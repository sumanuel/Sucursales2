<%@ Language=VBScript %>
<%
Response.ContentType = "application/json"
Response.Charset = "utf-8"
%>
<!--#include file="../conexion/conexion.asp"-->
<%
On Error Resume Next
Dim idEva, resultadoCentral
Dim cmd, rs, resultadoSp, mensajeSp, idRetornado

idEva = Trim(Request.Form("id_eva") & "")
resultadoCentral = Trim(Request.Form("eva_com_cen") & "")

If idEva = "" Or Not IsNumeric(idEva) Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""ID requerido""}"
  Response.End
End If

Set cmd = Server.CreateObject("ADODB.Command")
cmd.ActiveConnection = db
cmd.CommandType = 4
cmd.CommandText = "SP_SUC_actualizar_ges_eva_cajero_central"
cmd.Parameters.Append cmd.CreateParameter("@ID_EVA", 3, 1, , CLng(idEva))
cmd.Parameters.Append cmd.CreateParameter("@EVA_COM_CEN", 200, 1, 250, resultadoCentral)

Set rs = cmd.Execute
If Err.Number <> 0 Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & Replace(Err.Description, Chr(34), "'") & """}"
Else
  If Not rs.EOF Then
    resultadoSp = rs("resultado")
    mensajeSp = rs("mensaje")
    If resultadoSp = "OK" Then
      idRetornado = rs("id_eva")
      If IsNull(idRetornado) Or idRetornado = "" Then idRetornado = 0
      Response.Write "{""resultado"":""OK"",""mensaje"":""" & Replace(mensajeSp, Chr(34), "'") & """,""id_eva"":" & CLng(idRetornado) & "}"
    Else
      Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & Replace(mensajeSp, Chr(34), "'") & """}"
    End If
  Else
    Response.Write "{""resultado"":""OK"",""mensaje"":""Registro actualizado correctamente.""}"
  End If
End If
%>