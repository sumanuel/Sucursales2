<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<% Response.Buffer = TRUE Response.CodePage = 65001 Response.ContentType =
"text/csv" Response.Charset = "utf-8" Response.AddHeader "Content-Disposition",
"attachment; filename=reporte_logs_" & Right("0" & Day(Date()), 2) & "-" &
Right("0" & Month(Date()), 2) & "-" & Year(Date()) & ".csv" 'Obtener parámetros
de búsqueda dim fechaDesde, fechaHasta, usuario, perfil, funcionalidad,
tipoAccion fechaDesde = trim(request("fecha_desde")) fechaHasta =
trim(request("fecha_hasta")) usuario = trim(request("usuario")) perfil =
trim(request("perfil")) funcionalidad = trim(request("funcionalidad"))
tipoAccion = trim(request("tipo_accion")) 'Construir la consulta al stored
procedure dim sql, rsLogs, rsLogsDetalle sql = "EXEC
dbo.SCSS_obtener_reporte_log " 'Agregar parámetros solo si tienen valor if
fechaDesde <> "" then sql = sql & "@fecha_desde = '" & fechaDesde & "', " else
sql = sql & "@fecha_desde = NULL, " end if if fechaHasta <> "" then sql = sql &
"@fecha_hasta = '" & fechaHasta & "', " else sql = sql & "@fecha_hasta = NULL, "
end if if usuario <> "" then sql = sql & "@usuario = '" & Replace(usuario, "'",
"''") & "', " else sql = sql & "@usuario = NULL, " end if if perfil <> "" then
sql = sql & "@perfil = '" & Replace(perfil, "'", "''") & "', " else sql = sql &
"@perfil = NULL, " end if if funcionalidad <> "" then sql = sql &
"@funcionalidad = '" & Replace(funcionalidad, "'", "''") & "', " else sql = sql
& "@funcionalidad = NULL, " end if if tipoAccion <> "" then sql = sql &
"@tipo_accion = '" & Replace(tipoAccion, "'", "''") & "'" else sql = sql &
"@tipo_accion = NULL" end if sql = sql & ", @page = 1, @page_size = 1000000"
'Ejecutar consulta on error resume next set rsLogs =
DB.execute(sql).NextRecordset if err.number <> 0 then Response.Write("Error al
obtener los logs: " & err.description) err.clear else
Response.Write("#;Usuario;Perfil;Funcionalidad;Tipo Accion;Fecha;Hora"& vbCrLf)
if not rsLogs.EOF then dim contador contador = 0 do while not rsLogs.EOF
contador = contador + 1 Response.Write(contador & ";" & _ rsLogs("usuario") &
";" & _ rsLogs("perfil") & ";" & _ rsLogs("funcionalidad") & ";" & _
rsLogs("tipo_accion") & ";" & _ FormatDateTime(rsLogs("fecha"), 2) & ";" & _
FormatDateTime(rsLogs("hora"), 4) & vbCrLf) rsLogs.MoveNext loop end if end if
on error goto 0 DB.Close() Set DB = Nothing %>
