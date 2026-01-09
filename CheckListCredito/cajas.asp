<!--#include file="../funciones2.asp"-->
<%
idSucursalCaja = trim(request("idSucursalCaja"))
idUsuarioMainCaja = trim(request("idUsuarioMainCaja"))
'response.write(idSucursalMain)
'response.end
%>

<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid" id="bloqueBotonAbreFormCaja">
			<div class="span2 btn btn-primary" id="btnCreaCaja">
				<span class="icon-stack">
					<i class="icon-check-empty icon-stack-base"></i>
					<i class="icon-archive"></i>
				</span> 
				Agregar Caja
			</div>
		</div>
		<p>
		<div class="row-fluid" id="bloqueBotonACierraFormCaja">
			<div class="span3 btn btn-primary" id="btnCierraFormCaja">
				<span class="icon-stack">
					<i class="icon-ban-circle icon-stack-base text-error"></i>
					<i class="icon-archive"></i>
				</span> 
				Cerrar Ingreso Caja
			</div>
		</div>
		</p>
		<div class="row-fluid" id="bloqueFormCaja">
			<div class="span12" id="formularioCajas">
			</div>
		</div>
	</div>
</div>
<div class="row-fluid" id="bloqueListaCajas">
	<div class="span12" id="listaCajas">
		<span><img src="../cdn/img/loader.gif"> Buscando cajas </span>
	</div>
</div>
<script type="text/javascript">
$(function(){
	var idSucursalCaja = <%=idSucursalCaja%>;
	$('#bloqueFormCaja, #bloqueBotonACierraFormCaja').hide();
	var pagina, div, datos;
	pagina = 'CheckListCredito/listaCajas.asp';
	div = 'listaCajas';
	var datos='idSucursalCaja='+idSucursalCaja;
	enviaDatos(pagina,div,datos);	
});

$('#btnCreaCaja').click(function() {
	var idUsuarioMainCaja = <%=idUsuarioMainCaja%>
	var idSucursalCaja = <%=idSucursalCaja%>;
	$('#bloqueListaCajas, #bloqueBotonAbreFormCaja').slideUp('fast');
	$('#bloqueBotonACierraFormCaja, #bloqueFormCaja').slideDown('fast', function() {
	var pagina, div, datos;	
	pagina = 'CheckListCredito/formularioCajas.asp';
	div = 'formularioCajas';
	datos = 'idUsuarioMainCaja='+idUsuarioMainCaja+'&idSucursalCaja='+idSucursalCaja;
	enviaDatos(pagina,div,datos);
	});
});

$('#btnCierraFormCaja').click(function() {
	cierraForm();
});
function cierraForm(){
	$('#listaCajas').html('').hide();
	var idSucursalCaja = <%=idSucursalCaja%>;
	$('#bloqueBotonACierraFormCaja, #bloqueFormCaja').slideUp('fast');
	$('#bloqueListaCajas, #bloqueBotonAbreFormCaja').slideDown('fast', function(){
	var pagina, div, datos;
	pagina = 'CheckListCredito/listaCajas.asp';
	div = 'listaCajas';
	datos='idSucursalCaja='+idSucursalCaja;
	enviaDatos(pagina,div,datos);
});
}
</script>