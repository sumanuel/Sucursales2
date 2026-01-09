<%
Option Explicit
Response.ContentType = "application/json"

Dim id_solicitud, cmd, rs

id_solicitud = Request.Form("id")

If IsEmpty(id_solicitud) Or id_solicitud = "" Then
    Response.Write "{""resultado"":""ERROR"", ""mensaje"":""ID no proporcionado""}"
    Response.End
End If

On Error Resume Next

Set cmd = Server.CreateObject("ADODB.Command")
With cmd
    .ActiveConnection = DB
    .CommandType = 4
    .CommandText = "SP_SUC_eliminar_solicitud_cajero"
    .Parameters.Append .CreateParameter("@id_solicitud", 3, 1, , CLng(id_solicitud))
    Set rs = .Execute
End With

If Err.Number <> 0 Then
    Response.Write "{""resultado"":""ERROR"", ""mensaje"":""" & Replace(Err.Description, """", "'") & """}"
Else
    If Not rs.EOF Then
        Response.Write "{""resultado"":""" & rs("resultado") & """, ""mensaje"":""Solicitud eliminada correctamente""}"
    Else
        Response.Write "{""resultado"":""ERROR"", ""mensaje"":""No se pudo eliminar la solicitud""}"
    End If
End If

If Not rs Is Nothing Then
    rs.Close
    Set rs = Nothing
End If
Set cmd = Nothing
%>