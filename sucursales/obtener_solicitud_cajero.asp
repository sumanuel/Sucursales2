<%@ Language=VBScript %>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Charset = "UTF-8"

Dim id_solicitud
id_solicitud = Request.QueryString("id_solicitud")

If id_solicitud = "" Then
    Response.Write "{""error"":""ID no proporcionado""}"
    Response.End
End If

Dim sql
sql = "EXEC SP_SUC_obtener_solicitud_cajero " & id_solicitud

On Error Resume Next
Dim rs
Set rs = db.Execute(sql)

If Err.Number <> 0 Then
    Response.Write "{""error"":""" & Replace(Err.Description, """", "\""") & """}"
    Response.End
End If

If Not rs.EOF Then
    Response.Write "{"
    Response.Write """id_solicitud"":" & rs("id_solicitud") & ","
    Response.Write """id_sucursal"":" & rs("id_sucursal") & ","
    Response.Write """motivo_solicitud"":""" & rs("motivo_solicitud") & ""","
    
    Dim fechaDesde, fechaHasta
    fechaDesde = rs("fecha_desde")
    fechaHasta = rs("fecha_hasta")
    
    If IsDate(fechaDesde) Then
        fechaDesde = Year(fechaDesde) & "-" & Right("0" & Month(fechaDesde), 2) & "-" & Right("0" & Day(fechaDesde), 2)
    End If
    
    If IsDate(fechaHasta) Then
        fechaHasta = Year(fechaHasta) & "-" & Right("0" & Month(fechaHasta), 2) & "-" & Right("0" & Day(fechaHasta), 2)
    End If
    
    Response.Write """fecha_desde"":""" & fechaDesde & ""","
    Response.Write """fecha_hasta"":""" & fechaHasta & ""","
    Response.Write """periodo"":""" & Trim(rs("periodo")) & ""","
    Response.Write """observaciones"":""" & Replace(rs("observaciones"), """", "\""") & """"
    Response.Write "}"
Else
    Response.Write "{""error"":""Solicitud no encontrada""}"
End If

rs.Close
Set rs = Nothing
%>