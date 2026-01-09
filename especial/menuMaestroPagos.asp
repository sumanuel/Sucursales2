<%tipoMenuTitulos = trim(request("tipoMenuTitulos"))%>
<div class="row-fluid">
	<div class="spna12">
		<div class="tabbable tabs-right">
			<ul class="nav nav-tabs" id="menuMaestroPagos">
				<li id="rf" data-tipo="1" data-tipoMenu="<%=tipoMenuTitulos%>" class="active">
					<a href="#">Red Fija</a>
				</li>
				<!--<li id="rmrf" data-tipo="2" data-tipoMenu="<%=tipoMenuTitulos%>">
					<a href="#">Red Movil en Red Fija</a>
				</li>-->
			</ul>
		</div>
	</div>
</div>
<script type="text/javascript">
/*	
	$('#rf').click(function() {
		$('#menuMaestroPagos li').each(function() {
			$(this).removeClass('active')
		});
		$(this).addClass('active');
		var tipo = $(this).attr('data-tipo');
		var tipoMenuTitulos = $(this).attr('data-tipoMenu');
		var pagina, div, datos;
		pagina = 'especial/maestroPagosAreaTrabajo.asp';
		div = 'areaTrabajoMaestro';
		datos='tipo='+tipo+'&tipoMenuTitulos='+tipoMenuTitulos;
		enviaDatos(pagina,div,datos);
	});
	$('#rmrf').click(function() {
		$('#menuMaestroPagos li').each(function() {
			$(this).removeClass('active')
		});
		$(this).addClass('active');
		var tipo = $(this).attr('data-tipo');
		var tipoMenuTitulos = $(this).attr('data-tipoMenu');
		var pagina, div, datos;
		pagina = 'especial/maestroPagosAreaTrabajo.asp';
		div = 'areaTrabajoMaestro';
		datos='tipo='+tipo+'&tipoMenuTitulos='+tipoMenuTitulos;
		//alert(datos)
		enviaDatos(pagina,div,datos);
	});
	$('#calendarioPagos').click(function() {
		$('#menuMaestroPagos li').each(function() {
			$(this).removeClass('active')
		});
		$(this).addClass('active');
		var tipo = $(this).attr('data-tipo');
		var tipoMenuTitulos = $(this).attr('data-tipoMenu');
		var pagina, div, datos;
		pagina = 'especial/maestroPagosAreaTrabajo.asp';
		div = 'areaTrabajoMaestro';
		datos='tipo='+tipo+'&tipoMenuTitulos='+tipoMenuTitulos;
		//alert(datos)
		enviaDatos(pagina,div,datos);
	});*/
</script>