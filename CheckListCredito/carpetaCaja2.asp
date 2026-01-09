<!--#include file="../funciones2.asp"-->
<%
mes = trim(request("mes"))
anio = trim(request("anio"))
%>

<%txtCarpeta= trim(request("idCarpeta"))%>
<div class="row-fluid">
	<div class="span4 offset3">
		<form id="carpetaCajaCambia<%=txtCarpeta%>" name="carpetaCajaCambia<%=txtCarpeta%>">
			<div class="row-fluid">
				<div class="span6">
					Ingrese Caja
				</div>
				<div class="span6">
					<input type="text" name="txtCajaCambia" id="txtCajaCambia" class="<%=txtCarpeta%>">
					<span id="errorCajaCambia<%=txtCarpeta%>"></span>
					<input type="hidden" name="txtCarpeta" id="txtCarpeta" value="<%=txtCarpeta%>">
					<input type="hidden" name="modo" id="modo" value="2">
					<span class="btn btn-mini btn-danger registraDoc" id="registrarDocumentos<%=txtCarpeta%>" onClick="registraDoc();">
						Modificar
					</span>
				</div>
			</div>
		</form>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('#botonPaso2Modal').slideUp('fast');
});
function registraDoc()
{
	var valores, valorCaja,txtCarpeta;
	txtCarpeta = $('#txtCarpeta').val();
	valores = $('#carpetaCajaCambia<%=txtCarpeta%>').serialize();
	valorCaja = $('#txtCajaCambia').val();
	if (valorCaja ==='')
	{
		$('#errorCaja<%=txtCarpeta%>').addClass('badge badge-important').text('Debe ingresar número de caja');
	}
	else
	{
		$('#errorCaja<%=txtCarpeta%>').slideUp('fast');
		var mes = <%=mes%>;
		var anio = <%=anio%>;
		var idUsuario = $.trim($('#idUsuario').val());
		var pagina, div, datos;
		pagina = 'CheckListCredito/sqlCarpetaCaja.asp';
		div = 'errorCajaCambia<%=txtCarpeta%>';
		datos= valores+'&idUsuario='+idUsuario+'&mes='+mes+'&anio='+anio;
		enviaDatos(pagina,div,datos);
	}
}
</script>