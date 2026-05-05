<%@ Language=VBScript CODEPAGE="65001" %>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Charset = "UTF-8"

' Obtener parámetros
Dim perfil, estadoActual
perfil = Request.QueryString("perfil")
estadoActual = Request.QueryString("estado_actual")

Dim sql, rs
sql = "EXEC SP_SUC_obtener_estados_rebaja_activos"

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
    incluirEstado = False
    
    ' Filtrar estados según perfil y estado actual
    ' Perfil 1 = JEPS: Solo puede ANULAR si está PENDIENTE REVISION
    ' Perfil 2 = ZONAL: Puede APROBAR ZONAL o RECHAZAR ZONAL
    ' Perfil 3 = GERENCIA/CENTRAL: Puede APROBAR CENTRAL o RECHAZAR CENTRAL
    
    If perfil = "1" Then ' JEPS
        If CInt(estadoActual) = 1 Then 
            If rs("id_estado_rebaja") = 2 Then 
                incluirEstado = True
            End If
        End If
    ElseIf perfil = "2" Then 
        If CInt(estadoActual) = 1 Then 
            If rs("id_estado_rebaja") = 3 Or rs("id_estado_rebaja") = 4 Then 
                incluirEstado = True
            End If
        End If
        If CInt(estadoActual) = 3 Then 
            If rs("id_estado_rebaja") = 2 Then 
                incluirEstado = True
            End If
        End If
    ElseIf perfil = "3" Then ' GERENCIA/CENTRAL
        If CInt(estadoActual) = 3 Then
            If rs("id_estado_rebaja") = 5 Or rs("id_estado_rebaja") = 6 Then 
                incluirEstado = True
            End If
        End If
    End If
    
    If incluirEstado Then
        If Not primera Then Response.Write ","
        primera = False
        
        Response.Write "{"
        Response.Write """id_estado_rebaja"":" & rs("id_estado_rebaja") & ","
        Response.Write """nombre_estado_rebaja"":""" & rs("nombre_estado_rebaja") & ""","
        Response.Write """descripcion_rebaja"":""" & Replace(rs("descripcion_rebaja"), """", "\""") & ""","
        Response.Write """color_badge_rebaja"":""" & rs("color_badge_rebaja") & ""","
        Response.Write """orden_flujo_rebaja"":" & rs("orden_flujo_rebaja") & ","
        Response.Write """requiere_comentario_rebaja"":" & IIf(rs("requiere_comentario_rebaja"), "true", "false")
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