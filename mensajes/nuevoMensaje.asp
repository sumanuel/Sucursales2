<%perfil = trim(request("perfil"))%>
<div class="row-fluid">
	<div class="span12">
		<form class="form-horizontal" id="ingresoNuevoMensaje" name="ingresoNuevoMensaje">
		  <div class="control-group botonesSeleccion">
		  		<span>
		  			<strong>
		  				Seleccione a quien desea enviar el mensaje
		  			</strong>
		  		</span>
		  		<%if perfil <> "2" then%>
				<label class="radio inline tipoUsuario" data-id="2">
			  		<input type="radio" name="optionTipoUsuario" id="optionTipoUsuario1" value="2" class="datosUsuarios">
			  			<i class="icon-location-arrow icon-2x" rel="tooltip" title="Zonales" id="iconoZonal"></i>
				</label>
				<%end if
				if perfil <> "3" then%>
				<label class="radio inline tipoUsuario" data-id="3">
			  		<input type="radio" name="optionTipoUsuario" id="optionTipoUsuario2" value="3" class="datosUsuarios">
			  		<i class="icon-sitemap icon-2x" rel="tooltip" title="Operaciones" id="iconpOperaciones" ></i>
				</label>
				<%end if
				if perfil <> "1" then%>
					<label class="radio inline tipoUsuario" data-id="1">
				  		<input type="radio" name="optionTipoUsuario" id="optionTipoUsuario3" value="1" class="datosUsuarios">
				  		<i class="icon-building icon-2x" rel="tooltip" title="Sucursales" id="iconoSucursales"></i>
					</label>
				<%end if%>
				<label class="inline volver pull-right" data-id="volver">
			  		<span class="botonVuelve pull-right mano">
						<i class="icon-reply icon-2x"></i>
						Volver
					</span>
				</label>
		  	</div>
		  	<div class="row-fluid">
				<div class="oculto span12" id="destinatario"></div>
			</div>
			<div class="row-fluid">
				<div class="oculto span12" id="cuerpoMensaje"></div>
			</div>
		</form>
	</div>
</div>

<script type="text/javascript">
$( document ).ready(function(){
	$('#iconoZonal').tooltip();
	$('#iconpOperaciones').tooltip();
	$('#iconoSucursales').tooltip();
	$('.botonVuelve').click(function(){
	$('#tablaMensajes').fadeIn('slow');
	$('#tabsMensajes').fadeIn('slow');
	$('#nuevoMensaje').slideUp('slow');
	$('#botonNuevoMensaje').fadeIn('slow');
	$('#separacionBotones').removeClass('span9').addClass('span7');
});
$('#cierraNuevoMensaje').click(function(){
	$('#nuevoMensaje').fadeOut('slow');
	$('#botonNuevoMensaje').fadeIn('slow');
	$('#tablaMensajes').fadeIn('slow');
	return false;
});
$('.tipoUsuario').click(function(){
	var tipoUsuario = $(this).attr('data-id');
	var icono = $(this).attr('data-icono');
	$('.botonesSeleccion').addClass('oculto');
	var pagina = 'mensajes/listaUsuarios.asp';
	var div = 'destinatario';
	var datos = 'idTipoUsuario='+tipoUsuario;
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
});
});

</script>