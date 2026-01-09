<%mes = trim(request("mes"))
tipo = trim(request("tipo"))%>
<div class="row-fluid">
	<div class="span12" id="principalSucursal" data-mes="<%=mes%>" data-regional="" data-zonal="" data-sucursal="" data-tipo="<%=tipo%>">
		<div class="row-fluid" id="divRegionales">
			<div class="span12" id="regionales">
				<img src="img/loader.gif">
			</div>
		</div>
		<div class="row-fluid" id="divZonales">
			<div class="span12" id="zonales">
				<img src="img/loader.gif">
			</div>
		</div>
		<div class="row-fluid" id="divSucursal">
			<div class="span12" id="sucursal">
				<img src="img/loader.gif">
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('#divZonales, #divSucursal').slideUp('fast');
	var pagina, div, datos;
	pagina = 'maestroPagos/regionales.asp';
	div = 'regionales';
	datos='';
	enviaDatos(pagina,div,datos);
});
</script>