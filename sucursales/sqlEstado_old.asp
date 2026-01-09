<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
estado = trim(request("valor"))
sql = ""
sql = sql & "exec SUC_prc_desborde_ing '"&idSucursal&"', '"&estado&"'"
db.execute(sql)
DB.Close
set DB=nothing%>