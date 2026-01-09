<%@ Language=VBScript CODEPAGE="65001" %>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Charset = "UTF-8"

Dim idUsuario, perfil, idSucursal
idUsuario = Trim(request("idUsuario"))
perfil = Trim(request("perfil"))
idSucursal = Trim(request("idSucursal"))

Dim sql, rsSolicitudes

' Si es perfil 2 (ZONAL), obtener todas las solicitudes de sus sucursales
If perfil = "2" Then
    ' Obtener solicitudes de todas las sucursales del usuario
    sql = "SELECT " & _
          "s.id_solicitud, s.id_sucursal, suc.suc_nombre, s.motivo_solicitud, " & _
          "FORMAT(s.fecha_desde, 'dd/MM/yyyy') AS fecha_desde, FORMAT(s.fecha_hasta, 'dd/MM/yyyy') AS fecha_hasta, s.periodo, s.observaciones, " & _
          "s.id_estado, e.nombre_estado, e.color_badge, " & _
          "s.usuario_registro, FORMAT(s.fecha_registro, 'dd/MM/yyyy') AS fecha_registro " & _
          "FROM SUC_solicitud_cajeros_adicionales s " & _
          "LEFT JOIN SUC_sucursal suc ON s.id_sucursal = suc.id_sucursal " & _
          "LEFT JOIN SUC_cat_estados_solicitud e ON s.id_estado = e.id_estado " & _
          "WHERE s.activo = 1 " & _
          "AND s.id_sucursal IN (SELECT id_sucursal FROM SUC_usuario_sucursal WHERE id_usuario = " & idUsuario & ") " & _
          "ORDER BY s.fecha_registro DESC"
ElseIf perfil = "3" Then
    ' Para CENTRAL/ADMIN, obtener todas las solicitudes
    sql = "SELECT " & _
          "s.id_solicitud, s.id_sucursal, suc.suc_nombre, s.motivo_solicitud, " & _
          "CASE s.motivo_solicitud " & _
          "  WHEN 'licencia_medica' THEN 'Licencia MÃƒÆ’Ã‚Â©dica' " & _
          "  WHEN 'vacaciones' THEN 'Vacaciones' " & _
          "  WHEN 'reemplazo' THEN 'Reemplazo' " & _
          "  WHEN 'flujo' THEN 'Flujo' " & _
          "  ELSE s.motivo_solicitud " & _
          "END AS motivo_solicitud_texto, " & _
          "FORMAT(s.fecha_desde, 'dd/MM/yyyy') AS fecha_desde, FORMAT(s.fecha_hasta, 'dd/MM/yyyy') AS fecha_hasta, s.periodo, s.observaciones, " & _
          "s.id_estado, e.nombre_estado, e.color_badge, " & _
          "s.usuario_registro, FORMAT(s.fecha_registro, 'dd/MM/yyyy') AS fecha_registro " & _
          "FROM SUC_solicitud_cajeros_adicionales s " & _
          "LEFT JOIN SUC_sucursal suc ON s.id_sucursal = suc.id_sucursal " & _
          "LEFT JOIN SUC_cat_estados_solicitud e ON s.id_estado = e.id_estado " & _
          "WHERE s.activo = 1 " & _
          "ORDER BY s.fecha_registro DESC"
Else
    ' Para otros perfiles, filtrar por la sucursal actual
    If idSucursal <> "" Then
        sql = "EXEC SP_SUC_listar_solicitudes_cajeros " & idSucursal
    Else
        ' Si no hay sucursal, retornar array vacÃƒÆ’Ã‚Â­o
        Response.Write "[]"
        Response.End
    End If
End If

Set rsSolicitudes = db.Execute(sql)

Response.Write "["
Dim primera
primera = True

Do While Not rsSolicitudes.EOF
    If Not primera Then Response.Write ","
    primera = False
    
    ' Traducir motivo_solicitud
    Dim motivoTexto
    Select Case rsSolicitudes("motivo_solicitud")
        Case "licencia_medica"
            motivoTexto = "Licencia Médica"
        Case "vacaciones"
            motivoTexto = "Vacaciones"
        Case "reemplazo"
            motivoTexto = "Reemplazo"
        Case "flujo"
            motivoTexto = "Flujo"
        Case Else
            motivoTexto = rsSolicitudes("motivo_solicitud")
    End Select
    
    Response.Write "{"
    Response.Write """id_solicitud"":" & rsSolicitudes("id_solicitud") & ","
    Response.Write """id_sucursal"":" & rsSolicitudes("id_sucursal") & ","
    Response.Write """suc_nombre"":""" & Replace(rsSolicitudes("suc_nombre"), """", "\""") & ""","
    Response.Write """motivo_solicitud_texto"":""" & motivoTexto & ""","
    Response.Write """fecha_desde"":""" & rsSolicitudes("fecha_desde") & ""","
    Response.Write """fecha_hasta"":""" & rsSolicitudes("fecha_hasta") & ""","
    Response.Write """periodo"":""" & rsSolicitudes("periodo") & ""","
    Response.Write """observaciones"":""" & Replace(rsSolicitudes("observaciones"), """", "\""") & ""","
    Response.Write """id_estado"":" & rsSolicitudes("id_estado") & ","
    Response.Write """nombre_estado"":""" & rsSolicitudes("nombre_estado") & ""","
    Response.Write """color_badge"":""" & rsSolicitudes("color_badge") & ""","
    Response.Write """usuario_registro"":""" & rsSolicitudes("usuario_registro") & ""","
    Response.Write """fecha_registro"":""" & rsSolicitudes("fecha_registro") & """"
    Response.Write "}"
    
    rsSolicitudes.MoveNext
Loop

Response.Write "]"

rsSolicitudes.Close
Set rsSolicitudes = Nothing
%>