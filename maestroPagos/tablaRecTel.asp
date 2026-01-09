<%valorFecha = trim(request("valorFecha"))%>
<div class="row-fluid">
	<div class="span12">
		<table  class="table table-bordered table-hover table-condensed" id="tablaDatosRecTel" data-fecha="<%=valorFecha%>">
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
	mes = $('#tablaDatosRecTel').attr('data-fecha');
	var url = 'maestroPagos/datosRecTel.asp?mes='+mes;
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
			generaTr += '<td class="categoriaFecha" data-valor="'+fecha+'">';
			generaTr += fecha;
			generaTr += '</td>';
			generaTr += '<td class="valorCantidad numero" data-valor="'+cantidad+'">';
			generaTr += cantidadF;
			generaTr += '</td>';
			generaTr += '<td class="valorMonto" data-valor="'+monto+'">$<span class="numero">';
			generaTr += montoF;
			generaTr += '</span></td>';
			generaTr += '</tr>';
			trTotal = '<tr>';
			trTotal += '<td><strong>Total</strong></td>';
			trTotal += '<td class="valorTotalCantidad numero" data-valor="'+sumaCantidad+'"><strong>'+sumaCantidadF+'</strong></td>';
			trTotal += '<td class="valorTotalMonto" data-valor="'+sumaMonto+'"><strong>$<span class="numero">'+sumaMontoF+'</span></strong></td>';
			trTotal += '<tr>';
		});	
		$('#tablaDatosRecTel tbody').append(generaTr+trTotal);
		$('.numero').prettynumber();		
	});
});


</script>