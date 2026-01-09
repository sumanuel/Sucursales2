<%idRegional = trim(request("idRegional"))
idZonal = trim(request("idZonal"))%>
<div class="row-fluid">
	<div class="span12" id="divSucursales">
		<table id="tablaDatosSucursales" class="table table-bordered table-hover table-condensed">
			<thead>
				<tr>
					<th>
						Nombre Sucursal
					</th>
					<th>
						Jeps
					</th>
					<th>
						Emitidas
					</th>
					<th>
						Pagadas
					</th>
					<th>
						% Pagadas
					</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td colspan="5">
						<img src="img/loader.gif">
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<script>
var principal = $('#principalSucursal');
var idRegional = principal.attr('data-regional');
var idZonal = principal.attr('data-zonal');
var mes = principal.attr('data-mes');
var tipo = principal.attr('data-tipo');
var url = 'maestroPagos/datosSucursales.asp?idRegional='+idRegional+'&idZonal='+idZonal+'&mes='+mes+'&tipo='+tipo;
var tablaTr = '';
$.when($.ajax(url)).done(function(data) {
	$.each( data.datos, function( key, valoresDatos ) {
		var idCampo = valoresDatos.idCampo;
		var idSucursal = valoresDatos.idSucursal;
		var codBtt = valoresDatos.codBtt;
		var sucNombre = valoresDatos.sucNombre;
		var sucJeps = valoresDatos.sucJeps;
		var emitidoCantidad = valoresDatos.emitidoCantidad;
		var pagadoCantidad = valoresDatos.pagadoCantidad;
		var porcPag  = valoresDatos.porcPag;
		tablaTr += '<tr class="mano" onClick="seleccionaSucursal('+codBtt+')">';
		tablaTr += '<td>'+sucNombre+'</td>';
		tablaTr += '<td>'+sucJeps+'</td>';
		tablaTr += '<td class="numero">'+emitidoCantidad+'</td>';
		tablaTr += '<td class="numero">'+pagadoCantidad+'</td>';
		tablaTr += '<td>'+porcPag+'</td>';
		tablaTr += '</tr>';
	});
	$('#tablaDatosSucursales tbody').html(tablaTr);
	$('.numero').prettynumber();
});
function seleccionaSucursal(codBtt)
{
	$('#principalSucursal').attr('data-sucursal', codBtt);
	$('#divSucursales').slideUp('fast');
	var pagina, div, datos;
	pagina = 'maestroPagos/sucursal.asp';
	div = 'divSucursales';
	datos='';
	enviaDatos(pagina,div,datos);

}
</script>