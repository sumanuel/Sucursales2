<!--#include file="../funciones2.asp"-->
<%fechaActual = date()
mesActual = month(fechaActual)
anioActual = year(fechaActual)
periodoActual = cint(anioActual)&cint(mesActual)
idColocacion = trim(request("idColocacion"))
perfilMain = trim(request("perfilMain"))
idCombo = trim(request("idCombo"))
if idCombo ="" then 
	idCombo = 0
end if

if idColocacion = "1" then
	sql = ""
	sql = sql & " select "
	sql = sql & " month(fecha_colocacion) as mes, year(fecha_colocacion) as anio  "
	sql = sql & " from SCVCC.dbo.OPCREDITOS  "
	sql = sql & " where cast(fecha_colocacion as date) >= '2016-01-01' "
	sql = sql & " group by month(fecha_colocacion), year(fecha_colocacion) "
	sql = sql & " order by year(fecha_colocacion) desc, month(fecha_colocacion) desc "
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
		<select id="comboFechas1">
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
	var id_combo = <%=idCombo%>;	
	if (id_combo == 0){		
		var periodo = $( "select#comboFechas1 option:selected" ).val();
		var mes = $( "select#comboFechas1 option:selected" ).attr('attrMes');
		var anio = $( "select#comboFechas1 option:selected" ).attr('attrAnio');
		var idColocacion = <%=idColocacion%>;
		var pagina = 'CheckListCredito/listaChecklistColo01.asp';
		var div = 'listaChecklistColo';
		var datos='periodo='+periodo+'&idColocacion='+idColocacion+'&mes='+mes+'&anio='+anio+'&id_combo='+id_combo;
		enviaDatos(pagina,div,datos);
	}
	if (id_combo == 3){		
		var periodo = $( "select#comboFechas1 option:selected" ).val();
		var mes = $( "select#comboFechas1 option:selected" ).attr('attrMes');
		var anio = $( "select#comboFechas1 option:selected" ).attr('attrAnio');
		var idColocacion = <%=idColocacion%>;
		var pagina = 'CheckListCredito/listaChecklistColo03.asp';
		var div = 'listaChecklistColo3';
		var datos='periodo='+periodo+'&idColocacion='+idColocacion+'&mes='+mes+'&anio='+anio+'&id_combo='+id_combo;
		enviaDatos(pagina,div,datos);
	}
	if (id_combo == 2){		
		var periodo = $( "select#comboFechas1 option:selected" ).val();
		var mes = $( "select#comboFechas1 option:selected" ).attr('attrMes');
		var anio = $( "select#comboFechas1 option:selected" ).attr('attrAnio');		
		var idColocacion = <%=idColocacion%>;
		var pagina = 'CheckListCredito/listaChecklistColo02.asp';
		var div = 'listaChecklistColo2';
		var datos='periodo='+periodo+'&idColocacion='+idColocacion+'&mes='+mes+'&anio='+anio+'&id_combo='+id_combo;
		enviaDatos(pagina,div,datos);
	}
});
$('#comboFechas1').change(function() {
	var id_combo = $('#idCombo').val();	
	var periodo = $( "select#comboFechas1 option:selected" ).val();
	var mes = $( "select#comboFechas1 option:selected" ).attr('attrMes');
	var anio = $( "select#comboFechas1 option:selected" ).attr('attrAnio');
	var idColocacion = <%=idColocacion%>;
	var pagina, idColocaciondiv, datos
	if (id_combo == 0){
		$('#listaChecklistColo').html('').hide();	
		var pagina = 'CheckListCredito/listaChecklistColo01.asp';
		var div = 'listaChecklistColo';
		var datos='idColocacion='+idColocacion+'&mes='+mes+'&anio='+anio;
		$('#listaChecklistColo').html('').hide();
		enviaDatos(pagina,div,datos);
	}
	if (id_combo == 2){
		var id_zonal = $('#idZonales').val();
		var pagina = 'CheckListCredito/listaChecklistColo02.asp';
		var div = 'listaChecklistColo2';
		//alert(mes);
		var datos='idColocacion='+idColocacion+'&mes='+mes+'&anio='+anio+'&id_combo='+id_combo+'&id_zonal='+id_zonal;
		$('#listaChecklistColo2').html('').hide();
		enviaDatos(pagina,div,datos);				
	}
	if (id_combo == 3){		
		var id_sucursal = $('#idSucursales').val();
		var id_zonal = $('#idZonales3').val();
		var pagina = 'CheckListCredito/listaChecklistColo03.asp';
		var div = 'listaChecklistColo3';
		var datos='periodo='+periodo+'&idColocacion='+idColocacion+'&mes='+mes+'&anio='+anio+'&id_combo='+id_combo+'&id_sucursal='+id_sucursal+'&id_zonal='+id_zonal;
		$('#listaChecklistColo3').html('').hide();
		enviaDatos(pagina,div,datos);		
	}
});

</script>