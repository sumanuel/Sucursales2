<!--#include file="../funciones.asp"-->
<%tipo = trim(request("tipo"))
tipoMenuTitulos = trim(request("tipoMenuTitulos"))
fechaActual = date()%>
<div class="row-fluid">
	<div class="span12"  id="areaMaestro">
		<div class="row-fluid">
			<div class="span10 well">
				<div class="row-fluid" id="divMaestroPagosAreaTrab" data-tipo="<%=tipo%>" data-tipoMenuTitulos="<%=tipoMenuTitulos%>">
					<div class="span12">
						<div class="row-fluid">
							<div class="span6" id="cuadro1"></div>
							<div class="span6" id="cuadro2"></div>
						</div>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<div class="row-fluid">
							<div class="span6" id="cuadro3"></div>
							<div class="span6" id="cuadro4"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="span2">
				<div class="row-fluid">
					<div class="span12">
						<span class="label label-info mano" id="cambiaTendencias">
							<i class="icon-bar-chart"></i> Tendencias
						</span>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<div class="row-fluid">
							<div class="span12">
								<span class="label label-info mano descarga" id="descarga1" data-descarga="1">
									<i class="icon-info-sign"></i>
									Distribución pagos <!--calendario pagos-->
								</span>	
							</div>
						</div>
						<div class="row-fluid divDescarga" id="divDescarga1">
							<div class="span12" id="seleccionaD1">
								<img src="img/loader.gif">
							</div>
						</div>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<div class="row-fluid">
							<div class="span12">
								<span class="label label-success mano descarga" id="descarga2" data-descarga="2">
									<i class="icon-cloud-download"></i>
									Pago Sucursal IPS (diario)
								</span>	
							</div>
						</div>
						<!-- sin selector
						<div class="row-fluid divDescarga" id="divDescarga2">
							<div class="span12">
								<select id="seleccionaD2" class="span9 seleccionaDescarga">
									<option value="">[Seleccione]</option>
									<option value="0">Todo</option>
									<option value="1">Hoy</option>
									<option value="2">Mañana</option>
								</select>
							</div>
						</div>		-->
					</div>
				</div>
			</div>
		</div>
		<div class="row-fluid">		
			<div class="span10 well">

			<div class="row-fluid" id="divMaestroPagosAreaTrab_v2" data-tipo="<%=tipo%>" data-tipoMenuTitulos="<%=tipoMenuTitulos%>">
				    <div class="span12">
						<div class="row-fluid">
							<div class="span5" id="cuadroBono1_v2"></div>
							<div class="span7" id="cuadroBono2_v2"></div>
						</div>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<div class="row-fluid">
							<div class="span5" id="cuadroBono3_v2"></div>
							<div class="span7" id="cuadroBono4_v2"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="span2">
				<div class="row-fluid">
					<div class="span12">
						<!--<span class="label label-success">
							<i class="icon-cloud-download"></i>
							boton 1
						</span>-->	
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<!--<span class="label label-success">
							 <i class="icon-cloud-download"></i>
							 Boton 2
						</span>-->		
					</div>
				</div>
			</div>
		</div>
		<div class="row-fluid">		
			<div class="span10 well">
			
				<div class="row-fluid" id="divMaestroPagosAreaTrab" data-tipo="<%=tipo%>" data-tipoMenuTitulos="<%=tipoMenuTitulos%>">
					<div class="span12">
						<div class="row-fluid">
							<div class="span5" id="cuadroBono1"></div>
							<div class="span7" id="cuadroBono2"></div>
						</div>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<div class="row-fluid">
							<div class="span5" id="cuadroBono3"></div>
							<div class="span7" id="cuadroBono4"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="span2">
				<div class="row-fluid">
					<div class="span12">
						<!--<span class="label label-success">
							<i class="icon-cloud-download"></i>
							boton 1
						</span>-->	
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<!--<span class="label label-success">
							 <i class="icon-cloud-download"></i>
							 Boton 2
						</span>-->		
					</div>
				</div>
			</div>
		</div>	
	</div>
</div>

<script type="text/javascript">
$(function(){
	$('.divDescarga').slideUp('fast');
	var pagina, div, datos;
	pagina = 'maestroPagos/tablaPagos1.asp';
	div = 'cuadro1';
	datos='';
	enviaDatos(pagina,div,datos);
	pagina = 'maestroPagos/tablaPagos2.asp';
	div = 'cuadro2';
	datos='';
	enviaDatos(pagina,div,datos);
	pagina = 'maestroPagos/tablaPagos3.asp';
	div = 'cuadro3';
	datos='';
	enviaDatos(pagina,div,datos);
	pagina = 'maestroPagos/tablaPagos4.asp';
	div = 'cuadro4';
	datos='';
	enviaDatos(pagina,div,datos);

	var pagina, div, datos;
	pagina = 'maestroPagos/tablaPagoBono1_v2.asp';
	div = 'cuadroBono1_v2';
	datos='';
	enviaDatos(pagina,div,datos);
	pagina = 'maestroPagos/tablaPagoBono2_v2.asp';
	div = 'cuadroBono2_v2';
	datos='';
	enviaDatos(pagina,div,datos);
	pagina = 'maestroPagos/tablaPagoBono3_v2.asp';
	div = 'cuadroBono3_v2';
	datos='';
	enviaDatos(pagina,div,datos);
	pagina = 'maestroPagos/tablaPagoBono4_v2.asp';
	div = 'cuadroBono4_v2';
	datos='';
	enviaDatos(pagina,div,datos);

	var pagina, div, datos;
	pagina = 'maestroPagos/tablaPagoBono1.asp';
	div = 'cuadroBono1';
	datos='';
	enviaDatos(pagina,div,datos);
	pagina = 'maestroPagos/tablaPagoBono2.asp';
	div = 'cuadroBono2';
	datos='';
	enviaDatos(pagina,div,datos);
	pagina = 'maestroPagos/tablaPagoBono3.asp';
	div = 'cuadroBono3';
	datos='';
	enviaDatos(pagina,div,datos);
	pagina = 'maestroPagos/tablaPagoBono4.asp';
	div = 'cuadroBono4';
	datos='';
	enviaDatos(pagina,div,datos);

	var url = 'maestroPagos/datosPagos.asp';
	$.when($.ajax(url)).done(function(data) {
		$.each( data.datos, function( key, valoresDatos ) {
			var area = valoresDatos.area;
			var tipo = valoresDatos.tipo;
			var valor = valoresDatos.valor;
			var tipoano = valoresDatos.tipoano;
			var areaTipo = area+'-'+tipo+'-'+tipoano;			

			if(tipoano == "0"){
				areaTipo = area+'-'+tipo;
				$('#'+areaTipo).text(valor);
			}else{
				$('#'+areaTipo).text(valor);
			}
			
		});
		$('.numero').prettynumber();
	});
	setTimeout(function() {
		/*var valorSumaProgramadosq = 0;
		$('.programadosq').each(function() {
			valorSumaProgramadosq += parseInt($(this).text());
		});
		$('#pgT1').text(valorSumaProgramadosq);	
		var valorSumaProgramadosm = 0;
		$('.programadosm').each(function() {
			valorSumaProgramadosm += parseInt($(this).text());
		});
		$('#pgT2').text(valorSumaProgramadosm);	
		var valorSumaBloqueadosq = 0;
		$('.bloqueadosq').each(function() {
			valorSumaBloqueadosq += parseInt($(this).text());
		});
		$('#pgT3').text(valorSumaBloqueadosq);	
		var valorSumaBloqueadosm = 0;
		$('.bloqueadosm').each(function() {
			valorSumaBloqueadosm += parseInt($(this).text());
		});
		$('#pgT4').text(valorSumaBloqueadosm);
		var valorSumaPagadosq = 0;
		$('.pagadosq').each(function() {
			valorSumaPagadosq += parseInt($(this).text());
		});
		$('#pgT5').text(valorSumaPagadosq);
		var valorSumaPagadosm = 0;
		$('.pagadosm').each(function() {
			valorSumaPagadosm += parseInt($(this).text());
		});
		$('#pgT6').text(valorSumaPagadosm);
		var valorSumaProgramadosq = 0;
		$('.programadosq').each(function() {
			valorSumaProgramadosq += parseInt($(this).text());
		});




		var valorSumaProgramadosMq = 0;
		$('.progMq').each(function() {
			valorSumaProgramadosMq += parseInt($(this).text());
		});
		$('#tablaM1').text(valorSumaProgramadosMq);	
		var valorSumaProgramadosMm = 0;
		$('.progMm').each(function() {
			valorSumaProgramadosMm += parseInt($(this).text());
		});
		$('#tablaM2').text(valorSumaProgramadosMm);	

		var valorSumaBloqueadosq = 0;
		$('.bloqueadosMq').each(function() {
			valorSumaBloqueadosq += parseInt($(this).text());
		});
		$('#tablaM3').text(valorSumaBloqueadosq);	
		var valorSumaBloqueadosm = 0;
		$('.bloqueadosMm').each(function() {
			valorSumaBloqueadosm += parseInt($(this).text());
		});
		$('#tablaM4').text(valorSumaBloqueadosm);

		var valorSumaPagadosq = 0;
		$('.pagadosMq').each(function() {
			valorSumaPagadosq += parseInt($(this).text());
		});
		$('#tablaM5').text(valorSumaPagadosq);
		var valorSumaPagadosm = 0;
		$('.pagadosMm').each(function() {
			valorSumaPagadosm += parseInt($(this).text());
		});
		$('#tablaM6').text(valorSumaPagadosm);


		var valorpagomsq = 0;
		$('.pagomsq').each(function() {
			valorpagomsq += parseInt($(this).text());
		});
		$('#totalPagmsq').text(valorpagomsq);	
		var valorpagomsm = 0;
		$('.pagomsm').each(function() {
			valorpagomsm += parseInt($(this).text());
		});
		$('#totalPagmsm').text(valorpagomsm);	
		var valorpagoosq = 0;
		$('.pagoosq').each(function() {
			valorpagoosq += parseInt($(this).text());
		});
		$('#totalPagosq').text(valorpagoosq);	
		var valorpagoosm = 0;
		$('.pagoosm').each(function() {
			valorpagoosm += parseInt($(this).text());
		});
		$('#totalPagosm').text(valorpagoosm);	



		var pago2msq = 0;
		$('.pago2msq').each(function() {
			pago2msq += parseInt($(this).text());
		});
		$('#totalPmsq').text(pago2msq);	
		var pago2msm = 0;
		$('.pago2msm').each(function() {
			pago2msm += parseInt($(this).text());
		});
		$('#totalPmsm').text(pago2msm);	
		var pago2osq = 0;
		$('.pago2osq').each(function() {
			pago2osq += parseInt($(this).text());
		});
		$('#totalPosq').text(pago2osq);	
		var pago2osm = 0;
		$('.pago2osm').each(function() {
			pago2osm += parseInt($(this).text());
		});
		$('#totalPosm').text(pago2osm);	*/

		

		


		
	}, 600);
	
});
$('.descarga').click(function(){
	var descarga = $(this).attr('data-descarga');
	if (descarga ==='1')
	{
		$('#divDescarga'+descarga).slideDown('fast');
		var pagina, div, datos;
		pagina = 'maestroPagos/seleccionaFecha.asp';
		div = 'seleccionaD'+descarga;
		datos='descarga='+descarga+'&tipo=1';
		enviaDatos(pagina,div,datos);
	}
	if (descarga === '2')
	{
		
		var pagina = 'maestroPagos/pagoSucursal.asp?pago=1';
		window.open(pagina)
	}
});

$('#cambiaTendencias').click(function(){
	var pagina, div, datos;
	pagina = 'maestroPagos/tendencias.asp';
	div = 'areaMaestro';
	datos='tendencia=1';
	enviaDatos(pagina,div,datos);
});
</script>
