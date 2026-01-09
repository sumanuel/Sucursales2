var pagina,donde,datos, idSucursal, idZonal,div;
$(function(){

}).on('click','.abreSucursales',function(){
	idSucursal = $(this).attr('data-idSucursal');
	pagina = 'sucursales/abreSucursal.asp';
	div = 'enviaDatosSucursal'+idSucursal;
	datos='';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	$('#sucursalAbierta'+idSucursal)
		.hide('fast')
		.show('fast')
		.addClass('pull-right')
		.html('<i class="icon-ok text-success"></i> Sucursal abierta');
	var fecha = new Date();
	var hora = fecha.getHours();
	var minuto = fecha.getMinutes();
	var totalMinutos = hora*60;
	totalMinutos += minuto;
	if (totalMinutos > 530)
	{
		var label='label-warning';
		var texto = 'Abierta FP';
	}
	else
	{
		label='label-success';
		texto = 'Abierta';
	}
	$('#botonAbreSucursal'+idSucursal).fadeOut('slow');
	$('#detalleAperturaGer'+idSucursal).removeClass('label-important').text(texto).addClass(label);
	$('#situacionSucursal'+idSucursal).removeClass('label label-important').text('');
	pagina = 'sucursales/sucursalesAbiertasZonal.asp';
	div = 'divSucursalesAbiertas';
	datos = 'idPerfil=3';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('.abreTrSucursales').click(function(){
	var idZonal = $(this).attr('data-idZonal');	
	if ($(this).hasClass('muestra'))
	{
		$('.'+idZonal).slideDown('fast');
		$(this).removeClass('muestra');
		$('#iconoZonal'+idZonal).show('fast');
		try{
			cargaDatosZonal(idZonal);
			return false;
		}
		catch(err){}		
	}
	else
	{
		$('.'+idZonal).slideUp('fast');
		$(this).addClass('muestra');
		$('#iconoZonal'+idZonal).hide('fast');
		return false;
	}
});
$('.muestraGraficoGer').click(function(){
	var idSucursal = $(this).attr('data-idSucursal');
	pagina = 'indices/indicesZonal.asp';
	donde = 'areaTrabajoGerencia';
	datos = 'idSucursal='+idSucursal;
	try{
		cargaDatosZonal(idZonal);
		return false;
	}
	catch(err){}
	return false;
});
$('.nombreSucursal').mouseover(function() {
	$(this).append('<span class="presionaSucursal pull-right"><i class="icon-home icon-2x mano"></i></span>').addClass('mano');
	return false;
});

$('.nombreSucursal').mouseout(function(){
	$('.presionaSucursal').remove();
	return false;
});
$('.nombreSucursal').click(function(){
	idSucursal = $(this).attr('data-idSucursal');
	pagina = 'sucursales/sucursalZonal.asp';
	donde = 'areaTrabajoGerencia';
	datos = 'sucursal='+idSucursal+'&muestraBoton=1';
	$('#menuGer, #datosZona, #areaDivTabsGerencia').fadeOut('slow');
	try{
			enviaDatos(pagina,donde,datos);
	}
	catch(err){}
	return false;
});
function cargaDatosZonal(idZonal)
{
	$('#imagenCarga'+idZonal).show();
	loadData2(idZonal);	
}
function loadData2(idZonal) {	
	$.ajax({
		url: "indices/loadDataDetalleSucursalZonal.asp",
		data: "idZonal="+idZonal,
		type: "GET",
		dataType: "json"
	}).done(function(source){
		var data = source;
		var objectTable = data['datos'];
		$.each(objectTable, function(index, value) {
			var cuenta = 0;
			var cuentaDoc = 0;
			var cuentaAdm = 0;
			var cuentaCont = 0;
			var valorDoC = 0;
			var valorCont = 0;
			var valorAdm = 0;
			var valorCajeroSucursalP = 0;
			var valorCajeroSucursalA = 0;
			var valorCajeroSucursalSR = 0;
			var valorGuardiaSucursal = 0;
			var idSucursal = value.idSucursal;

			var claseCont,claseAdm,claseCajeroSucP,claseCajeroSucA,claseGuardiaSuc;
			var campoDoc = '#detallePorcentajeDocSucursal' + idSucursal;
			valorDoC = value.porcentajeDoc;
			var campoCont = '#detallePorcentajeContSucursal'+idSucursal ;
			valorCont = value.porcentajeCont;
			var campoAdm = '#detallePorcentajeAdmSucursal' + idSucursal;
			valorAdm = value.porcentajeAdm;
			var campoPorcentajeCajeroSucursalP = '#cajerosSucursalP'+ idSucursal;
			valorCajeroSucursalP = value.porcentajeCajerosSucursalP;
			if (valorCajeroSucursalP =='100,00') {
				valorCajeroSucursalP = '100';
			}

			var campoPorcentajeCajeroSucursalA = '#cajerosSucursalA'+ idSucursal;
			valorCajeroSucursalA = value.porcentajeCajerosSucursalA;
			if (valorCajeroSucursalA =='100,00') {
				valorCajeroSucursalA = '100';
			}
			
			var campoPorcentajeCajeroSucursalSR = '#cajerosSucursalSR'+ idSucursal;
			valorCajeroSucursalSR = value.porcentajeCajerosSucursalSR;
			if (valorCajeroSucursalSR =='100,00') {
				valorCajeroSucursalSR = '100';
			}

			var campoPorcentajeGuardiasSucursal = '#guardiasSucursal'+ idSucursal;
			valorGuardiaSucursal = value.porcentajeGuardiasSucursal;
			if (valorCont === '100')
			{
				claseCont='label label-success tieneValorCont';
			}
			else
			{
				if(valorCont <= '30')
				{
					claseCont='label label-important tieneValorCont';
				}
				else
				{
					claseCont='label label-warning tieneValorCont';
				}			
			}
			if (valorDoC === '100')
			{
				var claseDoc='label label-success tieneValorDoc';
			}
			else
			{
				if(valorDoC <= '30')
				{
					claseDoc='label label-important tieneValorDoc';
				}
				else
				{
					claseDoc='label label-warning tieneValorDoc';
				}			
			}
			if (valorAdm === '100')
			{
				claseAdm='label label-success tieneValorDoc';
			}
			else
			{
				if(valorAdm <= '30')
				{
					claseAdm='label label-important tieneValorDoc';
				}
				else
				{
					claseAdm='label label-warning tieneValorDoc';
				}			
			}
			if(valorCajeroSucursalP <= '30')
			{
				claseCajeroSucP='label label-important tieneValorDoc';
			}
			if(valorCajeroSucursalP > '30')
			{
				claseCajeroSucP='label label-warning tieneValorDoc';
			}
			if (valorCajeroSucursalP === '100')
			{
				claseCajeroSucP='label label-success tieneValorDoc';
			}
			
			claseCajeroSucA='label label-important tieneValorDoc';
			var claseCajeroSucSR='label tieneValorDoc';

			if (valorGuardiaSucursal === '100')
			{
				claseGuardiaSuc='label label-success tieneValorDoc';
			}
			else
			{
				if(valorGuardiaSucursal <= '30')
				{
					claseGuardiaSuc='label label-important tieneValorDoc';
				}
				else
				{
					claseGuardiaSuc='label label-warning tieneValorDoc';
				}			
			}
			$(campoDoc).text(valorDoC+'%').addClass(claseDoc).attr('data-valor',valorDoC);
			$(campoCont).text(valorCont+'%').addClass(claseCont).attr('data-valor',valorCont);
			$(campoAdm).text(valorAdm+'%').addClass(claseAdm).attr('data-valor',valorAdm);
			
			$(campoPorcentajeCajeroSucursalP)
			.text('P: '+valorCajeroSucursalP+'%')
			.addClass(claseCajeroSucP)
			.attr('data-valor',valorCajeroSucursalP);
			
			$(campoPorcentajeCajeroSucursalA)
			.text('A: '+valorCajeroSucursalA+'%')
			.addClass(claseCajeroSucA)
			.attr('data-valor',valorCajeroSucursalA);
			
			$(campoPorcentajeCajeroSucursalSR)
			.text('SR: '+valorCajeroSucursalSR+'%')
			.addClass(claseCajeroSucSR)
			.attr('data-valor',valorCajeroSucursalSR);

			$(campoPorcentajeGuardiasSucursal)
			.text(valorGuardiaSucursal+'%')
			.addClass(claseGuardiaSuc)
			.attr('data-valor',valorGuardiaSucursal);

		var estadoSucursal = value.estadoSucursal;
		if (estadoSucursal =="0")
		{
			var estadoSucursalPalabras = "Cerrada";
			$('#detalleAperturaGer'+idSucursal).html('Cerrada').addClass('label label-important');
			var fecha = new Date();
			var horaActual = fecha.getHours();
			var minutoActual = fecha.getMinutes();
			var horaEnMinutos = horaActual * 60;
			horaEnMinutos += minutoActual;
			if (horaEnMinutos > 530)
			{
				var claseBoton = 'btn-warning';
				var textoBoton = 'Abrir sucursal FP';
			}
			else
			{
				claseBoton = 'btn-success';
				textoBoton = 'Abrir sucursal';
			}
			var perfil = $.session.get('perfil');
			if (perfil !=='4')
			{
				$('#botonAbreSucursal'+idSucursal)
				.html('<i class="icon-signin"></i><strong> '+textoBoton+'</strong></span>')
				.addClass('btn '+claseBoton+' btn-mini pull-right abreSucursales');
			}
		}
		else
		{
			var horaApertura = value.horaAperturaSucursal;
			if (estadoSucursal =="1") {
				$('#detalleAperturaGer'+idSucursal).html('Abierta     : '+horaApertura).addClass('label label-success');
			}else{
				$('#detalleAperturaGer'+idSucursal).html('Abierta FP  : '+horaApertura).addClass('label label-warning');
			}
		}
		var situacionSucursal = value.situacionSucursal;
		var claseEstado;
		switch(situacionSucursal)
		{
		case 'Nadie':
			claseEstado = 'label';
			break;
		case '1/4':
        claseEstado = 'label label-success';
        break;
		case '1/2':
        claseEstado = 'label label-success';
        break;
		case '3/4':
        claseEstado = 'label label-success';
        break;
		case 'Full':
        claseEstado = "label label-warning";
        break;
		case 'Desborde':
        claseEstado = "label label-important";
        break;
		case 'Cerrada':
        claseEstado = "label label-important";
        break;
		}
		$('#situacionSucursal'+idSucursal).html(situacionSucursal).addClass(claseEstado);
		});
	}).fail(function(){
		alert('La informacion es enstos momentos no puede ser procesada');
	});
}
function loadData(idZona) {
	$.ajax({
		url: "indices/loadDataDetalleZonal.asp",
		data: "idZona="+idZona,
		type: "GET",
		dataType: "json"
	}).done(function(source){
		data = source;
		dispatchInfo();
	}).fail(function(){
		alert('La informacion es enstos momentos no puede ser procesada');
	});							
}
function dispatchInfo(){
	renderData(data['datos']);
}

function renderData(objectTable){
	var  claseDoc,claseCont,claseAdm,claseAdmZon,claseContZon,claseDocZon,claseCajeroSuc,claseCajeroZon,claseGuardiaSuc,claseGuardiaZon;
	var cuenta = 0;
	var cuentaDoc = 0;
	var cuentaAdm = 0;
	var cuentaCont = 0;
	$.each(objectTable, function(index, value) {
		var idSucursal = value.idSucursal;
		var idZonal = value.idZonal;
		var promedioCont = 0;
		var promedioDoc = 0;
		var valorCajeroZonalP = 0;
		var valorCajeroZonalA = 0;
		var valorCajeroZonalSR = 0;
		var valorPorcentajeApertura = 0;
		var valorPorcentajeSinRegistro = 0;
		var valorPorcentajeCerradas = 0;
		promedioCont = value.promedioCont;
		var promedioAdm = value.promedioAdm;
		promedioDoc = value.promedioDoc;
		valorCajeroZonalP = value.porcentajeCajerosZonalP;
		valorCajeroZonalA = value.porcentajeCajerosZonalA;
		valorCajeroZonalSR = value.porcentajeCajerosZonalSR;
		var valorGuardiaZonal = value.porcentajeGuardiasZonal;
		var valorPorcentajeApertura = parseFloat(value.porcentajeApertura);
		valorPorcentajeApertura = valorPorcentajeApertura.toFixed(2);
		if (valorPorcentajeApertura.slice(-2) == '00')
		{
			valorPorcentajeApertura = parseInt(valorPorcentajeApertura);
		}
		valorPorcentajeApertura = valorPorcentajeApertura+'%';
		var valorPorcentajeSinRegistro = parseFloat(value.porcentajeSinRegistro);
		valorPorcentajeSinRegistro = valorPorcentajeSinRegistro.toFixed(2);
		if (valorPorcentajeSinRegistro.slice(-2) == '00')
		{
			valorPorcentajeSinRegistro = parseInt(valorPorcentajeSinRegistro);
		}
		valorPorcentajeSinRegistro = valorPorcentajeSinRegistro+'%';
		var valorPorcentajeCerradas = parseFloat(value.porcentajeCerradas);
		valorPorcentajeCerradas = valorPorcentajeCerradas.toFixed(2);
		if (valorPorcentajeCerradas.slice(-2) == '00')
		{
			valorPorcentajeCerradas = parseInt(valorPorcentajeCerradas);
		}
		valorPorcentajeCerradas = valorPorcentajeCerradas+'%';
		if (promedioDoc ==='100')
		{
			claseDocZon = 'label label-success tieneValorZonDoc';
		}
		else
		{
			if(promedioDoc <= '30')
			{
				claseDocZon='label label-important tieneValorZonDoc';
			}
			else
			{
				claseDocZon='label label-warning tieneValorZonDoc';
			}
		}
		if (promedioCont ==='100')
		{
			claseContZon = 'label label-success tieneValorZonCont';
		}
		else
		{
			if(promedioCont <= '30')
			{
				claseContZon='label label-important tieneValorZonCont';
			}
			else
			{
				claseContZon='label label-warning tieneValorZonCont';
			}
		}
		if (promedioAdm ==='100')
		{
			claseAdmZon = 'label label-success tieneValorZonAdm';
		}
		else
		{
			if(promedioAdm <= '30')
			{
				claseAdmZon='label label-important tieneValorZonAdm';
			}
			else
			{
				claseAdmZon='label label-warning tieneValorZonAdm';
			}
		}

		if (valorCajeroZonalP ==='100')
		{
			var claseCajeroZonP = 'label label-success tieneValorZonAdm';
		}
		else
		{
			if(valorCajeroZonalP <= '30')
			{
				claseCajeroZonP='label label-important tieneValorZonAdm';
			}
			else
			{
				claseCajeroZonP='label label-warning tieneValorZonAdm';
			}
		}

		
		var claseCajeroZonA = 'label label-important tieneValorZonAdm';
		
		var claseCajeroZonSR = 'label tieneValorZonAdm';
		
		if (valorGuardiaZonal ==='100')
		{
			claseGuardiaZon = 'label label-success tieneValorZonAdm';
		}
		else
		{
			if(valorGuardiaZonal <= '30')
			{
				claseGuardiaZon='label label-important tieneValorZonAdm';
			}
			else
			{
				claseGuardiaZon='label label-warning tieneValorZonAdm';
			}
		}
		$('#detalleDocumentalZonal'+idZonal).text(promedioDoc+'%').addClass(claseDocZon).attr('data-valor',promedioDoc);
		$('#detalleContableZonal'+idZonal).text(promedioCont+'%').addClass(claseContZon).attr('data-valor',promedioCont);
		$('#detalleAdministrativaZonal'+idZonal).text(promedioAdm+'%').addClass(claseAdmZon).attr('data-valor',promedioAdm);
		$('#cajerosZonalP'+idZonal).text('P: '+valorCajeroZonalP+'%').addClass(claseCajeroZonP).attr('data-valor',valorCajeroZonalP);
		$('#cajerosZonalA'+idZonal).text('A: '+valorCajeroZonalA+'%').addClass(claseCajeroZonA).attr('data-valor',valorCajeroZonalA);
		$('#cajerosZonalSR'+idZonal).text('SR: '+valorCajeroZonalSR+'%').addClass(claseCajeroZonSR).attr('data-valor',valorCajeroZonalSR);
		$('#guardiasZonal'+idZonal).text(valorGuardiaZonal+'%').addClass(claseGuardiaZon).attr('data-valor',valorGuardiaZonal);		
		$('#porcentajeApertura'+idZonal).text(valorPorcentajeApertura);
		$('#porcentajeAperturaSr'+idZonal).text(valorPorcentajeSinRegistro);
		$('#porcentajeCerrado'+idZonal).text(valorPorcentajeCerradas);
	});
}