<%
idSucursal = trim(request("sucursal"))
'response.write(idSucursal)
'response.end
muestraBoton = trim(request("muestraBoton"))
if muestraBoton = "" then muestraBoton = "0"%>
<input type="hidden" name="idSucursal" value="<%=idSucursal%>" id="idSucursal">
<%if muestraBoton = "1" then%>
	<div class="row-fluid">
		<div class="span2 pull-right alert alert-error mano" id="vuelveGerencia">
			Volver a vista zonales 
			<i class="icon-reply"></i>
		</div>
	</div>
<%end if%>

<div class="row-fluid">
	<div class="span12" id="miSucursal"></div>
</div>
<div class="row-fluid">
	<div class="span3 well tareasZonal mano" id="gDocumentalZonalSuc" data-idTipo="2"></div>
	<div class="span3 well tareasZonal mano" id="gContableZonalSuc" data-idTipo="3"></div>
	<div class="span3 well tareasZonal mano" id="gAdministrativaZonalSuc" data-idTipo="4"></div> 
	<div class="span3 well" id="panelZonal"></div> 
</div>
<div class="row-fluid">
	<div class="span12 oculto" id="tareasZonal"></div>
</div>
<script type="text/javascript">
pagina = 'indicadores/indicadorZonal.asp';
div = 'gAdministrativaZonalSuc';
datos = 'idSucursal='+$('#idSucursal').val()+'&tipo=4'
try{
       enviaDatos(pagina,div,datos);
}catch(err){}


pagina = 'indicadores/indicadorZonal.asp';
div = 'gContableZonalSuc';
datos = 'idSucursal='+$('#idSucursal').val()+'&tipo=3'
try{
       enviaDatos(pagina,div,datos);
}catch(err){}

div='gDocumentalZonalSuc';
datos = 'idSucursal='+$('#idSucursal').val()+'&tipo=2'
try{
       enviaDatos(pagina,div,datos);
}catch(err){}


pagina='sucursales/misucursal.asp';
div = 'miSucursal';
datos = 'idSucursal='+$('#idSucursal').val();
try{
       enviaDatos(pagina,div,datos);
}catch(err){}

pagina = 'sucursales/panelZonal.asp';
div = 'panelZonal';
datos = 'idSucursal='+$('#idSucursal').val();
try{
       enviaDatos(pagina,div,datos);
}catch(err){}

$('.tareasZonal').click(function(){
	var idTipo = $(this).attr('data-idTipo');
	var idSucursal = $('#idSucursal').val();
	datos = 'tipo='+idTipo+'&idSucursal='+idSucursal
	pagina = 'indices/GestionZon.asp';
	div = 'tareasZonal'
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#vuelveGerencia').click(function(){
	$('#areaTrabajoGerencia').fadeOut('fast');
	$('#menuGer, #datosZona, #areaDivTabsGerencia').fadeIn('slow');
	return false;
});
</script>