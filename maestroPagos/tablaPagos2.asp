<!--#include file="../funciones.asp"-->
<%fechaActual = date()%>
<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span10 text-center">
				<span class="label label-info">
					Pagados en Sucursal Red fija
				</span>
			</div>
			<div class="span2 abreDatos1 mano" data-abierto="1">
				<span class="label label-important"> 
					<span id="icono1">
						<i class="icon-collapse"></i>
					</span>
					Mas datos
				</span>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12">
				<table class="table table-bordered table-condensed">
					<thead>
						<tr>
							<th rowspan="2">Pagos</th>
							<th colspan="2">Misma Sucursal</th>
							<th colspan="2">De otra Suc</th>
						</tr>
						<tr>
							<th>Qty</th>
							<th>Total $</th>
							<th>Qty</th>
							<th>Total $</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>Hoy</td>
							<td class="textoDerecha">
								<span id="pg-125" class="numero pagomsq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-126" class="numero pagomsm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-127" class="numero pagoosq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-128" class="numero pagoosm">0</span>
							</td>
						</tr>
						<tr>
							<td>Mañana</td>
							<td class="textoDerecha">
								<span id="pg-129" class="numero pagomsq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-130" class="numero pagomsm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-131" class="numero pagoosq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-132" class="numero pagoosm">0</span>
							</td>
						</tr>
						<tr>
							<td>Rezagos</td>
							<td class="textoDerecha">
								<span id="pg-133" class="numero pagomsq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-134" class="numero pagomsm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-135" class="numero pagoosq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-136" class="numero pagoosm">0</span>
							</td>
						</tr>
						<tr>
							<td>Total</td>
							<td class="textoDerecha">
								<strong><span id="pg-207" class="numero">0</span></strong>
							</td>
							<td class="textoDerecha">
								<strong>$<span id="pg-208" class="numero">0</span></strong>
							</td>
							<td class="textoDerecha">
								<strong><span id="pg-209" class="numero">0</span></strong>
							</td>
							<td class="textoDerecha">
								<strong>$<span id="pg-210" class="numero">0</span></strong>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="row-fluid masDatos1">
			<div class="span12">
				<table class="table table-bordered table-condensed">
					<thead>
						<tr>
							<th rowspan="2">Rezagos</th>
							<th colspan="2">Misma Sucursal</th>
							<th colspan="2">De otra Suc</th>
						</tr>
						<tr>
							<th>Qty</th>
							<th>Total $</th>
							<th>Qty</th>
							<th>Total $</th>
						</tr>
					</thead>
					<tbody>
						<%mes = DateAdd("m",0,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<tr>
							<td>
								<%=nombreMes%>
							</td>
							<td class="textoDerecha">
								<span id="pg-137" class="numero pago2msq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-138" class="numero pago2msm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-139" class="numero pago2osq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-140" class="numero pago2osm">0</span>
							</td>
						</tr>
						<%mes = DateAdd("m",-1,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<tr>
							<td>
								<%=nombreMes%>
							</td>
							<td class="textoDerecha">
								<span id="pg-141" class="numero pago2msq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-142" class="numero pago2msm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-143" class="numero pago2osq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-144" class="numero pago2osm">0</span>
							</td>
						</tr>
						<%mes = DateAdd("m",-2,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<tr>
							<td>
								<%=nombreMes%>
							</td>
							<td class="textoDerecha">
								<span id="pg-145" class="numero pago2msq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-146" class="numero pago2msm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-147" class="numero pago2osq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-148" class="numero pago2osm">0</span>
							</td>
						</tr>
						<!--<tr>
							<td>
								Total
							</td>
							<td class="textoDerecha">
								<strong><span id="totalPmsq" class="numero">0</span></strong>
							</td>
							<td class="textoDerecha">
								<strong>$<span id="totalPmsm" class="numero">0</span></strong>
							</td>
							<td class="textoDerecha">
								<strong><span id="totalPosq" class="numero">0</span></strong>
							</td>
							<td class="textoDerecha">
								<strong>$<span id="totalPosm" class="numero">0</span></strong>
							</td>
						</tr>-->
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('.masDatos1').hide('fast');
});
$('.abreDatos1').click(function() {
	var abierto = $(this).attr('data-abierto');
	if (abierto === '1')
	{
		$('.masDatos1').slideDown('slow');
		$('.abreDatos1').attr('data-abierto', '0');
		$('#icono1').html('<i class="icon-collapse-top"></i>');
	}
	else
	{
		$('.masDatos1').slideUp('fast');
		$('.abreDatos1').attr('data-abierto', '1');
		$('#icono1').html('<i class="icon-collapse"></i>');
	}
});
</script>