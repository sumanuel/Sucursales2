<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuario"))
perfil = trim(request("perfil"))
tipoConsulta = trim(request("consulta"))
traeDatos = trim(request("traeDatos"))
idSucursal = trim(request("idSucursal"))
fecha = trim(request("fecha"))

'Response.Write(cdate(fecha))
'Response.End()

if fecha <> "" then 
	fecha = cdate(fecha)
	diaFecha = formateaParaFecha(day(fecha))
	mesFecha = formateaParaFecha(month(fecha))
	anioFecha = year(fecha)
	fecha = anioFecha&"-"&mesFecha&"-"&diaFecha
end if
if tipoConsulta = "1" then
	'Saldo Caja Bt'
	if fecha = "" then
		sql = ""
		sql = sql & " select max(cast(fecha_operacion as date)) "
		sql = sql & " as fecha_registro "
		sql = sql & " from SUC_index_controller_saldo_caja_btt_det "
		set rs=db.execute(sql)
		if not rs.eof then
			fecha = cdate(trim(rs("fecha_registro")))
		end if	
		diaFecha = formateaParaFecha(day(fecha))
		mesFecha = formateaParaFecha(month(fecha))
		anioFecha = year(fecha)
		fecha = anioFecha&"-"&mesFecha&"-"&diaFecha
	end if
	sql = ""
	sql = sql & " SELECT a.id_registro, "
	sql = sql & " a.cod_sap, "
	sql = sql & " a.cod_bantotal, "
	sql = sql & " a.cod_sucursal, "
	sql = sql & " a.saldo, "
	sql = sql & " a.cajero, "
	sql = sql & " a.fecha_registro, "
	sql = sql & " b.suc_nombre, "
	sql = sql & " fecha_operacion "
	sql = sql & " FROM SUC_index_controller_saldo_caja_btt_det a, "
	sql = sql & " SUC_sucursal b "
	sql = sql & " where a.cod_sucursal = b.id_sucursal "
	if fecha = "" then
		sql = sql & " and cast(fecha_operacion as DATE) in (select MAX(cast(fecha_operacion as DATE)) from SUC_index_controller_saldo_caja_btt_det) "
	else
		sql = sql & " and cast(fecha_operacion as DATE) = '"&fecha&"' "
	end if
	if traeDatos = "1" then
		sql = sql & " and b.id_sucursal = '"&idSucursal&"'  "
	else
		if perfil = "1" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"')"
		end if
		if perfil = "2" then
			sql = sql & " and b.id_sucursal in "
			'sql = sql & " (select id_sucursal "
			'sql = sql & " from SUC_zonales_sucursal "
			'sql = sql & " where id_zonal = '"&idUsuario&"') "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"') "
		end if
	end if

	'response.write(sql)
	'response.end

	sql = sql & " order by suc_nombre"
	set rs=db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & "<table>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		resultado = resultado & "<th>Codigo bantotal</th>"
		resultado = resultado & "<th>Sucursal</th>"
		resultado = resultado & "<th>Cajero</th>"
		resultado = resultado & "<th>Saldo</th>"
		resultado = resultado & "<th>Fecha</th>"
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		for i=0 to ubound(datos,2)
			idRegistro = trim(datos(0,i))
			codSap = trim(datos(1,i))
			codBantotal = trim(datos(2,i))
			codSucursal = trim(datos(3,i))
			saldo = trim(datos(4,i))
			cajero = trim(datos(5,i))
			fechaRegistro = trim(datos(6,i))
			nombreSucursal = server.htmlencode(trim(datos(7,i)))
			fechaOp = cdate(trim(datos(8,i)))
			resultado = resultado & "<tr>"
			
			resultado = resultado & "<td>"&codBantotal&"</td>"
			resultado = resultado & "<td>"&nombreSucursal&"</td>"
			resultado = resultado & "<td>"&cajero&"</td>"
			resultado = resultado & "<td>"&saldo&"</td>"
			resultado = resultado & "<td>"&fechaOp&"</td>"
			resultado = resultado & "</tr>"
		next
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	end if
	if traeDatos = "1" then
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Saldo Caja Bantotal "&"CodBTT-"&codBantotal&".xls"
	else
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Saldo Caja Bantotal.xls"
	end if
end if

if tipoConsulta = "2" then
	if fecha = "" then
		sql = ""
		sql = sql & " select max(cast(fecha_registro as date)) as fecha_registro "
		sql = sql & " from SUC_sucursal_saldos_servibanca "
		sql = sql & " where fecha_registro is not NULL "
		set rs=db.execute(sql)
		if not rs.eof then
			fecha = cdate(trim(rs("fecha_registro")))
		end if	
		diaFecha = formateaParaFecha(day(fecha))
		mesFecha = formateaParaFecha(month(fecha))
		anioFecha = year(fecha)
		fecha = anioFecha&"-"&mesFecha&"-"&diaFecha
	end if
	sql = ""
	sql = sql & " select "
	sql = sql & " b.id_sucursal, "
	sql = sql & " b.suc_nombre, "
	sql = sql & " a.b_20000, "
	sql = sql & " a.b_10000, "
	sql = sql & " a.b_5000, "
	sql = sql & " a.b_2000, "
	sql = sql & " a.b_1000, "
	sql = sql & " a.m_500, "
	sql = sql & " a.m_100, "
	sql = sql & " a.m_50, "
	sql = sql & " a.m_10, "
	sql = sql & " a.m_5, "
	sql = sql & " a.m_1, "
	sql = sql & " a.suc_total, "
	sql = sql & " b.cod_bantotal, "
	sql = sql & " a.fecha_registro "
	sql = sql & " from SUC_sucursal_saldos_servibanca a, "
	sql = sql & " SUC_sucursal b "
	sql = sql & " where a.cod_plaza = b.cod_plaza "
	if fecha = "" then
		sql = sql & " and fecha_registro in (select MAX(fecha_registro) from SUC_sucursal_saldos_servibanca) "
	else
		sql = sql & " and cast(fecha_registro as DATE) = '"&fecha&"' "
	end if
	if traeDatos = "1" then
		sql = sql & " and b.id_sucursal = '"&idSucursal&"'  "
	else
		if perfil = "1" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"')"
		end if
		if perfil = "2" then
			sql = sql & " and b.id_sucursal in "
			'sql = sql & " (select id_sucursal "
			'sql = sql & " from SUC_zonales_sucursal "
			'sql = sql & " where id_zonal = '"&idUsuario&"') "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"') "
		end if
	end if
	sql = sql & " order by suc_nombre "
	set rs=db.execute(sql)
	if not rs.eof then
		'datos = rs.GetRows()
		resultado = ""
		resultado = resultado & "<table>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		resultado = resultado & "<th>Codigo bantotal</th>"
		resultado = resultado & "<th>Sucursal</th>"
		resultado = resultado & "<th>b 20000</th>"
		resultado = resultado & "<th>b 10000</th>"
		resultado = resultado & "<th>b 5000</th>"
		resultado = resultado & "<th>b 2000</th>"
		resultado = resultado & "<th>b 1000</th>"
		resultado = resultado & "<th>m 500</th>"
		resultado = resultado & "<th>m 100</th>"
		resultado = resultado & "<th>m 50</th>"
		resultado = resultado & "<th>m 10</th>"
		resultado = resultado & "<th>m 5</th>"
		resultado = resultado & "<th>m 1</th>"
		resultado = resultado & "<th>Total sucursal</th>"
		resultado = resultado & "<th>Fecha</th>"
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		'for i=0 to ubound(datos,2)
		do while not rs.eof
			idSucursal = trim(rs("id_sucursal"))
			nombreSucursal = server.htmlencode(trim(rs("suc_nombre")))
			b20000 = trim(rs("b_20000"))
			b10000 = trim(rs("b_10000"))
			b5000 = trim(rs("b_5000"))
			b2000 = trim(rs("b_2000"))
			b1000 = trim(rs("b_1000"))
			m500 = trim(rs("m_500"))
			m100 = trim(rs("m_100"))
			m50 = trim(rs("m_50"))
			m10 = trim(rs("m_10"))
			m5 = trim(rs("m_5"))
			m1 = trim(rs("m_1"))
			totalSucursal = trim(rs("suc_total"))
			codBantotal = trim(rs("cod_bantotal"))
			fechaRegistro = trim(rs("fecha_registro"))
			resultado = resultado & "<tr>"
			resultado = resultado & "<td>"&codBantotal&"</td>"
			resultado = resultado & "<td>"&nombreSucursal&"</td>"
			resultado = resultado & "<td>"&b20000&"</td>"
			resultado = resultado & "<td>"&b10000&"</td>"
			resultado = resultado & "<td>"&b5000&"</td>"
			resultado = resultado & "<td>"&b2000&"</td>"
			resultado = resultado & "<td>"&b1000&"</td>"
			resultado = resultado & "<td>"&m500&"</td>"
			resultado = resultado & "<td>"&m100&"</td>"
			resultado = resultado & "<td>"&m50&"</td>"
			resultado = resultado & "<td>"&m10&"</td>"
			resultado = resultado & "<td>"&m5&"</td>"
			resultado = resultado & "<td>"&m1&"</td>"
			resultado = resultado & "<td>"&totalSucursal&"</td>"
			resultado = resultado & "<td>"&fechaRegistro&"</td>"
			resultado = resultado & "</tr>"
		'next		
		rs.MoveNext
		loop
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	end if
	if traeDatos = "1" then
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Saldo ServiBanca "&"CodBTT-"&codBantotal&".xls"
	else
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Saldo ServiBanca.xls"
	end if
end if
if tipoConsulta = "3" then
	if fecha = "" then
		sql = ""
		sql = sql & " select max(cast(fecha as date)) as fecha_registro "
		sql = sql & " from SUC_remesas "
		sql = sql & " where fecha is not NULL "
		set rs=db.execute(sql)
		if not rs.eof then
			fecha = cdate(trim(rs("fecha_registro")))
		end if	
		diaFecha = formateaParaFecha(day(fecha))
		mesFecha = formateaParaFecha(month(fecha))
		anioFecha = year(fecha)
		fecha = anioFecha&"-"&mesFecha&"-"&diaFecha
	end if
	sql = ""
	sql = sql & " select b.id_sucursal, "
	sql = sql & " b.suc_nombre, "
	sql = sql & " a.monto_remesa, "
	sql = sql & " cast(fecha as date) as fecha, "
	sql = sql & " b.cod_bantotal "
	sql = sql & " from SUC_remesas a, "
	sql = sql & " SUC_sucursal b "
	sql = sql & " where a.cod_bt = b.cod_bantotal "
	if fecha = "" then
		sql = sql & " and fecha in (select max(cast(fecha as date)) as fecha_registro from SUC_remesas where fecha is not NULL) "
	else
		sql = sql & " and cast(fecha as DATE) = '"&fecha&"' "
	end if
	if traeDatos = "1" then
		sql = sql & " and b.id_sucursal = '"&idSucursal&"'  "
	else
		if perfil = "1" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"')"
		end if
		if perfil = "2" then
			sql = sql & " and b.id_sucursal in "
			'sql = sql & " (select id_sucursal "
			'sql = sql & " from SUC_zonales_sucursal "
			'sql = sql & " where id_zonal = '"&idUsuario&"') "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"') "
		end if
	end if
	sql = sql & " order by suc_nombre "
	set rs=db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & "<table>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		resultado = resultado & "<th>Codifo bantotal</th>"
		resultado = resultado & "<th>Sucursal</th>"
		resultado = resultado & "<th>Monto remesa</th>"
		resultado = resultado & "<th>Fecha</th>"
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		for i=0 to ubound(datos,2)
			idSucursal = trim(datos(0,i))
			nombreSucursal = server.htmlencode(trim(datos(1,i)))
			montoRemesa = trim(datos(2,i))
			fecha = trim(datos(3,i))
			codBantotal = trim(datos(4,i))
			resultado = resultado & "<tr>"
			resultado = resultado & "<td>"&codBantotal&"</td>"
			resultado = resultado & "<td>"&nombreSucursal&"</td>"
			resultado = resultado & "<td>"&montoRemesa&"</td>"
			resultado = resultado & "<td>"&fecha&"</td>"
			resultado = resultado & "</tr>"
		next
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	end if
	if traeDatos = "1" then
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Remesas "&nombreSucursal&".xls"
	else
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Remesas.xls"
	end if
end  if
response.write(resultado)
Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo 
%>