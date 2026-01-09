<!--#include file="../funciones2.asp"-->
<%
idUsuarioMainCaja = trim(request("idUsuarioMainCaja"))
idSucursalCaja = trim(request("idSucursalCaja"))
'response.write(idSucursalMain)
'response.end
%>

<div class="row-fluid">
	<div class="span5 offset3">
		<form class="form-horizontal">
			<div class="control-group" id="controlCodigo">
				<label class="control-label" for="txtCodigoBarras">Código de Barras</label>
				<div class="controls">
					<input type="text" id="txtCodigoBarras" placeholder="Código de Barras">
					<span id="checkOk">
						<i class="icon-ok"></i>
					</span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="txtCodigoBarras"></label>
				<div class="controls" id="controlBtn">
					<span id="btnGuardaCodigoBarras">Guardar</span>
				</div>
			</div>
		</form>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('#btnGuardaCodigoBarras, #checkOk').hide();
	setTimeout(function() {
		$('#txtCodigoBarras').focus();
	},600);
});
var typingTimer;
var doneTypingInterval = 2000;
$('#txtCodigoBarras').keyup(function(){
	clearTimeout(typingTimer);
	typingTimer = setTimeout(doneTyping, doneTypingInterval);
});

$('#txtCodigoBarras').keydown(function(){
	clearTimeout(typingTimer);
});

function doneTyping (){
	var codigo = $.trim($('#txtCodigoBarras').val());
	var pagina, div, datos;
	pagina = 'CheckListCredito/buscaCodigo.asp';
	div = 'btnGuardaCodigoBarras';
	datos='codigo='+codigo;
	enviaDatos(pagina,div,datos);
}
function registraCodigo(){
	var codigo = $.trim($('#txtCodigoBarras').val());
	$('#controlCodigo').slideUp('fast');
	$('#controlBtn').addClass('label');
	$('#btnGuardaCodigoBarras').html('Quiere registrar la caja: '+codigo+' <span class="btn btn-mini btn-success" onClick="registrar();"> Si </span> <span class="btn btn-mini btn-danger" onClick="cierraForm();"> No </span>');
}
function registrar(){
	$('#btnGuardaCodigoBarras').html('<span id="registra" class="oculto"></span><span id="muestraTexto"><img src="../cdn/img/loader.gif"></span>');
	$('#registra').slideUp('fast');
	var pagina, div, datos,codigo,valorCampo, idUsuario, idSucursal;
	codigo = $.trim($('#txtCodigoBarras').val());	
	//idUsuario = $.trim($('#idUsuario').val());
	idUsuario = <%=idUsuarioMainCaja%>;
	idSucursal = <%=idSucursalCaja%>;
	//alert(idUsuario);
	pagina = 'CheckListCredito/sqlRegistraCajas.asp';
	div = 'registra';
	datos='codigo='+codigo+'&idAccion=1&idUsuario='+idUsuario+'&idSucursal='+idSucursal;
	enviaDatos(pagina,div,datos);
	setTimeout(function() {
		valorCampo = $.trim($('#btnGuardaCodigoBarras').text());
		if (valorCampo === '')
		{
			$('#controlBtn').removeClass('label').addClass('badge badge-success');
			$('#btnGuardaCodigoBarras').html('<i class="icon-ok"></i> Caja ingresada');
		}
	}, 600);
	setTimeout(function() {
		cierraForm();
	}, 1500);
}
</script>