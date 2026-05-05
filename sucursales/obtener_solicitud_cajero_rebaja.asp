<%@ Language=VBScript %>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Charset = "UTF-8"

Dim id_solicitud_rebaja
id_solicitud_rebaja = Request.QueryString("id_solicitud_rebaja")

If id_solicitud_rebaja = "" Then
    Response.Write "{""error"":""ID no proporcionado""}"
    Response.End
End If

Dim sql
sql = "EXEC SP_SUC_obtener_solicitud_cajero_rebaja " & id_solicitud_rebaja

On Error Resume Next
Dim rs
Set rs = db.Execute(sql)

If Err.Number <> 0 Then
    Response.Write "{""error"":""" & Replace(Err.Description, """", "\""") & """}"
    Response.End
End If

If Not rs.EOF Then
    Response.Write "{"
    Response.Write """id_solicitud_rebaja"":" & rs("id_solicitud_rebaja") & ","
    Response.Write """id_sucursal"":" & rs("id_sucursal") & ","
    Response.Write """id_motivo_rebaja"":""" & rs("id_motivo_rebaja") & ""","
    Response.Write """nombre_motivo_rebaja"":""" & rs("nombre_motivo_rebaja") & ""","
    
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