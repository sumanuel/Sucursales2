<%@ Language=VBScript %>
<!--#include file="../conexion/conexion.asp"-->
<%
On Error Resume Next
Response.ContentType = "application/json"
Response.Charset = "UTF-8"

Dim id_solicitud, id_sucursal, motivo, fecha_desde, fecha_hasta, periodo, observaciones, usuario, perfil

id_solicitud = Request.Form("id_solicitud")
If id_solicitud = "" Then id_solicitud = 0

id_sucursal = Request.Form("id_sucursal")
motivo = Request.Form("motivo")
fecha_desde = Request.Form("fecha_desde")
fecha_hasta = Request.Form("fecha_hasta")
periodo = Request.Form("periodo")
observaciones = Request.Form("observaciones")
perfil = Request.Form("perfil")
If perfil = "" Then perfil = 1

Dim idUsrWin
idUsrWin = Request.ServerVariables("LOGON_USER")
If InStr(idUsrWin, "\") > 0 Then
    usuario = Mid(idUsrWin, InStr(idUsrWin, "\") + 1)
Else
    usuario = "SISTEMA"
End If

If id_sucursal = "" Or motivo = "" Or fecha_desde = "" Or fecha_hasta = "" Or periodo = "" Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""Campos requeridos""}"
    Response.End
End If

Dim sql
sql = "EXEC SP_SUC_insertar_solicitud_cajero "
sql = sql & "@id_solicitud=" & id_solicitud & ","
sql = sql & "@id_sucursal=" & id_sucursal & ","
sql = sql & "@motivo_solicitud='" & Replace(motivo, "'", "''") & "',"
sql = sql & "@fecha_desde='" & fecha_desde & "',"
sql = sql & "@fecha_hasta='" & fecha_hasta & "',"
sql = sql & "@periodo='" & Replace(periodo, "'", "''") & "',"

If observaciones = "" Then
    sql = sql & "@observaciones=NULL,"
Else
    sql = sql & "@observaciones='" & Replace(observaciones, "'", "''") & "',"
End If

sql = sql & "@usuario_registro='" & Replace(usuario, "'", "''") & "',"
sql = sql & "@perfil=" & perfil

Dim rs
Set rs = db.Execute(sql)

If Err.Number <> 0 Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & Replace(Replace(Err.Description, """", "\"""), vbCrLf, " ") & """}"
Else
    If Not rs.EOF Then
        If rs("resultado") = "OK" Then
            Response.Write "{""resultado"":""OK"",""id"":" & rs("id_solicitud") & "}"
        Else
            Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & rs("mensaje") & """}"
        End If
    Else
        Response.Write "{""resultado"":""OK""}"
    End If
End If
%>