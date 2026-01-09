<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span2">
				<span class="label label-success" id="mesActual"></span>
			</div>
			<div class="span9"></div>
			<div class="span1 mano">
				<span class="label label-important" id="volverRegionales">
					<i class="icon-arrow-left"></i> Volver
				</span>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12" id="muestraData">
				<div class="row-fluid">
					<div class="span3 offset4">
						<img src="img/loader.gif">	
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
$('#volverRegionales').click(function(){
	var tipoMenuTitulos
	$('ul#menuTitulos li').each(function() {
		if ($(this).hasClass('active'))
		{
			tipoMenuTitulos = $(this).attr('data-tipo');		
		}
	});
	var pagina, div, datos;
	pagina = 'maestroPagos/maestroPagosAreaTrabajo.asp';
	div = 'areaTrabajoMaestro';
	datos='tipo=1&tipoMenuTitulos='+tipoMenuTitulos;
	enviaDatos(pagina,div,datos);
});
var principal = $('#principalSucursal');
var mes = principal.attr('data-mes');
var nombresMes = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio","Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
var mesActual = parseInt(mes.substr(4, 6))-1
var anioActual = parseInt(mes.substr(0, 4))
mesActual = nombresMes[mesActual];
$('#mesActual').text(mesActual+' '+anioActual);
var tipo = principal.attr('data-tipo');
var url = 'maestroPagos/datosRegionales.asp?mes='+mes+'&tipo='+tipo;
var generaHtml = '';
$.when($.ajax(url)).then(function(data) {
	var i,x,valorCampo;
	var totalRegistros = data.datos.length;
	var cuentaCampos = 0;
	var totalRows = totalRegistros * 4;
	totalRows =  Math.round(totalRows / 12);
	for (i = 1; i <= totalRows; i++)
	{
		generaHtml += '<div class="row-fluid">';
		for (x=1 ; x<= 4; x++ )
		{
			valorCampo = x*i;
			generaHtml += '<div class="span3 '+valorCampo+' campo mano well" id="campo'+valorCampo+'">';
			generaHtml += '<div class="row-fluid">';
			generaHtml += '<div class="span12">';
			generaHtml += '<div class="row-fluid">';
			generaHtml += '<div class="span12" id="nombre'+valorCampo+'">';
			generaHtml += '</div></div>';
			generaHtml += '<div class="row-fluid">';
			generaHtml += '<div class="span6" id="emitido'+valorCampo+'">';
			generaHtml += '<div class="row-fluid">';
			generaHtml += '<div class="span1"><span class="label label-info">C</span></div><div class="span1"></div>';
			generaHtml += '<div class="span10" id="emitidoCantidad'+valorCampo+'">0</div></div>';
			generaHtml += '<div class="row-fluid">';
			generaHtml += '<div class="span1"><span class="label label-info">M</span></div><div class="span1"></div>';
			generaHtml += '<div class="span10" id="emitidoMonto'+valorCampo+'">0</div></div>';
			generaHtml += '<div class="row-fluid oculto" id="divMuestraValorMonto'+valorCampo+'">';
			generaHtml += '<div class="span12" id="muestraValorMonto'+valorCampo+'"></div></div></div>';
			generaHtml += '<div class="span6" id="pagado'+valorCampo+'">';
			generaHtml += '<div class="row-fluid">';
			generaHtml += '<div class="span1">';
			generaHtml += '<span class="label label-info">C</span>';
			generaHtml += '</div><div class="span1"></div>';
			generaHtml += '<div class="span10" id="pagadoCantidad'+valorCampo+'"></div>';
			generaHtml += '</div><div class="row-fluid">';
			generaHtml += '<div class="span1"><span class="label label-info">M</span></div>';
			generaHtml += '<div class="span1"></div><div class="span10" id="pagadoMonto'+valorCampo+'"></div>';
			generaHtml += '</div>';
			generaHtml += '<div class="row-fluid oculto" id="divMuestraValorMontoPagado'+valorCampo+'">';
			generaHtml += '<div class="span12" id="muestraValorMontoPagado'+valorCampo+'"></div>';
			generaHtml += '</div></div></div></div></div></div>';
		}
		generaHtml += '</div>';
	}
	$('#muestraData').html(generaHtml);
	$.each( data.datos, function( key, valoresDatos ) {
		var idCampo = valoresDatos.idCampo;
		var nombreRegional = valoresDatos.nombreRegional;
		var idRegional = valoresDatos.idRegional;
		var emitidoCantidad = valoresDatos.emitidoCantidad;
		var emitidoMonto = valoresDatos.emitidoMonto;
		var emitidoMontoMuestra = valoresDatos.emitidoMontoMuestra;
		var pagadoCantidad = valoresDatos.pagadoCantidad;
		var pagadoMontoMuestra = valoresDatos.pagadoMontoMuestra;
		var pagadoMonto = valoresDatos.pagadoMonto;
		$('.campo').each(function(){
			if ($(this).hasClass(idCampo))
			{
				$(this).addClass('existe').slideDown('fast');
				$('#emitidoCantidad'+idCampo).html('<span class="label label-info">' +emitidoCantidad+'</span>');
				$('#emitidoMonto'+idCampo).html('<span class="label label-info">$' +emitidoMontoMuestra+'</span>').attr({
					'onmouseenter': 'muestraMontoCompleto("'+emitidoMonto+'",'+idCampo+',1);',
					'onmouseleave': 'quitaMontoCompleto('+idCampo+',1);'
				});
				$('#pagadoCantidad'+idCampo).html('<span class="label label-info">' +pagadoCantidad+'</span>');
				$('#pagadoMonto'+idCampo).html('<span class="label label-info">$' +pagadoMontoMuestra+'</span>').attr({
					'onmouseenter': 'muestraMontoCompleto("'+pagadoMonto+'",'+idCampo+',0);',
					'onmouseleave': 'quitaMontoCompleto('+idCampo+',0);'
				});
				$('#campo'+idCampo).attr({'onClick' : 'seleccionaRegional('+idRegional+')','data-idRegional': idRegional});
				$('#nombre'+idCampo).html('<span class="label label-info">'+nombreRegional+'</span>').addClass('text-center');
			}
		});
	});
	$('.campo').each(function(){
		if (!$(this).hasClass('existe'))
		{
			$(this).slideUp('fast');
			cuentaCampos += 1;
		}
	});
	if (cuentaCampos === 1)
	{
		$('#campo1').addClass('offset1');
	}
	if (cuentaCampos === 2)
	{
		$('#campo1').addClass('offset2');
	}
});
function seleccionaRegional(idRegional)
{
	$('#divZonales').slideDown('fast');
	$('#divRegionales').slideUp('fast');
	principal.attr('data-regional',idRegional);
	var pagina, div, datos;
	pagina = 'maestroPagos/zonales.asp';
	div = 'zonales';
	datos='';
	enviaDatos(pagina,div,datos);	
}
function muestraMontoCompleto(monto,campo,tipo)
{
	if (tipo =='1')
	{
		$('#divMuestraValorMonto'+campo).removeClass('oculto').slideDown('slow');
		$('#muestraValorMonto'+campo).html('<span class="label label-success">$'+monto+'</span>');
	}
	else
	{
		$('#divMuestraValorMontoPagado'+campo).removeClass('oculto').slideDown('slow');
		$('#muestraValorMontoPagado'+campo).html('<span class="label label-success">$'+monto+'</span>');	
	}
	
}
function quitaMontoCompleto(campo,tipo)
{
	if (tipo =='1')
	{
		$('#divMuestraValorMonto'+campo).hide('fast');
	}
	else
	{
		$('#divMuestraValorMontoPagado'+campo).hide('fast');
	}
}
</script>	