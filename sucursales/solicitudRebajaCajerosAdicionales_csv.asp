<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.Buffer = TRUE
Response.ContentType = "text/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=cajeros_adicionales_" & Replace(Date(), "/", "-") & ".csv"

'Obtener parámetros de búsqueda
dim whereClause, fechaDesdeSol, fechaHastaSol
fechaDesdeSol = Request("fechaDesdeSol_rebaja")
fechaHastaSol = Request("fechaHastaSol_rebaja")

' Construcción de la consulta WHERE según perfil
whereClause = "WHERE s.activo = 1 and fecha_registro >= CAST('" & fechaDesdeSol & "' AS DATE) and fecha_registro <= DATEADD(day, 1, CAST('" & fechaHastaSol & "' AS DATE)) "

' Consulta con paginación
Dim sql, rs, datos, i
'sql = "SELECT " & _
'      "s.id_solicitud, s.id_sucursal, suc.suc_nombre, s.motivo_solicitud, " & _
'      "CASE s.motivo_solicitud " & _
'      "  WHEN 'licencia_medica' THEN 'Licencia Médica' " & _
'      "  WHEN 'vacaciones' THEN 'Vacaciones' " & _
'      "  WHEN 'reemplazo' THEN 'Reemplazo' " & _
'      "  WHEN 'flujo' THEN 'Flujo' " & _
'      "  ELSE s.motivo_solicitud " & _
'      "END AS motivo_solicitud_texto, " & _
'      "FORMAT(s.fecha_desde, 'dd/MM/yyyy') AS fecha_desde, " & _
'      "FORMAT(s.fecha_hasta, 'dd/MM/yyyy') AS fecha_hasta, " & _
'      "s.periodo, s.observaciones, " & _
'      "s.id_estado, e.nombre_estado, e.color_badge, " & _
'      "s.usuario_registro, FORMAT(s.fecha_registro, 'dd/MM/yyyy') AS fecha_registro " & _
'      "FROM SUC_solicitud_cajeros_adicionales s " & _
'      "LEFT JOIN SUC_sucursal suc ON s.id_sucursal = suc.id_sucursal " & _
'      "LEFT JOIN SUC_cat_estados_solicitud e ON s.id_estado = e.id_estado " & _
'      whereClause & _
'      "ORDER BY s.fecha_registro DESC "

    sql = "SELECT  " & _
      "s.id_solicitud_rebaja, s.id_sucursal, suc.suc_nombre, s.motivo_solicitud_rebaja,  " & _
      "mr.nombre_motivo_rebaja,  " & _
      "s.observaciones,  " & _
      "s.id_estado_rebaja, e.nombre_estado_rebaja, e.color_badge_rebaja,  " & _
      "FORMAT(s.fecha_desde, 'dd/MM/yyyy') AS fecha_desde, " & _
      "FORMAT(s.fecha_hasta, 'dd/MM/yyyy') AS fecha_hasta, " & _
      "s.periodo, " & _
      "s.usuario_registro, FORMAT(s.fecha_registro, 'dd/MM/yyyy') AS fecha_registro  " & _
      "FROM SUC_solicitud_cajeros_adicionales_rebaja s  " & _
      "LEFT JOIN SUC_sucursal suc ON s.id_sucursal = suc.id_sucursal  " & _
      "LEFT JOIN SUC_cat_estados_solicitud_rebaja e ON s.id_estado_rebaja = e.id_estado_rebaja  " & _
      "JOIN SUC_cat_motivo_solicitud_rebaja mr on mr.id_motivo_rebaja = s.motivo_solicitud_rebaja " & _
      whereClause & _
      "ORDER BY s.fecha_registro DESC  " 

'response.Write(sql)
'response.end

'Ejecutar consulta
on error resume next
set rs = DB.execute(sql)

if err.number <> 0 then
	Response.Write("Error al obtener los solicitudes: " & err.description)
	err.clear
else
Response.Write("id;Sucursal;Estado;Motivo;Desde;Hasta;Periodo;Observaciones;Fecha Registro;"& vbCrLf)
if not rs.EOF then
dim contador
contador = 0

do while not rs.EOF
Response.Write(rs("id_solicitud_rebaja") & ";" & _
rs("suc_nombre") & ";" & _
rs("nombre_estado_rebaja") & ";" & _
rs("nombre_motivo_rebaja") & ";" & _
rs("fecha_desde") & ";" & _
rs("fecha_hasta") & ";" & _
rs("periodo") & ";" & _
rs("observaciones") & ";" & _
rs("fecha_registro") & ";" & vbCrLf)

rs.MoveNext
loop
end if
end if

on error goto 0
DB.Close()
Set DB = Nothing
%>
