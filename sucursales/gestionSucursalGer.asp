<!--#include file="../funciones.asp"-->
<%tipo = trim(request("tipo"))
select case tipo
	case "1" :
		icono = "icon-archive"
		texto = "Gestión documental"
	case "2" :
		icono = "icon-money"
		texto="Gestión contable"
	case "3" :
		icono = "icon-group"
		texto = "Gestión administrativa"
end select%>
<div class="row-fluid mano" id="totalGestionGer<%=tipo%>">
	<div class="span12">
		<i class="<%=icono%> icon-2x ayuda" data-placement="top" data-original-title="<%=texto%>"></i>
		<div class="progress">
			<div class="bar" style="width: 60%;"></div>
		</div>
	</div>
</div>
<div class="row-fluid oculto" id="muestraDetalle<%=tipo%>">
	<div class="span12">
		<ul class="unstyled">
		<%
		sql = ""
		sql = sql & " select id_zonal,"
		sql = sql & " zonal,id_usuario "
		sql = sql & " from suc_zonales "
		sql = sql & " where estado_zonal = '1' "
		set rs = db.execute(sql)
		if not rs.eof then
			datosZonal = rs.GetRows()
		end if
		for x=0 to ubound(datosZonal,2)
			idZonal = trim(datosZonal(2,x))
			nombreZonal = server.htmlencode(trim(datosZonal(1,x)))%>
			<li id="<%=idZonal%>">
				<%=nombreZonal%>
				<div class="progress">
					<div class="bar" id="progreso<%=idZonal%>Tipo<%=tipo%>"></div>
				</div>
			</li>
		<%next%>
		</ul>
	</div>
</div>
<script type="text/javascript">
$('#totalGestionGer<%=tipo%>').click(function() {
	if ($('#muestraDetalle<%=tipo%>').hasClass('oculto'))
	{
		$('#muestraDetalle<%=tipo%>').removeClass('oculto').slideDown('slow');
	}
	else
	{
		$('#muestraDetalle<%=tipo%>').slideUp('fast').addClass('oculto');
	}
});
$.when($.ajax( "sucursales/detalleGestionSucursalGer.asp?tipo=<%=tipo%>" )).then(function(data) {
	$.each( data.datos, function( key, val ) {
		var idZonal = val.idZOnal;
		var valorProgreso  = val.valor;
		var tipo = val.tipo;
		$('#progreso'+idZonal+'Tipo'+tipo).css('width', valorProgreso);
	});
});
</script>
