
<%
Response.Expires = -1
Server.ScriptTimeout = 600
Session.CodePage  = 65001
idSucursal = request("idSucursal")
%>
<!-- #include file="freeaspupload.asp" -->
<!-- #include file="../funciones.asp" -->
<!--#include file="../conexion/conexion.asp"-->
<%Dim uploadsDirVar
response.write guardaArchivos()



function guardaArchivos
    Dim Upload, fileName, fileSize, ks, i, fileKey
    Set Upload = New FreeASPUpload  
    set fs=Server.CreateObject("Scripting.FileSystemObject")
	path =server.mappath("archivos\"&idSucursal)

	if idSucursal = "" then 
		response.redirect("upload.asp?accion=1")
	end if
	carpeta = creaCarpeta("archivos\"&idSucursal)
	'guardaArchivos =path
    Upload.Save(path)
	If Err.Number<>0 then Exit function
    guardaArchivos = ""
    ks = Upload.UploadedFiles.keys
    fechaActual = date()
	diaFechaActual = formateaParaFecha(day(fechaActual))
	mesFechaActual = formateaParaFecha(month(fechaActual))
	anioFechaActual = year(fechaActual)
	nuevaFecha = diaFechaActual&mesFechaActual&anioFechaActual
   	
   	guardaArchivos = fileKey
    if (UBound(ks) <> -1) then
		guardaArchivos = guardaArchivos  & "<ul>"
		
		processOk = 1
		for each fileKey in Upload.UploadedFiles.keys
			
			fechaAudutoria = Upload.Form("fechaAudutoria")
			observacion = Upload.Form("observacion")
			evaluacion = Upload.Form("evaluacion")
			puntaje = Upload.Form("puntaje")
			nombreArchivo = Upload.UploadedFiles(fileKey).FileName

			sql = ""
			sql = sql & " set dateformat dmy "
			sql = sql & " insert into SUC_sucursal_auditoria "
			sql = sql & "( id_sucursal, "
			sql = sql &	" archivo, "
			sql = sql & " fecha_auditoria, "
			sql = sql & " observacion, "
			sql = sql & " evaluacion, "
			sql = sql & " puntaje "
			sql = sql & ")"
			sql = sql & " values ( "
			sql = sql & " '"&idSucursal&"', "
			sql = sql & " '"&nombreArchivo&"', "
			sql = sql & " '"&fechaAudutoria&"', "
			sql = sql & " '"&observacion&"', "
			sql = sql & " '"&evaluacion&"', "
			sql = sql & " '"&puntaje&"' ) "
			db.execute(sql)

			sql = ""
			sql = sql & "select max(id_auditoria) from SUC_sucursal_auditoria "
			set rs = db.execute(sql)
			if not rs.eof then
				idRegistro = trim(rs(0))
			end if

	    	
	    	nuevoNombre= idRegistro&"-"&idSucursal&"-"&nuevaFecha

	    	nombreArchivoNuevo = renombraArchivos("archivos\"&idSucursal,nombreArchivo,nuevoNombre)

	    	sql = ""
	    	sql = sql & "update SUC_sucursal_auditoria set archivo = '"&nombreArchivoNuevo&"' where id_auditoria = '"&idRegistro&"' "
	    	db.execute(sql)

		   	pesoArchivo = Upload.UploadedFiles(fileKey).Length
	    	pesoArchivo = FormatNumber((clng(pesoArchivo) / 1024)/1024,2)
		   	guardaArchivos = guardaArchivos & "<li>"
		   	guardaArchivos = guardaArchivos & " se guardo correctamente el archivo : "&nombreArchivoNuevo&" ("&pesoArchivo&" MB)"
			guardaArchivos = guardaArchivos & "</li>"
		next
		guardaArchivos = guardaArchivos & "</ul>"
	end if
end function
%>