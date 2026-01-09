<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<% 
tipo=request.QueryString("tipo")  

qtipo ="select * from dbo.SUC_sucursal_dotacion_tipo where id_tipo="&tipo&" and est_reg=1"
set rsTipo = DB.execute(qtipo)

cargos ="select * from dbo.SUC_sucursal_dotacion_cargos where est_reg=1"
set rsCargos = DB.execute(cargos)

zonas ="select * from dbo.SUC_sucursal_dotacion_zonas where est_reg=1"
set rsZonas = DB.execute(zonas)

zonales ="select * from dbo.SUC_sucursal_dotacion_zonales where est_reg=1"
set rsZonales = DB.execute(zonales)

sucursales ="select id_sucursal, cod_bantotal, suc_nombre from SUC_sucursal order by suc_nombre"
set rsSucursales = DB.execute(sucursales)

if NOT rsTipo.EOF then %>
<script type="text/javascript" src="js/bootstrap-popover.js"></script>
<script type="text/javascript">
// JavaScript Document
function validarSoloNumeros(event){
	if (event.keyCode < 48 || event.keyCode > 57)
		return false;	
}

function validarSoloLetras(event){
	if (event.keyCode<65 || event.keyCode>90 && event.keyCode<97 || event.keyCode>122)
		return false;
}

//Función para validar el ingreso del Digito Verificador de un RUT
function validarCaracteres(event){
	if (event.keyCode<65 || event.keyCode>90 && event.keyCode<97 || event.keyCode>122 && event.keyCode < 48 || event.keyCode > 57) {
		if (event.keyCode == 39 || event.keyCode == 219 || event.keyCode == 50 || event.keyCode == 34 )
			return false;
	}
}

//Función para validar el ingreso del Digito Verificador de un RUT
function validarDvRut(event){
	if (event.keyCode < 48 || event.keyCode > 57 ) {
		if (event.keyCode != 75 && event.keyCode != 107 )
			return false;
	}
}
function getDV(numero) {
	nuevo_numero = numero.toString().split("").reverse().join("");
	for(i=0,j=2,suma=0; i < nuevo_numero.length; i++, ((j==7) ? j=2 : j++)) {
		suma += (parseInt(nuevo_numero.charAt(i)) * j); 
	}
	n_dv = 11 - (suma % 11);
	return ((n_dv == 11) ? 0 : ((n_dv == 10) ? "K" : n_dv));
}
function doListaDotacion(){
	var idSucursal = $('#idSucursalMain').val();
	var datos = 'idSucursal='+idSucursal;
	$.ajax({
		url: 'dotacion/dotacion_lista.asp',
		data: datos,
		type: "GET",
		dataType: "html",
		cache:false,
		//async:true,
		timeout:120000,
		success: function(source){			
			$('#idTablaDotacion').html('');
			$('#idTablaDotacion').html(source);
		},
		error: function(source){
			alert(source);								
		}
	});
}
</script>
<%
	if rsTipo("id_tipo")=1 then 'CUPO UTILIZADO
%>
		<div id="tipoDotacion">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr height="20px">
					<td colspan="2" align="left" bgcolor="#F3F3F3"><strong style="font-size:11px">Descripci&oacute;n:</strong> <%response.Write(rsTipo("descripcion"))%></td>
				</tr>
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td width="50%">                    
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left" width="100px">R.U.N</td>
								<td align="left" width="170px"><input name="txtRut" id="txtRut" type="text" value="" maxlength="8" style="width:150px" onkeypress="return validarSoloNumeros(event)"/></td>
								<td width="10px">-</td>
                                <td align="left"><input name="txtDv" id="txtDv" type="text" maxlength="1" style="width:20px" onkeypress="return validarDvRut(event)" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para Rut" data-original-title="Error de validacion R.U.N"/></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Nombres</td>
								<td align="left" colspan="3"><input name="txtNombres" id="txtNombres" type="text" style="width:200px" value="" maxlength="199" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Nombre" data-original-title="Error de validacion NOMBRE"/></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Apellido Paterno</td>
								<td align="left" colspan="3"><input name="txtApep" id="txtApep" type="text" style="width:200px" maxlength="99" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Apellido Paterno" data-original-title="Error de validacion Apellido Paterno"/></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Apellido Materno</td>
								<td align="left" colspan="3"><input name="txtApem" id="txtApem" type="text" style="width:200px" maxlength="99" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Apellido Materno" data-original-title="Error de validacion Apellido Materno"/></td>
							</tr>
						</table>
					</td>
					<td width="50%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="100px">&nbsp;</td>
                                <td width="100px" align="left">Cargo</td>
								<td align="left"><select name="slcCargo" id="slcCargo" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Cargo" data-original-title="Error de validacion Cargo">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsCargos.EOF %>
                                        <option value="<% response.Write(rsCargos("id_cargo")) %>"><% response.Write(rsCargos("cargo")) %></option>	
                                        <% rsCargos.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Anexo</td>
								<td align="left"><input name="txtAnexo" id="txtAnexo" type="text" style="width:196px" maxlength="19" onkeypress="return validarSoloNumeros(event)" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Anexo" data-original-title="Error de validacion Anexo"/></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Zona</td>
								<td align="left"><select name="slcZona" id="slcZona" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Zona" data-original-title="Error de validacion Zona">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsZonas.EOF %>
                                        <option value="<% response.Write(rsZonas("id_zona")) %>"><% response.Write(rsZonas("zona")) %></option>	
                                        <% rsZonas.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Zonal</td>
								<td align="left"><select name="slcZonal" id="slcZonal" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Zonal" data-original-title="Error de validacion Zonal">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsZonales.EOF %>
                                        <option value="<% response.Write(rsZonales("id_zonal")) %>"><% response.Write(rsZonales("zonal")) %></option>	
                                        <% rsZonales.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
                        </table>                        
					</td>
				</tr>
               	<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
                <tr>
                	<td colspan="2">
                    	<div class="btn btn-success botonEnviaEntrada"><i class="icon-plus-sign-alt icon-large"/><strong> Ingresar</strong></div>	
					</td>
                </tr>
            </table>
            <script type="text/javascript">		
			$(document).ready(function(){
            	$('.botonEnviaEntrada').click(function(){	

					var arrForm = [];
					
					if($('#txtRut').val() == ''){						
						if ($.inArray('#txtDv', arrForm) == -1){
							arrForm.push('#txtDv');								
						}
					}
					if($('#txtDv').val() == ''){						
						if ($.inArray('#txtDv', arrForm) == -1){
							arrForm.push('#txtDv');							
						}
					}			
					if(getDV($('#txtRut').val())!=$('#txtDv').val()){						
						if ($.inArray('#txtDv', arrForm) == -1){
							arrForm.push('#txtDv');							
						}
					}						
					if($('#txtNombres').val() == '')
						arrForm.push('#txtNombres');
					if($('#txtApep').val() == '')
						arrForm.push('#txtApep');
					if($('#txtApem').val() == '')
						arrForm.push('#txtApem');
					if($('#slcCargo').val() == '0')
						arrForm.push('#slcCargo');
					if($('#txtAnexo').val() == '')
						arrForm.push('#txtAnexo');
					if($('#slcZona').val() == '0')
						arrForm.push('#slcZona');
					if($('#slcZonal').val() == '0')
						arrForm.push('#slcZonal');
										

					if(arrForm.length > 0){
						var vTime = 0;
						$.each(arrForm, function(index, value){						
							setTimeout(function(){
								$(value).popover('show');
								setTimeout(function(){
									$(value).popover('destroy');	
								}, (vTime-(vTime*0.5)))
							}, vTime);
							vTime = vTime + 1100;
						});	
					}else{						
						var rutIngresados = '';
						rutIngresados = $('#arrValidRuts').val();
						if(rutIngresados != ''){
							var arr_rutIngresado = rutIngresados.split(';');								
							if($.inArray($('#txtRut').val(), arr_rutIngresado) == '-1'){								
								$('#loadIcon').show();
								$('#formsIng').fadeOut('slow');								
								//Add new Rut
								var addRut = $('#arrValidRuts').val() + ';' + $('#txtRut').val();
								$('#arrValidRuts').val(addRut);
								
								var datos = '';
								datos += 'q=1&';
								datos += 'tipo=' + $('#tipoDot').val() + '&';
								datos += 'rut=' + $('#txtRut').val() + '&';
								datos += 'dv=' + $('#txtDv').val() + '&';
								datos += 'nombres=' + $('#txtNombres').val() + '&';
								datos += 'apep=' + $('#txtApep').val() + '&';
								datos += 'apem=' + $('#txtApem').val() + '&';
								datos += 'cargo=' + $('#slcCargo').val() + '&';
								datos += 'anexo=' + $('#txtAnexo').val() + '&';
								datos += 'zona=' + $('#slcZona').val() + '&';
								datos += 'zonal=' + $('#slcZonal').val();
								datos += '&idSucursal='+$('#idSucursalMain').val();
								
								var  executeIngreso = $.ajax({
									url: 'dotacion/dotacion_ingreso.asp',
									data: datos,
									type: "GET",
									dataType: "text",
									cache:false,
									//async:true,
									timeout:120000,
									success: function(source){						
									$('#loadIcon').hide();
									
									var idSucursal = $('#idSucursal').val();
									var datos = 'idSucursal='+idSucursal;
									var  vListaDotacion = $.ajax({										
											url: 'dotacion/dotacion_lista.asp',
											data: datos,
											type: "GET",
											dataType: "html",
											cache:false,
											//async:true,
											timeout:120000,
											success: function(source){			
												$('#idTablaDotacion').html('');
												$('#idTablaDotacion').html(source);
											},
											error: function(source){
												alert(source);								
											}
										});
									},
									error: function(source){
										alert(source);								
									}
								});	
							}else{
								$('#alertaRut').fadeIn('slow');
								setTimeout(function(){
									$('#alertaRut').fadeOut('slow');		
								},3500);
							}									
						}else{
							$('#loadIcon').show();
							$('#formsIng').fadeOut('slow');							
							//Add new Rut
							$('#arrValidRuts').val($('#txtRut').val());
							
							var datos = '';
							datos += 'q=1&';
							datos += 'tipo=' + $('#tipoDot').val() + '&';
							datos += 'rut=' + $('#txtRut').val() + '&';
							datos += 'dv=' + $('#txtDv').val() + '&';
							datos += 'nombres=' + $('#txtNombres').val() + '&';
							datos += 'apep=' + $('#txtApep').val() + '&';
							datos += 'apem=' + $('#txtApem').val() + '&';
							datos += 'cargo=' + $('#slcCargo').val() + '&';
							datos += 'anexo=' + $('#txtAnexo').val() + '&';
							datos += 'zona=' + $('#slcZona').val() + '&';
							datos += 'zonal=' + $('#slcZonal').val();
							datos += '&idSucursal='+$('#idSucursalMain').val();
							
							var  executeIngreso = $.ajax({
								url: 'dotacion/dotacion_ingreso.asp',
								data: datos,
								type: "GET",
								dataType: "text",
								cache:false,
								//async:true,
								timeout:120000,
								success: function(source){						
									$('#loadIcon').hide();
									doListaDotacion();
								},
								error: function(source){
									alert(source);								
								}
							});	
						}
					}
				});	
				});							
            </script>
		</div>
	<% end if
	if rsTipo("id_tipo")=2 then 'CUPO FALTANTE
	%>
		<div id=tipoDotacion>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr height="20px">
					<td colspan="2" align="left" bgcolor="#F3F3F3"><strong style="font-size:11px">Descripci&oacute;n:</strong> <%response.Write(rsTipo("descripcion"))%></td>
				</tr>
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td width="50%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left" width="100px">R.U.N</td>
								<td align="left" width="170px"><input name="txtRut" id="txtRut" type="text" maxlength="8" style="width:150px"/></td>
								<td width="10px">-</td>
                                <td align="left"><input name="txtDv" id="txtDv" type="text" maxlength="1" style="width:20px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo R.U.N" data-original-title="Error de validacion R.U.N"/></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Nombres</td>
								<td align="left" colspan="3"><input name="txtNombres" id="txtNombres" type="text" style="width:200px" maxlength="199" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Nombres" data-original-title="Error de validacion Nombres" /></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Apellido Paterno</td>
								<td align="left" colspan="32"><input name="txtApep" id="txtApep" type="text" style="width:200px" maxlength="99" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Apellido Paterno" data-original-title="Error de validacion Apellido Paterno"/></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Apellido Materno</td>
								<td align="left" colspan="3"><input name="txtApem" id="txtApem" type="text" style="width:200px" maxlength="99" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Apellido Materno" data-original-title="Error de validacion Apellido Materno"/></td>
							</tr>
						</table>
					</td>
					<td width="50%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left" width="100px">Cargo</td>
								<td align="left"><select name="slcCargo" id="slcCargo" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Cargo" data-original-title="Error de validacion Cargo">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsCargos.EOF %>
                                        <option value="<% response.Write(rsCargos("id_cargo")) %>"><% response.Write(rsCargos("cargo")) %></option>	
                                        <% rsCargos.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Anexo</td>
								<td align="left"><input name="txtAnexo" id="txtAnexo" type="text" style="width:196px" maxlength="19" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Anexo" data-original-title="Error de validacion Anexo"/></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Zona</td>
								<td align="left"><select name="slcZona" id="slcZona" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Zona" data-original-title="Error de validacion Zona">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsZonas.EOF %>
                                        <option value="<% response.Write(rsZonas("id_zona")) %>"><% response.Write(rsZonas("zona")) %></option>	
                                        <% rsZonas.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Zonal</td>
								<td align="left"><select name="slcZonal" id="slcZonal" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Zonal" data-original-title="Error de validacion Zonal">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsZonales.EOF %>
                                        <option value="<% response.Write(rsZonales("id_zonal")) %>"><% response.Write(rsZonales("zonal")) %></option>	
                                        <% rsZonales.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
                            <tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Sucursal Asignada</td>
								<td align="left"><select name="slcSucursal" id="slcSucursal" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Sucursal Asignada" data-original-title="Error de validacion Sucursal Asignada">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsSucursales.EOF %>
                                        <option value="<% response.Write(rsSucursales("id_sucursal")) %>"><% response.Write(rsSucursales("suc_nombre")) %></option>	
                                        <% rsSucursales.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
						</table>
					</td>
				</tr>
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr> 
                <tr>
					<td colspan="2">
                    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr align="center" valign="top">
								<td>Comentario: <textarea name="txtDetalle" id="txtDetalle" style="width:500px; height:75px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Detalle" data-original-title="Error de validacion Detalle"></textarea><input type="text" name="caracteres" id="caracteres" size=1 style="width:25px" disabled="disabled" ></td>
                            </tr>
						</table>                        
                    </td>
				</tr>
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr>
                <tr>
                	<td colspan="2">
                    	<div class="btn btn-success botonEnviaEntrada"><i class="icon-plus-sign-alt icon-large"/><strong> Ingresar</strong></div>
					</td>
                </tr> 
            </table>
            <script type="text/javascript">
			$(document).ready(function(){
				$('.botonEnviaEntrada').click(function(){
					alert('aca!')	
					var arrForm = [];
					
					if($('#txtRut').val() == ''){						
						if ($.inArray('#txtDv', arrForm) == -1){
							arrForm.push('#txtDv');								
						}
					}
					if($('#txtDv').val() == ''){						
						if ($.inArray('#txtDv', arrForm) == -1){
							arrForm.push('#txtDv');							
						}
					}				
					if(getDV($('#txtRut').val())!=$('#txtDv').val()){						
						if ($.inArray('#txtDv', arrForm) == -1){
							arrForm.push('#txtDv');							
						}
					}						
					if($('#txtNombres').val() == '')
						arrForm.push('#txtNombres');
					if($('#txtApep').val() == '')
						arrForm.push('#txtApep');
					if($('#txtApem').val() == '')
						arrForm.push('#txtApem');
					if($('#slcCargo').val() == '0')
						arrForm.push('#slcCargo');
					if($('#txtAnexo').val() == '')
						arrForm.push('#txtAnexo');
					if($('#slcZona').val() == '0')
						arrForm.push('#slcZona');
					if($('#slcZonal').val() == '0')
						arrForm.push('#slcZonal');
					if($('#slcSucursal').val() == '0')
						arrForm.push('#slcSucursal');
					if($('#txtDetalle').val() == '')
						arrForm.push('#txtDetalle');
										

					if(arrForm.length > 0){
						var vTime = 0;
						$.each(arrForm, function(index, value){						
							setTimeout(function(){
								$(value).popover('show');
								setTimeout(function(){
									$(value).popover('destroy');	
								}, (vTime-(vTime*0.5)))
							}, vTime);
							vTime = vTime + 1100;
						});	
					}else{
						var rutIngresados = '';
						rutIngresados = $('#arrValidRuts').val();
						if(rutIngresados != ''){
							var arr_rutIngresado = rutIngresados.split(';');
	
							if($.inArray($('#txtRut').val(), arr_rutIngresado) == '-1'){
								$('#loadIcon').show();
								$('#formsIng').fadeOut('slow');								
								//Add new Rut
								var addRut = $('#arrValidRuts').val() + ';' + $('#txtRut').val();
								$('#arrValidRuts').val(addRut);
								
								var datos = '';
								datos += 'q=1&';
								datos += 'tipo=' + $('#tipoDot').val() + '&';
								datos += 'rut=' + $('#txtRut').val() + '&';
								datos += 'dv=' + $('#txtDv').val() + '&';
								datos += 'nombres=' + $('#txtNombres').val() + '&';
								datos += 'apep=' + $('#txtApep').val() + '&';
								datos += 'apem=' + $('#txtApem').val() + '&';
								datos += 'cargo=' + $('#slcCargo').val() + '&';
								datos += 'anexo=' + $('#txtAnexo').val() + '&';
								datos += 'zona=' + $('#slcZona').val() + '&';
								datos += 'zonal=' + $('#slcZonal').val() + '&';
								datos += 'sucursal=' + $('#slcSucursal').val() + '&';
								datos += 'detalle=' + $('#txtDetalle').val();
								datos += '&idSucursal='+$('#idSucursalMain').val();

								
								var  executeIngreso = $.ajax({
									url: 'dotacion/dotacion_ingreso.asp',
									data: datos,
									type: "GET",
									dataType: "text",
									cache:false,
									//async:true,
									timeout:120000,
									success: function(source){						

										$('#loadIcon').hide();
										doListaDotacion();
									},
									error: function(source){
										alert(source);								
									}
								});	
							}else{
								$('#alertaRut').fadeIn('slow');
								setTimeout(function(){
									$('#alertaRut').fadeOut('slow');		
								},3500);

							}
						}else{
							$('#loadIcon').show();
							$('#formsIng').fadeOut('slow');							
							//Add new Rut							
							$('#arrValidRuts').val($('#txtRut').val());
							
							var datos = '';
							datos += 'q=1&';
							datos += 'tipo=' + $('#tipoDot').val() + '&';
							datos += 'rut=' + $('#txtRut').val() + '&';
							datos += 'dv=' + $('#txtDv').val() + '&';
							datos += 'nombres=' + $('#txtNombres').val() + '&';
							datos += 'apep=' + $('#txtApep').val() + '&';
							datos += 'apem=' + $('#txtApem').val() + '&';
							datos += 'cargo=' + $('#slcCargo').val() + '&';
							datos += 'anexo=' + $('#txtAnexo').val() + '&';
							datos += 'zona=' + $('#slcZona').val() + '&';
							datos += 'zonal=' + $('#slcZonal').val() + '&';
							datos += 'sucursal=' + $('#slcSucursal').val() + '&';
							datos += 'detalle=' + $('#txtDetalle').val();
							datos += '&idSucursal='+$('#idSucursalMain').val();
	
							
							var  executeIngreso = $.ajax({
								url: 'dotacion/dotacion_ingreso.asp',
								data: datos,
								type: "GET",
								dataType: "text",
								cache:false,
								//async:true,
								timeout:120000,
								success: function(source){						

									$('#loadIcon').hide();
									doListaDotacion();
								},
								error: function(source){
									alert(source);								
								}
							});	
						}
					}
				});
				$('#txtDetalle').keyup(function(){
					$('#caracteres').val(this.value.length);
				});
				});
			</script>
		</div>
    <% end if
	if rsTipo("id_tipo")=3 then 'CUPO SIN LLENAR
	%>
		<div id=tipoDotacion>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr height="20px">
					<td colspan="2" align="left" bgcolor="#F3F3F3"><strong style="font-size:11px">Descripci&oacute;n:</strong> <%response.Write(rsTipo("descripcion"))%></td>
				</tr>
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td width="50%">
                    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left" width="100px">Cargo</td>
								<td align="left"><select name="slcCargo" id="slcCargo" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Cargo" data-original-title="Error de validacion Cargo">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsCargos.EOF %>
                                        <option value="<% response.Write(rsCargos("id_cargo")) %>"><% response.Write(rsCargos("cargo")) %></option>	
                                        <% rsCargos.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
						</table>
                    </td>
					<td width="50%">
                    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="150px">Comentario:</td>
                                <td><textarea name="txtDetalle" id="txtDetalle" style="width:400px; height:75px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Detalle" data-original-title="Error de validacion Detalle"></textarea><input type="text" name="caracteres" id="caracteres" size=1 style="width:25px" disabled="disabled" ></td>
                            </tr>
						</table>
                    </td>
				</tr>
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr>
                <tr>
                	<td colspan="2">
                    	<div class="btn btn-success botonEnviaEntrada"><i class="icon-plus-sign-alt icon-large"/><strong> Ingresar</strong></div>
					</td>
                </tr>  
            </table>
            <script type="text/javascript">
			$(document).ready(function(){
				$('.botonEnviaEntrada').click(function(){
						var arrForm = [];					
										
						if($('#slcCargo').val() == '0')
							arrForm.push('#slcCargo');						
						if($('#txtDetalle').val() == '')
							arrForm.push('#txtDetalle');
											

						if(arrForm.length > 0){
							var vTime = 0;
							$.each(arrForm, function(index, value){						
								setTimeout(function(){
									$(value).popover('show');
									setTimeout(function(){
										$(value).popover('destroy');	
									}, (vTime-(vTime*0.5)))
								}, vTime);
								vTime = vTime + 1100;
							});	
						}else{
							$('#loadIcon').show();
							$('#formsIng').fadeOut('slow');							
							
							var datos = '';
							datos += 'q=1&';
							datos += 'tipo=' + $('#tipoDot').val() + '&';							
							datos += 'cargo=' + $('#slcCargo').val() + '&';							
							datos += 'detalle=' + $('#txtDetalle').val();
							datos += '&idSucursal='+$('#idSucursalMain').val();

							
							var  executeIngreso = $.ajax({
								url: 'dotacion/dotacion_ingreso.asp',
								data: datos,
								type: "GET",
								dataType: "text",
								cache:false,
								//async:true,
								timeout:120000,
								success: function(source){						

									$('#loadIcon').hide();
									doListaDotacion();
								},
								error: function(source){
									alert(source);								
								}
							});
						}
				});
				$('#txtDetalle').keyup(function(){
					$('#caracteres').val(this.value.length);
				});
				});
			</script>
		</div>
    <% end if
	if rsTipo("id_tipo")=4 then 'LICENCIAS MEDICA
	%>
		<div id=tipoDotacion>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr height="20px">
					<td colspan="2" align="left" bgcolor="#F3F3F3"><strong style="font-size:11px">Descripci&oacute;n:</strong> <%response.Write(rsTipo("descripcion"))%></td>
				</tr>
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td width="50%">
                    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">R.U.N</td>
								<td align="left" width="170px"><input name="txtRut" id="txtRut" type="text" maxlength="8" style="width:150px" /></td>
								<td width="10px">-</td>
                                <td align="left"><input name="txtDv" id="txtDv" type="text" maxlength="1" style="width:20px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo R.U.N" data-original-title="Error de validacion R.U.N"/></td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Nombres</td>
								<td align="left" colspan="3"><input name="txtNombres" id="txtNombres" type="text" style="width:200px" maxlength="199" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Nombres" data-original-title="Error de validacion Nombres"/></td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Apellido Paterno</td>
								<td align="left" colspan="3"><input name="txtApep" id="txtApep" type="text" style="width:200px" maxlength="99" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Apellido Paterno" data-original-title="Error de validacion Apellido Paterno"/></td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Apellido Materno</td>
								<td align="left" colspan="3"><input name="txtApem" id="txtApem" type="text" style="width:200px" maxlength="99" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Apellido Paterno" data-original-title="Error de validacion Apellido Materno"/></td>
							</tr>
						</table>
                    </td>
					<td width="50%">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Cargo</td>
								<td align="left"><select name="slcCargo" id="slcCargo" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Cargo" data-original-title="Error de validacion Cargo">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsCargos.EOF %>
                                        <option value="<% response.Write(rsCargos("id_cargo")) %>"><% response.Write(rsCargos("cargo")) %></option>	
                                        <% rsCargos.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Anexo</td>
								<td align="left"><input name="txtAnexo" id="txtAnexo" type="text" style="width:196px" maxlength="19" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Anexo" data-original-title="Error de validacion Anexo"/></td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Zona</td>
								<td align="left"><select name="slcZona" id="slcZona" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Zona" data-original-title="Error de validacion Zona">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsZonas.EOF %>
                                        <option value="<% response.Write(rsZonas("id_zona")) %>"><% response.Write(rsZonas("zona")) %></option>	
                                        <% rsZonas.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Zonal</td>
								<td align="left"><select name="slcZonal" id="slcZonal" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Zonal" data-original-title="Error de validacion Zonal">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsZonales.EOF %>
                                        <option value="<% response.Write(rsZonales("id_zonal")) %>"><% response.Write(rsZonales("zonal")) %></option>	
                                        <% rsZonales.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
                        </table>
                 	</td>
				</tr>
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr> 
                <tr>
					<td colspan="2">
                    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr align="center" valign="top">
								<td>Comentario: <textarea name="txtDetalle" id="txtDetalle" style="width:500px; height:75px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Detalle" data-original-title="Error de validacion Detalle"></textarea><input type="text" name="caracteres" id="caracteres" size=1 style="width:25px" disabled="disabled" ></td>
                            </tr>
						</table>
                    </td>
				</tr> 
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr>
                <tr>
                	<td colspan="2">
                    	<div class="btn btn-success botonEnviaEntrada"><i class="icon-plus-sign-alt icon-large"/><strong> Ingresar</strong></div>
					</td>
                </tr> 
            </table>
             <script type="text/javascript">
			 $(document).ready(function(){
			 	$('.botonEnviaEntrada').click(function(){
					var arrForm = [];
					
					if($('#txtRut').val() == ''){						
						if ($.inArray('#txtDv', arrForm) == -1){
							arrForm.push('#txtDv');								
						}
					}
					if($('#txtDv').val() == ''){						
						if ($.inArray('#txtDv', arrForm) == -1){
							arrForm.push('#txtDv');							
						}
					}						
					if(getDV($('#txtRut').val())!=$('#txtDv').val()){						
						if ($.inArray('#txtDv', arrForm) == -1){
							arrForm.push('#txtDv');							
						}
					}						
					if($('#txtNombres').val() == '')
						arrForm.push('#txtNombres');
					if($('#txtApep').val() == '')
						arrForm.push('#txtApep');
					if($('#txtApem').val() == '')
						arrForm.push('#txtApem');
					if($('#slcCargo').val() == '0')
						arrForm.push('#slcCargo');
					if($('#txtAnexo').val() == '')
						arrForm.push('#txtAnexo');
					if($('#slcZona').val() == '0')
						arrForm.push('#slcZona');
					if($('#slcZonal').val() == '0')
						arrForm.push('#slcZonal');
					if($('#txtDetalle').val() == '')
						arrForm.push('#txtDetalle');
										

					if(arrForm.length > 0){
						var vTime = 0;
						$.each(arrForm, function(index, value){						
							setTimeout(function(){
								$(value).popover('show');
								setTimeout(function(){
									$(value).popover('destroy');	
								}, (vTime-(vTime*0.5)))
							}, vTime);
							vTime = vTime + 1100;
						});	
					}else{
						var rutIngresados = '';
						rutIngresados = $('#arrValidRuts').val();
						if(rutIngresados != ''){
							var arr_rutIngresado = rutIngresados.split(';');
	
							if($.inArray($('#txtRut').val(), arr_rutIngresado) == '-1'){
								$('#loadIcon').show();
								$('#formsIng').fadeOut('slow');								
								//Add new Rut
								var addRut = $('#arrValidRuts').val() + ';' + $('#txtRut').val();
								$('#arrValidRuts').val(addRut);
								
								var datos = '';
								datos += 'q=1&';
								datos += 'tipo=' + $('#tipoDot').val() + '&';
								datos += 'rut=' + $('#txtRut').val() + '&';
								datos += 'dv=' + $('#txtDv').val() + '&';
								datos += 'nombres=' + $('#txtNombres').val() + '&';
								datos += 'apep=' + $('#txtApep').val() + '&';
								datos += 'apem=' + $('#txtApem').val() + '&';
								datos += 'cargo=' + $('#slcCargo').val() + '&';
								datos += 'anexo=' + $('#txtAnexo').val() + '&';
								datos += 'zona=' + $('#slcZona').val() + '&';
								datos += 'zonal=' + $('#slcZonal').val() + '&';
								datos += 'detalle=' + $('#txtDetalle').val();
								datos += '&idSucursal='+$('#idSucursalMain').val();

								
								var  executeIngreso = $.ajax({
									url: 'dotacion/dotacion_ingreso.asp',
									data: datos,
									type: "GET",
									dataType: "text",
									cache:false,
									//async:true,
									timeout:120000,
									success: function(source){						

										$('#loadIcon').hide();
										doListaDotacion();
									},
									error: function(source){
										alert(source);								
									}
								});
							}
							else{
								$('#alertaRut').fadeIn('slow');
								setTimeout(function(){
									$('#alertaRut').fadeOut('slow');		
								},3500);

							}
						}else{
							$('#loadIcon').show();
							$('#formsIng').fadeOut('slow');							
							//Add new Rut							
							$('#arrValidRuts').val($('#txtRut').val());
							
							var datos = '';
							datos += 'q=1&';
							datos += 'tipo=' + $('#tipoDot').val() + '&';
							datos += 'rut=' + $('#txtRut').val() + '&';
							datos += 'dv=' + $('#txtDv').val() + '&';
							datos += 'nombres=' + $('#txtNombres').val() + '&';
							datos += 'apep=' + $('#txtApep').val() + '&';
							datos += 'apem=' + $('#txtApem').val() + '&';
							datos += 'cargo=' + $('#slcCargo').val() + '&';
							datos += 'anexo=' + $('#txtAnexo').val() + '&';
							datos += 'zona=' + $('#slcZona').val() + '&';
							datos += 'zonal=' + $('#slcZonal').val() + '&';
							datos += 'detalle=' + $('#txtDetalle').val();
							datos += '&idSucursal='+$('#idSucursalMain').val();

							
							var  executeIngreso = $.ajax({
								url: 'dotacion/dotacion_ingreso.asp',
								data: datos,
								type: "GET",
								dataType: "text",
								cache:false,
								//async:true,
								timeout:120000,
								success: function(source){						

									$('#loadIcon').hide();
									doListaDotacion();
								},
								error: function(source){
									alert(source);								
								}
							});
						}
					}

				});
				$('#txtDetalle').keyup(function(){
					$('#caracteres').val(this.value.length);
				});
				});
			 </script>
		</div>
    <% end if
	if rsTipo("id_tipo")=5 then 'VACACIONES
	%>
		<div id=tipoDotacion>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr height="20px">
					<td colspan="2" align="left" bgcolor="#F3F3F3"><strong style="font-size:11px">Descripci&oacute;n:</strong> <%response.Write(rsTipo("descripcion"))%></td>
				</tr>
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td width="50%">
                    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">R.U.N</td>
								<td align="left" width="170px"><input name="txtRut" id="txtRut" type="text" maxlength="8" style="width:150px" /></td>
								<td width="10px">-</td>
                                <td align="left"><input name="txtDv" id="txtDv" type="text" maxlength="1" style="width:20px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo R.U.N" data-original-title="Error de validacion R.U.N"/></td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Nombres</td>
								<td align="left" colspan="3"><input name="txtNombres" id="txtNombres" type="text" style="width:200px" maxlength="199" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Nombres" data-original-title="Error de validacion Nombres"/></td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Apellido Paterno</td>
								<td align="left" colspan="3"><input name="txtApep" id="txtApep" type="text" style="width:200px" maxlength="99" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Apellido Paterno" data-original-title="Error de validacion Apellido Paterno"/></td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Apellido Materno</td>
								<td align="left" colspan="3"><input name="txtApem" id="txtApem" type="text" style="width:200px" maxlength="99" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Apellido Paterno" data-original-title="Error de validacion Apellido Materno"/></td>
							</tr>
						</table>
                    </td>
					<td width="50%">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Cargo</td>
								<td align="left"><select name="slcCargo" id="slcCargo" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Cargo" data-original-title="Error de validacion Cargo">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsCargos.EOF %>
                                        <option value="<% response.Write(rsCargos("id_cargo")) %>"><% response.Write(rsCargos("cargo")) %></option>	
                                        <% rsCargos.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Anexo</td>
								<td align="left"><input name="txtAnexo" id="txtAnexo" type="text" style="width:196px" maxlength="19" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Anexo" data-original-title="Error de validacion Anexo"/></td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Zona</td>
								<td align="left"><select name="slcZona" id="slcZona" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Zona" data-original-title="Error de validacion Zona">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsZonas.EOF %>
                                        <option value="<% response.Write(rsZonas("id_zona")) %>"><% response.Write(rsZonas("zona")) %></option>	
                                        <% rsZonas.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Zonal</td>
								<td align="left"><select name="slcZonal" id="slcZonal" style="width:200px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Zonal" data-original-title="Error de validacion Zonal">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsZonales.EOF %>
                                        <option value="<% response.Write(rsZonales("id_zonal")) %>"><% response.Write(rsZonales("zonal")) %></option>	
                                        <% rsZonales.MoveNext
                                        loop %>
                                	</select>
                                </td>
							</tr>
                        </table>
                 	</td>
				</tr>
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr> 
                <tr>
					<td colspan="2">
                    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr align="center" valign="top">
								<td>Comentario: <textarea name="txtDetalle" id="txtDetalle" style="width:500px; height:75px" data-toggle="popover" title="" data-content="Favor ingrese valor correcto para el campo Detalle" data-original-title="Error de validacion Detalle"></textarea><input type="text" name="caracteres" id="caracteres" size=1 style="width:25px" disabled="disabled" ></td>
                            </tr>
						</table>
                    </td>
				</tr> 
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr>
                <tr>
                	<td colspan="2">
                    	<div class="btn btn-success botonEnviaEntrada"><i class="icon-plus-sign-alt icon-large"/><strong> Ingresar</strong></div>
					</td>
                </tr> 
            </table>
             <script type="text/javascript">
			 $(document).ready(function(){
			 	$('.botonEnviaEntrada').click(function(){
					var arrForm = [];

					//alert(getDV($('#txtRut').val())!=$('#txtDv').val());

					if($('#txtRut').val() == ''){						
						if ($.inArray('#txtDv', arrForm) == -1){
							arrForm.push('#txtDv');								
						}
					}

					if($('#txtDv').val() == ''){						
						if ($.inArray('#txtDv', arrForm) == -1){
							arrForm.push('#txtDv');							
						}
					}

					/*if(getDV($('#txtRut').val())!=$('#txtDv').val()){						
						if ($.inArray('#txtDv', arrForm) == -1){
							arrForm.push('#txtDv');							
						}
					}*/

					if($('#txtNombres').val() == '')
						arrForm.push('#txtNombres');
					if($('#txtApep').val() == '')
						arrForm.push('#txtApep');
					if($('#txtApem').val() == '')
						arrForm.push('#txtApem');
					if($('#slcCargo').val() == '0')
						arrForm.push('#slcCargo');
					if($('#txtAnexo').val() == '')
						arrForm.push('#txtAnexo');
					if($('#slcZona').val() == '0')
						arrForm.push('#slcZona');
					if($('#slcZonal').val() == '0')
						arrForm.push('#slcZonal');
					if($('#txtDetalle').val() == '')
						arrForm.push('#txtDetalle');
										

					if(arrForm.length > 0){
						var vTime = 0;
						$.each(arrForm, function(index, value){						
							setTimeout(function(){
								$(value).popover('show');
								setTimeout(function(){
									$(value).popover('destroy');	
								}, (vTime-(vTime*0.5)))
							}, vTime);
							vTime = vTime + 1100;
						});	
					}else{
						var rutIngresados = '';
						rutIngresados = $('#arrValidRuts').val();
						if(rutIngresados != ''){
							var arr_rutIngresado = rutIngresados.split(';');
	
							if($.inArray($('#txtRut').val(), arr_rutIngresado) == '-1'){
								$('#loadIcon').show();
								$('#formsIng').fadeOut('slow');								
								//Add new Rut
								var addRut = $('#arrValidRuts').val() + ';' + $('#txtRut').val();
								$('#arrValidRuts').val(addRut);
								
								var datos = '';
								datos += 'q=1&';
								datos += 'tipo=' + $('#tipoDot').val() + '&';
								datos += 'rut=' + $('#txtRut').val() + '&';
								datos += 'dv=' + $('#txtDv').val() + '&';
								datos += 'nombres=' + $('#txtNombres').val() + '&';
								datos += 'apep=' + $('#txtApep').val() + '&';
								datos += 'apem=' + $('#txtApem').val() + '&';
								datos += 'cargo=' + $('#slcCargo').val() + '&';
								datos += 'anexo=' + $('#txtAnexo').val() + '&';
								datos += 'zona=' + $('#slcZona').val() + '&';
								datos += 'zonal=' + $('#slcZonal').val() + '&';
								datos += 'detalle=' + $('#txtDetalle').val();
								datos += '&idSucursal='+$('#idSucursalMain').val();
							
								var  executeIngreso = $.ajax({
									url: 'dotacion/dotacion_ingreso.asp',
									data: datos,
									type: "GET",
									dataType: "text",
									cache:false,
									//async:true,
									timeout:120000,
									success: function(source){						

										$('#loadIcon').hide();
										doListaDotacion();
									},
									error: function(source){
										alert(source);
									}
								});
							}
							else{
								$('#alertaRut').fadeIn('slow');
								setTimeout(function(){
									$('#alertaRut').fadeOut('slow');		
								},3500);

							}
						}else{
							$('#loadIcon').show();
							$('#formsIng').fadeOut('slow');							
							//Add new Rut							
							$('#arrValidRuts').val($('#txtRut').val());
							
							var datos = '';
							datos += 'q=1&';
							datos += 'tipo=' + $('#tipoDot').val() + '&';
							datos += 'rut=' + $('#txtRut').val() + '&';
							datos += 'dv=' + $('#txtDv').val() + '&';
							datos += 'nombres=' + $('#txtNombres').val() + '&';
							datos += 'apep=' + $('#txtApep').val() + '&';
							datos += 'apem=' + $('#txtApem').val() + '&';
							datos += 'cargo=' + $('#slcCargo').val() + '&';
							datos += 'anexo=' + $('#txtAnexo').val() + '&';
							datos += 'zona=' + $('#slcZona').val() + '&';
							datos += 'zonal=' + $('#slcZonal').val() + '&';
							datos += 'detalle=' + $('#txtDetalle').val();
							datos += '&idSucursal='+$('#idSucursalMain').val();

							
							var  executeIngreso = $.ajax({
								url: 'dotacion/dotacion_ingreso.asp',
								data: datos,
								type: "GET",
								dataType: "text",
								cache:false,
								//async:true,
								timeout:120000,
								success: function(source){						

									$('#loadIcon').hide();
									doListaDotacion();
								},
								error: function(source){
									alert(source);								
								}
							});
						}
					}

				});
				$('#txtDetalle').keyup(function(){
					$('#caracteres').val(this.value.length);
				});
				});
			 </script>
		</div>
    <% end if
else %>
	<div id=tipoDotacion>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
            	<td>Favor seleccionar un Tipo</td>
            </tr>	
		</table>
	</div>
<% 
end if 

rsTipo.Close
set rsTipo.ActiveConnection = nothing
set rsTipo=nothing

rsCargos.Close
set rsCargos.ActiveConnection = nothing
set rsCargos=nothing

rsZonas.Close
set rsZonas.ActiveConnection = nothing
set rsZonas=nothing

rsZonales.Close
set rsZonales.ActiveConnection = nothing
set rsZonales=nothing

DB.Close
set DB=nothing

%>