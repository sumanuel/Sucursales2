<%idPerfil = trim(request("perfilMain"))%>
<div class="row-fluid">
	<div class="span2" id="muestraInfoSa">
		<span class="alert alert-danger mano">
			<i class="icon-signin"></i> Sin Apertura
		</span>
	</div>
	<div class="span2" id="muestraInfoDp">
		<span class="alert alert-success mano">
			<i class="icon-signin"></i> Abiertas DP
		</span>
	</div>

	<div class="span2" id="muestraInfoFp">
		<span class="alert alert-warning mano">
			<i class="icon-signin"></i>
			Abiertas FP
		</span>
	</div>
	<div class="span2" id="muestraInfoCr">
		<span class="alert alert-info mano">
			<i class="icon-signout"></i>
			Cerradas
		</span>
	</div>
	<div class="span2 offset2" id="cierraInfoSuc">
		<span class="alert alert-danger mano">
			<i class="icon-off"></i>
			Cerrar
		</span>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="muestraTablaInfoSucursales"></div>
</div>
<script type="text/javascript">
$(function(){
	pagina = 'sucursales/tablaSucursales.asp'
	div='muestraTablaInfoSucursales';
	datos = 'tipo=4'
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#muestraInfoSa').click(function(){
	pagina = 'sucursales/tablaSucursales.asp'
	div='muestraTablaInfoSucursales';
	datos = 'tipo=4'
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#muestraInfoDp').click(function(){
	pagina = 'sucursales/tablaSucursales.asp'
	div='muestraTablaInfoSucursales';
	datos = 'tipo=1'
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#muestraInfoFp').click(function(){
	pagina = 'sucursales/tablaSucursales.asp'
	div='muestraTablaInfoSucursales';
	datos = 'tipo=2'
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#muestraInfoCr').click(function(){
	pagina = 'sucursales/tablaSucursales.asp'
	div='muestraTablaInfoSucursales';
	datos = 'tipo=3'
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#cierraInfoSuc').click(function(){
	$('#divDetalleSucursales').addClass('oculto');
})
</script>