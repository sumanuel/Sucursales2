<div class="row-fluid">
	<div class="span12">
		<ul class="nav nav-tabs" id="menuTitulos">
			<li id="ips" data-tipo="1">
				<a href="#">IPS</a>
			</li>
			<li id="afp" data-tipo="2">
				<a href="#">AFP</a>
			</li>
			<li id="afp" data-tipo="2">
				<a href="#">Bonos</a>
			</li>
			<li id="afp" data-tipo="2">
				<a href="#">Otros</a>
			</li>
			<li id="afp" data-tipo="2">
				<a href="#">Red Movil</a>
			</li>
			<li id="afp" data-tipo="2">
				<a href="#">Totales</a>
			</li>

		</ul>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('#menuTitulos li').first().addClass('active');
	var tipoMenuTitulos = $('#menuTitulos li').first().attr('data-tipo');
	var pagina, div, datos;
	pagina = 'especial/maestroPagosAreaTrabajo.asp';
	div = 'areaTrabajoMaestro';
	datos='tipo=1&tipoMenuTitulos='+tipoMenuTitulos;
	enviaDatos(pagina,div,datos);
});
$('#ips').click(function() {
	$('#menuTitulos li').each(function() {
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	var tipoMenuTitulos = $(this).attr('data-tipo');
	var pagina, div, datos;
	pagina = 'especial/maestroPagosAreaTrabajo.asp';
	div = 'areaTrabajoMaestro';
	datos='tipo=1&tipoMenuTitulos='+tipoMenuTitulos;
	enviaDatos(pagina,div,datos);
});
$('#afp').click(function() {
	$('#menuTitulos li').each(function() {
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	var tipoMenuTitulos = $(this).attr('data-tipo');
	var pagina, div, datos;
	pagina = 'maestroPagos/afp.asp';
	div = 'areaTrabajoMaestro';
	datos='tipo=1&tipoMenuTitulos='+tipoMenuTitulos;
	enviaDatos(pagina,div,datos);
});
</script>