<!--#include file="../conexion/conexion.asp"-->
<% Response.Expires = -1 Response.ContentType = "text/csv" Response.Charset =
"utf-8" Response.AddHeader "Content-Disposition", "attachment;
filename=maestro_reportes_evaluacion_" & Replace(Date(), "/", "-") & ".csv"
Function CsvSafe(valor) If IsNull(valor) Then valor = "" valor = CStr(valor)
valor = Replace(valor, Chr(34), Chr(34) & Chr(34)) CsvSafe = Chr(34) & valor &
Chr(34) End Function Function FechaSqlMr(valor) If Trim(valor & "") = "" Or Not
IsDate(valor) Then FechaSqlMr = "" Else FechaSqlMr = Year(CDate(valor)) & "-" &
Right("0" & Month(CDate(valor)), 2) & "-" & Right("0" & Day(CDate(valor)), 2)
End If End Function Function FechaCsvMr(valorFecha) If IsNull(valorFecha) Or
Trim(CStr(valorFecha)) = "" Then FechaCsvMr = "" Else FechaCsvMr = Right("0" &
Day(CDate(valorFecha)), 2) & "-" & Right("0" & Month(CDate(valorFecha)), 2) &
"-" & Year(CDate(valorFecha)) End If End Function Function RespuestaTexto(valor)
If IsNull(valor) Or Trim(CStr(valor)) = "" Then RespuestaTexto = "" ElseIf
CLng(valor) = 1 Then RespuestaTexto = "Si" ElseIf CLng(valor) = 0 Then
RespuestaTexto = "No" ElseIf CLng(valor) = 2 Then RespuestaTexto = "N/A" Else
RespuestaTexto = CStr(valor) End If End Function Dim filtroDesde, filtroHasta
Dim rsPreguntas, rsDatos, rsRespuestas Dim sqlPreguntas, sqlDatos, sqlRespuestas
Dim preguntas, datos, respuestas Dim totalPreguntas, totalDatos, i, j Dim
idsEva, llave, dicRespuestas filtroDesde = FechaSqlMr(Request("fch_desde"))
filtroHasta = FechaSqlMr(Request("fch_hasta")) If filtroDesde = "" Then
filtroDesde = FechaSqlMr(DateAdd("m", -3, Date())) If filtroHasta = "" Then
filtroHasta = FechaSqlMr(Date()) sqlPreguntas = "SELECT PRE_ID_PRE, PRE_TIT,
PRE_ORD FROM dbo.SUC_CAP_PRE WHERE ISNULL(PRE_EST, 0) = 1 ORDER BY PRE_ORD,
PRE_ID_PRE" Set rsPreguntas = db.Execute(sqlPreguntas) If Not rsPreguntas.EOF
Then preguntas = rsPreguntas.GetRows() If rsPreguntas.State = 1 Then
rsPreguntas.Close Set rsPreguntas = Nothing sqlDatos = "EXEC
dbo.SP_SUC_listar_mae_rep_eva_cajero @TOP_REGISTROS = 5000, @FCH_DESDE = '" &
filtroDesde & "', @FCH_HASTA = '" & filtroHasta & "'" Set rsDatos =
db.Execute(sqlDatos) If rsDatos.EOF Then Response.Write CsvSafe("Rut cajero") &
"," & CsvSafe("Nombre cajero") & vbCrLf Response.End End If If
UCase(Trim(rsDatos.Fields(0).Name & "")) = "RESULTADO" Then Response.Write
CsvSafe("Error") & "," & CsvSafe(rsDatos("mensaje")) & vbCrLf Response.End End
If datos = rsDatos.GetRows() If rsDatos.State = 1 Then rsDatos.Close Set rsDatos
= Nothing totalDatos = UBound(datos, 2) idsEva = "" For i = 0 To totalDatos If
idsEva <> "" Then idsEva = idsEva & "," idsEva = idsEva & CLng(datos(0, i)) Next
Set dicRespuestas = Server.CreateObject("Scripting.Dictionary") If idsEva <> ""
Then sqlRespuestas = "SELECT ID_EVA, PRE_ID_PRE, RES_RES FROM dbo.SUC_CAP_RES
WHERE ID_EVA IN (" & idsEva & ")" Set rsRespuestas = db.Execute(sqlRespuestas)
If Not rsRespuestas.EOF Then respuestas = rsRespuestas.GetRows() For i = 0 To
UBound(respuestas, 2) llave = CStr(respuestas(0, i)) & "_" & CStr(respuestas(1,
i)) dicRespuestas(llave) = RespuestaTexto(respuestas(2, i)) Next End If If
rsRespuestas.State = 1 Then rsRespuestas.Close Set rsRespuestas = Nothing End If
Response.Write CsvSafe("Rut cajero") & "," & CsvSafe("Nombre cajero") & "," &
CsvSafe("Proveedor") & "," & CsvSafe("Fecha Envio Capacitacion") & "," &
CsvSafe("Fecha Evaluacion") & "," & CsvSafe("Estado") & "," & CsvSafe("Puntaje
Evaluacion") & "," & CsvSafe("Comentario") & "," & CsvSafe("Resultado areas
centrales") If IsArray(preguntas) Then For j = 0 To UBound(preguntas, 2)
Response.Write "," & CsvSafe("Pregunta " & (j + 1) & " - " & preguntas(1, j))
Next End If Response.Write vbCrLf For i = 0 To totalDatos Response.Write
CsvSafe(datos(1, i)) & "," & CsvSafe(datos(2, i)) & "," & CsvSafe(datos(3, i)) &
"," & CsvSafe(FechaCsvMr(datos(5, i))) & "," & CsvSafe(FechaCsvMr(datos(6, i)))
& "," & CsvSafe(datos(10, i)) & "," & CsvSafe(datos(11, i)) & "," &
CsvSafe(datos(7, i)) & "," & CsvSafe(datos(8, i)) If IsArray(preguntas) Then For
j = 0 To UBound(preguntas, 2) llave = CStr(datos(0, i)) & "_" &
CStr(preguntas(0, j)) If dicRespuestas.Exists(llave) Then Response.Write "," &
CsvSafe(dicRespuestas(llave)) Else Response.Write "," & CsvSafe("") End If Next
End If Response.Write vbCrLf Next %>
