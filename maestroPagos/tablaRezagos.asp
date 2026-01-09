<div class="row-fluid">
	<div class="span4 offset4">
		<span class="label label-info">Rezagos</span>
	</div>
</div>
<div class="row-fluid">
	<div class="span12">
		<table id="tablaRezagos" class="table table-bordered table-hover table-condensed">
			<thead>
				<tr>
					<th rowspan="3">
						Mes
					</th>
					<th colspan="4">
						IPS
					</th>
					<th colspan="4">
						AFP
					</th>
				</tr>
				<tr>
					<th colspan="2">
						Disponible
					</th>
					<th colspan="2">
						Pagado
					</th>
					<th colspan="2">
						Disponible
					</th>
					<th colspan="2">
						Pagado
					</th>
				</tr>
				<tr>
					<th>
						Cantidad
					</th>
					<th>
						Total
					</th>
					<th>
						Cantidad
					</th>
					<th>
						Total
					</th>
					<th>
						Cantidad
					</th>
					<th>
						Total
					</th>
					<th>
						Cantidad
					</th>
					<th>
						Total
					</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
$(function(){
	var url='maestroPagos/datosTablaRezagos.asp';
	var datosTr='';
	$.when($.ajax(url)).done(function(data) {
		$.each( data.datos, function( key, valoresDatos ) {
			var nombreMes = valoresDatos.nombreMes;
			var mes = valoresDatos.mes;
			var Disp_IQty =  valoresDatos.Disp_IQty;
			var Disp_ITot =  valoresDatos.Disp_ITot;
			var Disp_AQty =  valoresDatos.Disp_AQty;
			var Disp_ATot =  valoresDatos.Disp_ATot;
			var Paga_IQty =  valoresDatos.Paga_IQty;
			var Paga_ITot =  valoresDatos.Paga_ITot;
			var Paga_AQty =  valoresDatos.Paga_AQty;
			var Paga_ATot =  valoresDatos.Paga_ATot;
			var Disp_IQtyNf =  valoresDatos.Disp_IQtyNf;
			var Disp_ITotNf =  valoresDatos.Disp_ITotNf;
			var Disp_AQtyNf =  valoresDatos.Disp_AQtyNf;
			var Disp_ATotNf =  valoresDatos.Disp_ATotNf;
			var Paga_IQtyNf =  valoresDatos.Paga_IQtyNf;
			var Paga_ITotNf =  valoresDatos.Paga_ITotNf;
			var Paga_AQtyNf =  valoresDatos.Paga_AQtyNf;
			var Paga_ATotNf =  valoresDatos.Paga_ATotNf;
			var claseTr = valoresDatos.claseTr;
			var claseTd = valoresDatos.claseTd;
			datosTr += '<tr class="'+claseTr+'">';
			datosTr += '<td>'+nombreMes+'</td>';
			datosTr += '<td id="disponibleIQty'+mes+'" data-valor="'+Disp_IQtyNf+'" class="'+claseTd+' numero">'+Disp_IQty+'</td>';
			datosTr += '<td id="disponibleICant'+mes+'" data-valor="'+Disp_ITotNf+'" class="'+claseTd+'">$<span class="numero">'+Disp_ITot+'</span></td>';
			datosTr += '<td id="pagadoIQty'+mes+'" data-valor="'+Disp_AQtyNf+'" class="'+claseTd+' numero">'+Disp_AQty+'</td>';
			datosTr += '<td id="pagadoICant'+mes+'" data-valor="'+Disp_ATotNf+'" class="'+claseTd+'">$<span class="numero">'+Disp_ATot+'</span></td>';
			datosTr += '<td id="disponibleAQty'+mes+'" data-valor="'+Paga_IQtyNf+'" class="'+claseTd+' numero">'+Paga_IQty+'</td>';
			datosTr += '<td id="disponibleACant'+mes+'" data-valor="'+Paga_ITotNf+'" class="'+claseTd+'">$<span class="numero">'+Paga_ITot+'</span></td>';
			datosTr += '<td id="pagadoAQty'+mes+'" data-valor="'+Paga_AQtyNf+'" class="'+claseTd+' numero">'+Paga_AQty+'</td>';
			datosTr += '<td id="pagadoACant'+mes+'" data-valor="'+Paga_ATotNf+'" class="'+claseTd+'">$<span class="numero">'+Paga_ATot+'</span></td>';
			datosTr += '</tr>';
		});
		$('#tablaRezagos tbody').append(datosTr);
		$('.numero').prettynumber();
	});	
});

</script>