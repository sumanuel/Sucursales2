$(function(){
	var pagina = 'sucursales/sucursalesAbiertasZonal.asp'
	var div = 'sucursalDivision';
	var datos = ''
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	pagina = 'indicadores/indicadorPersonalZonal.asp?';
	datos='perfil=3';
	div = 'cajerosDivision';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	pagina = 'sucursales/seguridadZonal.asp';
	datos = 'idPerfil=3';
	div = 'guardiasDivision'
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	pagina = 'divisional/tablaZonales.asp';
	datos = '';
	div = 'areaDivision'
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	pagina = 'divisional/dotacion.asp';
	datos = '';
	div = 'dotacionDivision'
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	setTimeout(function(){
		pagina = 'dashboard/graficoDash.asp';
		div = 'graficoDash1';
		datos='graficoDash=1';
		try{
			enviaDatos(pagina,div,datos);
    	}
    	catch(err){}
    	return false;
	}, 500);
	setTimeout(function(){
		pagina = 'dashboard/graficoDash.asp';
		div = 'graficoDash2';
		datos='graficoDash=2';
		try{
      		enviaDatos(pagina,div,datos);
    	}
    	catch(err){}
    	return false;
	}, 700);
	setTimeout(function(){
		pagina = 'dashboard/graficoDash.asp';
		div = 'graficoDash3';
		datos='graficoDash=3';
		try{
      		enviaDatos(pagina,div,datos);
    	}
    	catch(err){}
    	return false;
	}, 900);
});
function loadData() {
	$.ajax({
		url: "indices/loadDataDetalleZonal.asp",
		data: '',
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
		promedioCont = value.promedioCont;
		var promedioAdm = value.promedioAdm;
		promedioDoc = value.promedioDoc;
		valorCajeroZonalP = value.porcentajeCajerosZonalP;
		valorCajeroZonalA = value.porcentajeCajerosZonalA;
		var valorGuardiaZonal = value.porcentajeGuardiasZonal;
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
		$('#guardiasZonal'+idZonal).text(valorGuardiaZonal+'%').addClass(claseGuardiaZon).attr('data-valor',valorGuardiaZonal);		
	});
}
$('.botonRecarga1').click(function(){
	pagina = 'dashboard/graficoDash.asp';
	div = 'graficoDash1';
	datos='graficoDash=1';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
});
$('.botonRecarga2').click(function(){
	pagina = 'dashboard/graficoDash.asp';
	div = 'graficoDash2';
	datos='graficoDash=2';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
});
$('.botonRecarga3').click(function(){
	pagina = 'dashboard/graficoDash.asp';
	div = 'graficoDash3';
	datos='graficoDash=3';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
});