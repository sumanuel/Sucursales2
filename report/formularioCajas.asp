<!--#include file="../funciones2.asp"-->
<%
idUsuarioMainCaja = trim(request("idUsuarioMainCaja"))
idSucursalCaja = trim(request("idSucursalCaja"))
'response.write(txtCarpeta)
'response.end
%>
<div class="row-fluid">
	<div class="span11 offset" id="controlador" data-usuario="<%=idUsuarioMainCaja%>" data-sucursal="<%=idSucursalCaja%>">
		<form class="form-horizontal" >
			<div class="control-group" id="controlCodigo">
				<label class="control-label" for="txtCodigoBarras">Numero de Caja/Sobre</label>
				<div class="controls" id="control">
					<input type="text" id="txtCodigoBarras" placeholder="Código de Barras">
					<span id="checkOk">
						<i class="icon-ok"></i>
					</span>
					<span id="validaInputVacio" class="badge badge-important oculto">Ingrese Codigo Barras</span>
					<span id="msjIngresoRegistroCaja" class="badge badge-info ">Está Registrando Caja</span>
					<span id="msjRegistroCompletado" class="badge badge-success oculto"> 
					<i class="icon-check-sign icon-large"></i> Registro Completado</span>
					<span id="validaCamposCaja"></span>
					<span id="cargaRegistroCaja" class="oculto"><img src="../cdn/img/loader.gif"></span>
				</div>
			</div>
			<div class="row-fluid span12">
				<div class="control-group offset3">
					<div class="controlss oculto" id="controlBtn">
						<span class="btn btn-primary span2" id="btnRegistraCaja" onclick="registraCaja();" data-toggle="tooltip" title="Registra Caja/Sobre"><i class="icon-save icon-large"></i></span>
						<span class="btn btn-danger span2" id="btnCancelaCaja" onclick="cancelaCaja();" data-toggle="tooltip" title="Limpia Campo Cod Barra"><i class="icon-eraser icon-large"></i></span>
					</div>
				</div>
			</div>
		</form>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('#txtCodigoBarras').val('');
	//$('#btnRegistraCaja, #btnCancelaCaja').tooltip('show');
	$('#checkOk').hide();
	setTimeout(function() {
		$('#txtCodigoBarras').focus();
	},600);
});
var typingTimer;
var doneTypingInterval = 900;
$('#txtCodigoBarras').keyup(function(){
	clearTimeout(typingTimer);
	typingTimer = setTimeout(doneTyping, doneTypingInterval);
});

$('#txtCodigoBarras').keydown(function(){
	clearTimeout(typingTimer);
});

function doneTyping(){
	var codigo = $.trim($('#txtCodigoBarras').val());
	if ($.isNumeric(codigo) === true){
		if (codigo !== ''){
			var pagina, div, datos, codigo;
			$('#controlBtn').removeClass('oculto');
			codigo = $.trim($('#txtCodigoBarras').val());
			pagina = 'report/buscaCodigo.asp';
			div = 'validaCamposCaja';
			datos='codigo='+codigo;
			enviaDatos(pagina,div,datos);
			$('#msjIngresoRegistroCaja').hide();
		}else{
			$('#checkOk').html('<i class="icon-remove"></i>').slideDown('slow').removeClass('text-success').addClass('text-error');
			$('#controlador').removeClass('success').addClass('error');
			$('#btnRegistraCaja').hide();	
		}
	}else{
		$('#checkOk').html('<i class="icon-remove"></i>').slideDown('slow').removeClass('text-success').addClass('text-error');
		$('#controlador').removeClass('success').addClass('error');
		$('#btnRegistraCaja').hide();
	}
}
function registraCaja(){
	var codigo = $.trim($('#txtCodigoBarras').val());
	if (codigo === '' && codigo === 0){
		$('#controlador').removeClass('error').addClass('success');
		$('#validaInputVacio').slideDown('fast');
		$('#msjIngresoRegistroCaja').hide();
		setTimeout(function(){ 
			$('#validaInputVacio').hide();
			$('#msjIngresoRegistroCaja').show();
		},2500)	
	}else{ 
		var pagina, div, datos, idSucursalMain, idUsuarioMain, codigo;
		codigo = $.trim($('#txtCodigoBarras').val());
		idSucursalMain = $('#controlador').attr('data-sucursal');
		idUsuarioMain = $('#controlador').attr('data-usuario');
		pagina = 'report/sqlRegistraCajas.asp';
		div = '';
		datos='codigo='+codigo+'&idAccion=1&idUsuarioMain1='+idUsuarioMain+'&idSucursalMain1='+idSucursalMain;
		enviaDatos(pagina,div,datos);
		$('#validaCamposCaja, #msjIngresoRegistroCaja').slideUp('fast');
		$('#checkOk').html('<i class="icon-ok"></i>').hide();
		$('#btnRegistraCaja, #btnCancelaCaja').hide();
		$('#cargaRegistroCaja').show();
		setTimeout(function(){
			$('#cargaRegistroCaja').hide();
			$('#msjRegistroCompletado').slideDown('fast');
		},1500);
		setTimeout(function(){
			$('#msjRegistroCompletado').hide();
			$('#txtCodigoBarras').val('');
			$('#msjIngresoRegistroCaja').slideDown('fast');
			$('#controlBtn').addClass('oculto');
		},3200);
	}
}

function cancelaCaja(){
	$('#txtCodigoBarras').val('');
	$('#controlBtn').addClass('oculto');
	$('#validaCamposCaja, #msjRegistroCompletado').hide();
	$('#checkOk').html('<i class="icon-remove"></i>').hide();
	$('#controlador').removeClass('error').addClass('success');
	$('#btnRegistraCaja, #msjIngresoRegistroCaja').slideDown('fast');
}
</script>