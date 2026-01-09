<!--#include file="../funciones2.asp"-->
<%
sql = ""
sql = sql & "select "
sql = sql & "month(fecha_envio_caja) as mes, year(fecha_envio_caja) as anio "
sql = sql & "from SUC_vcc_caja "
sql = sql & "where id_estado = 204 and fecha_envio_caja is not null "
sql = sql & "group by month(fecha_envio_caja), year(fecha_envio_caja) "
sql = sql & "order by month(fecha_envio_caja) desc, year(fecha_envio_caja) asc "

'response.write(sql)
'response.end

set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getRows()
end if%>
<div class="row-fluid">
	<div class="span6">
		Seleccione Período Envió
	</div>
	<div class="span6">
		<select id="comboFechas3">
			<%for i = 0 to ubound(datos,2)
				mes = cint(trim(datos(0,i)))
				anio = cint(trim(datos(1,i)))
				nombreMesSistema = MonthName(mes)
				periodo = anio&mes
				nombrePeriodo = nombreMesSistema&" "&anio
				seleccion = ""
				if periodo = periodoActual then seleccion = "selected"%>
				<option attrMes="<%=mes%>" attrAnio="<%=anio%>" value="<%=periodo%>" <%=seleccion%>>
					<%=primeraMayuscula(nombrePeriodo)%>
				</option>
			<%next%>
		</select>
	</div>
</div>
<script type="text/javascript">
$(function(){	
	//var periodo = $( "select#comboFechas3 option:selected" ).val();
	var mes = $( "select#comboFechas3 option:selected" ).attr('attrMes');
	var anio = $( "select#comboFechas3 option:selected" ).attr('attrAnio');	
	var pagina = 'CheckListCredito/ListaCajasEnviadas.asp';
	var div = 'ListaCajasEnviadas';
	var datos = 'mes='+mes+'&anio='+anio;
	enviaDatos(pagina,div,datos);	
});
$('#comboFechas3').change(function(){	
	var mes = $( "select#comboFechas3 option:selected" ).attr('attrMes');
	var anio = $( "select#comboFechas3 option:selected" ).attr('attrAnio');	
	var pagina = 'CheckListCredito/ListaCajasEnviadas.asp';
	var div = 'ListaCajasEnviadas';
	var datos = 'mes='+mes+'&anio='+anio;
	enviaDatos(pagina,div,datos);	
});

</script>