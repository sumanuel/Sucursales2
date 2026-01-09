<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuario"))
perfil = trim(request("perfil"))
tipoConsulta = trim(request("tipoConsulta"))
traeDatos = trim(request("traeDatos"))
idSucursal = trim(request("idSucursal"))
fechaActual = date()
diaFechaActual = formateaParaFecha(day(fechaActual))
mesFechaActual = formateaParaFecha(month(fechaActual))
anioFechaActual = year(fechaActual)
' plantilla basica para el if'
'if tipoConsulta = "1" then
''	if traeDatos = "0" then
''	else
''	end if
'end if


if tipoConsulta = "1" then
	if traeDatos = "0" then
		sql = ""
		sql = sql & " select a.bt_sucursal, "
		sql = sql & " a.nom_sucursal, "
		sql = sql & " a.p1, "
		sql = sql & " a.p2, "
		sql = sql & " a.p3, "
		sql = sql & " a.p4, "
		sql = sql & " a.p5, "
		sql = sql & " a.p6, "
		sql = sql & " a.p7, "
		sql = sql & " a.p8 "
		sql = sql & " from encuestaGC.dbo.resp_aseo a "
		sql = sql & " where fecha_reg = '"&anioFechaActual&"-"&mesFechaActual&"-"&diaFechaActual&"' "
		sql = sql & " and bt_sucursal in "
		sql = sql & " (select cod_bantotal "
		sql = sql & " from SUC_sucursal "
		if perfil = "1" then
			sql = sql & " where id_sucursal in ("
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_usuario_sucursal "
			sql = sql & " where id_usuario = '"&idUsuario&"')) "
		end if
		if perfil = "2" then
			sql = sql & " where id_sucursal in "
			sql = sql & " (select id_sucursal "
			sql = sql & " from SUC_zonales_sucursal "
			sql = sql & " where id_zonal = '"&idUsuario&"')) "
		end if
		if perfil = "3" then
			sql = sql & " )"
		end if
		sql = sql & " order by a.nom_sucursal "
	else
		sql = ""
		sql = sql & " select a.bt_sucursal, "
		sql = sql & " a.nom_sucursal, "
		sql = sql & " a.p1, "
		sql = sql & " a.p2, "
		sql = sql & " a.p3, "
		sql = sql & " a.p4, "
		sql = sql & " a.p5, "
		sql = sql & " a.p6, "
		sql = sql & " a.p7, "
		sql = sql & " a.p8 "
		sql = sql & " from encuestaGC.dbo.resp_aseo a "
		sql = sql & " where fecha_reg = '"&anioFechaActual&"-"&mesFechaActual&"-"&diaFechaActual&"' "
		sql = sql & " and bt_sucursal in "
		sql = sql & " (select cod_bantotal "
		sql = sql & " from SUC_sucursal "
		sql = sql & " where id_sucursal = '"&idSucursal&"' ) "
		sql = sql & " order by a.nom_sucursal "
	end if
	set rs = db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & " <table> "
		resultado = resultado & " <thead> "
		resultado = resultado & " <tr> "
		resultado = resultado & " <th>Nombre Sucursal</th> "
		resultado = resultado & " <th>Pregunta 1</th> "
		resultado = resultado & " <th>Pregunta 2</th> "
		resultado = resultado & " <th>Pregunta 3</th> "
		resultado = resultado & " <th>Pregunta 4</th> "
		resultado = resultado & " <th>Pregunta 5</th> "
		resultado = resultado & " <th>Pregunta 6</th> "
		resultado = resultado & " <th>Pregunta 7</th> "
		resultado = resultado & " <th>Pregunta 8</th> "
		resultado = resultado & " </tr> "
		resultado = resultado & " </thead> "
		resultado = resultado & " <tbody> "
		for i=0 to ubound(datos,2)
			idSucursal = trim(datos(0,i))
			nombreSucursal = server.htmlencode(trim(datos(1,i)))
			p1 = server.htmlencode(trim(datos(2,i)))
			p2 = server.htmlencode(trim(datos(3,i)))
			p3 = server.htmlencode(trim(datos(4,i)))
			p4 = server.htmlencode(trim(datos(5,i)))
			p5 = server.htmlencode(trim(datos(6,i)))
			p6 = server.htmlencode(trim(datos(7,i)))
			p7 = server.htmlencode(trim(datos(8,i)))
			p8 = server.htmlencode(trim(datos(9,i)))
			resultado = resultado & " <tr> "
			resultado = resultado & " <td> "
			resultado = resultado & nombreSucursal
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p1
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p2
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p3
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p4
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p5
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p6
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p7
			resultado = resultado & " </td> "
			resultado = resultado & " <td> "
			resultado = resultado & p8
			resultado = resultado & " </td> "
			resultado = resultado & " </tr> "
		next
		resultado = resultado & " </tbody>"
		resultado = resultado & " </table>"
	else
		response.write("La sucursal no tiene datos")
	end if
	if traeDatos = "1" then
		archivo = anioFechaActual&"-"&mesFechaActual&"-"&diaFechaActual&" Encuesta Aseo "&nombreSucursal&".xls"
	else
		archivo = anioFechaActual&"-"&mesFechaActual&"-"&diaFechaActual&" Encuesta Aseo.xls"
	end if
end if
if tipoConsulta = "2" then
	sql = ""
	sql = sql & "select count(*) as cuenta from SUC_index_rec_det "
	set rs = db.execute(sql)
	if not rs.eof then
		cuenta = trim(rs("cuenta"))
	end if
	if cuenta = "0" then
		sql = ""
		sql = sql & " select * "
		sql = sql & " , 'A' as xtype into "
		sql = sql & " #bbdd_gc from indices..gc_abiertos "
		sql = sql & " where sucursal is not null "
		sql = sql & " and n_caso not in "
		sql = sql & " (select n_caso from indices..gc_creados) "
		sql = sql & " and n_caso not in (select "
		sql = sql & " n_caso from indices..gc_resueltos) "
		sql = sql & " insert into #bbdd_gc select *, "
		sql = sql & " 'C' as xtype from indices..gc_creados "
		sql = sql & " where sucursal is not null and n_caso not "
		sql = sql & " in (select n_caso from indices..gc_abiertos) "
		sql = sql & " and n_caso not in (select n_caso from "
		sql = sql & " indices..gc_resueltos) "
		sql = sql & " insert into #bbdd_gc select *, "
		sql = sql & " 'R' as xtype from indices..gc_resueltos "
		sql = sql & " where sucursal is not null and "
		sql = sql & " n_caso not in (select n_caso from indices..gc_creados) "
		sql = sql & " and n_caso not in (select n_caso from indices..gc_abiertos) "
		sql = sql & " insert into SUC_index_rec_det "
		sql = sql & " (id_sucursal, cod_sap, cod_bantotal, "
		sql = sql & " n_caso, rut, "
		sql = sql & " dv, canal_ingreso, fechacreacion, "
		sql = sql & " via_ingreso, producto, motivo, detalle, tipo, "
        sql = sql & " fecha_probable_respuesta, direccion_cliente, "
        sql = sql & " mail, fono_contacto, resolucion_a_favor, "
        sql = sql & " SLA, duracion_caso_enminutos, duracion_caso_endias, "
        sql = sql & " estado,fecha_sol_propuesta, fecha_cierre, "
        sql = sql & " fecha_derivacion, fecha_asignacion, fecha_modificacion, "
        sql = sql & " usuario_ingreso, usuario_solucion_propuesta, "
		sql = sql & " usuario_cierre,responsable, grupo_responsable, "
		sql = sql & " tipo_cliente, sucursal, regional, "
		sql = sql & " cumplimiento, rango_duracion_caso, xtype) "
		sql = sql & " select *  from ( "
		sql = sql & " select b.id_sucursal, b.cod_sap, "
		sql = sql & " b.cod_bantotal, a.* from #bbdd_gc a "
		sql = sql & " inner join SUC_sucursal_hom b on a.sucursal=b.cod_gc_glosa3 "
		sql = sql & " where a.xtype in ('R', 'C', 'A')  and a.tipo='Reclamo' ) as z "
		'ejecuto la consulta'
		db.execute(sql)

		sql = ""
		sql = sql & " drop table #bbdd_gc "
		db.execute(sql)


		sql = "" 
		sql = sql & " select a.*, "
		sql = sql & " b.suc_nombre "
		sql = sql & " from SUC_index_rec_det a, "
		sql = sql & " SUC_sucursal b "
		sql = sql & " where a.id_sucursal = b.id_sucursal "
		if perfil = "2" then
			if traeDatos = "1" then
				sql = sql & " and a.id_sucursal = '"&idSucursal&"'  "
			else
				sql = sql & " and a.id_sucursal in "
				sql = sql & " (select id_sucursal from SUC_zonales_sucursal where id_zonal = '"&idUsuario&"') "
			end if
		end if
		'response.write(sql)
		'response.end
	else
		sql = "" 
		sql = sql & " select a.*, "
		sql = sql & " b.suc_nombre "
		sql = sql & " from SUC_index_rec_det a, "
		sql = sql & " SUC_sucursal b "
		sql = sql & " where a.id_sucursal = b.id_sucursal "
		if perfil = "2" then
			if traeDatos = "1" then
				sql = sql & " and a.id_sucursal = '"&idSucursal&"'  "
			else
				sql = sql & " and a.id_sucursal in "
				sql = sql & " (select id_sucursal from SUC_zonales_sucursal where id_zonal = '"&idUsuario&"') "
			end if
		end if
	end if
	set rs=db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & " <table> "
		resultado = resultado & " <thead> "
		resultado = resultado & " <tr> "
		resultado = resultado & " <th>Numero caso</th> "
		resultado = resultado & " <th>Rut</th> "
		resultado = resultado & " <th>Canal ingreso</th> "
		resultado = resultado & " <th>Fecha creación</th> "
		resultado = resultado & " <th>Via ingreso</th> "
		resultado = resultado & " <th>Producto</th> "
		resultado = resultado & " <th>Motivo</th> "
		resultado = resultado & " <th>Detalle</th> "
		resultado = resultado & " <th>Tipo</th> "
		resultado = resultado & " <th>Fecha probable respuesta</th> "
		resultado = resultado & " <th>Direccion Cliente</th> "
		resultado = resultado & " <th>Mail</th> "
		resultado = resultado & " <th>Teléfono Contacto</th> "
		resultado = resultado & " <th>Resolucion</th> "
		resultado = resultado & " <th>Sla</th> "
		resultado = resultado & " <th>Duración en minutos</th> "
		resultado = resultado & " <th>Duración en días</th> "
		resultado = resultado & " <th>Fecha solución propuesta</th> "
		resultado = resultado & " <th>Fecha cierre</th> "
		resultado = resultado & " <th>Fecha derivación</th> "
		resultado = resultado & " <th>Fecha asignación</th> "
		resultado = resultado & " <th>Fecha cierre</th> "
		resultado = resultado & " <th>Responsable</th> "
		resultado = resultado & " <th>Grupo responsable</th> "
		resultado = resultado & " <th>Tipo Cliente</th> "
		resultado = resultado & " <th>Sucursal</th> "
		resultado = resultado & " <th>Regional</th> "
		resultado = resultado & " <th>Cumplimiento</th> "
		resultado = resultado & " <th>Rango duración caso</th> "
		resultado = resultado & " <th>xtype</th> "
		resultado = resultado & " <th>header</th> "
		resultado = resultado & " </tr> "
		resultado = resultado & " </thead> "
		resultado = resultado & " <tbody> "
		for i=0 to ubound(datos,2)
			idRecdet = trim(datos(0,i))
			idSucursal = trim(datos(1,i))
			codSap = trim(datos(2,i))
			codBanTotal =trim(datos(3,i))
			numeroCaso = trim(datos(4,i))
			rut = trim(datos(5,i))&"-"&trim(datos(6,i))
			canalIngreso = trim(datos(7,i))
			fechaCreacion = trim(datos(8,i))
			viaIngreso = trim(datos(9,i))
			producto = trim(datos(10,i))
			motivo = trim(datos(11,i))
			detalle  = trim(datos(12,i))
			tipo  = trim(datos(13,i))
			fechaProbableRespuesta  = trim(datos(14,i))
			direccionCliente = trim(datos(15,i))
			mail = trim(datos(16,i))
			fonoContacto = trim(datos(17,i))
			resolucion = trim(datos(18,i))
			sla = trim(datos(19,i))
			duracionMin = trim(datos(20,i))
			duracionDias = trim(datos(21,i))
			estado = trim(datos(22,i))
			fechaSolucionPropuesta = trim(datos(23,i))
			fechaCierre = trim(datos(24,i))
			fechaDerivacion = trim(datos(25,i))
			fechaAsignacion = trim(datos(26,i))
			fechaModificacion = trim(datos(27,i))
			usuarioIngreso = trim(datos(28,i))
			usuarioSolucion = trim(datos(29,i))
			usuarioCierre = trim(datos(30,i))
			responsable = trim(datos(31,i))
			grupoResponsable = trim(datos(32,i))
			tipoCliente = trim(datos(33,i))
			regional = trim(datos(35,i))
			cumplimiento = trim(datos(36,i))
			rango = trim(datos(37,i))
			xtype = trim(datos(38,i))
			nombreSucursal = trim(datos(39,i))
			resultado = resultado & " <tr> "
			resultado = resultado & " <td>"&numeroCaso&"</td> "
			resultado = resultado & " <td>"&rut&"</td> "
			resultado = resultado & " <td>"&canalIngreso&"</td> "
			resultado = resultado & " <td>"&fechaCreacion&"</td> "
			resultado = resultado & " <td>"&producto&"</td> "
			resultado = resultado & " <td>"&motivo&"</td> "
			resultado = resultado & " <td>"&detalle&"</td> "
			resultado = resultado & " <td>"&tipo&"</td> "
			resultado = resultado & " <td>"&fechaProbableRespuesta&"</td> "
			resultado = resultado & " <td>"&direccionCliente&"</td> "
			resultado = resultado & " <td>"&mail&"</td> "
			resultado = resultado & " <td>"&fonoContacto&"</td> "
			resultado = resultado & " <td>"&resolucion&"</td> "
			resultado = resultado & " <td>"&sla&"</td> "
			resultado = resultado & " <td>"&duracionMin&"</td> "
			resultado = resultado & " <td>"&duracionDias&"</td> "
			resultado = resultado & " <td>"&estado&"</td> "
			resultado = resultado & " <td>"&fechaSolucionPropuesta&"</td> "
			resultado = resultado & " <td>"&fechaCierre&"</td> "
			resultado = resultado & " <td>"&fechaDerivacion&"</td> "
			resultado = resultado & " <td>"&fechaModificacion&"</td> "
			resultado = resultado & " <td>"&usuarioIngreso&"</td> "
			resultado = resultado & " <td>"&responsable&"</td> "
			resultado = resultado & " <td>"&grupoResponsable&"</td> "
			resultado = resultado & " <td>"&tipoCliente&"</td> "
			resultado = resultado & " <td>"&regional&"</td> "
			resultado = resultado & " <td>"&cumplimiento&"</td> "
			resultado = resultado & " <td>"&rango&"</td> "
			resultado = resultado & " <td>"&xtype&"</td> "
			resultado = resultado & " <td>"&nombreSucursal&"</td> "
			resultado = resultado & " </tr> "
		next
		resultado = resultado & " </tbody> "
		resultado = resultado & " </table> "
	else
		response.write("La sucursal no tiene Datos")
	end if
	if traeDatos = "1" then
		archivo = anioFechaActual&"-"&mesFechaActual&"-"&diaFechaActual&" Gestor Casos "&nombreSucursal&".xls"
	else
		archivo = anioFechaActual&"-"&mesFechaActual&"-"&diaFechaActual&" Gestor Casos.xls"
	end if
end if

response.write(resultado)


' ////////////////// esto es para la salida y el nombre del archivo'
Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo 
%>
