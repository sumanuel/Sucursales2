$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$mainPathLocal = 'd:\Sucursales2\personal\evaluacion_cajeros.asp'
$mainPathRemote = '\\Vmpoperapp01\APP_SC\sucursales2\personal\evaluacion_cajeros.asp'
$mainContent = [System.IO.File]::ReadAllText($mainPathLocal)
$mainContent = $mainContent.Replace("Â¿Seguro que desea eliminar la evaluacion seleccionada?", "Seguro que desea eliminar la evaluacion seleccionada?")
[System.IO.File]::WriteAllText($mainPathLocal, $mainContent, $utf8NoBom)
[System.IO.File]::WriteAllText($mainPathRemote, $mainContent, $utf8NoBom)

$procesar = @'
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
'@

$guardarEdicion = @'
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Expires = -1

Dim idEva
Dim fechaDesdeTxt
Dim fechaHastaTxt
Dim fechaDesde
Dim fechaHasta
Dim usuarioLog
Dim sqlBase
Dim rsBase
Dim sqlDup
Dim rsDup
Dim sqlUpdate

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

Function ParsearFechaISO(valorFecha)
  Dim partes
  valorFecha = Trim(CStr(valorFecha))
  If valorFecha = "" Then
    ParsearFechaISO = Null
    Exit Function
  End If
  partes = Split(valorFecha, "-")
  If UBound(partes) <> 2 Then
    Err.Raise vbObjectError + 2000, "ParsearFechaISO", "Fecha invalida: " & valorFecha
  End If
  ParsearFechaISO = DateSerial(CInt(partes(0)), CInt(partes(1)), CInt(partes(2)))
End Function

Function SqlTexto(valor)
  SqlTexto = Replace(Trim(CStr(valor)), "'", "''")
End Function

Function SqlFecha(valorFecha)
  SqlFecha = Year(CDate(valorFecha)) & Right("0" & Month(CDate(valorFecha)), 2) & Right("0" & Day(CDate(valorFecha)), 2)
End Function

idEva = 0
If Trim(Request("id_eva") & "") <> "" Then
  idEva = CLng(Request("id_eva"))
End If
fechaDesdeTxt = Trim(Request("eva_fch_des") & "")
fechaHastaTxt = Trim(Request("eva_fch_has") & "")
usuarioLog = ObtenerUsuarioLog()

On Error Resume Next
fechaDesde = ParsearFechaISO(fechaDesdeTxt)
fechaHasta = ParsearFechaISO(fechaHastaTxt)
If Err.Number <> 0 Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & JsonSafe(Err.Description) & """}"
  Response.End
End If
On Error GoTo 0

sqlBase = "SELECT TOP 1 EVA_RUT, EVA_SUC, EVA_EMP FROM dbo.SUC_CAP_EVA WHERE ID_EVA = " & idEva
Set rsBase = db.Execute(sqlBase)
If rsBase.EOF Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""No existe la evaluacion indicada.""}"
  Response.End
End If

sqlDup = "SELECT TOP 1 ID_EVA FROM dbo.SUC_CAP_EVA WHERE ID_EVA <> " & idEva & " AND EVA_RUT = '" & SqlTexto(rsBase("EVA_RUT")) & "' AND EVA_SUC = " & CLng(rsBase("EVA_SUC")) & " AND EVA_EMP = '" & SqlTexto(rsBase("EVA_EMP")) & "' AND EVA_FCH_DES = '" & SqlFecha(fechaDesde) & "' AND EVA_FCH_HAS = '" & SqlFecha(fechaHasta) & "'"
Set rsDup = db.Execute(sqlDup)
If Not rsDup.EOF Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""Ya existe otra evaluacion con los mismos datos para el cajero.""}"
  Response.End
End If

sqlUpdate = "UPDATE dbo.SUC_CAP_EVA SET EVA_FCH_DES = '" & SqlFecha(fechaDesde) & "', EVA_FCH_HAS = '" & SqlFecha(fechaHasta) & "', EVA_USR = '" & SqlTexto(usuarioLog) & "', EVA_FCH = GETDATE() WHERE ID_EVA = " & idEva
Call db.Execute(sqlUpdate)

If IsObject(rsDup) Then
  If rsDup.State = 1 Then
    rsDup.Close
  End If
  Set rsDup = Nothing
End If
If IsObject(rsBase) Then
  If rsBase.State = 1 Then
    rsBase.Close
  End If
  Set rsBase = Nothing
End If

Response.Write "{""resultado"":""OK"",""mensaje"":""Registro actualizado correctamente.""",""id_eva"":" & idEva & "}"
%>
'@

$eliminar = @'
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Expires = -1

Dim idEva
Dim usuarioLog
Dim sqlExiste
Dim rsExiste
Dim sqlUpdate

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

Function SqlTexto(valor)
  SqlTexto = Replace(Trim(CStr(valor)), "'", "''")
End Function

idEva = 0
If Trim(Request("id_eva") & "") <> "" Then
  idEva = CLng(Request("id_eva"))
End If
usuarioLog = ObtenerUsuarioLog()

sqlExiste = "SELECT TOP 1 ID_EVA FROM dbo.SUC_CAP_EVA WHERE ID_EVA = " & idEva
Set rsExiste = db.Execute(sqlExiste)
If rsExiste.EOF Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""No existe la evaluacion indicada.""}"
  Response.End
End If

sqlUpdate = "UPDATE dbo.SUC_CAP_EVA SET EVA_EST = 0, EVA_USR = '" & SqlTexto(usuarioLog) & "', EVA_FCH = GETDATE() WHERE ID_EVA = " & idEva
Call db.Execute(sqlUpdate)

If rsExiste.State = 1 Then
  rsExiste.Close
End If
Set rsExiste = Nothing

Response.Write "{""resultado"":""OK"",""mensaje"":""Registro eliminado correctamente.""",""id_eva"":" & idEva & "}"
%>
'@

$spInsert = @"
IF OBJECT_ID('dbo.SP_SUC_insertar_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_insertar_eva_cajero;
GO

CREATE PROCEDURE dbo.SP_SUC_insertar_eva_cajero
    @EVA_RUT     VARCHAR(10),
    @EVA_NOMBRE  VARCHAR(150),
    @EVA_SUC     INT,
    @EVA_EMP     VARCHAR(150),
    @EVA_FCH_DES DATE,
    @EVA_FCH_HAS DATE,
    @EVA_COM     VARCHAR(250) = NULL,
    @EVA_EST     SMALLINT = 1,
    @EVA_USR     VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @EVA_RUT = LTRIM(RTRIM(ISNULL(@EVA_RUT, '')));
        SET @EVA_NOMBRE = LTRIM(RTRIM(ISNULL(@EVA_NOMBRE, '')));
        SET @EVA_EMP = LTRIM(RTRIM(ISNULL(@EVA_EMP, '')));
        SET @EVA_COM = LTRIM(RTRIM(ISNULL(@EVA_COM, '')));
        SET @EVA_USR = LTRIM(RTRIM(ISNULL(@EVA_USR, '')));

        IF @EVA_RUT = ''
        BEGIN
            SELECT 'ERROR' AS resultado, 'El rut del cajero es obligatorio.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_NOMBRE = ''
        BEGIN
            SELECT 'ERROR' AS resultado, 'El nombre del cajero es obligatorio.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_SUC IS NULL OR @EVA_SUC <= 0
        BEGIN
            SELECT 'ERROR' AS resultado, 'La sucursal es obligatoria y debe ser mayor a cero.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_EMP = ''
        BEGIN
            SELECT 'ERROR' AS resultado, 'La empresa es obligatoria.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_FCH_DES IS NULL OR @EVA_FCH_HAS IS NULL
        BEGIN
            SELECT 'ERROR' AS resultado, 'Las fechas desde y hasta son obligatorias.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_FCH_DES > @EVA_FCH_HAS
        BEGIN
            SELECT 'ERROR' AS resultado, 'La fecha desde no puede ser mayor que la fecha hasta.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_RUT) > 10
        BEGIN
            SELECT 'ERROR' AS resultado, 'El rut excede el largo permitido de la columna EVA_RUT (10).' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_NOMBRE) > 100
        BEGIN
            SELECT 'ERROR' AS resultado, 'El nombre excede el largo permitido de la columna EVA_NOMBRE (100). Ajuste la tabla o reduzca el valor.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_EMP) > 150
        BEGIN
            SELECT 'ERROR' AS resultado, 'La empresa excede el largo permitido de la columna EVA_EMP (150).' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_COM) > 250
        BEGIN
            SELECT 'ERROR' AS resultado, 'El comentario excede el largo permitido de la columna EVA_COM (250).' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_USR) > 50
        BEGIN
            SELECT 'ERROR' AS resultado, 'El usuario excede el largo permitido de la columna EVA_USR (50).' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.SUC_CAP_EVA
            WHERE EVA_RUT = @EVA_RUT
              AND EVA_SUC = @EVA_SUC
              AND EVA_EMP = @EVA_EMP
              AND EVA_FCH_DES = @EVA_FCH_DES
              AND EVA_FCH_HAS = @EVA_FCH_HAS
        )
        BEGIN
            SELECT 'ERROR' AS resultado, 'Ya existe una evaluacion con los mismos datos para el cajero.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        INSERT INTO dbo.SUC_CAP_EVA
        (
            EVA_RUT,
            EVA_NOMBRE,
            EVA_SUC,
            EVA_EMP,
            EVA_FCH_DES,
            EVA_FCH_HAS,
            EVA_COM,
            EVA_EST,
            EVA_USR,
            EVA_FCH
        )
        VALUES
        (
            @EVA_RUT,
            @EVA_NOMBRE,
            @EVA_SUC,
            @EVA_EMP,
            @EVA_FCH_DES,
            @EVA_FCH_HAS,
            NULLIF(@EVA_COM, ''),
            ISNULL(@EVA_EST, 1),
            NULLIF(@EVA_USR, ''),
            GETDATE()
        );

        SELECT 'OK' AS resultado, 'Registro insertado correctamente.' AS mensaje, CAST(SCOPE_IDENTITY() AS INT) AS id_eva;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS resultado, ERROR_MESSAGE() AS mensaje, CAST(NULL AS INT) AS id_eva;
    END CATCH
END;
GO
"@

$spUpdate = @"
IF OBJECT_ID('dbo.SP_SUC_actualizar_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_actualizar_eva_cajero;
GO

CREATE PROCEDURE dbo.SP_SUC_actualizar_eva_cajero
    @ID_EVA      INT,
    @EVA_FCH_DES DATE,
    @EVA_FCH_HAS DATE,
    @EVA_USR     VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @EVA_USR = LTRIM(RTRIM(ISNULL(@EVA_USR, '')));

        IF @ID_EVA IS NULL OR @ID_EVA <= 0
        BEGIN
            SELECT 'ERROR' AS resultado, 'El identificador de la evaluacion es obligatorio.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM dbo.SUC_CAP_EVA WHERE ID_EVA = @ID_EVA)
        BEGIN
            SELECT 'ERROR' AS resultado, 'No existe la evaluacion indicada.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_FCH_DES IS NULL OR @EVA_FCH_HAS IS NULL
        BEGIN
            SELECT 'ERROR' AS resultado, 'Las fechas desde y hasta son obligatorias.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_FCH_DES > @EVA_FCH_HAS
        BEGIN
            SELECT 'ERROR' AS resultado, 'La fecha desde no puede ser mayor que la fecha hasta.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_USR) > 50
        BEGIN
            SELECT 'ERROR' AS resultado, 'El usuario excede el largo permitido de la columna EVA_USR (50).' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.SUC_CAP_EVA A
            INNER JOIN dbo.SUC_CAP_EVA B
                ON B.ID_EVA = @ID_EVA
            WHERE A.ID_EVA <> @ID_EVA
              AND A.EVA_RUT = B.EVA_RUT
              AND A.EVA_SUC = B.EVA_SUC
              AND A.EVA_EMP = B.EVA_EMP
              AND A.EVA_FCH_DES = @EVA_FCH_DES
              AND A.EVA_FCH_HAS = @EVA_FCH_HAS
        )
        BEGIN
            SELECT 'ERROR' AS resultado, 'Ya existe otra evaluacion con los mismos datos para el cajero.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        UPDATE dbo.SUC_CAP_EVA
        SET EVA_FCH_DES = @EVA_FCH_DES,
            EVA_FCH_HAS = @EVA_FCH_HAS,
            EVA_USR = CASE WHEN @EVA_USR = '' THEN EVA_USR ELSE @EVA_USR END,
            EVA_FCH = GETDATE()
        WHERE ID_EVA = @ID_EVA;

        SELECT 'OK' AS resultado, 'Registro actualizado correctamente.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS resultado, ERROR_MESSAGE() AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END CATCH
END;
GO
"@

[System.IO.File]::WriteAllText('d:\Sucursales2\personal\evaluacion_cajeros_procesar.asp', $procesar, $utf8NoBom)
[System.IO.File]::WriteAllText('\\Vmpoperapp01\APP_SC\sucursales2\personal\evaluacion_cajeros_procesar.asp', $procesar, $utf8NoBom)
[System.IO.File]::WriteAllText('d:\Sucursales2\personal\evaluacion_cajeros_guardar_edicion.asp', $guardarEdicion, $utf8NoBom)
[System.IO.File]::WriteAllText('\\Vmpoperapp01\APP_SC\sucursales2\personal\evaluacion_cajeros_guardar_edicion.asp', $guardarEdicion, $utf8NoBom)
[System.IO.File]::WriteAllText('d:\Sucursales2\personal\evaluacion_cajeros_eliminar.asp', $eliminar, $utf8NoBom)
[System.IO.File]::WriteAllText('\\Vmpoperapp01\APP_SC\sucursales2\personal\evaluacion_cajeros_eliminar.asp', $eliminar, $utf8NoBom)
[System.IO.File]::WriteAllText('d:\Sucursales2\SP_SUC_insertar_eva_cajero.sql', $spInsert, $utf8NoBom)
[System.IO.File]::WriteAllText('d:\Sucursales2\SP_SUC_actualizar_eva_cajero.sql', $spUpdate, $utf8NoBom)
Write-Output 'OK'
