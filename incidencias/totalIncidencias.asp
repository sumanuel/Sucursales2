<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursalMain"))
'idUsuario = trim(request("idUsuario"))
'perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuarioMain"))
perfil = trim(request("perfilMain"))
	totalIncidencias = 0
	Actual =  Now()
	diaActual = Day(Actual) 
	mesActual = Month(Actual)
	anioActual = Year(Actual) 
	sql = ""
	sql = sql & " select count(id_gest_inc) as totalIncidencias"
	sql = sql & " from SUC_gest_inc "
	sql = sql & " where gest_inc_estado = 0 "
	if perfil = "2" then
		sql = sql & " and id_sucursal in (select id_sucursal "
		sql = sql & " from SUC_zonales_sucursal "
		sql = sql & " where id_zonal = '"&idUsuario&"') "
	end if
	if perfil = "1" then
		sql = sql & " and id_sucursal = '"&idSucursal&"' "
		'sql = sql & " (select id_sucursal "
		'sql = sql & " from SUC_usuario_sucursal "
		'sql = sql & " where id_usuario = '"&idUsuario&"')"
	end if
	if perfil = "55" then
			sql = sql & " and id_sucursal in  (select id_sucursal  "
			sql = sql & " from SUC_zonales_comercial_sucursal  where id_zonal = '"&idUsuario&"' ) "
	End if
	if perfil = "66" then
			sql = sql & " and id_sucursal in  (select id_sucursal  "
			sql = sql & " from SUC_zonales_comercial_mas_sucursal  where id_zonal = '"&idUsuario&"' ) "
	End if
	'response.write(sql)
	'response.end
	set rs = db.execute(sql)
	if not rs.eof then
		totalIncidencias = trim(rs("totalIncidencias"))
	end if
	response.write(totalIncidencias)
rs.Close%>