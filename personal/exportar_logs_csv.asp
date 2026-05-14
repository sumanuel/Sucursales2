<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<% Response.Buffer = TRUE Response.CodePage = 65001 Response.ContentType =
"text/csv" Response.Charset = "utf-8" Response.AddHeader "Content-Disposition",
"attachment; filename=reporte_logs_" & Right("0" & Day(Date()), 2) & "-" &
Right("0" & Month(Date()), 2) & "-" & Year(Date()) & ".csv" Dim fechaDesde,
fechaHasta, usuario, perfil, funcionalidad, tipoAccion Dim sql, rsLogs
fechaDesde = Trim(Request("fecha_desde")) fechaHasta =
Trim(Request("fecha_hasta")) usuario = Trim(Request("usuario")) perfil =
Trim(Request("perfil")) funcionalidad = Trim(Request("funcionalidad"))
tipoAccion = Trim(Request("tipo_accion")) sql = "EXEC
dbo.SCSS_obtener_reporte_log " If fechaDesde <> "" Then sql = sql &
"@fecha_desde = '" & fechaDesde & "', " Else sql = sql & "@fecha_desde = NULL, "
End If If fechaHasta <> "" Then sql = sql & "@fecha_hasta = '" & fechaHasta &
"', " Else sql = sql & "@fecha_hasta = NULL, " End If If usuario <> "" Then sql
= sql & "@usuario = '" & Replace(usuario, "'", "''") & "', " Else sql = sql &
"@usuario = NULL, " End If If perfil <> "" Then sql = sql & "@perfil = '" &
Replace(perfil, "'", "''") & "', " Else sql = sql & "@perfil = NULL, " End If If
funcionalidad <> "" Then sql = sql & "@funcionalidad = '" &
Replace(funcionalidad, "'", "''") & "', " Else sql = sql & "@funcionalidad =
NULL, " End If If tipoAccion <> "" Then sql = sql & "@tipo_accion = '" &
Replace(tipoAccion, "'", "''") & "'" Else sql = sql & "@tipo_accion = NULL" End
If sql = sql & ", @page = 1, @page_size = 1000000" On Error Resume Next Set
rsLogs = DB.Execute(sql).NextRecordset If Err.Number <> 0 Then
Response.Write("Error al obtener los logs: " & Err.Description) Err.Clear Else
Dim contador, idRegistroReg, horaReg Response.Write("#;ID
Registro;Usuario;Perfil;Funcionalidad;Tipo Accion;Fecha;Hora" & vbCrLf) If Not
rsLogs.EOF Then contador = 0 Do While Not rsLogs.EOF contador = contador + 1
idRegistroReg = "" If Not IsNull(rsLogs("id_registro")) Then idRegistroReg =
rsLogs("id_registro") End If horaReg = rsLogs("hora") Response.Write(contador &
";" & _ idRegistroReg & ";" & _ rsLogs("usuario") & ";" & _ rsLogs("perfil") &
";" & _ rsLogs("funcionalidad") & ";" & _ rsLogs("tipo_accion") & ";" & _
FormatDateTime(rsLogs("fecha"), 2) & ";" & _ horaReg & vbCrLf) rsLogs.MoveNext
Loop End If End If On Error GoTo 0 DB.Close() Set DB = Nothing %>
