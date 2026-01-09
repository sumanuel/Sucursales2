var pagina,div,datos,subConsulta;
$(function () {
	$('.ayuda').tooltip();
	$('#datatable').dataTable( {
		"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
		"sPaginationType": "bootstrap",
		"oLanguage": {
			"sLengthMenu": "_MENU_ registros por página",
			"sProcessing":     "Procesando...",
			"sZeroRecords":    "No se encontraron resultados",
			"sEmptyTable":     "Ningún dato disponible en esta tabla",
			"sInfo":           "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
			"sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
			"sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
			"sInfoPostFix":    "",
			"sSearch":         "Buscar:",
			"sUrl":            "",
			"sInfoThousands":  ",",
			"sLoadingRecords": "Cargando...",
			"oPaginate": {
				"sFirst":    "Primero",
				"sLast":     "Último",
				"sNext":     "Siguiente",
				"sPrevious": "Anterior"
			},
			"oAria": {
				"sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
				"sSortDescending": ": Activar para ordenar la columna de manera descendente"
			}
		},
	});
	$('.numero').prettynumber();
	//botonFoco();
});
$('#datatable').on( 'draw.dt', function () {
	//alert('pesca')
	$('.numero').prettynumber();
});
/*$('.tablaMontos').click(function(){
	pagina = 'transacciones/transacciones.asp';
	div = 'transaccionesGer';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
		$('#areaTransacciones').slideDown('slow');
		
	}
	catch(err){}
});*/
$('.iconoDescargaInforme').click(function(){
	var tipoConsulta = $(this).attr('data-tipoConsulta');
	location.href='informes/informeTransacciones.asp?tipoConsulta='+tipoConsulta;
});
$('.cambiaAcumulado').click(function(){
	var pagina = 'transacciones/transacciones.asp';
	var div = 'transaccionesGer';
	var datos='tipoConsulta=2';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
});
$('.cambiaDiario').click(function(){
	var pagina = 'transacciones/transacciones.asp';
	var div = 'transaccionesGer';
	var datos='tipoConsulta=1';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
});

$('.cambiaGrafico').click(function(){
	pagina = 'transacciones/transaccionesGer.asp';
	div = 'transaccionesGer';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
});
$('.cambiaMonto').click(function(){
	var tipoConsulta = $(this).attr('data-tipoConsulta');
	subConsulta = $(this).attr('data-subConsulta');
	if (subConsulta =='1')
	{
		subConsulta = '0';
	}
	else
	{
		subConsulta = '1';
	}
	pagina = 'transacciones/transacciones.asp';
	div = 'transaccionesGer';
	datos='tipoConsulta='+tipoConsulta+'&subConsulta='+subConsulta;
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
});
$('.muestraBotonFoco').click(function(){
	botonFoco();
});
function botonFoco()
{
	$('.downloadFoco').removeClass('hidden');
	$('.boton').removeClass('hidden');
	$('#datosFoco').removeClass('hidden');
	$('.icono').removeClass('icon-dropbox').addClass('icon-puzzle-piece');
	$('.muestraBotonFoco').hide('fast');
	cargaFoco();	
	return false;
}
$('.boton').click(function(){	
	cargaFoco();
	return false;
});

$('.downloadFoco').click(function(){
	downloadFoco();	
});

function downloadFoco(){
	/*var perfilMain = $('#perfilMain').val();
	var idSucursalMain = $('#idSucursalMain').val();
	var idUsuarioMain = $('#idUsuarioMain').val();
	valores = '?perfilMain='+perfilMain+'&idSucursalMain='+idSucursalMain+'&idUsuarioMain='+idUsuarioMain;
	if($('.icono').hasClass('icon-puzzle-piece')){		
		//alert('Descarga afiliaciones');
		location.href='transacciones/foco/downloadFocoAfiliaciones.asp'+valores;
	}
	else{		
		//alert('Descarga colocaciones');
		location.href='transacciones/foco/downloadFocoColocaciones.asp'+valores;
	}	*/
	//alert('pega foco');
	var pagina, div, datos;
	pagina = 'transacciones/foco/seleccionaMesAnioTransacciones.asp';
	div = 'focoSucursal';
	datos='';
	enviaDatos(pagina,div,datos);
}

function cargaFoco()
{
	var pagina, datos,div;
	if($('.icono').hasClass('icon-puzzle-piece'))
	{
		$('#graficoAfiliacionesEspecial').slideUp('slow');
		$('.icono').removeClass('icon-puzzle-piece').addClass('icon-dropbox');
		pagina = 'transacciones/focoColocaciones.asp';
		$('.boton').attr('data-original-title','Afiliaciones');
	}
	else
	{
		$('.icono').removeClass('icon-dropbox').addClass('icon-puzzle-piece');
		pagina = 'transacciones/focoAfiliaciones.asp';
		$('.boton').attr('data-original-title','Colocaciones');
	}
	$('.muestraTabla').slideUp('fast');
	$('.focoSucursal').removeClass('hidden');
	$('#datosFocoDiv').removeClass('hidden');
	div = 'datosFoco';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
		
	}
	catch(err){}

	return false;
}