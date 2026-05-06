<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.Expires = -1
Response.ContentType = "application/json"
Server.ScriptTimeout = 600

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
Dim pesoArchivo
Dim rsDup
Dim sqlDup

archivoPath = Server.MapPath("../upload/evaluacion_cajeros.csv")
comentarioGeneral = Trim(Request("eva_com"))
insertados = 0
errores = 0
totalMensajes = -1
resultadoCarga = "OK"
pesoArchivo = 0

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

Function JsonSafe(valor)
    If IsNull(valor) Then
        valor = ""
    End If

    valor = CStr(valor)
    valor = Replace(valor, "\", "\\")
    valor = Replace(valor, Chr(34), Chr(92) & Chr(34))
    valor = Replace(valor, vbCrLf, " ")
    valor = Replace(valor, vbCr, " ")
    valor = Replace(valor, vbLf, " ")
    JsonSafe = valor
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

Function FormatearPeso(bytes)
    If IsNull(bytes) Or bytes = "" Then
        FormatearPeso = ""
    ElseIf CLng(bytes) >= 1048576 Then
        FormatearPeso = Replace(FormatNumber(CDbl(bytes) / 1048576, 2), ",", "") & " MB"
    ElseIf CLng(bytes) >= 1024 Then
        FormatearPeso = Replace(FormatNumber(CDbl(bytes) / 1024, 2), ",", "") & " KB"
    Else
        FormatearPeso = CStr(bytes) & " B"
    End If
End Function

Function SqlTexto(valor)
    SqlTexto = Replace(Trim(CStr(valor)), "'", "''")
End Function

Function SqlFecha(valorFecha)
    SqlFecha = Year(CDate(valorFecha)) & Right("0" & Month(CDate(valorFecha)), 2) & Right("0" & Day(CDate(valorFecha)), 2)
End Function

Sub ResponderJson(resultado, insertadosTotal, erroresTotal, mensajesLista, archivo, peso)
    Dim i
    Response.Write "{""resultado"":""" & JsonSafe(resultado) & """,""insertados"":" & insertadosTotal & ",""errores"":" & erroresTotal & ",""archivo"":""" & JsonSafe(archivo) & """,""peso"":""" & JsonSafe(peso) & """,""mensajes"":"
    Response.Write "["
    For i = 0 To UBound(mensajesLista)
        If i > 0 Then
            Response.Write ","
        End If
        Response.Write "{""texto"":""" & JsonSafe(mensajesLista(i)) & """}"
    Next
    Response.Write "]}"
End Sub

ReDim mensajes(0)
mensajes(0) = ""
usuarioLog = ObtenerUsuarioLog()

Set fs = Server.CreateObject("Scripting.FileSystemObject")
If Not fs.FileExists(archivoPath) Then
    ReDim mensajes(0)
    mensajes(0) = "No se encontro el archivo CSV cargado para procesar."
    Call ResponderJson("ERROR", 0, 1, mensajes, "evaluacion_cajeros.csv", "")
    Response.End
End If

On Error Resume Next
pesoArchivo = fs.GetFile(archivoPath).Size
Set archivoTexto = fs.OpenTextFile(archivoPath, 1, False)
If Err.Number <> 0 Then
    ReDim mensajes(0)
    mensajes(0) = "No fue posible abrir el archivo cargado: " & Err.Description
    Err.Clear
    Call ResponderJson("ERROR", 0, 1, mensajes, "evaluacion_cajeros.csv", "")
    Response.End
End If
On Error GoTo 0
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
                sqlDup = "SELECT TOP 1 ID_EVA FROM dbo.SUC_CAP_EVA WHERE EVA_RUT = '" & SqlTexto(rutEva) & "' AND EVA_SUC = " & CLng(sucursalEva) & " AND EVA_EMP = '" & SqlTexto(empresaEva) & "' AND EVA_FCH_DES = '" & SqlFecha(fechaDesdeEva) & "' AND EVA_FCH_HAS = '" & SqlFecha(fechaHastaEva) & "'"
                Set rsDup = db.Execute(sqlDup)

                If Not rsDup.EOF Then
                    errores = errores + 1
                    totalMensajes = totalMensajes + 1
                    ReDim Preserve mensajes(totalMensajes)
                    mensajes(totalMensajes) = "Linea " & lineaActual & ": ya existe una evaluacion con los mismos datos para el cajero."
                Else
                    Set cmd = Server.CreateObject("ADODB.Command")
                    Set cmd.ActiveConnection = db
                    cmd.NamedParameters = True
                    cmd.CommandType = 4
                    cmd.CommandText = "SP_SUC_insertar_ges_eva_cajero"
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
                        mensajes(totalMensajes) = "Linea " & lineaActual & ": error al ejecutar SP_SUC_insertar_ges_eva_cajero - " & Err.Description
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

                If IsObject(rsDup) Then
                    If rsDup.State = 1 Then
                        rsDup.Close
                    End If
                    Set rsDup = Nothing
                End If
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

Call ResponderJson(resultadoCarga, insertados, errores, mensajes, "evaluacion_cajeros.csv", FormatearPeso(pesoArchivo))
%>