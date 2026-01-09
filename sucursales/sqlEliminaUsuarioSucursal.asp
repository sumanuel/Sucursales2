<!--#include file="../funciones2.asp"-->
<%idUsuarioSucursal = trim(request("idUsuario"))
esJeps = trim(request("esJeps"))
sql = ""
sql = sql & "execute SUC_prc_usuario_elimina_sucursal '"&idUsuarioSucursal&"', '"&esJeps&"'"
'response.write(sql)
db.execute(sql)
'tiene que existir procedimiento%>