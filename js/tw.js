(function($) {
    $.fn.extend( {
        limiter: function(limit, elem) {
            $(this).on("keyup focus", function() {
                setCount(this, elem);
            });
            function setCount(src, elem) {
                var chars = src.value.length;
                if (chars > limit) {
                    src.value = src.value.substr(0, limit);
                    chars = limit;
                    elem.addClass("badge-important");
                }
                else
                {
                	elem.removeClass("badge-important");
                }
                elem.html( limit - chars );
            }
            setCount($(this)[0], elem);
        }
    });
})(jQuery);
$(function(){
    $('.tw').addClass('sticky');
   
	$('#formularioMensaje').slideUp('fast');
	$('#enviaMensaje').slideUp('fast');
	var elem = $("#totalCaracteres");
	$("#mensaje").limiter(160, elem);
	var pagina ='tweet/mensajes.asp';
	var div='mensajesTw';
	var datos = '';
	try{
		enviaDatos(pagina,div,datos);
		 $('#tl').addClass('active'); 
	}catch(err){}
}).on('mouseover','.tw',function(){
	$('#barraTitulo').addClass('mano');

}).on('mouseout','.tw',function(){
	$('#barraTitulo').removeClass('mano');
}).on('click','#barraTitulo',function(){
	if ($('#barraTitulo').hasClass('sobre'))
	{
		abreTw();
	}
	else
	{
		cierraTw();
	}
	
	return false;
}).on('click','#cerrarTw',function(){
	if ($('#barraTitulo').hasClass('sobre'))
	{
		abreTw();
	}
	else
	{
		cierraTw();
	}
	
	return false;
})
$('#textoMensajes').click(function(){
	$('#textoMensajes').slideUp('fast');
	$('#formularioMensaje').slideDown('slow');
	$('#respondiendo').slideUp('fast');
	return false;
});
$('#agregaMensajeTw').mouseover(function(){
	$('#textoMensajes').addClass('claseAgregarMensaje2').removeClass('claseAgregarMensaje').html('<i class="icon-level-up"></i> Agregar mensaje');
});
$('#agregaMensajeTw').mouseout(function(){
	$('#textoMensajes').addClass('claseAgregarMensaje').removeClass('claseAgregarMensaje2').html('<i class="icon-edit"></i> Agregar mensaje');
})
$('#botonCancelar').click(function(){
	$('#formularioMensaje').slideUp('fast');
	$('#textoMensajes').slideDown('slow');
	$('#respuesta').val('');
	$('#mensaje').val('');
	return false;
});
function abreTw()
{
	$('.tw').removeClass('sticky span3 offset9').addClass('sticky2 span9 offset3');
	$('#barraTitulo').addClass('sobre2').removeClass('sobre');
	$('#divMensajesTw, #divAgregaMensaje').removeClass('hidden');
	$('#cerrarTw').html('<i class="icon-collapse"></i>');
	 $('#tl').addClass('active'); 
}
function cierraTw()
{
	$('.tw').addClass('sticky span3 offset9').removeClass('sticky2 span9 offset3');
	$('#barraTitulo').removeClass('sobre2').addClass('sobre');
	$('#divMensajesTw, #divAgregaMensaje').addClass('hidden');
	$('#cerrarTw').html('<i class="icon-collapse-top"></i>');
	$('#formularioMensaje').slideUp('fast');
	$('#textoMensajes').slideDown('slow');
	$('#respuesta').val('');
	$('#mensaje').val('');
	return false;
}
