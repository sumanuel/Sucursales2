<!--#include file="../../funciones.asp"-->
<div class="row-fluid">
	<div class="span12">
			<table class="table table-bordered table-hover table-condensed" id="tablaSucursalesFocoAfiliaciones">
				<thead>
					<tr>
						<th class="h7"><b>Zonal</b></th>
						<th class="h7"><strong>BTT</strong></th>
						<th class="h7"><strong>Sucursal</strong></th>
						<th class="h7"><strong>Normal</strong></th>
						<th class="h7"><strong>PBS</strong></th>
                        <th class="h7"><strong>FFAA</strong></th>
						<th class="h7"><strong>Fecha</strong></th>
					</tr>
				</thead>
				<tbody>
				
				</tbody>
			</table>

	</div>
</div>
			<script type="text/javascript">
				var url='transacciones/foco/datosAfiliaciones.asp';
				$('#tablaSucursalesFocoAfiliaciones').dataTable( {
					"ajax": url,
					"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
					"sPaginationType": "bootstrap",
					"bFilter": false,
					"bInfo": false,
					"iDisplayLength": 20,
					"columns": [
						{ "data": "zonal" },
						{ "data": "codSucursal" },
						{ "data": "nombre_sucursal" },
						{ "data": "afiNormal" },
						{ "data": "afiPbs" },
						{ "data": "afiFFAA" },
						{ "data": "fecha" }
					]
				});
				$('#tablaSucursalesFocoAfiliaciones').on( 'draw.dt', function () {
					$('#tablaSucursalesFocoAfiliaciones tbody tr').each(function() {
						$(this).addClass('h7')
					});
				});
			</script>