<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
periodo = trim(request("periodo"))
action = trim(request("action"))

sql = ""
sql = sql & " EXEC SCSS_prc_cajeros_ingresa_nuevo_periodo_dim  '"&action&"','"&periodo&"','"&idUsuario&"' "
db.execute(sql)
%>
