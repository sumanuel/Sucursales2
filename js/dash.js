//try{
//      enviaDatos(pagina,div,datos);
 //     return false;
 //   }
 //   catch(err){}
$(function(){
	$('.ayuda').tooltip();
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

	setTimeout(function(){
		pagina = 'dashboard/graficoDash.asp';
		div = 'graficoDash4';
		datos='graficoDash=4';
		try{
      		enviaDatos(pagina,div,datos);
    	}
    	catch(err){}
    	return false;
	}, 1100);
	setTimeout(function(){
		pagina = 'dashboard/graficoDash.asp';
		div = 'graficoDash5';
		datos='graficoDash=5';
		try{
      		enviaDatos(pagina,div,datos);
		}
    	catch(err){}
    	return false;
	}, 1300);
	setTimeout(function(){
		pagina = 'dashboard/graficoDash.asp';
		div = 'graficoDash6';
		datos='graficoDash=6';
		try{
      		enviaDatos(pagina,div,datos);
	    }
    	catch(err){}
    	return false;
	}, 1500);
	setTimeout(function(){
		pagina = 'indicadores/indicadorZonal.asp';
		div = 'gDocumentalZonalSuc';
		datos='tipo=2';
		try{
      		enviaDatos(pagina,div,datos);
		}
		catch(err){}
		return false;
	}, 2000);
	setTimeout(function(){
		pagina = 'indicadores/indicadorZonal.asp';
		div = 'gContableZonalSuc';
		datos='tipo=3';
		try{
			enviaDatos(pagina,div,datos);
		}
    	catch(err){}
    	return false;
	}, 2500);
	setTimeout(function(){
		pagina = 'indicadores/indicadorZonal.asp';
		div = 'gAdministrativaZonalSuc';
		datos='tipo=4';
		try{
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
		return false;
	}, 3000);
	setTimeout(function(){
		pagina = 'sucursales/estadoSucursalGer.asp';
		div = 'estadoSucursalesPorcentaje';
		datos='';
		try{
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
		return false;
	}, 2000);
}).on('click','.botonTabla4',function(){	
	if ($(this).hasClass('cambiaTabla4'))
	{
		pagina = 'dashboard/graficoDash.asp';
		div = 'graficoDash4';
		datos='graficoDash=4';
		try{
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
		$(this).removeClass('cambiaTabla4');
		$('.iconoTabla4').removeClass('icon-list-alt icon-bar-chart').addClass('icon-list-alt');
		return false;
	}
	else
	{
		pagina = 'dashboard/descargaDatos.asp';
		div = 'graficoDash4';
		datos='graficoDash=4&imprime=0';
		try{
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
		$(this).addClass('cambiaTabla4');
		$('.iconoTabla4').removeClass('icon-bar-chart icon-list-alt').addClass('icon-bar-chart');
		return false;
	}
}).on('click','.botonTabla5',function(){
	if ($(this).hasClass('cambiaTabla5'))
	{
		pagina = 'dashboard/graficoDash.asp';
		div = 'graficoDash5';
		datos='graficoDash=5';
		try{
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
		$(this).removeClass('cambiaTabla5');
		$('.iconoTabla5').removeClass('icon-list-alt icon-bar-chart').addClass('icon-list-alt');
		return false;
	}
	else
	{
		pagina = 'dashboard/descargaDatos.asp';
		div = 'graficoDash5';
		datos='graficoDash=5&imprime=0';
		try{
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
		$(this).addClass('cambiaTabla5');
		$('.iconoTabla5').removeClass('icon-bar-chart icon-list-alt').addClass('icon-bar-chart');
		return false;
	}
}).on('click','.botonTabla6',function(){
	if ($(this).hasClass('cambiaTabla6'))
	{
		pagina = 'dashboard/graficoDash.asp';
		div = 'graficoDash6';
		datos='graficoDash=6';
		try{
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
		$(this).removeClass('cambiaTabla6');
		$('.iconoTabla6').removeClass('icon-list-alt icon-bar-chart').addClass('icon-list-alt');
		return false;
	}
	else
	{
		pagina = 'dashboard/descargaDatos.asp';
		div = 'graficoDash6';
		datos='graficoDash=6&imprime=0';
		try{
      		enviaDatos(pagina,div,datos);
		}
    	catch(err){}
		$(this).addClass('cambiaTabla6');
		$('.iconoTabla6').removeClass('icon-bar-chart icon-list-alt').addClass('icon-bar-chart');
		return false;
	}
});
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
$('.botonRecarga4').click(function(){
	pagina = 'dashboard/graficoDash.asp';
	div = 'graficoDash4';
	datos='graficoDash=4';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
});
$('.botonRecarga5').click(function(){
	pagina = 'dashboard/graficoDash.asp';
	div = 'graficoDash5';
	datos='graficoDash=5';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
});
$('.botonRecarga6').click(function(){
	pagina = 'dashboard/graficoDash.asp';
	div = 'graficoDash6';
	datos='graficoDash=6';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
});
$('.botonDescarga4').click(function(){
	datos='dashboard/descargaDatos.asp?graficoDash=4&imprime=1';
	location.href=datos;
});
$('.botonDescarga5').click(function(){
	datos='dashboard/descargaDatos.asp?graficoDash=5&imprime=1';
	location.href=datos;
});
$('.botonDescarga6').click(function(){
	datos='dashboard/descargaDatos.asp?graficoDash=7&imprime=1';
	location.href=datos;
});