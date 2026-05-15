<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json; charset=utf-8"
Response.CodePage = 65001
Response.CharSet = "utf-8"

Sub ObtenerUsuarioYPerfil(ByRef usuarioLog, ByRef perfilLog)
	Dim idUsrWin, usuarios, usuarioWin

	usuarioLog = Trim(Request("usuario_log") & "")
	perfilLog = Trim(Request("perfil_log") & "")

	If usuarioLog = "" Then
		idUsrWin = Request.ServerVariables("LOGON_USER")
		If idUsrWin <> "" Then
			usuarios = Split(idUsrWin, "\")
			If UBound(usuarios) >= 1 Then
				usuarioWin = usuarios(1)
			Else
				usuarioWin = idUsrWin
			End If
			usuarioLog = Trim(usuarioWin & "")
		End If
	End If

	If usuarioLog = "" Then
		If Session("id_usuario") <> "" Then
			usuarioLog = Trim(Session("id_usuario") & "")
		End If
		If usuarioLog = "" And Session("nombre_usuario") <> "" Then
			usuarioLog = Trim(Session("nombre_usuario") & "")
		End If
	End If

	If perfilLog = "" And Session("tipo") <> "" Then
		perfilLog = Trim(Session("tipo") & "")
	End If

	If usuarioLog = "" Then usuarioLog = "Sistema"
	If perfilLog = "" Then perfilLog = "General"
End Sub

' Parámetros de paginación
Dim id, usuarioLog, perfilLog
id = Request("id")
Call ObtenerUsuarioYPerfil(usuarioLog, perfilLog)

' Consulta con paginación
Dim sql, rs

sql = "EXEC SP_SUC_CAP_SWAP " & id & ", '" & Replace(usuarioLog, "'", "''") & "', '" & Replace(perfilLog, "'", "''") & "'"

Set rs = DB.execute(sql)

Dim json, first
json = "{"
json = json & """status"": """ & rs("RESULTADO") & """"
json = json & "}"

rs.Close
Set rs = Nothing
DB.Close
Set DB = Nothing

Response.Write json

%>
