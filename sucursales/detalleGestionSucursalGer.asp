<!--#include file="../funciones.asp"-->
<%idRegional = trim(request("idRegional"))
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datosRegional"": ["
sql = ""
sql = sql & " select * "
sql = sql & " from suc_regionales where id_regional = '"&idRegional&"'"
set rs = db.execute(sql)
if not rs.eof then
	datosRegional = rs.GetRows()
end if
for x=0 to ubound(datosRegional,2)
	idRegional = trim(datosRegional(0,x))
	nombreRegional = trim(datosRegional(1,x))
	Response.Write "{"
	Response.Write "   ""idRegional"": """ & idRegional & """, "
	Response.Write "   ""nombreRegional"": """ & nombreRegional & """ "
	Response.Write "}"
	if x <> ubound(datosRegional,2) then response.write(",")
next
Response.Write "],"
Response.Write "  ""datosTipoGestion"": ["
	for i = 1 to 3
		select case i
		case "1"
			icono = "icon-archive"
			nombre = "Gestión documental"
		case "2"
			icono = "icon-money"
			nombre = "Gestión contable"
		case "3"
			icono = "icon-group"
			nombre = "Gestión administrativa"
		end select
	
		Response.Write "{"
		Response.Write "   ""idTipo"": """ & i & """, "
		Response.Write "   ""icono"": """ & icono & """, "
		Response.Write "   ""nombre"": """ & nombre & """ "
		Response.Write "}"
		if i <> 3 then response.write(",")
	next
Response.Write "],"
Response.Write "  ""datosGestion"": ["
sql = ""
sql = sql & " select y.id_regional_p, "
sql = sql & " sum(y.gest_admin_ok) as gest_admin_ok, "
sql = sql & " sum(y.gest_admin_nok) as gest_admin_nok, "
sql = sql & " left(((cast(sum(y.gest_admin_ok) as float))*100/(cast(sum(y.gest_admin_ok)+sum(y.gest_admin_nok) as float))),4) as porct_admin,"
sql = sql & " sum(y.gest_cont_ok) as gest_cont_ok, "
sql = sql & " sum(y.gest_cont_nok) as gest_cont_nok, "
sql = sql & " left(((cast(sum(y.gest_cont_ok) as float))*100/(cast(sum(y.gest_cont_ok)+sum(y.gest_cont_nok) as float))),4) as porct_cont," 
sql = sql & " sum(y.gest_doc_ok) as gest_doc_ok, "
sql = sql & " sum(y.gest_doc_nok) as gest_doc_nok, "
sql = sql & " left(((cast(sum(y.gest_doc_ok) as float))*100/(cast(sum(y.gest_doc_ok)+sum(y.gest_doc_nok) as float))),4) as porct_doc "
sql = sql & " from (select z.id_regional_p, "
sql = sql & " z.id_sucursal, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_admin x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_admin_estado = 1) as gest_admin_ok, "
sql = sql & " (select count(*) "
	sql = sql & " from SUC_gest_admin x "
	sql = sql & " where x.fecha_operacion = z.fecha "
	sql = sql & " and x.id_sucursal = z.id_sucursal "
	sql = sql & " and gest_admin_estado = 0) as gest_admin_nok, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_cont x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_cont_estado = 1) as gest_cont_ok, "
sql = sql & " (select count(*) "
	sql = sql & " from SUC_gest_cont x "
	sql = sql & " where x.fecha_operacion = z.fecha "
	sql = sql & " and x.id_sucursal = z.id_sucursal "
	sql = sql & " and gest_cont_estado = 0) as gest_cont_nok, "
sql = sql & " (select count(*) "
	sql = sql & " from SUC_gest_doc x "
	sql = sql & " where x.fecha_operacion = z.fecha "
	sql = sql & " and x.id_sucursal = z.id_sucursal "
	sql = sql & " and gest_doc_estado = 1) as gest_doc_ok, "
sql = sql & " (select count(*) "
	sql = sql & " from SUC_gest_doc x "
	sql = sql & " where x.fecha_operacion = z.fecha "
	sql = sql & " and x.id_sucursal = z.id_sucursal "
	sql = sql & " and gest_doc_estado = 0) as gest_doc_nok "
sql = sql & " from ( select a.id_regional_p, "
	sql = sql & " c.id_sucursal, "
	sql = sql & " c.suc_nombre, "
	sql = sql & " cast(getdate() as date) as fecha "
sql = sql & " from SUC_zonales a "
sql = sql & " inner join SUC_zonales_sucursal b "
sql = sql & " on a.id_usuario = b.id_zonal "
sql = sql & " and a.estado_zonal = 1 "
sql = sql & " inner join SUC_sucursal c "
sql = sql & " on b.id_sucursal = c.id_sucursal  "
sql = sql & " ) as z ) as y "
sql = sql & " where y.id_regional_p = '"&idRegional&"' "
sql = sql & " group by y.id_regional_p "

set rs = db.execute(sql)
json = ""
if not rs.eof then
	do while not rs.eof 
		idRegional =  trim(rs("id_regional_p")) 
		idGestAdmOk = trim(rs("gest_admin_ok"))
		idGestAdmNoOk = trim(rs("gest_admin_nok")) 
		poctAdmin = replace( trim(rs("porct_admin")) ,".",",")
		idGestContOk = trim(rs("gest_cont_ok"))
		idGestContNoOk = trim(rs("gest_cont_nok")) 
		poctCont = replace( trim(rs("porct_cont")) ,".",",")
		idGestDocOk = trim(rs("gest_doc_ok"))
		idGestDocNoOk = trim(rs("gest_doc_nok")) 
		poctDoc = replace( trim(rs("porct_doc")) ,".",",")
		json = json + "{"
	json = json + "   ""idRegional"": """ & idRegional & """, "
	json = json + "   ""idGestAdmOk"": """ & idGestAdmOk & """, "
	json = json + "   ""idGestAdmNoOk"": """ & idGestAdmNoOk & """, "
	json = json + "   ""poctAdmin"": """ & poctAdmin & """, "
	json = json + "   ""idGestContOk"": """ & idGestContOk & """, "
	json = json + "   ""idGestContNoOk"": """ & idGestContNoOk & """, "
	json = json + "   ""poctCont"": """ & poctCont & """, "
	json = json + "   ""idGestDocOk"": """ & idGestDocOk & """, "
	json = json + "   ""idGestDocNoOk"": """ & idGestDocNoOk & """, "
	json = json + "   ""poctDoc"": """ & poctDoc & """ "

	json = json + "},"
	rs.movenext	
	loop	
end if

totaljson = len(json) - 1

json = left(json,totaljson)
response.write(json)
Response.Write "],"
Response.Write "  ""datosZonales"": ["
sql= ""
sql = sql & " select y.id_zonal, "
sql = sql & " y.id_regional_p, "
sql = sql & " y.zonal, "
sql = sql & " y.zona_geo, "
sql = sql & " sum(y.gest_admin_ok) as gest_admin_ok, "
sql = sql & " sum(y.gest_admin_nok) as gest_admin_nok, " 
sql = sql & " left(((cast(sum(y.gest_admin_ok) as float))/(cast(sum(y.gest_admin_ok)+sum(y.gest_admin_nok) as float))*100),4) as porct_admin, "
sql = sql & " sum(y.gest_cont_ok) as gest_cont_ok, "
sql = sql & " sum(y.gest_cont_nok) as gest_cont_nok, "
sql = sql & " left(((cast(sum(y.gest_cont_ok) as float))/(cast(sum(y.gest_cont_ok)+sum(y.gest_cont_nok) as float))*100),4) as porct_gest, "
sql = sql & " sum(y.gest_doc_ok) as gest_doc_ok, "
sql = sql & " sum(y.gest_doc_nok) as gest_doc_nok, "
sql = sql & " left(((cast(sum(y.gest_doc_ok) as float))/(cast(sum(y.gest_doc_ok)+sum(y.gest_doc_nok) as float))*100),4) as porct_doc "
sql = sql & " from ( select "
sql = sql & " z.id_zonal, "
sql = sql & " z.id_regional_p, "
sql = sql & " z.id_sucursal, "
sql = sql & " z.zonal, "
sql = sql & " z.zona_geo, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_admin x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_admin_estado = 1) as gest_admin_ok, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_admin x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_admin_estado = 0) as gest_admin_nok, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_cont x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_cont_estado = 1) as gest_cont_ok, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_cont x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_cont_estado = 0) as gest_cont_nok, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_doc x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_doc_estado = 1) as gest_doc_ok, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_doc x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_doc_estado = 0) as gest_doc_nok "
sql = sql & " from ( select a.id_zonal, "
sql = sql & " a.id_regional_p, "
sql = sql & " c.id_sucursal, "
sql = sql & " c.suc_nombre, "
sql = sql & " cast(getdate() as date) as fecha, "
sql = sql & " a.zonal, "
sql = sql & " a.zona_geo "
sql = sql & " from SUC_zonales a "
sql = sql & " inner join "
sql = sql & " SUC_zonales_sucursal b "
sql = sql & " on a.id_usuario = b.id_zonal "
sql = sql & " and a.estado_zonal = 1 "
sql = sql & " inner join SUC_sucursal c "
sql = sql & " on b.id_sucursal = c.id_sucursal "
sql = sql & " ) as z ) as y "
sql = sql & " where y.id_regional_p = '"&idRegional&"' "
sql = sql & " group by y.id_zonal, "
sql = sql & " y.id_regional_p, "
sql = sql & " y.zonal, "
sql = sql & " y.zona_geo "
set rs = db.execute(sql)
if not rs.eof then
	datosZonales = rs.GetRows()
end if
for i = 0 to ubound(datosZonales,2)
	idZonal = trim(datosZonales(0,i))
	idRegional = trim(datosZonales(1,i))
	nombreZonal = server.htmlencode(trim(datosZonales(2,i)))
	zonaGeo = trim(datosZonales(3,i))
	gestAdminOk = trim(datosZonales(4,i))
	gestAdminNok = trim(datosZonales(5,i))
	porctAdmin = replace(trim(datosZonales(6,i)),".",",")
	gestContOk = trim(datosZonales(7,i))
	gestContNok = trim(datosZonales(8,i))
	porctCont = replace(trim(datosZonales(9,i)),".",",")
	gestDocOk = trim(datosZonales(10,i))
	gestDocNok = trim(datosZonales(11,i))
	porctDoc = replace(trim(datosZonales(12,i)),".",",")
	Response.Write "{"
	Response.Write "   ""idZonal"": """ & idZonal & """, "
	Response.Write "   ""idRegional"": """ & idRegional & """, "
	Response.Write "   ""nombreZonal"": """ & nombreZonal & """, "
	Response.Write "   ""zonaGeo"": """ & zonaGeo & """, "
	Response.Write "   ""gestAdminOk"": """ & gestAdminOk & """, "
	Response.Write "   ""gestAdminNok"": """ & gestAdminNok & """, "
	Response.Write "   ""porctAdmin"": """ & porctAdmin & """, "
	Response.Write "   ""gestContOk"": """ & gestContOk & """, "
	Response.Write "   ""gestContNok"": """ & gestContNok & """, "
	Response.Write "   ""porctCont"": """ & porctCont & """, "
	Response.Write "   ""gestDocOk"": """ & gestDocOk & """, "
	Response.Write "   ""gestDocNok"": """ & gestDocNok & """, "
	Response.Write "   ""porctDoc"": """ & porctDoc & """ "
	Response.Write "}"
	if i <> ubound(datosZonales,2) then response.write(",")
next
response.write "]"
Response.Write "}"
%>