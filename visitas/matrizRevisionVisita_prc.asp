<!--#include file="../funciones.asp"-->
<%
xml = trim(request("xml"))
idUsuario = trim(request("idUsuario"))

Response.ContentType = "text/xml"
'Response.Write(xml)	

sql = ""
sql = sql & "exec SUC_prc_sucursal_visita_eval_ing " & idUsuario & ", '" & xml & "'"
db.execute(sql)
	
DB.Close
set DB=nothing
%>