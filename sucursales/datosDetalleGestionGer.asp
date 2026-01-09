<!--#include file="../funciones.asp"-->
<%idRegional = trim(request("idRegional"))
Response.ContentType = "application/json"
Response.Write "{"
sql = ""
sql = sql & " select y.id_zonal, "
sql = sql & " y.id_regional_p, "
sql = sql & " y.id_sucursal, "
sql = sql & " y.suc_nombre, "
sql = sql & " y.suc_jeps, "
sql = sql & " sum(y.gest_admin_ok) as gest_admin_ok, "
sql = sql & " sum(y.gest_admin_nok) as gest_admin_nok, "
sql = sql & " left(((cast(sum(y.gest_admin_ok) as float))/(cast(sum(y.gest_admin_ok)+sum(y.gest_admin_nok) as float))*100),4) as porct_admin, "
sql = sql & " sum(y.gest_cont_ok) as gest_cont_ok, "
sql = sql & " sum(y.gest_cont_nok) as gest_cont_nok, "
sql = sql & " ((cast(sum(y.gest_cont_ok) as float))/(cast(sum(y.gest_cont_ok)+sum(y.gest_cont_nok) as float))*100) as porct_gest, "
sql = sql & " sum(y.gest_doc_ok) as gest_doc_ok, "
sql = sql & " sum(y.gest_doc_nok) as gest_doc_nok, "
sql = sql & " ((cast(sum(y.gest_doc_ok) as float))/(cast(sum(y.gest_doc_ok)+sum(y.gest_doc_nok) as float))*100) as porct_doc "
sql = sql & " from ( select "
sql = sql & " z.id_zonal, "
sql = sql & " z.id_regional_p, "
sql = sql & " z.id_sucursal, "
sql = sql & " z.suc_nombre, "
sql = sql & " z.suc_jeps, "
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
sql = sql & " c.suc_jeps, "
sql = sql & " cast(getdate() as date) as fecha "
sql = sql & " from SUC_zonales a "
sql = sql & " inner join SUC_zonales_sucursal b "
sql = sql & " on a.id_usuario = b.id_zonal "
sql = sql & " and a.estado_zonal = 1 "
sql = sql & " inner join SUC_sucursal c "
sql = sql & " on b.id_sucursal = c.id_sucursal "
sql = sql & " ) as z ) as y where y.id_regional_p = '"&idRegional&"' "
sql = sql & " group by y.id_zonal, "
sql = sql & " y.id_regional_p, "
sql = sql & " y.id_sucursal, "
sql = sql & " y.suc_nombre, "
sql = sql & " y.suc_jeps "
Response.Write "  ""data"": ["
set rs = db.execute(sql)
if not rs.eof then
	datosSucursales = rs.GetRows()
end if
for i = 0 to ubound(datosSucursales,2)
	idZonal = trim(datosSucursales(0,i))
	idRegional = trim(datosSucursales(1,i))
	idSucursal = trim(datosSucursales(2,i))
	nombreSucursal = trim(datosSucursales(3,i))
	nombreJeps = server.htmlencode(trim(datosSucursales(4,i)))
	gestAdminOk = trim(datosSucursales(5,i))
	gestAdminNok = trim(datosSucursales(6,i))
	porctAdmin = replace(trim(datosSucursales(7,i)),".",",")
	gestContOk = trim(datosSucursales(8,i))
	gestContNok = trim(datosSucursales(9,i))
	porctCont = replace(trim(datosSucursales(10,i)),".",",")
	gestDocOk = trim(datosSucursales(11,i))
	gestDocNok = trim(datosSucursales(12,i))
	porctDoc = replace(trim(datosSucursales(13,i)),".",",")
	Response.Write "["
	Response.Write "   ""idZonal"": """ & idZonal & """, "
	Response.Write "   ""idRegional"": """ & idRegional & """, "
	Response.Write "   ""idSucursal"": """ & idSucursal & """, "
	Response.Write "   ""nombreSucursal"": """ & nombreSucursal & """, "
	Response.Write "   ""nombreJeps"": """ & nombreJeps & """, "
	Response.Write "   ""gestAdminOk"": """ & gestAdminOk & """, "
	Response.Write "   ""gestAdminNok"": """ & gestAdminNok & """, "
	Response.Write "   ""porctAdmin"": """ & porctAdmin & """, "
	Response.Write "   ""gestContOk"": """ & gestContOk & """, "
	Response.Write "   ""gestContNok"": """ & gestContNok & """, "
	Response.Write "   ""porctCont"": """ & porctCont & """, "
	Response.Write "   ""gestDocOk"": """ & gestDocOk & """, "
	Response.Write "   ""gestDocNok"": """ & gestDocNok & """, "
	Response.Write "   ""porctDoc"": """ & porctDoc & """ "
	Response.Write "]"
	if i <> ubound(datosSucursales,2) then response.write(",")
next
response.write "]"
Response.Write "}"
%>