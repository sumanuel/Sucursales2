<!--#include file="../funciones.asp"-->
<%idGestion = trim(request("idGestion"))
valor = trim(request("valor"))
idUsuario = trim(request("idUsuarioMain"))
sql = ""
sql = sql & "update SUC_gest_inc set gest_inc_estado = '"&valor&"',"
sql = sql & " cierra_usuario = '"&idUsuario&"' "
sql = sql & " where id_gest_inc = '"&idGestion&"' "
set rs = db.execute(sql)%>