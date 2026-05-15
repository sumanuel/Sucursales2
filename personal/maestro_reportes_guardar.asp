<%@ Language=VBScript %>
<%
Response.ContentType = "application/json"
Response.Charset = "utf-8"
%>
<!--#include file="../conexion/conexion.asp"-->
<%
On Error Resume Next
Dim idEva, resultadoCentral, usuarioLog, perfilLog
Dim cmd, rs, resultadoSp, mensajeSp, idRetornado
Dim idUsrWin, usuarios, usuarioWin

idEva = Trim(Request.Form("id_eva") & "")
resultadoCentral = Trim(Request.Form("eva_com_cen") & "")

If idEva = "" Or Not IsNumeric(idEva) Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""ID requerido""}"
  Response.End
End If

usuarioLog = Trim(Request.Form("usuario_log") & "")
perfilLog = Trim(Request.Form("perfil_log") & "")

If usuarioLog = "" Then
  idUsrWin = Request.ServerVariables("LOGON_USER")
  If idUsrWin <> "" Then
    usuarios = Split(idUsrWin, "\")
    If UBound(usuarios) >= 1 Then
      usuarioWin = usuarios(1)
    Else
      usuarioWin = idUsrWin
    End If
    usuarioLog = Trim(usuarioWin & "")
  End If
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

If usuarioLog = "" Then usuarioLog = "Sistema"
If perfilLog = "" Then perfilLog = "General"

Set cmd = Server.CreateObject("ADODB.Command")
cmd.ActiveConnection = db
cmd.CommandType = 4
cmd.CommandText = "SP_SUC_actualizar_ges_eva_cajero_central"
cmd.Parameters.Append cmd.CreateParameter("@ID_EVA", 3, 1, , CLng(idEva))
cmd.Parameters.Append cmd.CreateParameter("@EVA_COM_CEN", 200, 1, 250, resultadoCentral)
cmd.Parameters.Append cmd.CreateParameter("@EVA_USR", 200, 1, 50, usuarioLog)
cmd.Parameters.Append cmd.CreateParameter("@EVA_PERFIL", 200, 1, 50, perfilLog)

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