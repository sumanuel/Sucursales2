<div class="row-fluid">
	<div class="span2" id="menuLateral"></div>
	<div class="span10" id="cargaTransacciones"></div>
</div>
<script type="text/javascript">
$(function() {
	try{
		pagina = 'transacciones/menuTransacciones.asp';
		div = 'menuLateral';
		datos='';
		enviaDatos(pagina,div,datos);
		var consulta='1';
		var tipoConsulta = '1';
		pagina = 'transacciones/consultasTransacciones.asp';
		div = 'cargaTransacciones';
		datos='consulta='+consulta+'&tipoConsulta='+tipoConsulta;
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
});
</script>