<!--#include file="../funciones2.asp"-->
<%fechaActual = date()
mesActual = month(fechaActual)
anioActual = year(fechaActual)
periodoActual = cint(anioActual)&cint(mesActual)
idColocacion = trim(request("idColocacion"))
perfilMain = trim(request("perfilMain"))
idComboRepro = trim(request("idComboRepro"))
if idComboRepro ="" then 
	idComboRepro = 0
end if

if idColocacion = "2" then
	sql = ""
	sql = sql & " select "
	sql = sql & " month(fecreprogramacion) as mes, year(fecreprogramacion) "
	sql = sql & " as anio from SCVCC.dbo.OPREPROCR "
	sql = sql & " group by month(fecreprogramacion), year(fecreprogramacion)  "
	sql = sql & " order by year(fecreprogramacion) desc, month(fecreprogramacion) desc "
	'response.write(sql)
	'response.end
end if

set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getRows()
end if%>
<div class="row-fluid">
	<div class="span4">
		Seleccione Período
	</div>
	<div class="span6">
		<select id="comboFechas2">
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
	var idComboRepro = <%=idComboRepro%>;	
	if (idComboRepro == 0){		
		var periodo = $( "select#comboFechas2 option:selected" ).val();
		var mes = $( "select#comboFechas2 option:selected" ).attr('attrMes');
		var anio = $( "select#comboFechas2 option:selected" ).attr('attrAnio');
		var idColocacion = <%=idColocacion%>;
		var pagina = 'CheckListCredito/listaChecklistRepro01.asp';
		var div = 'listaChecklistRepro';
		var datos='periodo='+periodo+'&idColocacion='+idColocacion+'&mes='+mes+'&anio='+anio+'&idComboRepro='+idComboRepro;
		enviaDatos(pagina,div,datos);
	}
	if (idComboRepro == 3){		
		var periodo = $( "select#comboFechas2 option:selected" ).val();
		var mes = $( "select#comboFechas2 option:selected" ).attr('attrMes');
		var anio = $( "select#comboFechas2 option:selected" ).attr('attrAnio');
		var idColocacion = <%=idColocacion%>;
		var pagina = 'CheckListCredito/listaChecklistRepro03.asp';
		var div = 'listaChecklistRepro3';
		var datos='periodo='+periodo+'&idColocacion='+idColocacion+'&mes='+mes+'&anio='+anio+'&idComboRepro='+idComboRepro;
		enviaDatos(pagina,div,datos);
	}
	if (idComboRepro == 2){		
		var periodo = $( "select#comboFechas2 option:selected" ).val();
		var mes = $( "select#comboFechas2 option:selected" ).attr('attrMes');
		var anio = $( "select#comboFechas2 option:selected" ).attr('attrAnio');		
		var idColocacion = <%=idColocacion%>;
		var pagina = 'CheckListCredito/listaChecklistRepro02.asp';
		var div = 'listaChecklistRepro2';
		var datos='periodo='+periodo+'&idColocacion='+idColocacion+'&mes='+mes+'&anio='+anio+'&idComboRepro='+idComboRepro;
		enviaDatos(pagina,div,datos);
	}
});
$('#comboFechas2').change(function() {
	var idComboRepro = $('#idComboRepro').val();	
	var periodo = $( "select#comboFechas2 option:selected" ).val();
	var mes = $( "select#comboFechas2 option:selected" ).attr('attrMes');
	var anio = $( "select#comboFechas2 option:selected" ).attr('attrAnio');
	var idColocacion = <%=idColocacion%>;
	var pagina, idColocaciondiv, datos
	if (idComboRepro == 0){
		$('#listaChecklistColo').html('').hide();	
		var pagina = 'CheckListCredito/listaChecklistRepro01.asp';
		var div = 'listaChecklistRepro';
		var datos='idColocacion='+idColocacion+'&mes='+mes+'&anio='+anio;
		$('#listaChecklistRepro').html('').hide();
		enviaDatos(pagina,div,datos);
	}
	if (idComboRepro == 2){
		var id_zonal = $('#idZonalesRepro').val();
		var pagina = 'CheckListCredito/listaChecklistRepro02.asp';
		var div = 'listaChecklistRepro2';
		//alert(mes);
		var datos='idColocacion='+idColocacion+'&mes='+mes+'&anio='+anio+'&idComboRepro='+idComboRepro+'&id_zonal='+id_zonal;
		$('#listaChecklistRepro2').html('').hide();
		enviaDatos(pagina,div,datos);				
	}
	if (idComboRepro == 3){		
		var id_sucursal = $('#idSucursales').val();
		var id_zonal = $('#idZonales3').val();
		var pagina = 'CheckListCredito/listaChecklistRepro03.asp';
		var div = 'listaChecklistRepro3';
		var datos='periodo='+periodo+'&idColocacion='+idColocacion+'&mes='+mes+'&anio='+anio+'&idComboRepro='+idComboRepro+'&id_sucursal='+id_sucursal+'&id_zonal='+id_zonal;
		$('#listaChecklistRepro3').html('').hide();
		enviaDatos(pagina,div,datos);		
	}
});
</script>