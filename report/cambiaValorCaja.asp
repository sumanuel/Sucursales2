
<%idSucursalMain = trim(request("idSucursalMain1"))
idUsuarioMain = trim(request("idUsuarioMain1"))
perfilMain = trim(request("perfilMain1"))
txtCarpeta = trim(request("idCarpeta"))
'response.write(txtCarpeta)
'response.end
%>
<div class="row-fluid">
	<div class="span4 offset3">
		<form id="carpetaCaja<%=txtCarpeta%>" name="carpetaCaja<%=txtCarpeta%>">
			<div class="row-fluid">
				<div class="span6">
					Caja Anterior
				</div>
					<div class="span6" id="muestraCodigoBarraAnterior">
				</div>
			</div>
			<div class="row-fluid">
				<div class="span6">
					Ingrese Nueva Caja
				</div>
				<div class="span6">
					<input type="text" name="txtCaja" id="txtCaja" class="<%=txtCarpeta%>">
					<span id="errorCaja<%=txtCarpeta%>"></span>
					<input type="hidden" name="txtCarpeta" id="txtCarpeta" value="<%=txtCarpeta%>">
					<input type="hidden" name="modo" id="modo" value="3">
					<span class="btn btn-mini btn-danger" id="registrarDocumentos<%=txtCarpeta%>">Modificar</span>
				</div>
			</div>
		</form>
	</div>
</div>
<script type="text/javascript">
$(function(){
	var codigoBarra = $('#modalCambiaCodigoCaja').attr('data-codigoBarra');
	$('#muestraCodigoBarraAnterior').text(codigoBarra);
});	
$('#registrarDocumentos'+$('#txtCarpeta').val()).click(function() {
	var valores, valorCaja, txtCarpeta;
	txtCarpeta = $('#txtCarpeta').val();
	valores = $('#carpetaCaja'+txtCarpeta).serialize();
	valorCaja = $('#txtCaja').val();
	
	if (valorCaja === ''){
		$('#errorCaja'+txtCarpeta).addClass('badge badge-important').text('Debe ingresar número de caja');
		}else if (valorCaja <= 0){
			$('#errorCaja'+txtCarpeta).addClass('badge badge-important').text('Debe ingresar número mayor a 0 ');
	}else{
		var codigoBarra = $('#modalCambiaCodigoCaja').attr('data-codigoBarra');
		if (valorCaja === codigoBarra){
			$('#errorCaja'+txtCarpeta).addClass('badge badge-important').text('El número de caja no puede ser igual al anterior');
		}else{
			$('#errorCaja'+txtCarpeta).slideUp('fast');
				var pagina, div, datos, idUsuarioMain, idSucursalMain, nuevaCaja;
				idUsuarioMain = $.trim($('#idUsuarioMain').val());
				idSucursalMain = $.trim($('#idSucursalMain').val());
				nuevaCaja = $('#txtCaja').val();
				pagina = 'report/sqlCambiaCaja.asp';
				div = 'errorCaja'+txtCarpeta;
				datos = valores+'&idUsuarioMain1='+idUsuarioMain+'&idSucursalMain1='+idSucursalMain;
				enviaDatos(pagina,div,datos);
				$('#modalCambiaCodigoCaja').attr('data-codigoBarra',nuevaCaja);
		}
	}


});

</script>