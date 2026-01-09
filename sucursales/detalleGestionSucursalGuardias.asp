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
sql = ""
sql = sql & " select sum(z.titulares_dot) as totalguardiastitulares , "
sql = sql & " sum(z.reemplazos_dot) as totalguardiasreemplazos , "
sql = sql & " sum(z.titulares_p)+SUM(z.reemp_p) as totalguardiaspresentes , "
sql = sql & " sum(z.ausencia) as totalguardiasausentes , "
sql = sql & " sum(sinRegistro) as totalguardiassinregistro from "
sql = sql & " ( select *,  "
sql = sql & " case "
sql = sql & " when y.total >= y.titulares_dot then 0 "
sql = sql & " else y.titulares_a + y.reemp_a  "
sql = sql & " end ausencia  "
sql = sql & " from ( select *,  "
sql = sql & " ((titulares_p)+(reemp_p)) as total "
sql = sql & " from ( "
sql = sql & " select a.cod_bantotal, "
sql = sql & " count(*) titulares_dot , "
sql = sql & " isnull((select count(*) "
sql = sql & " from SUC_sucursal_guardias_asistencia b "
sql = sql & " where a.cod_bantotal = b.cod_bantotal "
sql = sql & " and b.asistencia = 'si' "
sql = sql & " and b.tipo_suc = 'titular'),0) as titulares_p , "
sql = sql & " isnull((select count(*) "
sql = sql & " from SUC_sucursal_guardias_asistencia b "
sql = sql & " where a.cod_bantotal = b.cod_bantotal "
sql = sql & " and (b.asistencia = 'no' or b.asistencia is null) "
sql = sql & " and b.tipo_suc = 'titular'),0) as titulares_a , "
sql = sql & " isnull((select COUNT(gr.guardia_rut_titular) "
sql = sql & " from SUC_sucursal_guardias_r gr "
sql = sql & " where gr.guardia_rut_titular = a.guardia_rut "
sql = sql & " and gr.cod_bantotal = a.cod_bantotal "
sql = sql & " and CONVERT(date,gr.desde) <= CONVERT(date,GETDATE())),0)as reemplazos_dot , "
sql = sql & " isnull((select count(*) "
sql = sql & " from SUC_sucursal_guardias_asistencia b "
sql = sql & " inner join SUC_sucursal_guardias_r gr "
sql = sql & " on gr.guardia_rut = b.guardia_rut "
sql = sql & " and gr.cod_bantotal = b.cod_bantotal "
sql = sql & " where a.cod_bantotal = b.cod_bantotal "
sql = sql & " and b.asistencia = 'si' "
sql = sql & " and b.tipo_suc = 'reemplazo' "
sql = sql & " and CONVERT(date,desde) <= CONVERT(date,GETDATE())),0) as reemp_p, "
sql = sql & " isnull((select count(*) "
sql = sql & " from SUC_sucursal_guardias_asistencia b "
sql = sql & " inner join SUC_sucursal_guardias_r gr "
sql = sql & " on gr.guardia_rut = b.guardia_rut "
sql = sql & " and gr.cod_bantotal = b.cod_bantotal "
sql = sql & " where a.cod_bantotal = b.cod_bantotal "
sql = sql & " and (b.asistencia = 'no' or b.asistencia is null) "
sql = sql & " and b.tipo_suc = 'reemplazo' "
sql = sql & " and CONVERT(date,desde) <= CONVERT(date,GETDATE()) ),0) as reemp_a , "
sql = sql & " (select COUNT(*) "
sql = sql & " from SUC_sucursal_guardias_asistencia b "
sql = sql & " where b.asistencia is null "
sql = sql & " and b.cod_bantotal = a.cod_bantotal) as sinRegistro "
sql = sql & " from SUC_sucursal_guardias_t a "
sql = sql & " group by a.cod_bantotal,a.guardia_rut ) as z ) as y "
sql = sql & " where y.cod_bantotal in ( "
sql = sql & " select cod_bantotal "
sql = sql & " 	from suc_sucursal "
sql = sql & " where suc_estado = 1 "
sql = sql & " and id_sucursal in "
sql = sql & " (select id_sucursal "
sql = sql & " from SUC_usuario_sucursal "
sql = sql & " where id_usuario in(  "
sql = sql & " select id_usuario "
sql = sql & " from SUC_zonales "
sql = sql & " where id_regional_p = '"&idRegional&"' "
sql = sql & " 	and estado_zonal = 1))) "
sql = sql & " ) as z "
'response.write(sql)
'response.end
	set rs = db.execute(sql)
	if not rs.eof then
		totalGuardiasTitulares = rs("totalguardiastitulares")
		totalguardiasreemplazos = rs("totalguardiasreemplazos")
		totalguardiaspresentes = rs("totalguardiaspresentes")
		totalguardiasausentes = rs("totalguardiasausentes")
		totalguardiassinregistro = rs("totalguardiassinregistro")
		Response.Write "  ""datosRegionales"": ["
		Response.Write "{"
		Response.Write "   ""idRegional"": """ & idRegional & """, "
		Response.Write "   ""totalGuardiasTitulares"": """ & totalGuardiasTitulares & """, "
		Response.Write "   ""totalguardiasreemplazos"": """ & totalguardiasreemplazos & """, "
		Response.Write "   ""totalguardiaspresentes"": """ & totalguardiaspresentes & """, "
		Response.Write "   ""totalguardiasausentes"": """ & totalguardiasausentes & """, "
		Response.Write "   ""totalguardiassinregistro"": """ & totalguardiassinregistro & """ "
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
	sql = ""
	sql = sql & " select sum(z.titulares_dot) as totalguardiastitulares , "
	sql = sql & " sum(z.reemplazos_dot) as totalguardiasreemplazos , "
	sql = sql & " sum(z.titulares_p)+SUM(z.reemp_p) as totalguardiaspresentes , "
	sql = sql & " sum(z.ausencia) as totalguardiasausentes , "
	sql = sql & " sum(sinRegistro) as totalguardiassinregistro from "
	sql = sql & " ( select *,  "
	sql = sql & " case "
	sql = sql & " when y.total >= y.titulares_dot then 0 "
	sql = sql & " else y.titulares_a + y.reemp_a  "
	sql = sql & " end ausencia  "
	sql = sql & " from ( select *,  "
	sql = sql & " ((titulares_p)+(reemp_p)) as total "
	sql = sql & " from ( "
	sql = sql & " select a.cod_bantotal, "
	sql = sql & " count(*) titulares_dot , "
	sql = sql & " isnull((select count(*) "
	sql = sql & " from SUC_sucursal_guardias_asistencia b "
	sql = sql & " where a.cod_bantotal = b.cod_bantotal "
	sql = sql & " and b.asistencia = 'si' "
	sql = sql & " and b.tipo_suc = 'titular'),0) as titulares_p , "
	sql = sql & " isnull((select count(*) "
	sql = sql & " from SUC_sucursal_guardias_asistencia b "
	sql = sql & " where a.cod_bantotal = b.cod_bantotal "
	sql = sql & " and (b.asistencia = 'no' or b.asistencia is null) "
	sql = sql & " and b.tipo_suc = 'titular'),0) as titulares_a , "
	sql = sql & " isnull((select COUNT(gr.guardia_rut_titular) "
	sql = sql & " from SUC_sucursal_guardias_r gr "
	sql = sql & " where gr.guardia_rut_titular = a.guardia_rut "
	sql = sql & " and gr.cod_bantotal = a.cod_bantotal "
	sql = sql & " and CONVERT(date,gr.desde) <= CONVERT(date,GETDATE())),0)as reemplazos_dot , "
	sql = sql & " isnull((select count(*) "
	sql = sql & " from SUC_sucursal_guardias_asistencia b "
	sql = sql & " inner join SUC_sucursal_guardias_r gr "
	sql = sql & " on gr.guardia_rut = b.guardia_rut "
	sql = sql & " and gr.cod_bantotal = b.cod_bantotal "
	sql = sql & " where a.cod_bantotal = b.cod_bantotal "
	sql = sql & " and b.asistencia = 'si' "
	sql = sql & " and b.tipo_suc = 'reemplazo' "
	sql = sql & " and CONVERT(date,desde) <= CONVERT(date,GETDATE())),0) as reemp_p, "
	sql = sql & " isnull((select count(*) "
	sql = sql & " from SUC_sucursal_guardias_asistencia b "
	sql = sql & " inner join SUC_sucursal_guardias_r gr "
	sql = sql & " on gr.guardia_rut = b.guardia_rut "
	sql = sql & " and gr.cod_bantotal = b.cod_bantotal "
	sql = sql & " where a.cod_bantotal = b.cod_bantotal "
	sql = sql & " and (b.asistencia = 'no' or b.asistencia is null) "
	sql = sql & " and b.tipo_suc = 'reemplazo' "
	sql = sql & " and CONVERT(date,desde) <= CONVERT(date,GETDATE()) ),0) as reemp_a , "
	sql = sql & " (select COUNT(*) "
	sql = sql & " from SUC_sucursal_guardias_asistencia b "
	sql = sql & " where b.asistencia is null "
	sql = sql & " and b.cod_bantotal = a.cod_bantotal) as sinRegistro "
	sql = sql & " from SUC_sucursal_guardias_t a "
	sql = sql & " group by a.cod_bantotal,a.guardia_rut ) as z ) as y "
	sql = sql & " where y.cod_bantotal in ( "
	sql = sql & " select cod_bantotal "
	sql = sql & " 	from suc_sucursal "
	sql = sql & " where suc_estado = 1 "
	sql = sql & " and id_sucursal in "
	sql = sql & " (select id_sucursal "
	sql = sql & " from SUC_usuario_sucursal "
	sql = sql & " where id_usuario = '"&idZonal&"' "
	sql = sql & " ))) as z "
	'response.write(sql)
	'response.end
	set rs = db.execute(sql)
	if not rs.eof then
		totalguardiastitulares = rs("totalguardiastitulares")
		totalguardiasreemplazos = rs("totalguardiasreemplazos")
		totalguardiaspresentes = rs("totalguardiaspresentes")
		totalguardiasausentes = rs("totalguardiasausentes")
		totalguardiassinregistro = rs("totalguardiassinregistro")
		
	else
		totalguardiastitulares = 0
		totalguardiasreemplazos = 0
		totalguardiaspresentes = 0
		totalguardiasausentes = 0
		totalguardiassinregistro = 0
	end if
	Response.Write "{"
		Response.Write "   ""idRegional"": """ & idRegional & """, "
		Response.Write "   ""idZonal"": """ & idZonal & """, "
		Response.Write "   ""idZonal2"": """ & idZonal2 & """, "
		Response.Write "   ""nombreZonal"": """ & nombreZonal & """, "
		Response.Write "   ""zonaGeo"": """ & zonaGeo & """, "		
		Response.Write "   ""totalguardiastitulares"": """ & totalguardiastitulares & """, "
		Response.Write "   ""totalguardiasreemplazos"": """ & totalguardiasreemplazos & """, "
		Response.Write "   ""totalguardiaspresentes"": """ & totalguardiaspresentes & """, "
		Response.Write "   ""totalguardiasausentes"": """ & totalguardiasausentes & """, "
		Response.Write "   ""totalguardiassinregistro"": """ & totalguardiassinregistro & """ "
		Response.Write "}"
	if i <> ubound(datos,2) then response.write(",")
next
Response.Write "]"
Response.Write "}"
%>