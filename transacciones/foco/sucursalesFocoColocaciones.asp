<!--#include file="../../funciones.asp"-->
<div class="row-fluid">
	<div class="span12">
		<table class="table table-bordered table-hover table-condensed" id="tablaSucursalesFocoColocaciones">
			<thead>
				<tr>
					<th class="h7"><b>Zonal</b></th>
					<th class="h7"><strong>BTT</strong></th>
					<th class="h7"><strong>Sucursal</strong></th>
					<th class="h7"><strong>QTY</strong></th>
					<th class="h7"><strong>Monto</strong></th>
					<th class="h7"><strong>Fecha</strong></th>
				</tr>
			</thead>
			<tbody>
				
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
	var url='transacciones/foco/datosColocaciones.asp';
	$('#tablaSucursalesFocoColocaciones').dataTable( {
		"ajax": url,
		"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
		"sPaginationType": "bootstrap",
		"bFilter": false,
		"bInfo": false,
		"iDisplayLength": 20,
		"columns": [
			{ "data": "zonal" },
			{ "data": "cod_bantotal" },
			{ "data": "nombre_sucursal" },
			{ "data": "colCredF" },
			{ "data": "colCred_monto" },
			{ "data": "fecha" }
		]
	});
	$('#tablaSucursalesFocoColocaciones').on( 'draw.dt', function () {
		$('#tablaSucursalesFocoColocaciones tbody tr').each(function() {
			$(this).addClass('h7')
		});
	});
</script>