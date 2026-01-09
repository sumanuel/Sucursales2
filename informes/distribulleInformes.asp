<%idSucursal = trim(request("idSucursal"))
traeDatos = trim(request("traeDatos"))
tipoConsulta = trim(request("tipoConsulta"))
consulta = trim(request("consulta"))
fecha = trim(request("fecha"))
perfil = trim(request("perfil"))
id_usuario = trim(request("id_usuario"))
idSucMain = trim(request("idSucMain"))

'response.write(traeDatos)
'response.end()


if tipoConsulta = "1" then
	response.redirect("informesDiarios.asp?idSucursal="&idSucursal&"&traeDatos="&traeDatos&"&consulta="&consulta&"&fecha="&fecha&"&perfil="&perfil&"&id_usuario="&id_usuario&"&idSucMain="&idSucMain)
end if
if tipoConsulta = "2" then
	response.redirect("informesReclamos.asp?idSucursal="&idSucursal&"&traeDatos="&traeDatos&"&consulta="&consulta&"&fecha="&fecha)
end if
if tipoConsulta = "3" then
	response.redirect("informesLM.asp?idSucursal="&idSucursal&"&traeDatos="&traeDatos&"&consulta="&consulta&"&fecha="&fecha)
end if
if tipoConsulta = "4" then
	response.redirect("informesControl.asp?idSucursal="&idSucursal&"&traeDatos="&traeDatos&"&consulta="&consulta&"&fecha="&fecha)
end if
if tipoConsulta = "5" then
	response.redirect("informesPagos.asp?idSucursal="&idSucursal&"&traeDatos="&traeDatos&"&consulta="&consulta&"&fecha="&fecha)
end if
if tipoConsulta = "6" then
	response.redirect("informesCreditos.asp?idSucursal="&idSucursal&"&traeDatos="&traeDatos&"&consulta="&consulta&"&fecha="&fecha)
end if
if tipoConsulta = "7" then
	response.redirect("informesDotacion.asp?idSucursal="&idSucursal&"&traeDatos="&traeDatos&"&consulta="&consulta&"&fecha="&fecha)
end if
if tipoConsulta = "8" then
	response.redirect("informesAfiliaciones.asp?idSucursal="&idSucursal&"&traeDatos="&traeDatos&"&consulta="&consulta&"&fecha="&fecha)
end if
if tipoConsulta = "9" then 'Asistencia de Personal
	response.redirect("informesAsistenciaPersonal.asp?idSucursal="&idSucursal&"&traeDatos="&traeDatos&"&consulta="&consulta&"&fecha="&fecha)
end if
if tipoConsulta = "10" then'detalleOperacional'
	if consulta = "1" then
		response.redirect("../sucursales/informeDetalle.asp")
	end if
	if consulta = "2" then
		response.redirect("../sucursales/informeDetalleComercial.asp")
	end if
	if consulta = "3" then
		response.redirect("../sucursales/informeDetalleControl.asp")
	end if
end if
%>