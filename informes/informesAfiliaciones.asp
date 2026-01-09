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
else
	sql = ""	
	sql = sql & " set dateformat dmy "
	sql = sql & " select z.creado_el from ( "
	sql = sql & " select max(cast(a.creado_el as date)) as creado_el"
	sql = sql & " from SUC_index_afi_det a ) as z "
	sql = sql & " group by z.creado_el "
	sql = sql & " order by z.creado_el desc "

	'response.write(sql)
	'response.end()

	set rs = db.execute(sql)
	if not rs.eof then
		fecha = trim(cdate(rs(0)))
	end if
	diaFecha = formateaParaFecha(day(fecha))
	mesFecha = formateaParaFecha(month(fecha))
	anioFecha = year(fecha)
	fecha = anioFecha&"-"&mesFecha&"-"&diaFecha

	'response.write(fecha)
	'response.end()

end if
if tipoConsulta = "1" then
	sql = ""
	sql = sql & " set dateformat dmy "
	sql = sql & " select a.fecha_op, "
	sql = sql & " a.cod_sap, "
	sql = sql & " a.cod_btt, "
	sql = sql & " a.id_mt, "
	sql = sql & " a.clase_op1, "
	sql = sql & " a.clase_op2, "
	sql = sql & " a.categoria, "
	sql = sql & " a.motivo, "
	sql = sql & " a.objetivo, "
	sql = sql & " a.clase_opdesc, "
	sql = sql & " a.creado_el, "
	sql = sql & " a.status_user, "
	sql = sql & " a.of_ventas, "
	sql = sql & " a.sucursal, "
	sql = sql & " a.canal, "
	sql = sql & " a.creado_por, "
	sql = sql & " a.rep_ventas, "
	sql = sql & " a.empleados, "
	sql = sql & " a.responsable1, "
	sql = sql & " a.responsable2, "
	sql = sql & " a.modificado_el, "
	sql = sql & " a.p_contacto, "
	sql = sql & " a.i_contacto, "
	sql = sql & " a.porct_tratado, "
	sql = sql & " a.resultado, "
	sql = sql & " a.id_org_venta "
	sql = sql & " from SUC_index_afi_det a "
	sql = sql & " inner join SUC_sucursal b "
	sql = sql & " on a.id_suc = b.id_sucursal "
	sql = sql & " where a.clase_op2 = 'Alta Pensionado' "
	if fecha <> "" then
		'sql = sql & " and cast((substring(a.creado_el, 7, 4)"
		sql = sql & " and cast(a.creado_el as date) = '"&fecha&"'"	
	end if
	if traeDatos = "1" then
		sql = sql & " and b.id_sucursal = '"&idSucursal&"' "
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
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"') "
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
		resultado = resultado & "<th>Fecha operacion</th>"
		resultado = resultado & "<th>Codigo sap</th>"
		resultado = resultado & "<th>Codigo bantotal</th>"
		resultado = resultado & "<th>Id mt</th>"
		resultado = resultado & "<th>Clase operacion 1</th>"
		resultado = resultado & "<th>Clase operacion 2</th>"
		resultado = resultado & "<th>Categoria</th>"
		resultado = resultado & "<th>Motivo</th>"
		resultado = resultado & "<th>Objetivo</th>"
		resultado = resultado & "<th>Clase operacion desc</th>"
		resultado = resultado & "<th>Creacion</th>"
		resultado = resultado & "<th>Estatus usuario</th>"
		resultado = resultado & "<th>Oficina de ventas</th>"		
		resultado = resultado & "<th>Sucursal</th>"
		resultado = resultado & "<th>Canal</th>"
		resultado = resultado & "<th>Creado por</th>"
		resultado = resultado & "<th>Representante de ventas</th>"
		resultado = resultado & "<th>Empleados</th>"
		resultado = resultado & "<th>Responsable 1</th>"
		resultado = resultado & "<th>Responsable 2</th>"
		resultado = resultado & "<th>P contacto</th>"
		resultado = resultado & "<th>I contacto</th>"
		resultado = resultado & "<th>% tratado</th>"
		resultado = resultado & "<th>Resultado</th>"
		resultado = resultado & "<th>Id origen de venta</th>"
		resultado = resultado & "</tr>"
		resultado = resultado & "</thead>"
		resultado = resultado & "<tbody>"
		for i=0 to ubound(datos,2)
			fechaOperacion = trim(datos(0,i))
			CodSap = trim(datos(1,i))
			codBantotal = trim(datos(2,i))
			Idmt = trim(datos(3,i))
			claseOperacion1 = server.htmlencode(trim(datos(4,i)))
			claseOperacion2 = server.htmlencode(trim(datos(5,i)))
			categoria = trim(datos(6,i))
			motivo = server.htmlencode(trim(datos(7,i)))
			objetivo = server.htmlencode(trim(datos(8,i)))
			claseOperacionDesc = trim(datos(9,i))
			creacion = trim(datos(10,i))
			estatusUsr = server.htmlencode(trim(datos(11,i)))
			oficinaVtas = server.htmlencode(trim(datos(12,i)))
			sucursal = server.htmlencode(trim(datos(13,i)))
			creadoPor = trim(datos(14,i))
			representanteVtas = trim(datos(15,i))
			empleados = trim(datos(16,i))
			responsable1 = trim(datos(17,i))
			responsable2 = trim(datos(18,i))
			pContacto = trim(datos(19,i))
			iContacto = trim(datos(20,i))
			tratado = trim(datos(21,i))
			resultados = trim(datos(22,i))
			origenVta = trim(datos(23,i))


			resultado = resultado & "<tr>"
			resultado = resultado & "<td>"&fechaOperacion&"</td>"
			resultado = resultado & "<td>"&CodSap&"</td>"
			resultado = resultado & "<td>"&codBantotal&"</td>"
			resultado = resultado & "<td>"&claseOperacion1&"</td>"
			resultado = resultado & "<td>"&claseOperacion2&"</td>"
			resultado = resultado & "<td>"&categoria&"</td>"
			resultado = resultado & "<td>"&motivo&"</td>"
			resultado = resultado & "<td>"&objetivo&"</td>"
			resultado = resultado & "<td>"&claseOperacionDesc&"</td>"
			resultado = resultado & "<td>"&creacion&"</td>"
			resultado = resultado & "<td>"&estatusUsr&"</td>"
			resultado = resultado & "<td>"&oficinaVtas&"</td>"
			resultado = resultado & "<td>"&sucursal&"</td>"
			resultado = resultado & "<td>"&creadoPor&"</td>"
			resultado = resultado & "<td>"&representanteVtas&"</td>"
			resultado = resultado & "<td>"&empleados&"</td>"
			resultado = resultado & "<td>"&responsable1&"</td>"
			resultado = resultado & "<td>"&responsable2&"</td>"	
			resultado = resultado & "<td>"&pContacto&"</td>"	
			resultado = resultado & "<td>"&iContacto&"</td>"					
			resultado = resultado & "<td>"&tratado&"</td>"	
			resultado = resultado & "<td>"&resultados&"</td>"	
			resultado = resultado & "<td>"&origenVta&"</td>"	
			resultado = resultado & "</tr>"
		next
		resultado = resultado & "</tbody>"
		resultado = resultado & "</table>"
	else
		resultado = ""
		resultado = "No existen datos"
	end if
	'response.write(traeDatos)
	'response.end	
	if traeDatos = "1" then
			archivo = fecha&" afiliacion "&"CodBTT-"&codBantotal&".xls"
	else
		archivo = fecha&" afiliacion.xls"
	end if
end if
response.write(resultado)
Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo 
%>