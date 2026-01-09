<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span1" id="divBtnCambiaGrafico">
				<span id="btnCambiaGrafico" class="label label-success mano" data-valor="1">
					Pagado
				</span>
			</div>
			<div class="offset1 span3" id="divBtnCambiaGraficoDiario">
				<span id="btnCambiaGraficoDiario" class="label label-success mano" data-valor="1">
					Comportamiento diario
				</span>
			</div>
		</div>
		<div class="row-fluid" id="graficosDP">
			<div class="row-fluid">
				<div class="span12" id="graficoDisponible"></div>	
			</div>
			<div class="row-fluid">
				<div class="span12" id="graficoPagado"></div>
			</div>
		</div>
		<div class="row-fluid" id="comportamientoDiario" data-valor="0">
			<div class="span12">
				<div class="row-fluid">
					<div class="span12">
						<span id="comportamientoTotales" class="label mano comportamiento total"> Ver : Totales</span>
						<span id="comportamientoIps" class="label  mano comportamiento ips">Ver : Ips</span>
						<span id="comportamientoAfp" class="label mano comportamiento afp">Ver : Afp</span>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12" id="mesesGrafico"></div>
				</div>
				<di class="row-fluid">
					<div class="span12" id="graficoComportamiento"></div>
				</di>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('#graficoPagado, #comportamientoDiario').slideUp('fast');
	var pagina, div, datos;
	pagina = 'maestroPagos/mesesGrafico.asp';
	div = 'mesesGrafico';
	datos='';
	enviaDatos(pagina,div,datos);
	graficoDisponible();
});
$('#btnCambiaGraficoDiario').click(function(){
	var valor = $(this).attr('data-valor');
	if (valor ==='1')
	{
		$('#btnCambiaGrafico, #graficosDP, #divBtnCambiaGrafico').slideUp('fast');
		$('#divBtnCambiaGraficoDiario').slideUp('fast').removeClass('offset1 span3').addClass('span2').slideDown('slow');
		$('#btnCambiaGraficoDiario').attr('data-valor','0').removeClass('label-success').addClass('label-important').text('Volver');
		$('#comportamientoDiario').slideDown('slow');
		muestraGraficoComportamiento();
	}
	else
	{
		$('#comportamientoDiario').slideUp('fast');
		$('#divBtnCambiaGraficoDiario').slideUp('fast').removeClass('span2').addClass('offset1 span3').slideDown('slow');
		$('#btnCambiaGraficoDiario').attr('data-valor','1').removeClass('label-important').addClass('label-success').text('Comportamiento diario');
		$('#btnCambiaGrafico, #graficosDP, #divBtnCambiaGrafico').slideDown('slow');
	}
});
$('#btnCambiaGrafico').click(function(){
	var tipoBoton = $(this).attr('data-valor');
	if (tipoBoton==='1')
	{
		$('#graficoDisponible').slideUp('fast');
		graficoPagado();
		$('#graficoPagado').slideDown('slow');
		$('#btnCambiaGrafico').attr('data-valor','0').text('Disponible');
	}
	else
	{
		$('#graficoPagado').slideUp('fast');
		graficoDisponible();	
		$('#graficoDisponible').slideDown('fast');
		$('#btnCambiaGrafico').attr('data-valor','1').text('Pagado');
	}
});
function subeComportamiento(boton)
{
	$('.comportamiento').slideUp('fast');
	if (boton==='total')
	{
		$('.ips, .afp').slideDown('slow');
	}
	if (boton ==='ips')
	{
		$('.total, .afp').slideDown('slow');
	}
	if (boton ==='afp')
	{
		$('.ips, .total').slideDown('slow');
	}
}
$('.total').click(function(){
	$('#comportamientoDiario').attr('data-valor','0');
	muestraGraficoComportamiento();
});
$('.ips').click(function(){
	$('#comportamientoDiario').attr('data-valor','1');
	muestraGraficoComportamiento();
});
$('.afp').click(function(){
	$('#comportamientoDiario').attr('data-valor','2');
	muestraGraficoComportamiento();
});

function muestraGraficoComportamiento()
{
	var nombreGrafico, fechaGrafico;
	$('.fechaGrafico').each(function(){
		if($(this).hasClass('label-success'))
		{
			fechaGrafico = $(this).attr('data-valor');
		}
	});
	var tipoGrafico = $('#comportamientoDiario').attr('data-valor');
	if (tipoGrafico ==='0')
	{
		subeComportamiento('total');
		nombreGrafico = 'Totales';
	}
	if (tipoGrafico ==='1')
	{
		subeComportamiento('ips');
		nombreGrafico = 'IPS';
	}
	if (tipoGrafico ==='2')
	{
		subeComportamiento('afp');
		nombreGrafico = 'AFP';
	}
	var pagosDisp = [];
	var cantPagos = [];
	var fechaDatos = [];

	var url = 'maestroPagos/datosGraficoComportamiento.asp?fecha='+fechaGrafico+'&tipoGrafico='+tipoGrafico;
	$.when($.ajax(url)).then(function(data) {
		$.each( data.datos, function( key, valoresDatos ) {
			var pago = valoresDatos.pago;
			var cantDisp = parseInt(valoresDatos.cantDisp);
			var cantPag = parseInt(valoresDatos.cantPag);
			var fecha = valoresDatos.fecha;

			if (tipoGrafico ==='0')
			{
				if (pago==='Total')
				{
					pagosDisp.push(cantDisp);
					cantPagos.push(cantPag);
				}	
			}
			if (tipoGrafico ==='1')
			{
				if (pago==='IPS')
				{
					pagosDisp.push(cantDisp);
					cantPagos.push(cantPag);
				}	
			}
			if (tipoGrafico ==='2')
			{
				if (pago==='AFP')
				{
					pagosDisp.push(cantDisp);
					cantPagos.push(cantPag);
				}
			}
			if(fechaDatos.indexOf(fecha) === -1)
			{  
			   fechaDatos.push(fecha);
			}
		});
		var habilita;
		var largoArreglo = data.datos.length;
		if (largoArreglo <=35)
		{
			habilita = true;
		}
		else
		{
			habilita = false;   
		}
		
		$('#graficoComportamiento').highcharts({
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
				series: {
					shadow: false
				}
			},
			xAxis: {
				categories: fechaDatos,
				lineColor: 'black',
				labels: {
					rotation: -45,
					align: 'right',
					style: {
						fontSize: '10px',
						fontFamily: 'Verdana, sans-serif'
					},
					enabled: habilita
				}
			},
			yAxis: {
				lineWidth: 1,
				tickWidth: 1,
				title: {
					align: 'high',
					offset: 0,
					text: 'Cantidades',
					rotation: 0,
					y: -10
				}
			},
			title: {
				text: nombreGrafico
			},
			series: [{
				name: 'Disponibles',
				data: pagosDisp
			},
			{
				name: 'Pagados',
				data: cantPagos
			}]
		});
	});
}
function graficoDisponible()
{
	var disponibleIps= parseInt($('#disponibleIQty3').attr('data-valor'));
	var disponibleAfp = parseInt($('#disponibleAQty3').attr('data-valor'));
	var totalDispRezago = disponibleIps+ disponibleAfp;
	var disponibleHoy = parseInt($('#disponibleCantidad2').attr('data-valor'));
	$('#graficoDisponible').highcharts({
		chart: {
			type: 'pie',
			options3d: {
				enabled: true,
				alpha: 45,
				beta: 0
			},
			width: 500,
			height: 350
		},
		title: {
			text: 'Cantidad disponible'
		},
		tooltip: {
			pointFormat: '{series.name}: <b>{point.percentage:.1f}% ({point.y}) </b>'
		},
		plotOptions: {
			pie: {
				innerSize: 100,
				depth: 45
			}
		},
		series: [{
			type: 'pie',
			name: 'Cantidad disponible ',
			data: [
				['Rezago',   totalDispRezago],
				['Hoy', disponibleHoy]
			]
		}]
	});
}
function graficoPagado()
{
	var pagadoIps = parseInt($('#pagadoIQty3').attr('data-valor'));
	var pagadoAfp = parseInt($('#pagadoAQty3').attr('data-valor'));
	var totalPagado = pagadoIps + pagadoAfp;
	var pagadoHoy = parseInt($('#pagadoCantidad2').attr('data-valor'));

	$('#graficoPagado').highcharts({
		chart: {
			type: 'pie',
			options3d: {
				enabled: true,
				alpha: 45,
				beta: 0
			},
			width: 500,
			height: 350
		},
		title: {
			text: 'Cantidad pagado'
		},
		tooltip: {
			pointFormat: '{series.name}: <b>{point.percentage:.1f}% ({point.y}) </b>'
		},
		plotOptions: {
			pie: {
				innerSize: 100,
				depth: 45
			}
		},
		series: [{
			name: 'Cantidad de pagos',
			data: [
				['Rezago',   totalPagado],
				['Hoy', pagadoHoy]
			]
		}]
	});
}

</script>