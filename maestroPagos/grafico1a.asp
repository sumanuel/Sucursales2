<div class="row-fluid" id="botoneraGrafico">
	<div class="span12">
		<span class="label btnGrafico mano" id="botonIpsGrafico" data-btnTipo="1">
			IPS
		</span>
		<span class="label btnGrafico mano" id="botonAfpGrafico" data-btnTipo="2">
			AFP
		</span>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="grafico1"></div>
</div>
<script type="text/javascript">
$(function(){
	$('#botoneraGrafico').hide();
	var valoresCategorias = ['Disponible', 'Pagado'];
	var afp = [];
	var ips = [];
	var valor = parseInt($('#disponibleCantidad0').attr('data-valor'));
	ips.push(valor);
	valor = parseInt($('#pagadoCantidad0').attr('data-valor'));
	ips.push(valor);
	valor = parseInt($('#disponibleCantidad1').attr('data-valor'));
	afp.push(valor);
	valor = parseInt($('#pagadoCantidad1').attr('data-valor'));
	afp.push(valor);

	$('#grafico1').highcharts({
		chart: {
			type: 'column',
			width: 500,
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
			},
			series: {
				shadow: false,
				allowPointSelect: true,
				point: {
					events:{
						select: function(e) {
							selecciona(e.currentTarget.x);
						}
					} 
				}
			},
			column: {
				stacking: 'normal',
				dataLabels: {
					enabled: true,
				}
			}
		},
		title: {
			text: 'Disponible v/s Pagado'
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
		series: [{
			name: 'AFP',
			data: afp
		},
		{
			name: 'IPS',
			data: ips
		}]
	});
});
function selecciona(valorEjeSeleccionado)
{
	$('#botoneraGrafico').show('slow');
	$('#botonIpsGrafico, #botonAfpGrafico').attr('data-tipoGrafico', valorEjeSeleccionado);
	$('.btnGrafico').removeClass('btn-success');
}
$('#botonIpsGrafico, #botonAfpGrafico').click(function() {
	var pagina, div, datos, tipoGrafico, btnTipo;
	$('.btnGrafico').removeClass('label-success').addClass('label-important');
	$(this).addClass('label-success');
	tipoGrafico = $(this).attr('data-tipoGrafico');
	btnTipo = $(this).attr('data-btnTipo');
	pagina = 'maestroPAgos/grafico2.asp';
	div = 'grafico1';
	datos='tipoGrafico='+tipoGrafico+'&btnTipo='+btnTipo;
	enviaDatos(pagina,div,datos);
});
</script>