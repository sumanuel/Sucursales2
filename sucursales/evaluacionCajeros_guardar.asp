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

Sub ObtenerUsuarioYPerfil(ByRef usuarioLog, ByRef perfilLog)
  Dim idUsrWinLocal, partesUsuarioLocal, usuarioWinLocal

  usuarioLog = Trim(Request("usuario_log") & "")
  perfilLog = Trim(Request("perfil_log") & "")

  If usuarioLog = "" Then
    idUsrWinLocal = Request.ServerVariables("LOGON_USER")
    If InStr(idUsrWinLocal, "\") > 0 Then
      partesUsuarioLocal = Split(idUsrWinLocal, "\")
      If UBound(partesUsuarioLocal) >= 1 Then
        usuarioWinLocal = partesUsuarioLocal(1)
      Else
        usuarioWinLocal = idUsrWinLocal
      End If
    Else
      usuarioWinLocal = idUsrWinLocal
    End If
    usuarioLog = Trim(usuarioWinLocal & "")
  End If

  If usuarioLog = "" Then
    If Session("id_usuario") <> "" Then
      usuarioLog = Trim(Session("id_usuario") & "")
    End If
    If usuarioLog = "" And Session("nombre_usuario") <> "" Then
      usuarioLog = Trim(Session("nombre_usuario") & "")
    End If
  End If

  If perfilLog = "" And Session("tipo") <> "" Then
    perfilLog = Trim(Session("tipo") & "")
  End If

  If usuarioLog = "" Then usuarioLog = "JEPS"
  If perfilLog = "" Then perfilLog = "General"
End Sub

Sub RegistrarLogGuardado(idRegistro, estadoEval, usuarioLog, perfilLog)
  Dim accionLog, sqlLog

  accionLog = "Guardar evaluacion"
  If CLng(estadoEval) = 2 Then
    accionLog = accionLog & " con estado Aprobado"
  ElseIf CLng(estadoEval) = 3 Then
    accionLog = accionLog & " con estado Reprobado"
  End If

  sqlLog = "IF NOT EXISTS ("
  sqlLog = sqlLog & "SELECT 1 FROM dbo.SUC_reporte_log "
  sqlLog = sqlLog & "WHERE funcionalidad='Evaluacion Cajeros' "
  sqlLog = sqlLog & "AND tipo_accion='" & SqlTexto(accionLog) & "' "
  sqlLog = sqlLog & "AND id_registro=" & CLng(idRegistro)
  sqlLog = sqlLog & ") "
  sqlLog = sqlLog & "EXEC dbo.SCSS_insertar_reporte_log "
  sqlLog = sqlLog & "@usuario='" & SqlTexto(usuarioLog) & "', "
  sqlLog = sqlLog & "@perfil='" & SqlTexto(perfilLog) & "', "
  sqlLog = sqlLog & "@funcionalidad='Evaluacion Cajeros', "
  sqlLog = sqlLog & "@tipo_accion='" & SqlTexto(accionLog) & "', "
  sqlLog = sqlLog & "@id_registro=" & CLng(idRegistro)

  DB.Execute sqlLog
End Sub

Sub Responder(resultado, mensaje)
  Response.Write "{""resultado"":""" & JsonSafe(resultado) & """,""mensaje"":""" & JsonSafe(mensaje) & """}"
  Response.End
End Sub

Dim idEva, evaCom, evaEst, respuestasTexto
Dim idUsrWin, partesUsuario, usuarioEval, perfilLog
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

Call ObtenerUsuarioYPerfil(usuarioEval, perfilLog)
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

Call RegistrarLogGuardado(idEva, evaEst, usuarioEval, perfilLog)

Responder "OK", mensajeSp
%>