<div class="row-fluid">
	<div class="span4" id="sucursalesFocoAfiliaciones"></div>
	<div class="span5" id="graficoFocoAfiliaciones"></div>
	<div class="span3" id="promedioFocoAfiliaciones"></div>
</div>
<script type="text/javascript">
$(function(){
	try{
		pagina = 'transacciones/foco/sucursalesFocoAfiliaciones.asp';
		div = 'sucursalesFocoAfiliaciones';
		datos='';
		enviaDatos(pagina,div,datos);
		pagina = 'transacciones/foco/promedioFocoAfiliaciones.asp';
		div = 'promedioFocoAfiliaciones';
		datos='';
		enviaDatos(pagina,div,datos);
		setTimeout(function(){
			pagina = 'transacciones/foco/graficoFocoAfiliaciones.asp';
			div = 'graficoFocoAfiliaciones';
			datos='';
			enviaDatos(pagina,div,datos);
		}, 1000);
	}
	catch(err){}
});
</script>