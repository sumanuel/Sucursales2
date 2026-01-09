<!--#include file="../funciones.asp"-->
<div class="row-fluid">
	<div class="span12">
		<ul class="nav nav-tabs" id="menuActivos">    
			<li id="entel">
				<a href="#">
					<i class="icon-fixed-width icon-home"></i>
					Entel
				</a>
			</li>
			<li id="lh">
				<a href="#">
					<i class="icon-fixed-width icon-list-alt"></i>
					LH
				</a>
			</li>
			<li id="otros">
				<a href="#">
					<i class="icon-fixed-width icon-building"></i>
					Otros
				</a>
			</li>
			<!---<li id="tabInformeActivos">
				<a href="#">
					<i class="icon-fixed-width icon-building"></i>
					Informes
				</a>
			</li>-->
		</ul>
	</div>
</div>
<div class="row-fluid">
	<div class="span4"></div>
	<div class="span4 well">Ante dudas o consultas sobre el uso de la aplicación por favor comunicarse con :<br>
		<strong>Soporte Canales</strong> al correo <strong>SoporteCanales@losheroes.cl</strong>
	</div>
	<div class="span4"></div>
</div>
<!--<div class="row-fluid">
	<div class="span4"></div>
	<div class="span4 well">Para ingresar todo equipo Compaq debe seleccionar previamente la marca HP</div>
	<div class="span4"></div>
</div>-->
<div class="row-fluid" id="divBtnAgregarActivo">
	<div class="span2 btn btn-success" id="btnAgregarActivo">
		<strong>
			<i class="icon-plus"></i> 
			Agregar Activo
		</strong>
	</div>
</div>
<div class="row-fluid oculto" id="divAgregarActivos">
	<div class="span3"></div>
	<div class="span6 well" id="cargaActivos"></div>
	<div class="span3"></div>
</div>
<div class="row-fluid">
	<div class="span12" id="informeActivos"></div>
</div>
<script type="text/javascript">
$(function(){
	$('ul#menuActivos > li').removeClass('active');
	$('#entel').addClass('active');
	$('#divBtnAgregarActivo').slideDown('fast');
	var pagina='activos/activosEntel.asp';
	var div='cargaActivos';
	var datos = '';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	pagina='activos/informeActivos.asp';
	div='informeActivos';
	datos = 'tipoActivo=1';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	$('#cargaActivos').addClass('oculto');
});
$('#entel').click(function(){
	$('ul#menuActivos > li').removeClass('active');
	$(this).addClass('active');
	$('#divBtnAgregarActivo').slideDown('fast');
  pagina='activos/activosEntel.asp';
  div='cargaActivos';
  datos = '';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	var pagina='activos/informeActivos.asp';
	var div='informeActivos';
	var datos = 'tipoActivo=1';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	$('#divAgregarActivos').addClass('oculto');
});
$('#lh').click(function(){
	$('ul#menuActivos > li').removeClass('active');
	$(this).addClass('active');
	$('#divBtnAgregarActivo').slideDown('fast');
	var pagina='activos/activosLH.asp';
	var div='cargaActivos';
	var datos = '';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
    pagina='activos/informeActivos.asp';
    div='informeActivos';
    datos = 'tipoActivo=2';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	$('#divAgregarActivos').addClass('oculto');
});
$('#otros').click(function(){
	$('ul#menuActivos > li').removeClass('active');
	$(this).addClass('active');
	$('#divBtnAgregarActivo').slideDown('fast');
    var pagina='activos/activosOtros.asp';
    var div='cargaActivos';
    var datos = '';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
    pagina='activos/informeActivos.asp';
    div='informeActivos';
    datos = 'tipoActivo=3';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	$('#divAgregarActivos').addClass('oculto');
});
/*$('#tabInformeActivos').click(function(){
	$('ul#menuActivos > li').removeClass('active');
	$(this).addClass('active');
    var pagina='activos/informesActivos.asp'
    var div='informeActivos';
    var datos = '';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	$('#divBtnAgregarActivo').slideUp('fast');
	$('#cargaActivos').slideUp('fast');
	
})*/
$('#btnAgregarActivo').click(function(){
	$('#divAgregarActivos').removeClass('oculto');
});
function soloModelo()
{
	$('#divModelo, #divMarca ,#divSerie').slideUp('slow');
	$('#otrosCampos').addClass('control-group').html('<label class="control-label" for="cantidadTotal">Cantidad</label><div class="controls" id="controlSerie"><input type="text" name="cantidadTotal" id="cantidadTotal" data-rule-required="true" data-msg-required="Debe ingresar cantidad" data-rule-number="true" data-msg-number="Debe ingresar solo números"></div><div class="control-group"><div class="controls"><input type="submit" class="btn btn-success" value="Guardar Registro" id="botonRegistroUsuario"></div></div>');
}
function soloModelo2()
{
	$('#divSerie, #divNombreUsuario, #divCorreo').slideUp('slow');
	$('#otrosCampos').addClass('control-group').html('<label class="control-label" for="cantidadTotal">Cantidad</label><div class="controls" id="controlSerie"><input type="text" name="cantidadTotal" id="cantidadTotal" data-rule-required="true" data-msg-required="Debe ingresar cantidad" data-rule-number="true" data-msg-number="Debe ingresar solo números"></div><div class="control-group"><div class="controls"><input type="submit" class="btn btn-success" value="Guardar Registro" id="botonRegistroUsuario"></div></div>');
}
function soloModelo3()
{
	$('#divCargo, #divNombreUsuario, #divCorreo').slideUp('slow');
	$('#otrosCampos').addClass('control-group').html('<div class="controls"><input type="submit" class="btn btn-success" value="Guardar Registro" id="botonRegistroUsuario"></div>');	
}
//function soloModelo4()
//{
//	$('#divNombreUsuario, #divCorreo').slideUp('slow');
//}
function soloModelo5()
{
	$('#divCorreo').slideUp('slow');
}

</script>