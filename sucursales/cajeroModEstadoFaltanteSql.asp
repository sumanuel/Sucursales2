<!--#include file="../funciones.asp"-->
<%
	perfil = trim(request("idPerfil"))
	idUsuario = trim(request("idUsuario"))
	idSucursal = trim(request("idSucursal"))
	periodo = trim(request("periodo"))
	idFaltanteModEstado = trim(request("idFaltanteModEstado"))
	textValija = trim(request("textValija"))
	estadoFaltante = trim(request("estadoFaltante"))
	sql = ""
	sql = sql & " EXEC SUC_prc_sucursal_mod_faltante '"&idFaltanteModEstado&"','"&textValija&"','"&estadoFaltante&"' "
	db.execute(sql)
%>
