<div class="row-fluid">
	<div class="span1 offset11 mano" id="vuelveSucursal">
		<span class="label label-important">
			<i class="icon-arrow-left"></i> 
			Volver
		</span>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="sucursal">
		<div class="row-fluid">
			<div class="span5 well offset4">
				<div class="row-fluid">
					<div class="span2">
						<span class="label label-info">Sucursal</span>
					</div>
					<div class="span1">
						:
					</div>
					<div class="span9">
						<span class="label label-info"  id="nombreSucursalDato"></span>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span2">
						<span class="label label-info">
							Jeps
						</span>
					</div>
					<div class="span1">
						:
					</div>
					<div class="span9">
						<span class="label label-info"  id="nombreJepsDato"></span>
					</div>
				</div>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span6">
				<table id="tablaValoresSucursal" class="table table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th>
								Fecha
							</th>
							<th>
								Emitido
							</th>
							<th>
								Pagado
							</th>
							<th>
								% Pagado
							</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>	
			</div>
			<div class="span6" id="graficoSucursal"></div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	var principal = $('#principalSucursal');
	var idRegional = principal.attr('data-regional');
	var idZonal = principal.attr('data-zonal');
	var idSucursal = principal.attr('data-sucursal');
	var mes = principal.attr('data-mes');
	var tipo = principal.attr('data-tipo');
	var url = 'maestroPagos/datosSucursal.asp?idRegional='+idRegional+'&idZonal='+idZonal+'&mes='+mes+'&tipo='+tipo+'&idSucursal='+idSucursal;
	var arregloFecha = [];
	var arregloEmitido = [];
	var arregloPagado = [];
	var ingresaValoresTabla = '';
	$.when($.ajax(url)).done(function(data) {
		var valoresCategorias = ['Disponible', 'Pagado'];
		$.each( data.datos, function( key, valoresDatos ) {
			var fecha = valoresDatos.fecha;
			arregloFecha.push(fecha);
			var emitidoCantidad = valoresDatos.emitidoCantidad;
			var emitidoCantidadValor = parseInt(valoresDatos.emitidoCantidadValor);
			arregloEmitido.push(emitidoCantidadValor);
			var pagadoCantidad = valoresDatos.pagadoCantidad;
			
			var pagadoCantidadValor = parseInt(valoresDatos.pagadoCantidadValor);
			var porcPag = valoresDatos.porcPag;
			var nombreSucursal = valoresDatos.sucNombre;
			var sucJeps = valoresDatos.sucJeps;
			arregloPagado.push(pagadoCantidadValor);
			ingresaValoresTabla += '<tr>';
			ingresaValoresTabla += '<td>'+fecha+'</td>'
			ingresaValoresTabla += '<td>'+emitidoCantidad+'</td>'
			ingresaValoresTabla += '<td>'+pagadoCantidad+'</td>'
			ingresaValoresTabla += '<td>'+porcPag+'</td>'
			ingresaValoresTabla += '</tr>';
			$('#nombreSucursalDato').html(nombreSucursal);
			$('#nombreJepsDato').html(sucJeps);
		});
		
		$('#tablaValoresSucursal tbody').append(ingresaValoresTabla);
		$('#graficoSucursal').highcharts({
			chart: {
			type: 'column',
			width: 600,
			height: 400,
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
			column: {
				stacking: 'normal',
				dataLabels: {
					enabled: false,
				}
			}
		},
			title: {
				text: 'Emitido v/s Pagado'
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
				name: 'Emitido',
				data: arregloEmitido
			},
			{
				name: 'Pagado',
				data: arregloPagado
			}]
		});
	});
});
$('#vuelveSucursal').click(function() {
	pagina = 'maestroPagos/sucursales.asp';
	div = 'sucursal';
	datos='';
	enviaDatos(pagina,div,datos);
});
</script>