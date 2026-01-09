<!--#include file="../funciones2.asp"-->
<%idRegional = trim(request("idRegional"))
'response.write(idRegional)
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datosRegional"": ["
fecha = "2015-02-17"
'fecha = date()
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
Response.Write "], "
Response.Write "  ""datosRegionales"": [{"
Response.Write "   ""idRegional"": """ & idRegional & """, "
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
sql = sql & " select count(id_sucursal) as fp "
sql = sql & " from SUC_sucursal_apertura "
sql = sql & " where tipo = 1 "
sql = sql & " and fecha_ingreso = cast('"&fecha&"' as date)  "
sql = sql & " and hora_ingreso > '08:50' "
sql = sql & sql2
set rs = db.execute(sql)
if not rs.eof then
	totalFueraDePlazo = trim(rs(0))	
end if
sql = ""
sql = sql & " select count(id_sucursal) as fp "
sql = sql & " from SUC_sucursal_apertura "
sql = sql & " where tipo = 1 and fecha_ingreso = cast('"&fecha&"' as date)  "
sql = sql & " and hora_ingreso <= '08:50' "
sql = sql & sql2
set rs = db.execute(sql)
if not rs.eof then
	totalDentroDePlazo = trim(rs(0))	
end if
sql = ""
sql = sql & " select COUNT(id_sucursal) as Abiertas "
sql = sql & " from SUC_sucursal_apertura "
sql = sql & " where tipo = 1 "
sql = sql & " and fecha_ingreso = cast('"&fecha&"' as date) "
sql = sql & sql2
set rs = db.execute(sql)
if not rs.eof then
	totalAbiertas = trim(rs(0))
end if
sql = ""
sql = sql & " select COUNT(id_sucursal) as Cerradas "
sql = sql & " from SUC_sucursal_apertura "
sql = sql & " where tipo = 2 "
sql = sql & " and fecha_ingreso = cast('"&fecha&"' as date) "
sql = sql & sql2
set rs = db.execute(sql)
if not rs.eof then
	totalCerradas = trim(rs(0))
end if
sql = ""
sql = sql & " select COUNT(*) as total "
sql = sql & " from SUC_desbordes "
sql = sql & " where fecha = cast('"&fecha&"' as date) "
sql = sql & " and situacion not in ('Desborde','Full')  "
sql = sql & sql2
set rs = db.execute(sql)
if not rs.eof then
	totalSituacionNormal = trim(rs(0))
end if
sql = ""
sql = sql & " select COUNT(*) as total "
sql = sql & " from SUC_desbordes "
sql = sql & " where fecha = cast('"&fecha&"' as date) "
sql = sql & " and situacion = 'Full' "
sql = sql & " and tipo =  1"
sql = sql & sql2
set rs = db.execute(sql)
if not rs.eof then
	totalSituacionFullIps = trim(rs(0))
end if
sql = ""
sql = sql & " select COUNT(*) as total "
sql = sql & " from SUC_desbordes "
sql = sql & " where fecha = cast('"&fecha&"' as date) "
sql = sql & " and situacion = 'Full' "
sql = sql & " and tipo =  1 "
sql = sql & sql2
set rs = db.execute(sql)
if not rs.eof then
	totalSituacionFullIps = trim(rs(0))
end if
sql = ""
sql = sql & " select COUNT(*) as total "
sql = sql & " from SUC_desbordes "
sql = sql & " where fecha = cast('"&fecha&"' as date) "
sql = sql & " and situacion = 'Full' "
sql = sql & " and tipo =  2 "
sql = sql & sql2
set rs = db.execute(sql)
if not rs.eof then
	totalSituacionFullAfp = trim(rs(0))
end if
sql = ""
sql = sql & " select COUNT(*) as total "
sql = sql & " from SUC_desbordes "
sql = sql & " where fecha = cast('"&fecha&"' as date) "
sql = sql & " and situacion = 'Desborde' "
sql = sql & " and tipo =  1 "
sql = sql & sql2
set rs = db.execute(sql)
if not rs.eof then
	totalSituacionDesIps = trim(rs(0))
end if
sql = ""
sql = sql & " select COUNT(*) as total "
sql = sql & " from SUC_desbordes "
sql = sql & " where fecha = cast('"&fecha&"' as date) "
sql = sql & " and situacion = 'Desborde' "
sql = sql & " and tipo =  2 "
sql = sql & sql2
set rs = db.execute(sql)
if not rs.eof then
	totalSituacionDesAfp = trim(rs(0))
end if
Response.Write "   ""totalAbiertas"": """ & totalAbiertas & """, "
Response.Write "   ""totalCerradas"": """ & totalCerradas & """, "
Response.Write "   ""totalFueraDePlazo"": """ & totalFueraDePlazo & """, "
Response.Write "   ""totalDentroDePlazo"": """ & totalDentroDePlazo & """, "
Response.Write "   ""totalSituacionNormal"": """ & totalSituacionNormal & """, "
Response.Write "   ""totalSituacionFullIps"": """ & totalSituacionFullIps & """, "
Response.Write "   ""totalSituacionFullAfp"": """ & totalSituacionFullAfp & """, "
Response.Write "   ""totalSituacionDesIps"": """ & totalSituacionDesIps & """, "
Response.Write "   ""totalSituacionDesAfp"": """ & totalSituacionDesAfp & """ "
Response.Write "}],"
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
	sql2 = sql2 & " where id_usuario = '"&idZonal&"')) "
	
	sql = ""
	sql = sql & " select count(id_sucursal) as fp "
	sql = sql & " from SUC_sucursal_apertura "
	sql = sql & " where tipo = 1 "
	sql = sql & " and fecha_ingreso = cast('"&fecha&"' as date)  "
	sql = sql & " and hora_ingreso > '08:50' "
	sql = sql & sql2
	set rs = db.execute(sql)
	if not rs.eof then
		totalFueraDePlazo = trim(rs(0))	
	end if
	sql = ""
	sql = sql & " select count(id_sucursal) as fp "
	sql = sql & " from SUC_sucursal_apertura "
	sql = sql & " where tipo = 1 and fecha_ingreso = cast('"&fecha&"' as date)  "
	sql = sql & " and hora_ingreso <= '08:50' "
	sql = sql & sql2
	set rs = db.execute(sql)
	if not rs.eof then
		totalDentroDePlazo = trim(rs(0))	
	end if
	sql = ""
	sql = sql & " select COUNT(id_sucursal) as Abiertas "
	sql = sql & " from SUC_sucursal_apertura "
	sql = sql & " where tipo = 1 "
	sql = sql & " and fecha_ingreso = cast('"&fecha&"' as date) "
	sql = sql & sql2
	set rs = db.execute(sql)
	if not rs.eof then
		totalAbiertas = trim(rs(0))
	end if
	sql = ""
	sql = sql & " select COUNT(id_sucursal) as Cerradas "
	sql = sql & " from SUC_sucursal_apertura "
	sql = sql & " where tipo = 2 "
	sql = sql & " and fecha_ingreso = cast('"&fecha&"' as date) "
	sql = sql & sql2
	set rs = db.execute(sql)
	if not rs.eof then
		totalCerradas = trim(rs(0))
	end if
	sql = ""
	sql = sql & " select COUNT(*) as total "
	sql = sql & " from SUC_desbordes "
	sql = sql & " where fecha = cast('"&fecha&"' as date) "
	sql = sql & " and situacion not in ('Desborde','Full')  "
	sql = sql & sql2
	set rs = db.execute(sql)
	if not rs.eof then
		totalSituacionNormal = trim(rs(0))
	end if
	sql = ""
	sql = sql & " select COUNT(*) as total "
	sql = sql & " from SUC_desbordes "
	sql = sql & " where fecha = cast('"&fecha&"' as date) "
	sql = sql & " and situacion = 'Full' "
	sql = sql & " and tipo =  1"
	sql = sql & sql2
	set rs = db.execute(sql)
	if not rs.eof then
		totalSituacionFullIps = trim(rs(0))
	end if
	sql = ""
	sql = sql & " select COUNT(*) as total "
	sql = sql & " from SUC_desbordes "
	sql = sql & " where fecha = cast('"&fecha&"' as date) "
	sql = sql & " and situacion = 'Full' "
	sql = sql & " and tipo =  1 "
	sql = sql & sql2
	set rs = db.execute(sql)
	if not rs.eof then
		totalSituacionFullIps = trim(rs(0))
	end if
	sql = ""
	sql = sql & " select COUNT(*) as total "
	sql = sql & " from SUC_desbordes "
	sql = sql & " where fecha = cast('"&fecha&"' as date) "
	sql = sql & " and situacion = 'Full' "
	sql = sql & " and tipo =  2 "
	sql = sql & sql2
	set rs = db.execute(sql)
	if not rs.eof then
		totalSituacionFullAfp = trim(rs(0))
	end if
	sql = ""
	sql = sql & " select COUNT(*) as total "
	sql = sql & " from SUC_desbordes "
	sql = sql & " where fecha = cast('"&fecha&"' as date) "
	sql = sql & " and situacion = 'Desborde' "
	sql = sql & " and tipo =  1 "
	sql = sql & sql2
	set rs = db.execute(sql)
	if not rs.eof then
		totalSituacionDesIps = trim(rs(0))
	end if
	sql = ""
	sql = sql & " select COUNT(*) as total "
	sql = sql & " from SUC_desbordes "
	sql = sql & " where fecha = cast('"&fecha&"' as date) "
	sql = sql & " and situacion = 'Desborde' "
	sql = sql & " and tipo =  2 "
	sql = sql & sql2
	set rs = db.execute(sql)
	if not rs.eof then
		totalSituacionDesAfp = trim(rs(0))
	end if
	Response.Write "{"
	Response.Write "   ""idRegional"": """ & idRegional & """, "
	Response.Write "   ""idZonal"": """ & idZonal & """, "
	Response.Write "   ""idZonal2"": """ & idZonal2 & """, "
	Response.Write "   ""nombreZonal"": """ & nombreZonal & """, "
	Response.Write "   ""zonaGeo"": """ & zonaGeo & """, "
	Response.Write "   ""totalAbiertas"": """ & totalAbiertas & """, "
	Response.Write "   ""totalCerradas"": """ & totalCerradas & """, "
	Response.Write "   ""totalFueraDePlazo"": """ & totalFueraDePlazo & """, "
	Response.Write "   ""totalDentroDePlazo"": """ & totalDentroDePlazo & """, "
	Response.Write "   ""totalSituacionNormal"": """ & totalSituacionNormal & """, "
	Response.Write "   ""totalSituacionFullIps"": """ & totalSituacionFullIps & """, "
	Response.Write "   ""totalSituacionFullAfp"": """ & totalSituacionFullAfp & """, "
	Response.Write "   ""totalSituacionDesIps"": """ & totalSituacionDesIps & """, "
	Response.Write "   ""totalSituacionDesAfp"": """ & totalSituacionDesAfp & """ "
	Response.Write "}"
	if i <> ubound(datos,2) then response.write(",")
next
Response.Write "]"
Response.Write "}"

%>