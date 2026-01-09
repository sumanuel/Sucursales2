<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
idPerfil = trim(request("perfilMain"))

if idPerfil = "1" or idSucursal = "0" then idSucursal = trim(request("idSucursalMain")) 
sql= ""
sql = sql & "exec SUC_prc_sucursal_apertura_ing '"&idSucursal&"', 1 "
'response.write(sql)
'response.end
set rs = db.execute(sql)
%>
