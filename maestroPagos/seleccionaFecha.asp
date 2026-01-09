<!--#include file="../funciones.asp"-->
<%descarga = trim(request("descarga"))
tipo = trim(request("tipo"))%>
<div class="row-fluid">
	<div class="span9">
		<%sql = ""
		sql = sql & " select month(fecha) as mes, "
		sql = sql & " YEAR(fecha) as anio "
		sql = sql & " from vw_Total_PagadosDisp_Dia "
		sql = sql & " group by month(fecha), "
		sql = sql & " YEAR(fecha) "
		sql = sql & " order by  year(fecha) desc, "
		sql = sql & " MONTH(fecha) desc"
		'response.write(sql)
		tieneDatos = 0
		set rs = db.execute(sql)
		if not rs.eof then
			datos = rs.getrows()
			tieneDatos = 1
		end if
		if tieneDatos = 1 then%>
			<select id="fecha" class="span12" data-descarga="<%=descarga%>" data-tipo="<%=tipo%>">
				<option value="">[Seleccione]</option>
			<%for i = 0 to ubound(datos,2)
				mes = trim(datos(0,i))
				anio = trim(datos(1,i))
				nombremesAnio = anio&" - "&primeraMayuscula(monthname(mes))
				if len(mes) = "1" then mes = "0"&mes
				anioMes = anio&mes%>
				<option value="<%=anioMes%>">
					<%=nombremesAnio%>
				</option>
			<%next%>
			</select>
		<%end if%>
	</div>
</div>
<script type="text/javascript">
$('#fecha').change(function(){
	$('.divDescarga').slideUp('fast');
	var mes = $(this).val();
	var tipo = $(this).attr('data-tipo');
	var pagina, div, datos;
	pagina = 'maestroPagos/principalSucursal.asp';
	div = 'areaMaestro';
	datos='mes='+mes+'&tipo='+tipo;
	enviaDatos(pagina,div,datos);
	/*var url = 'maestroPagos/descarga.asp?mes='+mes+'&idDescarga=';
	window.open(url, '_blank')*/
});
</script>