<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.CodePage = 65001
Response.CharSet = "utf-8"
Response.Expires = -1
On Error Resume Next

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

Function SqlTexto(valor)
  SqlTexto = Replace(CStr(valor), "'", "''")
End Function

Sub Responder(resultado, mensaje)
  Response.Write "{""resultado"":""" & JsonSafe(resultado) & """,""mensaje"":""" & JsonSafe(mensaje) & """}"
  Response.End
End Sub

Dim idEva, evaCom, evaEst, respuestasTexto
Dim idUsrWin, partesUsuario, usuarioEval
Dim cmd, rsResultado, resultadoSp, mensajeSp

idEva = 0
If Trim(Request("id_eva") & "") <> "" And IsNumeric(Request("id_eva")) Then
  idEva = CLng(Request("id_eva"))
End If
If idEva <= 0 Then
  Responder "ERROR", "El identificador de la evaluacion es obligatorio."
End If

evaCom = Trim(Request("eva_com") & "")
If Len(evaCom) > 250 Then
  Responder "ERROR", "La observacion no puede exceder 250 caracteres."
End If

evaEst = 0
If Trim(Request("eva_est") & "") <> "" And IsNumeric(Request("eva_est")) Then
  evaEst = CLng(Request("eva_est"))
End If
If evaEst <> 2 And evaEst <> 3 Then
  Responder "ERROR", "Debe seleccionar un estado valido para la evaluacion."
End If

respuestasTexto = Trim(Request("respuestas") & "")
If respuestasTexto = "" Then
  Responder "ERROR", "Debe enviar las respuestas de la evaluacion."
End If

idUsrWin = Request.ServerVariables("LOGON_USER")
usuarioEval = Trim(idUsrWin & "")
If InStr(usuarioEval, "\") > 0 Then
  partesUsuario = Split(usuarioEval, "\")
  If UBound(partesUsuario) >= 1 Then
    usuarioEval = Trim(partesUsuario(1) & "")
  End If
End If
If usuarioEval = "" Then
  usuarioEval = "JEPS"
End If
If Len(usuarioEval) > 50 Then
  usuarioEval = Left(usuarioEval, 50)
End If

Set cmd = Server.CreateObject("ADODB.Command")
cmd.ActiveConnection = DB
cmd.NamedParameters = True
cmd.CommandType = 4
cmd.CommandText = "dbo.SP_SUC_guardar_eva_cajero"
cmd.Parameters.Append cmd.CreateParameter("@ID_EVA", 3, 1, , idEva)
cmd.Parameters.Append cmd.CreateParameter("@EVA_COM", 200, 1, 250, evaCom)
cmd.Parameters.Append cmd.CreateParameter("@EVA_EST", 2, 1, , evaEst)
cmd.Parameters.Append cmd.CreateParameter("@RESPUESTAS", 201, 1, Len(respuestasTexto), respuestasTexto)
cmd.Parameters.Append cmd.CreateParameter("@EVA_USR", 200, 1, 50, usuarioEval)

Set rsResultado = cmd.Execute
If Err.Number <> 0 Then
  Responder "ERROR", Err.Description
End If

If rsResultado.EOF Then
  Responder "ERROR", "No se obtuvo respuesta al guardar la evaluacion."
End If

resultadoSp = Trim(rsResultado("resultado") & "")
mensajeSp = Trim(rsResultado("mensaje") & "")

If UCase(resultadoSp) <> "OK" Then
  Responder "ERROR", mensajeSp
End If

Responder "OK", mensajeSp
%>