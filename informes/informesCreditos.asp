<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuario"))
perfil = trim(request("perfil"))
tipoConsulta = trim(request("consulta"))
traeDatos = trim(request("traeDatos"))
idSucursal = trim(request("idSucursal"))
fecha = trim(request("fecha"))

'Response.Write(cdate(fecha))
'Response.End()

if fecha <> "" then 
	fecha = cdate(fecha)
	diaFecha = formateaParaFecha(day(fecha))
	mesFecha = formateaParaFecha(month(fecha))
	anioFecha = year(fecha)
	fecha = anioFecha&"-"&mesFecha&"-"&diaFecha
end if

if tipoConsulta = "1" then 'STOCK DE CREDITOS
	if fecha = "" then
		sql = ""		
		sql = sql & " select MAX(cast(fecha_inicio as date)) as fecha_registro "		
		sql = sql & " from SUC_index_cr_det_stock "
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
	sql = sql & " a.cod_bantotal, "
	sql = sql & " a.nombre_sucursal, "
	sql = sql & " a.cuenta, "
	sql = sql & " a.operacion, "
	sql = sql & " a.segmento, "
	sql = sql & " a.fecha_colocacion, "
	sql = sql & " a.saldo_insoluto, "
	sql = sql & " a.fecha_operacion "
	sql = sql & " from SUC_index_cr_det_stock a, "		
	sql = sql & " SUC_sucursal b "
	sql = sql & " where a.id_sucursal = b.id_sucursal "
	if fecha <> "" then
		sql = sql & " and cast(fecha_inicio as DATE) = '"&fecha&"'"	
	end if
	if traeDatos = "1" then
		sql = sql & " and a.id_sucursal = '"&idSucursal&"' "
	else
		if perfil = "1" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"')"
		end if
		if perfil = "2" then
			sql = sql & " and b.id_sucursal in "
			'sql = sql & " (select id_sucursal "
			'sql = sql & " from SUC_zonales_sucursal "
			'sql = sql & " where id_zonal = '"&idUsuario&"') "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"') "
		end if
	end if
	
	Response.Write(sql)	
	Response.End()

	set rs=db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & "<table>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		
		resultado = resultado & "<th>Cod BT</th>"
		resultado = resultado & "<th>Nombre Sucursal</th>"
		resultado = resultado & "<th>Cuenta</th>"
		resultado = resultado & "<th>Operación</th>"
		resultado = resultado & "<th>Segmento</th>"
		resultado = resultado & "<th>Fecha Colocacion</th>"
		resultado = resultado & "<th>Saldo Insoluto</th>"
		resultado = resultado & "<th>Fecha Operacion</th>"			
		
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		
		for i=0 to ubound(datos,2)
			cod_bantotal = trim(datos(0,i))
			nombre_sucursal = trim(datos(1,i))
			cuenta = trim(datos(2,i))
			operacion = trim(datos(3,i))
			segmento = trim(datos(4,i))
			fecha_colocacion = trim(datos(5,i))
			saldo_insoluto = trim(datos(6,i))
			fecha_operacion = trim(datos(7,i))
						
			resultado = resultado & "<tr>"
			
			resultado = resultado & "<td>"&cod_bantotal&"</td>"
			resultado = resultado & "<td>"&nombre_sucursal&"</td>"
			resultado = resultado & "<td>"&cuenta&"</td>"
			resultado = resultado & "<td>"&operacion&"</td>"
			resultado = resultado & "<td>"&segmento&"</td>"
			resultado = resultado & "<td>"&fecha_colocacion&"</td>"
			resultado = resultado & "<td>"&saldo_insoluto&"</td>"
			resultado = resultado & "<td>"&fecha_operacion&"</td>"				
						
			resultado = resultado & "</tr>"
		next
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	else
		resultado = ""
		resultado = resultado & "No existen registros"
	end if
	if traeDatos = "1" then
			archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" CreditosSTOCK "&nombre_sucursal&".xls"
	else
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Creditos STOCK.xls"
	end if
	
end if

if tipoConsulta = "2" then 'INSTANCIAS DE CREDITO
	if fecha = "" then
		sql = ""		
		sql = sql & " select MAX(cast(fecha_inicio as date)) as fecha_registro "		
		sql = sql & " from SUC_index_cr_det_inst "
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
	sql = sql & " a.tarea, "
	sql = sql & " a.instancia, "
	sql = sql & " a.usuario, "
	sql = sql & " a.sucursal_usuario, "
	sql = sql & " a.nombre_sucursal, "
	sql = sql & " a.fecha_inicio, "
	sql = sql & " a.fecha_finalizacion, "
	sql = sql & " a.cuenta, "
	sql = sql & " a.operacion, "
	sql = sql & " a.cuenta_empresa, "
	sql = sql & " a.cuotas, "
	sql = sql & " a.fecha_solicitud, "
	sql = sql & " a.estado "
	sql = sql & " from SUC_index_cr_det_inst a, "		
	sql = sql & " SUC_sucursal b "
	sql = sql & " where a.id_sucursal = b.id_sucursal "
	if fecha <> "" then
		sql = sql & " and cast(fecha_inicio as DATE) = '"&fecha&"'"	
	end if
	if traeDatos = "1" then
		sql = sql & " and a.id_sucursal = '"&idSucursal&"' "
	else
		if perfil = "1" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"')"
		end if
		if perfil = "2" then
			sql = sql & " and b.id_sucursal in "
			'sql = sql & " (select id_sucursal "
			'sql = sql & " from SUC_zonales_sucursal "
			'sql = sql & " where id_zonal = '"&idUsuario&"') "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"') "
		end if
	end if
	
	'Response.Write(sql)	
	'Response.End()

	set rs=db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & "<table>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		
		resultado = resultado & "<th>Tarea</th>"
		resultado = resultado & "<th>Instancia</th>"
		resultado = resultado & "<th>Usuario</th>"
		resultado = resultado & "<th>Sucurusal Usuario</th>"
		resultado = resultado & "<th>Nombre Sucurusal</th>"
		resultado = resultado & "<th>Fecha Inicio</th>"
		resultado = resultado & "<th>Fecha Finalización</th>"
		resultado = resultado & "<th>Cuenta</th>"
		resultado = resultado & "<th>Operación</th>"
		resultado = resultado & "<th>Cuenta Empresa</th>"
		resultado = resultado & "<th>Cuotas</th>"
		resultado = resultado & "<th>Fecha Solicitud</th>"
		resultado = resultado & "<th>Estado</th>"			
		
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		
		for i=0 to ubound(datos,2)
			tarea = trim(datos(0,i))
			instancia = trim(datos(1,i))
			usuario = trim(datos(2,i))
			sucursal_usuario = trim(datos(3,i))
			nombre_sucursal = trim(datos(4,i))
			fecha_inicio = trim(datos(5,i))
			fecha_finalizacion = trim(datos(6,i))
			cuenta = trim(datos(7,i))
			operacion = trim(datos(8,i))
			cuenta_empresa = trim(datos(9,i))
			cuotas = trim(datos(10,i))
			fecha_solicitud = trim(datos(11,i))
			estado = trim(datos(12,i))
			
			resultado = resultado & "<tr>"
			
			resultado = resultado & "<td>"&tarea&"</td>"
			resultado = resultado & "<td>"&instancia&"</td>"
			resultado = resultado & "<td>"&usuario&"</td>"
			resultado = resultado & "<td>"&sucursal_usuario&"</td>"
			resultado = resultado & "<td>"&nombre_sucursal&"</td>"
			resultado = resultado & "<td>"&fecha_inicio&"</td>"
			resultado = resultado & "<td>"&fecha_finalizacion&"</td>"
			resultado = resultado & "<td>"&cuenta&"</td>"
			resultado = resultado & "<td>"&operacion&"</td>"
			resultado = resultado & "<td>"&cuenta_empresa&"</td>"
			resultado = resultado & "<td>"&cuotas&"</td>"
			resultado = resultado & "<td>"&fecha_solicitud&"</td>"
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
			archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Creditos INSTANCIAS "&"CodBTT-"&sucursal_usuario&".xls"
	else
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Creditos INSTANCIAS.xls"
	end if
	
end if

if tipoConsulta = "3" then 'CREDITOS COLOCADOS
	if fecha = "" then
		sql = ""		
		sql = sql & " select MAX(cast(fecha as date)) as fecha_registro "		
		sql = sql & " from SUC_index_cr_det_coloc "
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
	sql = sql & " a.sucursal, "
	sql = sql & " b.suc_nombre, "
	sql = sql & " a.modulo, "
	sql = sql & " a.transaccion, "
	sql = sql & " a.relacion, "
	sql = sql & " a.fecha, "
	sql = sql & " a.cuenta, "
	sql = sql & " a.operacion, "	
	sql = sql & " a.monto "
	sql = sql & " from SUC_index_cr_det_coloc a, "		
	sql = sql & " SUC_sucursal b "
	sql = sql & " where a.id_sucursal = b.id_sucursal "
	if fecha <> "" then
		sql = sql & " and cast(fecha as DATE) = '"&fecha&"'"	
	end if
	if traeDatos = "1" then
		sql = sql & " and a.id_sucursal = '"&idSucursal&"' "
	else
		if perfil = "1" then
			sql = sql & " and b.id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"')"
		end if
		if perfil = "2" then
			sql = sql & " and b.id_sucursal in "
			'sql = sql & " (select id_sucursal "
			'sql = sql & " from SUC_zonales_sucursal "
			'sql = sql & " where id_zonal = '"&idUsuario&"') "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"') "
		end if
	end if
	
	'Response.Write(sql)	
	'Response.End()
	set rs=db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & "<table>"
		resultado = resultado & "<thead>"
		resultado = resultado & "<tr>"
		
		resultado = resultado & "<th>Cod BTT</th>"
		resultado = resultado & "<th>Sucursal</th>"		
		resultado = resultado & "<th>Modulo</th>"
		resultado = resultado & "<th>Transaccion</th>"	
		resultado = resultado & "<th>Relacion</th>"	
		resultado = resultado & "<th>Fecha</th>"
		resultado = resultado & "<th>Cuenta</th>"
		resultado = resultado & "<th>Operacion</th>"
		resultado = resultado & "<th>Monto</th>"	
		
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		
		for i=0 to ubound(datos,2)
			cod_bantotal = trim(datos(0,i))
			sucursal_nombre = trim(datos(1,i))
			modulo = trim(datos(2,i))
			transaccion = trim(datos(3,i))
			relacion = trim(datos(4,i))
			fecha = trim(datos(5,i))
			cuenta = trim(datos(6,i))
			operacion = trim(datos(7,i))
			monto = trim(datos(8,i))
			
			resultado = resultado & "<tr>"
			
			resultado = resultado & "<td>"&cod_bantotal&"</td>"
			resultado = resultado & "<td>"&sucursal_nombre&"</td>"
			resultado = resultado & "<td>"&modulo&"</td>"
			resultado = resultado & "<td>"&transaccion&"</td>"
			resultado = resultado & "<td>"&relacion&"</td>"
			resultado = resultado & "<td>"&fecha&"</td>"
			resultado = resultado & "<td>"&cuenta&"</td>"
			resultado = resultado & "<td>"&operacion&"</td>"			
			resultado = resultado & "<td>"&monto&"</td>"
						
			resultado = resultado & "</tr>"
		next
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	else
		resultado = ""
		resultado = resultado & "No existen registros"
	end if
	if traeDatos = "1" then
			archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" CreditosCOLOCADOS "&"CodBTT-"&cod_bantotal&".xls"
	else
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Creditos COLOCADOS.xls"
	end if
end if


response.write(resultado)
Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo 

%>