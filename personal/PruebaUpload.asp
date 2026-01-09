<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
option explicit
Response.Expires = -1
Server.ScriptTimeout = 600
%>
<!-- #include file="freeaspupload.asp" -->
<%
' ****************************************************
' Cambiar el valor de la siguiente variable
' para indicar el directorio de destino.
' El directorio indicado debe tener permisos de escritura
' de caso contrario el script fallará mostrando un error.
  Dim uploadsDirVar,conex,rs,rs2,consulta,carpeta2
  Dim processOk, SaveFiles
  SaveFiles = ""
  processOk = -1
'  carpeta2=session("carpeta")
  'uploadsDirVar = "E:\inetpub\wwwroot\sucursales2\upload"
  'uploadsDirVar = "C:\inetpub\wwwroot\pro\sucursales2\upload"
  'uploadsDirVar = "D:\Aplicaciones\pro\sucursales2\upload"
  uploadsDirVar = "F:\APP_SC\sucursales2\upload"
  'response.Write(uploadsDirVar)
  'response.End()

' ****************************************************
if Request.ServerVariables("REQUEST_METHOD") = "POST" then
	Dim Upload, fileName, fileSize, ks, i, fileKey, resumen, nombreArchivo
    Set Upload = New FreeASPUpload
    Upload.Save(uploadsDirVar)
	' If something fails inside the script, but the exception is handled
	If Not Err.Number <> 0 then
		SaveFiles = ""
		ks = Upload.UploadedFiles.keys
		if (UBound(ks) <> -1) then
			resumen = "<span class='TextoNegroTablas'><B>Archivos subidos:</B> "

			for each fileKey in Upload.UploadedFiles.keys
				nombreArchivo = Upload.UploadedFiles(fileKey).FileName
				if nombreArchivo = "titulares.csv" or nombreArchivo = "reemplazos.csv" then
					resumen = resumen & Upload.UploadedFiles(fileKey).FileName & " (" & Upload.UploadedFiles(fileKey).Length & "B)</span> "


				end if
			next
			processOk = 1
		else
			resumen = "<span class='TextoNegroTablas'>El nombre del archivo especificado en el formulario no es valido en el sistema.</span>"
			processOk = 0
		end if
	end if
	'comentar la siguiente linea si no se desea mostrar el resumen
	SaveFiles = resumen
end if


'function SaveFiles
'    Dim Upload, fileName, fileSize, ks, i, fileKey, resumen
'    Set Upload = New FreeASPUpload
'    Upload.Save(uploadsDirVar)
'	' If something fails inside the script, but the exception is handled
'	If Err.Number <> 0 then Exit function
'    SaveFiles = ""
'    ks = Upload.UploadedFiles.keys
'    if (UBound(ks) <> -1) then
'		resumen = "<span class='TextoNegroTablas'><B>Archivos subidos:</B> "
'        for each fileKey in Upload.UploadedFiles.keys
'			resumen = resumen & Upload.UploadedFiles(fileKey).FileName & " (" & Upload.UploadedFiles(fileKey).Length & "B)</span> "
'        next
'		processOk = 1
'    else
'		resumen = "<span class='TextoNegroTablas'>El nombre del archivo especificado en el formulario no es valido en el sistema.</span>"
'		processOk = 0
'    end if
'	'comentar la siguiente linea si no se desea mostrar el resumen
'	SaveFiles = resumen
'end function
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Subir Listado de Cajeros</title>
</head>
<body>
<form name="frmSend" id="frmSend" method="POST" enctype="multipart/form-data" action="pruebaupload.asp">
<input type="hidden" name="statusProcess" id="statusProcess" value="<%=processOk%>"/>
<table width="90%">
	<tr>
    	<td class="TextoNegro">Documento:</td>
        <td><input name="attach1" type="file" size="45"></td>
    </tr>
    <tr>
    	<td class="TextoNegro" colspan="2" align="left">&nbsp;</td>
    </tr>
    <tr>
    	<td class="TextoNegro" colspan="2" align="center"><input type=submit value="Subir documento"></td>
    </tr>
    <tr>
    	<td class="TextoNegro" colspan="2" align="center">&nbsp;</td>
    </tr>
    <tr>
    	<td class="TextoNegro" colspan="2" align="center"><%=SaveFiles%></td>
    </tr>
</table>
</form>
</body>
</html>
<%
'solo llamo al UPLOAD si hay envio de formulario
'if Request.ServerVariables("REQUEST_METHOD") = "POST" then
'	'Hace el upload de los archivos enviados y muestra el resumen
'	response.write SaveFiles()
'end if
%>
