<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span4 offset4">
				<span class="label label-info"> Recarga telefonica </span>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12" id="seleccionaFechaRecTel">
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12">
				<div class="row-fluid">
					<div class="span1 offset11">
						<i class="icon-bar-chart icon-2x mano" id="iconoRecCel" data-tipoBoton="1"></i>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12" id="datosRecCel"></div>
				</div>
				<div class="row-fluid">
					<div class="span12" id="graficoRecCel">
						<div class="row-fluid">
							<div class="span12">
								<span class="label seleccionaTipoGrafico 2 mano" data-tipoGrafico="2">
									Cantidad
								</span>
								<span class="label seleccionaTipoGrafico 1 mano" data-tipoGrafico="1">
									Monto
								</span>
							</div>
						</div>
						<div class="row-fluid">
							<div class="span12" id="muestraGraficoCel"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('#graficoRecCel').hide();
	var pagina, div, datos;
	pagina = 'maestroPagos/seleccionaFechaRecTel.asp';
	div = 'seleccionaFechaRecTel';
	datos='';
	enviaDatos(pagina,div,datos);
});
$('#iconoRecCel').click(function(){
	var tipoBoton = $(this).attr('data-tipoBoton');
	if (tipoBoton ==='1')
	{
		$(this).hide('fast').delay(500).removeClass('icon-bar-chart').addClass('icon-table').attr('data-tipoBoton', '2').fadeIn('slow');
		$('#datosRecCel').slideUp('fast');
		$('#graficoRecCel').slideDown('slow');
		var graficoSeleccionado = $('.seleccionaTipoGrafico').first().attr('data-tipoGrafico');
		creaGraficoRecTel(graficoSeleccionado);
	}
	else
	{
		$(this).hide('fast').delay(500).removeClass('icon-table').addClass('icon-bar-chart').attr('data-tipoBoton', '1').fadeIn('slow');
		$('#graficoRecCel').slideUp('fast');
		$('#datosRecCel').slideDown('slow');
	}
});
$('.seleccionaTipoGrafico').click(function() {
	var graficoSeleccionado = $(this).attr('data-tipoGrafico');
	creaGraficoRecTel(graficoSeleccionado);
});
function creaGraficoRecTel(graficoSeleccionado)
{
	var valor, nombreSerie,nombreSerie2;
	var arregloValores = [];
	$('.seleccionaTipoGrafico').removeClass('label-success');
	if ($('.seleccionaTipoGrafico').hasClass(graficoSeleccionado))
	{
		$('.'+graficoSeleccionado).addClass('label-success');
	}
	if (graficoSeleccionado ==='1')
	{
		
		$('.valorMonto').each(function() {
			valor = Number($(this).attr('data-valor'));
			arregloValores.push(valor);
		});
		nombreSerie = 'Monto';
		nombreSerie2 = 'Monto Total Recargas';
	}
	else
	{
		$('.valorCantidad').each(function() {
			valor = Number($(this).attr('data-valor'));
			arregloValores.push(valor);
		});
		nombreSerie = 'Cantidad';
		nombreSerie2 = 'Cantidad de Recargas';
	}
	var valoresCategorias = [];
	$('.categoriaFecha').each(function(){
		valor = $(this).attr('data-valor');
		valoresCategorias.push(valor);
	});
	$('#muestraGraficoCel').highcharts({
		chart: {
			type: 'column',
			width: 600,
			height: 350,
			options3d: {
				enabled: true,
				alpha: 0,
				beta: 30,
				depth: 70
			}
		},
		plotOptions: {
			area: {
				color:'rgba(24,90,169,.75)',
				fillColor:'rgba(24,90,169,.25)',
				marker: {
					enabled: false,
					symbol:'circle'
				}
			}
		},
		title: {
			text: nombreSerie2
		},
		xAxis: {
			categories: valoresCategorias,
			labels: {
				rotation: -45,
				align: 'right',
				style: {
					fontSize: '11px',
					fontFamily: 'Verdana, sans-serif'
				}
			}
		},
		yAxis: {
			min: 0,
			title: {
				text: 'Totales'
			}
		},
		tooltip: {
			headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
			pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td><td style="padding:0"><b>{point.y} </b></td></tr>',
			footerFormat: '</table>',
			shared: true,
			useHTML: true
		},
		series: [
		{
			name: nombreSerie,
			data: arregloValores
		}]
	});
}
</script>