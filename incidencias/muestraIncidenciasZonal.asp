<div class="row-fluid">
	<div class="span12">
<%perfil = trim(request("perfilMain"))
muestraIncidencias = trim(request("muestraIncidencias"))
if muestraIncidencias = "" then muestraIncidencias = "0"%>
<%if perfil = "3" then%>
	<div class="row-fluid">
		<div class="alert alert-error mano text-center offset9 botonVuelveGer">
			Volver a vista zonales 
			<i class="icon-reply"></i>
		</div>
	</div>
<%end if
if perfil = "2" then%>
	<div class="row-fluid">
		<div class="alert alert-error mano text-center offset9 botonVuelveZon">
			Volver a sucursal 
			<i class="icon-reply"></i>
		</div>
	</div>
<%end if%>
<div class="row-fluid">
	<div class="span12">
		<ul class="nav nav-tabs" id="menuTab">    
			<li class="active" id="incidenciasAbiertas">
				<a href="#">
					<i class="icon-fixed-width icon-flag-alt"></i>
					Abiertas
				</a>
			</li>
			<li id="incidenciasCerradas">
				<a href="#">
					<i class="icon-fixed-width icon-lock"></i>
					Cerradas
				</a>
			</li>
		</ul>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="muestraConsultaIncidencias"></div>
</div>
<script type="text/javascript">
$(function(){
	if($('#sucursalSeleccionada').hasClass('oculto'))
	{
		$('.botonVuelveZon').addClass('oculto');
	}
	pagina = "incidencias/consultaIncidencias.asp";
	div = "muestraConsultaIncidencias"
	datos = "muestraIncidencias=<%=muestraIncidencias%>" ;
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('.botonVuelveGer').click(function(event){
	$('#areaTrabajoGerencia').slideUp('fast');
	$('#menuGer, #datosZona, #areaDivTabsGerencia').slideDown('slow');

	event.preventDefault(); 
});

$('.botonVuelveZon').click(function(){
	var pagina,div,datos
	var idSucursal = $("#sucursalSeleccionada").attr('data-idSucursal');
	var textoSeleccionado = $(this).attr('data-nombreSucursal');
	/*$('#sucursalSeleccionada')
	.removeClass('oculto')
	.addClass('span12 label label-inverse')
	.attr('data-idSucursal',idSucursal);
	$('#textoSucursalSeleccionada').text(textoSeleccionado);
	$('.listado').slideUp('fast');
	$('#estadoSucursalesZonal').removeClass('span5').addClass('span2');
	$('#trabajoZonal').removeClass('span5').addClass('span8');
	$('#botonNuevoMensaje').removeClass('span4').addClass('span6');
	//$('#flash').slideUp('fast');
	$('#trabajoZonal').html('');
	pagina = 'sucursales/sucursalZonal.asp';
	div = 'trabajoZonal';
	datos = 'sucursal='+idSucursal
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}*/
	window.location.reload();
});
$('.quitaDivZon').click(function(){
	window.location.reload();
	return false;
});
$("#incidenciasCerradas").click(function(){
	$("#incidenciasAbiertas").removeClass("active");
    $(this).addClass("active");
    pagina = "incidencias/consultaIncidencias.asp";
	div = "muestraConsultaIncidencias";
	datos = "muestraIncidencias=1" ;
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
	
});
$("#incidenciasAbiertas").click(function(){
	$("#incidenciasCerradas").removeClass("active");
    $(this).addClass("active");
    pagina = "incidencias/consultaIncidencias.asp";
	div = "muestraConsultaIncidencias";
	datos = "muestraIncidencias=0" ;
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
	
});



</script>