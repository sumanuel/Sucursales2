<!--#include file="../funciones.asp"-->
<%tendencias = trim(request("tendencias"))%>
<div class="row-fluid">
	<div class="span3">
		<span class="label label-important">Seleccione Año : </span> 
	</div>
	<div class="span9">
		<%sql = ""
		sql = sql & " select YEAR(fecha) "
		sql = sql & " from vw_Total_Pagos_Dia "
		if tendencias = "1" then
			sql = sql & " where pago = 'IPS' "
		end if
		if tendencias = "2" then
			sql = sql & " where pago = 'AFP' "
		end if
		sql = sql & " group by  YEAR(fecha) "
		sql = sql & " order by  YEAR(Fecha) desc "
		tieneDatos = 0
		set rs = db.execute(sql)
		if not rs.eof then
			datos = rs.getrows()
			tieneDatos = 1
		end if
		if tieneDatos = 1 then%>
			<select id="anioFecha" class="span7">
			<option value="">[Seleccione Año]</option>	
				<%for i = 0 to ubound(datos,2)
					anio = trim(datos(0,i))%>
					<option value="<%=anio%>">
						<%=anio%>
					</option>
				<%next%>
			</select>
		<%end if%>
		<span id="errorAnioFecha" class="label label-important">
			Debe seleccionar año
		</span>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('#errorAnioFecha').hide();
	var currentTime = new Date();
	var anioActual = currentTime.getFullYear();
	$('#anioFecha').val(anioActual);
	var tendencia = $('#anioTendencia').attr('data-tendencia');
	$('#errorAnioFecha').hide();
	var pagina, div, datos;
	pagina = 'maestroPagos/mesTendencias.asp';
	div = 'mesesTendencia';
	datos='anioTendencia='+anioActual+'&tendencia='+tendencia;
	enviaDatos(pagina,div,datos);
});
$('#anioFecha').change(function(){
	var tendencia = $('#anioTendencia').attr('data-tendencia');
	var valorAnio = $(this).val();
	if (valorAnio !=='')
	{
		$('#errorAnioFecha').hide();
		var pagina, div, datos;
		pagina = 'maestroPagos/mesTendencias.asp';
		div = 'mesesTendencia';
		datos='anioTendencia='+valorAnio+'&tendencia='+tendencia;
		enviaDatos(pagina,div,datos);
	}
	else
	{
		$('#errorAnioFecha').show();
	}
});
</script>
