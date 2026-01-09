<!--#include file="../funciones.asp"-->
<%fechaActual = date()
var_anio=(year(fechaActual))-1%>
<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span12">
				<div class="span2 offset10 abreDatosBono2 mano" data-abierto="1">
					<span class="label label-important"> 
						<span id="iconoBono2">
							<i class="icon-collapse"></i>
						</span>
						Mas datos
					</span>
				</div>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12">
				<table class="table table-bordered table-condensed">
					<tr>
						<th colspan="5" class="textoCentrado">
							<span class="label label-info">
								Bono Marzo (<%=var_anio%>) - Clientes - RM en RF
							</span>
						</th>
						<th colspan="4" class="textoCentrado">
							<span class="label label-info">
								Bono Marzo (<%=var_anio%>) - No Clientes - RM en RF
							</span>
						</th>
					</tr>
					<tr>
						<th rowspan="3">Rezagos</th>
						<th colspan="2">Programados</th>
						<th colspan="2">Pagados</th>
						<th colspan="2">Programados</th>
						<th colspan="2">Pagados</th>
					</tr>
					<tr>
						<th>Qty</th>
						<th>Tot$</th>
						<th>Qty</th>
						<th>Tot$</th>
						<th>Qty</th>
						<th>Tot$</th>
						<th>Qty</th>
						<th>Tot$</th>
					</tr>
					<tr>
						<td class="textoDerecha">
							<span class="numero" id="bmm-117-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-118-1">0</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-119-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-120-1">0</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-133-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-134-1">0</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-135-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-136-1">0</span>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="row-fluid masDatosBono2 oculto">
			<div class="span12">
				<table class="table table-bordered table-condensed">
					<tr>
						<th rowspan="2">Rezagos</th>
						<th colspan="2">Programados</th>
						<th colspan="2">Pagados</th>
						<th colspan="2">Programados</th>
						<th colspan="2">Pagados</th>
					</tr>
					<tr>
						<th>Qty</th>
						<th>Tot$</th>
						<th>Qty</th>
						<th>Tot$</th>
						<th>Qty</th>
						<th>Tot$</th>
						<th>Qty</th>
						<th>Tot$</th>
					</tr>
					<%mes = DateAdd("m",0,fechaActual)
					nombreMes = primeraMayuscula(monthName(month(mes)))%>
					<tr>
						<td>
							<%=nombreMes%>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-121-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-122-1">0</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-123-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-124-1">0</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-137-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-138-1">0</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-139-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-140-1">0</span>
						</td>
					</tr>
					<%mes = DateAdd("m",-1,fechaActual)
					nombreMes = primeraMayuscula(monthName(month(mes)))%>
					<tr>
						<td>
							<%=nombreMes%>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-125-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-126-1">0</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-127-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-128-1">0</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-141-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-142-1">0</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-143-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-144-1">0</span>
						</td>
					</tr>
					<%mes = DateAdd("m",-2,fechaActual)
					nombreMes = primeraMayuscula(monthName(month(mes)))%>
					<tr>
						<td>
							<%=nombreMes%>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-129-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-130-1">0</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-131-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-132-1">0</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-145-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-146-1">0</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-147-1">0</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-148-1">0</span>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('.masDatosBono2').hide('fast');
});


$('.abreDatosBono2').click(function() {
	var abierto = $(this).attr('data-abierto');
	if (abierto === '1')
	{
		$('.masDatosBono2').removeClass('oculto').slideDown('slow');
		$('.abreDatosBono2').attr('data-abierto', '0');
		$('#iconoBono2').html('<i class="icon-collapse-top"></i>');

	}
	else
	{
		$('.masDatosBono2').slideUp('fast');
		$('.abreDatosBono2').attr('data-abierto', '1');
		$('#iconoBono2').html('<i class="icon-collapse"></i>');
	}
});
</script>