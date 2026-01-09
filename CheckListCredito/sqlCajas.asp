<!--#include file="../funciones2.asp"-->
<%
idUsuario = trim(request("IdUsuario"))
if idUsuario = "" then
	idUsuario = trim(request("idUsuarioMain"))
end if
codigo = trim(request("codigo"))
idAccion = trim(request("idAccion"))
idSucursalMain = trim(request("idAccion"))

if idAccion = "1" then
	if idUsuario = "" then %>
		No se puede registrar
	<%else
		sql = ""
		sql = sql & "execute SCSS_prc_ingresa_caja '"&codigo&"', '"&idUsuario&"', '"&idSucursalMain&"' "
		'response.write (sql)
		'response.end
		set rs = db.execute(sql)
		if not rs.eof then
			codigoMensaje = trim(rs(0))
			mensaje = trim(rs(1))
		end if
		codigoMensaje = "0"
		if codigoMensaje = "0" then
			response.write("")
		end if
	end if
end if
if idAccion = "2" then
	codigoBarras = trim(request("codigoBarras"))
	valorEstado = trim(request("valorEstado"))
	botonera = trim(request("botonera"))	
 	'response.write(fechaEnvio)
 	'response.end 	
	if valorEstado = "204" then
		fechaEnvio = trim(request("fechaEnvio"))
		fechaEnvio  = cdate(fechaEnvio)
   		mesFecha = formateaParaFecha(month(fechaEnvio))
   		diaFecha = formateaParaFecha(day(fechaEnvio))
   		anioFecha = year(fechaEnvio)
 		fechaEnvio = anioFecha&"/"&mesFecha&"/"&diaFecha
 		obsCaja = trim(request("obsCaja"))
 		
		sql = ""
		sql = sql & "execute SCSS_prc_modifica_caja_envio '"&codigoBarras&"','"&idUsuario&"','"&valorEstado&"','"&fechaEnvio&"','"&obsCaja&"' "
		db.execute(sql)
	else
		sql = ""
		sql = sql & "execute SCSS_prc_modifica_caja '"&codigoBarras&"','"&idUsuario&"','"&valorEstado&"' "	
		db.execute(sql)		
	end if
	sql = ""
	sql = sql & " select id_estado, "
	sql = sql & " descrip_estado "
	sql = sql & " from SUC_vcc_estados " 
	sql = sql & " where id_estado = '"&valorEstado&"' "
	set rs = db.execute(sql)
	if not rs.eof then
		nuevoEstado = trim(server.htmlencode(rs(1)))
	end if%>
	<script type="text/javascript">		
		$('#botonera<%=botonera%>').html('<img src="../cdn/img/loader.gif">');
		setTimeout(function() {
			$('#estadoActual<%=botonera%>').text('<%=nuevoEstado%>');
			<%if valorEstado <> "299"  and valorEstado <> "204" then%>
				$('#botonera<%=botonera%>').html('<span id="btnModifica<%=botonera%>" data-idEstado="<%=valorEstado%>" class="modificaEstado btn btn-mini btn-danger" data-codigoBarras="<%=codigoBarras%>" data-modifica="0" data-porcentaje="<%=enteroPorcentaje%>" onClick="modificaEstado(<%=botonera%>);" data-botonera="<%=botonera%>">Modificar Estado</span>');
			<%else%>
				$('#botonera<%=botonera%>').html('');
			<%end if%>
		}, 900);
	
	</script>
<%end if
if idAccion = "3" then
	sql = ""
	sql = sql & "execute SCSS_prc_ingresa_caja '"&codigo&"', '"&idUsuario&"', '"&idSucursalMain&"' "
	'response.write (sql)
	'response.end
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
