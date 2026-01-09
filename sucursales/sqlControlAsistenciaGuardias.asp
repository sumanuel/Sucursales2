<!--#include file="../funciones.asp"-->
<%
idSucursal = trim(request("idSucursal"))
xml = trim(request("xml"))
idUsuario = 1

Response.ContentType = "application/xml"
Response.Write(xml)

sql = ""
sql = sql & "exec SUC_prc_sucursal_asist_guardias '"&idUsuario&"', '"&xml&"'"
db.execute(sql)
DB.Close
set DB=nothing
%>