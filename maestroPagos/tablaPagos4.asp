<!--#include file="../funciones.asp"-->
<%fechaActual = date()%>
<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span10 text-center">
				<span class="label label-info">
					Pagados en Sucursal Red Movil Fija
				</span>
			</div>
			<div class="span2 abreDatos2 mano" data-abierto="1">
				<span class="label label-important"> 
					<span id="icono2">
						<i class="icon-collapse"></i>
					</span>
					Mas datos
				</span>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12">
				<table class="table table-bordered table-condensed">
					<tr>
						<th rowspan="3">Rezagos</th>
						<th colspan="2">Misma Sucursal</th>
						<!--<th colspan="2">Bloqueados</th>-->
						<th colspan="2">De otra Suc</th>
					</tr>
					<tr>
						<th>Qty</th>
						<th>Total $</th>
						<!--<th>Qty</th>
						<th>Total $</th>-->
						<th>Qty</th>
						<th>Total $</th>
					</tr>
					<tr>
						<td class="textoDerecha">
							<span id="rm-117" class="numero">0</span>
						</td>
						<td class="textoDerecha">
							$<span id="rm-118" class="numero">0</span>
						</td>
						<!--<td class="textoDerecha">
							<span id="rm-141" class="numero">0</span>
						</td>
						<td class="textoDerecha">
							$<span id="rm-142" class="numero">0</span>
						</td>-->
						<td class="textoDerecha">
							<span id="rm-119" class="numero">0</span>
						</td>
						<td class="textoDerecha">
							$<span id="rm-120" class="numero">0</span>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="row-fluid masDatos2 oculto">
			<div class="span12">
				<table class="table table-bordered table-condensed">
					<thead>
						<tr>
							<th rowspan="2">Rezagos</th>
							<th colspan="2">Misma Sucursal</th>
							<!--<th colspan="2">Bloqueados</th>-->
							<th colspan="2">De otra Suc</th>
						</tr>
						<tr>
							<th>Qty</th>
							<th>Total $</th>
							<!--<th>Qty</th>
							<th>Total $</th>-->
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
								<span id="rm-121" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-122" class="numero">0</span>
							</td>
							<!--<td class="textoDerecha">
								<span id="rm-143" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-144" class="numero">0</span>
							</td>-->
							<td class="textoDerecha">
								<span id="rm-123" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-124" class="numero">0</span>
							</td>
						</tr>
						<%mes = DateAdd("m",-1,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<tr>
							<td>
								<%=nombreMes%>
							</td>
							<td class="textoDerecha">
								<span id="rm-125" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-126" class="numero">0</span>
							</td>
							<!--<td class="textoDerecha">
								<span id="rm-145" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-146" class="numero">0</span>
							</td>-->
							<td class="textoDerecha">
								<span id="rm-127" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-128" class="numero">0</span>
							</td>
						</tr>
						<%mes = DateAdd("m",-2,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<tr>
							<td>
								<%=nombreMes%>
							</td>
							<td class="textoDerecha">
								<span id="rm-129" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-130" class="numero">0</span>
							</td>
							<!--<td class="textoDerecha">
								<span id="rm-147" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-148" class="numero">0</span>
							</td>-->
							<td class="textoDerecha">
								<span id="rm-131" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-132" class="numero">0</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('.masDatos2').hide('fast');
});

$('.abreDatos2').click(function() {
	var abierto = $(this).attr('data-abierto');
	if (abierto === '1')
	{
		$('.masDatos2').removeClass('oculto').slideDown('slow');
		$('.abreDatos2').attr('data-abierto', '0');
		$('#icono2').html('<i class="icon-collapse-top"></i>');

	}
	else
	{
		$('.masDatos2').slideUp('fast');
		$('.abreDatos2').attr('data-abierto', '1');
		$('#icono2').html('<i class="icon-collapse"></i>');
	}
});
</script>