<!--#include file="../funciones.asp"-->
<%fechaTermino2 = date()
fechaInicio2 = Dateadd("m", -1, fechaTermino2)%>
<input type="hidden" name="fechaTermino2" id="fechaTermino2" value="<%=fechaTermino2%>">
<input type="hidden" name="fechaInicio2" id="fechaInicio2" value="<%=fechaInicio2%>">
<div class="row-fluid">
	<div class="span5">
		<div id="divfechaInicio" class="input-append">
			<span class="badge">
				Inicio
			</span>
			<input data-format="dd/MM/yyyy" type="text" id="fechaInicio" name="fechaInicio"/>
			<span class="add-on">
				<i data-time-icon="icon-time" data-date-icon="icon-calendar"></i>
			</span>
		</div>
		<div class="oculto text-error" id="mensajeFechaInicioSeleccionaRango">
			La fecha no tiene datos
		</div>
	</div>
	<div class="span5">
		<div id="divfechaTermino" class="input-append">
			<span class="badge">
				Termino
			</span>
			<input data-format="dd/MM/yyyy" type="text" id="fechaTermino" name="fechaTermino"/>
			<span class="add-on">
				<i data-time-icon="icon-time" data-date-icon="icon-calendar"></i>
			</span>
		</div>
		<div class="oculto text-error" id="mensajeFechaTerminoSeleccionaRango">
			La fecha no tiene datos
		</div>
	</div>
	<div class="span2">
		<span class="btn btn-inverse" id="btnVistaMensual">
			<i class="icon-exchange"></i>
			Vista mensual
		</span>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="muestraGrafico"></div>
</div>
<script type="text/javascript">
$(function(){
	if ($('#fechaTermino').val() === '' && $('#fechaInicio').val() ==='')
	{
		var valorTermino = $('#fechaTermino2').val();
		var valorInicio = $('#fechaInicio2').val();
		$('#fechaTermino').val(valorTermino);
		$('#fechaInicio').val(valorInicio);
		var pagina = 'especial/creaGrafico.asp';
		var div = 'muestraGrafico';
		var datos = 'fechaInicio='+valorInicio+'&fechaTermino='+valorTermino+'&grafico=3';
		enviaDatos(pagina,div,datos);
	}
});
$('#divfechaInicio').datetimepicker({
	language: 'es-Cl',
	pickTime: false
}).on('changeDate',function(){
	var valorInicio = $('#fechaInicio').val();
	var valorTermino = $('#fechaTermino').val();
	if (valorInicio !=='' && valorTermino !=='')
	{
		$('#mensajeFechaInicioSeleccionaRango').addClass('oculto');
		var pagina = 'especial/creaGrafico.asp';
		var div = 'muestraGrafico';
		var datos = 'fechaInicio='+valorInicio+'&fechaTermino='+valorTermino+'&grafico=3';
		enviaDatos(pagina,div,datos);
	}
	else
	{
		$('#mensajeFechaInicioSeleccionaRango').removeClass('oculto');
	}
});
$('#divfechaTermino').datetimepicker({
	language: 'es-Cl',
	pickTime: false
}).on('changeDate',function(){
	var valorInicio = $('#fechaInicio').val();
	var valorTermino = $('#fechaTermino').val();
	if (valorInicio !=='' && valorTermino !=='')
	{
		$('#mensajeFechaTerminoSeleccionaRango').addClass('oculto');
		var pagina = 'especial/creaGrafico.asp';
		var div = 'muestraGrafico';
		var datos = 'fechaInicio='+valorInicio+'&fechaTermino='+valorTermino+'&grafico=3';
		enviaDatos(pagina,div,datos);
	}
	else
	{
		$('#mensajeFechaTerminoSeleccionaRango').removeClass('oculto');
	}
});
$('#btnVistaMensual').click(function(){
	var pagina = 'especial/vistaMensual.asp';
	var div = 'graficoDiario';
	var datos='';
	enviaDatos(pagina,div,datos);
});
</script>