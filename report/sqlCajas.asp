<!--#include file="../funciones2.asp"-->
<%
codigo = trim(request("codigo"))
enteroPorcentaje = trim(request("porcentaje"))
idAccion = trim(request("idAccion"))
idSucursalMain = trim(request("idSucursalMain"))
idUsuarioMain = trim(request("idUsuarioMain1"))
if idAccion = "2" then
	codigoBarras = trim(request("codigoBarras"))
	valorEstado = trim(request("valorEstado"))
	botonera = trim(request("botonera"))
	if valorEstado = "204" then
		idUsuarioMain = trim(request("idUsuarioMain1"))
		fechaEnvio = trim(request("fechaEnvio"))
		fechaEnvio  = cdate(fechaEnvio)
   		mesFecha = formateaParaFecha(month(fechaEnvio))
   		diaFecha = formateaParaFecha(day(fechaEnvio))
   		anioFecha = year(fechaEnvio)
 		fechaEnvio = anioFecha&"/"&mesFecha&"/"&diaFecha
 		obsCaja = trim(request("obsCaja"))
		sql = ""
		sql = sql & " EXEC SCSS_prc_modifica_caja_envio '"&codigoBarras&"','"&idUsuarioMain&"','"&valorEstado&"','"&fechaEnvio&"','"&obsCaja&"' "
		'response.write(sql)
		'response.end
		db.execute(sql)
	else
		sql = ""
		sql = sql & " EXEC SCSS_prc_modifica_caja '"&codigoBarras&"','"&idUsuarioMain&"','"&valorEstado&"' "	
		db.execute(sql)		
	end if
	sql = ""
	sql = sql & " SELECT id_estado, "
	sql = sql & " descrip_estado "
	sql = sql & " FROM SUC_vcc_estados " 
	sql = sql & " WHERE id_estado = '"&valorEstado&"' "
	set rs = db.execute(sql)	
	if not rs.eof then
		nuevoEstado = trim(server.htmlencode(rs(1)))
	end if%>
	<script type="text/javascript">		
		$('#botonera<%=botonera%>').html('<img src="../cdn/img/loading.gif">');
		setTimeout(function() {
			$('#estadoActual<%=botonera%>').text('<%=nuevoEstado%>');
			<%if valorEstado <> "299" and valorEstado <> "204" then%>
				<%if valorEstado = "202" then%>	
					$('#botonera<%=botonera%>').html('<span id="btnModifica<%=botonera%>" data-idEstado="<%=valorEstado%>" class="modificaEstado btn btn-mini btn-info" data-codigoBarras="<%=codigoBarras%>" data-modifica="0" data-porcentaje="<%=enteroPorcentaje%>" onClick="modificaEstado(<%=botonera%>);" data-botonera="<%=botonera%>"><i class="icon-edit icon-large"></i></span> <span id="listaContenido" class="btn btn-success btn-mini" data-codigoBarras="<%=codigoBarras%>" onClick="listaContenido(<%=codigoBarras%>)"><i class="icon-eye-open icon-large"></i></span>');
				<%else%>
					$('#botonera<%=botonera%>').html('<span id="btnModifica<%=botonera%>" data-idEstado="<%=valorEstado%>" class="modificaEstado btn btn-mini btn-info" data-codigoBarras="<%=codigoBarras%>" data-modifica="0" data-porcentaje="<%=enteroPorcentaje%>" onClick="modificaEstado(<%=botonera%>);" data-botonera="<%=botonera%>"><i class="icon-edit icon-large"></i></span> <span id="listaContenido" class="btn btn-success btn-mini" data-codigoBarras="<%=codigoBarras%>" onClick="listaContenido(<%=codigoBarras%>)"><i class="icon-eye-open icon-large"></i></span>');
				<%end if%>
			<%else%>
				$('#botonera<%=botonera%>').html('');
			<%end if%>
			
		}, 900);
	</script>
<%end if
if idAccion = "3" then
	sql = ""
	sql = sql & "execute SCSS_prc_ingresa_caja '"&codigo&"','"&idUsuarioMain&"','"&idSucursalMain&"' "
	set rs = db.execute(sql)
	if not rs.eof then
		codigoMensaje = trim(rs(0))
		mensaje = trim(rs(1))
	end if
	codigoMensaje = "0"
	if codigoMensaje = "0" then
		response.write("")
	end if
end if%>
