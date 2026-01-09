<%@ Language=VBScript %>
<!-- #include file="../funciones.asp" -->
<%
Response.ContentType = "text/html; charset=utf-8"
Response.CacheControl = "no-cache"
Response.Expires = -1

' Test directo del Stored Procedure
Dim rs, sql, fechaPrueba

fechaPrueba = "2025-12-04"

sql = "EXEC SP_ValidarPlazoCargaReemplazo @fecha_inicio = '" & fechaPrueba & "'"

Response.Write "<h2>Prueba directa de SP desde ASP</h2>"
Response.Write "<p>Fecha a validar: <strong>" & fechaPrueba & "</strong></p>"
Response.Write "<p>Hora actual servidor: <strong>" & Now() & "</strong></p>"
Response.Write "<hr>"

On Error Resume Next
Set rs = db.execute(sql)

If Err.Number <> 0 Then
    Response.Write "<p style='color:red'>ERROR: " & Err.Description & "</p>"
    Err.Clear
ElseIf rs.EOF Then
    Response.Write "<p style='color:red'>ERROR: No se obtuvo resultado del SP</p>"
Else
    Response.Write "<table border='1' cellpadding='5'>"
    Response.Write "<tr><th>Campo</th><th>Valor</th></tr>"
    Response.Write "<tr><td>resultado</td><td style='background:" & IIf(rs("resultado") = "OK", "lightgreen", "lightcoral") & "'><strong>" & rs("resultado") & "</strong></td></tr>"
    Response.Write "<tr><td>mensaje</td><td>" & rs("mensaje") & "</td></tr>"
    Response.Write "<tr><td>fecha_limite</td><td>" & rs("fecha_limite") & "</td></tr>"
    Response.Write "<tr><td>hora_limite</td><td>" & rs("hora_limite") & "</td></tr>"
    Response.Write "<tr><td>fecha_actual</td><td>" & rs("fecha_actual") & "</td></tr>"
    Response.Write "<tr><td>dia_semana_inicio</td><td>" & rs("dia_semana_inicio") & "</td></tr>"
    Response.Write "</table>"
End If

If Not rs Is Nothing Then
    If Not rs.EOF Then rs.Close
    Set rs = Nothing
End If

Response.Write "<hr>"
Response.Write "<h3>Interpretación:</h3>"
Response.Write "<ul>"
Response.Write "<li>Si resultado = <strong>OK</strong>: Permite cargar</li>"
Response.Write "<li>Si resultado = <strong>ERROR</strong>: NO permite cargar (ya pasó la hora límite)</li>"
Response.Write "</ul>"

db.close
Set db = Nothing
%>
