
<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))

sql = "exec SUC_prc_eva_get_periodo"

set rs = db.execute(sql)
if not rs.eof then
	datosPeriodo = rs.getrows()
end if

%>
<style type="text/css">
.flex-parent{
  display: -ms-flex;
  display: -webkit-flex;
  display: flex;
}
 
.flex-child{
  display: -ms-flex;
  display: -webkit-flex;
  display: flex;
  justify-content: center;
  flex-direction: column;
}

</style>


<div class="row-fluid flex-parent" >
	<div class=" flex-child" id="evaluacionGeneralp1">
		<b >Seleccione Periodo:</b>		
		<select id="cboPeriodoSelectEva">
			<option value='0'>Seleccione Periodo</option>
			<%for i = 0 to ubound(datosPeriodo,2)
				periodoSel = trim(datosPeriodo(0,i))
			if i = 0 then%>
				<option value="<%=periodoSel%>" selected><%=periodoSel%></option>
			<%else%>
				<option value="<%=periodoSel%>"><%=periodoSel%></option>
			<%end if
				next%>
		</select>
	</div>
	<div class="span10" id="semaphore">		
	</div>
</div>
</br>
<div class="row-fluid">
	<div class="span3 text-center" ><b>REGIONALES</b></div>
	<div class="span3 text-center" ><b>ZONALES</b></div>
	<div class="span3 text-center" ><b>SUCURSALES</b></div>
	<div class="span3 text-center" ><b>TOP MALOS</b></div>
</div>
<div class="row-fluid">
	<div class="span3" id="regional"></div>
	<div class="span3" id="zonal"></div>
	<div class="span3" id="sucursal"></div>
	<div class="span3" id="top"></div>
</div>


<script type="text/javascript">

	$(document).ready(function(){	   
		var periodo= $('#cboPeriodoSelectEva').val();
     	var pagina, div, datos;
	    pagina = 'evaluacion_EvaGeneralSemaphore.asp';
		div = 'semaphore';
		datos=	'periodo='+periodo;
		enviaDatos(pagina,div,datos);

		var pagina2, div2, datos2;
	    pagina2 = 'evaluacion_EvaGeneralTablesRegional.asp';
		div2 = 'regional';
		datos2=	'periodo='+periodo;
		enviaDatos(pagina2,div2,datos2);

		var pagina3, div3, datos3;
	    pagina3 = 'evaluacion_EvaGeneralTablesZonal.asp';
		div3 = 'zonal';
		datos3=	'periodo='+periodo;
		enviaDatos(pagina3,div3,datos3);

		var pagina4, div4, datos4;
	    pagina4 = 'evaluacion_EvaGeneralTablesSucursal.asp';
		div4 = 'sucursal';
		datos4=	'periodo='+periodo+'&zonal=0';
		enviaDatos(pagina4,div4,datos4);

		var pagina5, div5, datos5;
	    pagina5= 'evaluacion_EvaGeneralTablesTop.asp';
		div5 = 'top';
		datos5=	'periodo='+periodo;
		enviaDatos(pagina5,div5,datos5);

	});

	$('#cboPeriodoSelectEva').change(function(){	
	    var periodo= $('#cboPeriodoSelectEva').val();
     	var pagina, div, datos;
	    pagina = 'evaluacion_EvaGeneralSemaphore.asp';
		div = 'semaphore';
		datos=	'periodo='+periodo;
		enviaDatos(pagina,div,datos);
	
		var pagina2, div2, datos2;
	    pagina2 = 'evaluacion_EvaGeneralTablesRegional.asp';
		div2 = 'regional';
		datos2=	'periodo='+periodo+'&opcion=1';
		enviaDatos(pagina2,div2,datos2);
	
		var pagina3, div3, datos3;
	    pagina3 = 'evaluacion_EvaGeneralTablesZonal.asp';
		div3 = 'zonal';
		datos3=	'periodo='+periodo;
		enviaDatos(pagina3,div3,datos3);

		var pagina4, div4, datos4;
	    pagina4 = 'evaluacion_EvaGeneralTablesSucursal.asp';
		div4 = 'sucursal';
		datos4=	'periodo='+periodo+'&zonal=0';
		enviaDatos(pagina4,div4,datos4);

		var pagina5, div5, datos5;
	    pagina5= 'evaluacion_EvaGeneralTablesTop.asp';
		div5 = 'top';
		datos5=	'periodo='+periodo;
		enviaDatos(pagina5,div5,datos5);

	});

</script>
