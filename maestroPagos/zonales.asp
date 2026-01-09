<%idRegional = trim(request("idRegional"))%>
<div class="row-fluid" >
	<div class="span12" id="muestraDataZonal" data-idRegional="<%=idRegional%>"></div>
</div>
<script>
var cuentaCamposZonal = 0;
var principal = $('#principalSucursal');
var idRegional = principal.attr('data-regional');
var mes = principal.attr('data-mes');
var tipo = principal.attr('data-tipo');
var nombresMes = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio","Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
var mesActual = parseInt(mes.substr(4, 6))-1
var anioActual = parseInt(mes.substr(0, 4))
mesActual = nombresMes[mesActual]+ ' ' +anioActual;
var url = 'maestroPagos/datosZonales.asp?idRegional='+idRegional+'&mes='+mes+'&tipo='+tipo;
var generaHtml = '<div class="row-fluid"><div class="span1" id="mesActual"><span class="label label-success">'+mesActual+'</span></div><div class="span10"></div><div class="span1"><span class="label label-important mano" onClick="vuelveZonal();"> <i class="icon-arrow-left"></i> Volver</span></div></div>';
$.when($.ajax(url)).then(function(data) {
	var i,x,valorCampo;
	var totalRegistros = data.datos.length;
	var totalRows = totalRegistros * 4;
	totalRows =  Math.round(totalRows / 12);
	for (i = 1; i <= totalRows; i++)
	{
		generaHtml += '<div class="row-fluid">';
		for (x=1 ; x<= 4; x++ )
		{
			valorCampo = x*i;
			generaHtml += '<div class="span3 '+valorCampo+' campoZonal mano well" id="campoZonal'+valorCampo+'">';
				generaHtml += '<div class="row-fluid">';
					generaHtml += '<div class="span12">';
						generaHtml += '<div class="row-fluid">';
							generaHtml += '<div class="span12" id="nombreZonal'+valorCampo+'"></div>';
						generaHtml += '</div>';
						generaHtml += '<div class="row-fluid">';
							generaHtml += '<div class="span6" id="emitidoZonal'+valorCampo+'">';
								generaHtml += '<div class="row-fluid">';
									generaHtml += '<div class="span1">';
										generaHtml += '<span class="label label-info">C</span>';
									generaHtml += '</div>';
									generaHtml += '<div class="span1"></div>';
									generaHtml += '<div class="span10" id="emitidoCantidadZonal'+valorCampo+'"></div>';
								generaHtml += '</div>';
								generaHtml += '<div class="row-fluid">';
									generaHtml += '<div class="span1">';
										generaHtml += '<span class="label label-info">M</span>';
									generaHtml += '</div>';
									generaHtml += '<div class="span1"></div>';
									generaHtml += '<div class="span10" id="emitidoMontoZonal'+valorCampo+'"></div>';
								generaHtml += '</div>';
								generaHtml += '<div class="row-fluid oculto" id="divMuestraValorMontoZonal'+valorCampo+'">';
									generaHtml += '<div class="span12" id="muestraValorMontoZonal'+valorCampo+'"></div>';
								generaHtml += '</div>';
							generaHtml += '</div>';
							generaHtml += '<div class="span6" id="pagadoZonal'+valorCampo+'">';
								generaHtml += '<div class="row-fluid">';
									generaHtml += '<div class="span1">';
										generaHtml += '<span class="label label-info">C</span>';
									generaHtml += '</div>';
									generaHtml += '<div class="span1"></div>';
									generaHtml += '<div class="span10" id="pagadoCantidadZonal'+valorCampo+'"></div>';
								generaHtml += '</div>';
								generaHtml += '<div class="row-fluid">';
									generaHtml += '<div class="span1">';
										generaHtml += '<span class="label label-info">M</span>';
									generaHtml += '</div>';
									generaHtml += '<div class="span1"></div>';
									generaHtml += '<div class="span10" id="pagadoMontoZonal'+valorCampo+'"></div>';
								generaHtml += '</div>';
								generaHtml += '<div class="row-fluid oculto" id="divMuestraValorMontoPZonal'+valorCampo+'">';
									generaHtml += '<div class="span12" id="muestraValorMontoPZonal'+valorCampo+'"></div>';
								generaHtml += '</div>';
							generaHtml += '</div>';
						generaHtml += '</div>';
					generaHtml += '</div>';
				generaHtml += '</div>';
			generaHtml += '</div>';
		}
		generaHtml += '</div>';
	}
	$('#muestraDataZonal').html(generaHtml);
	$.each( data.datos, function( key, valoresDatos ) {
		var idCampo = valoresDatos.idCampo;
		var nombreZonal = valoresDatos.nombreZonal;
		//console.log(nombreZonal)
		var idZonal = valoresDatos.idZonal;
		var emitidoCantidadZonal = valoresDatos.emitidoCantidad;
		var emitidoMontoZonal = valoresDatos.emitidoMonto;
		var emitidoMontoMuestraZonal = valoresDatos.emitidoMontoMuestra;
		var pagadoCantidadZonal = valoresDatos.pagadoCantidad;
		var pagadoMontoMuestraZonal = valoresDatos.pagadoMontoMuestra;
		var pagadoMontoZonal = valoresDatos.pagadoMonto;
		var idRegional = principal.attr('data-regional');
		$('.campoZonal').each(function(){
			if ($(this).hasClass(idCampo))
			{
				$(this).addClass('existe').slideDown('fast');
				$('#emitidoCantidadZonal'+idCampo).html('<span class="label label-info">' +emitidoCantidadZonal+'</span>');
				$('#pagadoCantidadZonal'+idCampo).html('<span class="label label-info">' +pagadoCantidadZonal+'</span>');
				$('#campoZonal'+idCampo).attr({'onClick' : 'seleccionaZonal('+idZonal+','+idRegional+','+idCampo+')','data-idZonal': idZonal});
				$('#nombreZonal'+idCampo).html('<span class="label label-info">'+nombreZonal+'</span>').addClass('text-center');
				$('#emitidoMontoZonal'+idCampo).html('<span class="label label-info">' +emitidoMontoZonal+'</span>');
				$('#emitidoMontoZonal'+idCampo).html('<span class="label label-info">$' +emitidoMontoMuestraZonal+'</span>').attr({
					'onmouseenter': 'muestraMontoCompletoZonal("'+emitidoMontoZonal+'",'+idCampo+',1);',
					'onmouseleave': 'quitaMontoCompletoZonal('+idCampo+',1);'
				});
				$('#pagadoMontoZonal'+idCampo).html('<span class="label label-info">' +pagadoMontoZonal+'</span>');
				$('#pagadoMontoZonal'+idCampo).html('<span class="label label-info">$' +pagadoMontoMuestraZonal+'</span>').attr({
					'onmouseenter': 'muestraMontoCompletoZonal("'+pagadoMontoZonal+'",'+idCampo+',0);',
					'onmouseleave': 'quitaMontoCompletoZonal('+idCampo+',0);'
				});
			}
		});
	});
	
	$('.campoZonal').each(function(){
		if (!$(this).hasClass('existe'))
		{
			$(this).slideUp('fast');
			cuentaCamposZonal += 1;
		}
	});
	if (cuentaCamposZonal === 1)
	{
		$('#campoZonal1').addClass('offset1');
	}
	if (cuentaCamposZonal === 2)
	{
		$('#campoZonal1').addClass('offset3');
	}
});
function vuelveZonal()
{
	$('#divRegionales').slideDown('fast');
	$('#divZonales, #sucursal').slideUp('fast');
	$('.seleccionado').each(function() {
		$(this).removeClass('seleccionado')
	});
}
function seleccionaZonal(idZonal,idRegional,campo)
{
	$('.seleccionado').each(function() {
		$(this).removeClass('seleccionado')
	});
	$('.'+campo).addClass('seleccionado');
	$('#divSucursal').slideDown('fast');
	principal.attr('data-zonal',idZonal);
	var pagina, div, datos;
	pagina = 'maestroPagos/sucursales.asp';
	div = 'sucursal';
	datos='';
	enviaDatos(pagina,div,datos);	
}
function muestraMontoCompletoZonal(monto,campo,tipo)
{
	if (tipo =='1')
	{
		$('#divMuestraValorMontoZonal'+campo).removeClass('oculto').slideDown('slow');
		$('#muestraValorMontoZonal'+campo).html('<span class="label label-success">$'+monto+'</span>');
	}
	else
	{
		$('#divMuestraValorMontoPZonal'+campo).removeClass('oculto').slideDown('slow');
		$('#muestraValorMontoPZonal'+campo).html('<span class="label label-success">$'+monto+'</span>');	
	}	
}
function quitaMontoCompletoZonal(campo,tipo)
{
	if (tipo =='1')
	{
		$('#divMuestraValorMontoZonal'+campo).hide('fast');
	}
	else
	{
		$('#divMuestraValorMontoPZonal'+campo).hide('fast');
	}
}
</script>	