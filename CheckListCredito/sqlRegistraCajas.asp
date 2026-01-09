<!--#include file="../funciones2.asp"-->
<%
idSucursal = trim(request("idSucursal"))
idUsuario = trim(request("IdUsuario"))
codigo = trim(request("codigo"))
idAccion = trim(request("idAccion"))

if idAccion = "1" then
	if idUsuario = "" then %>
		No se puede registrar
	<%else
		sql = ""
		sql = sql & "execute SCSS_prc_ingresa_caja '"&codigo&"', '"&idUsuario&"', '"&idSucursal&"' "
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
	sql = ""
	sql = sql & "execute SCSS_prc_modifica_caja '"&codigoBarras&"','"&idUsuario&"','"&valorEstado&"' "
	'response.write(sql)
	'response.end
	db.execute(sql)
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
	sql = sql & "execute SCSS_prc_ingresa_caja '"&codigo&"', '"&idUsuario&"', '"&idSucursal&"' "
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
