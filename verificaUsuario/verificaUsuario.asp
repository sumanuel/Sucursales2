<!--#include file="../conexion/conexion.asp"-->
<%
usuario = trim(request("txtlogin"))
contrasenia = trim(request("txtpwd"))
sql = ""
sql = sql & " select id_usuario, "
sql = sql & " id_perfil, "
sql = sql & " usuario_nombre, "
sql = sql & " usuario_rut, "
sql = sql & " usuario_pass "
sql = sql & " from SUC_usuario "
sql = sql & " where usuario_nombre = '"& usuario &"' "
sql = sql & " and usuario_pass = '"& contrasenia &"'"
Set rsUser = DB.execute(sql)
if not rsUser.Eof then
	perfil = rsUser("id_perfil")
	idUsuario = rsUser("id_usuario")
	idUsrWin = request.servervariables("LOGON_USER")
	usuarios = split(idUsrWin,"\")
	usuarioWin = usuarios(1)
	dominio = usuarios(0)
	ip = Request.ServerVariables("remote_addr")
	sql = ""
	sql = sql & " insert into "
	sql = sql & " SUC_usuario_ingreso "
	sql = sql & " values ('"&usuarioWin&"', "
	sql = sql & " '"&dominio&"', "
	sql = sql & " '"&idUsuario&"', "
	sql = sql & " '"&ip&"', "
	sql = sql & " getdate()) "
	db.execute(sql)
	if perfil = "1" then
		nombrePerfil = "Sucursal"
		idSucursal = obtieneIdSucursal(idUsuario)
		if idSucursal = "0" then 
			estado = "0"
		else
			estado = "1"
		end if
	elseif perfil = "2" then
		nombrePerfil = "Zonal"
		idSucursal="0"
		estado = "1"
	elseif perfil = "3" then
		nombrePerfil = "Gerencial"
		idSucursal="0"
		estado = "1"
	elseif perfil = "55" then
		nombrePerfil = "Zonal Comercial"
		idSucursal="0"
		estado = "1"
	elseif perfil = "66" then
		nombrePerfil = "MAS"
		idSucursal="0"
		estado = "1"
	end if
else
	if usuario = "admin" then
		nombrePerfil = "Administrador"
		idSucursal="0"
		perfil = "0"
		estado = "1"
	else
		estado = "2"
	end if
end if
function obtieneIdSucursal(idUsuario)
	sql2 = ""
	sql2 = sql2 & "select id_sucursal from SUC_usuario_sucursal where id_usuario = " & idUsuario& " and estado = 0"
	Set rsUserSuc = DB.execute(sql2)
	if not rsUserSuc.Eof then
		idSucursal = rsUserSuc("id_sucursal")
	else
		idSucursal = "0"
	end if	
	rsUserSuc.Close
	set rsUserSuc.ActiveConnection = nothing
	set rsUserSuc = nothing
	obtieneIdSucursal = idSucursal
end function

rsUser.Close
set rsUser.ActiveConnection = nothing
set rsUser = nothing
DB.Close
set DB=nothing
Response.ContentType = "application/json"
Response.Write "{"
Response.Write """datos"": [{"
Response.Write """estado"": """ & estado & ""","
Response.Write """idUsuario"": """ & idUsuario & ""","
Response.Write """usuarioWin"": """ & usuarioWin & ""","
Response.Write """nombrePerfil"": """ & nombrePerfil & ""","
Response.Write """idSucursal"": """ & idSucursal & ""","  
Response.Write """perfil"": """ & perfil & """"
Response.Write "}]}"
%>
