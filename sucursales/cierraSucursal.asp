<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursalMain"))%>
<div class="row-fluid">
	<div class="span12 well">
		<div class="row-fluid">
			<div class="span12">Desea realmente cerrar la sucursal?</div>
		</div>
		<div class="row-fluid">
			<div class="span3 btn btn-success btnCierra">Si</div>
			<div class="span3 btn btn-danger btnNoCierra">No</div>
			<div class="span6"></div>
		</div>
	</div>
</div>
<script type="text/javascript">
$('.btnNoCierra').click(function(){
	$('#divBotonCierraSucursal').html('<div class="btn btn-danger botonCierraSucursal"><i class="icon-signout"></i><strong>Cerrar Sucursal</strong></div>');
});
$('.btnCierra').click(function(){
	pagina = 'sucursales/cierraSucursalSql.asp';
	div = 'divBotonCierraSucursal';
	datos='idSucursal=<%=idSucursal%>';
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
	pagina = 'sucursales/miSucursal.asp';
	div = 'miSucursal';
	datos = '';
	setTimeout(function() {
		$('#divBotonCierraSucursal').fadeOut('slow');
		try{enviaDatos(pagina,div,datos);
		}catch(err){}
	}, 1500);
})
</script>