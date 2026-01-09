<%anioTendencia = trim(request("anioTendencia"))
mesTendencia = trim(request("mesTendencia"))
tendencia = trim(request("tendencia"))%>
<div class="row-fluid">
	<div class="span8" id="graficoTendencias1" data-anio="<%=anioTendencia%>" data-mes="<%=mesTendencia%>"></div>
	<div class="span4">
		<table id="tablaDatosGrafico1" class="table table-bordered table-hover table-condensed">
			<thead>
				<tr>
					<th>
						Fecha
					</th>
					<th>
						Disponible
					</th>
					<th>
						Pagado
					</th>
				</tr>
			</thead>
			<tbody>
				
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
var anioTendencia = $('#graficoTendencias1').attr('data-anio');
var mesTendencia = $('#graficoTendencias1').attr('data-mes');
var url='maestroPagos/datosGraficoTendencia1.asp?anioTendencia='+anioTendencia+'&mesTendencia='+mesTendencia+'&tipo='+tendencia;
var arregloFecha = [];
var arregloDisponible = [];
var arregloPagado = [];
var trMuestra = '';
$.when($.ajax(url)).done(function(data) {
	$.each( data.datos, function( key, valoresDatos ) {
		var fecha = valoresDatos.fecha;
		arregloFecha.push(fecha);
		var disponible = parseInt(valoresDatos.cantDisp);
		arregloDisponible.push(disponible);
		var pagado = parseInt(valoresDatos.cantPag);
		arregloPagado.push(pagado);
		var disponibleF = valoresDatos.cantDispF;
		var pagadoF = valoresDatos.cantPagF;
		trMuestra += '<tr>';
		trMuestra += '<td>'+fecha+'</td>';
		trMuestra += '<td class="numero">'+disponibleF+'</td>';
		trMuestra += '<td class="numero">'+pagadoF+'</td>';
		trMuestra += '</tr>';
	});
	$('#tablaDatosGrafico1 tbody').append(trMuestra);
	$('.numero').prettynumber();
	$('#graficoTendencias1').highcharts({
		chart: {
			type: 'column',
			width: 800,
			height: 450,
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
			/*series: {
				shadow: false,
				allowPointSelect: true,
				point: {
					events:{
						select: function(e) {
							selecciona(e.currentTarget.x);
						}
					} 
				}
			},*/
			column: {
				stacking: 'normal',
				dataLabels: {
					enabled: false,
				}
			}
		},
		title: {
			text: 'Disponible v/s Pagado'
		},
		xAxis: {
			categories: arregloFecha,
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
			name: 'Disponible',
			data: arregloDisponible
		},
		{
			name: 'Pagado',
			data: arregloPagado
		}]
	});
});

</script>