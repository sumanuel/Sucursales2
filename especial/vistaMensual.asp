<div class="row-fluid">
	<div class="span3 offset9 btn btn-inverse" id="btnVistaDiaria">
		<i class="icon-exchange"></i>
		Volver a vista diaria
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="muestraGrafico"></div>
</div>
<script type="text/javascript">
	$(function(){
		var pagina = 'especial/creaGrafico.asp';
		var div = 'muestraGrafico';
		var datos = 'grafico=2';
		enviaDatos(pagina,div,datos);
	});
	$('#btnVistaDiaria').click(function(){
		pagina = 'especial/seleccionaFechas.asp';
		div = 'graficoDiario';
		datos= '';
		enviaDatos(pagina,div,datos);
	});
</script>