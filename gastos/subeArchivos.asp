<%
Response.Expires = -1
Server.ScriptTimeout = 600
Session.CodePage  = 65001
idZonal = request("idZonal")
tipo = trim(request("tipo"))

%>
<!-- #include file="../librerias/freeaspupload.asp" -->
<!-- #include file="../funciones.asp" -->
<!--#include file="../conexion/conexion.asp"-->
<%Dim uploadsDirVar
response.write guardaArchivos()



function guardaArchivos
    Dim Upload, fileName, fileSize, ks, i, fileKey
    Set Upload = New FreeASPUpload  
    set fs=Server.CreateObject("Scripting.FileSystemObject")
	path =server.mappath("archivos\"&idZonal&"\"&tipo)

	
	carpeta = creaCarpeta("archivos\"&idZonal)
	carpeta = creaCarpeta("archivos\"&idZonal&"\"&tipo)
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
   	gasto = Upload.Form("monto")
	titulo = Upload.Form("titulo")
	obs = Upload.Form("observacion")
	fecha = Upload.Form("fecha")
	fecha=cdate(fecha)
	mesFecha = formateaParaFecha(month(fecha))
	anioFecha= year(fecha)
	sql = ""
	sql = sql & " select id_zonal_ppto "
	sql = sql & " from SUC_zonales_ppto "
	sql = sql & " where id_zonal = '"&idZonal&"' "
	sql = sql & " and id_zonal_ppto_tipo = '"&tipo&"' "
	sql = sql & " and zonal_ppto_mes = month(getdate()) "
	sql = sql & " and zonal_ppto_ano = year(GETDATE()) "
	set rs = db.execute(sql)
	if not rs.eof then
		id_zonal_ppto = trim(rs(0))
	end if

	sql = ""
	sql = sql & " set dateformat dmy "
	sql = sql & " insert into SUC_zonales_ppto_gastos "
	sql = sql & "( id_zonal, "
	sql = sql &	" id_zonal_ppto, "
	sql = sql & " id_zonal_ppto_tipo, "
	sql = sql & " zonal_ppto_gasto, "
	sql = sql & " zonal_ppto_gasto_titulo, "
	sql = sql & " zonal_ppto_gasto_obs, "
	sql = sql & " zonal_ppto_gasto_fecha, "
	sql = sql & " zonal_ppto_gasto_mes, "
	sql = sql & " zonal_ppto_gasto_ano, "
	sql = sql & " fecha_registro, "
	sql = sql & " hora_registro "
	sql = sql & ")"
	sql = sql & " values ( "
	sql = sql & " '"&idZonal&"', "
	sql = sql & " '"&id_zonal_ppto&"', "
	sql = sql & " '"&tipo&"', "
	sql = sql & " '"&gasto&"', " 
	sql = sql & " '"&titulo&"', "
	sql = sql & " '"&obs&"', "
	sql = sql & " '"&fecha&"', "
	sql = sql & " '"&mesFecha&"', "
	sql = sql & " '"&anioFecha&"', "
	sql = sql & " cast(getdate() as date), cast(getdate() as time) ) "
	db.execute(sql)

	sql = ""
	sql = sql & "select max(id_zonal_ppto_gasto) from SUC_zonales_ppto_gastos "
	set rs = db.execute(sql)
	if not rs.eof then
		idRegistro = trim(rs(0))
	end if
	guardaArchivos = fileKey
    if (UBound(ks) <> -1) then
		guardaArchivos = guardaArchivos  & "<ul>"
		
		processOk = 1
		for each fileKey in Upload.UploadedFiles.keys
			nombreArchivo = Upload.UploadedFiles(fileKey).FileName	    	
	    	nuevoNombre= idRegistro&"-"&idZonal&"-"&tipo&"-"&nuevaFecha
	    	nombreArchivoNuevo = renombraArchivos("archivos\"&idZonal&"\"&tipo,nombreArchivo,nuevoNombre)
''
	    	sql = ""
	    	sql = sql & "update SUC_zonales_ppto_gastos "
	    	sql = sql & " set zonal_ppto_gasto_archivo = '"&nombreArchivoNuevo&"' where id_zonal_ppto_gasto = '"&idRegistro&"' "
	    	db.execute(sql)

		   	pesoArchivo = Upload.UploadedFiles(fileKey).Length
	    	pesoArchivo = FormatNumber((clng(pesoArchivo) / 1024)/1024,2)
		next
		guardaArchivos = guardaArchivos & "</ul>"
	end if
			guardaArchivos = guardaArchivos & "<li>"
		   	guardaArchivos = guardaArchivos & " Se guardaron los datos. Presione el boton Cerrar"
			guardaArchivos = guardaArchivos & "</li>"
			guardaArchivos = guardaArchivos & "</ul>"

end function
%>