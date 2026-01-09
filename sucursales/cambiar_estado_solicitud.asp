<%@ Language=VBScript CODEPAGE="65001" %>
<!--#include file="../conexion/conexion.asp"-->
<%
On Error Resume Next
Response.ContentType = "application/json"
Response.Charset = "UTF-8"

Dim id_solicitud, id_estado_nuevo, comentario, usuario

id_solicitud = Request.Form("id_solicitud")
id_estado_nuevo = Request.Form("id_estado_nuevo")
comentario = Request.Form("comentario")

' Obtener usuario del sistema
Dim idUsrWin
idUsrWin = Request.ServerVariables("LOGON_USER")
If InStr(idUsrWin, "\") > 0 Then
    usuario = Mid(idUsrWin, InStr(idUsrWin, "\") + 1)
Else
    usuario = "SISTEMA"
End If

' Validar parámetros requeridos
If id_solicitud = "" Or id_estado_nuevo = "" Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""Parámetros requeridos faltantes""}"
    Response.End
End If

' Construir SQL
Dim sql
sql = "EXEC SP_SUC_cambiar_estado_solicitud "
sql = sql & "@id_solicitud=" & id_solicitud & ","
sql = sql & "@id_estado_nuevo=" & id_estado_nuevo & ","

If comentario <> "" Then
    sql = sql & "@comentario='" & Replace(comentario, "'", "''") & "',"
Else
    sql = sql & "@comentario=NULL,"
End If

sql = sql & "@usuario='" & Replace(usuario, "'", "''") & "'"

' Ejecutar procedimiento
Dim rs
Set rs = db.Execute(sql)

If Err.Number <> 0 Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & Replace(Replace(Err.Description, """", "\"""), vbCrLf, " ") & """}"
Else
    If Not rs.EOF Then
        Response.Write "{""resultado"":""" & rs("resultado") & """,""mensaje"":""" & Replace(rs("mensaje"), """", "\""") & """}"
    Else
        Response.Write "{""resultado"":""ERROR"",""mensaje"":""No se recibió respuesta del servidor""}"
    End If
End If

rs.Close
Set rs = Nothing
%>
