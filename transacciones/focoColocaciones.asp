<div class="row-fluid">
	<div class="span4" id="sucursalesFocoColocaciones"></div>
	<div class="span5" id="graficoFocoColocaciones"></div>
	<div class="span3" id="promedioFocoColocaciones"></div>
</div>
<script type="text/javascript">
$(function(){
	try{
		pagina = 'transacciones/foco/sucursalesFocoColocaciones.asp';
		div = 'sucursalesFocoColocaciones';
		datos='';
		enviaDatos(pagina,div,datos);
		pagina = 'transacciones/foco/promedioFocoColocaciones.asp';
		div = 'promedioFocoColocaciones';
		datos='';
		enviaDatos(pagina,div,datos);
		setTimeout(function(){
		pagina = 'transacciones/foco/graficoFocoColocaciones.asp';
		div = 'graficoFocoColocaciones';
		datos='';
		enviaDatos(pagina,div,datos);
		}, 1000);
	}
	catch(err){}
});
</script>