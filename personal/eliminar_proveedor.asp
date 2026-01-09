<%@ Language=VBScript %>
<%
Response.ContentType = "application/json"
Response.Charset = "utf-8"
%>
<!--#include file="../conexion/conexion.asp"-->
<%
On Error Resume Next
Dim id: id = Request.Form("id")
If id = "" Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""ID requerido""}"
    Response.End
End If
Dim sql: sql = "EXEC SP_SUC_eliminar_proveedor @id_proveedor=" & CInt(id)
Dim rs: Set rs = db.Execute(sql)
If Err.Number <> 0 Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & Replace(Err.Description, """", "'") & """}"
Else
    If Not rs.EOF Then
        If rs("resultado") = "OK" Then
            Response.Write "{""resultado"":""OK""}"
        Else
            Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & Replace(rs("mensaje"), """", "'") & """}"
        End If
    Else
        Response.Write "{""resultado"":""OK""}"
    End If
End If
%>