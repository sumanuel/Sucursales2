<div class="row-fluid">
	<div class="span12" id="areaMaestro">
		<div class="row-fluid">
			<div class="span10 well">
				<div class="row-fluid">
					<div class="span12">
						<div class="row-fluid">
							<div class="span6 textoCentrado">
								<span class="label label-info">
									AFP
								</span>
							</div>
							<div class="span5 textoCentrado">
								<span class="label label-info">
									Pagos en Sucursal
								</span>
							</div>
							<div class="span1 mano abreTablaPago1">
								<span class="label label-important"> 
									<span id="iconoCierra1">
										<i class="icon-collapse"></i>
									</span>
									Mas datos
								</span>
							</div>
						</div>
						<div class="row-fluid">
							<div class="span6" id="tablaAfp1"></div>
							<div class="span6" id="tablaAfp2"></div>
						</div>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<div class="row-fluid">
							<div class="span6 textoCentrado">
								<span class="label label-info">
									Pagos por Convenio
								</span>
							</div>
							<div class="span5 textoCentrado">
								<span class="label label-info">
									Convenios pagados en sucursal
								</span>
							</div>
						</div>
						<div class="row-fluid">
							<div class="span6" id="tablaAfp3"></div>
							<div class="span6" id="tablaAfp4"></div>
						</div>	
					</div>
				</div>
			</div>
			<div class="span2">
				<div class="row-fluid">
					<div class="span12">
						<span class="label label-info mano descarga" id="descarga1" data-descarga="1">
							<i class="icon-bar-chart"></i> Tendencias
						</span>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<span class="label label-success mano descarga" id="descarga2" data-descarga="2">
							<i class="icon-cloud-download"></i>
							Pago Sucursal AFP
						</span>	
					</div>
				</div>
			</div>
		</div>	
	</div>
</div>
<script type="text/javascript">
var pagina, div, datos;
pagina = 'maestroPagos/tablaPagoAfp1.asp';
div = 'tablaAfp1';
datos='';
enviaDatos(pagina,div,datos);
pagina = 'maestroPagos/tablaPagoAfp2.asp';
div = 'tablaAfp2';
datos='';
enviaDatos(pagina,div,datos);
pagina = 'maestroPagos/tablaPagoAfp3.asp';
div = 'tablaAfp3';
datos='';
enviaDatos(pagina,div,datos);
pagina = 'maestroPagos/tablaPagoAfp4.asp';
div = 'tablaAfp4';
datos='';
enviaDatos(pagina,div,datos);
var url = 'maestroPagos/datosAfp.asp';
$.when($.ajax(url)).done(function(data) {
	$.each( data.datos, function( key, valoresDatos ) {
		var area = valoresDatos.area;
		var tipo = valoresDatos.tipo;
		var valor = valoresDatos.valor;
		var areaTipo = area+'-'+tipo;
		$('#'+areaTipo).text(valor);
	});
	$('.numero').prettynumber();
});

$('.descarga').click(function(){
	var descarga = $(this).attr('data-descarga');
	if (descarga ==='1')
	{
		var pagina, div, datos;
		pagina = 'maestroPagos/tendencias.asp';
		div = 'areaMaestro';
		datos='tendencia=2';
		enviaDatos(pagina,div,datos);
	}
	if (descarga === '2')
	{
		
		var pagina = 'maestroPagos/pagoSucursal.asp?pago=2';
		window.open(pagina)
	}
});
</script>

