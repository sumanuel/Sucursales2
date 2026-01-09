<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span4 offset4">
				<span class="label label-info"> Pago de cuentas </span>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12" id="seleccionaFechaPagoCta">
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12">
				<div class="row-fluid">
					<div class="span1 offset11">
						<i class="icon-bar-chart icon-2x mano" id="iconoPagoCtas" data-tipoBoton="1"></i>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12" id="datosPagoCta"></div>
				</div>
				<div class="row-fluid">
					<div class="span12" id="graficoPagoCtas">
						<div class="row-fluid">
							<div class="span12">
								<span class="label seleccionaTipoGraficoPagoCta pagoCta2 mano" data-tipoGrafico="2">
									Cantidad
								</span>
								<span class="label seleccionaTipoGraficoPagoCta pagoCta1 mano" data-tipoGrafico="1">
									Monto
								</span>
								
							</div>
						</div>
						<div class="row-fluid">
							<div class="span12" id="muestraGraficoPagoCtas"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('#graficoPagoCtas').hide();
	var pagina, div, datos;
	pagina = 'maestroPagos/seleccionaFechaPagoCtas.asp';
	div = 'seleccionaFechaPagoCta';
	datos='';
	enviaDatos(pagina,div,datos);
});
$('#iconoPagoCtas').click(function(){
	var tipoBoton = $(this).attr('data-tipoBoton');
	if (tipoBoton ==='1')
	{
		$(this).hide('fast').delay(500).removeClass('icon-bar-chart').addClass('icon-table').attr('data-tipoBoton', '2').fadeIn('slow');
		$('#datosPagoCta').slideUp('fast');
		$('#graficoPagoCtas').slideDown('slow');
		var graficoSeleccionado = $('.seleccionaTipoGraficoPagoCta').first().attr('data-tipoGrafico');
		creaGraficoPagoCtas(graficoSeleccionado);
	}
	else
	{
		$(this).hide('fast').delay(500).removeClass('icon-table').addClass('icon-bar-chart').attr('data-tipoBoton', '1').fadeIn('slow');
		$('#graficoPagoCtas').slideUp('fast');
		$('#datosPagoCta').slideDown('slow');
	}
});
$('.seleccionaTipoGraficoPagoCta').click(function() {
	var graficoSeleccionado = $(this).attr('data-tipoGrafico');
	creaGraficoPagoCtas(graficoSeleccionado);
});
function creaGraficoPagoCtas(graficoSeleccionado)
{
	var valor, nombreSeriePagoCta,nombreSeriePagoCta2;
	var arregloValores = [];
	$('.seleccionaTipoGraficoPagoCta').removeClass('label-success');
	if ($('.seleccionaTipoGraficoPagoCta').hasClass('pagoCta'+graficoSeleccionado))
	{
		$('.pagoCta'+graficoSeleccionado).addClass('label-success');
	}
	if (graficoSeleccionado ==='1')
	{
		
		$('.valorMontoPagoCta').each(function() {
			valor = Number($(this).attr('data-valor'));
			arregloValores.push(valor);
		});
		nombreSeriePagoCta = 'Monto';
		nombreSeriePagoCta2 = 'Monto Total Cuentas';
	}
	else
	{
		$('.valorCantidadPagoCta').each(function() {
			valor = Number($(this).attr('data-valor'));
			arregloValores.push(valor);
		});
		nombreSeriePagoCta = 'Cantidad';
		nombreSeriePagoCta2 = 'Cantidad de Cuentas';
	}
	var valoresCategoriasPagoCta = [];
	$('.categoriaFechaPagoCta').each(function(){
		valor = $(this).attr('data-valor');
		valoresCategoriasPagoCta.push(valor);
	});
	$('#muestraGraficoPagoCtas').highcharts({
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
			text: nombreSeriePagoCta2
		},
		xAxis: {
			categories: valoresCategoriasPagoCta,
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
			name: nombreSeriePagoCta,
			data: arregloValores
		}]
	});
}
</script>