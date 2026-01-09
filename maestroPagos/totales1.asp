
<div class="row-fluid">
	<div class="span12" id="divTabla1"></div>
</div>
<div class="row-fluid">
	<div class="span12" id="divGrafico1"></div>
</div>
<script type="text/javascript">
$(function(){
	var pagina, div, datos;
	pagina = 'maestroPagos/tablaDisponibles.asp';
	div = 'divTabla1';
	datos='';
	enviaDatos(pagina,div,datos);
});
</script>