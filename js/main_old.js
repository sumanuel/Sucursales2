//setInterval(totalincidencias(), 3000);
var perfil = $.session.get('perfil');
$('#verDatos').click(function(){
	if($(this).hasClass('activaBoton'))
	{
		$('#datosMiSucursal').removeClass('oculto');
		$(this).removeClass('activaBoton').addClass('desactivaBoton');		
	}
	else
	{
		$('#datosMiSucursal').addClass('oculto');
		$(this).addClass('activaBoton').removeClass('desactivaBoton');
	}
});
$('#botonSalirZonal').click(function(){
	location.href='verificaUsuario/salir.asp';
});
$('#tabMenu1').click(function(){
	window.location.href='main.asp';
});
$('#muestraCalendario').click(function(){
	pagina = 'visitas/visitaZonal.asp';
	div = 'trabajoZonal';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	
});
$('#muestraCalendarioZonal').click(function(){
	pagina = 'visitas/visitaZonal.asp';
	div = 'trabajoZonal';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
});
$('#informes').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$('#informes').addClass('active');
	sube();
	pagina = 'informes/informes.asp';
	div = 'areaInformes';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	//$('#areaInformes').slideDown('slow');
	 
});
$('#dash').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$('#dash').addClass('active');
	sube();
	pagina = 'dashboard/dash.asp';
	div = 'dashGer';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
		$('#areaDashGer').slideDown('slow');
		
	}
	catch(err){}
});
$('#dashDivision').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$('#dashDivision').addClass('active');
	pagina = 'dashboard/dash.asp';
	div = 'areaDivisional';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
		
	}
	catch(err){}
});

$('#transacciones').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$('#transacciones').addClass('active');
	sube();
	pagina = 'transacciones/transacciones.asp';
	div = 'transaccionesGer';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
		$('#areaTransacciones').slideDown('slow');
		
	}
	catch(err){}	
});
$('#activos').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	sube();
	pagina = 'activos/activos.asp';
	div = 'areaInformes';
	datos='';
	try{
		enviaDatos(pagina,div,datos);		
	}
	catch(err){}
	$('#areaInformes').slideDown('slow');
});
$('#gastosGer').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	sube();
	pagina = 'gastos/gastos.asp';
	div = 'gastosGerEspacio';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
		$('#areaGastosGer').slideDown('slow');
		
	}
	catch(err){}
});
$('#opPersonal').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	sube();
	pagina = 'personal/personal.asp';
	div = 'personalGer';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
		$('#personalGer').slideDown('slow');
		
	}
	catch(err){}
});
$('#opPersonalInt').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	sube();
	pagina = 'personal/personal_int.asp';
	div = 'personalGer';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
		$('#personalGer').slideDown('slow');
		
	}
	catch(err){}	
});
$('#opSucursales').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	sube();
	pagina = 'sucursales/listaSucursales_detalle.asp';
	div = 'personalGer';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
		$('#personalGer').slideDown('slow');
		
	}
	catch(err){}	
});
$('#opPersonalDivision').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	pagina = 'personal/personal.asp';
	div = 'areaDivisional';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
		$('#personalGer').slideDown('slow');
		
	}
	catch(err){}
});
$('#opPersonalIntDivision').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	pagina = 'personal/personal_int.asp';
	div = 'areaDivisional';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
		$('#personalGer').slideDown('slow');
		
	}
	catch(err){}
});
$('#opSucursalesDivision').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	pagina = 'sucursales/listaSucursales_detalle.asp';
	div = 'areaDivisional';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
		$('#personalGer').slideDown('slow');
		
	}
	catch(err){}
});

$('#opEspecial').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	pagina = 'especial/listaEspecial.asp';
	div = 'areaTrabajoGer';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
		$('#areaTrabajoGer').slideDown('slow');
		
	}
	catch(err){}
});


$('#divIncidencias').click(function(){
	pagina = 'incidencias/muestraIncidenciasZonal.asp';
	div = 'trabajoZonal';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	if ($('#estadoSucursalesZonal').hasClass('span5'))
	{
		$('#estadoSucursalesZonal').remove();
		$('#trabajoZonal')
		.addClass('span10')
		.removeClass('span5');	
		setTimeout(function() {
			$('.botonVuelveZon')
			.html('Cerrar <i class="icon-remove"></i>')
			.removeClass('botonVuelveZon')
			.addClass('botonCierraZon quitaDivZon');
		}, 100);
	}
	
});
/*$('#divMensajesZonal').click(function(){
	pagina = 'mensajes/mensajes.asp';
	div = 'trabajoZonal';
	datos='';
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
	if ($('#estadoSucursalesZonal').hasClass('span5'))
	{
		$('#estadoSucursalesZonal').remove();
		$('#trabajoZonal')
		.addClass('span10')
		.removeClass('span5');	
		setTimeout(function() {
			$('.botonVuelveZon')
			.html('Cerrar <i class="icon-remove"></i>')
			.removeClass('botonVuelveZon')
			.addClass('botonCierraZon quitaDivZon');
		}, 100);
	}
	
});*/
$('.muestraGraficoZonal').click(function(){
	sube();
	$('#gastosIndices').removeClass('oculto');
	pagina = 'indices/indicesGer.asp';
	div = 'indicesZOnal';
	datos='';
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#logOut').click(function(){
	location.href="verificaUsuario/salir.asp";
	
});
$('#gastosZon').click(function(){
	$('ul#menuTab li').each(function(){
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	sube();
	$('#gastosIndices')
	.removeClass('oculto')
	.slideDown('slow');
	var pagina = 'gastos/menuGastosZonal.asp';
	var div = 'gastosZonal';
  	var datos='';
  	try{
  	       enviaDatos(pagina,div,datos);
  	}catch(err){}
  	
});
$('.botonCambiaEstado').click(function(){
	 var idGestion = $(this).attr("data-idGestion");
    $(this).removeClass("botonCambiaEstado");
    $("." + idGestion).html('<select class="selectCambiaEstadoSucursal input-small ' + idGestion + '" data-idGestion=' + idGestion + ' id="selectCambiaEstadoSucursal"><option value="">[Seleccione opcion]</option><option value="1">Ingresado por error</option><option value="2">Cerrar</option></select><div id="validaOpcion" class="' + idGestion + '"></div>');
    
});
$(".selectCambiaEstadoSucursal").change(function() {
	var valorSeleccionado = $(this).val();
    var idGestion = $(this).attr("data-idGestion");
    if (valorSeleccionado === "") {
        $("#validaOpcion." + idGestion)
        .text("Debe seleccionar una opcion")
        .addClass("alert alert-error");
    } else {
        $("#validaOpcion." + idGestion)
        .removeClass("alert alert-error")
        .html('<span class="btn btn-mini btn-success" id="botonGuardaEstadoGestion" data-idGestion="' + idGestion + '" data-valorSeleccionado="' + valorSeleccionado + '"><strong><i class="icon-save"></i> Guardar</strong></span><span class="btn btn-mini btn-danger" id="botonCancelaEstadoGestion" data-idGestion=' + idGestion + '><i class="icon-remove"></i> Cerrar</span>');
    }
    
});
$("#botonGuardaEstadoGestion").click(function(){
	var idGestion = $(this).attr("data-idGestion");
    var valorSeleccionado = $(this).attr("data-valorSeleccionado");
    var textoSeleccionado = $("select." + idGestion + " option:selected").text();
    $("#estado" + idGestion).text(textoSeleccionado);
    $("#divCambiaEstadoGestion." + idGestion).html("");
    pagina = "incidencias/cambiaEstadoIncidencias.asp";
    div = "divCambiaEstadoGestion" + idGestion;
    datos = "idGestion=" + idGestion + "&valor=" + valorSeleccionado;
    try{
           enviaDatos(pagina, div, datos);
    }catch(err){}
    $('tr#'+idGestion).fadeToggle('slow');
    
});
$("#botonCancelaEstadoGestion").click(function(){
	 var idGestion = $(this).attr("data-idGestion");
    $("#divCambiaEstadoGestion." + idGestion).html('<span class="btn btn-mini btn-success botonCambiaEstado" data-idGestion="' + idGestion + '"><i class="icon-wrench"></i></span>');
    
});

$('#nombreUsuarioTitulo').mouseover(function() {
  $(this).addClass('well');
});
$('#nombreUsuarioTitulo').mouseleave(function(){
  $(this).removeClass('well');
});

/*

*/
var pagina, div, datos, idTab;
$( document ).ready(function() {
	$('.tool').tooltip();
   	$('.ayuda').tooltip();
   	$('ul#menuTab li').each(function() {
		if ($(this).hasClass('active'))
		{
			idTab = $(this).attr('id');
		}
    });
	if (idTab == 'tabMenu1')
	{
		if (perfil !== '4')
		{
			pagina = 'sucursales/miSucursal.asp';
			div = 'miSucursal';
			datos='';
			enviaDatos(pagina,div,datos);
			pagina = 'sucursales/panelSucursal.asp';
			div = 'panelSucursal';
			datos='';
			enviaDatos(pagina,div,datos);	
		}
		
	}
});
function sube()
{
	try{
		$('#areaInformes,#areaTrabajoGer,#areaDashGer,#areaTransacciones,#areaGastosGer,#sucursalesZonal,#areaTrabajoZonal,#areaJeps,#miSucursal,#panelSucursal,#areaInformes,#gastosZonal,#indicesZOnal, #gastosIndices, #personalGer, #areaGastosGer, #gastosGerEspacio, #divDetalleSucursales, #areaDivTabsGerencia').slideUp('fast');
	}
	catch(er){}
	
}
function enviaDatos(pagina,div,datos)
{
	try{
		var perfilSession = $.session.get('perfil');
		var sucursalSession = $.session.get('idSucursal');
		var usuarioSession = $.session.get('idUsuario');
		if (perfilSession == '1' && sucursalSession == '0')
		{
			location.href='verificaUsuario/salir.asp';
		}
		if (usuarioSession =='0' && perfilSession !='0')
		{
			location.href='verificaUsuario/salir.asp';
		}
		var rand = '&v='+ Math.random() * 999;
		var ajaxobject = $.ajax(
		{
			type:'GET', 
			url:pagina,
			cache:false,
			//async:true,
			global:false,
			dataType:"html",
			data:datos+rand,
			timeout:10000,
			success:function(contenido){
				$('#'+div).hide().empty().html('');
        		$('#'+div).html(contenido).fadeIn('fast');
        		
			}
		});
		if(ajaxobject === undefined)
		alert('Problemas en la generacion del objeto');
	}
	catch(er){}
	
}
function poneColor(valor,div)
{
	try{
		if (valor === 0)
		{
			$('#'+div).addClass('text-info');
			$('.texto'+div).addClass('text-info');
		}
		if (valor > 0)
		{
			$('#'+div).addClass('text-success');
		}
		if(valor < 0)
		{
			$('#'+div).addClass('text-error');
		}
	}
	catch(er){}
		
}
function totalincidencias()
{
	try{
		var perfil = $.session.get("perfil");
		var idSucursal = $.session.get("idSucursal");
		var idUsuario = $.session.get("idUsuario");
		var pagina = 'incidencias/totalincidencias.asp';
		if (idSucursal == null || idUsuario == null){
			pagina='verificausuario/salir.asp';
		}
		var div='numeroIncidencias';
		var datos='perfil='+perfil+'&idSucursal='+idSucursal+'&idUsuario='+idUsuario;
		//alert(datos)
		enviaDatos(pagina,div,datos);
		
	}
	catch(er){}
}
/*function totalmensajes()
{
	try{
		var perfil = $.session.get("perfil");
		var idSucursal = $.session.get("idSucursal");
		var idUsuario = $.session.get("idUsuario");
		var datos='perfil='+perfil+'&idSucursal='+idSucursal+'&idUsuario='+idUsuario;
		var pagina = 'mensajes/loadMensaje.asp';
		var div = 'numeroMensajes';
		enviaDatos(pagina,div,datos);
		
	}
	catch(er){}
}*/

function numberFormat(numero){ 
	try{
		var resultado = ""; // Si el numero empieza por el valor "-" (numero negativo)
       if(numero[0]=="-"){
				var nuevoNumero=numero.replace(/\./g,'').substring(1);
			}else{
				nuevoNumero=numero.replace(/\./g,'');
			}
			if(numero.indexOf(",")>=0)
				nuevoNumero=nuevoNumero.substring(0,nuevoNumero.indexOf(","));
			for (i = nuevoNumero.length - 1, j = 0; i >= 0; i--, j++) 
          resultado = nuevoNumero.charAt(i) + ((j > 0) && (j % 3 === 0)? ".": "") + resultado; 
				if(numero.indexOf(",")>=0)
				resultado+=numero.substring(numero.indexOf(","));
		if(numero[0]=="-"){
			return "-"+resultado;
		}else{
			return resultado;
		}
	}
	catch(er){}   
}
function cargaDatosInicio(perfil)
{
	var pagina,div,datos;
	
	try{
		if (perfil !="0")
		{
			pagina = 'sucursales/usuario.asp';
			div = 'nombreUsuarioTitulo';
			datos = '';
			try{
				enviaDatos(pagina,div,datos);
			}catch(err){}
			pagina = 'tweet/tweet.asp';
			div="tw";
			datos='';
			try{
				enviaDatos(pagina,div,datos);
			}catch(err){}
			
			if (perfil == '1')
			{
				pagina = 'indicadores/indicadores.asp';
				div = 'indicadores';
				datos = '';
				try{
				       enviaDatos(pagina,div,datos);
				}catch(err){}
				//detiene(pagina,div,datos,1100);
				pagina = 'indices/indices.asp';
				div = 'area';
				datos = '';
				try{
				       enviaDatos(pagina,div,datos);
				}catch(err){}
				//detiene(pagina,div,datos,0);				
			}
			if (perfil == '2')
			{
				
				pagina = 'indices/indices.asp';
				div = 'area';
				datos = '';
				detiene(pagina,div,datos,0);
				pagina = 'indicadores/indicadorGestiones.asp';
				div = 'gDocumental';
				datos = 'tipo=2';
				detiene(pagina,div,datos,500);
				pagina = 'indicadores/indicadorGestiones.asp';
				div = 'gContable';
				datos = 'tipo=3';
				detiene(pagina,div,datos,600);
				pagina = 'indicadores/indicadorGestiones.asp';
				div = 'gAdministrativa';
				datos = 'tipo=4';
				detiene(pagina,div,datos,700);
				pagina = 'auditoria/auditoriaSucursal.asp';
				div = 'auditoria';
				datos = '';
				detiene(pagina,div,datos,800);
				pagina = 'indicadores/indicadores.asp';
				div = 'indicadoresZonal';
				datos = '';
				detiene(pagina,div,datos,1100);
				pagina = 'sucursales/sucursalesAbiertasZonal.asp';
				div = 'divSucursalesAbiertas';
				datos = 'idPerfil=2';
				try{
					enviaDatos(pagina,div,datos);
				}catch(err){}
				//detiene(pagina,div,datos,1200);
				pagina = 'sucursales/estadoSucursal.asp';
				div = 'estadoSucursalesZonal';
				datos = '';
				detiene(pagina,div,datos,1300);
				pagina = 'indicadores/indicadorPersonalZonal.asp';
				div = 'divIndicadoresZonal';
				datos = 'idPerfil=2';
				detiene(pagina,div,datos,1400);
				pagina = 'sucursales/seguridadZonal.asp';
				div = 'divSeguridadZonal';
				datos = 'idPerfil=2';
				detiene(pagina,div,datos,1500);
				pagina = 'zonal/zonal.asp';
				div = 'trabajoZonal';
				datos = '';
				detiene(pagina,div,datos,1600);
					setInterval(function() {    
					var cargaDatos = $('#estadoSucursalesZonal').attr('data-cargaDatos');
					if (cargaDatos == "1")
					{
						if ($('#sucursalSeleccionada').hasClass('oculto'))
						{
							pagina = 'sucursales/estadoSucursal.asp';
							div = 'estadoSucursalesZonal';
							datos = '';
							try{
								enviaDatos(pagina,div,datos);
							}catch(err){}
						}
					}
				}, 300000);	
			}
			if (perfil == '55')
			{				
				pagina = 'indices/indices.asp';
				div = 'area';
				datos = '';
				detiene(pagina,div,datos,0);
				pagina = 'indicadores/indicadorGestiones.asp';
				div = 'gDocumental';
				datos = 'tipo=2';
				detiene(pagina,div,datos,500);
				pagina = 'indicadores/indicadorGestiones.asp';
				div = 'gContable';
				datos = 'tipo=3';
				detiene(pagina,div,datos,600);
				pagina = 'indicadores/indicadorGestiones.asp';
				div = 'gAdministrativa';
				datos = 'tipo=4';
				detiene(pagina,div,datos,700);
				pagina = 'auditoria/auditoriaSucursal.asp';
				div = 'auditoria';
				datos = '';
				detiene(pagina,div,datos,800);
				pagina = 'indicadores/indicadores.asp';
				div = 'indicadoresZonal';
				datos = '';
				detiene(pagina,div,datos,1100);
				pagina = 'sucursales/sucursalesAbiertasZonal.asp';
				div = 'divSucursalesAbiertas';
				datos = 'idPerfil=55';
				try{
					enviaDatos(pagina,div,datos);
				}catch(err){}
				//detiene(pagina,div,datos,1200);
				pagina = 'sucursales/estadoSucursal.asp';
				div = 'estadoSucursalesZonal';
				datos = '';
				detiene(pagina,div,datos,1300);
				pagina = 'indicadores/indicadorPersonalZonal.asp';
				div = 'divIndicadoresZonal';
				datos = 'idPerfil=55';
				detiene(pagina,div,datos,1400);
				pagina = 'sucursales/seguridadZonal.asp';
				div = 'divSeguridadZonal';
				datos = 'idPerfil=55';
				detiene(pagina,div,datos,1500);
				pagina = 'zonal/zonal.asp';
				div = 'trabajoZonal';
				datos = '';
				detiene(pagina,div,datos,1600);
					setInterval(function() {    
					var cargaDatos = $('#estadoSucursalesZonal').attr('data-cargaDatos');
					if (cargaDatos == "1")
					{
						if ($('#sucursalSeleccionada').hasClass('oculto'))
						{
							pagina = 'sucursales/estadoSucursal.asp';
							div = 'estadoSucursalesZonal';
							datos = '';
							try{
								enviaDatos(pagina,div,datos);
							}catch(err){}
						}
					}
				}, 300000);	
			}
			if (perfil == '66')
			{				
				pagina = 'indices/indices.asp';
				div = 'area';
				datos = '';
				detiene(pagina,div,datos,0);
				pagina = 'indicadores/indicadorGestiones.asp';
				div = 'gDocumental';
				datos = 'tipo=2';
				detiene(pagina,div,datos,500);
				pagina = 'indicadores/indicadorGestiones.asp';
				div = 'gContable';
				datos = 'tipo=3';
				detiene(pagina,div,datos,600);
				pagina = 'indicadores/indicadorGestiones.asp';
				div = 'gAdministrativa';
				datos = 'tipo=4';
				detiene(pagina,div,datos,700);
				pagina = 'auditoria/auditoriaSucursal.asp';
				div = 'auditoria';
				datos = '';
				detiene(pagina,div,datos,800);
				pagina = 'indicadores/indicadores.asp';
				div = 'indicadoresZonal';
				datos = '';
				detiene(pagina,div,datos,1100);
				pagina = 'sucursales/sucursalesAbiertasZonal.asp';
				div = 'divSucursalesAbiertas';
				datos = 'idPerfil=66';
				try{
					enviaDatos(pagina,div,datos);
				}catch(err){}
				//detiene(pagina,div,datos,1200);
				pagina = 'sucursales/estadoSucursal.asp';
				div = 'estadoSucursalesZonal';
				datos = '';
				detiene(pagina,div,datos,1300);
				pagina = 'indicadores/indicadorPersonalZonal.asp';
				div = 'divIndicadoresZonal';
				datos = 'idPerfil=66';
				detiene(pagina,div,datos,1400);
				pagina = 'sucursales/seguridadZonal.asp';
				div = 'divSeguridadZonal';
				datos = 'idPerfil=66';
				detiene(pagina,div,datos,1500);
				pagina = 'zonal/zonal.asp';
				div = 'trabajoZonal';
				datos = '';
				detiene(pagina,div,datos,1600);
					setInterval(function() {    
					var cargaDatos = $('#estadoSucursalesZonal').attr('data-cargaDatos');
					if (cargaDatos == "1")
					{
						if ($('#sucursalSeleccionada').hasClass('oculto'))
						{
							pagina = 'sucursales/estadoSucursal.asp';
							div = 'estadoSucursalesZonal';
							datos = '';
							try{
								enviaDatos(pagina,div,datos);
							}catch(err){}
						}
					}
				}, 300000);	
			}
			if (perfil == '3')
			{
				
				pagina = 'indices/indices.asp';
				div = 'area';
				datos = '';
				detiene(pagina,div,datos,0);
				pagina = 'indicadores/indicadorGestiones.asp';
				div = 'gDocumental';
				datos = 'tipo=2';
				detiene(pagina,div,datos,500);
				pagina = 'indicadores/indicadorGestiones.asp';
				div = 'gContable';
				datos = 'tipo=3';
				detiene(pagina,div,datos,600);
				pagina = 'indicadores/indicadorGestiones.asp';
				div = 'gAdministrativa';
				datos = 'tipo=4';
				detiene(pagina,div,datos,700);
				pagina = 'auditoria/auditoriaSucursal.asp';
				div = 'auditoria';
				datos = '';
				detiene(pagina,div,datos,800);
				pagina = 'sucursales/sucursalGerencia2.asp';
				div = 'sucursalesGer';
				datos = '';
				detiene(pagina,div,datos,1100);
				pagina = 'sucursales/sucursalesAbiertasZonal.asp';
				div = 'divSucursalesAbiertas';
				datos = 'idPerfil=3';
				detiene(pagina,div,datos,1200);
				pagina = 'indicadores/indicadorPersonalZonal.asp';
				div = 'divIndicadoresGerencial';
				datos = 'idPerfil=3';
				detiene(pagina,div,datos,1300);
				pagina = 'sucursales/seguridadZonal.asp';
				div = 'divSeguridadGerencial';
				datos = 'idPerfil=3';
				detiene(pagina,div,datos,1400);
			}
			if (perfil ==='5')
			{
				pagina = 'cda/cda.asp';
				div = 'areaCda';
				datos = '';
				try{
					enviaDatos(pagina,div,datos);
				}catch(err){}
			}
			if (perfil !== '4')
			{
				try{
					setTimeout(totalincidencias,4000);
					//setTimeout(totalmensajes,4000);
					setInterval(totalincidencias,10000);
					//setInterval(totalmensajes,10000);
				}
				catch(er){}
			}
			else{
				pagina = 'divisional/division.asp';
				div = 'areaDivisional';
				datos = '';
				try{
					enviaDatos(pagina,div,datos);
				}catch(err){}
			}			
		}
		else
		{	
			pagina = 'admin/menuAdmin.asp';
			div = 'menuAdmin';
			datos = '';
			enviaDatos(pagina,div,datos);
		}
	}
	catch(er){}
	
}
function detiene(pagina,div,datos,tiempo){
	try{
		setTimeout(function() {
			enviaDatos(pagina,div,datos);
		}, tiempo);
	}
	catch(er){}
	
}
function demonio(pagina,div,datos,tiempo){
	try{
		setInterval(function() {
			enviaDatos(pagina,div,datos);
		}, tiempo);
	}
	catch(er){}
	
}
jQuery.fn.extend({
	addToArray: function(value) {
		var valor = this.val();
		return this.filter(":input").val(function(i, v) {
		if (valor === "")
		{
			var arr = v.split('');
		}
		else
		{
			arr = v.split(',');
		}
		arr.push(value);
		return arr.join(',');
	}).end();
},
	removeFromArray: function(value) {
		return this.filter(":input").val(function(i, v) {
		return $.grep(v.split(','), function(val) {  
		return val != value;
			}).join(',');
		}).end();
	}
});
$.validator.addMethod('verificaNumerosLetras', function(value, element) {
	return this.optional(element) || (value.match(/[a-zA-Z]/) && value.match(/[0-9]/));
},'El campo debe contener al menos una letra y número');