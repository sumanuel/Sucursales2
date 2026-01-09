<!--#include file="../funciones2.asp"-->
<%
idSucursalMain = trim(request("idSucursalMain1"))
idUsuarioMain = trim(request("idUsuarioMain1"))
codigo = trim(request("codigo"))
idAccion = trim(request("idAccion"))
'response.write(idAccion)
'response.end
if idAccion = "1" then
	if idUsuarioMain = "" then %>
		No se puede registrar
	<%else
		sql = ""
		sql = sql & "EXEC SCSS_prc_ingresa_caja '"&codigo&"','"&idUsuarioMain&"','"&idSucursalMain&"' "
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
	sql = sql & "execute SCSS_prc_modifica_caja '"&codigoBarras&"','"&idUsuarioMain&"','"&valorEstado&"' "
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
		$('#botonera<%=botonera%>').html('<img src="../cdn/img/loading.gif">');
		setTimeout(function() {
			$('#estadoActual<%=botonera%>').text('<%=nuevoEstado%>');
			<%if valorEstado <> "299"  and valorEstado <> "204" then%>
				$('#botonera<%=botonera%>').html('<span id="btnModifica<%=botonera%>" data-idEstado="<%=valorEstado%>" class="modificaEstado btn btn-mini btn-danger" data-codigoBarras="<%=codigoBarras%>" data-modifica="0" data-porcentaje="<%=enteroPorcentaje%>" onClick="modificaEstado(<%=botonera%>);" data-botonera="<%=botonera%>"><i class="icon-edit icon-large"></span>');
			<%else%>
				$('#botonera<%=botonera%>').html('');
			<%end if%>
		}, 900);
	
	</script>
<%end if
if idAccion = "3" then
	sql = ""
	sql = sql & "execute SCSS_prc_ingresa_caja '"&codigo&"', '"&idUsuarioMain&"', '"&idSucursalMain&"' "
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
