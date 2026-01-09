<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json; charset=utf-8"
Response.CodePage = 65001
Response.CharSet = "utf-8"

' Parámetros de paginación
Dim page, pageSize, offset, totalRegistros
page = Request("page")
If page = "" Or Not IsNumeric(page) Then page = 1
page = CInt(page)

pageSize = Request("page_size")
If pageSize = "" Or Not IsNumeric(pageSize) Then pageSize = 15
pageSize = CInt(pageSize)

offset = (page - 1) * pageSize

' Parámetros de filtros
Dim idSucursal, idUsuario, perfil
idSucursal = Request("idSucursal")
idUsuario = Request("idUsuario")
perfil = Request("perfil")

' Construcción de la consulta WHERE según perfil
Dim whereClause
whereClause = "WHERE s.activo = 1 "

If perfil = "1" Then
    ' JEPS: Solo su sucursal
    If idSucursal <> "" And IsNumeric(idSucursal) Then
        whereClause = whereClause & "AND s.id_sucursal = " & idSucursal & " "
    End If
ElseIf perfil = "2" Then
    ' ZONAL: Todas las sucursales asignadas
    If idUsuario <> "" Then
        whereClause = whereClause & "AND s.id_sucursal IN (SELECT id_sucursal FROM SUC_usuario_sucursal WHERE id_usuario = '" & idUsuario & "') "
    End If
ElseIf perfil = "3" Then
    ' CENTRAL/ADMIN: Todas las solicitudes (no agregar filtro adicional)
End If

' Contar total de registros
Dim sqlCount, rsCount
sqlCount = "SELECT COUNT(*) AS total " & _
           "FROM SUC_solicitud_cajeros_adicionales s " & _
           whereClause

Set rsCount = DB.execute(sqlCount)
If Not rsCount.EOF Then
    totalRegistros = rsCount("total")
Else
    totalRegistros = 0
End If
rsCount.Close
Set rsCount = Nothing

' Consulta con paginación
Dim sql, rs, datos, i
sql = "SELECT " & _
      "s.id_solicitud, s.id_sucursal, suc.suc_nombre, s.motivo_solicitud, " & _
      "CASE s.motivo_solicitud " & _
      "  WHEN 'licencia_medica' THEN 'Licencia Médica' " & _
      "  WHEN 'vacaciones' THEN 'Vacaciones' " & _
      "  WHEN 'reemplazo' THEN 'Reemplazo' " & _
      "  WHEN 'flujo' THEN 'Flujo' " & _
      "  ELSE s.motivo_solicitud " & _
      "END AS motivo_solicitud_texto, " & _
      "FORMAT(s.fecha_desde, 'dd/MM/yyyy') AS fecha_desde, " & _
      "FORMAT(s.fecha_hasta, 'dd/MM/yyyy') AS fecha_hasta, " & _
      "s.periodo, s.observaciones, " & _
      "s.id_estado, e.nombre_estado, e.color_badge, " & _
      "s.usuario_registro, FORMAT(s.fecha_registro, 'dd/MM/yyyy') AS fecha_registro " & _
      "FROM SUC_solicitud_cajeros_adicionales s " & _
      "LEFT JOIN SUC_sucursal suc ON s.id_sucursal = suc.id_sucursal " & _
      "LEFT JOIN SUC_cat_estados_solicitud e ON s.id_estado = e.id_estado " & _
      whereClause & _
      "ORDER BY s.fecha_registro DESC " & _
      "OFFSET " & offset & " ROWS " & _
      "FETCH NEXT " & pageSize & " ROWS ONLY"

Set rs = DB.execute(sql)

' Construir JSON
Dim json, first
json = "{"
json = json & """page"":" & page & ","
json = json & """pageSize"":" & pageSize & ","
json = json & """totalRegistros"":" & totalRegistros & ","
json = json & """totalPaginas"":" & Ceiling(totalRegistros / pageSize) & ","
json = json & """solicitudes"":["

first = True
Do While Not rs.EOF
    If Not first Then json = json & ","
    first = False
    
    json = json & "{"
    json = json & """id_solicitud"":" & rs("id_solicitud") & ","
    json = json & """id_sucursal"":" & nvl(rs("id_sucursal"), 0) & ","
    json = json & """suc_nombre"":""" & EscapeJSON(nvl(rs("suc_nombre"), "")) & ""","
    json = json & """motivo_solicitud"":""" & EscapeJSON(nvl(rs("motivo_solicitud"), "")) & ""","
    json = json & """motivo_solicitud_texto"":""" & EscapeJSON(nvl(rs("motivo_solicitud_texto"), "")) & ""","
    json = json & """fecha_desde"":""" & nvl(rs("fecha_desde"), "") & ""","
    json = json & """fecha_hasta"":""" & nvl(rs("fecha_hasta"), "") & ""","
    json = json & """periodo"":""" & EscapeJSON(nvl(rs("periodo"), "")) & ""","
    json = json & """observaciones"":""" & EscapeJSON(nvl(rs("observaciones"), "")) & ""","
    json = json & """id_estado"":" & nvl(rs("id_estado"), 0) & ","
    json = json & """nombre_estado"":""" & EscapeJSON(nvl(rs("nombre_estado"), "")) & ""","
    json = json & """color_badge"":""" & EscapeJSON(nvl(rs("color_badge"), "")) & ""","
    json = json & """usuario_registro"":""" & EscapeJSON(nvl(rs("usuario_registro"), "")) & ""","
    json = json & """fecha_registro"":""" & nvl(rs("fecha_registro"), "") & """"
    json = json & "}"
    
    rs.MoveNext
Loop

json = json & "]"
json = json & "}"

rs.Close
Set rs = Nothing
DB.Close
Set DB = Nothing

Response.Write json

' Función auxiliar para valores nulos
Function nvl(valor, defecto)
    If IsNull(valor) Or valor = "" Then
        nvl = defecto
    Else
        nvl = valor
    End If
End Function

' Función para escapar JSON
Function EscapeJSON(str)
    If IsNull(str) Then
        EscapeJSON = ""
        Exit Function
    End If
    Dim result
    result = Replace(str, "\", "\\")
    result = Replace(result, """", "\""")
    result = Replace(result, vbCrLf, "\n")
    result = Replace(result, vbCr, "\n")
    result = Replace(result, vbLf, "\n")
    result = Replace(result, vbTab, "\t")
    EscapeJSON = result
End Function

' Función techo para calcular páginas
Function Ceiling(num)
    Ceiling = Int(num)
    If num > Int(num) Then
        Ceiling = Ceiling + 1
    End If
End Function
%>
