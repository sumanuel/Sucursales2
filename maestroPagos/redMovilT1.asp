<%mes = trim(request("mes"))%>
<div class="row-fluid">
	<div class="span2 offset5">
		<span class="label label-info">
			Red movil
		</span>	
	</div>
</div>
<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span1 offset11">
				<span class="label label-info mano" id="muestraDetalleT1" data-tipo="1">
					<span id="iconoT1"><i class="icon-chevron-down"></i></span> Detalles
				</span>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12">
				<table id="tablaRedMovilT1" class="table table-bordered table-hover table-condensed" data-mes="<%=mes%>">
					<thead>
						<tr>
							<th rowspan="2">
								Pagos
							</th>
							<th colspan="2">
								Programados
							</th>
							<th colspan="2">
								En ruta
							</th>
							<th colspan="2">
								Pagados
							</th>
							<th colspan="2">
								Bloqueados
							</th>
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
					</thead>
					<tbody>
						
					</tbody>
				</table>	
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	mes = $('#tablaRedMovilT1').attr('data-fecha');
	var url = 'maestroPagos/datosRedMovilT1.asp?mes='+mes;
	var generaTr,trTotal;
	var sumaCantidad = 0;
	/*$.when($.ajax(url)).then(function(data) {
		$.each( data.datos, function( key, valoresDatos ) {
			var fecha = valoresDatos.fecha;
			var cantidad = valoresDatos.cantidad;
			var cantidadF = valoresDatos.cantidadF;
			var monto = valoresDatos.monto;
			var montoF = valoresDatos.montoF;
			var sumaCantidad = valoresDatos.sumaCantidad;
			var sumaCantidadF = valoresDatos.sumaCantidadF;
			var sumaMonto = valoresDatos.sumaMonto;
			var sumaMontoF = valoresDatos.sumaMontoF;
			
			generaTr += '<tr>';
			generaTr += '<td class="categoriaFechaPagoCta" data-valor="'+fecha+'">';
			generaTr += fecha;
			generaTr += '</td>';
			generaTr += '<td class="valorCantidadPagoCta" data-valor="'+cantidad+'">';
			generaTr += cantidadF;
			generaTr += '</td>';
			generaTr += '<td class="valorMontoPagoCta" data-valor="'+monto+'">$';
			generaTr += montoF;
			generaTr += '</td>';
			generaTr += '</tr>';
			trTotal = '<tr>';
			trTotal += '<td>Total</td>';
			trTotal += '<td class="valorTotalCantidad" data-valor="'+sumaCantidad+'">'+sumaCantidadF+'</td>';
			trTotal += '<td class="valorTotalMonto" data-valor="'+sumaMonto+'">$'+sumaMontoF+'</td>';
			trTotal += '<tr>';
		});
		$('#tablaDatosPagoCtas tbody').append(generaTr+trTotal);
	});*/
});
$('#muestraDetalleT1').click(function(){
	var tipo = $(this).attr('data-tipo');
	if (tipo ==='1')
	{
		$('#iconoT1').html('<i class="icon-chevron-up"></i>');
		$(this).attr('data-tipo', '2');
	}
	else
	{
		$('#iconoT1').html('<i class="icon-chevron-down"></i>');
		$(this).attr('data-tipo', '1');
	}
});
</script>