<div class="row-fluid">
    <div id="graficoAfiliaciones" class="span12"></div>
</div>
<div class="row-fluid">
    <div id="graficoAfiliaciones2" class="span12"></div>
</div>
<script type="text/javascript">
$(function(){
	var pagina, div,datos
	pagina = 'transacciones/foco/graficoAfiliaciones.asp';
	div = 'graficoAfiliaciones';
	datos='grafico=1&render=graficoAfiliaciones';
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
	pagina = 'transacciones/foco/graficoAfiliaciones.asp';
	div = 'graficoAfiliaciones2';
	datos='grafico=2&render=graficoAfiliaciones2';
	try{
		setTimeout(function() {
			enviaDatos(pagina,div,datos);
		}, 500);
		
	}catch(err){}

	$('#graficoAfiliacionesEspecial, #graficoAfiliacionesEspecialDiv').removeClass("hidden");
});

</script>