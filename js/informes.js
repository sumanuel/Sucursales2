// todas las acciones para los informes

// todos los click
var idSucursal, value
$('.encuestaAseo').click(function(){
	$('#textoSeleccioneSucursalAseo').slideUp('fast');
	$('#divSelectSucursalAseo').removeClass('oculto');
});
$('.iconoFechaEncuestaAseo').click(function(){
	$('#divFechaSelectEncuestaAseo').removeClass('oculto');
	$('.iconoTodosEncuestaAseo').attr('data-traeDatos', '1');
});
$('.dotacion').click(function(){
	$('#textoSeleccioneDotacion').slideUp('fast');
	$('#divSelectDotacion').removeClass('oculto');
});
$('.iconoFechaDotacion').click(function(){
	$('#divFechaSelectDotacion').removeClass('oculto');
});
$('.asistCajeros').click(function(){
	$('#textoSeleccioneAsistCajeros').slideUp('fast');
	$('#divSelectAsistCajeros').removeClass('oculto');
});
$('.iconoFechaAsistCajeros').click(function(){
	$('#divFechaSelectAsistCajeros').removeClass('oculto');
});
$('.afiliaciones').click(function(){
	$('#textoSeleccioneAfiliaciones').slideUp('fast');
	$('#divSelectAfiliaciones').removeClass('oculto');
});
$('.iconoFechaAfiliaciones').click(function(){
	$('#divFechaSelecAfiliaciones').removeClass('oculto');
});
$('.gestorCasos').click(function(){
	$('#textoSeleccioneGestorCasos').slideUp('fast');
	$('#divSelectGestorCasos').removeClass('oculto');
});
$('.iconoFechaGestorCasos').click(function(){
	$('#divFechaSelectGestorCasos').removeClass('oculto');
});
$('.mesaAyuda').click(function(){
	$('#textoSeleccioneMesaAyuda').slideUp('fast');
	$('#divSelectMesaAyuda').removeClass('oculto');
});
$('.iconoFechaMesaAyuda').click(function(){
	$('#divFechaSelectMesaAyuda').removeClass('oculto');
});
$('.licenciasMedicas').click(function(){
	$('#textoSeleccioneLicenciasMedicas').slideUp('fast');
	$('#divSelectLicenciaMedica').removeClass('oculto');
});
$('.iconoFechaLicenciasMedica').click(function(){
	$('#divFechaLicenciasMedicas').removeClass('oculto');
});
$('.pagosIps').click(function(){
	$('#textoSeleccionePagoIps').slideUp('fast');
	$('#divSelectPagoIps').removeClass('oculto');
});
$('.iconoFechaPagoIps').click(function(){
	$('#divFechaPagoIps').removeClass('oculto');
});
$('.bonos').click(function(){
	$('#textoSeleccioneBonos').slideUp('fast');
	$('#divSelectBonos').removeClass('oculto');
});
$('.iconoFechaBonos').click(function(){
	$('#divFechaBonos').removeClass('oculto');
});
$('.entidadesPagadoras').click(function(){
	$('#textoSeleccioneEntidadesPagadoras').slideUp('fast');
	$('#divSelectEntidadesPagadoras').removeClass('oculto');
});
$('.iconoFechaEntidadesPagadoras').click(function(){
	$('#divFechaEntidadesPagadoras').removeClass('oculto');
});
/*$('.stock').click(function(){
	$('#textoSeleccioneStock').slideUp('fast');
	$('#divSelectStock').removeClass('oculto');
});*/
$('.iconoFechaStock').click(function(){
	$('#divFechaStock').removeClass('oculto');
});
$('.intancias').click(function(){
	$('#textoSeleccioneIntancias').slideUp('fast');
	$('#divSelectIntancias').removeClass('oculto');
});
$('.iconoFechaIntancias').click(function(){
	$('#divFechaIntancias').removeClass('oculto');
});
$('.colocados').click(function(){
	$('#textoSeleccioneColocados').slideUp('fast');
	$('#divSelectColocados').removeClass('oculto');
});
$('.iconoFechaColocados').click(function(){
	$('#divFechaColocados').removeClass('oculto');
});
$('.saldoCajaBt').click(function(){
	$('#textoSeleccioneSaldoCajaBt').slideUp('fast');
	$('#divSelectSaldoCajaBt').removeClass('oculto');
});

$('.iconoFechaSaldoCajaBt').click(function(){
	$('#divFechaSaldoCajaBt').removeClass('oculto');
});
$('.saldoServiBanca').click(function(){
	$('#textoSeleccioneSaldoServiBanca').slideUp('fast');
	$('#divSelectSaldoServiBanca').removeClass('oculto');
});
$('.iconoFechaSaldoServiBanca').click(function(){
	$('#divFechaSaldoServiBanca').removeClass('oculto');
});
$('.remesas').click(function(){
	$('#textoSeleccioneRemesas').slideUp('fast');
	$('#divSelectRemesas').removeClass('oculto');
});
$('.iconoFechaRemesas').click(function(){
	$('#divFechaRemesas').removeClass('oculto');
});

$('#selectSucursalAseo').change(function(){
	value = $(this).val();
	$('.iconoEncuestaAseo').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneSucursalAseo').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoEncuestaAseo').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectSucursalAseo option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoEncuestaAseo').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoSeleccioneSucursalAseo').slideUp('fast');
	}
});
$('#selectDotacion').change(function(){
	value = $(this).val();
	
	$('.iconoDotacion').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneDotacion').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoDotacion').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectDotacion option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoDotacion').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoSeleccioneDotacion').slideUp('fast');
	}
});

$('#selectAsistCajeros').change(function(){
	value = $(this).val();
	
	$('.iconoAsistCajeros').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneAsistCajeros').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoAsistCajeros').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectAsistCajeros option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoAsistCajeros').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoSeleccioneAsistCajeros').slideUp('fast');
	}
});

$('#selectAfiliaciones').change(function(){
	value = $(this).val();
	
	$('.iconoAfiliaciones').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneAfiliaciones').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoAfiliaciones').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectAfiliaciones option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoAfiliaciones').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoSeleccioneAfiliaciones').slideUp('fast');
	}
});

$('#selectGestorCasos').change(function(){
	value = $(this).val();
	
	$('.iconoGestorCasos').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneGestorCasos').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoGestorCasos').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectGestorCasos option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoGestorCasos').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoSeleccioneGestorCasos').slideUp('fast');
	}
});



$('#selectMesaAyuda').change(function(){
	value = $(this).val();
	
	$('.iconoMesaAyuda').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneMesaAyuda').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoMesaAyuda').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectMesaAyuda option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoMesaAyuda').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoSeleccioneMesaAyuda').slideUp('fast');
	}
});
$('#selectLicenciaMedica').change(function(){
	value = $(this).val();
	$('.iconoLicenciaMedica').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneLicenciasMedicas').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoLicenciaMedica').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectLicenciaMedica option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoLicenciaMedica').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoSeleccioneLicenciasMedicas').slideUp('fast');
	}
});



$('#selectPagoIps').change(function(){
	value = $(this).val();
	$('.iconoPagoIps').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccionePagoIps').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoPagoIps').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectPagoIps option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoPagoIps').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoSeleccionePagoIps').slideUp('fast');
	}
});



$('#selectBonos').change(function(){
	value = $(this).val();
	$('.iconoBonos').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneBonos').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoBonos').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectBonos option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoBonos').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoSeleccioneBonos').slideUp('fast');
	}
});


$('#selectEntidadesPagadoras').change(function(){
	value = $(this).val();
	$('.iconoEntidadesPagadoras').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneEntidadesPagadoras').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoEntidadesPagadoras').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectEntidadesPagadoras option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoEntidadesPagadoras').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoSeleccioneEntidadesPagadoras').slideUp('fast');
	}
});

$('#selectStock').change(function(){
	value = $(this).val();
	$('.iconoStock').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneStock').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoStock').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectStock option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoStock').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoStock').slideUp('fast');
	}
});
$('#selectIntancias').change(function(){
	value = $(this).val();
	$('.iconoIntancias').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneIntancias').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoIntancias').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectIntancias option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoIntancias').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoIntancias').slideUp('fast');
	}
});
$('#selectColocados').change(function(){
	value = $(this).val();
	$('.iconoColocados').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneColocados').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoColocados').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectColocados option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoColocados').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoColocados').slideUp('fast');
	}
});

$('#selectSaldoCajaBt').change(function(){
	value = $(this).val();
	$('.iconoSaldoCajaBt').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneSaldoCajaBt').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoSaldoCajaBt').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectSaldoCajaBt option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoSaldoCajaBt').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoSaldoCajaBt').slideUp('fast');
	}
});
$('#selectSaldoServiBanca').change(function(){
	value = $(this).val();
	$('.iconoSaldoServiBanca').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneSaldoServiBanca').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoSaldoServiBanca').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectSaldoServiBanca option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoSaldoServiBanca').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoSaldoServiBanca').slideUp('fast');
	}
});
$('#selectRemesas').change(function(){
	value = $(this).val();
	$('.iconoRemesas').attr('data-idSucursal',value);
	if(value==null || value==undefined || value=='') {
		;
		$('#textoSeleccioneRemesas').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
		$('.iconoRemesas').removeClass('text-success').addClass('text-error').attr('data-original-title','Debe seleccionar sucursal')

	}
	else
	{
		var nombreSucursal = $('#selectRemesas option:selected').text();
		var textoMuestra = 'Puede descargar informe para la sucursal '+nombreSucursal;
		$('.iconoRemesas').removeClass('text-error').addClass('text-success').attr('data-original-title',textoMuestra);
		$('#textoRemesas').slideUp('fast');
	}
});

$('.iconoEncuestaAseo').click(function(){
	if ($(this).hasClass('text-success'))
	{
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,1,1,'');
	}
	else
	{
		$('#textoSeleccioneSucursalAseo').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});

$('.iconoDotacion').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaDotacion = $('#selectFechaDotacion').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,7,1,selectFechaDotacion);
	}
	else
	{
		$('#textoSeleccioneDotacion').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});

$('.iconoAsistCajeros').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaAsistCajeros = $('#selectFechaAsistCajeros').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,9,1,selectFechaAsistCajeros);
	}
	else
	{
		$('#textoSeleccioneAsistCajeros').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});

$('.iconoAfiliaciones').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaAfiliaciones = $('#selectFechaAfiliaciones').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,8,1,selectFechaAfiliaciones);
	}
	else
	{
		$('#textoSeleccioneAfiliaciones').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});

$('.iconoGestorCasos').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaGestorCasos = $('#selectFechaGestorCasos').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,2,1,selectFechaGestorCasos);
	}
	else
	{
		$('#textoSeleccioneGestorCasos').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});

$('.iconoMesaAyuda').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaMesaAyuda = $('#selectFechaMesaAyuda').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,2,2,selectFechaMesaAyuda);
	}
	else
	{
		$('#textoSeleccioneMesaAyuda').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});
$('.iconoLicenciaMedica').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaLicenciaMedica = $('#selectFechaLicenciaMedica').val();		
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,3,1,selectFechaLicenciaMedica);
	}
	else
	{
		$('#textoSeleccioneLicenciasMedicas').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});





$('.iconoSaldoCajaBt').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaSaldoCajaBt = $('#selectFechaSaldoCajaBt').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,4,1,selectFechaSaldoCajaBt);
	}
	else
	{
		$('#textoSeleccioneSaldoCajaBt').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});
$('.iconoSaldoServiBanca').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaSaldoServiBanca = $('#selectFechaSaldoServiBanca').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,4,2,selectFechaSaldoServiBanca);
	}
	else
	{
		$('#textoSeleccioneSaldoServiBanca').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});
$('.iconoRemesas').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaRemesas = $('#selectFechaRemesas').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,4,3,selectFechaRemesas);
	}
	else
	{
		$('#textoSeleccioneRemesas').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});





$('.iconoPagoIps').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaPagoIps = $('#selectFechaPagoIps').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,5,1,selectFechaPagoIps);
	}
	else
	{
		$('#textoSeleccionePagoIps').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});

$('.iconoBonos').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaBonos = $('#selectFechaBonos').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,5,2,selectFechaBonos);
	}
	else
	{
		$('#textoSeleccioneBonos').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});
$('.iconoEntidadesPagadoras').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaEntidadesPagadoras = $('#selectFechaEntidadesPagadoras').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,5,3,selectFechaEntidadesPagadoras);
	}
	else
	{
		$('#textoSeleccioneEntidadesPagadoras').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});
$('.iconoStock').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaStock = $('#selectFechaStock').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,6,1,selectFechaStock);
	}
	else
	{
		$('#textoSeleccioneStock').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});
$('.iconoIntancias').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaIntancias = $('#selectFechaIntancias').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,6,2,selectFechaIntancias);
	}
	else
	{
		$('#textoSeleccioneIntancias').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});
$('.iconoColocados').click(function(){
	if ($(this).hasClass('text-success'))
	{
		var selectFechaColocados = $('#selectFechaColocados').val();
		idSucursal = $(this).attr('data-idSucursal');
		buscaDatos(idSucursal,1,6,3,selectFechaColocados);
	}
	else
	{
		$('#textoSeleccioneColocados').addClass('alert alert-error').text('Debe seleccionar sucursal').slideDown('fast');
	}
});



//todos los registros
$('.iconoTodosEncuestaAseo').click(function(){
	var selectFechaEncuestaAseo = $('#selectFechaEncuestaAseo').val();
	var traeDatos = $(this).attr('data-traeDatos');
	buscaDatos(0,traeDatos,1,1,selectFechaEncuestaAseo);

	//alert(buscaDatos);

});
$('.iconoTodosDotacion').click(function(){
	var selectFechaDotacion = $('#selectFechaDotacion').val();
	var idSucursal = $('#selectDotacion').val();
	buscaDatos(idSucursal,0,7,1,0);
});

$('.iconoTodosAsistCajeros').click(function(){
	var selectFechaAsistCajeros = $('#selectFechaAsistCajeros').val();
	buscaDatos(0,0,9,1,selectFechaAsistCajeros);
});

$('.iconoTodosAfiliaciones').click(function(){
	var selectFechaAfiliaciones = $('#selectFechaAfiliaciones').val();
	buscaDatos(0,0,8,1,selectFechaAfiliaciones);
});
$('.iconoTodosGestorCasos').click(function(){
	var selectFechaGestorCasos = $('#selectFechaGestorCasos').val();
	buscaDatos(0,0,2,1,selectFechaGestorCasos);
});

$('.iconoTodosMesaAyuda').click(function(){
	var selectFechaMesaAyuda = $('#selectFechaMesaAyuda').val();
	buscaDatos(0,0,2,2,selectFechaMesaAyuda);
});
$('.iconoTodosLicenciaMedica').click(function(){
	var selectFechaLicenciaMedica = $('#selectFechaLicenciaMedica').val();	
	buscaDatos(0,0,3,1,selectFechaLicenciaMedica);
});

$('.iconoTodosSaldoCajaBt').click(function(){
	var selectFechaSaldoCajaBt = $('#selectFechaSaldoCajaBt').val();
	buscaDatos(0,0,4,1,selectFechaSaldoCajaBt);
});
$('.iconoTodosSaldoServiBanca').click(function(){
	var selectFechaSaldoServiBanca = $('#selectFechaSaldoServiBanca').val();
	buscaDatos(0,0,4,2,selectFechaSaldoServiBanca);
});
$('.iconoTodosRemesas').click(function(){
	var selectFechaRemesas = $('#selectFechaRemesas').val();
	buscaDatos(0,0,4,3,selectFechaRemesas);
});
$('.iconoTodosPagoIps').click(function(){
	var selectFechaPagoIps = $('#selectFechaPagoIps').val();
	buscaDatos(0,0,5,1,selectFechaPagoIps);
});
$('.iconoTodosBonos').click(function(){
	var selectFechaBonos = $('#selectFechaBonos').val();
	buscaDatos(0,0,5,2,selectFechaBonos);
});
$('.iconoTodosEntidadesPagadoras').click(function(){
	var selectFechaEntidadesPagadoras = $('#selectFechaEntidadesPagadoras').val();
	buscaDatos(0,0,5,3,selectFechaEntidadesPagadoras);
});
$('.iconoTodosStock').click(function(){
	var selectFechaStock = $('#selectFechaStock').val();
	buscaDatos(0,0,6,1,selectFechaStock);
});
$('.iconoTodosIntancias').click(function(){
	var selectFechaIntancias = $('#selectFechaIntancias').val();
	buscaDatos(0,0,6,2,selectFechaIntancias);
});
$('.iconoTodosColocados').click(function(){
	var selectFechaColocados = $('#selectFechaColocados').val();
	buscaDatos(0,0,6,3,selectFechaColocados);
});
$('.detalleOperacional').click(function(){
	buscaDatos('','',10,1,'');
});
$('.detalleComercial').click(function(){
	buscaDatos('','',10,2,'');
});
$('.detalleControl').click(function(){
	buscaDatos('','',10,3,'');
});


$(function () {
	$('.ayuda').tooltip();
});
function buscaDatos(idSucursal,traeDatos,tipoConsulta,consulta,fecha)
{
	var perfil = $('#perfilMain').val();
	var id_usuario = $('#idUsuarioMain').val();	
	var idSucMain = $('#idSucursalMain').val();
	var url ='informes/distribulleInformes.asp?idSucursal='+idSucursal+'&traeDatos='+traeDatos+'&tipoConsulta='+tipoConsulta+'&consulta='+consulta+'&fecha='+fecha+'&perfil='
	+perfil+'&id_usuario='+id_usuario+'&idSucMain='+idSucMain;
	location.href = url;
	//alert(url)
}