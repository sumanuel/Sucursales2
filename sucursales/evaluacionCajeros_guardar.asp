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
Dim rsEva, rsPreguntas, rsTmp, sql
Dim preguntasDict, respuestasDict
Dim arrRespuestas, itemRespuesta, partesRespuesta
Dim preId, valorRespuesta, key
Dim recordsAffected

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

Set preguntasDict = Server.CreateObject("Scripting.Dictionary")
Set respuestasDict = Server.CreateObject("Scripting.Dictionary")

Set rsPreguntas = DB.Execute("EXEC dbo.SP_SUC_obtener_pre_eva_cajero")
If Err.Number <> 0 Then
  Responder "ERROR", Err.Description
End If
If rsPreguntas.EOF Then
  Responder "ERROR", "No hay items habilitados para evaluar."
End If
If UCase(Trim(rsPreguntas.Fields(0).Name & "")) = "RESULTADO" Then
  Responder "ERROR", Trim(rsPreguntas("mensaje") & "")
End If
Do While Not rsPreguntas.EOF
  preguntasDict(Trim(rsPreguntas("PRE_ID_PRE") & "")) = ""
  rsPreguntas.MoveNext
Loop
If rsPreguntas.State = 1 Then rsPreguntas.Close
Set rsPreguntas = Nothing

arrRespuestas = Split(respuestasTexto, "|")
For Each itemRespuesta In arrRespuestas
  itemRespuesta = Trim(itemRespuesta & "")
  If itemRespuesta <> "" Then
    partesRespuesta = Split(itemRespuesta, ":")
    If UBound(partesRespuesta) <> 1 Then
      Responder "ERROR", "El formato de las respuestas es invalido."
    End If

    preId = Trim(partesRespuesta(0) & "")
    valorRespuesta = Trim(partesRespuesta(1) & "")

    If Not IsNumeric(preId) Then
      Responder "ERROR", "El item evaluado es invalido."
    End If
    If Not preguntasDict.Exists(preId) Then
      Responder "ERROR", "Se recibio un item que no esta habilitado para evaluar."
    End If
    If Not IsNumeric(valorRespuesta) Then
      Responder "ERROR", "La respuesta de uno de los items no es valida."
    End If
    valorRespuesta = CLng(valorRespuesta)
    If valorRespuesta <> 0 And valorRespuesta <> 1 And valorRespuesta <> 2 Then
      Responder "ERROR", "La respuesta de uno de los items no es valida."
    End If
    If respuestasDict.Exists(preId) Then
      Responder "ERROR", "No se puede responder un mismo item mas de una vez."
    End If

    respuestasDict(preId) = valorRespuesta
  End If
Next

If respuestasDict.Count <> preguntasDict.Count Then
  Responder "ERROR", "Debe responder todos los items habilitados del formulario."
End If

Err.Clear
DB.BeginTrans
If Err.Number <> 0 Then
  Responder "ERROR", Err.Description
End If

Set rsEva = DB.Execute("SELECT ID_EVA, EVA_EST FROM dbo.SUC_CAP_EVA WITH (UPDLOCK, HOLDLOCK) WHERE ID_EVA = " & idEva)
If Err.Number <> 0 Then
  DB.RollbackTrans
  Responder "ERROR", Err.Description
End If
If rsEva.EOF Then
  DB.RollbackTrans
  Responder "ERROR", "No existe la evaluacion indicada."
End If
If CLng(rsEva("EVA_EST")) <> 1 Then
  If rsEva.State = 1 Then rsEva.Close
  Set rsEva = Nothing
  DB.RollbackTrans
  Responder "ERROR", "Esta evaluacion ya fue registrada y no puede repetirse."
End If
If rsEva.State = 1 Then rsEva.Close
Set rsEva = Nothing

Set rsTmp = DB.Execute("SELECT TOP 1 ID_EVA FROM dbo.SUC_CAP_RES WHERE ID_EVA = " & idEva)
If Err.Number <> 0 Then
  DB.RollbackTrans
  Responder "ERROR", Err.Description
End If
If Not rsTmp.EOF Then
  If rsTmp.State = 1 Then rsTmp.Close
  Set rsTmp = Nothing
  DB.RollbackTrans
  Responder "ERROR", "Esta evaluacion ya fue registrada y no puede repetirse."
End If
If rsTmp.State = 1 Then rsTmp.Close
Set rsTmp = Nothing

For Each key In respuestasDict.Keys
  sql = "INSERT INTO dbo.SUC_CAP_RES (PRE_ID_PRE, ID_EVA, RES_RES) VALUES (" & CLng(key) & ", " & idEva & ", " & CLng(respuestasDict(key)) & ")"
  Err.Clear
  DB.Execute sql, recordsAffected
  If Err.Number <> 0 Then
    DB.RollbackTrans
    Responder "ERROR", Err.Description
  End If
Next

sql = "UPDATE dbo.SUC_CAP_EVA SET "
sql = sql & "EVA_COM = "
If evaCom = "" Then
  sql = sql & "NULL, "
Else
  sql = sql & "'" & SqlTexto(evaCom) & "', "
End If
sql = sql & "EVA_EST = " & evaEst & ", "
sql = sql & "EVA_USR = '" & SqlTexto(usuarioEval) & "', "
sql = sql & "EVA_FCH = GETDATE() "
sql = sql & "WHERE ID_EVA = " & idEva & " AND EVA_EST = 1"
Err.Clear
DB.Execute sql, recordsAffected
If Err.Number <> 0 Then
  DB.RollbackTrans
  Responder "ERROR", Err.Description
End If
If CLng(recordsAffected) <= 0 Then
  DB.RollbackTrans
  Responder "ERROR", "No fue posible actualizar el estado de la evaluacion."
End If

Err.Clear
DB.CommitTrans
If Err.Number <> 0 Then
  On Error Resume Next
  DB.RollbackTrans
  Responder "ERROR", Err.Description
End If

Responder "OK", "La evaluacion fue guardada correctamente."
%>