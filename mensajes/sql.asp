<!--#include file="../funciones.asp"-->
<%
strData=request(trim("idUsuarioDestino"))
mensajeTipo = trim(request("mensajeTipo"))
asunto = server.htmlencode(trim(request("asuntoMensaje")))
mensaje = server.htmlencode(trim(request("mensaje")))
idUsuario = trim(request("idUsuario"))

generaXml = ""
generaXml = generaXml& "<root>"
generaXml = generaXml& "<msg>"
generaXml = generaXml& "<sb>"
generaXml = generaXml& asunto
generaXml = generaXml& "</sb>"
generaXml = generaXml& "<body>"
generaXml = generaXml& mensaje
generaXml = generaXml& "</body>"
generaXml = generaXml& "<tipo>"
generaXml = generaXml& mensajeTipo
generaXml = generaXml& "</tipo>"
generaXml = generaXml& "</msg>"
generaXml = generaXml& "<destino>"
'response.write(generaXml)
if mensajeTipo = "1" then 'operaciones a sucursal'
	if strData = "todos" then
		sql = ""
		sql = sql& "select id_sucursal from suc_sucursal "
		set rs = db.execute(sql)
		if not rs.eof then
			do while not rs.eof 
				generaXml = generaXml&"<d>"&trim(rs("id_sucursal"))&"</d>"
				rs.movenext
			loop
		end if
	else
		strArr=split(strData,",")
		for x=0 to ubound(strArr)
			idDestinatario = strArr(x)
			generaXml = generaXml&"<d>"&idDestinatario&"</d>"
		next
	end if
end if
if mensajeTipo = "2" then 'operaciones a zonal'
	if strData = "todos" then
		sql = ""
		sql = sql& "select id_sucursal from suc_sucursal "
		set rs = db.execute(sql)
		if not rs.eof then
			do while not rs.eof 
				generaXml = generaXml&"<d>"&trim(rs("id_sucursal"))&"</d>"
				rs.movenext
			loop
		end if
	else
		strArr=split(strData,",")
		for x=0 to ubound(strArr)
			idDestinatario = strArr(x)
			generaXml = generaXml&"<d>"&idDestinatario&"</d>"
		next
	end if
end if
if mensajeTipo = "3" then 'operaciones a sucursal'
	generaXml = generaXml&"<d></d>"
end if
if mensajeTipo = "4" then 'operaciones a sucursal'
	if strData = "todos" then
		sql = ""
		sql = sql & " select id_sucursal,"
		sql = sql & " suc_nombre "
		sql = sql & " from suc_sucursal "
		sql = sql & " where id_sucursal in "
		sql = sql & " (select id_sucursal "
		sql = sql & " from SUC_usuario_sucursal "
		sql = sql & " where id_usuario = '"&idUsuario&"')"
		set rs = db.execute(sql)
		if not rs.eof then
			do while not rs.eof 
				generaXml = generaXml&"<d>"&trim(rs("id_sucursal"))&"</d>"
				rs.movenext
			loop
		end if
	else
		strArr=split(strData,",")
		for x=0 to ubound(strArr)
			idDestinatario = strArr(x)
			generaXml = generaXml&"<d>"&idDestinatario&"</d>"
		next
	end if
end if
if mensajeTipo = "5" then 'operaciones a sucursal'
	generaXml = generaXml&"<d></d>"
end if
if mensajeTipo = "6" then 'jeps a zonal'
	generaXml = generaXml&"<d>"&strData&"</d>"
end if

generaXml = generaXml& "</destino>"
generaXml = generaXml& "</root>"
'response.write(generaXml)
sql = ""
sql = sql & "exec SUC_prc_msg_ing "&idUsuario&", N'"&generaXml&"'"
'response.write(sql)
db.execute(sql)
'DB.Close
'set DB=nothing%>