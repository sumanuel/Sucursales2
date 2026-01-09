
<div class="row-fluid">
	<div class="span5 well">
		<div class="row-fluid">
			<div class="span12" id="muestraFechaTotalAlerta"></div>
		</div>
		<div class="row-fluid">
			<div class="span12" id="reporteTotalTablaAlerta"></div>
		</div>
	</div>
	<div class="span7 well">
		<div class="row-fluid">
			<div class="span12" id="divMuestraCaja"></div>
		</div>
		<div class="row-fluid">
			<div class="span12" id="reporteTotalGraficoAlerta"></div>
		</div>
		<div class="row-fluid">
			
		</div>
	</div>
</div>
<script type="text/javascript">
	var pagina, div, datos;
	pagina = 'report/seleccionaFechaTotalAlerta.asp';
	div = 'muestraFechaTotalAlerta';
	datos='';
	enviaDatos(pagina,div,datos);
	$('#divMuestraCaja').slideUp('fast');
</script>