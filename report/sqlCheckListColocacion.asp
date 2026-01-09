<!--#include file="../funciones2.asp"-->
<%idChecklist = trim(request("idChecklist"))
idCarpeta = trim(request("idCarpeta"))
tipoDoc = trim(request("tipoDoc"))
checkOk = trim(request("checkOk"))
idUsuarioMain = trim(request("idUsuarioMain1"))
'response.write(idUsuarioMain)
'response.end
sql = ""
sql = sql & " EXEC SCSS_prc__modifica_checkOK_checklist "
sql = sql & " '"&idChecklist&"', "
sql = sql & " '"&idCarpeta&"', "
'sql = sql & " '"&tipoDoc&"', "
sql = sql & " '"&checkOk&"', "
sql = sql & " '"&idUsuarioMain&"' "
'response.write(sql)
db.execute(sql)%>
