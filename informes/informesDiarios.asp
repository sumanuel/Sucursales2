<!--#include file="../funciones.asp"-->
<%

idUsuario = trim(request("id_usuario"))
idSucMain = trim(request("idSucMain"))
perfil = trim(request("perfil"))
tipoConsulta = trim(request("consulta"))
traeDatos = trim(request("traeDatos"))
idSucursal = trim(request("idSucursal"))
if traeDatos = "1" then
	fechaActual = trim(request("fecha"))
else
	fechaActual = now()
end if
diaFechaActual = formateaParaFecha(day(fechaActual))
mesFechaActual = formateaParaFecha(month(fechaActual))
anioFechaActual = year(fechaActual)
archivo = anioFechaActual&"-"&mesFechaActual&"-"&diaFechaActual&" Encuesta Aseo.xls"
if tipoConsulta = "1" then
	if traeDatos = "0" then
		sql = ""
		sql = sql & " select a.id_sucursal, "
		sql = sql & " b.suc_nombre, "
		sql = sql & " a.p1, "
		sql = sql & " a.p2, "
		sql = sql & " a.p3, "
		sql = sql & " a.p4, "
		sql = sql & " a.p5, "
		sql = sql & " a.p6, "
		sql = sql & " a.p7, "
		sql = sql & " a.p8, "
		sql = sql & " a.fecha_reg, "
		sql = sql & " a.hora_reg  "
		sql = sql & " from SUC_encuesta_aseo a, "
		sql = sql & " SUC_sucursal b "
		sql = sql & " where a.id_sucursal = b.id_sucursal "
		sql = sql & " and a.fecha_reg = '"&anioFechaActual&"-"&mesFechaActual&"-"&diaFechaActual&"' "
		if perfil = "1" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"')"
		end if
		if perfil = "2" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"') "
		end if
	end if
	if traeDatos = "1" then
		sql = ""
		sql = sql & " select a.id_sucursal, "
		sql = sql & " b.suc_nombre, "
		sql = sql & " a.p1, "
		sql = sql & " a.p2, "
		sql = sql & " a.p3, "
		sql = sql & " a.p4, "
		sql = sql & " a.p5, "
		sql = sql & " a.p6, "
		sql = sql & " a.p7, "
		sql = sql & " a.p8, "
		sql = sql & " a.fecha_reg, "
		sql = sql & " a.hora_reg  "
		sql = sql & " from SUC_encuesta_aseo a, "
		sql = sql & " SUC_sucursal b "
		sql = sql & " where a.id_sucursal = b.id_sucursal "
		sql = sql & " and a.fecha_reg = '"&anioFechaActual&"-"&mesFechaActual&"-"&diaFechaActual&"' "
		if perfil = "1" then
			sql = sql & " and b.id_sucursal = '"&idSucMain&"'"
		end if
		if perfil = "2" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"') "
		end if
	end if
	sql = sql & " order by b.suc_nombre "

	'response.write(sql)
	'response.end


	set rs = db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & " <table border=""1""> "
		resultado = resultado & " <thead> "
		resultado = resultado & " <tr> "
		resultado = resultado & " <th>Nombre Sucursal</th> "
		resultado = resultado & " <th>Pregunta 1</th> "
		resultado = resultado & " <th>Pregunta 2</th> "
		resultado = resultado & " <th>Pregunta 3</th> "
		resultado = resultado & " <th>Pregunta 4</th> "
		resultado = resultado & " <th>Pregunta 5</th> "
		resultado = resultado & " <th>Pregunta 6</th> "
		resultado = resultado & " <th>Pregunta 7</th> "
		resultado = resultado & " <th>Pregunta 8</th> "
		resultado = resultado & " </tr> "
		resultado = resultado & " </thead> "
		resultado = resultado & " <tbody> "
		for i=0 to ubound(datos,2)
			idSucursal = trim(datos(0,i))
			nombreSucursal = server.htmlencode(trim(datos(1,i)))
			p1 = server.htmlencode(trim(datos(2,i)))
			p2 = server.htmlencode(trim(datos(3,i)))
			p3 = server.htmlencode(trim(datos(4,i)))
			p4 = server.htmlencode(trim(datos(5,i)))
			p5 = server.htmlencode(trim(datos(6,i)))
			p6 = server.htmlencode(trim(datos(7,i)))
			p7 = server.htmlencode(trim(datos(8,i)))
			p8 = server.htmlencode(trim(datos(9,i)))
			resultado = resultado & " <tr> "
			resultado = resultado & " <td> "
			resultado = resultado & nombreSucursal
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p1
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p2
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p3
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p4
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p5
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p6
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p7
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p8
			resultado = resultado & " </td> "
			resultado = resultado & " </tr> "
		next
		resultado = resultado & " </tbody>"
		resultado = resultado & " </table>"
	else
		response.write("La sucursal no tiene datos")
	end if
end if

response.write(resultado)
' ////////////////// esto es para la salida y el nombre del archivo'
Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo %>