<%idSucursal = trim(request("idSucursal"))%>
<div class="row-fluid">
	<div class="span12">
		<table id="tablaDatosSucursal" class="table table-bordered table-hover table-condensed">
			</thead>
			<tbody>
				<tr>
					<td>
						Nombre Sucursal
					</td>
					<td>
						<span id="nombreSucursal"></span>
						<span id="btnCambiaNombreSuc">
							<i class="icon-edit"></i>	
						</span>
						<input type="hidden" name="cambiaNombreSucursal" id="cambiaNombreSucursal">
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
	url = 'sucursales/datosSucursalZonal.asp?idSucursal='+idSucursal;
	$.when($.ajax(url)).then(function(data) {
		/*$.each( data.datosZonales, function( key, valoresZonales ) {
		});*/
	});
	$('#btnCambiaNombreSuc').click(function(){
		$('#cambiaNombreSucursal').prop('type', 'text');
	});
</script>