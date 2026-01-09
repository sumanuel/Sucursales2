<!--#include file="../funciones.asp"-->
<%tendencias = trim(request("tendencia"))
fechaActual = date()%>
<div class="row-fluid">
	<div class="span4" id="anioTendencia" data-tendencia="<%=tendencias%>"></div>
	<div class="span6" id="mesesTendencia"></div>
	<div class="span2 text-right" id="volver">
		<span class="label label-important mano" id="btnVolverTendencia">
			<i class="icon-arrow-left"></i> Volver
		</span>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="graficoTendencia1"></div>
</div>
<script type="text/javascript">
var tendencia = $('#anioTendencia').attr('data-tendencia');
var pagina, div, datos;
pagina = 'maestroPagos/anioTendencias.asp';
div = 'anioTendencia';
datos='tendencia='+tendencia;
enviaDatos(pagina,div,datos);
$('#btnVolverTendencia').click(function(){
	var tendencia = $('#anioTendencia').attr('data-tendencia');
	if ($('ul#menuTitulos li').hasClass('active'))
	{
		var tipoMenuTitulos = $(this).attr('data-tipo');
	}
	var pagina, div, datos;
	if (tendencia ==='1') {
		pagina = 'maestroPagos/maestroPagosAreaTrabajo.asp';
		tipoMenuTitulos = 1
	}
	if (tendencia ==='2') {
		pagina = 'maestroPagos/afp.asp';
		tipoMenuTitulos = 2;
	}

	div = 'areaTrabajoMaestro';
	datos='tipo=1&tipoMenuTitulos='+tipoMenuTitulos;
	enviaDatos(pagina,div,datos);
});
</script>