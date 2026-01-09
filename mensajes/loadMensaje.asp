<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
idUsuario = trim(request("idUsuario"))
perfil = trim(request("perfil"))
if idSucursal = "" then
	response.redirect("default.asp")
else
	if perfil = "3" then idUsuario = "0"
	if perfil = "2" then
		sql2 = ""
		sql2 = sql2 & "select id_zonal from SUC_zonales where id_usuario = '"&idUsuario&"'"
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			idUsuario = trim(rs2("id_zonal"))
		end if
	end if
	totalMensajes = 0
	if perfil = "1" then
		sql = ""
		sql = sql & " select count(a.id_msg) as totalMensajes "
		sql = sql & " from SUC_msg a "
		sql = sql & " inner join SUC_msg_dest b on a.id_msg = b.id_msg "
		sql = sql & " inner join SUC_msg_tipo c on a.id_msgtipo = c.id_msgtipo "
		sql = sql & " where b.id_dest = '"&idUsuario&"' " ' para sucursal'
		sql = sql & " and readMsg = 0 "
		sql = sql & " and c.id_msgtipo in (2,4) "
	end if
	if perfil = "2" then 'zonal'
		sql = ""
		sql = sql & " select count(a.id_msg) as totalMensajes "
		sql = sql & " from SUC_msg a "
		sql = sql & " inner join SUC_msg_dest b on a.id_msg = b.id_msg "
		sql = sql & " inner join SUC_msg_tipo c on a.id_msgtipo = c.id_msgtipo "
		sql = sql & " where b.id_dest = '"&idUsuario&"' " ' para sucursal'
		sql = sql & " and readMsg = 0 "
		sql = sql & " and c.id_msgtipo in (1,6) "
	end if
	if perfil = "3" then
		sql = ""
		sql = sql & " select count(a.id_msg) as totalMensajes "
		sql = sql & " from SUC_msg a "
		sql = sql & " inner join SUC_msg_dest b on a.id_msg = b.id_msg "
		sql = sql & " inner join SUC_msg_tipo c on a.id_msgtipo = c.id_msgtipo "
		sql = sql & " where b.id_dest = '"&idUsuario&"' " ' para sucursal'
		sql = sql & " and readMsg = 0 "
		sql = sql & " and c.id_msgtipo in (3,5) "
	end if
	set rs = db.execute(sql)
	if not rs.eof then
		totalMensajes = trim(rs("totalMensajes"))
	end if
	response.write(totalMensajes)
end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
DB.Close
set DB=nothing%>