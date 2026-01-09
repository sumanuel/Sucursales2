<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="validar_dias_habiles.asp"-->
<%
Response.ContentType = "text/html; charset=utf-8"

' Ejemplos de fechas para probar - FORMATO DEL CSV: MM/DD/YYYY
dim fechasPrueba(7)
fechasPrueba(0) = "01-12-2025"  ' Formato CSV con guiones (Enero 12, 2025)
fechasPrueba(1) = "01/12/2025"  ' Formato CSV con barras (Enero 12, 2025)
fechasPrueba(2) = "1/12/2025"   ' Sin cero adelante (Enero 12, 2025)
fechasPrueba(3) = "12/01/2025"  ' Diciembre 1, 2025
fechasPrueba(4) = "12-03-2025"  ' Diciembre 3, 2025
fechasPrueba(5) = "12/15/2025"  ' Diciembre 15, 2025
fechasPrueba(6) = "1/1/2025"    ' Enero 1, 2025
fechasPrueba(7) = "11/29/2025"  ' Noviembre 29, 2025
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Debug - Conversión de Fechas</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
        .error { color: red; }
        .success { color: green; }
        .warning { color: orange; }
    </style>
</head>
<body>
    <h1>🔍 Debug - Conversión y Validación de Fechas</h1>
    
    <h2>Información del Servidor</h2>
    <table>
        <tr>
            <th>Parámetro</th>
            <th>Valor</th>
        </tr>
        <tr>
            <td>Fecha/Hora Actual (Now)</td>
            <td><strong><%=Now()%></strong></td>
        </tr>
        <tr>
            <td>Date()</td>
            <td><%=Date()%></td>
        </tr>
        <tr>
            <td>FormatDateTime(Now, 2)</td>
            <td><%=FormatDateTime(Now(), 2)%></td>
        </tr>
        <tr>
            <td>Día de la Semana</td>
            <td><%=WeekdayName(Weekday(Now()))%> (<%=Weekday(Now())%>)</td>
        </tr>
    </table>
    
    <h2>Pruebas de Conversión de Fechas (Formato CSV: MM/DD/YYYY)</h2>
    <p style="background: #fff3cd; padding: 10px; border-left: 4px solid #ffc107;">
        <strong>⚠️ Nota:</strong> El CSV usa formato americano <code>MM/DD/YYYY</code> o <code>MM-DD-YYYY</code>
    </p>
    <table>
        <tr>
            <th>String CSV Original</th>
            <th>Interpretación Correcta</th>
            <th>convertirFechaCSV()</th>
            <th>Weekday</th>
            <th>FormatDateTime</th>
            <th>Día Hábil Anterior</th>
            <th>Estado Validación</th>
        </tr>
        <%
        dim i, fechaStr, fechaConv, diaHabilAnt, validacion
        
        For i = 0 To 7
            fechaStr = fechasPrueba(i)
            
            Response.Write "<tr>"
            Response.Write "<td><code>" & fechaStr & "</code></td>"
            
            ' Mostrar interpretación esperada
            dim partes, mesEsp, diaEsp
            partes = Split(Replace(fechaStr, "-", "/"), "/")
            mesEsp = partes(0)
            diaEsp = partes(1)
            Response.Write "<td><strong>" & diaEsp & " de " & MonthName(CInt(mesEsp)) & "</strong></td>"
            
            On Error Resume Next
            fechaConv = convertirFechaCSV(fechaStr)
            
            If Err.Number = 0 And Not IsNull(fechaConv) Then
                Response.Write "<td class='success'>" & fechaConv & "</td>"
                Response.Write "<td>" & WeekdayName(Weekday(fechaConv), True) & " (" & Weekday(fechaConv) & ")</td>"
                Response.Write "<td>" & FormatDateTime(fechaConv, 2) & "</td>"
                
                ' Calcular día hábil anterior
                diaHabilAnt = DateAdd("d", -1, fechaConv)
                Do While Not esDiaHabil(diaHabilAnt)
                    diaHabilAnt = DateAdd("d", -1, diaHabilAnt)
                Loop
                
                Response.Write "<td>" & FormatDateTime(diaHabilAnt, 2) & " (" & WeekdayName(Weekday(diaHabilAnt), True) & ") 18:00</td>"
                
                ' Validar plazo
                Set validacion = validarPlazoCarga(fechaConv)
                
                If validacion("valido") Then
                    Response.Write "<td class='success'>✅ VÁLIDO para cargar</td>"
                Else
                    Response.Write "<td class='error'>❌ " & Server.HTMLEncode(validacion("mensaje")) & "</td>"
                End If
            Else
                Response.Write "<td class='error' colspan='5'>Error: " & Err.Description & "</td>"
                Err.Clear
            End If
            On Error GoTo 0
            
            Response.Write "</tr>"
        Next
        %>
    </table>
    
    <h2>Prueba Específica con Fechas del Error</h2>
    <div style="background: #fff3cd; border: 2px solid #ffc107; padding: 15px; border-radius: 5px;">
        <%
        ' Las fechas del error del CSV
        dim fechasError(1), j
        fechasError(0) = "01-12-2025"  ' Como aparece en el CSV
        fechasError(1) = "1/12/2025"   ' Como aparece en Excel
        
        For j = 0 To 1
            dim fechaError, fechaErrorConv, validacionError
            fechaError = fechasError(j)
            
            Response.Write "<h3>Probando: <code>" & fechaError & "</code></h3>"
            
            fechaErrorConv = convertirFechaCSV(fechaError)
            
            If Not IsNull(fechaErrorConv) Then
                Response.Write "<p><strong>✅ Convertida a:</strong> " & fechaErrorConv & "</p>"
                Response.Write "<p><strong>FormatDateTime:</strong> " & FormatDateTime(fechaErrorConv, 2) & "</p>"
                Response.Write "<p><strong>Día de la Semana:</strong> " & WeekdayName(Weekday(fechaErrorConv)) & " (" & Weekday(fechaErrorConv) & ")</p>"
                Response.Write "<p><strong>¿Es día hábil?:</strong> " & IIf(esDiaHabil(fechaErrorConv), "Sí", "No") & "</p>"
                
                ' Calcular día hábil anterior
                dim diaHabilAntError
                diaHabilAntError = DateAdd("d", -1, fechaErrorConv)
                Response.Write "<p><strong>Día anterior (-1):</strong> " & FormatDateTime(diaHabilAntError, 2) & " (" & WeekdayName(Weekday(diaHabilAntError)) & ")</p>"
                
                dim contador
                contador = 0
                Do While Not esDiaHabil(diaHabilAntError)
                    diaHabilAntError = DateAdd("d", -1, diaHabilAntError)
                    contador = contador + 1
                    Response.Write "<p style='color: orange;'><strong>  → Retrocediendo (paso " & contador & "):</strong> " & FormatDateTime(diaHabilAntError, 2) & " (" & WeekdayName(Weekday(diaHabilAntError)) & ")</p>"
                Loop
                
                Response.Write "<p style='color: green; font-size: 16px;'><strong>✅ Día hábil anterior encontrado:</strong> " & FormatDateTime(diaHabilAntError, 2) & " a las 18:00 hrs</p>"
                
                ' Validación completa
                Set validacionError = validarPlazoCarga(fechaErrorConv)
                
                Response.Write "<hr>"
                Response.Write "<p><strong>Resultado de Validación:</strong></p>"
                
                If validacionError("valido") Then
                    Response.Write "<p style='font-size: 16px; color: green;'>✅ VÁLIDO - Puede cargar</p>"
                Else
                    Response.Write "<p style='font-size: 16px; color: red;'>❌ INVÁLIDO</p>"
                    Response.Write "<p style='color: red;'><strong>Mensaje:</strong> " & Server.HTMLEncode(validacionError("mensaje")) & "</p>"
                End If
            Else
                Response.Write "<p class='error'>❌ Error al convertir la fecha</p>"
            End If
            
            If j = 0 Then Response.Write "<hr>"
        Next
        %>
    </div>
    
    <hr>
    <p><a href="admin_personal.asp">&laquo; Volver</a> | <a href="test_validacion_reemplazos.asp">Test Completo</a></p>
</body>
</html>
