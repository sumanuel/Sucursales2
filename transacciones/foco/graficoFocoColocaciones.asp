<div class="row-fluid">
    <div id="graficoFocoColocacionesx" class="span12"></div>
    <div id="graficoFocoColocacionesx2" class="span12"></div>
    <div id="graficoFocoColocacionesx3" class="span12"></div>
    <div id="graficoFocoColocacionesx4" class="span12"></div>
</div>
<script type="text/javascript">
$(function(){

		pagina = 'transacciones/foco/grafico.asp';
		div = 'graficoFocoColocacionesx';
		datos='grafico=1&render=graficoFocoColocacionesx';
		enviaDatos(pagina,div,datos);

		setTimeout(function() {
			div = 'graficoFocoColocacionesx2';
			datos='grafico=2&render=graficoFocoColocacionesx2';
			enviaDatos(pagina,div,datos);
		}, 1500);
		

		setTimeout(function() {
			div = 'graficoFocoColocacionesx3';
			datos='grafico=3&render=graficoFocoColocacionesx3';
			enviaDatos(pagina,div,datos);
		}, 1500);
		

		setTimeout(function() {
			div = 'graficoFocoColocacionesx4';
			datos='grafico=4&render=graficoFocoColocacionesx4';
			enviaDatos(pagina,div,datos);
		}, 1500);

});


</script>