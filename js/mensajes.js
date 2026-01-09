$( document ).ready(function() {
	if($('#sucursalSeleccionada').hasClass('oculto'))
	{
		$('.botonVuelveZon').css('display','none');
		$('.espacio').removeClass('span7').addClass('span4');
	}
	var pagina = 'mensajes/listaMensajes.asp';
	var div = 'tablaMensajes';
	var datos = 'tipo=1';
	$('.muestraRecividos').addClass('active');
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	if ($('#trabajoZonal').hasClass('span5'))
	{
		$('#botonNuevoMensaje').addClass('span6');
	}
	else
	{
		$('#botonNuevoMensaje').addClass('span3');
	}
	$('#botonNuevoMensaje').click(function() {
		$(this).fadeOut('slow');
		$('#tablaMensajes').fadeOut('slow');
		$('#tabsMensajes').fadeOut('slow');
		$('#nuevoMensaje').empty().slideDown('slow');
		$('#separacionBotones').removeClass('span7').addClass('span9');
		$('#nuevoMensajeDiv').removeClass('oculto');
		var pagina = 'mensajes/nuevoMensaje.asp';
		var div = 'nuevoMensaje';
		var datos = '';
		try{
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
	});
	$('.quitaDivZon').click(function(){
		location.reload();
	});
	$('.botonVuelveGer').click(function(){
		$('#areaTrabajoGerencia').slideUp('fast');
		$('#menuGer, #datosZona, #areaDivTabsGerencia').slideDown('slow');
		return false;
	});
	$('.botonVuelveZon').click(function(){
		var pagina,div,datos;
		var idSucursal = $("#sucursalSeleccionada").attr('data-idSucursal');
		var textoSeleccionado = $(this).attr('data-nombreSucursal');
		location.reload();
		/*$('#sucursalSeleccionada').removeClass('oculto').addClass('span12 label label-inverse').attr('data-idSucursal',idSucursal);
		$('#textoSucursalSeleccionada').text(textoSeleccionado);
		$('.listado').slideUp('fast');
		$('#estadoSucursalesZonal').removeClass('span5').addClass('span2');
		$('#trabajoZonal').removeClass('span5').addClass('span8');
		$('#botonNuevoMensaje').removeClass('span4').addClass('span6');
		//$('#flash').slideUp('fast');
		$('#trabajoZonal').html('');
		*/
		/*pagina = 'sucursales/sucursalZonal.asp';
		div = 'trabajoZonal';
		datos = 'sucursal='+idSucursal;
		try{
			enviaDatos(pagina,div,datos);
			return false;
		}
		catch(err){}*/
	});
	$('.revisaMensaje').click(function(){
		var idMensaje = $(this).attr('id');
		$('#revisaMensajes').fadeIn('slow');
		$('#revisaMensajesDiv').removeClass('oculto');
		$('#botonNuevoMensaje').slideUp('slow');
		var pagina = 'mensajes/revisaMensaje.asp';
		var div = 'revisaMensajes';
		var datos = 'idMensaje='+idMensaje;
		try{
			enviaDatos(pagina,div,datos);
			return false;
		}
		catch(err){}
	});
	$('.muestraRecividos').click(function(){
		var pagina = 'mensajes/listaMensajes.asp';
		var div = 'tablaMensajes';
		var datos = 'tipo=1';
		$(this).addClass('active');
		$('.muestraEnviados').removeClass('active');
		try{
			enviaDatos(pagina,div,datos);
			return false;
		}
		catch(err){}
	});
	$('.muestraEnviados').click(function(){
		var pagina = 'mensajes/listaMensajes.asp';
		var div = 'tablaMensajes';
		var datos = 'tipo=2';
		$(this).addClass('active');
		$('.muestraRecividos').removeClass('active');
		try{
			enviaDatos(pagina,div,datos);
			return false;
		}
		catch(err){}
	});
	return false;
});