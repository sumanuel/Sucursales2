<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<!--#include file="freeASPUpload.asp"-->

<%
Option Explicit
Response.Expires = -1
Response.Charset = "utf-8"
Server.ScriptTimeout = 600

Dim uploadsDirVar
Dim fsUploadDir
Dim upload
Dim nombreArchivo
Dim fileKey
Dim archivoPath
Dim comentarioGeneral
Dim fs
Dim archivoTexto
Dim contenidoLinea
Dim columnas
Dim usuarioLog
Dim lineaActual
Dim insertados
Dim errores
Dim totalMensajes
Dim mensajes()
Dim resultadoCarga
Dim extensionArchivo
Dim cmd
Dim rsResultado
Dim resultadoSp
Dim mensajeSp
Dim rutEva
Dim nombreEva
Dim sucursalEva
Dim empresaEva
Dim fechaDesdeEva
Dim fechaHastaEva

uploadsDirVar = "F:\APP_SC\sucursales2\upload"

Set fsUploadDir = Server.CreateObject("Scripting.FileSystemObject")
If Not fsUploadDir.FolderExists(uploadsDirVar) Then
    uploadsDirVar = Server.MapPath("../upload")
End If
Set fsUploadDir = Nothing

Function ObtenerUsuarioLog()
    Dim idUsrWin
    Dim partesUsuario

    idUsrWin = Request.ServerVariables("LOGON_USER")
    If idUsrWin <> "" Then
        partesUsuario = Split(idUsrWin, "\")
        If UBound(partesUsuario) >= 1 Then
            ObtenerUsuarioLog = partesUsuario(1)
        Else
            ObtenerUsuarioLog = idUsrWin
        End If
    ElseIf Session("nombre_usuario") <> "" Then
        ObtenerUsuarioLog = Session("nombre_usuario")
    ElseIf Session("id_usuario") <> "" Then
        ObtenerUsuarioLog = Session("id_usuario")
    Else
        ObtenerUsuarioLog = ""
    End If
End Function

Function JsSafe(valor)
    If IsNull(valor) Then
        valor = ""
    End If

    valor = CStr(valor)
    valor = Replace(valor, "\", "\\")
    valor = Replace(valor, "'", "\'")
    valor = Replace(valor, vbCrLf, " ")
    valor = Replace(valor, vbCr, " ")
    valor = Replace(valor, vbLf, " ")
    JsSafe = valor
End Function

Function CsvCampo(valor)
    valor = Trim(CStr(valor))
    If Len(valor) >= 2 Then
        If Left(valor, 1) = Chr(34) And Right(valor, 1) = Chr(34) Then
            valor = Mid(valor, 2, Len(valor) - 2)
        End If
    End If
    CsvCampo = Trim(valor)
End Function

Function ParsearFechaCsv(valorFecha)
    Dim partesFecha

    valorFecha = Trim(CStr(valorFecha))
    If valorFecha = "" Then
        ParsearFechaCsv = Null
        Exit Function
    End If

    partesFecha = Split(valorFecha, "-")
    If UBound(partesFecha) <> 2 Then
        Err.Raise vbObjectError + 1000, "ParsearFechaCsv", "Fecha invalida: " & valorFecha
    End If

    ParsearFechaCsv = DateSerial(CInt(partesFecha(2)), CInt(partesFecha(1)), CInt(partesFecha(0)))
End Function

Sub ImprimirResultado(resultado, insertados, errores, mensajes)
    Dim i

    Response.Write "<html><body><script type=""text/javascript"">"
    Response.Write "if(window.parent && window.parent.onEvaluacionCajerosCargaCompleta){window.parent.onEvaluacionCajerosCargaCompleta({"
    Response.Write "resultado:'" & JsSafe(resultado) & "',"
    Response.Write "insertados:" & insertados & ","
    Response.Write "errores:" & errores & ","
    Response.Write "mensajes:["

    For i = 0 To UBound(mensajes)
        If i > 0 Then
            Response.Write ","
        End If
        Response.Write "{texto:'" & JsSafe(mensajes(i)) & "'}"
    Next

    Response.Write "]});}"
    Response.Write "</script></body></html>"
End Sub

ReDim mensajes(0)
mensajes(0) = ""
totalMensajes = -1
insertados = 0
errores = 0
resultadoCarga = "OK"
usuarioLog = ObtenerUsuarioLog()

If Request.ServerVariables("REQUEST_METHOD") <> "POST" Then
    ReDim mensajes(0)
    mensajes(0) = "Solicitud invalida."
    Call ImprimirResultado("ERROR", 0, 1, mensajes)
    Response.End
End If

comentarioGeneral = ""
nombreArchivo = ""
archivoPath = ""

On Error Resume Next
Set upload = New FreeASPUpload
upload.Save uploadsDirVar
If Err.Number <> 0 Then
    ReDim mensajes(0)
    mensajes(0) = "No fue posible subir el archivo: " & Err.Description
    Call ImprimirResultado("ERROR", 0, 1, mensajes)
    Response.End
End If
On Error GoTo 0

comentarioGeneral = Trim(upload.Form("eva_com"))

For Each fileKey In upload.UploadedFiles.Keys
    nombreArchivo = upload.UploadedFiles(fileKey).FileName
    archivoPath = upload.UploadedFiles(fileKey).Path
    Exit For
Next

If nombreArchivo = "" Then
    ReDim mensajes(0)
    mensajes(0) = "Debe seleccionar un archivo CSV."
    Call ImprimirResultado("ERROR", 0, 1, mensajes)
    Response.End
End If

extensionArchivo = LCase(Mid(nombreArchivo, InStrRev(nombreArchivo, ".") + 1))
If extensionArchivo <> "csv" Then
    ReDim mensajes(0)
    mensajes(0) = "El archivo debe tener extension .csv."
    Call ImprimirResultado("ERROR", 0, 1, mensajes)
    Response.End
End If

Set fs = Server.CreateObject("Scripting.FileSystemObject")
If Not fs.FileExists(archivoPath) Then
    ReDim mensajes(0)
    mensajes(0) = "No se encontro el archivo cargado para procesar."
    Call ImprimirResultado("ERROR", 0, 1, mensajes)
    Response.End
End If

Set archivoTexto = fs.OpenTextFile(archivoPath, 1, False)
lineaActual = 0

Do Until archivoTexto.AtEndOfStream
    contenidoLinea = Trim(archivoTexto.ReadLine)
    lineaActual = lineaActual + 1

    If contenidoLinea <> "" Then
        columnas = Split(contenidoLinea, ";")

        If UBound(columnas) < 5 Then
            errores = errores + 1
            totalMensajes = totalMensajes + 1
            ReDim Preserve mensajes(totalMensajes)
            mensajes(totalMensajes) = "Linea " & lineaActual & ": formato invalido. Debe contener 6 columnas separadas por ';'."
        Else
            On Error Resume Next
            rutEva = CsvCampo(columnas(0))
            nombreEva = CsvCampo(columnas(1))
            sucursalEva = CLng(CsvCampo(columnas(2)))
            empresaEva = CsvCampo(columnas(3))
            fechaDesdeEva = ParsearFechaCsv(CsvCampo(columnas(4)))
            fechaHastaEva = ParsearFechaCsv(CsvCampo(columnas(5)))

            If Err.Number <> 0 Then
                errores = errores + 1
                totalMensajes = totalMensajes + 1
                ReDim Preserve mensajes(totalMensajes)
                mensajes(totalMensajes) = "Linea " & lineaActual & ": " & Err.Description
                Err.Clear
            ElseIf rutEva = "" Or nombreEva = "" Or empresaEva = "" Then
                errores = errores + 1
                totalMensajes = totalMensajes + 1
                ReDim Preserve mensajes(totalMensajes)
                mensajes(totalMensajes) = "Linea " & lineaActual & ": hay campos obligatorios vacios."
            Else
                Set cmd = Server.CreateObject("ADODB.Command")
                Set cmd.ActiveConnection = db
                cmd.NamedParameters = True
                cmd.CommandType = 4
                cmd.CommandText = "SP_SUC_insertar_eva_cajero"
                cmd.Parameters.Append cmd.CreateParameter("@EVA_RUT", 200, 1, 10, rutEva)
                cmd.Parameters.Append cmd.CreateParameter("@EVA_NOMBRE", 200, 1, 150, nombreEva)
                cmd.Parameters.Append cmd.CreateParameter("@EVA_SUC", 3, 1, , sucursalEva)
                cmd.Parameters.Append cmd.CreateParameter("@EVA_EMP", 200, 1, 150, empresaEva)
                cmd.Parameters.Append cmd.CreateParameter("@EVA_FCH_DES", 7, 1, , fechaDesdeEva)
                cmd.Parameters.Append cmd.CreateParameter("@EVA_FCH_HAS", 7, 1, , fechaHastaEva)
                cmd.Parameters.Append cmd.CreateParameter("@EVA_COM", 200, 1, 250, comentarioGeneral)
                cmd.Parameters.Append cmd.CreateParameter("@EVA_EST", 2, 1, , 1)
                cmd.Parameters.Append cmd.CreateParameter("@EVA_USR", 200, 1, 50, usuarioLog)

                Set rsResultado = Nothing
                On Error Resume Next
                Set rsResultado = cmd.Execute

                If Err.Number <> 0 Then
                    errores = errores + 1
                    totalMensajes = totalMensajes + 1
                    ReDim Preserve mensajes(totalMensajes)
                    mensajes(totalMensajes) = "Linea " & lineaActual & ": error al ejecutar SP_SUC_insertar_eva_cajero - " & Err.Description
                    Err.Clear
                Else
                    resultadoSp = "OK"
                    mensajeSp = ""

                    If IsObject(rsResultado) Then
                        If Not rsResultado.EOF Then
                            On Error Resume Next
                            resultadoSp = Trim(CStr(rsResultado("resultado") & ""))
                            mensajeSp = Trim(CStr(rsResultado("mensaje") & ""))
                            On Error GoTo 0
                        End If
                    End If

                    If resultadoSp <> "" And UCase(resultadoSp) <> "OK" Then
                        errores = errores + 1
                        totalMensajes = totalMensajes + 1
                        ReDim Preserve mensajes(totalMensajes)
                        If mensajeSp = "" Then
                            mensajeSp = "El procedimiento almacenado devolvio un resultado distinto de OK."
                        End If
                        mensajes(totalMensajes) = "Linea " & lineaActual & ": " & mensajeSp
                    Else
                        insertados = insertados + 1
                        totalMensajes = totalMensajes + 1
                        ReDim Preserve mensajes(totalMensajes)
                        mensajes(totalMensajes) = "Linea " & lineaActual & ": registro cargado correctamente para " & rutEva & "."
                    End If
                End If

                On Error GoTo 0

                If IsObject(rsResultado) Then
                    If rsResultado.State = 1 Then
                        rsResultado.Close
                    End If
                    Set rsResultado = Nothing
                End If
                Set cmd = Nothing
            End If

            On Error GoTo 0
        End If
    End If
Loop

archivoTexto.Close
Set archivoTexto = Nothing

On Error Resume Next
If fs.FileExists(archivoPath) Then
    fs.DeleteFile archivoPath, True
End If
On Error GoTo 0
Set fs = Nothing

If totalMensajes = -1 Then
    ReDim mensajes(0)
    mensajes(0) = "El archivo no contiene registros para procesar."
    errores = 1
End If

If errores > 0 And insertados = 0 Then
    resultadoCarga = "ERROR"
End If

Call ImprimirResultado(resultadoCarga, insertados, errores, mensajes)
%>
