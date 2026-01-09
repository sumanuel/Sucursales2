<div class="row-fluid">
	<div class="span12">
		<ul class="nav nav-tabs" id="menuTitulos">
			<li id="totales" data-tipo="6">
				<a href="#">Totales</a>
			</li>
			<li id="ips" data-tipo="1">
				<a href="#">IPS</a>
			</li>
			<li id="afp" data-tipo="2">
				<a href="#">AFP</a>
			</li>
			<!--<li id="bonos" data-tipo="3">
				<a href="#">Bonos</a>
			</li>-->
			<li id="otros" data-tipo="4">
				<a href="#">Otros</a>
			</li>
			<!--<li id="rm" data-tipo="5">
				<a href="#">Red Movil</a>
			</li>-->
		</ul>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('#menuTitulos li').first().addClass('active');
	var tipoMenuTitulos = $('#menuTitulos li').first().attr('data-tipo');
	var pagina, div, datos;
	pagina = 'maestroPagos/totales.asp';
	div = 'areaTrabajoMaestro';
	datos='tipo=1&tipoMenuTitulos='+tipoMenuTitulos;
	enviaDatos(pagina,div,datos);
});
$('#ips').click(function() {
	eliminaActive();
	$(this).addClass('active');
	var tipoMenuTitulos = $(this).attr('data-tipo');
	var pagina, div, datos;
	pagina = 'maestroPagos/maestroPagosAreaTrabajo.asp';
	div = 'areaTrabajoMaestro';
	datos='tipo=1&tipoMenuTitulos='+tipoMenuTitulos;
	enviaDatos(pagina,div,datos);
});
$('#afp').click(function() {
	eliminaActive();
	$(this).addClass('active');
	var tipoMenuTitulos = $(this).attr('data-tipo');
	var pagina, div, datos;
	pagina = 'maestroPagos/afp.asp';
	div = 'areaTrabajoMaestro';
	datos='tipo=1&tipoMenuTitulos='+tipoMenuTitulos;
	enviaDatos(pagina,div,datos);
});
$('#bonos').click(function(event) {
	eliminaActive();
	$(this).addClass('active');
	var tipoMenuTitulos = $(this).attr('data-tipo');
	var pagina, div, datos;
	pagina = 'maestroPagos/bonos.asp';
	div = 'areaTrabajoMaestro';
	datos='tipo=1&tipoMenuTitulos='+tipoMenuTitulos;
	enviaDatos(pagina,div,datos);
});
$('#otros').click(function(event) {
	eliminaActive();
	$(this).addClass('active');
	var tipoMenuTitulos = $(this).attr('data-tipo');
	var pagina, div, datos;
	pagina = 'maestroPagos/otros.asp';
	div = 'areaTrabajoMaestro';
	datos='tipo=1&tipoMenuTitulos='+tipoMenuTitulos;
	enviaDatos(pagina,div,datos);
});
$('#totales').click(function(event) {
	eliminaActive();
	$(this).addClass('active');
	var tipoMenuTitulos = $(this).attr('data-tipo');
	var pagina, div, datos;
	pagina = 'maestroPagos/totales.asp';
	div = 'areaTrabajoMaestro';
	datos='tipo=1&tipoMenuTitulos='+tipoMenuTitulos;
	enviaDatos(pagina,div,datos);
});
$('#rm').click(function(event) {
	eliminaActive();
	$(this).addClass('active');
	var tipoMenuTitulos = $(this).attr('data-tipo');
	var pagina, div, datos;
	pagina = 'maestroPagos/redMovil.asp';
	div = 'areaTrabajoMaestro';
	datos='tipo=1&tipoMenuTitulos='+tipoMenuTitulos;
	enviaDatos(pagina,div,datos);
});
function eliminaActive()
{
	$('#menuTitulos li').each(function() {
		$(this).removeClass('active');
	});
}
</script>