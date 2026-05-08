<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Charset = "utf-8"
Response.Expires = -1

Dim idEva, rsDatos, sqlDatos

Function MrJsonSafe(valor)
  If IsNull(valor) Then valor = ""
  valor = CStr(valor)
  valor = Replace(valor, "\", "\\")
  valor = Replace(valor, Chr(34), Chr(92) & Chr(34))
  valor = Replace(valor, vbCrLf, " ")
  valor = Replace(valor, vbCr, " ")
  valor = Replace(valor, vbLf, " ")
  MrJsonSafe = valor
End Function

idEva = 0
If Trim(Request("id") & "") <> "" And IsNumeric(Request("id")) Then
  idEva = CLng(Request("id"))
End If

If idEva <= 0 Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""Identificador invalido.""}"
  Response.End
End If

sqlDatos = "EXEC dbo.SP_SUC_listar_mae_rep_eva_cajero @ID_EVA = " & idEva & ", @TOP_REGISTROS = 1"
Set rsDatos = db.Execute(sqlDatos)

If rsDatos.EOF Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""No se encontro el registro indicado.""}"
  Response.End
End If

If UCase(Trim(rsDatos.Fields(0).Name & "")) = "RESULTADO" Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & MrJsonSafe(rsDatos("mensaje")) & """}"
  Response.End
End If

Response.Write "{""resultado"":""OK"",""id_eva"":" & idEva & ",""eva_rut"":""" & MrJsonSafe(rsDatos("EVA_RUT")) & """,""eva_nombre"":""" & MrJsonSafe(rsDatos("EVA_NOMBRE")) & """,""eva_emp"":""" & MrJsonSafe(rsDatos("EVA_EMP")) & """,""eva_est"":""" & MrJsonSafe(rsDatos("EVA_EST")) & """,""puntaje_evaluacion"":""" & MrJsonSafe(rsDatos("PUNTAJE_EVALUACION")) & """,""eva_com"":""" & MrJsonSafe(rsDatos("EVA_COM")) & """,""eva_com_cen"":""" & MrJsonSafe(rsDatos("EVA_COM_CEN")) & """}"

If rsDatos.State = 1 Then rsDatos.Close
Set rsDatos = Nothing
%>