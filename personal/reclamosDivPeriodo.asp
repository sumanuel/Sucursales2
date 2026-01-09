<!--#include file="../funciones.asp"-->
<%tipoVista = trim(request("tipoVista"))

filtroPeriodo = trim(request("filtroPeriodo"))

if tipoVista = 3 then
	filtroEstadoSLA = trim(request("filtroEstadoSLA"))
end if

sql = ""
sql = sql + "select "
sql = sql + "CONVERT(nvarchar(6),caso_fecha_cre, 112) as idperiodo, "
sql = sql + "dbo.FN_PERIODO(CONVERT(nvarchar(6),caso_fecha_cre, 112)+'01',3) as periodo "
sql = sql + "from SUC_casos "
sql = sql + "group by CONVERT(nvarchar(6),caso_fecha_cre, 112) "
sql = sql + "order by CONVERT(nvarchar(6),caso_fecha_cre, 112) desc "

set rs = db.execute(sql)
if not rs.eof then
	datosPeriodo = rs.getrows()
end if
%>
<style >
	.popover {  		
	  max-width: 90%;
	}
</style>
<%
	GlosaTbV1 = "Periodo TODOS : <br> Este Filtro muestra todos los casos que <b>'NO'</b> se encuentra en estado <b>'CERRADO'</b>. "
%>
<div class="text-center" ><b style="font-size: 16px">Seleccione Periodo:</b>
<% if tipoVista = 3 then %>
	<select id="cboPeriodoSelectReclamo" data-filtroPeriodo="<%=filtroPeriodo%>" data-filtroSla="<%=filtroEstadoSLA%>">
<% else %>
	<select id="cboPeriodoSelectReclamo" data-filtroPeriodo="<%=filtroPeriodo%>">
<% end if %>
		<option value="0">TODOS</option>
		<%for i = 0 to ubound(datosPeriodo,2)
					id_periodoSel = trim(datosPeriodo(0,i))
					periodoNombreSel = trim(datosPeriodo(1,i))%>
					<option value="<%=id_periodoSel%>"><%=periodoNombreSel%></option>	
		<%next%> 
	</select>
<% if tipoVista = 2 or tipoVista = 3 then %>
	<i style="font-size: 12px" class="icon-comment" data-toggle="popover" title="Glosa" data-trigger="hover" data-content="<%=GlosaTbV1%>">Filtro Todos</i>
<% end if %>
</div>

<div class="text-center oculto" id="divGifCargandoReclamos">
		<Strong>CARGANDO CASOS</Strong><br><img src="../img/loader.gif"> 
</div>
<div class="text-center" id="reclamosCuerpoTrabajo2"></div>


<% if tipoVista = 1 then %>

<script type="text/javascript">
	$(function(){	

		var filtroPerido = $('#cboPeriodoSelectReclamo').attr('data-filtroPeriodo');

		$("#cboPeriodoSelectReclamo").val(filtroPerido);
		//$("#divGifCargandoReclamos").removeClass("oculto");

		var div = 'reclamosCuerpoTrabajo2';
	    var datos = 'periodoSel='+filtroPerido+'&tipoVista=1';
	    var pagina = 'creaGraficoGestionCasos_ii.asp'; 
	    enviaDatos(pagina,div,datos);

	});

	$('#cboPeriodoSelectReclamo').change(function() {
		var periodoSeleccionado= $('select#cboPeriodoSelectReclamo option:selected').val();
		
		//$("#divGifCargandoReclamos").removeClass("oculto");

		var div = 'reclamosCuerpoTrabajo2';
	    var datos = 'periodoSel='+periodoSeleccionado+'&tipoVista=1';
	    var pagina = 'creaGraficoGestionCasos_ii.asp'; 
	    enviaDatos(pagina,div,datos);
	});
</script>

<% end if %>

<% if tipoVista = 2 then %>

<script type="text/javascript">
	$(document).ready(function(){
	    $('[data-toggle="popover"]').popover({
	    	 html:true
	    });   
	});
		$(function(){
			$("#divGifCargandoReclamos").removeClass("oculto");	

			
			var filtroPerido = $('#cboPeriodoSelectReclamo').attr('data-filtroPeriodo');

			$("#cboPeriodoSelectReclamo").val(filtroPerido);
			
			$('#reclamosCuerpoTrabajo2').removeClass('text-center');			
			$('#reclamosCuerpoTrabajo2').addClass('text-left');

		    var div = 'reclamosCuerpoTrabajo2';
		    var datos = 'periodoSel='+filtroPerido+'&tipoVista=2';
		    var pagina = 'cuadroControlGC.asp';
		    enviaDatos(pagina,div,datos);

		});

		$('#cboPeriodoSelectReclamo').change(function() {

			$("#divGifCargandoReclamos").removeClass("oculto");

			var periodoSeleccionado= $('select#cboPeriodoSelectReclamo option:selected').val();
			
			var div = 'reclamosCuerpoTrabajo2';
		    var datos = 'periodoSel='+periodoSeleccionado+'&tipoVista=2';
		    var pagina = 'cuadroControlGC.asp';
		    enviaDatos(pagina,div,datos);
		});
	</script>
<% end if %>

<% if tipoVista = 3 then %>

<script type="text/javascript">
	$(document).ready(function(){
	    $('[data-toggle="popover"]').popover({
	    	 html:true
	    });   
	});
		$(function(){

			var filtroPerido = $('#cboPeriodoSelectReclamo').attr('data-filtroPeriodo');
			var filtroSla = $('#cboPeriodoSelectReclamo').attr('data-filtroSla');

			$("#cboPeriodoSelectReclamo").val(filtroPerido);
			$("#cboPeriodoSelectReclamo").val(filtroPerido);

			$("#divGifCargandoReclamos").removeClass("oculto");	
			$('#reclamosCuerpoTrabajo2').removeClass('text-center');			
			$('#reclamosCuerpoTrabajo2').addClass('text-left');

		    var div = 'reclamosCuerpoTrabajo2';
		    var datos = 'periodoSel='+filtroPerido+'&tipoVista=3&filtroSla='+filtroSla;
		    var pagina = 'cuadroControlGC.asp';
		    enviaDatos(pagina,div,datos);

		});

		$('#cboPeriodoSelectReclamo').change(function() {

			$("#divGifCargandoReclamos").removeClass("oculto");

			var periodoSeleccionado= $('select#cboPeriodoSelectReclamo option:selected').val();
			
			var div = 'reclamosCuerpoTrabajo2';
		    var datos = 'periodoSel='+periodoSeleccionado+'&tipoVista=2';
		    var pagina = 'cuadroControlGC.asp';
		    enviaDatos(pagina,div,datos);
		});
	</script>
<% end if %>