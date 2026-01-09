<%
txtCarpeta = trim(request("idCarpeta"))
idSuc = trim(request("idSuc"))

%>
<div class="row-fluid">
	<div class="span4 offset3">
		<form id="carpetaCaja<%=txtCarpeta%>" name="carpetaCaja<%=txtCarpeta%>">
		<div class="row-fluid">
				<div class="span6">
					Caja anterior
				</div>
				<div class="span6" id="muestraCodigoBarrasAnt">
				</div>
			</div>
			<div class="row-fluid">
				<div class="span6">
					Nueva Caja
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
	$('#muestraCodigoBarrasAnt').text(codigoBarra);
});
$('#registrarDocumentos'+$('#txtCarpeta').val()).click(function() {
	var valores, valorCaja, txtCarpeta;
	txtCarpeta = $('#txtCarpeta').val();
	valores = $('#carpetaCaja'+txtCarpeta).serialize();
	valorCaja = $('#txtCaja').val();
	if (valorCaja ==='')
	{
		$('#errorCaja'+txtCarpeta).addClass('badge badge-important').text('Debe ingresar número de caja');
	}
	else
	{
		var codigoBarra = $('#modalCambiaCodigoCaja').attr('data-codigoBarra');
		if (valorCaja === codigoBarra)
		{
			$('#errorCaja'+txtCarpeta).addClass('badge badge-important').text('El número de caja no puede ser igual al anterior');
		}
		else
		{
			$('#errorCaja'+txtCarpeta).slideUp('fast');
			var idSuc = <%=idSuc%>;
			var nuevaCaja = $('#txtCaja').val();
			var idUsuario = $.trim($('#idUsuario').val());
			var pagina, div, datos;
			pagina = 'CheckListCredito/sqlCarpetaCaja.asp';
			div = 'errorCaja'+txtCarpeta;
			datos= valores+'&idUsuario='+idUsuario+'&idSuc='+idSuc;
			enviaDatos(pagina,div,datos);
			$('#modalCambiaCodigoCaja').attr('data-codigoBarra',nuevaCaja);
		}
	}
});
</script>