<!--#include file="../funciones.asp"-->
<%tipo = trim(request("tipo"))
idActivo = trim(request("idActivo"))

sql = ""
sql = sql & " delete from "
if tipo = "1" or tipo = "2" then
	sql = sql& " SUC_activo where id_activo = "&idActivo
end if
if tipo = "3" then
	sql = sql & " SUC_activo_otros where id_activo_otros = "&idActivo
end if
set rs = db.execute(sql)
%>