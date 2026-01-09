<!--#include file="../funciones.asp"-->
<%idPerfil = trim(request("perfil"))%>
<div class="row-fluid">
	<div class="span2" id="divSucursalesAbiertas"></div>
	<div class="span4" id="divIndicadoresGerencial"></div>
	<div class="span4" id="divSeguridadGerencial"></div>
	<div class="span2 well" id="botoneraGerencia">
		<!--<i class="icon-flag-alt icon-2x mano"></i>
		<i class="icon-calendar icon-2x mano ayuda calendarioGer" data-placement="right" title="" data-original-title="Calendario"></i>
		<i class="icon-pushpin icon-2x mano"></i>-->
		<!--<span id="divIncidenciasGer" class="mano" data-placement="top" title="Incidencias">
          <i class="icon-flag-alt icon-2x mano"></i>
          <span id="numeroIncidencias" class="badge badge-info mano">0</span>
        </span>-->
        <!--<span id="divMensajesGer" class="mano" data-placement="top" title="Mensajes">
          <i class="icon-comment-alt icon-2x mano"></i>
          <span id="numeroMensajes" class="badge badge-info mano">0</span>
        </span>-->
		<i class="icon-calendar icon-2x mano ayuda calendarioGer" data-placement="right" title="" data-original-title="Calendario"></i>
		<i class="icon-bar-chart icon-2x mano muestraGraficoGerencia ayuda" data-placement="left" title="" data-original-title="Tendencias">
		</i>
		<!--<span id="divEstadisticasAuditoria" class="mano" data-placement="top" title="Auditoría">
          <i class="icon-legal icon-2x mano"></i>
        </span>
		<i class="icon-signout icon-2x mano ayuda salir" data-placement="right" title="" data-original-title="Salir"></i>-->
	</div>
</div>
<div class="row-fluid oculto" id="divDetalleSucursales">
	<div class="span12" id="detalleSucursales"></div>
</div>
<div class="row-fluid">
	<div class="span12 oculto" id="areaTrabajoGerencia"></div>
</div>
<div class="row-fluid">
	<div class="span12" id="divDetalleGerencia"></div>
</div>
<!--<div class="row-fluid" id="areaDivTabsGerencia">
	<div class="span10 tabbable tabs-left">
		<ul class="nav nav-tabs" id="menuLateral">
			<li id="operaciones"><a href="#">Operaciones</a></li>
			<li id="comercial"><a href="#">Comercial</a></li>
			<li id="control"><a href="#">Control</a></li>
		</ul>
		
		<div id="datosZona" class="tab-content"></div>
	</div>
	<div class="span2">
		<div class="row-fluid">
			<div class="span12 well" id="gestDocGerSuc" data-tipoGestion="1"></div>
		</div>
		<div class="row-fluid">
			<div class="span12 well" id="gestContGerSuc" data-tipoGestion="2"></div>
		</div>
		<div class="row-fluid">
			<div class="span12 well" id="gestAdmGerSuc" data-tipoGestion="3"></div>
		</div>
	</div>
</div>-->


<input type="hidden" name="zona" id="zona">

<script type="text/javascript">
$(function () {
	$('.ayuda').tooltip();
	var fecha = new Date();
	var hora = fecha.getHours();
	var minuto = fecha.getMinutes();
	var totalMinutos = hora*60;
	totalMinutos += minuto;
	var minutosFalta = 480 -totalMinutos;
	/*var pagina = 'sucursales/tabSucursalGer.asp';
	var div = 'datosZona';
	var datos = 'idZona=1';
	$('ul#menuLateral > li#operaciones').addClass('active');
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}*/
	var pagina, div, datos;
	pagina = 'sucursales/tabRegionales.asp';
	div = 'divDetalleGerencia';
	datos='';
	enviaDatos(pagina,div,datos);
	setTimeout(function() {
		pagina = 'indicadores/indicadorPersonalZonal.asp';
		div = 'divIndicadoresGerencial';
		datos = 'idPerfil=3';
		try{
			enviaDatos(pagina,div,datos);
		}catch(err){}
	}, minutosFalta);
	setTimeout(function(){
		pagina = 'sucursales/seguridadZonal.asp';
		div = 'divSeguridadGerencial';
		datos = 'idPerfil=3';
		try{
			enviaDatos(pagina,div,datos);
		}catch(err){}
	},minutosFalta);
	pagina = 'sucursales/gestionSucursalGer.asp';
	div = 'gestDocGerSuc';
	datos='tipo=1';
	enviaDatos(pagina,div,datos);
	pagina = 'sucursales/gestionSucursalGer.asp';
	div = 'gestContGerSuc';
	datos='tipo=2';
	enviaDatos(pagina,div,datos);
	pagina = 'sucursales/gestionSucursalGer.asp';
	div = 'gestAdmGerSuc';
	datos='tipo=3';
	enviaDatos(pagina,div,datos);

});
$('#operaciones').click(function(){
	pagina = 'sucursales/tabSucursalGer.asp';
	div = 'datosZona';
	datos = 'idZona=1';
	$('ul#menuLateral > li').each(function(){
		$(this).removeClass('active')
	});
	$(this).addClass('active');
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#comercial').click(function(){
	pagina = 'sucursales/comercial.asp';
	div = 'datosZona';
	datos = '';
	$('ul#menuLateral > li').each(function(){
		$(this).removeClass('active')
	});
	$(this).addClass('active');
	try{enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#control').click(function(){
	var pagina = 'sucursales/control.asp';
	var div = 'datosZona';
	var datos = '';
	$('ul#menuLateral > li').each(function(){
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#areaTrabajoGerencia').hide('fast');
var pagina,div,datos,div;
var idZona = $('#idZona').val();

$('#divEstadisticasAuditoria').click(function(){
	pagina = 'auditoria/estadisticas.asp';
	div = 'areaTrabajoGerencia';
	datos = 'idZona='+idZona;
	enviaDatos(pagina,div,datos);
	$('#menuGer,#datosZona, #areaDivTabsGerencia').fadeOut('slow');
	return false;
});
$('.calendarioGer').click(function(){
	pagina = 'visitas/visitaZonal.asp';
	div = 'areaTrabajoGerencia';
	datos='';
	try{enviaDatos(pagina,div,datos);
	}catch(err){}
	$('#menuGer,#datosZona, #areaDivTabsGerencia').fadeOut('slow');
	return false;
});
$('#divIncidenciasGer').click(function(){
	pagina = 'incidencias/muestraIncidenciasZonal.asp';
	div = 'areaTrabajoGerencia';
	datos='';
  try{enviaDatos(pagina,div,datos);
	}catch(err){}
	$('#menuGer,#datosZona, #areaDivTabsGerencia').fadeOut('slow');
	return false;
});
$('#divMensajesGer').click(function(){
	pagina = 'mensajes/mensajes.asp';
	div = 'areaTrabajoGerencia';
	datos='';
	enviaDatos(pagina,div,datos);
	$('#menuGer,#datosZona, #areaDivTabsGerencia').fadeOut('slow');
	return false;
});
$('#muestraCalendario').click(function(){
	pagina = 'visitas/visitaZonal.asp';
	div = 'areaZonal';
	datos='';
	try{enviaDatos(pagina,div,datos);
	}catch(err){}
	return false;
});
$('.muestraGraficoGerencia').click(function(){
	pagina = 'indices/indicesGer.asp';
	div = 'areaTrabajoGerencia';
	datos='';
	try{enviaDatos(pagina,div,datos);
	}catch(err){}
	$('#menuGer,#datosZona, #areaDivTabsGerencia').fadeOut('slow');
	return false;

});
$('.salir').click(function(){
	location.href='verificaUsuario/salir.asp';
	return false;
});

$('.abreSucursal').click(function(){
	var idSucursal = $(this).attr('data-idSucursal');
	$('#botonAbreSucursal'+idSucursal).hide('fast');
	pagina = 'sucursales/abreSucursal.asp';
	div = 'enviaDatosSucursal'+idSucursal;
	datos='';
	try{enviaDatos(pagina,div,datos);
	}catch(err){}
	$('#sucursalAbierta'+idSucursal)
		.hide('fast')
		.show('fast')
		.addClass('pull-right')
		.html('<i class="icon-ok text-success"></i> Sucursal abierta');
	var fecha = new Date();
	var hora = fecha.getHours();
	var minuto = fecha.getMinutes();
	var totalMinutos = hora*60;
	totalMinutos += minuto;
	

	if (totalMinutos > 540)
	{
		var label='label-warning';
		var texto = 'Abierta FP';
	}
	else
	{
		label='label-success';
		texto = 'Abierta';
	}

	$('#detalleAperturaGer'+idSucursal).removeClass('label-important').text(texto).addClass(label);
	$('#situacionSucursal'+idSucursal).removeClass('label label-important').text('');
	pagina = 'sucursales/sucursalesAbiertasZonal.asp';
	div = 'divSucursalesAbiertas';
	datos = 'idPerfil=<%=idPerfil%>';
	try{enviaDatos(pagina,div,datos);
	}catch(err){}
	return false;
});
setInterval(function() {
	//alert('llega')
  pagina = 'sucursales/sucursalesAbiertasZonal.asp';
  div = 'divSucursalesAbiertas';
  datos = 'idPerfil=<%=idPerfil%>';
  enviaDatos(pagina,div,datos);
}, 20000);
</script>