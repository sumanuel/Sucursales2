<!--#include file="../funciones.asp"-->
<div class="row-fluid" id="divTl">  
    <div class="span3 tw offset9">
	    <div class="row-fluid" id="divBarraTitulo">
	    	<div class="span12 sobre" id="barraTitulo">
	    		<div class="row-fluid">
	    			<div class="span4"></div>
	    			<div class="span6">
	    				<strong>
	    					Mensajes
	    				</strong>
	    			</div>
	    			<div class="span2" id="cerrarTw">
	    				<i class="icon-collapse-top"></i>
	    			</div>
	    		</div>
	    	</div>
	    </div>
	    <div class="row-fluid hidden" id="divMensajesTw">
	    	<div class="span12" id="tabsTl">
				<ul class="nav nav-tabs" id="menuTabTw">    
					<li  class="active" id="tl">
						<a href="#">
							<i class="icon-fixed-width icon-home"></i>
							TL
						</a>
					</li>
					<li id="mitl">
						<a href="#">
							<i class="icon-fixed-width icon-comments-alt"></i>
							Mi TL
						</a>
					</li>
					<li id="recarga">
						<a href="#">
							<i class="icon-refresh"></i>   
							Recargar
						</a>
					</li>
					
				</ul>
	    	</div>
	    	<div class="span11" id="mensajesTw"></div>
	    </div>
	    <div class="row-fluid hidden" id="divAgregaMensaje">
	    	<div class="span12 formulario" id="agregaMensajeTw">
	    		<span class="span12 text-center mano" id="textoMensajes"><i class="icon-edit"></i> Agregar mensaje</span>
	    		<span class="span12 text-center" id="formularioMensaje">
		    		<form name="enviarMensaje" id="enviarMensaje">
						<span class="span12">
							<span id="respondiendo" name="respondiendo" class="badge badge-success"></span>
							<input type="hidden" name="respuesta" id="respuesta">
							<textarea row="4" name="mensaje" id="mensaje" cols="20" placeholder="Ingrese Mensaje"></textarea>
							<span id="totalCaracteres" class="badge"></span>
							<input type="button" class="btn btn-mini btn-success" id="botonEnviar" value="Enviar">
							<input type="button" class="btn btn-mini btn-danger" id="botonCancelar" value="Cancelar">
							<span id="errorMensaje" class="text-error oculto">El mensaje no puede estar vacío</span>
						</span>
					</form>
				</span>
				<span class="span12" id="enviaMensaje"></span>
	    	</div>
	    </div>
    </div>
</div>
<style>
  .overF{
 	width: 100px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
 }
</style>
<script type="text/javascript">
$('#mensaje').keyup(function(){
	$('#errorMensaje').addClass('oculto');
});
$(function(){

});
$('#botonEnviar').click(function(){
	var mensaje = $('#mensaje').val();
	if (mensaje ==='')
	{
		$('#errorMensaje').removeClass('oculto');
	}
	else{
		$('#errorMensaje').addClass('oculto');
		$('#formularioMensaje').slideUp('fast');
		var datos = $('#enviarMensaje').serialize();
		var div = 'enviaMensaje';
		var pagina = 'tweet/sql.asp'
		try{
			enviaDatos(pagina,div,datos);
		}catch(err){}
		var pagina ='tweet/mensajes.asp';
		var div='mensajesTw';
		var datos = '';
		try{
			enviaDatos(pagina,div,datos);
		}catch(err){}
		setTimeout(function() {
			$('#enviaMensaje').slideUp('fast');
			$('#formularioMensaje').slideUp('fast');
			$('#textoMensajes').slideDown('slow');
			$('#respuesta').val('');
			$('#mensaje').val();
			return false;
		}, 5000);
	}
	
});
setInterval(function() {
	$('#recarga').html('<img src="img/loading.gif">');
	if ($('#tl').hasClass('active'))
	{
		var pagina ='tweet/mensajes.asp';
	}
	if ($('#mitl').hasClass('active'))
	{
		var pagina ='tweet/mensajes2.asp';	
	}
	setTimeout(function() {
		var div='mensajesTw';
		var datos = '';
		try{
			$('#recarga').html('<a href="#"><i class="icon-refresh"></i>   Recargar</a>');
			enviaDatos(pagina,div,datos);
		}catch(err){}
	}, 1000);
}, 25000);
$('#mitl').click(function(){
	$('#tl').removeClass('active');
	$('#mitl').addClass('active');
	var pagina ='tweet/mensajes2.asp';
	var div='mensajesTw';
	var datos = '';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#tl').click(function(){
	$('#mitl').removeClass('active');
	$('#tl').addClass('active');
	var pagina ='tweet/mensajes.asp';
	var div='mensajesTw';
	var datos = '';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#recarga').click(function(){
	$(this).html('<img src="img/loading.gif">');
	setTimeout(function() {
		var pagina ='tweet/mensajes.asp';
		var div='mensajesTw';
		var datos = '';
		try{
			enviaDatos(pagina,div,datos);
		}catch(err){}
		$('#recarga').html('<a href="#"><i class="icon-refresh"></i>Recargar</a>');
	}, 1500);
	return false;
});
</script>
<script src="js/tw.js"></script>
<script src="js/jquery.momentos.js"></script>
