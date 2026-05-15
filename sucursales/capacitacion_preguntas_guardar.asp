<%@ Language=VBScript %>
<!--#include file="../conexion/conexion.asp"-->
<%
On Error Resume Next
Response.ContentType = "application/json"
Response.Charset = "UTF-8"

Dim txt_TituloNuevaPregunta, txt_TextoNuevaPregunta, idUsrWin, usuario, perfilLog, usuarios, usuarioWin

txt_TituloNuevaPregunta = Request.Form("txt_TituloNuevaPregunta")
txt_TextoNuevaPregunta = Request.Form("txt_TextoNuevaPregunta")
usuario = Trim(Request.Form("usuario_log") & "")
perfilLog = Trim(Request.Form("perfil_log") & "")

If usuario = "" Then
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
End If

If usuario = "" Then usuario = "SISTEMA"
If perfilLog = "" Then perfilLog = "General"

If txt_TituloNuevaPregunta = "" Or txt_TextoNuevaPregunta = "" Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""Campos requeridos""}"
    Response.End
End If

Dim sql
sql = "EXEC SP_SUC_CAP_INSERT "
sql = sql & "@PRE_TIT='" & Replace(txt_TituloNuevaPregunta, "'", "''") & "',"
sql = sql & "@PRE_PRE='" & Replace(txt_TextoNuevaPregunta, "'", "''") & "',"
sql = sql & "@PRE_USR='" & Replace(usuario, "'", "''") & "',"
sql = sql & "@PRE_PERFIL='" & Replace(perfilLog, "'", "''") & "'"

'response.write "sql:"&sql
'response.End

Dim rs
Set rs = db.Execute(sql)

If Err.Number <> 0 Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & Replace(Replace(Err.Description, """", "\"""), vbCrLf, " ") & """}"
Else
    If Not rs.EOF Then
        If rs("resultado") = "OK" Then
            Response.Write "{""resultado"":""OK"",""id"":" & rs("NewID") & "}"
        Else
            Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & rs("mensaje") & """}"
        End If
    Else
        Response.Write "{""resultado"":""OK""}"
    End If
End If
%>