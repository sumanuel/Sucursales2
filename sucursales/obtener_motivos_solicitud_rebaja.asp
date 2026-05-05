<%@ Language=VBScript CODEPAGE="65001" %>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Charset = "UTF-8"

' Obtener parámetros
Dim perfil, motivoActual
perfil = Request.QueryString("perfil")
motivoActual = Request.QueryString("motivo_actual")

Dim sql, rs
sql = "EXEC SP_SUC_obtener_motivos_rebaja_activos"

On Error Resume Next
Set rs = db.Execute(sql)

If Err.Number <> 0 Then
    Response.Write "{""error"":""" & Replace(Err.Description, """", "\""") & """}"
    Response.End
End If

Response.Write "["
Dim primera
primera = True

Do While Not rs.EOF
    Dim incluirEstado
    incluirEstado = true
    
    If incluirEstado Then
        If Not primera Then Response.Write ","
        primera = False
        
        Response.Write "{"
        Response.Write """id_motivo_rebaja"":" & rs("id_motivo_rebaja") & ","
        Response.Write """nombre_motivo_rebaja"":""" & rs("nombre_motivo_rebaja") & """"
        Response.Write "}"
    End If
    
    rs.MoveNext
Loop

Response.Write "]"

rs.Close
Set rs = Nothing

Response.Flush
Response.End
%>