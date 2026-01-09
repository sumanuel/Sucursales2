<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuario"))
perfil = trim(request("perfil"))
tipoConsulta = trim(request("consulta"))
traeDatos = trim(request("traeDatos"))
idSucursal = trim(request("idSucursal"))
fecha = trim(request("fecha"))

'response.write("")


if fecha <> "" then 
	fecha = cdate(fecha)
	diaFecha = formateaParaFecha(day(fecha))
	mesFecha = formateaParaFecha(month(fecha))
	anioFecha = year(fecha)
	fecha = anioFecha&"-"&mesFecha&"-"&diaFecha
else
	sql = ""
	sql = sql & " select max(fecha_reg) as fecha_respaldo "
	sql = sql & " from SUC_sucursal_asistencia_personal_respaldo "	
	
	set rs = db.execute(sql)
	if not rs.eof then
		fecha = trim(cdate(rs("fecha_respaldo")))
	end if
	diaFecha = formateaParaFecha(day(fecha))
	mesFecha = formateaParaFecha(month(fecha))
	anioFecha = year(fecha)
	fecha = anioFecha&"-"&mesFecha&"-"&diaFecha
end if
if tipoConsulta = "1" then
	sql = ""
	sql = sql & "select "	
	sql = sql & "a.bt_sucursal, "
	sql = sql & "b.suc_nombre, "
	sql = sql & "a.rut_personal, "
	sql = sql & "a.nombre_personal, "	
	sql = sql & "isnull(a.tipo_personal, '') as tipo_personal, "
	sql = sql & "isnull(a.tipo, '') as tipo, "
	sql = sql & "isnull(a.empresa, '') as empresa, "
	sql = sql & "isnull(a.asistencia, '') as asistencia, "
	sql = sql & "isnull(a.hora_llegada, '') as hora_llegada, "
	sql = sql & "isnull(a.min_llegada, '') as min_llegada, "
	sql = sql & "isnull(a.hora_salida, '') as hora_salida, "
	sql = sql & "isnull(a.min_salida, '') as min_salida, "
	sql = sql & "a.fecha_respaldo "
	sql = sql & "from SUC_sucursal_asistencia_personal_respaldo a "
	sql = sql & "inner join SUC_sucursal b on a.id_sucursal = b.id_sucursal "	
	if fecha <> "" then
		sql = sql & " where a.fecha_reg = '"&fecha&"'  "	
	end if	
	if traeDatos = "1" then
		sql = sql & " and a.id_sucursal = '"&idSucursal&"' "
	else
		if perfil = "1" then
			sql = sql & "and a.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"')"
		end if
		if perfil = "2" then
			sql = sql & " and a.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_zonales_sucursal "
			sql = sql & " where id_zonal = '"&idUsuario&"') "
		end if
	end if
	'response.write(sql)
	'response.end

	set rs=db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & "<table>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		resultado = resultado & "<th>Cod BT</th>"
		resultado = resultado & "<th>Sucursal</th>"
		resultado = resultado & "<th>Rut Personal</th>"
		resultado = resultado & "<th>Nombre Personal</th>"
		resultado = resultado & "<th>Cargo</th>"
		resultado = resultado & "<th>Tipo</th>"
		resultado = resultado & "<th>Empresa</th>"
		resultado = resultado & "<th>Asistencia</th>"
		resultado = resultado & "<th>Hora Llegada</th>"		
		resultado = resultado & "<th>Hora Salida</th>"		
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		for i=0 to ubound(datos,2)
			cod_bt = trim(datos(0,i))
			nombreSucursal = trim(datos(1,i))
			rut_personal = trim(datos(2,i))
			nombre_personal = server.htmlencode(trim(datos(3,i)))
			cargo = server.htmlencode(trim(datos(4,i)))
			tipo = server.htmlencode(trim(datos(5,i)))
			empresa = server.htmlencode(trim(datos(6,i)))
			asistencia = trim(datos(7,i))
			hora_llegada = trim(datos(8,i))
			min_llegada = trim(datos(9,i))
			hora_salida = trim(datos(10,i))
			min_salida = trim(datos(11,i))		
		
			xHoraEntrada = ""
			xHoraSalida = ""				
			
			if not hora_llegada = "" then
				if CInt(hora_llegada) < 0 then
					hora_llegada = "0"&hora_llegada
				end if 
				if CInt(min_llegada) < 0 then
					min_llegada = "0"&min_llegada
				end if 				
				xHoraEntrada = hora_llegada&":"&min_llegada
			end if
			
			if not hora_salida = "" then
				if CInt(hora_salida) < 0 then
					hora_salida = "0"&hora_salida
				end if 
				if CInt(min_salida) < 0 then
					min_salida = "0"&min_salida
				end if 				
				xHoraSalida = hora_salida&":"&min_salida
			end if

			resultado = resultado & "<tr>"
			resultado = resultado & "<td>"&cod_bt&"</td>"
			resultado = resultado & "<td>"&nombreSucursal&"</td>"
			resultado = resultado & "<td>"&rut_personal&"</td>"
			resultado = resultado & "<td>"&nombre_personal&"</td>"
			resultado = resultado & "<td>"&cargo&"</td>"
			resultado = resultado & "<td>"&tipo&"</td>"
			resultado = resultado & "<td>"&empresa&"</td>"
			resultado = resultado & "<td>"&asistencia&"</td>"
			resultado = resultado & "<td>"&xHoraEntrada&"</td>"			
			resultado = resultado & "<td>"&xHoraSalida&"</td>"			
			resultado = resultado & "</tr>"
		next
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	else
		resultado = "No existen datos"
	end if
	'archivo = fecha&" Asistencia_Personal.xls"
	if traeDatos = "1" then
			archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Asistencia_Personal "&"cod_bt-"&cod_bt&".xls"
	else
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Asistencia_Personal.xls"
	end if
end if
response.write(resultado)
Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo 
%>