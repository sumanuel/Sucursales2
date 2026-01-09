<!--#include file="../funciones.asp"-->
<%
idSucursal = trim(request("idSucursal"))
idUsuario = trim(request("idUsuario"))
xml = trim(request("xml2"))
'idUsuario = 1

'Response.ContentType = "application/xml"
'Response.Write(xml)

sql = ""
sql = sql & "EXEC SUC_prc_sucursal_asist_personal_reg_cuenta '"&idUsuario&"', '"&xml&"','"&idSucursal&"'"
db.execute(sql)


DB.Close
set DB=nothing
%>