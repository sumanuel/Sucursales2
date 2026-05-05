<%idSucursal=trim(request("idSucursalMain"))
if idSucursal = "0" then
  idSucursal = trim(request("idSucursal"))
end if
perfil = trim(request("perfilMain"))%>
	<!--<span id="tabMenu5" class="mano" data-placement="top" title="Mensajes">
		<i class="icon-comment-alt icon-2x mano"></i>
		<span id="numeroMensajes" class="badge badge-info mano">0</span>
	</span>-->
<div class="row-fluid">
	<div class="span12">
		<!--<span id="tabMenu6" class="mano" data-placement="top" title="Incidencias" data-idSucursal="<%=idSucursal%>">
			<i class="icon-flag-alt icon-2x mano"></i>
			<span id="numeroIncidencias" class="badge badge-info mano">0</span>
		</span>-->
		<!--<span id="agregaTareaSucursal" class="mano" data-placement="left" title="Agregar visita" data-idSucursal="<%=idSucursal%>">
			<i class="icon-pushpin icon-2x mano"></i>
		</span>-->
		<span id="tabMenu8" class="mano" data-placement="left" title="Encuesta de aseo" data-idSucursal="<%=idSucursal%>">
			<i class="icon-ticket icon-2x mano" ></i>
		</span>
		<!--<span id="muestraCalendarioSucursal" class="mano" data-placement="left" title="Calendario Sucursal" data-idSucursal="<%=idSucursal%>">
			<i class="icon-calendar icon-2x mano" ></i>
		</span>-->
		<span id="muestraIndicesGrafico" class="mano" data-placement="left" title="Mostrar gráficos" data-idSucursal="<%=idSucursal%>">
			<i class="icon-bar-chart icon-2x mano" ></i>
		</span>
	    <span id="muestraAsistenciaCajeros" class="mano" data-placement="left" title="Asistencia Cajeros" data-idSucursal="<%=idSucursal%>">
			<i class="icon-user icon-2x mano" ></i>		
		</span>
	    <span id="muestraAsistenciaGuardias" class="mano" data-placement="left" title="Asistencia Guardias" data-idSucursal="<%=idSucursal%>">
			<i class="icon-shield icon-2x mano" ></i>		
		</span>
		<span id="muestraDotacion" class="mano" data-placement="left" title="Ingreso Dotacion" data-idSucursal="<%=idSucursal%>">
			<i class="icon-group icon-2x mano" ></i>		
		</span>
		<%if perfil = "2" then%>
		<!--<span id="muestraAuditoria" class="mano" data-placement="left" title="Audutoria" data-idSucursal="<%=idSucursal%>">
			<i class="icon-legal icon-2x mano" ></i>
		</span>-->
		<%end if%>
	</div>
</div>
<script type="text/javascript">
var idSucursal, pagina,div,datos
$('#tabMenu6').click(function(){
	idSucursal = $(this).attr('data-idSucursal');
	pagina='incidencias/muestraIncidenciasZonal.asp';
	div='tareasZonal';
	datos = 'idSucursal='+idSucursal
	enviaDatos(pagina,div,datos);
	return false;
});
$('#tabMenu8').click(function(){
	idSucursal = $(this).attr('data-idSucursal');
	pagina='encuestaAseo/encuestaZonal.asp';
	div='tareasZonal';
	datos = 'idSucursal='+idSucursal
	enviaDatos(pagina,div,datos);
	return false;
});
$('#agregaTareaSucursal').click(function(){
	idSucursal = $(this).attr('data-idSucursal');
	pagina='visitas/agregaVisita.asp';
	div='tareasZonal';
	datos = 'idSucursal='+idSucursal+'&noZonal=0'
	enviaDatos(pagina,div,datos);
	$('#tareasZonal').addClass('well');
	return false;

});
$('#muestraCalendarioSucursal').click(function(){
	idSucursal = $(this).attr('data-idSucursal');
	pagina = 'calendario/calendario.asp';
	div='tareasZonal';
	datos = 'idSucursal='+idSucursal
	enviaDatos(pagina,div,datos);
	return false;
});
$('#muestraIndicesGrafico').click(function(){
	idSucursal = $(this).attr('data-idSucursal');
	pagina = 'indices/indicesZonal.asp';
	div = 'tareasZonal';
	datos = 'idSucursal='+idSucursal;
	enviaDatos(pagina,div,datos);
	return false;
});
$('#muestraAsistenciaCajeros').click(function(){

	idSucursal = $(this).attr('data-idSucursal');
	//pagina = 'sucursales/asistenciaSucursalCajeros_ver.asp';
	pagina = 'sucursales/asistenciaSucursalCajeros_zonal.asp';
	div = 'tareasZonal';
	datos = 'idSucursal='+idSucursal;
	enviaDatos(pagina,div,datos);
	return false;
});
$('#muestraAsistenciaGuardias').click(function(){
	idSucursal = $(this).attr('data-idSucursal');
	pagina = 'sucursales/asistenciaSucursalGuardias_ver.asp';
	div = 'tareasZonal';
	datos = 'idSucursal='+idSucursal;
	enviaDatos(pagina,div,datos);
	return false;
});
$('#muestraDotacion').click(function(){
	idSucursal = $(this).attr('data-idSucursal');
	pagina = 'dotacion/dotacion_ver.asp';
	div = 'tareasZonal';
	datos = 'idSucursal='+idSucursal;
	enviaDatos(pagina,div,datos);
	return false;
});
$('#muestraAuditoria').click(function(){
	idSucursal = $(this).attr('data-idSucursal');
	pagina = 'auditoria/auditoria.asp';
	div = 'tareasZonal';
	datos = 'idSucursal='+idSucursal;
	enviaDatos(pagina,div,datos);
	return false;
});
/*$('#actualizaSuc').click(function(event) {
	idSucursal = $(this).attr('data-idSucursal');
	pagina = 'sucursales/actualizaSucursal.asp';
	div = 'tareasZonal';
	datos = 'idSucursal='+idSucursal;
	enviaDatos(pagina,div,datos);
	return false;
});*/
</script>
	

