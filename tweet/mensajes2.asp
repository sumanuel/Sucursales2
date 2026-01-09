<!--#include file="../funciones.asp"-->
<div class="row-fluid">
	<div class="span12" id="recarga">
		<span class="badge badge-info mano">
			<i class="icon-refresh"></i>
			Recargar
		</span>
	</div>
	<div class="span12">
		<div class="row-fluid">
			<div class="span12">
				<span class=" badge badge-important text-center mano respondido">
					Respuestas a mis mensajes
				</span>
				<span class=" badge badge-success text-center mano respuestas">
					Respuestas enviadas
				</span>
			</div>
		</div>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="cargaMensajesPersonales">
</div>
<script type="text/javascript">
$(function(){
	var pagina='tweet/mensajesPersonales.asp';
	var div='cargaMensajesPersonales';
	var datos='tipo=2';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#recarga').click(function(){
	$(this).html('<img src="img/loading.gif">');
	setTimeout(function() {
		var pagina ='tweet/mensajes2.asp';
		var div='mensajesTw';
		var datos = '';
		try{
			enviaDatos(pagina,div,datos);
		}catch(err){}
	}, 1500);
});
$('.respuestas').click(function(){
	var pagina='tweet/mensajesPersonales.asp';
	var div='cargaMensajesPersonales';
	var datos='tipo=1';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('.respondido').click(function(){
	var pagina='tweet/mensajesPersonales.asp';
	var div='cargaMensajesPersonales';
	var datos='tipo=2';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
</script>