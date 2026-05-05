<%@ Language=VBScript %>
<!--#include file="../conexion/conexion.asp"-->
<%
On Error Resume Next
Response.ContentType = "application/json"
Response.Charset = "UTF-8"

Dim txt_TituloNuevaPregunta, txt_TextoNuevaPregunta, idUsrWin

txt_TituloNuevaPregunta = Request.Form("txt_TituloNuevaPregunta")
txt_TextoNuevaPregunta = Request.Form("txt_TextoNuevaPregunta")
idUsrWin = Request.ServerVariables("LOGON_USER")

If InStr(idUsrWin, "\") > 0 Then
    usuario = Mid(idUsrWin, InStr(idUsrWin, "\") + 1)
Else
    usuario = "SISTEMA"
End If

If txt_TituloNuevaPregunta = "" Or txt_TextoNuevaPregunta = "" Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""Campos requeridos""}"
    Response.End
End If

Dim sql
sql = "EXEC SP_SUC_CAP_INSERT "
sql = sql & "@PRE_TIT='" & Replace(txt_TituloNuevaPregunta, "'", "''") & "',"
sql = sql & "@PRE_PRE='" & Replace(txt_TextoNuevaPregunta, "'", "''") & "',"
sql = sql & "@PRE_USR='" & Replace(usuario, "'", "''") & "'"

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