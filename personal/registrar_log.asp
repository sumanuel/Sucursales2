<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones.asp"-->
<%
Response.ContentType = "application/json"

dim usuarioLog, perfilLog, funcionalidad, tipoAccion
dim idUsrWin, usuarios, usuarioWin, dominio

'Obtener parámetros de la petición
funcionalidad = trim(request("funcionalidad"))
tipoAccion = trim(request("tipo_accion"))

'Obtener usuario de Windows (LOGON_USER)
idUsrWin = request.servervariables("LOGON_USER")
if idUsrWin <> "" then
usuarios = split(idUsrWin, "\")
if UBound(usuarios) >= 1 then
usuarioWin = usuarios(1)
dominio = usuarios(0)
else
usuarioWin = idUsrWin
dominio = ""
end if
usuarioLog = usuarioWin
else
usuarioLog = ""
end if

'Si no se obtuvo de LOGON_USER, intentar de la sesión
if usuarioLog = "" then
if Session("id_usuario") <> "" then
usuarioLog = Session("id_usuario")
end if

if usuarioLog = "" and Session("nombre_usuario") <> "" then
usuarioLog = Session("nombre_usuario")
end if
end if

'Obtener perfil de la sesión
if Session("tipo") <> "" then
perfilLog = Session("tipo")
else
perfilLog = ""
end if

'Si no hay perfil y tenemos usuario, consultar en BD
if perfilLog = "" and usuarioLog <> "" then
on error resume next
dim rsPerfil, sqlPerfil
sqlPerfil = "SELECT TOP 1 tipo FROM SCSS_usuarios WHERE usuario = '" & Replace(usuarioLog, "'", "''") & "'"
set rsPerfil = DB.execute(sqlPerfil)
if not rsPerfil.EOF then
perfilLog = rsPerfil("tipo")
end if
rsPerfil.Close
set rsPerfil = nothing
on error goto 0
end if

'Valores por defecto si aún no hay datos
if usuarioLog = "" then
usuarioLog = "Sistema"
end if

if perfilLog = "" then
perfilLog = "General"
end if

'Validar y registrar
if funcionalidad <> "" and tipoAccion <> "" then
call registrarLog(usuarioLog, perfilLog, funcionalidad, tipoAccion)
Response.Write("{""status"":""ok"",""message"":""Log registrado"",""usuario"":""" & usuarioLog & """,""perfil"":""" & perfilLog & """}")
else
Response.Write("{""status"":""error"",""message"":""Faltan parametros"",""funcionalidad"":""" & funcionalidad & """,""tipo_accion"":""" & tipoAccion & """}")
end if
%>