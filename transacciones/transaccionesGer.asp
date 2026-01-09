<div class="row-fluid">
	<div class="span2" id="menuLateralTransacciones"></div>
	<div class="span10" id="cargaTransacciones"></div>
</div>
<script type="text/javascript">
	var pagina = 'transacciones/menuTransacciones.asp';
	var div = 'menuLateralTransacciones';
	var datos='';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){};
	var consulta='1';
	var tipoConsulta = '1';
	pagina = 'transacciones/consultasTransacciones.asp';
	div = 'cargaTransacciones';
	datos='consulta='+consulta+'&tipoConsulta='+tipoConsulta;
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}

</script>