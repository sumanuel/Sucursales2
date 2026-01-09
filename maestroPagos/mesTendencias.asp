<!--#include file="../funciones.asp"-->
<%anioTendencia = trim(request("anioTendencia"))
tendencia = trim(request("tendencia"))
sql = ""
sql = sql & " select month(fecha) "
sql = sql & " from vw_Total_Pagos_Dia "
sql = sql & " where year(fecha)= '"&anioTendencia&"' "
if tendencia = "1" then
	sql = sql & " and pago = 'IPS' "
end if
if tendencia = "2" then
	sql = sql & " and pago = 'AFP' "
end if
sql = sql & " group by month(fecha) "
sql = sql & " order by MONTH(fecha) "
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getrows()
	tieneDatos = 1
end if
if tieneDatos = 1 then%>
	<div class="row-fluid">
		<div class="span2">
			<span class="label label-important">
				Seleccione Mes :
			</span>
		</div>
		<div class="span4">
			<select id="mesFecha" data-anio="<%=anioTendencia%>">
				<option value=""> [Seleccione mes] </option>
				<%for i = 0 to ubound(datos,2)
					mes = trim(datos(0,i))
					nombreMes = primeraMayuscula(monthname(mes))%>
					<option value="<%=mes%>">
						<%=nombreMes%>
					</option>
				<%next%>
			</select>
			<span id="errorMesFecha" class="label label-important">
				Debe seleccionar año
			</span>
		</div>
	</div>
	<script type="text/javascript">
	$(function(){
		$('#errorMesFecha').hide();
		var currentTime = new Date();
		var mesActual = currentTime.getMonth() + 1;
		$('#mesFecha').val(mesActual);
		var tendencia = $('#anioTendencia').attr('data-tendencia');
		var anio = $('#mesFecha').attr('data-anio');
		var pagina, div, datos;
		pagina = 'maestroPagos/graficoTendencia1.asp';
		div = 'graficoTendencia1';
		datos='anioTendencia='+anio+'&mesTendencia='+mesActual+'&tendencia='+tendencia;
		enviaDatos(pagina,div,datos);
		$('#errorMesFecha').hide();
	});
	$('#mesFecha').change(function(){
		var valorMes = $(this).val();
		var tendencia = $('#anioTendencia').attr('data-tendencia');
		var anio = $(this).attr('data-anio');
		if (valorMes !=='')
		{
			var pagina, div, datos;
			pagina = 'maestroPagos/graficoTendencia1.asp';
			div = 'graficoTendencia1';
			datos='anioTendencia='+anio+'&mesTendencia='+valorMes+'&tendencia='+tendencia;
			enviaDatos(pagina,div,datos);
			$('#errorMesFecha').hide();
		}
		else
		{
			$('#errorMesFecha').show();
		}
	});
	</script>
<%end if%>