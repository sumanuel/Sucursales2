<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuario"))
perfil = trim(request("perfil"))
tipoConsulta = trim(request("consulta"))
traeDatos = trim(request("traeDatos"))
idSucursal = trim(request("idSucursal"))

fecha = trim(request("fecha"))
if  fecha = "0" then 
	fecha = date()
	diaFecha = formateaParaFecha(day(fecha))
	mesFecha = formateaParaFecha(month(fecha))
	anioFecha = year(fecha)
	fecha = anioFecha&"-"&mesFecha&"-"&diaFecha
end if

if tipoConsulta = "1" then
	sql = ""
	sql = sql & " select c.suc_zonal_jefe as grupo, c.suc_zonal_ext as nombre_zonal, "
	sql = sql & " c.cod_bantotal, "
	sql = sql & " c.cod_sap, "
	sql = sql & " c.suc_nombre, "
	sql = sql & " c.suc_jeps, "
	sql = sql & " c.suc_jeps_rut, "
	sql = sql & " c.suc_jeps_dv, "
	sql = sql & " b.cargo, "
	sql = sql & " a.rut, "
	sql = sql & " a.dv, "
	sql = sql & " a.nombres, "
	sql = sql & " a.apep, "
	sql = sql & " a.apem, "
	sql = sql & " a.anexo, "
	sql = sql & " f.cod_bantotal as sucdest_cod_bantotal, "
	sql = sql & " f.cod_sap as sucdest_cod_sap, "
	sql = sql & " f.suc_nombre as sucdest_nombre, "
	sql = sql & " a.detalle "
	sql = sql & " from SUC_sucursal_dotacion a "
	sql = sql & " inner join SUC_sucursal_dotacion_cargos b on a.cargo = b.id_cargo "
	sql = sql & " inner join SUC_sucursal c on a.id_sucursal = c.id_sucursal "
	sql = sql & " left outer join SUC_sucursal f on a.id_sucursal_dest = f.id_sucursal "	
	if idSucursal <> "" then
		sql = sql & " where c.id_sucursal = '"&idSucursal&"' "
	else
		if perfil = "2" then
			sql = sql & " where  c.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"') "
		end if
		if perfil = "1" then
			sql = sql & " where c.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"') "
		end if
	end if

	'response.write(sql)
	'response.end

	set rs=db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & "<table>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		resultado = resultado & "<th>Grupo</th>"
		resultado = resultado & "<th>Nombre zonal</th>"
		resultado = resultado & "<th>Codigo bantotal</th>"
		resultado = resultado & "<th>Codigo Sap</th>"
		resultado = resultado & "<th>Nombre Sucursal</th>"
		resultado = resultado & "<th>Jeps</th>"
		resultado = resultado & "<th>Rut jeps</th>"
		resultado = resultado & "<th>Dv jeps</th>"
		resultado = resultado & "<th>Cargo</th>"
		resultado = resultado & "<th>Rut</th>"
		resultado = resultado & "<th>Dv</th>"
		resultado = resultado & "<th>Nombres</th>"
		resultado = resultado & "<th>App pat</th>"		
		resultado = resultado & "<th>App mat</th>"
		resultado = resultado & "<th>Anexo</th>"
		resultado = resultado & "<th>Sucursal destino cod bantotal</th>"
		resultado = resultado & "<th>Sucursal destino cod sap</th>"
		resultado = resultado & "<th>Sucursal destino nombre</th>"
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		for i=0 to ubound(datos,2)
			grupo = server.htmlencode(trim(datos(0,i)))
			nombreZonal = server.htmlencode(trim(datos(1,i)))
			codBantotal = trim(datos(2,i))
			codSap = trim(datos(3,i))
			nombreSucursal = server.htmlencode(trim(datos(4,i)))
			jeps = server.htmlencode(trim(datos(5,i)))
			rutJeps = trim(datos(6,i))
			dvJeps = trim(datos(7,i))
			cargo = server.htmlencode(trim(datos(8,i)))
			rut = trim(datos(9,i))
			dv = trim(datos(10,i))
			nombres = server.htmlencode(trim(datos(11,i)))
			apppat = server.htmlencode(trim(datos(12,i)))
			appmat = server.htmlencode(trim(datos(13,i)))
			anexo = trim(datos(14,i))
			sucCodBttDest = trim(datos(15,i))
			sucDestCodSap = trim(datos(16,i))
			nombreSucDestino = trim(datos(17,i))

			resultado = resultado & "<tr>"
			resultado = resultado & "<td>"&grupo&"</td>"
			resultado = resultado & "<td>"&nombreZonal&"</td>"
			resultado = resultado & "<td>"&codBantotal&"</td>"
			resultado = resultado & "<td>"&codSap&"</td>"
			resultado = resultado & "<td>"&nombreSucursal&"</td>"
			resultado = resultado & "<td>"&jeps&"</td>"
			resultado = resultado & "<td>"&rutJeps&"</td>"
			resultado = resultado & "<td>"&dvJeps&"</td>"
			resultado = resultado & "<td>"&cargo&"</td>"
			resultado = resultado & "<td>"&rut&"</td>"
			resultado = resultado & "<td>"&dv&"</td>"
			resultado = resultado & "<td>"&nombres&"</td>"
			resultado = resultado & "<td>"&apppat&"</td>"
			resultado = resultado & "<td>"&appmat&"</td>"
			resultado = resultado & "<td>"&anexo&"</td>"
			resultado = resultado & "<td>"&sucCodBttDest&"</td>"
			resultado = resultado & "<td>"&sucDestCodSap&"</td>"
			resultado = resultado & "<td>"&nombreSucDestino&"</td>"					
			resultado = resultado & "</tr>"
		next
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	else
		resultado = "No existen datos"
	end if
	if idSucursal <> "" then
		archivo = fecha&" Dotacion "&"CodBTT-"&codBantotal&".xls"
	else
		archivo = fecha&" Dotacion.xls"
	end if
end if
response.write(resultado)
Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo 
%>