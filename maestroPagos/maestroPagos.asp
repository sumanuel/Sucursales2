<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span12" id="menuTitulos"></div>
		</div>
		<div class="row-fluid">
			<div class="span12 " id="areaTrabajoMaestro"></div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	var pagina, div, datos;
	pagina = 'maestroPagos/menuTitulos.asp';
	div = 'menuTitulos';
	datos='';
	enviaDatos(pagina,div,datos);
	Highcharts.setOptions({
		lang: {
			numericSymbols: null, 
			thousandsSep: '.',
			decimalPoint: ','
		}
	});
});
</script>