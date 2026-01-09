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
	if fecha = "" then
		sql = ""		
		sql = sql & " select MAX(cast(fecha as date)) as fecha_registro "		
		sql = sql & " from indices..control_ips2_historico "
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
	sql = sql & " sucursal, "
	sql = sql & " nombre_sucursal, "
	sql = sql & " apagar_qty, "
	sql = sql & " apagar_monto, "
	sql = sql & " pagado_qty, "
	sql = sql & " pagado_monto, "
	sql = sql & " cumpl_qty, "
	sql = sql & " cumpl_monto, "
	sql = sql & " fecha "
	sql = sql & " from indices..control_ips2_historico a, "		
	sql = sql & " SUC_sucursal b "
	sql = sql & " where a.sucursal = b.cod_bantotal "
	if fecha <> "" then
		sql = sql & " and cast(fecha as DATE) = '"&fecha&"'"	
	end if
	if traeDatos = "1" then
		sql = sql & " and a.sucursal = (select cod_bantotal from SUC_sucursal where id_sucursal = '"&idSucursal&"')  "
	else
		if perfil = "1" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"')"
		end if
		if perfil = "2" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_zonales_sucursal "
			sql = sql & " where id_zonal = '"&idUsuario&"') "
		end if
	end if
	
	'Response.Write(sql)	
	'Response.End()

	set rs=db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & "<table>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		
		resultado = resultado & "<th>Cod BTT</th>"
		resultado = resultado & "<th>Sucursal</th>"		
		resultado = resultado & "<th>Apagar QTY</th>"
		resultado = resultado & "<th>Apagar $</th>"
		resultado = resultado & "<th>Pagado QTY</th>"
		resultado = resultado & "<th>Pagado $</th>"
		resultado = resultado & "<th>% Cumpl. QTY</th>"
		resultado = resultado & "<th>% Cumpl. $</th>"
		resultado = resultado & "<th>Fecha</th>"		
		
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		
		for i=0 to ubound(datos,2)
			cod_bantotal = trim(datos(0,i))
			sucursal = trim(datos(1,i))
			apagar_qty = trim(datos(2,i))
			apagar_monto = trim(datos(3,i))
			pagado_qty = trim(datos(4,i))
			pagado_monto = trim(datos(5,i))
			cumpl_qty = trim(datos(6,i))
			cumpl_monto = trim(datos(7,i))
			fecha_ips = trim(datos(8,i))			
			
			resultado = resultado & "<tr>"
			
			resultado = resultado & "<td>"&cod_bantotal&"</td>"
			resultado = resultado & "<td>"&sucursal&"</td>"
			resultado = resultado & "<td>"&apagar_qty&"</td>"
			resultado = resultado & "<td>"&apagar_monto&"</td>"
			resultado = resultado & "<td>"&pagado_qty&"</td>"
			resultado = resultado & "<td>"&pagado_monto&"</td>"
			resultado = resultado & "<td>"&cumpl_qty&"</td>"
			resultado = resultado & "<td>"&cumpl_monto&"</td>"			
			resultado = resultado & "<td>"&fecha_ips&"</td>"
						
			resultado = resultado & "</tr>"
		next
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	else
		resultado = ""
		resultado = resultado & "No existen registros"
	end if
	if traeDatos = "1" then
			archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" PagosIPS "&"CodBTT-"&cod_bantotal&".xls"
			'response.write(archivo)
			'response.end()
	else
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Pagos IPS.xls"
	end if
end if

if tipoConsulta = "2" then
	if fecha = "" then
		sql = ""		
		sql = sql & " select MAX(cast(fecha as date)) as fecha_registro "		
		sql = sql & " from indices..control_bonos_historico "
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
	sql = sql & " sucursal, "
	sql = sql & " nombre_sucursal, "
	sql = sql & " apagar_qty, "
	sql = sql & " apagar_monto, "
	sql = sql & " pagado_qty, "
	sql = sql & " pagado_monto, "
	sql = sql & " cumpl_qty, "
	sql = sql & " cumpl_monto, "			
	sql = sql & " fecha "
	sql = sql & " from indices..control_bonos_historico a, "		
	sql = sql & " SUC_sucursal b "
	sql = sql & " where a.sucursal = b.cod_bantotal "
	if fecha <> "" then
		sql = sql & " and cast(fecha as DATE) = '"&fecha&"'"	
	end if
	if traeDatos = "1" then
		sql = sql & " and a.sucursal = (select cod_bantotal from SUC_sucursal where id_sucursal = '"&idSucursal&"')  "
	else
		if perfil = "1" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"')"
		end if
		if perfil = "2" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_zonales_sucursal "
			sql = sql & " where id_zonal = '"&idUsuario&"') "
		end if
	end if
	
	'Response.Write(sql)	
	'Response.End()

	set rs=db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & "<table>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		
		resultado = resultado & "<th>Cod BTT</th>"
		resultado = resultado & "<th>Sucursal</th>"		
		resultado = resultado & "<th>Apagar QTY</th>"
		resultado = resultado & "<th>Apagar $</th>"
		resultado = resultado & "<th>Pagado QTY</th>"
		resultado = resultado & "<th>Pagado $</th>"
		resultado = resultado & "<th>% Cumpl. QTY</th>"
		resultado = resultado & "<th>% Cumpl. $</th>"		
		resultado = resultado & "<th>Fecha</th>"		
		
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		
		for i=0 to ubound(datos,2)
			cod_bantotal = trim(datos(0,i))
			sucursal = trim(datos(1,i))
			apagar_qty = trim(datos(2,i))
			apagar_monto = trim(datos(3,i))
			pagado_qty = trim(datos(4,i))
			pagado_monto = trim(datos(5,i))
			cumpl_qty = trim(datos(6,i))
			cumpl_monto = trim(datos(7,i))			
			fecha_bono = trim(datos(8,i))			
			
			resultado = resultado & "<tr>"
			
			resultado = resultado & "<td>"&cod_bantotal&"</td>"
			resultado = resultado & "<td>"&sucursal&"</td>"
			resultado = resultado & "<td>"&apagar_qty&"</td>"
			resultado = resultado & "<td>"&apagar_monto&"</td>"
			resultado = resultado & "<td>"&pagado_qty&"</td>"
			resultado = resultado & "<td>"&pagado_monto&"</td>"
			resultado = resultado & "<td>"&cumpl_qty&"</td>"
			resultado = resultado & "<td>"&cumpl_monto&"</td>"								
			resultado = resultado & "<td>"&fecha_bono&"</td>"
						
			resultado = resultado & "</tr>"
		next
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	else
		resultado = ""
		resultado = resultado & "No existen registros"
	end if
	if traeDatos = "1" then
			archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" PagosBONOS "&"CodBTT-"&cod_bantotal&".xls"
	else
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Pagos BONOS.xls"
	end if
	
end if

if tipoConsulta = "3" then
	if fecha = "" then
		sql = ""		
		sql = sql & " select MAX(cast(fecha as date)) as fecha_registro "		
		sql = sql & " from indices..control_afp_historico "
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
	sql = sql & " sucursal, "
	sql = sql & " nombre_sucursal, "
	sql = sql & " d_apagar_qty, "
	sql = sql & " d_apagar_monto, "
	sql = sql & " d_pagado_qty, "
	sql = sql & " d_pagado_monto, "
	sql = sql & " d_cumpl_qty, "
	sql = sql & " d_cumpl_monto, "
	sql = sql & " r_apagar_qty, "
	sql = sql & " r_apagar_monto, "
	sql = sql & " r_pagado_qty, "
	sql = sql & " r_pagado_monto, "
	sql = sql & " r_cumpl_qty, "
	sql = sql & " r_cumpl_monto, "		
	sql = sql & " fecha "
	sql = sql & " from indices..control_afp_historico a, "		
	sql = sql & " SUC_sucursal b "
	sql = sql & " where a.sucursal = b.cod_bantotal "
	if fecha <> "" then
		sql = sql & " and cast(fecha as DATE) = '"&fecha&"'"	
	end if
	if traeDatos = "1" then
		sql = sql & " and a.sucursal = (select cod_bantotal from SUC_sucursal where id_sucursal = '"&idSucursal&"')  "
	else
		if perfil = "1" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"')"
		end if
		if perfil = "2" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_zonales_sucursal "
			sql = sql & " where id_zonal = '"&idUsuario&"') "
		end if
	end if
	
	'Response.Write(sql)	
	'Response.End()
	set rs=db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & "<table>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		
		resultado = resultado & "<th>Cod BTT</th>"
		resultado = resultado & "<th>Sucursal</th>"		
		resultado = resultado & "<th>Diario Apagar QTY</th>"
		resultado = resultado & "<th>Diario Apagar $</th>"
		resultado = resultado & "<th>Diario Pagado QTY</th>"
		resultado = resultado & "<th>Diario Pagado $</th>"
		resultado = resultado & "<th>Diario % Cumpl. QTY</th>"
		resultado = resultado & "<th>Diario % Cumpl. $</th>"
		resultado = resultado & "<th>Rezagado Apagar QTY</th>"
		resultado = resultado & "<th>Rezagado Apagar $</th>"
		resultado = resultado & "<th>Rezagado Pagado QTY</th>"
		resultado = resultado & "<th>Rezagado Pagado $</th>"
		resultado = resultado & "<th>Rezagado % Cumpl. QTY</th>"
		resultado = resultado & "<th>Rezagado % Cumpl. $</th>"
		resultado = resultado & "<th>Fecha</th>"		
		
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		
		for i=0 to ubound(datos,2)
			cod_bantotal = trim(datos(0,i))
			sucursal = trim(datos(1,i))
			d_apagar_qty = trim(datos(2,i))
			d_apagar_monto = trim(datos(3,i))
			d_pagado_qty = trim(datos(4,i))
			d_pagado_monto = trim(datos(5,i))
			d_cumpl_qty = trim(datos(6,i))
			d_cumpl_monto = trim(datos(7,i))
			r_apagar_qty = trim(datos(8,i))
			r_apagar_monto = trim(datos(9,i))
			r_pagado_qty = trim(datos(10,i))
			r_pagado_monto = trim(datos(11,i))
			r_cumpl_qty = trim(datos(12,i))
			r_cumpl_monto = trim(datos(13,i))
			fecha_afp = trim(datos(14,i))			
			
			resultado = resultado & "<tr>"
			
			resultado = resultado & "<td>"&cod_bantotal&"</td>"
			resultado = resultado & "<td>"&sucursal&"</td>"
			resultado = resultado & "<td>"&d_apagar_qty&"</td>"
			resultado = resultado & "<td>"&d_apagar_monto&"</td>"
			resultado = resultado & "<td>"&d_pagado_qty&"</td>"
			resultado = resultado & "<td>"&d_pagado_monto&"</td>"
			resultado = resultado & "<td>"&d_cumpl_qty&"</td>"
			resultado = resultado & "<td>"&d_cumpl_monto&"</td>"			
			resultado = resultado & "<td>"&r_apagar_qty&"</td>"
			resultado = resultado & "<td>"&r_apagar_monto&"</td>"
			resultado = resultado & "<td>"&r_pagado_qty&"</td>"
			resultado = resultado & "<td>"&r_pagado_monto&"</td>"
			resultado = resultado & "<td>"&r_cumpl_qty&"</td>"
			resultado = resultado & "<td>"&r_cumpl_monto&"</td>"			
			resultado = resultado & "<td>"&fecha_afp&"</td>"
						
			resultado = resultado & "</tr>"
		next
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	else
		resultado = ""
		resultado = resultado & "No existen registros"
	end if
	if traeDatos = "1" then
			archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" PagosAFP "&"CodBTT-"&cod_bantotal&".xls"
	else
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Pagos AFP.xls"
	end if
end if

response.write(resultado)
Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo 

%>