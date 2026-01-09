<div class="row-fluid">
	<div class="span5">
		
		<div class="row-fluid">
			<div class="span12" id="muestraGrafico1"></div>
		</div>
	</div>
	<div class="span7" id="muestraGrafico2"></div>
</div>
<script type="text/javascript">
$(function(){
	setTimeout(function() {
		var pagina, div, datos;
		pagina = 'maestroPagos/grafico1a.asp';
		div = 'muestraGrafico1';
		datos='';
		enviaDatos(pagina,div,datos);
		pagina = 'maestroPagos/graficoRezagos.asp';
		datos='';
		div = 'muestraGrafico2';
		enviaDatos(pagina,div,datos);
	},500)
});


</script>