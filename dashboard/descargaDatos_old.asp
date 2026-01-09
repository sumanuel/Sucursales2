<!--#include file="../funciones.asp"-->
<%grafico = trim(request("graficoDash"))
imprime = trim(request("imprime"))
fechaActual = date()
diaActual = formateaParaFecha(day(fechaActual))
mesActual = formateaParaFecha(month(fechaActual))
anioActual = year(fechaActual)
if grafico = "4" then
	sql = ""
	sql = sql & " select cast(hora as datetime) as hora, "
	sql = sql & " disponibles_c as programado, "
	sql = sql & " pagados_c as pagados, "
	sql = sql & " disponibles_m as monto, "
	sql = sql & " pagados_m as monto_pagado, "
	sql = sql & " cumplimiento "
	sql = sql & " from indices..control_ips2 "
	sql = sql & " where fecha = cast(GETDATE() as DATE) "
	sql = sql & " order by hora desc "
	set rs = db.execute(sql)
	if not rs.eof then
		clase="table table-bordered"
		resultado = ""
		resultado = resultado & "<table class='"&clase&"'>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		resultado = resultado & "<th>QTY Prog.</th>"
		resultado = resultado & "<th>QTY Realizados</th>"
		resultado = resultado & "<th>$ Prog.</th>"
		resultado = resultado & "<th>$ Realizados</th>"
		resultado = resultado & "<th>Cumplimiento</th>"
		resultado = resultado & "<th>Hora</th>"
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		datos = rs.GetRows()
		For i = 0 to ubound(datos, 2)
			hora = cdate(trim(datos(0,i)))
			programado = FormatNumber(trim(datos(1,i)),0)
			pagado = FormatNumber(trim(datos(2,i)), 0)
			monto = FormatNumber(trim(datos(3,i)),0)
			monto_pagado = FormatNumber(trim(datos(4,i)),0)
			cumplimiento = trim(datos(5,i))
			
			horaDato = formateaParaFecha(hour(hora))
			minutoDato = formateaParaFecha(minute(hora))
			hora = horaDato&":"&minutoDato
			resultado = resultado & "<tr>"
			resultado = resultado & "<td>"&programado&"</td>"
			resultado = resultado & "<td>"&pagado&"</td>"
			resultado = resultado & "<td>"&monto&"</td>"
			resultado = resultado & "<td>"&monto_pagado&"</td>"
			resultado = resultado & "<td>"&cumplimiento&"</td>"
			resultado = resultado & "<td>"&hora&"</td>"
			resultado = resultado & "</tr>"	
		next
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	else
		response.write("no existen datos")
	end if
	nombreArchivo = diaActual&"-"&mesActual&"-"&anioActual&" Pagos IPS.xls"
end if
if grafico="5" then
	if imprime = "1" then
		sql = ""
		sql = sql & " select nombre_sucursal, "
		sql = sql & " d_apagar_qty as pago_dia, "
		sql = sql & " d_apagar_monto as monto_pago_dia, "
		sql = sql & " d_pagado_qty as pagados_dia, "
		sql = sql & " d_pagado_monto as total_pagado_dia, "
		sql = sql & " d_cumpl_qty as cumplimiento, "
		sql = sql & " d_cumpl_monto as porcentaje_cumplimiento_monto, "
		sql = sql & " r_apagar_qty as rezagos, "
		sql = sql & " r_apagar_monto as monto_resagos, "
		sql = sql & " r_pagado_qty as resagos_pagados, "
		sql = sql & " r_pagado_monto as resagos_monto_pagado, "
		sql = sql & " r_cumpl_qty as porcentaje_resago, "
		sql = sql & " r_cumpl_monto as resagos_porcentaje_monto "
		sql = sql & " from indices..control_afp_historico "
		sql = sql & " where fecha = cast(GETDATE() as date) "
		set rs = db.execute(sql)
		if not rs.eof then
			resultado =""
			resultado = resultado & "<table class='"&clase&"'>"
			resultado = resultado & "<thead>"
			resultado = resultado & "<tr>"
			resultado = resultado & "<th>Sucursal</th>"
			resultado = resultado & "<th>Pago dia</th>"
			resultado = resultado & "<th>Monto pago dia</th>"
			resultado = resultado & "<th>Pagados dia</th>"
			resultado = resultado & "<th>Total pagados dia</th>"
			resultado = resultado & "<th>Cumplimiento</th>"
			resultado = resultado & "<th>% cumplimiento monto</th>"
			resultado = resultado & "<th>Rezago</th>"
			resultado = resultado & "<th>Monto rezagos</th>"
			resultado = resultado & "<th>Rezagos pagados</th>"
			resultado = resultado & "<th>Rezago montos pagados</th>"
			resultado = resultado & "<th>% rezago</th>"
			resultado = resultado & "<th>% rezago monto</th>"
			resultado = resultado & "</tr>"
			resultado = resultado & "</thead>"
			resultado = resultado & "<tbody>"
			datos = rs.GetRows()
			For i = 0 to ubound(datos, 2)
				sucursal = trim(datos(0,i))
				pagoDia = FormatNumber(trim(datos(1,i)),0)
				montoPagoDia = FormatNumber(trim(datos(2,i)),0)
				pagadosDia = FormatNumber(trim(datos(3,i)),0)
				totalPagadosDia = FormatNumber(trim(datos(4,i)),0)
				cumplimiento = FormatNumber(trim(datos(5,i)),2)
				porcentajeCumplimientoMonto = FormatNumber(trim(datos(6,i)),2)
				rezago = FormatNumber(trim(datos(7,i)),0)
				montoRezago = FormatNumber(trim(datos(8,i)),0)
				rezagosPagados = FormatNumber(trim(datos(9,i)),0)
				rezagosMontosPagados = FormatNumber(trim(datos(10,i)),0)
				porcentajeRezago = FormatNumber(trim(datos(11,i)),2)
				porcentajeRezagoMonto = FormatNumber(trim(datos(12,i)),2)
				resultado = resultado & "<tr>"
				resultado = resultado & "<td>"&sucursal&"</td>"
				resultado = resultado & "<td>"&pagoDia&"</td>"
				resultado = resultado & "<td>"&montoPagoDia&"</td>"
				resultado = resultado & "<td>"&pagadosDia&"</td>"
				resultado = resultado & "<td>"&totalPagadosDia&"</td>"
				resultado = resultado & "<td>"&cumplimiento&"</td>"
				resultado = resultado & "<td>"&porcentajeCumplimientoMonto&"</td>"
				resultado = resultado & "<td>"&rezago&"</td>"
				resultado = resultado & "<td>"&montoRezago&"</td>"
				resultado = resultado & "<td>"&rezagosPagados&"</td>"
				resultado = resultado & "<td>"&rezagosMontosPagados&"</td>"
				resultado = resultado & "<td>"&porcentajeRezago&"</td>"
				resultado = resultado & "<td>"&porcentajeRezagoMonto&"</td>"
				resultado = resultado & "</tr>"
			next
			resultado = resultado & "</tbody>"
			resultado = resultado & "</table>"
		else
			response.write("no existen datos")
		end if
	else
		sql = ""
		sql = sql & " select "
		sql = sql & " cast(hora as datetime) as hora, "
		sql = sql & " t_apago_d_qty as total, "
		sql = sql & " t_apago_d_monto as totalMonto, "
		sql = sql & " t_pagado_d_qty as pagados, "
		sql = sql & " t_pagado_d_monto as pagadosMonto, "
		sql = sql & " t_cumpl_d_qty as cumplimiento, "
		sql = sql & " t_cumpl_d_monto as cumplimientoMonto, "
		sql = sql & " t_apago_r_qty as totalRezago, "
		sql = sql & " t_apago_r_monto as totalRezagoMonto, "
		sql = sql & " t_pagado_r_qty as pagadosRezago, "
		sql = sql & " t_pagado_r_monto as pagadoRezagoMonto, "
		sql = sql & " t_cumpl_r_qty as cumplimentoRezago, "
		sql = sql & " t_cumpl_r_monto as cumplimientoRezagoMonto "
		sql = sql & " from indices..control_afp "
		sql = sql & " where fecha = cast(GETDATE() as DATE) "
		sql = sql & " order by hora desc "
		set rs = db.execute(sql)
		if not rs.eof then
			if imprime = "0" then 
				clase="table table-bordered table-condensed"
			else
				clase=""
			end if
			resultado = ""
			resultado = resultado & "<table class='"&clase&"'>"
			resultado = resultado & "<thead>"
			resultado = resultado & "<tr>"
			resultado = resultado & "<th>QTY AD Prog.</th>"
			resultado = resultado & "<th>QTY AD Realizados</th>"
			resultado = resultado & "<th>$ AD Prog.</th>"			
			resultado = resultado & "<th>$ AD Realizados</th>"
			'resultado = resultado & "<th>Cumplimiento</th>"
			'resultado = resultado & "<th>Cumplimiento monto</th>"
			resultado = resultado & "<th>QTY R Prog.</th>"
			resultado = resultado & "<th>QTY R Realizados</th>"
			resultado = resultado & "<th>$ R Prog.</th>"			
			resultado = resultado & "<th>$ R Realizados</th>"
			'resultado = resultado & "<th>Cumplimiento rezagos</th>"
			'resultado = resultado & "<th>Cumplimiento monto rezagos</th>"
			resultado = resultado & "<th>Hora</th>"
			resultado = resultado & "</tr>"
			resultado = resultado & "</thead>"
			resultado = resultado & "<tbody>"
			datos = rs.GetRows()
			For i = 0 to ubound(datos, 2)
				hora = cdate(trim(datos(0,i)))
				programados = FormatNumber(trim(datos(1,i)),0)
				montoProgramado = FormatNumber(trim(datos(2,i)),0)
				pagados = FormatNumber(trim(datos(3,i)),0)
				montoPagado = FormatNumber(trim(datos(4,i)),0)
				cumplimiento = FormatNumber(trim(datos(5,i)),2)
				montoCumplimiento = FormatNumber(trim(datos(6,i)),2)
				programadosRezago = FormatNumber(trim(datos(7,i)),0)
				montoProgramadoRezago = FormatNumber(trim(datos(8,i)),0)
				pagadosRezago = FormatNumber(trim(datos(9,i)),0)
				montoPagadoRezago = FormatNumber(trim(datos(10,i)),0)
				cumplimientoRezago = FormatNumber(trim(datos(11,i)),2)
				montoCumplimientoRezago = FormatNumber(trim(datos(12,i)),2)
				horaDato = formateaParaFecha(hour(hora))
				minutoDato = formateaParaFecha(minute(hora))
				hora = horaDato&":"&minutoDato

				resultado = resultado & "<tr>"
				resultado = resultado & "<td>"&programados&"</td>"
				resultado = resultado & "<td>"&pagados&"</td>"
				resultado = resultado & "<td>"&montoProgramado&"</td>"				
				resultado = resultado & "<td>"&montoPagado&"</td>"
				'resultado = resultado & "<td>"&cumplimiento&"</td>"
				'resultado = resultado & "<td>"&montoCumplimiento&"</td>"
				resultado = resultado & "<td>"&programadosRezago&"</td>"
				resultado = resultado & "<td>"&pagadosRezago&"</td>"
				resultado = resultado & "<td>"&montoProgramadoRezago&"</td>"				
				resultado = resultado & "<td>"&montoPagadoRezago&"</td>"
				'resultado = resultado & "<td>"&cumplimientoRezago&"</td>"
				'resultado = resultado & "<td>"&montoCumplimientoRezago&"</td>"
				resultado = resultado & "<td>"&hora&"</td>"
				resultado = resultado & "</tr>"
			next
			resultado = resultado & "</tbody>"
			resultado = resultado & "</table>"
		else
		response.write("no existen datos")
		end if
	end if
	nombreArchivo = diaActual&"-"&mesActual&"-"&anioActual&" Pagos AFP.xls"
end if
if grafico="6" then
	sql = ""
	sql = sql & " select cast(hora as datetime), "
	sql = sql & " disponibles_c, "
	sql = sql & " pagados_c, "
	sql = sql & " disponibles_m, "
	sql = sql & " pagados_m, "
	sql = sql & " cumplimiento, "
	sql = sql & " area "
	sql = sql & " from indices..control_ips "
	sql = sql & " where tipo in (2,3) "
	sql = sql & " and fecha = cast(GETDATE() as date) "
	sql = sql & " order by hora desc "
	set rs = db.execute(sql)
	if not rs.eof then
		if imprime = "0" then 
			clase="table table-bordered"
		else
			clase=""
		end if
		resultado = ""
		resultado = resultado & "<table class='"&clase&"'>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		resultado = resultado & "<th>QTY Prog.</th>"
		resultado = resultado & "<th>QTY Realizados</th>"
		resultado = resultado & "<th>$ Prog.</th>"
		resultado = resultado & "<th>$ Realizados</th>"
		resultado = resultado & "<th>Cumplimiento</th>"
		resultado = resultado & "<th>Hora</th>"
		resultado = resultado & "<th>Area</th>"
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		datos = rs.GetRows()
		For i = 0 to ubound(datos, 2)
			hora = cdate(trim(datos(0,i)))
			programado = FormatNumber(trim(datos(1,i)),0)
			pagado = FormatNumber(trim(datos(2,i)),0)
			monto = FormatNumber(trim(datos(3,i)),0)
			monto_pagado = FormatNumber(trim(datos(4,i)),0)
			cumplimiento = trim(datos(5,i))
			
			horaDato = formateaParaFecha(hour(hora))
			minutoDato = formateaParaFecha(minute(hora))
			hora = horaDato&":"&minutoDato
			area = trim(datos(6,i))
			if area = "bonoM" then 
				area = "B. Marzo"
			else
				area = "Bono"
			end if
			resultado = resultado & "<tr>"
			resultado = resultado & "<td>"&programado&"</td>"
			resultado = resultado & "<td>"&pagado&"</td>"
			resultado = resultado & "<td>"&monto&"</td>"
			resultado = resultado & "<td>"&monto_pagado&"</td>"
			resultado = resultado & "<td>"&cumplimiento&"</td>"
			resultado = resultado & "<td>"&hora&"</td>"
			resultado = resultado & "<td>"&area&"</td>"
			resultado = resultado & "</tr>"	
		next
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	else
		response.write("no existen datos")
	end if
	nombreArchivo = diaActual&"-"&mesActual&"-"&anioActual&" Pagos BONOS.xls"
end if
response.write(resultado)
if imprime="1" then
	Response.Charset = "UTF-8"
	Response.ContentType = "application/vnd.ms-excel" 
	Response.AddHeader "Content-Disposition", "attachment; filename=" & nombreArchivo 
end if
%>