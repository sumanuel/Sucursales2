<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
idUsuario = trim(request("idUsuario"))
id_gest = trim(request("idTarea"))
tipo = trim(request("tipo"))
hora = trim(request("hora"))
if hora = "" then
	hora = hour(Time())
end if
minutos = trim(request("minutos"))
if minutos = "" then
	minutos = minute(time())
end if
totalHora = hora&":"&minutos
observacion = trim(request("observacion"))
if aplica = "" then aplica = "1"
if tipo = "2" then
	procedimiento = "SUC_prc_gest_doc_op"
end if
if tipo = "3" then
	procedimiento = "SUC_prc_gest_cont_op"
end if
if tipo = "4" then
	procedimiento = "SUC_prc_gest_admin_op"
end if
sql = ""
sql = sql & "execute "&procedimiento&" "&id_gest&", "&idUsuario&", 1 , '"&totalHora&"', '"&observacion&"'"
'response.write(sql)
'response.end
db.execute(sql)
DB.Close
set DB=nothing
response.write(totalHora)%>