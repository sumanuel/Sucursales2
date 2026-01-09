<%perfil = trim(request("perfil"))%>
<style type="text/css">
.oculto{display: none;}
</style>
<div class="row-fluid">
	<div class="btn btn-success span3" id="botonNuevoMensaje">
		<i class="icon-plus-sign-alt"></i>
		Redactar nuevo mensaje
	</div>
<%if perfil = "3" then%>
	<div class="span7" id="separacionBotones"></div>
	<div class="alert alert-error mano text-center botonVuelveGer span2">
			Volver a vista zonales 
			<i class="icon-reply"></i>
	</div>
<%end if
if perfil = "2" then%>
	<div class="span7" id="separacionBotones"></div>
	<div class="alert alert-error mano text-center botonVuelveZon span2">
		Volver 
		<i class="icon-reply"></i>
	</div>
<%end if%>
</div>

<div class="row-fluid oculto" id="nuevoMensajeDiv">
	<div class="well oculto span12" id="nuevoMensaje"></div>
</div>
<div class="row-fluid oculto" id="revisaMensajesDiv">
	<div class="well oculto span12" id="revisaMensajes"></div>
</div>
<div class="row-fluid">
	<div class="span12">
		<ul class="nav nav-tabs" id="tabsMensajes">
			<li class="muestraRecividos">
				<a href="#">
					Recibidos  
					<i class="icon-envelope"></i> 
					<i class="icon-long-arrow-left"></i>
				</a>
			</li>
			<li class="muestraEnviados">
				<a href="#">
					Enviados  
					<i class="icon-envelope"></i> 
					<i class="icon-long-arrow-right"></i>
				</a>
			</li>
		</ul>
	</div>
</div>
<div class="row-fluid">
	<div id="tablaMensajes" class="span12"></div>
</div>
<script type="text/javascript" src="js/mensajes.js"></script>