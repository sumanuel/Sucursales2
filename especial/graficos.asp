<div class="row-fluid">
	<div class="span12" id="graficoAnual"></div>
</div>
<div class="row-fluid">
	<div class="span12" id="graficoMensual">
		Mensual
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="graficoDiario">
		<img src="img/loader.gif"> 
		<span class="badge badge-info">
			Creando Gráfico
		</span>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="graficoRegional">
		<img src="img/loader.gif"> 
		<span class="badge badge-info">
			Creando Gráfico
		</span>
	</div>
</div>
<script type="text/javascript">
	$(function(){
		var pagina,div,datos
		pagina = 'especial/creaGrafico.asp';
		div = 'graficoAnual';
		datos= 'grafico=1';
		enviaDatos(pagina,div,datos)
		pagina = 'especial/seleccionaFechas.asp';
		div = 'graficoDiario';
		datos= '';
		detiene(pagina,div,datos,1000);
		pagina = 'especial/creaGrafico.asp';
		div = 'graficoRegional';
		datos= 'grafico=4';
		detiene(pagina,div,datos,1500);
	});
</script>