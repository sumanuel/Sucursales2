<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% tipo=request.QueryString("dato")  
'response.Write(tipo)
'response.End()

%><!--#include file="conex.asp"--><%

set rsTipo = server.createObject("ADODB.Recordset")
tipo ="select * from dbo.DOTA_tipos where id_tipo="&tipo&" and est_reg=1"
conex.execute(tipo)
rsTipo.open tipo, conex

set rsCargos = server.createObject("ADODB.Recordset")
cargos ="select * from dbo.DOTA_cargos where est_reg=1"
conex.execute(cargos)
rsCargos.open cargos, conex

set rsZonas = server.createObject("ADODB.Recordset")
zonas ="select * from dbo.DOTA_zonas where est_reg=1"
conex.execute(zonas)
rsZonas.open zonas, conex

set rsZonales = server.createObject("ADODB.Recordset")
zonales ="select * from dbo.DOTA_zonales where est_reg=1"
conex.execute(zonales)
rsZonales.open zonales, conex

set rsSucursales = server.createObject("ADODB.Recordset")
sucursales ="select bt_sucursal,nombre_sucursal from sucursales.dbo.sucursales order by nombre_sucursal"
conex.execute(sucursales)
rsSucursales.open sucursales, conex

if NOT rsTipo.EOF then 
	if rsTipo("id_tipo")=1 then %>
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
								<td align="left" width="170px"><input name="txtRut" type="text" maxlength="8" style="width:150px" onkeypress="return validarSoloNumeros(event)"/></td>
								<td width="10px">-</td>
                                <td align="left"><input name="txtDv" type="text" maxlength="1" style="width:20px" onkeypress="return validarDvRut(event)"/></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Nombres</td>
								<td align="left" colspan="3"><input name="txtNombres" type="text" style="width:200px" maxlength="199" onkeypress="return validarCaracteres(event)" /></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Apellido Paterno</td>
								<td align="left" colspan="3"><input name="txtApep" type="text" style="width:200px" maxlength="99" /></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Apellido Materno</td>
								<td align="left" colspan="3"><input name="txtApem" type="text" style="width:200px" maxlength="99" /></td>
							</tr>
						</table>
					</td>
					<td width="50%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="100px">&nbsp;</td>
                                <td width="100px" align="left">Cargo</td>
								<td align="left"><select name="slcCargo" style="width:200px">
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
								<td align="left"><input name="txtAnexo" type="text" style="width:196px" maxlength="19" onkeypress="return validarSoloNumeros(event)"/></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Zona</td>
								<td align="left"><select name="slcZona" style="width:200px">
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
								<td align="left"><select name="slcZonal" style="width:200px">
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
                    	<input name="btnEnviar" type="submit" value="Ingresar" />
					</td>
                </tr>
            </table>
		</div>
	<% end if
	if rsTipo("id_tipo")=2 then %>
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
								<td align="left" width="170px"><input name="txtRut" type="text" maxlength="8" style="width:150px" onkeypress="return validarSoloNumeros(event)" /></td>
								<td width="10px">-</td>
                                <td align="left"><input name="txtDv" type="text" maxlength="1" style="width:20px" onkeypress="return validarDvRut(event)"/></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Nombres</td>
								<td align="left" colspan="3"><input name="txtNombres" type="text" style="width:200px" maxlength="199" /></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Apellido Paterno</td>
								<td align="left" colspan="32"><input name="txtApep" type="text" style="width:200px" maxlength="99" /></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Apellido Materno</td>
								<td align="left" colspan="3"><input name="txtApem" type="text" style="width:200px" maxlength="99" /></td>
							</tr>
						</table>
					</td>
					<td width="50%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left" width="100px">Cargo</td>
								<td align="left"><select name="slcCargo" style="width:200px">
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
								<td align="left"><input name="txtAnexo" type="text" style="width:196px" maxlength="19" onkeypress="return validarSoloNumeros(event)" /></td>
							</tr>
							<tr>
								<td width="100px">&nbsp;</td>
                                <td align="left">Zona</td>
								<td align="left"><select name="slcZona" style="width:200px">
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
								<td align="left"><select name="slcZonal" style="width:200px">
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
								<td align="left"><select name="slcSucursal" style="width:200px">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsSucursales.EOF %>
                                        <option value="<% response.Write(rsSucursales("bt_sucursal")) %>"><% response.Write(rsSucursales("nombre_sucursal")) %></option>	
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
								<td>Comentario: <textarea name="txtDetalle" style="width:500px; height:75px" onKeyDown="validaDetalle('499')" onKeyUp="validaDetalle('499')" ></textarea><input type="text" name="caracteres" size=1 style="width:25px" disabled="disabled" ></td>
                            </tr>
						</table>
                    </td>
				</tr>
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr>
                <tr>
                	<td colspan="2">
                    	<input name="btnEnviar" type="submit" value="Ingresar" />
					</td>
                </tr> 
            </table>
		</div>
    <% end if
	if rsTipo("id_tipo")=3 then %>
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
								<td align="left"><select name="slcCargo" style="width:200px">
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
                                <td><textarea name="txtDetalle" style="width:400px; height:75px" onKeyDown="validaDetalle('499')" onKeyUp="validaDetalle('499')" ></textarea><input type="text" name="caracteres" size=1 style="width:25px" disabled="disabled" ></td>
                            </tr>
						</table>
                    </td>
				</tr>
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr>
                <tr>
                	<td colspan="2">
                    	<input name="btnEnviar" type="submit" value="Ingresar" />
					</td>
                </tr>  
            </table>
		</div>
    <% end if
	if rsTipo("id_tipo")=4 then %>
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
								<td align="left" width="170px"><input name="txtRut" type="text" maxlength="8" style="width:150px" onkeypress="return validarSoloNumeros(event)" /></td>
								<td width="10px">-</td>
                                <td align="left"><input name="txtDv" type="text" maxlength="1" style="width:20px" onkeypress="return validarDvRut(event)" /></td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Nombres</td>
								<td align="left" colspan="3"><input name="txtNombres" type="text" style="width:200px" maxlength="199" /></td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Apellido Paterno</td>
								<td align="left" colspan="3"><input name="txtApep" type="text" style="width:200px" maxlength="99" /></td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Apellido Materno</td>
								<td align="left" colspan="3"><input name="txtApem" type="text" style="width:200px" maxlength="99" /></td>
							</tr>
						</table>
                    </td>
					<td width="50%">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Cargo</td>
								<td align="left"><select name="slcCargo" style="width:200px">
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
								<td align="left"><input name="txtAnexo" type="text" style="width:196px" maxlength="19" onkeypress="return validarSoloNumeros(event)" /></td>
							</tr>
							<tr>
								<td align="left" width="100px">&nbsp;</td>
                                <td align="left" width="100px">Zona</td>
								<td align="left"><select name="slcZona" style="width:200px">
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
								<td align="left"><select name="slcZonal" style="width:200px">
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
								<td>Comentario: <textarea name="txtDetalle" style="width:500px; height:75px" onKeyDown="validaDetalle('499')" onKeyUp="validaDetalle('499')" ></textarea><input type="text" name="caracteres" size=1 style="width:25px" disabled="disabled" ></td>
                            </tr>
						</table>
                    </td>
				</tr> 
                <tr>
					<td colspan="2">&nbsp;</td>
				</tr>
                <tr>
                	<td colspan="2">
                    	<input name="btnEnviar" type="submit" value="Ingresar" />
					</td>
                </tr> 
            </table>
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
<% end if %>








