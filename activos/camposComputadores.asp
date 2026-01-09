<!--#include file="../funciones.asp"-->
<%tipoFormulario = trim(request("tipoFormulario"))
tipoElemento = trim(request("tipoElemento"))
tieneResticcion = 0
activaCantidad = 0
if tipoFormulario = "1" then
	if tipoElemento = "1" then
		cargo = "(1,2,3,5,6,7,8,10,12,13,14,17)"
		tieneResticcion = 1
	end if
	if tipoElemento = "9" then
		cargo="(1,4,6,8,9,11,5,17)"
		tieneResticcion = 1
	end if
	if tipoElemento= "8" then
		cargo="(1,2,3,4,5,6,7,8,9,10,11,12,13,14,17)"
		tieneResticcion = 1
	end if
end if
if tipoFormulario = "3" then
	if tipoElemento = "2" then
		cargo="(3,4,6,15)"
		tieneResticcion = 1
	end if
	if tipoElemento ="4" then
		cargo = "(1,2,3,5,6,7,8,9,10,11,13,14)"
		tieneResticcion = 1
	end if
	if tipoElemento ="5" or tipoElemento ="6" or tipoElemento ="7" then
		cargo = "(6,16)"
		tieneResticcion = 1
		activaCantidad=1
		textoCantidad="Cantidad"
	end if
end if
if tipoElemento = "2" then
	activaCantidad=1
	textoCantidad="Cantidad de usuarios"
end if
sql = ""
sql = sql & " select id_cargo, "
sql = sql & " nombre_cargo "
sql = sql & " from suc_activo_cargo "
if tieneResticcion = 1 then
	sql = sql & " where id_cargo in "&cargo
end if
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
end if%>
<div class="control-group" id="divRotulo">
	<label class="control-label" for="rotulo">Rotulo inventario Los Heroes</label>
	<div class="controls" id="controlRotulo">
		<input type="text" name="rotulo" id="rotulo" data-rule-required="true" data-msg-required="El campo no puede estar vacio">
		<span class="btn btn-mini btn-danger" id="btnSinRotulo">Sin rotulo</span>
	</div>
</div>
<%if tipoFormulario <> "2" then%>
	<div class="control-group" id="divCargo">
		<label class="control-label" for="campoCargo">Cargo</label>
		<div class="controls" id="cargo">
			<select id="campoCargo" name="campoCargo" data-rule-required="true" data-msg-required="Debe seleccionar una opción">
				<option value="">[Seleccione Cargo]</option>
				<%For i = 0 to ubound(datos, 2)
					idCargo = trim(datos(0,i))
					nombreCargo = server.htmlencode(trim(datos(1,i)))%>
					<option value="<%=idCargo%>"><%=nombreCargo%></option>
				<%next%>
			</select>
		</div>
	</div>
<%else%>
	<input type="hidden" name="campoCargo" id="campoCargo" value="6">
<%end if%>

<%if activaCantidad = "1" then%>
	<div class="control-group" id="divCantidadUsuarios">
		<label class="control-label" for="cantidadTotal"><%=textoCantidad%></label>
		<div class="controls" id="controlCantidad">
			<input type="text" name="cantidadTotal" id="cantidadTotal" data-rule-required="true" data-msg-required="Debe ingresar cantidad" data-rule-number="true" data-msg-number="Debe ingresar solo números">
		</div>
	</div>
<%end if%>
<div class="control-group" id="divNombreUsuario">
	<label class="control-label" for="nombreUsuario">Nombre de usuario</label>
	<div class="controls" id="controlNombreUsuario">
		<input type="text" name="nombreUsuario" id="nombreUsuario" data-rule-required="true" data-msg-required="El campo no puede estar vacio">
	</div>
</div>
<div class="control-group" id="divCorreo">
	<label class="control-label" for="correo">Correo electrónico</label>
	<div class="controls" id="controlCorreo">
		<input type="text" name="correo" id="correo" data-rule-required="true" data-rule-email="true" data-msg-email="Ingrese una dirección de correo válida" data-msg-required="El campo no puede estar vacio">
	</div>
</div>
<div class="control-group">
	<div class="controls">
		<input type="submit" class="btn btn-success" value="Guardar Registro" id="º">
	</div>
</div>
<script type="text/javascript">
if ($('#tipoFormulario').val() === '1' || $('#tipoFormulario').val() === '3')
{
	$('#divRotulo').slideUp('fast');
	$('#controlRotulo').html('<input type="hidden" name="rotulo" id="rotulo" value="">');
};
$('#btnSinRotulo').click(function(){
	$('#rotulo').val('Sin Rotulo');
});
if ($('#tipoElemento').val() ==='5' || $('#tipoElemento').val() ==='6' || $('#tipoElemento').val() ==='7')
{
	$('#cantidadTotal').attr('data-rule-max','30');
	$('#cantidadTotal').attr('data-rule-min','1');
	$('#cantidadTotal').attr('data-msg-max','La cantidad no puede ser mayor a 30');
	$('#cantidadTotal').attr('data-msg-min','La cantidad no puede ser menor a 1');
}
if($('#tipoFormulario').val() === '2')
{
	$('#rotulo').attr('data-rule-number','true');
	$('#rotulo').attr('data-msg-number','Debe ingresar solo números');
}
$('#campoCargo').change(function(){
	if ($('#campoCargo option:selected').val() === '6')
	{
		soloModelo4();
	}
	if($('#campoCargo option:selected').val() ==='3')
	{
		soloModelo5();
	}
});
/*if($('#campoCargo option:selected').val() ==='6')
{
	soloModelo4();
}*/

/*$('#botonRegistroUsuario').click(function(){
	$('ul#menuActivos > li').removeClass('active');
	$(this).addClass('active');
	$('#divBtnAgregarActivo').slideDown('fast');
    var pagina='activos/activosOtros.asp';
    var div='cargaActivos';
    var datos = '';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
    var pagina='activos/informeActivos.asp';
    var div='informeActivos';
    var datos = 'tipoActivo=3';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	$('#divAgregarActivos').addClass('oculto');
});*/

</script>