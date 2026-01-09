<!--#include file="../funciones.asp"-->
<%tipo = trim(request("tipo"))

if tipo = 1 then
	reclamo_valido = trim(request("reclamo_valido"))
	idCaso = trim(request("idCaso"))


	sql = ""
	sql = sql + "update suc_casos set reclamo_valido = " + reclamo_valido + " where id_caso = " + idCaso

	db.execute(sql)
end if

%>