<%@ Language=VBScript %>
<!-- #include file="validar_dias_habiles.asp" -->
<%
Response.ContentType = "text/html; charset=utf-8"
Response.Write "<h1>Verificación de Versión de Archivos</h1>"
Response.Write "<p><strong>validar_dias_habiles.asp:</strong> VERSIÓN 2025-12-03 18:35:00 - USA STORED PROCEDURE + FIX DB Connection</p>"
Response.Write "<p><strong>Hora del servidor:</strong> " & Now() & "</p>"
Response.Write "<hr>"

' Probar función validarPlazoCarga
Dim resultado, fechaPrueba
fechaPrueba = CDate("2025-12-04")

Set resultado = validarPlazoCarga(fechaPrueba)

Response.Write "<h2>Resultado de validarPlazoCarga('04/12/2025'):</h2>"
Response.Write "<ul>"
Response.Write "<li>valido: <strong style='color:" & IIf(resultado("valido"), "green", "red") & "'>" & resultado("valido") & "</strong></li>"
Response.Write "<li>mensaje: " & resultado("mensaje") & "</li>"
Response.Write "<li>horaLimite: " & resultado("horaLimite") & "</li>"
Response.Write "</ul>"

Response.Write "<hr>"
Response.Write "<p><strong>Interpretación:</strong></p>"
Response.Write "<ul>"
Response.Write "<li>Si 'valido' = <strong>True</strong>: El archivo está DESACTUALIZADO (no usa SP)</li>"
Response.Write "<li>Si 'valido' = <strong>False</strong>: El archivo está ACTUALIZADO (usa SP correctamente)</li>"
Response.Write "</ul>"
%>
