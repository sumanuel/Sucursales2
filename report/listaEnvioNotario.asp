<!--#include file="../funciones2.asp"-->
<%idSucursalMain = trim(request("idSucursalEnvio"))
idUsuarioMain = trim(request("idUsuarioMainEnvio"))
perfilMain = trim(request("idPerfilMainEnvio"))
periodoEnvio = trim(request("periodoEnvio"))
%>
<div class="row-fluid">
	<div class="span12">
		<table class="table table-bordered table-hover table-condensed" id="tablaEnvioNotario" data-periodo="<%=periodoEnvio%>" data-usuario="<%=idUsuarioMain%>" data-sucursal="<%=idSucursalMain%>" data-perfil="<%=perfilMain%>">
			<thead>
				<tr>
					<th>EnvioNotario</th>
					<th>Fecha_Envio</th>
					<th>Usuario</th>
					<th>Estado_Envio</th>
					<th>Sucursal</th>
					<th>Q Carpetas</th>
					<th>% Envio</th>
					<th>Acción</th>
				</tr>
			</thead>
			<tbody>
				<script type="text/javascript">
					$(document).ready(function (){
						var periodoEnvio, idUsuarioMainEnvio, idSucursalEnvio, idPerfilMainEnvio;
						periodoEnvio = $('#tablaEnvioNotario').attr('data-periodo');
						idUsuarioMainEnvio = $('#tablaEnvioNotario').attr('data-usuario');
						idSucursalEnvio = $('#tablaEnvioNotario').attr('data-sucursal');
						idPerfilMainEnvio = $('#tablaEnvioNotario').attr('data-perfil');

						var url = 'report/datosTablaEnvioNotario.asp?periodoEnvio='+periodoEnvio+'&idSucursalEnvio='+idSucursalEnvio+'&idUsuarioMainEnvio='+idUsuarioMainEnvio+'&idPerfilMainEnvio='+idPerfilMainEnvio;
						$('#tablaEnvioNotario').dataTable({
						    "ajax": url,    
						    "sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
						    "sPaginationType": "bootstrap",
						        "columns": [
						            { "data": "codigoNotario" },
						            { "data": "fechaEnvio"},
						            { "data": "idUsuario" },            
						            { "data": "estadoEnvio" },
						            { "data": "nomSucursal" },
						            { "data": "total_carpeta" },         
						            { "data": "porcentajeMarca" },
						            {
						                data: null,
						                className: "center",
						                defaultContent: '<span class="boton"></span>'
						            }
						          ]      
						});
					
						$('#tablaEnvioNotario').on( 'draw.dt', function() {
							$('#tablaEnvioNotario tbody > tr').each(function(){
								var codigoNotario = $('td:eq(0)', this).text();
								var revCheck = $('td:eq(6)',this).text();
								var idCodigoNotario = $(this).attr('data-idCodigoNotario');
								var idEstadoNotario = $(this).attr('data-idEstadoNotario');
								var idEstadoEnvioNotario = $(this).attr('data-idEstadoEnvioNotario');

								if (idCodigoNotario !== "---"){
									if (idPerfilMainEnvio === "1"){
										if (parseInt(idEstadoNotario) === 1 ){
											$('td:eq(7)', this).html('<span class="label label-success ayuda mano" onClick="enviaAllRecepNotario('+idCodigoNotario+','+idEstadoNotario+');" title="Recepcionar Q Carpeta" id="spanAllRecep_'+idCodigoNotario+'"><i class="icon-check-sign"></i></span> <span class="label label-important ayuda mano" onClick="enviaAllNoRecepNotario('+idCodigoNotario+');" title="No Recepcionar Q Carpetas" id="spanAllNoRecep_'+idCodigoNotario+'"><i class="icon-check-sign"></i></span> <span class="label label-info ayuda mano" onClick="detalleListaEnvioNotario('+idCodigoNotario+');" title="Ver Detalle Envio" id="spanVerAllDetalle_'+idCodigoNotario+'"><i class="icon-eye-open"></i></span>');

										}else if (parseInt(idEstadoNotario) === 3 && parseInt(idEstadoEnvioNotario) === 0){
											$('td:eq(7)', this).html('<span class="label label-success ayuda mano" onClick="enviaAllRecepNotario('+idCodigoNotario+','+idEstadoNotario+');" title="Recepcionar Todos" id="spanAllRecep_'+idCodigoNotario+'"><i class="icon-check-sign"></i></span> <span class="label label-info ayuda mano" onClick="detalleListaEnvioNotario('+idCodigoNotario+');" title="Ver Detalle Envio" id="spanVerAllDetalle_'+idCodigoNotario+'"><i class="icon-eye-open"></i></span>');

										}else if (parseInt(idEstadoNotario) === 2 && parseInt(idEstadoEnvioNotario) === 0){
											$('td:eq(7)', this).html('<span class="label label-info ayuda mano" onClick="detalleListaEnvioNotario('+idCodigoNotario+');" title="Ver Detalle Envio" id="spanVerAllDetalle_'+idCodigoNotario+'"><i class="icon-eye-open"></i></span>');
										}
									}else{
										$('td:eq(7)', this).html('<span class="label label-info ayuda mano" onClick="detalleListaEnvioNotario('+idCodigoNotario+');" title="Ver Detalle Envio" id="spanVerAllDetalle_'+idCodigoNotario+'"><i class="icon-eye-open"></i></span>');
									}	
								}else{
									$('td:eq(7)', this).html('---');
									$('td:nth-child(9),th:nth-child(9)').hide();
									$('td:nth-child(10),th:nth-child(10)').hide();
								}

								if (revCheck != "--") {
									if (revCheck === "100%") {
										$('td:eq(6)', this).html('<span class="label label-success">'+revCheck+'</span>');
					
									}else{
										$('td:eq(6)', this).html('---');
									}
								}	
							});	
						});	
					});

					function enviaAllNoRecepNotario(idCodigoNotario){
						$('#reporteDetalleTabla').slideUp('fast');
						$('#menuTrabPens').slideUp('fast');
						var pagina, div, datos, idUsuarioMainEnvio, idSucursalEnvio, idPerfilMainEnvio;
						idUsuarioMainEnvio = $('#tablaEnvioNotario').attr('data-usuario');
						idPerfilMainEnvio = $('#tablaEnvioNotario').attr('data-perfil');
						idSucursalEnvio = $('#tablaEnvioNotario').attr('data-sucursal');
						pagina = 'report/sqlAllRecepNoRecepNotario.asp';
						div = 'msgUpdAllRecepNoRecep';
						datos = 'action=1&idUsuarioMainEnvio='+idUsuarioMainEnvio+'&idCodigoNotario='+idCodigoNotario+'&idSucursalEnvio='+idSucursalEnvio+'&idPerfilMainEnvio='+idPerfilMainEnvio;
						enviaDatos(pagina,div,datos);
					}

					function enviaAllRecepNotario(idCodigoNotario, idEstadoNotario){
						$('#reporteDetalleTabla').slideUp('fast');
						$('#menuTrabPens').slideUp('fast');
						var pagina, div, datos, idUsuarioMainEnvio, idSucursalEnvio, idPerfilMainEnvio, idEstadoNotario;
						idUsuarioMainEnvio = $('#tablaEnvioNotario').attr('data-usuario');
						idPerfilMainEnvio = $('#tablaEnvioNotario').attr('data-perfil');
						idSucursalEnvio = $('#tablaEnvioNotario').attr('data-sucursal');
						pagina= 'report/sqlAllRecepNoRecepNotario.asp';
						div= 'msgUpdAllRecepNoRecep';
						datos= 'action=2&idUsuarioMainEnvio='+idUsuarioMainEnvio+'&idCodigoNotario='+idCodigoNotario+'&idSucursalEnvio='+idSucursalEnvio+'&idPerfilMainEnvio='+idPerfilMainEnvio+'&idEstadoNotario='+idEstadoNotario;
						enviaDatos(pagina,div,datos);
					}

					function detalleListaEnvioNotario(idCodigoNotario){
						$('#reporteDetalleTabla').slideUp('fast');
						$('#menuTrabPens').slideUp('fast');
						var pagina, div, datos, idUsuarioMainEnvio, idSucursalEnvio, idPerfilMainEnvio, periodoEnvio;
						periodoEnvio = $('#tablaEnvioNotario').attr('data-periodo');
						idUsuarioMainEnvio = $('#tablaEnvioNotario').attr('data-usuario');
						idSucursalEnvio = $('#tablaEnvioNotario').attr('data-sucursal');
						idPerfilMainEnvio = $('#tablaEnvioNotario').attr('data-perfil');
						pagina= 'report/detalleListaEnvioNotario.asp';
						div= 'listarContenido';
						datos= 'idUsuarioMainEnvio='+idUsuarioMainEnvio+'&idCodigoNotario='+idCodigoNotario+'&idSucursalEnvio='+idSucursalEnvio+'&idPerfilMainEnvio='+idPerfilMainEnvio+'&periodoEnvio='+periodoEnvio;
						enviaDatos(pagina,div,datos);
					}
				</script>
			</tbody>
		</table>
	</div>
</div>