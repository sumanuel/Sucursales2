<div class="row-fluid">
	<div id="divReporteTotalAlerta">
		<div class="span12" id="reporteTotalAlerta"></div>
	</div>
</div>
<div class="row-fluid">
	<div id="divListarContenido">
		<div class="span12 well" id="listarContenido"></div>
	</div>
</div>
<div class="row-fluid">
	<div id="divMenuTrabPens">
		<div class="span12" id="menuTrabPens"></div>
	</div>
</div>
<div class="row-fluid">
	<div id="divReporteDetalleTabla">
		<div class="span12 well" id="reporteDetalleTabla"></div>
	</div>
</div>
<script type="text/javascript">
	var pagina, div, datos;
	pagina = 'report/reporteTotalAlerta.asp';
	div = 'reporteTotalAlerta';
	datos='';
	enviaDatos(pagina,div,datos);
	$('#reporteDetalleTabla, #listarContenido').slideUp('fast');
</script>
