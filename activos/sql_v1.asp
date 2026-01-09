<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
if idSucursal = "0" then response.redirect("verificausuario/salir.asp")
tipoFormulario = trim(request("tipoFormulario"))
tipoElemento = trim(request("tipoElemento"))
campoMarca = trim(request("campoMarca"))
campoModelo = trim(request("campoModelo"))
campoSerie = trim(request("campoSerie"))
rotulo = trim(request("rotulo"))
campoCargo = trim(request("campoCargo"))
nombreUsuario = trim(request("nombreUsuario"))
correo = trim(request("correo"))
cantidadTotal = trim(request("cantidadTotal"))
if cantidadTotal = "" then cantidadTotal = 1

if campoMarca = "" then
	sql = ""
	sql = sql & " select a.id_activo_marca, "
	sql = sql & " b.id_activo_modelo "
	sql = sql & " from SUC_activo_marca a, "
	sql = sql & " suc_activo_modelos b "
	sql = sql & " where id_activo_tipo = '"&tipoElemento&"' "
	sql = sql & " and a.id_activo_marca = b.id_activo_marca "
	set rs = db.execute(sql)
	if not rs.eof then
		campoMarca = trim(rs(0))
		campoModelo = trim(rs(1))
		campoCargo = 6
	end if
end if
if campoCargo = "" then campoCargo = "16"

sql = ""
sql = sql & " exec SUC_prc_activos "
sql = sql & "'"&tipoFormulario&"', "
sql = sql & "'"&campoMarca&"', "
sql = sql & "'"&idSucursal&"', "
sql = sql & "'"&campoModelo&"', "
sql = sql & "'"&campoCargo&"', "
sql = sql & "'"&campoSerie&"', "
sql = sql & "'"&rotulo&"', "
sql = sql & "'"&nombreUsuario&"', "
sql = sql & "'"&correo&"', "
sql = sql & " '"&cantidadTotal&"' "
'response.write(sql)
set rs = db.execute(sql)


%>