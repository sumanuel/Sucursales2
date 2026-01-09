<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuario"))
perfil = trim(request("perfil"))
tipoConsulta = trim(request("consulta"))
traeDatos = trim(request("traeDatos"))
idSucursal = trim(request("idSucursal"))
fecha = trim(request("fecha"))

'response.write(traeDatos)
'response.end



if fecha <> "" then 
	fecha = cdate(fecha)
	diaFecha = formateaParaFecha(day(fecha))
	mesFecha = formateaParaFecha(month(fecha))
	anioFecha = year(fecha)
	fecha = anioFecha&"-"&mesFecha&"-"&diaFecha
end if
if tipoConsulta = "1" then
	if fecha = "" then
		sql = ""
		sql = sql & " select max(cast(cast(fecha_proceso as varchar(10)) as date)) "
		sql = sql & " as fecha_registro "
		sql = sql & " from SUC_index_lm_det "

		'response.write(sql)
		'response.end


		set rs=db.execute(sql)
		if not rs.eof then
			fecha = cdate(trim(rs("fecha_registro")))
		end if	
		diaFecha = formateaParaFecha(day(fecha))
		mesFecha = formateaParaFecha(month(fecha))
		anioFecha = year(fecha)
		fecha = anioFecha&"-"&mesFecha&"-"&diaFecha
	end if
	sql = ""
	sql = sql & " select "
	sql = sql & " id_registro, "
	sql = sql & " a.cod_bantotal, "
	sql = sql & " cod_sucursal, "
	sql = sql & " fecha_proceso, "
	sql = sql & " rut_empleador, "
	sql = sql & " razon_social, "
	sql = sql & " codigo_area,"
	sql = sql & " telefono, "
	sql = sql & " rut_trabajador, "
	sql = sql & " nombre, "
	sql = sql & " apellido_paterno, "
	sql = sql & " apellido_materno, "
	sql = sql & " edad, "
	sql = sql & " licencia, "
	sql = sql & " EST_LIC, "
	sql = sql & " EST_MAT, "
	sql = sql & " EST_FIS, "
	sql = sql & " COD_MOV, "
	sql = sql & " des_mov, "
	sql = sql & " A1_DIA_REP_TEX, "
	sql = sql & " PARTNER_TRA, "
	sql = sql & " PARTNER_EMP, "
	sql = sql & " PARTNER_FAE, "
	sql = sql & " estado, "
	sql = sql & " b.suc_nombre, "
	sql = sql & " fecha_proceso as fecha_registro "
	sql = sql & " from SUC_index_lm_det a, "
	sql = sql & " SUC_sucursal b "
	sql = sql & " where a.cod_sucursal = b.id_sucursal "
	if fecha <> "" then
		sql = sql & " and cast(cast(fecha_proceso as varchar(10)) as date) = '"&fecha&"'"
	else
		sql = sql & " and cast(cast(fecha_proceso as varchar(10)) as date) = "
		sql = sql & " (select max(cast(cast(fecha_proceso as varchar(10)) as date)) "
		sql = sql & " as fecha_registro "
		sql = sql & " from SUC_index_lm_det) "
	end if
	if traeDatos = "1" then
		sql = sql & " and a.cod_sucursal = '"&idSucursal&"'  "
	else
		if perfil = "1" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"')"
		end if
		if perfil = "2" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_zonales_sucursal "
			sql = sql & " where id_zonal = '"&idUsuario&"') "
		end if
	end if	

	set rs=db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & "<table>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		resultado = resultado & "<th>Sucursal</th>"
		resultado = resultado & "<th>Rut empleador</th>"
		resultado = resultado & "<th>Empresa</th>"
		resultado = resultado & "<th>Cod area</th>"
		resultado = resultado & "<th>Telefono empresa</th>"
		resultado = resultado & "<th>Fecha operacion</th>"
		resultado = resultado & "<th>Fecha ingreso</th>"
		resultado = resultado & "<th>Rut trabajador</th>"
		resultado = resultado & "<th>Nombre trabajador</th>"
		resultado = resultado & "<th>Apellido paterno trabajador</th>"
		resultado = resultado & "<th>Apellido materno trabajador</th>"
		resultado = resultado & "<th>Edad trabajador</th>"
		resultado = resultado & "<th>Numero licencia</th>"
		resultado = resultado & "<th>Est lic</th>"
		resultado = resultado & "<th>Est mat</th>"
		resultado = resultado & "<th>Est fis</th>"
		resultado = resultado & "<th>Cod mov</th>"
		resultado = resultado & "<th>Des mov</th>"
		resultado = resultado & "<th>Dias licencia</th>"
		resultado = resultado & "<th>Partner tra</th>"
		resultado = resultado & "<th>Partner emp</th>"
		resultado = resultado & "<th>Partner fae</th>"
		resultado = resultado & "<th>Estado</th>"
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		for i=0 to ubound(datos,2)
			idRegistro = trim(datos(0,i))
			codBantotal = trim(datos(1,i))
			codSucursal = trim(datos(2,i))
			fechaOperacion = trim(datos(3,i))
			rutEmpleador = trim(datos(4,i))
			empresa = server.htmlencode(trim(datos(5,i)))
			codArea = trim(datos(6,i))
			telefonoEmpresa = trim(datos(7,i))
			rutTrabajador = trim(datos(8,i))
			nombreTrabajador = server.htmlencode(trim(datos(9,i)))
			appPatTrabajador = server.htmlencode(trim(datos(10,i)))
			appMatTrabajador = server.htmlencode(trim(datos(11,i)))
			edad = trim(datos(12,i))
			licencia = server.htmlencode(trim(datos(13,i)))
			estLic = trim(datos(14,i))
			estMat = trim(datos(15,i))
			estFis = trim(datos(16,i))
			codMov = trim(datos(17,i))
			desMov = server.htmlencode(trim(datos(18,i)))
			diaRepTex = server.htmlencode(trim(datos(19,i)))
			partnerTra = server.htmlencode(trim(datos(20,i)))
			partnerEmp = server.htmlencode(trim(datos(21,i)))
			partnerFae = server.htmlencode(trim(datos(22,i)))
			estado = server.htmlencode(trim(datos(23,i)))
			sucursal = server.htmlencode(trim(datos(24,i)))
			fechaRegistro = trim(datos(25,i))
			
			resultado = resultado & "<tr>"
			resultado = resultado & "<td>"&sucursal&"</td>"
			resultado = resultado & "<td>"&rutEmpleador&"</td>"
			resultado = resultado & "<td>"&empresa&"</td>"
			resultado = resultado & "<td>"&codArea&"</td>"
			resultado = resultado & "<td>"&telefonoEmpresa&"</td>"
			resultado = resultado & "<td>"&fechaOperacion&"</td>"
			resultado = resultado & "<td>"&fechaRegistro&"</td>"
			resultado = resultado & "<td>"&rutTrabajador&"</td>"
			resultado = resultado & "<td>"&nombreTrabajador&"</td>"
			resultado = resultado & "<td>"&appPatTrabajador&"</td>"
			resultado = resultado & "<td>"&appMatTrabajador&"</td>"
			resultado = resultado & "<td>"&edad&"</td>"
			resultado = resultado & "<td>"&licencia&"</td>"
			resultado = resultado & "<td>"&estLic&"</td>"
			resultado = resultado & "<td>"&estMat&"</td>"
			resultado = resultado & "<td>"&estFis&"</td>"
			resultado = resultado & "<td>"&codMov&"</td>"
			resultado = resultado & "<td>"&desMov&"</td>"
			resultado = resultado & "<td>"&diaRepTex&"</td>"
			resultado = resultado & "<td>"&partnerTra&"</td>"
			resultado = resultado & "<td>"&partnerEmp&"</td>"
			resultado = resultado & "<td>"&partnerFae&"</td>"
			resultado = resultado & "<td>"&estado&"</td>"
			
			resultado = resultado & "</tr>"
		next
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	else
		resultado = ""
		resultado = resultado & "No existen registros"
	end if
	if traeDatos = "1" then
			archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Licencias Medicas "&"CodBTT"&codBantotal&".xls"
	else
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Licencias Medicas.xls"
	end if
end if

response.write(resultado)
Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo %>