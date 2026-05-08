<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "text/html"
Response.Charset = "utf-8"
On Error Resume Next

Dim idEva, rsCabecera, rsDetalle, sqlCabecera, sqlDetalle

Function DetTextoSeguro(valor)
  If IsNull(valor) Then
    DetTextoSeguro = ""
  Else
    DetTextoSeguro = Server.HTMLEncode(CStr(valor))
  End If
End Function

Function DetFechaDMY(valorFecha)
  If IsNull(valorFecha) Or Trim(CStr(valorFecha)) = "" Then
    DetFechaDMY = ""
  Else
    DetFechaDMY = Right("0" & Day(CDate(valorFecha)), 2) & "-" & Right("0" & Month(CDate(valorFecha)), 2) & "-" & Year(CDate(valorFecha))
  End If
End Function

Function DetRespuesta(valor)
  If IsNull(valor) Or Trim(CStr(valor)) = "" Then
    DetRespuesta = ""
  ElseIf CLng(valor) = 1 Then
    DetRespuesta = "Si"
  ElseIf CLng(valor) = 0 Then
    DetRespuesta = "No"
  ElseIf CLng(valor) = 2 Then
    DetRespuesta = "N/A"
  Else
    DetRespuesta = CStr(valor)
  End If
End Function

idEva = 0
If Trim(Request("id") & "") <> "" And IsNumeric(Request("id")) Then
  idEva = CLng(Request("id"))
End If

If idEva <= 0 Then
  Response.Write "<div class=""alert alert-error"">Identificador invalido.</div>"
  Response.End
End If

sqlCabecera = "EXEC dbo.SP_SUC_listar_mae_rep_eva_cajero @ID_EVA = " & idEva & ", @TOP_REGISTROS = 1"
Set rsCabecera = db.Execute(sqlCabecera)

If rsCabecera.EOF Then
  Response.Write "<div class=""alert alert-error"">No se encontro la evaluacion indicada.</div>"
  Response.End
End If

If UCase(Trim(rsCabecera.Fields(0).Name & "")) = "RESULTADO" Then
  Response.Write "<div class=""alert alert-error"">" & DetTextoSeguro(rsCabecera("mensaje")) & "</div>"
  Response.End
End If

Response.Write "<div class=""row-fluid"" style=""margin-bottom:12px;""><div class=""span4""><strong>Rut:</strong> " & DetTextoSeguro(rsCabecera("EVA_RUT")) & "</div><div class=""span5""><strong>Nombre:</strong> " & DetTextoSeguro(rsCabecera("EVA_NOMBRE")) & "</div><div class=""span3""><strong>Puntaje:</strong> " & DetTextoSeguro(rsCabecera("PUNTAJE_EVALUACION")) & "</div></div>"
Response.Write "<div class=""row-fluid"" style=""margin-bottom:12px;""><div class=""span4""><strong>Proveedor:</strong> " & DetTextoSeguro(rsCabecera("EVA_EMP")) & "</div><div class=""span4""><strong>Envio capacitacion:</strong> " & DetTextoSeguro(DetFechaDMY(rsCabecera("FCH_ENVIO_CAPACITACION"))) & "</div><div class=""span4""><strong>Fecha evaluacion:</strong> " & DetTextoSeguro(DetFechaDMY(rsCabecera("FCH_EVALUACION"))) & "</div></div>"
Response.Write "<div class=""row-fluid"" style=""margin-bottom:12px;""><div class=""span6""><strong>Comentario JEPS:</strong><div class=""well well-small"" style=""margin-top:5px;margin-bottom:0;"">" & DetTextoSeguro(rsCabecera("EVA_COM")) & "</div></div><div class=""span6""><strong>Comentario areas centrales:</strong><div class=""well well-small"" style=""margin-top:5px;margin-bottom:0;"">" & DetTextoSeguro(rsCabecera("EVA_COM_CEN")) & "</div></div></div>"

sqlDetalle = "SELECT pre.PRE_TIT, pre.PRE_PRE, pre.PRE_ORD, res.RES_RES FROM dbo.SUC_CAP_RES res INNER JOIN dbo.SUC_CAP_PRE pre ON pre.PRE_ID_PRE = res.PRE_ID_PRE WHERE res.ID_EVA = " & idEva & " ORDER BY pre.PRE_ORD, pre.PRE_ID_PRE"
Set rsDetalle = db.Execute(sqlDetalle)

If rsDetalle.EOF Then
  Response.Write "<div class=""alert alert-info"" style=""margin-bottom:0;"">No hay respuestas registradas para esta evaluacion.</div>"
  Response.End
End If

Response.Write "<table class=""table table-bordered table-striped table-hover"" style=""margin-bottom:0;""><thead><tr><th style=""width:50px;text-align:center;"">#</th><th>Pregunta</th><th>Descripcion</th><th style=""width:110px;text-align:center;"">Respuesta</th></tr></thead><tbody>"

Dim idx
idx = 0
Do While Not rsDetalle.EOF
  idx = idx + 1
  Response.Write "<tr>"
  Response.Write "<td style=""text-align:center;"">" & idx & "</td>"
  Response.Write "<td>" & DetTextoSeguro(rsDetalle("PRE_TIT")) & "</td>"
  Response.Write "<td>" & DetTextoSeguro(rsDetalle("PRE_PRE")) & "</td>"
  Response.Write "<td style=""text-align:center;font-weight:bold;"">" & DetTextoSeguro(DetRespuesta(rsDetalle("RES_RES"))) & "</td>"
  Response.Write "</tr>"
  rsDetalle.MoveNext
Loop

Response.Write "</tbody></table>"

If IsObject(rsCabecera) Then
  If rsCabecera.State = 1 Then rsCabecera.Close
  Set rsCabecera = Nothing
End If

If IsObject(rsDetalle) Then
  If rsDetalle.State = 1 Then rsDetalle.Close
  Set rsDetalle = Nothing
End If
%>