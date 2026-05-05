<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.Expires = -1
Server.ScriptTimeout = 600
%>
<!--#include file="freeASPUpload.asp"-->
<%
Dim uploadsDirVar
Dim processOk
Dim mensaje
Dim nombreArchivo
Dim pesoArchivo
Dim resumenPeso
Dim upload
Dim ks
Dim fileKey
Dim fs
Dim archivoTemporal
Dim archivoDestino
Dim extensionArchivo

processOk = 0
mensaje = ""
nombreArchivo = ""
pesoArchivo = 0
resumenPeso = ""
uploadsDirVar = "F:\APP_SC\sucursales2\upload"

Function JsSafe(valor)
    If IsNull(valor) Then
        valor = ""
    End If

    valor = CStr(valor)
    valor = Replace(valor, "\", "\\")
    valor = Replace(valor, "'", "\'")
    valor = Replace(valor, vbCrLf, " ")
    valor = Replace(valor, vbCr, " ")
    valor = Replace(valor, vbLf, " ")
    JsSafe = valor
End Function

Function FormatearPeso(bytes)
    If IsNull(bytes) Or bytes = "" Then
        FormatearPeso = ""
    ElseIf CLng(bytes) >= 1048576 Then
        FormatearPeso = Replace(FormatNumber(CDbl(bytes) / 1048576, 2), ",", "") & " MB"
    ElseIf CLng(bytes) >= 1024 Then
        FormatearPeso = Replace(FormatNumber(CDbl(bytes) / 1024, 2), ",", "") & " KB"
    Else
        FormatearPeso = CStr(bytes) & " B"
    End If
End Function

Sub Responder(resultado, mensajeTexto, archivo, peso)
    Response.Write "<html><body><script type=""text/javascript"">"
    Response.Write "if(window.parent && window.parent.onEvaluacionCajerosUploadCompleto){window.parent.onEvaluacionCajerosUploadCompleto({"
    Response.Write "resultado:'" & JsSafe(resultado) & "',"
    Response.Write "mensaje:'" & JsSafe(mensajeTexto) & "',"
    Response.Write "archivo:'" & JsSafe(archivo) & "',"
    Response.Write "peso:'" & JsSafe(peso) & "'"
    Response.Write "});}"
    Response.Write "</script></body></html>"
End Sub

If Request.ServerVariables("REQUEST_METHOD") <> "POST" Then
    Call Responder("ERROR", "Solicitud invalida.", "", "")
    Response.End
End If

On Error Resume Next
Set upload = New FreeASPUpload
upload.Save uploadsDirVar
If Err.Number <> 0 Then
    mensaje = "No fue posible subir el archivo: " & Err.Description
    Call Responder("ERROR", mensaje, "", "")
    Response.End
End If
On Error GoTo 0

ks = upload.UploadedFiles.Keys
If UBound(ks) = -1 Then
    Call Responder("ERROR", "Debe seleccionar un archivo CSV.", "", "")
    Response.End
End If

For Each fileKey In upload.UploadedFiles.Keys
    nombreArchivo = upload.UploadedFiles(fileKey).FileName
    pesoArchivo = upload.UploadedFiles(fileKey).Length
    archivoTemporal = upload.UploadedFiles(fileKey).Path
    Exit For
Next

extensionArchivo = LCase(Mid(nombreArchivo, InStrRev(nombreArchivo, ".") + 1))
If extensionArchivo <> "csv" Then
    Call Responder("ERROR", "El archivo debe tener extension .csv.", nombreArchivo, FormatearPeso(pesoArchivo))
    Response.End
End If

Set fs = Server.CreateObject("Scripting.FileSystemObject")
If Right(uploadsDirVar, 1) <> "\" Then
    uploadsDirVar = uploadsDirVar & "\"
End If
archivoDestino = uploadsDirVar & "evaluacion_cajeros.csv"

On Error Resume Next
If LCase(archivoTemporal) <> LCase(archivoDestino) Then
    If fs.FileExists(archivoDestino) Then
        fs.DeleteFile archivoDestino, True
    End If
    fs.MoveFile archivoTemporal, archivoDestino
End If
If Err.Number <> 0 Then
    mensaje = "No fue posible preparar el archivo para procesarlo: " & Err.Description
    Call Responder("ERROR", mensaje, nombreArchivo, FormatearPeso(pesoArchivo))
    Response.End
End If
On Error GoTo 0

resumenPeso = FormatearPeso(pesoArchivo)
Call Responder("OK", "Archivo subido correctamente.", nombreArchivo, resumenPeso)
%>