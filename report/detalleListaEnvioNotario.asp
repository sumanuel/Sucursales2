<!--#include file="../funciones2.asp"-->
<%idSucursalMain = trim(request("idSucursalEnvio"))
idUsuarioMain = trim(request("idUsuarioMainEnvio"))
perfilMain = trim(request("idPerfilMainEnvio"))
periodoEnvio = trim(request("periodoEnvio"))
idCodigoNotario = trim(request("idCodigoNotario"))%>
<div class="span5 offset3">
	<span class="btn btn-info" id="btnDescargaInformeDetalleNotario" data-toggle="tooltip" title="Descarga Informe Detalle Notario">
		<i class="icon-download-alt"></i>
	</span>
</div>
<div class="row-fluid">
	<div class="span12">
		<table class="table table-bordered table-hover table-condensed" id="detalleTablaEnvioNotario" data-periodo="<%=periodoEnvio%>" data-usuario="<%=idUsuarioMain%>" data-sucursal="<%=idSucursalMain%>" data-perfil="<%=perfilMain%>" data-codigoNotario="<%=idCodigoNotario%>">
			<thead>
				<tr>
					<th>Carpeta</th>
					<th>Numero Crédito</th>
					<th>Fecha Colocación</th>
					<th>Envio Notario</th>
					<th>Estado Envio</th>
					<th>Fecha Asig Credito</th>
					<th>Rut Cliente</th>
					<th>Usuario</th>
					<th>Sucursal</th>
				</tr>
			</thead>
			<tbody>
				<script type="text/javascript">
					$(function(){
						var periodoEnvio, idUsuarioMainEnvio, idSucursalEnvio, idPerfilMainEnvio, idCodigoNotario;
						periodoEnvio=$('#detalleTablaEnvioNotario').attr('data-periodo');
						idUsuarioMainEnvio=$('#detalleTablaEnvioNotario').attr('data-usuario');
						idSucursalEnvio=$('#detalleTablaEnvioNotario').attr('data-sucursal');
						idPerfilMainEnvio=$('#detalleTablaEnvioNotario').attr('data-perfil');
            idCodigoNotario=$('#detalleTablaEnvioNotario').attr('data-codigoNotario');
						var url = 'report/datosDetalleListaEnvioNotario.asp?periodoEnvio='+periodoEnvio+'&idSucursalEnvio='+idSucursalEnvio+'&idUsuarioMainEnvio='+idUsuarioMainEnvio+'&idCodigoNotario='+idCodigoNotario+'&idPerfilMainEnvio='+idPerfilMainEnvio;
							$('#detalleTablaEnvioNotario').dataTable({
							    "ajax": url,
							    "sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
							    "sPaginationType": "bootstrap",
							        "columns": [
							            { "data": "idCarpeta" },
							            { "data": "numCredito"},
							            { "data": "fechaColocacion"},
							            { "data": "codNotario" },
							            { "data": "estadoCredNotario" },
							            { "data": "fechaCredito" },
							            { "data": "rutCliente" },
							            { "data": "usuarioCred" },
							            { "data": "nomSucursal" }
							        ]
							});
							$('#detalleTablaEnvioNotario').on( 'draw.dt', function() {
								$('#detalleTablaEnvioNotario tbody > tr').each(function(){
									var idCarpeta = $('td:eq(0)', this).text();
									var estadoCredNotario = $('td:eq(3)', this).text();
									var idEstadoNotarioCred = $(this).attr('data-idEstadoNotarioCred');
									//console.log(idEstadoNotarioCred);
									if (idCarpeta !== "---"){
										if (parseInt(idEstadoNotarioCred) === 1) {
											$('td:eq(3)', this).html('<span class="label label-warning">'+estadoCredNotario+'</span>');
										}else if (parseInt(idEstadoNotarioCred) === 2){
											$('td:eq(3)', this).html('<span class="label label-success">'+estadoCredNotario+'</span>');
										}else if (parseInt(idEstadoNotarioCred) === 3){
											$('td:eq(3)', this).html('<span class="label label-important">'+estadoCredNotario+'</span>');
										}

									}
							});
						});
					});
				$('#btnDescargaInformeDetalleNotario').click(function() {
					var pagina, div, datos, idSucursalEnvio, periodoEnvio, idPerfilMainEnvio, idUsuarioMainEnvio;
					periodoEnvio=$('#detalleTablaEnvioNotario').attr('data-periodo');
					idUsuarioMainEnvio=$('#detalleTablaEnvioNotario').attr('data-usuario');
					idSucursalEnvio=$('#detalleTablaEnvioNotario').attr('data-sucursal');
					idPerfilMainEnvio=$('#detalleTablaEnvioNotario').attr('data-perfil');
          idCodigoNotario=$('#detalleTablaEnvioNotario').attr('data-codigoNotario');
          $('#btnDescargaInformeDetalleNotario').tooltip('show');
					location.href='report/informeListaDetalleNotario.asp?periodoEnvio='+periodoEnvio+'&idSucursalEnvio='+idSucursalEnvio+'&idUsuarioMainEnvio='+idUsuarioMainEnvio+'&idCodigoNotario='+idCodigoNotario+'&idPerfilMainEnvio='+idPerfilMainEnvio;
				});
				</script>
			</tbody>
		</table>
	</div>
</div>
