<!--#include file="../funciones.asp"-->
<%
idSucursal = trim(request("idSucursal"))
idUsuario = trim(request("idUsuario"))
xml = trim(request("xml"))
'idUsuario = 1

Response.ContentType = "application/xml"
Response.Write(xml)

sql = ""
sql = sql & "exec SUC_prc_sucursal_asist_personal '"&idUsuario&"', '"&xml&"'"
'response.Write(sql)
'response.end
db.execute(sql)

'Response.Write(sql)

DB.Close
set DB=nothing
%>