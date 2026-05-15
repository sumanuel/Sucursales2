<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.CodePage = 65001
Response.CharSet = "utf-8"
Response.Expires = -1

Function JsonSafe(valor)
  If IsNull(valor) Then
    valor = ""
  End If
  valor = CStr(valor)
  valor = Replace(valor, "\", "\\")
  valor = Replace(valor, Chr(34), Chr(92) & Chr(34))
  valor = Replace(valor, vbCrLf, " ")
  valor = Replace(valor, vbCr, " ")
  valor = Replace(valor, vbLf, " ")
  JsonSafe = valor
End Function

Sub Responder(resultado, mensaje)
  Response.Write "{""resultado"":""" & JsonSafe(resultado) & """,""mensaje"":""" & JsonSafe(mensaje) & """}"
End Sub

Sub ObtenerUsuarioYPerfil(ByRef usuario, ByRef perfil)
  Dim idUsrWin, usuarios, usuarioWin

  usuario = ""
  perfil = ""

  idUsrWin = Request.ServerVariables("LOGON_USER")
  If idUsrWin <> "" Then
    usuarios = Split(idUsrWin, "\")
    If UBound(usuarios) >= 1 Then
      usuarioWin = usuarios(1)
    Else
      usuarioWin = idUsrWin
    End If
    usuario = Trim(usuarioWin & "")
  End If

  If usuario = "" Then
    If Session("id_usuario") <> "" Then
      usuario = Trim(Session("id_usuario") & "")
    End If
    If usuario = "" And Session("nombre_usuario") <> "" Then
      usuario = Trim(Session("nombre_usuario") & "")
    End If
  End If

  If Session("tipo") <> "" Then
    perfil = Trim(Session("tipo") & "")
  End If

  If usuario = "" Then usuario = "Sistema"
  If perfil = "" Then perfil = "General"
End Sub

Dim usuarioLog, perfilLog, archivoLog, accionLog, sqlLog

archivoLog = Trim(Request("archivo") & "")
Call ObtenerUsuarioYPerfil(usuarioLog, perfilLog)

accionLog = "Subir archivo CSV"
If archivoLog <> "" Then
  accionLog = accionLog & ": " & archivoLog
End If

sqlLog = "EXEC dbo.SCSS_insertar_reporte_log "
sqlLog = sqlLog & "@usuario='" & Replace(usuarioLog, "'", "''") & "', "
sqlLog = sqlLog & "@perfil='" & Replace(perfilLog, "'", "''") & "', "
sqlLog = sqlLog & "@funcionalidad='Gestion de Cajeros a Evaluar', "
sqlLog = sqlLog & "@tipo_accion='" & Replace(accionLog, "'", "''") & "'"

On Error Resume Next
DB.Execute sqlLog
If Err.Number <> 0 Then
  Responder "ERROR", Err.Description
Else
  Responder "OK", "Log registrado correctamente."
End If
%>