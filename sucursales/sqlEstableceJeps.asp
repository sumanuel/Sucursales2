<!--#include file="../funciones2.asp"-->
<%idUsuario = trim(request("idUsuario"))
sql = sql & "execute SUC_prc_usuario_adjunta_sucursal '"&idUsuario&"'"
'response.write(sql)
db.execute(sql)%>