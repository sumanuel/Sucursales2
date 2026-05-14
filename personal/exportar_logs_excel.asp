<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.Buffer = TRUE
Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition", "attachment; filename=reporte_logs_" & Replace(Date(), "/", "-") & ".xls"

'Obtener parámetros de búsqueda
dim fechaDesde, fechaHasta, usuario, perfil, funcionalidad, tipoAccion
fechaDesde = trim(request("fecha_desde"))
fechaHasta = trim(request("fecha_hasta"))
usuario = trim(request("usuario"))
perfil = trim(request("perfil"))
funcionalidad = trim(request("funcionalidad"))
tipoAccion = trim(request("tipo_accion"))

'Construir la consulta al stored procedure
dim sql, rsLogs, rsLogsDetalle
sql = "EXEC dbo.SCSS_obtener_reporte_log "

'Agregar parámetros solo si tienen valor
if fechaDesde <> "" then
	sql = sql & "@fecha_desde = '" & fechaDesde & "', "
else
	sql = sql & "@fecha_desde = NULL, "
end if

if fechaHasta <> "" then
	sql = sql & "@fecha_hasta = '" & fechaHasta & "', "
else
	sql = sql & "@fecha_hasta = NULL, "
end if

if usuario <> "" then
	sql = sql & "@usuario = '" & Replace(usuario, "'", "''") & "', "
else
	sql = sql & "@usuario = NULL, "
end if

if perfil <> "" then
	sql = sql & "@perfil = '" & Replace(perfil, "'", "''") & "', "
else
	sql = sql & "@perfil = NULL, "
end if

if funcionalidad <> "" then
	sql = sql & "@funcionalidad = '" & Replace(funcionalidad, "'", "''") & "', "
else
	sql = sql & "@funcionalidad = NULL, "
end if

if tipoAccion <> "" then
	sql = sql & "@tipo_accion = '" & Replace(tipoAccion, "'", "''") & "'"
else
	sql = sql & "@tipo_accion = NULL"
end if

'Ejecutar consulta
on error resume next
set rsLogs = DB.execute(sql).NextRecordset

if err.number <> 0 then
	Response.Write("Error al obtener los logs: " & err.description)
	err.clear
else
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Reporte de Logs</title>
	<style>
		table {
			border-collapse: collapse;
			width: 100%;
		}
		th {
			background-color: #4CAF50;
			color: white;
			font-weight: bold;
			padding: 8px;
			text-align: left;
			border: 1px solid #ddd;
		}
		td {
			padding: 8px;
			border: 1px solid #ddd;
		}
		tr:nth-child(even) {
			background-color: #f2f2f2;
		}
		.titulo {
			font-size: 18px;
			font-weight: bold;
			margin-bottom: 10px;
		}
		.filtros {
			font-size: 12px;
			margin-bottom: 15px;
			color: #666;
		}
	</style>
</head>
<body>
	<div class="titulo">Reporte de Logs de Eventos</div>
	<div class="filtros">
		<strong>Filtros aplicados:</strong><br/>
		<% if fechaDesde <> "" then Response.Write("Fecha Desde: " & fechaDesde & " | ") end if %>
		<% if fechaHasta <> "" then Response.Write("Fecha Hasta: " & fechaHasta & " | ") end if %>
		<% if usuario <> "" then Response.Write("Usuario: " & usuario & " | ") end if %>
		<% if perfil <> "" then Response.Write("Perfil: " & perfil & " | ") end if %>
		<% if funcionalidad <> "" then Response.Write("Funcionalidad: " & funcionalidad & " | ") end if %>
		<% if tipoAccion <> "" then Response.Write("Tipo Acción: " & tipoAccion) end if %>
		<% if fechaDesde = "" and fechaHasta = "" and usuario = "" and perfil = "" and funcionalidad = "" and tipoAccion = "" then %>
			Sin filtros (Todos los registros)
		<% end if %>
		<br/>
		<strong>Fecha de generación:</strong> <%=FormatDateTime(Now(), 1)%> - <%=FormatDateTime(Now(), 4)%>
	</div>
	
	<table>
		<thead>
			<tr>
				<th>#</th>
				<th>ID Registro</th>
				<th>Usuario</th>
				<th>Perfil</th>
				<th>Funcionalidad</th>
				<th>Tipo Acción</th>
				<th>Fecha</th>
				<th>Hora</th>
			</tr>
		</thead>
		<tbody>
			<%
			if not rsLogs.EOF then
				dim contador
				contador = 0
				
				do while not rsLogs.EOF
					contador = contador + 1
					dim idRegistroReg, usuarioReg, perfilReg, funcionalidadReg, tipoAccionReg, fechaReg, horaReg
					
					idRegistroReg = ""
					if not IsNull(rsLogs("id_registro")) then
						idRegistroReg = rsLogs("id_registro")
					end if
					usuarioReg = rsLogs("usuario")
					perfilReg = rsLogs("perfil")
					funcionalidadReg = rsLogs("funcionalidad")
					tipoAccionReg = rsLogs("tipo_accion")
					fechaReg = rsLogs("fecha")
					horaReg = rsLogs("hora")
			%>
			<tr>
				<td><%=contador%></td>
				<td><%=idRegistroReg%></td>
				<td><%=Server.HTMLEncode(usuarioReg)%></td>
				<td><%=Server.HTMLEncode(perfilReg)%></td>
				<td><%=Server.HTMLEncode(funcionalidadReg)%></td>
				<td><%=Server.HTMLEncode(tipoAccionReg)%></td>
				<td><%=FormatDateTime(fechaReg, 2)%></td>
				<td><%=FormatDateTime(horaReg, 4)%></td>
			</tr>
			<%
					rsLogs.MoveNext
				loop
			%>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="8" style="text-align: right; font-weight: bold; background-color: #e8e8e8;">
					Total de registros: <%=contador%>
				</td>
			</tr>
		</tfoot>
			<%
			else
			%>
			<tr>
				<td colspan="8" style="text-align: center; color: #999;">
					No se encontraron registros con los filtros seleccionados
				</td>
			</tr>
			<%
			end if
			
			rsLogs.Close
			set rsLogs = nothing
			%>
		</tbody>
	</table>
</body>
</html>
<%
end if

on error goto 0
DB.Close()
Set DB = Nothing
%>
