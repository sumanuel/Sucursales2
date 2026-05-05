<%@ Language=VBScript CODEPAGE="65001" %>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Charset = "UTF-8"

Function FormatearFechaHoraDMY(valorFecha)
    If IsNull(valorFecha) Or Trim(CStr(valorFecha)) = "" Then
        FormatearFechaHoraDMY = ""
        Exit Function
    End If

    Dim fechaValor, hora12, minutos, segundos, sufijo
    fechaValor = CDate(valorFecha)

    hora12 = Hour(fechaValor)
    sufijo = "AM"

    If hora12 >= 12 Then
        sufijo = "PM"
    End If

    If hora12 = 0 Then
        hora12 = 12
    ElseIf hora12 > 12 Then
        hora12 = hora12 - 12
    End If

    minutos = Right("0" & Minute(fechaValor), 2)
    segundos = Right("0" & Second(fechaValor), 2)

    FormatearFechaHoraDMY = Right("0" & Day(fechaValor), 2) & "/" & Right("0" & Month(fechaValor), 2) & "/" & Year(fechaValor) & " " & hora12 & ":" & minutos & ":" & segundos & " " & sufijo
End Function

Dim id_solicitud_rebaja
id_solicitud_rebaja = Request.QueryString("id_solicitud_rebaja")

If id_solicitud_rebaja = "" Then
    Response.Write "{""error"":""ID de solicitud no proporcionado""}"
    Response.End
End If

Dim sql
sql = "EXEC SP_SUC_obtener_historial_estados_rebaja " & id_solicitud_rebaja

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
    Response.Write """id_solicitud_rebaja"":" & rs("id_solicitud_rebaja") & ","
    
    If Not IsNull(rs("id_estado_anterior")) Then
        Response.Write """id_estado_anterior"":" & rs("id_estado_anterior") & ","
        Response.Write """estado_anterior"":""" & rs("estado_anterior") & ""","
    Else
        Response.Write """id_estado_anterior"":null,"
        Response.Write """estado_anterior"":null,"
    End If
    
    Response.Write """id_estado_nuevo"":" & rs("id_estado_nuevo") & ","
    Response.Write """estado_nuevo"":""" & rs("estado_nuevo") & ""","
    Response.Write """color_badge_rebaja"":""" & rs("color_badge_rebaja") & ""","
    Response.Write """comentario"":""" & Replace(rs("comentario"), """", "\""") & ""","
    Response.Write """usuario_cambio"":""" & rs("usuario_cambio") & ""","
    Response.Write """fecha_cambio"":""" & FormatearFechaHoraDMY(rs("fecha_cambio")) & """"
    Response.Write "}"
    
    rs.MoveNext
Loop

Response.Write "]"

rs.Close
Set rs = Nothing
%>
