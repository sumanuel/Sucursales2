<!--#include file="../funciones.asp"-->
<%accion = trim(request("accion"))
if accion = "" then accion = "1"
if accion = "1" then
	rut = trim(request("rut"))
	totalCaracteres = len(rut)
	if totalCaracteres = "10" then
		dv = right(rut,1)
		rut = left(rut,8)
	else
		dv = right(rut,1)
		rut = left(rut,7)
	end if
	perfil = trim(request("comboPerfil"))
	pass = trim(request("pass"))
	nombre = server.htmlencode(trim(request("nombre")))
	app_pat = server.htmlencode(trim(request("app_pat")))
	app_mat = server.htmlencode(trim(request("app_mat")))
	sexo = trim(request("sexo"))
	correo = trim(request("correo"))
	celular = trim(request("celular"))
	anexo = trim(request("anexo"))
	sql = ""
	sql = sql & "insert into  SUC_m_usuarios "
	sql = sql & " (usuario_rut, "
	sql = sql & " usuario_dv, "
	sql = sql & " id_perfil, "
	sql = sql & " usuario_pass, "
	sql = sql & " nombre, "
	sql = sql & " apellido_paterno, "
	sql = sql & " apellido_materno, "
	sql = sql & " sexo, "
	sql = sql & " correo, "
	sql = sql & " celular, "
	sql = sql & " anexo, "
	sql = sql & " usuario_estado, "
	sql = sql & " fecha_registro) "
	sql = sql & " values ( "
	sql = sql & " '"&rut&"', "
	sql = sql & " '"&dv&"', "
	sql = sql & " '"&perfil&"', "
	sql = sql & " '"&pass&"', "
	sql = sql & " '"&nombre&"', "
	sql = sql & " '"&app_pat&"', "
	sql = sql & " '"&app_mat&"', "
	sql = sql & " '"&sexo&"', "
	sql = sql & " '"&correo&"', "
	sql = sql & " '"&celular&"', "
	sql = sql & " '"&anexo&"', "
	sql = sql & " '1', "
	sql = sql & " getdate()) "
	'response.write(sql)
	'response.end
	db.execute(sql)
else
	idUsuario = trim(request("idUsuario"))
	perfil = trim(request("comboPerfil"))
	pass = trim(request("pass"))
	nombre = server.htmlencode(trim(request("nombre")))
	app_pat = server.htmlencode(trim(request("app_pat")))
	app_mat = server.htmlencode(trim(request("app_mat")))
	sexo = trim(request("sexo"))
	correo = trim(request("correo"))
	celular = trim(request("celular"))
	anexo = trim(request("anexo"))
	sql = ""
	sql = sql & "update SUC_m_usuarios set "
	sql = sql & " id_perfil = '"&perfil&"',  "
	sql = sql & " nombre = '"&nombre&"', "
	sql = sql & " apellido_paterno = '"&app_pat&"', "
	sql = sql & " apellido_materno = '"&app_mat&"', "
	sql = sql & " sexo = '"&sexo&"', "
	sql = sql & " correo = '"&correo&"', "
	sql = sql & " celular = '"&celular&"', "
	sql = sql & " anexo = '"&anexo&"' "
	sql = sql & " where id_usuario = '"&idUsuario&"' "
	db.execute(sql)

	'actualiza'
end if
response.write("1")%>