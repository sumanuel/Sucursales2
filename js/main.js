var perfil = $('#perfilMain').val();
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

$('#tabMenu13CajerosA').click(function(){
	sube();
	$('#gastosIndices').removeClass('oculto');
	pagina =  'sucursales/solicitudCajerosAdicionales.asp';
	div = 'indicesZOnal';
	datos='';
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
});

$('#tabMenu13CajerosR').click(function(){
	sube();
	$('#gastosIndices').removeClass('oculto');
	pagina =  'sucursales/solicitudRebajaCajerosAdicionales.asp';
	div = 'indicesZOnal';
	datos='';
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
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

/*$('#nombreUsuarioTitulo').mouseover(function() {
  $(this).addClass('well');
});
$('#nombreUsuarioTitulo').mouseleave(function(){
  $(this).removeClass('well');
});*/
var pagina, div, datos, idTab;
$(function(){
	$('.tool').tooltip();
	$('.ayuda').tooltip();
	$('ul#menuTab li').each(function() {
		if ($(this).hasClass('active'))
		{
			idTab = $(this).attr('id');
		}
	});
	var pagina, div, datos;
	pagina = 'menu/default.asp';
	div = 'menu';
	datos='';
	enviaDatos(pagina,div,datos);
});
function sube()
{
	try{
		$('#areaInformes,#areaTrabajoGer,#areaDashGer,#areaTransacciones,#areaGastosGer,#sucursalesZonal,#areaTrabajoZonal,#areaJeps,#miSucursal,#panelSucursal,#areaInformes,#gastosZonal,#indicesZOnal, #gastosIndices, #personalGer, #checkListGer, #reporteGer, #areaGastosGer, #gastosGerEspacio, #divDetalleSucursales, #areaDivTabsGerencia').slideUp('fast');
	}
	catch(er){}
}
function enviaDatos(pagina,div,datos)
{
	try{
		var perfil = $('#perfilMain').val();
		var idUsuario = $('#idUsuarioMain').val();
		var idSucursal = $('#idSucursalMain').val();
		var cadena = 'perfilMain='+perfil+'&idUsuarioMain='+idUsuario+'&idSucursalMain='+idSucursal
		var rand = '&v='+ Math.random() * 999;
		if (datos == '' || datos == cadena )
		{
			datos = cadena
		}
		else
		{
			datos += '&'+cadena
		}
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
		var perfil = $("#perfilMain").val();
		var idSucursal = $("#idSucursalMain").val();
		var idUsuario = $("#idUsuarioMain").val();
		var pagina = 'incidencias/totalincidencias.asp';
		if (idSucursal == null || idUsuario == null){
			pagina='verificausuario/salir.asp';
		}
		var div='numeroIncidencias';
		var datos='';
		enviaDatos(pagina,div,datos);	
	}
	catch(er){}
}

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



function cargaDatosInicio(perfil)
{
	var pagina,div,datos;
	try
	{
		if (perfil !== '0')
		{
			pagina = 'sucursales/usuario.asp';
			div = 'nombreUsuarioTitulo';
			datos = '';
			try{
				enviaDatos(pagina,div,datos);
			}catch(err){}
			if (perfil === '1')
			{
				pagina = 'sucursales/miSucursal.asp';
				div = 'miSucursal';
				datos='';
				enviaDatos(pagina,div,datos);

				pagina = 'sucursales/panelSucursal.asp';
				div = 'panelSucursal';
				datos='';
				enviaDatos(pagina,div,datos);

				pagina = 'sucursales/verificaAperturaSucursal.asp';
				div = 'verificaEstadoSucursal';
				datos = '';
				enviaDatos(pagina,div,datos);
				tiempo = 5000; //100000;
				demonio(pagina,div,datos,tiempo)
				
				pagina = 'indices/indices.asp';
				div = 'area';
				datos = '';
				try{
				       enviaDatos(pagina,div,datos);
				}catch(err){}
				pagina = 'indicadores/indicadores.asp';
				div = 'indicadores';
				datos = '';
				try{
					enviaDatos(pagina,div,datos);
				}catch(err){}
			}
		}
		 if (perfil == '2')
		 	{
		 		pagina = 'sucursales/sucursalesAbiertasZonal.asp';
		 		div = 'divSucursalesAbiertas';
		 		datos = '';
		 		try{
		 			enviaDatos(pagina,div,datos);
		 		}catch(err){}
		 		pagina = 'indicadores/indicadores.asp';
		 		div = 'indicadoresZonal';
				datos = '';
				detiene(pagina,div,datos,1100);
				pagina = 'sucursales/estadoSucursal.asp';
				div = 'estadoSucursalesZonal';
				datos = '';
				detiene(pagina,div,datos,1300);
				pagina = 'indicadores/indicadorPersonalZonal.asp';
				div = 'divIndicadoresZonal';
				datos = '';
				detiene(pagina,div,datos,1400);
				pagina = 'sucursales/seguridadZonal.asp';
				div = 'divSeguridadZonal';
				datos = '';
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
							enviaDatos(pagina,div,datos);
						}
					}
				}, 60000);
				setInterval(function(){
					if ($('#tabMenu1').hasClass('active'))
					{
						var fechaActual = new Date(); 
						var horaActual = fechaActual.getHours();
						var minutosActuales = fechaActual.getMinutes();
						var totalMinutosActuales = horaActual * 60 + minutosActuales;
						var totalRecarga = 0;
						if (totalMinutosActuales >= 0 && totalMinutosActuales <= 480) //0 -> 8 am
						{
							totalRecarga = 3600000;
						}
						if (totalMinutosActuales >= 481 && totalMinutosActuales <= 600) // 8:01 -> 10 am 
						{
							totalRecarga = 30000;
						}
						if (totalMinutosActuales >= 601 && totalMinutosActuales <= 1050) // 10:10 -> 17:10
						{
							totalRecarga = 3600000;	 //3600000
						}
						if (totalMinutosActuales >= 1051 && totalMinutosActuales <= 1170) // 1731 -> 19:30
						{
							totalRecarga = 30000;
						}
						if (totalMinutosActuales >= 1171 && totalMinutosActuales <= 1439) // 19:30 -> 23:59
						{
							totalRecarga = 3600000;
						}
						setInterval(function(){
							pagina = 'sucursales/sucursalesAbiertasZonal.asp';
							div = 'divSucursalesAbiertas';
							datos = '';
							try{
								enviaDatos(pagina,div,datos);
							}catch(err){}
						},totalRecarga);
					}
				},30000);
				
			}
			/*if (perfil == '55')
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
				enviaDatos(pagina,div,datos);
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
			}*/
			if (perfil === '3')
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
				/*pagina = 'indicadores/indicadorPersonalZonal.asp';
				div = 'divIndicadoresGerencial';
				datos = 'idPerfil=3';
				detiene(pagina,div,datos,1300);
				pagina = 'sucursales/seguridadZonal.asp';
				div = 'divSeguridadGerencial';
				datos = 'idPerfil=3';
				detiene(pagina,div,datos,1400);*/
				//aca datos Cajas
			}
			/*if (perfil ==='5')
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
					if ($('#tabMenu1').hasClass('active'))
					{
						setTimeout(totalincidencias,10000);
						//setTimeout(totalmensajes,4000);
						setInterval(totalincidencias,100000);
						//setInterval(totalmensajes,10000);
					}
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
		}*/

	}
	catch(err)
	{}
}