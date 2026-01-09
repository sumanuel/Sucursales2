<!--#include file="../funciones2.asp"-->
<%idChecklist = trim(request("idChecklist"))
checkOk = trim(request("checkOk"))
idUsuario = trim(request("idUsuario"))
idCarpeta = trim(request("idCarpeta"))
tipoDoc = trim(request("tipoDoc"))
sql = ""
sql = sql & " execute SCSS_prc__modifica_checkOK_checklist "
sql = sql & " '"&idChecklist&"', "
sql = sql & " '"&idCarpeta&"', "
sql = sql & " '"&tipoDoc&"', "
sql = sql & " '"&checkOk&"', "
sql = sql & " '"&idUsuario&"' "
db.execute(sql)%>