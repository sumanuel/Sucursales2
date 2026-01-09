<%valorFecha = trim(request("valorFecha"))%>
<div class="row-fluid">
	<div class="span12">
		<table  class="table table-bordered table-hover table-condensed" id="tablaDatosPagoCtas" data-fecha="<%=valorFecha%>">
			<thead>
				<tr>
					<th>
						Fecha
					</th>
					<th>
						Cantidad
					</th>
					<th>
						Monto
					</th>
				</tr>
			</thead>
			<tbody>
				
			</tbody>
		</table>	
	</div>
</div>
<script type="text/javascript">
$(function(){
	mes = $('#tablaDatosPagoCtas').attr('data-fecha');
	var url = 'maestroPagos/datosPagoCtas.asp?mes='+mes;
	var generaTr,trTotal;
	var sumaCantidad = 0;
	$.when($.ajax(url)).done(function(data) {
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
			generaTr += '<td class="valorCantidadPagoCta numero" data-valor="'+cantidad+'">';
			generaTr += cantidadF;
			generaTr += '</td>';
			generaTr += '<td class="valorMontoPagoCta" data-valor="'+monto+'">$<span class="numero">';
			generaTr += montoF;
			generaTr += '</span></td>';
			generaTr += '</tr>';
			trTotal = '<tr>';
			trTotal += '<td><strong>Total</strong></td>';
			trTotal += '<td class="valorTotalCantidad" data-valor="'+sumaCantidad+'"><strong><span class="numero">'+sumaCantidadF+'</span></strong></td>';
			trTotal += '<td class="valorTotalMonto" data-valor="'+sumaMonto+'"><strong>$<span class="numero">'+sumaMontoF+'</span></strong></td>';
			trTotal += '<tr>';
		});
		$('#tablaDatosPagoCtas tbody').append(generaTr+trTotal);
		$('.numero').prettynumber();	
	});
});
</script>