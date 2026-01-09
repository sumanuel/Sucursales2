<!--#include file="../funciones.asp"-->
<%
grafico = trim(request("graficoDash"))
imprime = trim(request("imprime"))
fechaActual = date()
diaActual = formateaParaFecha(day(fechaActual))
mesActual = formateaParaFecha(month(fechaActual))
anioActual = year(fechaActual)
if grafico = "4" then
	if imprime = "0" then
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
			clase="table table-bordered table-condensed"
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
	else 
		sql = ""
		sql = sql & " select "
		sql = sql & " z.cod_bantotal, z.suc_nombre, "
		sql = sql & " (select sum(a.valor) from SUC_index_ips a where a.tipo = 1 and "
		sql = sql & " a.fecha = CAST(GETDATE() as date) and a.cod_bantotal = z.cod_bantotal) as pagos_prog_qty, "
		sql = sql & " (select sum(a.valor) from SUC_index_ips a where a.tipo = 2 and "
		sql = sql & " a.fecha = CAST(GETDATE() as date) and a.cod_bantotal = z.cod_bantotal) as pagos_prog_monto, "
		sql = sql & " (select sum(a.valor) from SUC_index_ips a where a.tipo = 3 and "
		sql = sql & " a.fecha = CAST(GETDATE() as date) and a.cod_bantotal = z.cod_bantotal) as pagos_real_qty, "
		sql = sql & " (select sum(a.valor) from SUC_index_ips a where a.tipo = 4 and "
		sql = sql & " a.fecha = CAST(GETDATE() as date) and a.cod_bantotal = z.cod_bantotal) as pagos_real_monto "
		sql = sql & " from ( "
		sql = sql & " select a.cod_bantotal, b.suc_nombre "
		sql = sql & " from SUC_index_ips a "
		sql = sql & " inner join SUC_sucursal b on a.cod_bantotal = b.cod_bantotal and b.suc_estado = 1 "
		sql = sql & " group by a.cod_bantotal, b.suc_nombre ) as z "
		sql = sql & " order by z.suc_nombre "

		set rs = db.execute(sql)
		if not rs.eof then
			clase="table table-bordered table-condensed"
			resultado = ""
			resultado = resultado & "<table class='"&clase&"'>"
			resultado = resultado & "<thead>"
			resultado = resultado & "<tr>"
			resultado = resultado & "<th>Cod BT</th>"
			resultado = resultado & "<th>Sucursal</th>"
			resultado = resultado & "<th>QTY Prog.</th>"
			resultado = resultado & "<th>$ Prog.</th>"
			resultado = resultado & "<th>QTY Realizados</th>"
			resultado = resultado & "<th>$ Realizados</th>"				
			resultado = resultado & "</tr>"
			resultado = resultado & "</thead>"
			resultado = resultado & "<tbody>"
			datos = rs.GetRows()
			For i = 0 to ubound(datos, 2)
				codBtt = trim(datos(0,i))
				sucursal  = trim(datos(1,i))
				qty_prog = trim(datos(2,i))
				monto_prog = trim(datos(3,i))
				qty_real = trim(datos(4,i))
				monto_real = trim(datos(5,i))
						
				resultado = resultado & "<tr>"
				resultado = resultado & "<td>"&codBtt&"</td>"
				resultado = resultado & "<td>"&sucursal&"</td>"
				resultado = resultado & "<td>"&qty_prog&"</td>"
				resultado = resultado & "<td>"&monto_prog&"</td>"
				resultado = resultado & "<td>"&qty_real&"</td>"
				resultado = resultado & "<td>"&monto_real&"</td>"
				resultado = resultado & "</tr>"	
			next
			resultado = resultado & "</tbody>"
			resultado = resultado & "</table>"
		else
			response.write("no existen datos")
		end if
		nombreArchivo = diaActual&"-"&mesActual&"-"&anioActual&" Pagos IPS.xls"
	end if 	
end if

if grafico="5" then
	if imprime = "1" then
		sql = ""
		sql = sql & " select sucursal, nombre_sucursal, "
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
			resultado = resultado & "<th>Cod BTT</th>"
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
			
			'datos = rs.GetRows()
			'For i = 0 to ubound(datos, 2)
			do while not rs.eof
				cod_btt = trim(rs("sucursal"))
				sucursal = trim(rs("nombre_sucursal"))
				pagoDia = FormatNumber(trim(rs("pago_dia")),0)
				montoPagoDia = FormatNumber(trim(rs("monto_pago_dia")),0)
				pagadosDia = FormatNumber(trim(rs("pagados_dia")),0)
				totalPagadosDia = FormatNumber(trim(rs("total_pagado_dia")),0)
				cumplimiento = FormatNumber(trim(rs("cumplimiento")),2)
				porcentajeCumplimientoMonto = FormatNumber(trim(rs("porcentaje_cumplimiento_monto")),2)
				rezago = FormatNumber(trim(rs("rezagos")),0)
				montoRezago = FormatNumber(trim(rs("monto_resagos")),0)
				rezagosPagados = FormatNumber(trim(rs("resagos_pagados")),0)
				rezagosMontosPagados = FormatNumber(trim(rs("resagos_monto_pagado")),0)
				porcentajeRezago = FormatNumber(trim(rs("porcentaje_resago")),2)
				porcentajeRezagoMonto = FormatNumber(trim(rs("resagos_porcentaje_monto")),2)

				resultado = resultado & "<tr>"
				resultado = resultado & "<td>"&cod_btt&"</td>"
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
			
			rs.MoveNext
  			loop
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
			
			'datos = rs.GetRows()			
			'For i = 0 to ubound(datos, 2)
			do while not rs.eof
				
				hora = cdate(trim(rs("hora")))
				programados = FormatNumber(trim(rs("total")),0)
				montoProgramado = FormatNumber(trim(rs("totalMonto")),0)
				pagados = FormatNumber(trim(rs("pagados")),0)
				montoPagado = FormatNumber(trim(rs("pagadosMonto")),0)
				cumplimiento = FormatNumber(trim(rs("cumplimiento")),2)
				montoCumplimiento = FormatNumber(trim(rs("cumplimientoMonto")),2)
				programadosRezago = FormatNumber(trim(rs("totalRezago")),0)
				montoProgramadoRezago = FormatNumber(trim(rs("totalRezagoMonto")),0)
				pagadosRezago = FormatNumber(trim(rs("pagadosRezago")),0)
				montoPagadoRezago = FormatNumber(trim(rs("pagadoRezagoMonto")),0)
				cumplimientoRezago = FormatNumber(trim(rs("cumplimentoRezago")),2)
				montoCumplimientoRezago = FormatNumber(trim(rs("cumplimientoRezagoMonto")),2)
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
			
			rs.MoveNext
  			loop
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
	sql = sql & " where tipo in (4) "
	sql = sql & " and fecha = cast(GETDATE() as date) "
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
				area = "BM2015"
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

if grafico = "7" then
	sql = ""
	sql = sql & " select "
	sql = sql & " sucursal, "
	sql = sql & " nombre_sucursal, "
	sql = sql & " apagar_qty, "
	sql = sql & " apagar_monto, "
	sql = sql & " pagado_qty, "
	sql = sql & " pagado_monto, "
	sql = sql & " cumpl_qty, "
	sql = sql & " cumpl_monto "
	sql = sql & " from indices..control_bonosM15_historico "
	sql = sql & " where fecha = cast(getdate() as date) "
	set rs = db.execute(sql)
	if not rs.eof then
		clase="table table-bordered table-condensed"		
		resultado = ""
		resultado = resultado & "<table class='"&clase&"'>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		resultado = resultado & "<th>Cod BTT</th>"
		resultado = resultado & "<th>Sucursal</th>"
		resultado = resultado & "<th>Qty Prog.</th>"
		resultado = resultado & "<th>$ Prog.</th>"
		resultado = resultado & "<th>Qty Realizados</th>"
		resultado = resultado & "<th>$ Realizados</th>"
		resultado = resultado & "<th>Cumplimiento</th>"		
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		datos = rs.GetRows()
		For i = 0 to ubound(datos, 2)
			cod_btt = trim(datos(0,i))
			sucursal = trim(datos(1,i))
			qty_apagar = FormatNumber(trim(datos(2,i)),0)
			monto_apagar = FormatNumber(trim(datos(3,i)),0)
			qty_pagado = FormatNumber(trim(datos(4,i)),0)
			monto_pagado = FormatNumber(trim(datos(5,i)),0)
			cumplimiento = trim(datos(6,i))			
			
			resultado = resultado & "<tr>"
			resultado = resultado & "<td>"&cod_btt&"</td>"
			resultado = resultado & "<td>"&sucursal&"</td>"
			resultado = resultado & "<td>"&qty_apagar&"</td>"
			resultado = resultado & "<td>"&monto_apagar&"</td>"
			resultado = resultado & "<td>"&qty_pagado&"</td>"
			resultado = resultado & "<td>"&monto_pagado&"</td>"
			resultado = resultado & "<td>"&cumplimiento&"</td>"
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