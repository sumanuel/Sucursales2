<!--#include file="../funciones.asp"-->
<%totales = trim(request("totales"))%>
<div class="row-fluid">
	<div class="span12">
		<table id="tablaDisponibles" class="table table-bordered table-hover table-condensed" data-totales="<%=totales%>">
			<thead>
				<tr>
					<th rowspan="2"></th>
					<th colspan="2">
						Disponible
					</th>
					<th colspan="2">
						Pagado
					</th>
				</tr>
				<tr>
					<th>
						Qty
					</th>
					<th>
						Monto
					</th>
					<th>
						Qty
					</th>
					<th>
						Monto
					</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
$(function(){
	var totales = $('#tablaDisponibles').attr('data-totales');
	var url='maestroPagos/datosTablaDisponible.asp?totales='+totales;
	var datosTr='';
	$.when($.ajax(url)).done(function(data) {
		$.each( data.datos, function( key, valoresDatos ) {
			var pago = valoresDatos.pago;
			var disponibleCantidad =  valoresDatos.disponibleCantidad;
			var disponibleCantidadNf =  valoresDatos.disponibleCantidadNf;
			var disponibleMonto =  valoresDatos.disponibleMonto;
			var disponibleMontoNf =  valoresDatos.disponibleMontoNf;
			var pagadoCantidad =  valoresDatos.pagadoCantidad;
			var pagadoCantidadNf =  valoresDatos.pagadoCantidadNf;
			var pagadoMonto =  valoresDatos.pagadoMonto;
			var pagadoMontoNf =  valoresDatos.pagadoMontoNf;
			var claseTr = valoresDatos.claseTr;
			var claseTd = valoresDatos.claseTd;
			datosTr += '<tr class="'+claseTr+'">';
			datosTr += '<td>'+pago+'</td>';
			datosTr += '<td id="disponibleCantidad'+key+'" data-valor="'+disponibleCantidadNf+'" class="'+claseTd+' numero">'+disponibleCantidad+'</td>';
			datosTr += '<td id="disponibleMonto'+key+'" data-valor="'+disponibleMontoNf+'" class="'+claseTd+'">$<span class="numero">'+disponibleMonto+'</span></td>';
			datosTr += '<td id="pagadoCantidad'+key+'" data-valor="'+pagadoCantidadNf+'" class="'+claseTd+' numero">'+pagadoCantidad+'</td>';
			datosTr += '<td id="pagadoMonto'+key+'" data-valor="'+pagadoMontoNf+'" class="'+claseTd+'"><span class="numero">'+pagadoMonto+'</span></td>';
			datosTr += '</tr>';
		});
		$('#tablaDisponibles tbody').append(datosTr);
		$('.numero').prettynumber();
	});	
});
</script>