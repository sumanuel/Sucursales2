<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))%>
<div id="CuerpoControlCajeros">
	<div id="divControlCajero" class="oculto" data-perfilMain="<%=perfilMain%>" data-idUsuario="<%=idUsuario%>"> </div>
	<div class="row-fluid">
		<div class="span12" id="faltanteSubMenu"></div>
	</div>
	<div class="row-fluid" id="faltanteHoyPeriodo"></div>
	<div class="row-fluid" id="faltanteCajeroHoyPeriodo">
		<div class="span12 text-center" id="subMenuFaltante"></div>
	</div>
	<div class="row-fluid" id="ctrolFaltanteTabla">
		<div class="span5" id="faltanteCargaTabla"></div>
		<div class="span7 " id="detalleEstadoFaltanteTabla"></div>
	</div>
	<!--<div class="row-fluid" id="ctrolCajeroTablaDetalle">		
		<div class="row-fluid">
			<div class="span6" id="ctrolCajeroCargaTablaDetalle"></div>
			<div class="span6" id="ctrolCajeroCargaGrafico"></div>
		</div>
		<div class="row-fluid" id="ctrolCajeroPeriodoDetalle"></div>
	</div>-->
	<!--<div class="row-fluid" id="ctrolCajeroTablaDetalleMod">
		<div class="span12" id="ctrolCajeroCargaTablaDetalleMod"></div>
	</div>
	<div class="row-fluid" id="ctrolCajeroTablaSuc">
		<div class="span12" id="ctrolCajeroTablaSucursal"></div>
	</div>
	<div class="row-fluid" id="ctrolCajeroTablaSucAsist">
		<div class="span12" id="ctrolCajeroTablaSucursalAsist"></div>
	</div>-->
</div>
<!--<div class="tab-content" id="divTablaCaj">
	<div class="row-fluid span12">
		<div class="span3" id="divTablaHoy"></div>
		<div class="span3" id="divTablaHoyAdicional"></div>
	</div>
	<div class="row-fluid" id="divDetallePeriodo">
		<div class="span6" id="divDetalleTablaPeriodo"></div>
		<div class="span5" id="divGraficoTotales"></div>
	</div>
	<div class="row-fluid" id="divDetalleDiario">
		<div class="span11" id="divDetalleDiarioTablaCajeros"></div>
	</div>
</div>-->

<script type="text/javascript">
	var pagina, div, datos, perfilMain, idUsuario;
	idUsuario = $('#divControlCajero').attr('data-idUsuario');
	perfilMain = $('#divControlCajero').attr('data-perfilMain');
	pagina = 'faltanteCajero.asp';
	div = 'faltanteSubMenu';
	datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain;
	enviaDatos(pagina,div,datos);
</script>
