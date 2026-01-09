<!--#include file="../funciones.asp"-->
<%idRegional = trim(request("idRegional"))
'response.write(idRegional)
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datosRegional"": ["
sql = ""
sql = sql & " select * "
sql = sql & " from suc_regionales where id_regional = '"&idRegional&"'"
set rs = db.execute(sql)
if not rs.eof then
	idRegional = trim(rs(0))
	nombreRegional = trim(rs(1))
	Response.Write "{"
	Response.Write "   ""idRegional"": """ & idRegional & """, "
	Response.Write "   ""nombreRegional"": """ & nombreRegional & """ "
	Response.Write "}"
end if
Response.Write "],"
	sql2 = ""  
	sql2 = sql2 & " and id_sucursal in "
	sql2 = sql2 & " (select id_sucursal "
	sql2 = sql2 & " from suc_sucursal "
	sql2 = sql2 & " where suc_estado = 1 "
	sql2 = sql2 & " and id_sucursal in "
	sql2 = sql2 & " (select id_sucursal "
	sql2 = sql2 & " from SUC_usuario_sucursal "
	sql2 = sql2 & " where id_usuario in( "
	sql2 = sql2 & " select id_usuario "
	sql2 = sql2 & " from SUC_zonales "
	sql2 = sql2 & " where id_regional_p = '"&idRegional&"' "
	sql2 = sql2 & " and estado_zonal = 1)))  "

	sql = ""
	sql = sql & "select "
	sql = sql & " (select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo_personal = 'Cajero' "
	sql = sql & " and tipo = 'titular' "&sql2&") as cajerostitulares, "
	sql = sql & " (select COUNT(*) " 
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo_personal = 'Cajero' "
	sql = sql & " and tipo = 'reemplazo' "&sql2&") as cajerosreemplazos, "
	sql = sql & " (select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo_personal = 'CAJERO ADICIONAL' "&sql2&") as cajerosadicionales, "
	sql = sql & " (select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo_personal in ('Cajero','CAJERO ADICIONAL') "
	sql = sql & " and asistencia = 'si' "&sql2&") as cajerospresentes, "
	sql = sql & " (select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo_personal in ('Cajero','CAJERO ADICIONAL') "
	sql = sql & " and asistencia = 'no' "&sql2&") as cajerosausentes, "
	sql = sql & " (select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo_personal in ('Cajero','CAJERO ADICIONAL') "
	sql = sql & " and asistencia is null "&sql2&") as cajerossinregistro, "
	sql = sql & " ((select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo='titular' "
	sql = sql & " and tipo_personal = 'cajero' "
	sql = sql & " and asistencia = 'no' "&sql2&") "
	sql = sql & " - (select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo='reemplazo' "
	sql = sql & " and tipo_personal = 'cajero' "
	sql = sql & " and asistencia = 'si' "&sql2&") "
	sql = sql & " +(select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo='reemplazo' "
	sql = sql & " and tipo_personal = 'cajero' "
	sql = sql & " and asistencia = 'no' "&sql2&") "
	sql = sql & " +(select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo='reemplazo' "
	sql = sql & " and tipo_personal = 'cajero adicional' "
	sql = sql & " and asistencia = 'no' "&sql2&")) as cajerosausentes2 "
	'response.write(sql)
	'response.end
	set rs = db.execute(sql)
	if not rs.eof then
		totalCajerosTitulares = rs("cajerostitulares")
		totalCajerosReemplazos = rs("cajerosreemplazos")
		totalCajerosAdicionales = rs("cajerosadicionales")
		totalAusentes = rs("cajerosausentes")
		totalAusentes2 = rs("cajerosausentes2")
		totalAusentes2 = ABS(totalAusentes2)
		totalPresentes = rs("cajerospresentes")
		totalSinRegistro = rs("cajerossinregistro")
		totalCajeros = cint(totalCajerosTitulares) + cint(totalCajerosAdicionales)
		Response.Write "  ""datosRegionales"": ["
		Response.Write "{"
		Response.Write "   ""idRegional"": """ & idRegional & """, "
		Response.Write "   ""totalCajerosReemplazos"": """ & totalCajerosReemplazos & """, "
		Response.Write "   ""totalCajerosAdicionales"": """ & totalCajerosAdicionales & """, "
		Response.Write "   ""totalCajerosTitulares"": """ & totalCajerosTitulares & """, "
		Response.Write "   ""totalAusentes"": """ & totalAusentes & """, "
		Response.Write "   ""totalAusentes2"": """ & totalAusentes2 & """, "
		Response.Write "   ""totalPresentes"": """ & totalPresentes & """, "
		Response.Write "   ""totalSinRegistro"": """ & totalSinRegistro & """, "
		Response.Write "   ""totalCajeros"": """ & totalCajeros & """ "
		Response.Write "}"
		response.write "],"
	end if
Response.Write "  ""datosZonales"": ["
sql = ""
sql = sql & " select id_usuario, "
sql = sql & " zonal, "
sql = sql & " zona_geo, "
sql = sql & " id_zonal "
sql = sql & " from SUC_zonales "
sql = sql & " where id_regional_p = '"&idRegional&"' "
sql = sql & " and estado_zonal = 1 "

set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows
end if
for i = 0 to ubound(datos,2)
	idZonal = trim(datos(0,i))
	nombreZonal = server.htmlencode(trim(datos(1,i)))
	zonaGeo = trim(datos(2,i))
	idZonal2 = trim(datos(3,i))
	sql2 = ""  
	sql2 = sql2 & " and id_sucursal in "
	sql2 = sql2 & " (select id_sucursal "
	sql2 = sql2 & " from suc_sucursal "
	sql2 = sql2 & " where suc_estado = 1 "
	sql2 = sql2 & " and id_sucursal in "
	sql2 = sql2 & " (select id_sucursal "
	sql2 = sql2 & " from SUC_usuario_sucursal "
	sql2 = sql2 & " where id_usuario = '"&idZonal&"'))  "
	
	sql = ""
	sql = sql & "select "
	sql = sql & " (select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo_personal = 'Cajero' "
	sql = sql & " and tipo = 'titular' "&sql2&") as cajerostitulares, "
	sql = sql & " (select COUNT(*) " 
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo_personal = 'Cajero' "
	sql = sql & " and tipo = 'reemplazo' "&sql2&") as cajerosreemplazos, "
	sql = sql & " (select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo_personal = 'CAJERO ADICIONAL' "&sql2&") as cajerosadicionales, "
	sql = sql & " (select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo_personal in ('Cajero','CAJERO ADICIONAL') "
	sql = sql & " and asistencia = 'si' "&sql2&") as cajerospresentes, "
	sql = sql & " (select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo_personal in ('Cajero','CAJERO ADICIONAL') "
	sql = sql & " and asistencia = 'no' "&sql2&") as cajerosausentes, "
	sql = sql & " (select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo_personal in ('Cajero','CAJERO ADICIONAL') "
	sql = sql & " and asistencia is null "&sql2&") as cajerossinregistro, "
	sql = sql & " ((select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo='titular' "
	sql = sql & " and tipo_personal = 'cajero' "
	sql = sql & " and asistencia = 'no' "&sql2&") "
	sql = sql & " - (select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo='reemplazo' "
	sql = sql & " and tipo_personal = 'cajero' "
	sql = sql & " and asistencia = 'si' "&sql2&") "
	sql = sql & " +(select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo='reemplazo' "
	sql = sql & " and tipo_personal = 'cajero' "
	sql = sql & " and asistencia = 'no' "&sql2&") "
	sql = sql & " +(select COUNT(*) "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where tipo='reemplazo' "
	sql = sql & " and tipo_personal = 'cajero adicional' "
	sql = sql & " and asistencia = 'no' "&sql2&")) as cajerosausentes2 "
	'response.write(sql)
	'response.end
	set rs = db.execute(sql)
	if not rs.eof then
		totalCajerosTitulares = rs("cajerostitulares")
		totalCajerosReemplazos = rs("cajerosreemplazos")
		totalCajerosAdicionales = rs("cajerosadicionales")
		totalAusentes = rs("cajerosausentes")
		totalAusentes2 = rs("cajerosausentes2")
		totalAusentes2 = ABS(totalAusentes2)
		totalPresentes = rs("cajerospresentes")
		totalSinRegistro = rs("cajerossinregistro")
		totalCajeros = cint(totalCajerosTitulares) + cint(totalCajerosAdicionales)
	else
		totalCajerosTitulares = 0
		totalCajerosReemplazos = 0
		totalCajerosAdicionales = 0
		totalAusentes = 0
		totalAusentes2 = 0
		totalPresentes = 0
		totalSinRegistro =0
		totalCajeros = 0
	end if
	Response.Write "{"
		Response.Write "   ""idRegional"": """ & idRegional & """, "
		Response.Write "   ""idZonal"": """ & idZonal & """, "
		Response.Write "   ""idZonal2"": """ & idZonal2 & """, "
		Response.Write "   ""nombreZonal"": """ & nombreZonal & """, "
		Response.Write "   ""zonaGeo"": """ & zonaGeo & """, "		
		Response.Write "   ""totalCajerosReemplazos"": """ & totalCajerosReemplazos & """, "
		Response.Write "   ""totalCajerosAdicionales"": """ & totalCajerosAdicionales & """, "
		Response.Write "   ""totalCajerosTitulares"": """ & totalCajerosTitulares & """, "
		Response.Write "   ""totalAusentes"": """ & totalAusentes & """, "
		Response.Write "   ""totalAusentes2"": """ & totalAusentes2 & """, "
		Response.Write "   ""totalPresentes"": """ & totalPresentes & """, "
		Response.Write "   ""totalCajeros"": """ & totalCajeros & """, "
		Response.Write "   ""totalSinRegistro"": """ & totalSinRegistro & """ "
		Response.Write "}"
	if i <> ubound(datos,2) then response.write(",")
next
Response.Write "]"
Response.Write "}"
%>