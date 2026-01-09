<!--#include file="../funciones.asp"-->
<%tipoConsulta = trim(request("tipoConsulta"))
if tipoConsulta = "" then tipoConsulta = "1"
subConsulta = trim(request("subConsulta"))%>
<div class="row-fluid">
	<div class="span3 text-centered">
		
		<span class="icon-stack icon-2x iconoDescargaInforme diario mano ayuda" data-placement="right" data-original-title="Descargar informe" data-tipoConsulta="<%=tipoConsulta%>">
			<i class="icon-check-empty icon-stack-base icon-2x"></i>
			<i class="icon-cloud-download icon-2x"></i>
		</span>
		<span class="icon-stack icon-2x cambiaMonto mano ayuda" data-placement="right" data-original-title="Monto" data-subConsulta="<%=subConsulta%>" data-tipoConsulta="<%=tipoConsulta%>">
			<i class="icon-check-empty icon-stack-base"></i>
			<i class="icon-money"></i>
		</span>
	<%if tipoConsulta = "1" then%>
			<span class="icon-stack icon-2x cambiaAcumulado ayuda mano" data-placement="right" data-original-title="Informe acumulado" data-tipoConsulta="<%=tipoConsulta%>">
				<i class="icon-check-empty icon-stack-base"></i>
				<i class="icon-calendar"></i>
			</span>
	<%else%>
			<span class="icon-stack icon-2x ayuda cambiaDiario mano" data-placement="right" data-original-title="Informe diario" data-tipoConsulta="<%=tipoConsulta%>">
				<i class="icon-check-empty icon-stack-base"></i>
				<i class="icon-calendar-empty"></i>
			</span>
	<%end if%>
		<span class="icon-stack icon-2x  ayuda cambiaGrafico mano" data-placement="right" data-original-title="Grafico" data-tipoConsulta="<%=tipoConsulta%>">
			<i class="icon-check-empty icon-stack-base"></i>
			<i class="icon-bar-chart"></i>
		</span>
	</div>
	<div class="span2">
		<span class="icon-stack icon-2x ayuda mano downloadFoco hidden" data-placement="right" data-original-title="Descargar">
			<i class="icon-check-empty icon-stack-base"></i>
			<i class="icon-cloud-download"></i>
		</span>
        <span class="icon-stack ayuda mano icon-2x muestraBotonFoco" data-placement="right" data-original-title="Sucursales Foco"> 
			<i class="icon-check-empty icon-stack-base"></i>
			<i class="icon-trophy"></i>
		</span>
		<span class="icon-stack icon-2x  ayuda mano boton hidden" data-placement="right" data-original-title="Afiliaciones" data-tipoconsulta="1">
			<i class="icon-check-empty icon-stack-base"></i>
			<i class="icon-puzzle-piece icono"></i>
		</span>        
	</div>
</div>
<div class="row-fluid">
	<div class="span12 focoSucursal hidden" id="focoSucursal"></div>
</div>
<div class="row-fluid">
	<div class="span12 muestraTabla">
		<%if tipoConsulta = "1" then
			if subConsulta = "1" then
				prefijo = "_monto"
			else
				prefijo = ""
			end if
			base = "SUC_transacciones_diarias"
			
		end if
		if tipoConsulta = "2" then
			if subConsulta = "1" then
				prefijo = "_monto"
			else
				prefijo = ""
			end if
			base = "SUC_transacciones_acumuladas"
		end if
		sql = ""
		sql = sql & " select a.cod_sucursal, "
		sql = sql & " nombre_sucursal, "
		sql = sql & " pagos2"&prefijo&", "
		sql = sql & " ppaa"&prefijo&", "
		sql = sql & " leasing"&prefijo&", "
		sql = sql & " nominas"&prefijo&", "
		sql = sql & " recCred"&prefijo&", "
		sql = sql & " trasCaja"&prefijo&", "
		sql = sql & " ingCaja"&prefijo&", "
		sql = sql & " creSocial"&prefijo&", "
		sql = sql & " reDistr"&prefijo&", "
		sql = sql & " pagosAFP"&prefijo&", "
		sql = sql & " pagosIPS"&prefijo&", "
		sql = sql & " licencias"&prefijo&", "
		sql = sql & " colCred"&prefijo&", "
		sql = sql & " CONVERT(DATETIME, CONVERT(CHAR(8), fecha)) as fecha"', "
		'sql = sql & " colCred"&prefijo&""
		sql = sql & " from "&base&" a, "
		sql = sql & " SUC_sucursal b "
		sql = sql & " where "
		sql = sql & " CONVERT(DATETIME, CONVERT(CHAR(8), fecha)) = "
		sql = sql & " ( select max(CONVERT(DATETIME, CONVERT(CHAR(8), fecha))) "
		sql = sql & " from "&base&") "
		sql = sql & " and a.cod_sucursal = b.cod_bantotal "
		sql = sql & " and b.suc_estado = 1 "
		sql = sql & " order by nombre_sucursal asc"
		'response.write(sql)
		'response.end
		set rs = db.execute(sql)
		if not rs.eof then
			datos = rs.GetRows()
			resultado = ""
			resultado = resultado & "<table id='datatable' class='table table-bordered table-hover table-condensed'>"
			resultado = resultado & "<thead>"
			resultado = resultado & "<tr>"
			resultado = resultado & "<th>BT</th>"
			resultado = resultado & "<th>Sucursal</th>"			
			resultado = resultado & "<th>Pagos IPS</th>"
			resultado = resultado & "<th>Pagos AFP</th>"			
			resultado = resultado & "<th>Rec. Leasing</th>"
			resultado = resultado & "<th>Rec. Nóminas EFT</th>"
			resultado = resultado & "<th>Rec. Cr&eacute;dito Efectivo</th>"
			resultado = resultado & "<th>Pago Cr&eacute;dito Efectivo</th>"
			resultado = resultado & "<th>Cr&eacute;dito Colocado</th>"
			resultado = resultado & "<th>Pagos 2%</th>"
			resultado = resultado & "<th>Pagos PPAA</th>"
			resultado = resultado & "<th>Rec. por Distribuir</th>"			
			resultado = resultado & "<th>Pago Licencias</th>"
			resultado = resultado & "<th>Traspaso Cajas</th>"
			resultado = resultado & "<th>Ingreso Caja</th>"		
			resultado = resultado & "</tr>"
			resultado = resultado & "</thead>"
			resultado = resultado & "<tbody>"
			for i=0 to ubound(datos,2)
				codSucursal = trim(datos(0,i))
				nombreSucursal = server.htmlencode(trim(datos(1,i)))
				pagos2 =trim(datos(2,i))
				ppaa =trim(datos(3,i))
				leasing =trim(datos(4,i))
				nominas =trim(datos(5,i))
				recCred =trim(datos(6,i))
				trasCaja =trim(datos(7,i))
				ingCaja =trim(datos(8,i))
				creSocial =trim(datos(9,i))
				reDistr =trim(datos(10,i))
				pagosAFP =trim(datos(11,i))
				pagosIPS =trim(datos(12,i))
				licencias =trim(datos(13,i))
				colCred =trim(datos(14,i))
				fecha = trim(datos(15,i))
				resultado = resultado & "<tr>"
				resultado = resultado & "<td>"&codSucursal&"</td>"
				resultado = resultado & "<td>"&nombreSucursal&"</td>"
				resultado = resultado & "<td class='numero'>"&pagosIPS&"</td>"
				resultado = resultado & "<td class='numero'>"&pagosAFP&"</td>"								
				resultado = resultado & "<td class='numero'>"&leasing&"</td>"
				resultado = resultado & "<td class='numero'>"&nominas&"</td>"
				resultado = resultado & "<td class='numero'>"&recCred&"</td>"
				resultado = resultado & "<td class='numero'>"&creSocial&"</td>"
				resultado = resultado & "<td class='numero'>"&colCred&"</td>"
				resultado = resultado & "<td class='numero'>"&pagos2&"</td>"
				resultado = resultado & "<td class='numero'>"&ppaa&"</td>"							
				resultado = resultado & "<td class='numero'>"&reDistr&"</td>"				
				resultado = resultado & "<td class='numero'>"&licencias&"</td>"
				resultado = resultado & "<td class='numero'>"&trasCaja&"</td>"
				resultado = resultado & "<td class='numero'>"&ingCaja&"</td>"	
				resultado = resultado & "</tr>"
			next
			resultado = resultado & "</tbody>"
			resultado = resultado & "</table>"
			response.write(resultado)
			diaFecha =  WeekDayName(WeekDay(fecha))
			dia = day(fecha)
			mesFecha = monthname(month(fecha))
			response.write("<span class='alert-info'>Datos correspondientes a la fecha: <strong>"&fecha&" ("&diaFecha&", "&dia&" de "&mesFecha&")</strong></span>")
		end if%>
	</div>
</div>
<div class="row-fluid hidden" id="datosFocoDiv">
	<div class="span12 hidden" id="datosFoco"></div>
</div>
<div class="row-fluid hidden" id="graficoAfiliacionesEspecialDiv">
	<div class="span12 hidden" id="graficoAfiliacionesEspecial"></div>
</div>

<link href="css/tablaSort.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="js/jquery.dataTables.js"></script>
<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>
<script type="text/javascript" src="js/transacciones.js"></script>