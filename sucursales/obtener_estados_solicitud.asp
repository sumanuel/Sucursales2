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
sql = "EXEC SP_SUC_obtener_estados_activos"

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
        If CInt(estadoActual) = 1 Then ' Si está PENDIENTE REVISION
            If rs("id_estado") = 2 Then ' Solo puede ANULAR
                incluirEstado = True
            End If
        End If
    ElseIf perfil = "2" Then ' ZONAL/REGIONAL
        If CInt(estadoActual) = 1 Then ' Si está PENDIENTE REVISION
            If rs("id_estado") = 3 Or rs("id_estado") = 4 Then ' APROBADA ZONAL o RECHAZADA ZONAL
                incluirEstado = True
            End If
        End If
    ElseIf perfil = "3" Then ' GERENCIA/CENTRAL
        ' Para CENTRAL, solo puede cambiar estados si está PENDIENTE REVISION o APROBADA ZONAL
        If CInt(estadoActual) = 1 Or CInt(estadoActual) = 3 Then ' Si está PENDIENTE REVISION o APROBADA ZONAL
            If rs("id_estado") = 5 Or rs("id_estado") = 6 Then ' APROBADO CENTRAL o RECHAZADA CENTRAL
                incluirEstado = True
            End If
        End If
    End If
    
    If incluirEstado Then
        If Not primera Then Response.Write ","
        primera = False
        
        Response.Write "{"
        Response.Write """id_estado"":" & rs("id_estado") & ","
        Response.Write """nombre_estado"":""" & rs("nombre_estado") & ""","
        Response.Write """descripcion"":""" & Replace(rs("descripcion"), """", "\""") & ""","
        Response.Write """color_badge"":""" & rs("color_badge") & ""","
        Response.Write """orden_flujo"":" & rs("orden_flujo") & ","
        Response.Write """requiere_comentario"":" & IIf(rs("requiere_comentario"), "true", "false")
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