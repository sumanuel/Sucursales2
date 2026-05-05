<%@ Language=VBScript %>
<%
Response.ContentType = "application/json"
Response.Charset = "utf-8"
%>
<!--#include file="../conexion/conexion.asp"-->
<%
On Error Resume Next
Dim id, usuario, logon_user
Dim cmd, rs, resultado_sp, mensaje_sp, idRetornado

id = Request.Form("id")
If id = "" Then id = Request.Form("id_eva")

If id = "" Or Not IsNumeric(id) Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""ID requerido""}"
    Response.End
End If

logon_user = Request.ServerVariables("LOGON_USER")
If InStr(logon_user, "\") > 0 Then
    usuario = Mid(logon_user, InStr(logon_user, "\") + 1)
Else
    usuario = logon_user
End If
If usuario = "" Then usuario = "sistema"

Set cmd = Server.CreateObject("ADODB.Command")
cmd.ActiveConnection = db
cmd.CommandType = 4
cmd.CommandText = "SP_SUC_eliminar_eva_cajero"
cmd.Parameters.Append cmd.CreateParameter("@ID_EVA", 3, 1, , CInt(id))
cmd.Parameters.Append cmd.CreateParameter("@EVA_USR", 200, 1, 50, usuario)

Set rs = cmd.Execute
If Err.Number <> 0 Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & Replace(Err.Description, """", "'") & """}"
Else
    If Not rs.EOF Then
        resultado_sp = rs("resultado")
        mensaje_sp = rs("mensaje")
        If resultado_sp = "OK" Then
            idRetornado = rs("id_eva")
            If IsNull(idRetornado) Or idRetornado = "" Then idRetornado = 0
            Response.Write "{""resultado"":""OK"",""mensaje"":""" & Replace(mensaje_sp, """", "'") & """,""id_eva"":" & CLng(idRetornado) & "}"
        Else
            Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & Replace(mensaje_sp, """", "'") & """}"
        End If
    Else
        Response.Write "{""resultado"":""OK"",""mensaje"":""Registro eliminado correctamente.""}"
    End If
End If
%>