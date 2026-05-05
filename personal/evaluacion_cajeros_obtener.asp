<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Expires = -1

Dim idEva
Dim rsEva
Dim sqlEva

Function JsonSafe(valor)
  If IsNull(valor) Then
    valor = ""
  End If
  valor = CStr(valor)
  valor = Replace(valor, "\", "\\")
  valor = Replace(valor, Chr(34), Chr(92) & Chr(34))
  valor = Replace(valor, vbCrLf, " ")
  valor = Replace(valor, vbCr, " ")
  valor = Replace(valor, vbLf, " ")
  JsonSafe = valor
End Function

Function FormatearFechaISO(valorFecha)
  If IsNull(valorFecha) Or Trim(CStr(valorFecha)) = "" Then
    FormatearFechaISO = ""
  Else
    FormatearFechaISO = Year(CDate(valorFecha)) & "-" & Right("0" & Month(CDate(valorFecha)), 2) & "-" & Right("0" & Day(CDate(valorFecha)), 2)
  End If
End Function

idEva = 0
If Trim(Request("id") & "") <> "" Then
  idEva = CLng(Request("id"))
End If

If idEva <= 0 Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""Identificador invalido.""}"
  Response.End
End If

sqlEva = "EXEC dbo.SP_SUC_listar_eva_cajero @ID_EVA = " & idEva & ", @TOP_REGISTROS = 1"
Set rsEva = db.Execute(sqlEva)

If rsEva.EOF Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""No se encontro la evaluacion indicada.""}"
  Response.End
End If

Response.Write "{""resultado"":""OK"",""id_eva"":" & idEva & ",""eva_rut"":""" & JsonSafe(rsEva("EVA_RUT")) & """,""eva_nombre"":""" & JsonSafe(rsEva("EVA_NOMBRE")) & """,""eva_suc"":""" & JsonSafe(rsEva("EVA_SUC")) & """,""eva_emp"":""" & JsonSafe(rsEva("EVA_EMP")) & """,""eva_fch_des"":""" & JsonSafe(FormatearFechaISO(rsEva("EVA_FCH_DES"))) & """,""eva_fch_has"":""" & JsonSafe(FormatearFechaISO(rsEva("EVA_FCH_HAS"))) & """}"

If rsEva.State = 1 Then
  rsEva.Close
End If
Set rsEva = Nothing
%>