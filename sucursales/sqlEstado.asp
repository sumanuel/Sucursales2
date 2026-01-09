<!--#include file="../funciones.asp"-->
<%
idUsuario = trim(request("idUsuarioMain"))
idSucursal = trim(request("idSucursalMain"))
estado = trim(request("valor"))
tipo = trim(request("confirma"))
idUsrWin = request.servervariables("LOGON_USER")
usuarios = split(idUsrWin,"\")
usuarioWin = usuarios(1)
dominio = usuarios(0)

sql = ""
sql = sql & "exec SUC_prc_desborde_ing "
sql = sql & "'"&idSucursal&"', '"&estado&"', "& idUsuario &", '"& usuarioWin &"', '"& dominio &"', '"& tipo &"'"
db.execute(sql)%>