<div class="row-fluid">
	<div class="span10"></div>
	<div class="span2 alert alert-danger mano" id="botonVuelveGer"><strong>Volver </strong>
		<i class="icon-reply"></i>
	</div>
</div>
<div class="row-fluid">
	<div class="span3">
		<div class="row-fluid">
			<div class="span12" id="estadisticasSucursales"></div>
		</div>
		<div class="row-fluid">
			<div class="span12" id="satisfaccion"></div>
		</div>
	</div>
	<div class="span9" id="muestraPaginasEstadisticas"></div>
</div>
	

<script type="text/javascript">
var pagina, donde, datos
$(function(){
	pagina = 'auditoria/estadisticaSucursales.asp';
	donde = 'estadisticasSucursales';
	datos = '';
	try{
		enviaDatos(pagina,donde,datos);
	}catch(err){}

	pagina = 'auditoria/satisfaccion.asp';
	donde = 'satisfaccion';
	datos = '';
	try{
		enviaDatos(pagina,donde,datos);
	}catch(err){}
});		
$('#botonVuelveGer').click(function(){
	$('#areaTrabajoGerencia').slideUp('fast');
	$('#menuGer, #datosZona, #areaDivTabsGerencia').slideDown('slow');
	return false
});
</script>