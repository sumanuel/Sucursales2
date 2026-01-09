<div class="row-fluid">
	<div class="span2 offset10 mano volverGrafico alert alert-success">
		<span class="icon-stack icon-large  ayuda" data-placement="right" data-original-title="Grafico">
				<i class="icon-check-empty icon-stack-base"></i>
				<i class="icon-arrow-left"></i>
			</span>
		 <strong>Volver</strong>
	</div>
</div>
<%consulta = trim(request("consulta"))
if consulta = "" then consulta = "1"
tipoConsulta = trim(request("tipoConsulta"))%>
<div class="row-fluid">
	<div id="cargaGrafico" class="span12"></div>
</div>
<script type="text/javascript">
$(function(){
	try{
		var consulta = '<%=consulta%>';
		var tipoConsulta = '<%=tipoConsulta%>';
		pagina = 'transacciones/grafico.asp';
		div = 'cargaGrafico';
		datos='consulta='+consulta+'&tipoConsulta='+tipoConsulta;
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	$('.volverGrafico').click(function(){
		try{
			pagina = 'transacciones/transacciones.asp';
			div = 'transaccionesGer';
			datos='';
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
	});
});
</script>