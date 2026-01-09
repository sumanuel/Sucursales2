<%@ Language=VBScript CODEPAGE="65001" %>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Charset = "UTF-8"

Dim id_solicitud
id_solicitud = Request.QueryString("id_solicitud")

If id_solicitud = "" Then
    Response.Write "{""error"":""ID de solicitud no proporcionado""}"
    Response.End
End If

Dim sql
sql = "EXEC SP_SUC_obtener_historial_estados " & id_solicitud

On Error Resume Next
Dim rs
Set rs = db.Execute(sql)

If Err.Number <> 0 Then
    Response.Write "{""error"":""" & Replace(Err.Description, """", "\""") & """}"
    Response.End
End If

Response.Write "["
Dim primera
primera = True

Do While Not rs.EOF
    If Not primera Then Response.Write ","
    primera = False
    
    Response.Write "{"
    Response.Write """id_historial"":" & rs("id_historial") & ","
    Response.Write """id_solicitud"":" & rs("id_solicitud") & ","
    
    If Not IsNull(rs("id_estado_anterior")) Then
        Response.Write """id_estado_anterior"":" & rs("id_estado_anterior") & ","
        Response.Write """estado_anterior"":""" & rs("estado_anterior") & ""","
    Else
        Response.Write """id_estado_anterior"":null,"
        Response.Write """estado_anterior"":null,"
    End If
    
    Response.Write """id_estado_nuevo"":" & rs("id_estado_nuevo") & ","
    Response.Write """estado_nuevo"":""" & rs("estado_nuevo") & ""","
    Response.Write """color_badge"":""" & rs("color_badge") & ""","
    Response.Write """comentario"":""" & Replace(rs("comentario"), """", "\""") & ""","
    Response.Write """usuario_cambio"":""" & rs("usuario_cambio") & ""","
    Response.Write """fecha_cambio"":""" & rs("fecha_cambio") & """"
    Response.Write "}"
    
    rs.MoveNext
Loop

Response.Write "]"

rs.Close
Set rs = Nothing
%>
