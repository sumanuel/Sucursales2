<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuario"))
perfil = trim(request("perfil"))
tipoConsulta = trim(request("consulta"))
traeDatos = trim(request("traeDatos"))
idSucursal = trim(request("idSucursal"))
fecha = trim(request("fecha"))

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
		sql = sql & " select max(cast(fechacreacion as DATE)) "
		sql = sql & " as fecha_registro "
		sql = sql & " from SUC_index_rec_det "
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
	sql = sql & " a.id_recdet, "
	sql = sql & " a.id_sucursal, " 
	sql = sql & " a.cod_sap, "
	sql = sql & " a.cod_bantotal, "
	sql = sql & " a.n_caso, "
	sql = sql & " a.rut, "
	sql = sql & " a.dv, "
	sql = sql & " a.canal_ingreso, "
	sql = sql & " a.fechacreacion, "
	sql = sql & " a.via_ingreso, "
	sql = sql & " a.producto, "
	sql = sql & " a.motivo, "
	sql = sql & " a.detalle, "
	sql = sql & " a.tipo, "
	sql = sql & " a.fecha_probable_respuesta, "
	sql = sql & " a.direccion_cliente, "
	sql = sql & " a.mail, "
	sql = sql & " a.fono_contacto, "
	sql = sql & " a.resolucion_a_favor, "
	sql = sql & " a.SLA, "
	sql = sql & " a.duracion_caso_enminutos, "
	sql = sql & " a.duracion_caso_endias, "
	sql = sql & " a.estado, "
	sql = sql & " a.fecha_sol_propuesta, "
	sql = sql & " a.fecha_cierre, "
	sql = sql & " a.fecha_derivacion, "
	sql = sql & " a.fecha_asignacion, "
	sql = sql & " a.fecha_asignacion, "
	sql = sql & " a.fecha_modificacion, "
	sql = sql & " a.usuario_ingreso, "
	sql = sql & " a.usuario_solucion_propuesta, "
	sql = sql & " a.usuario_cierre, "
	sql = sql & " a.responsable, "
	sql = sql & " a.grupo_responsable, "
	sql = sql & " a.tipo_cliente, "
	sql = sql & " a.sucursal, "
	sql = sql & " a.regional, "
	sql = sql & " a.cumplimiento, "
	sql = sql & " a.rango_duracion_caso, "
	sql = sql & " a.xtype, "
	sql = sql & " a.fecha_registro, "
	sql = sql & " b.suc_nombre "
	sql = sql & " from SUC_index_rec_det a, "
	sql = sql & " SUC_sucursal b "
	sql = sql & " where a.id_sucursal = b.id_sucursal "
	if traeDatos = "1" then
		sql = sql & " and a.id_sucursal = '"&idSucursal&"'  "
	else
		if perfil = "1" then
			sql = sql & " and a.id_sucursal in "
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
	if fecha <> "" then
		sql = sql & " and cast(fechacreacion as date) = '"&fecha&"'"
	else
		sql = sql & " and cast(fechacreacion as date) = "
		sql = sql & " (select max(cast(fechacreacion as date)) "
		sql = sql & " as fecha_registro "
		sql = sql & " from SUC_index_rec_det) "
	end if

	'response.write(sql)
	'response.end

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
		resultado = resultado & " <th>Fecha creacion</th> "
		resultado = resultado & " <th>Via ingreso</th> "
		resultado = resultado & " <th>Producto</th> "
		resultado = resultado & " <th>Motivo</th> "
		resultado = resultado & " <th>Detalle</th> "
		resultado = resultado & " <th>Tipo</th> "
		resultado = resultado & " <th>Fecha probable respuesta</th> "
		resultado = resultado & " <th>Direccion Cliente</th> "
		resultado = resultado & " <th>Mail</th> "
		resultado = resultado & " <th>Telefono Contacto</th> "
		resultado = resultado & " <th>Resolucion</th> "
		resultado = resultado & " <th>Sla</th> "
		resultado = resultado & " <th>Duracion en minutos</th> "
		resultado = resultado & " <th>Duracion en dias</th> "
		resultado = resultado & " <th>Fecha solución propuesta</th> "
		resultado = resultado & " <th>Fecha cierre</th> "
		resultado = resultado & " <th>Fecha derivacion</th> "
		resultado = resultado & " <th>Fecha asignacion</th> "
		resultado = resultado & " <th>Fecha cierre</th> "
		resultado = resultado & " <th>Responsable</th> "
		resultado = resultado & " <th>Grupo responsable</th> "
		resultado = resultado & " <th>Tipo Cliente</th> "
		resultado = resultado & " <th>Sucursal</th> "
		resultado = resultado & " <th>Regional</th> "
		resultado = resultado & " <th>Cumplimiento</th> "
		resultado = resultado & " <th>Rango duracion caso</th> "
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
			resultado = resultado & " <td>"&viaIngreso&"</td> "
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
			archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Gestor Casos "&"CodBTT-"&codBanTotal&".xls"
	else
		archivo = anioFecha&"-"&mesFecha&"-"&diaFecha&" Gestor Casos.xls"
	end if
end if

if tipoConsulta = "2" then
	sql = ""
	sql = sql & " select Incident_Number, "
	sql = sql & " Assigned_Group, "
	sql = sql & " Submit_Date, "
	sql = sql & " Assignee, "
	sql = sql & " Description, "
	sql = sql & " First_Name, "
	sql = sql & " isnull(Middle_Initial, '') as Middle_Initial, "
	sql = sql & " Last_Name, "
	sql = sql & " Last_Modified_Date, "
	sql = sql & " Last_Resolved_Date, "
	sql = sql & " isnull(Closed_Date, '') as Closed_Date, "
	sql = sql & " isnull(zAgenteCierreTecnico, '') as zAgenteCierreTecnico, "
	sql = sql & " Grupos, "
	sql = sql & " cast(SLA as varchar(30)) as sla, "
	sql = sql & " diferencia, "
	sql = sql & " dentro_fuera, "
	sql = sql & " status2 "
	sql = sql & " cod_sucursal, "
	sql = sql & " b.suc_nombre,  "
	sql = sql & " fecha_registro, a.cod_bantotal"
	sql = sql & " from SUC_index_ma_det a, "
	sql = sql & " SUC_sucursal b "
	sql = sql & " where  "
	sql = sql & "  a.cod_sucursal = b.id_sucursal "
	if fecha = "" then
		sql = sql & " and cast(Submit_Date as date) in (select MAX(cast(Submit_Date as date)) from SUC_index_ma_det) "
	else
		sql = sql & " and cast(Submit_Date as date) = '"&fecha&"' "
	end if
	if traeDatos = "1" then
		sql = sql & " and b.id_sucursal = '"&idSucursal&"'  "
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

	'Response.Write(sql)
	'Response.End()
	
	set rs=db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		resultado = ""
		resultado = resultado & " <table> "
		resultado = resultado & " <thead> "
		resultado = resultado & " <tr> "
		resultado = resultado & " <th>Numero incidencia</th> "
		resultado = resultado & " <th>Grupo Asignado</th> "
		resultado = resultado & " <th>Fecha ingreso</th> "
		resultado = resultado & " <th>Asignacion</th> "
		resultado = resultado & " <th>Descripcion</th> "
		resultado = resultado & " <th>Nombre</th> "
		resultado = resultado & " <th>Apellido</th> "
		resultado = resultado & " <th>Fecha ultima modificacion</th> "
		resultado = resultado & " <th>Fecha ultima resolucion</th> "
		resultado = resultado & " <th>Fecha de cierre</th> "
		resultado = resultado & " <th>Agente cierre tecnico</th> "
		resultado = resultado & " <th>Grupos</th> "
		resultado = resultado & " <th>SLA</th> "
		resultado = resultado & " <th>Diferencia</th> "
		resultado = resultado & " <th>Plazo</th> "
		resultado = resultado & " <th>Status</th> "
		resultado = resultado & " <th>Sucursal</th> "
		resultado = resultado & " </tr> "
		resultado = resultado & " </thead> "
		resultado = resultado & " <tbody> "
		for i=0 to ubound(datos,2)
			numeroIncidencia = trim(datos(0,i))
			grupoAsignado = server.htmlencode(trim(datos(1,i)))
			fechaIngreso = trim(datos(2,i))
			descripcion = trim(datos(3,i))
			asignacion = server.htmlencode(trim(datos(4,i)))
			nombre = server.htmlencode(trim(datos(5,i)) & " "& trim(datos(6,i)))
			apellido = server.htmlencode(trim(datos(7,i)))
			ultimaModificacion = trim(datos(8,i))
			ultimaResolucion = server.htmlencode(trim(datos(9,i)))
			fechaCierre = trim(datos(10,i))
			agente =trim(datos(11,i))
			grupos = server.htmlencode(trim(datos(12,i)))
			sla = server.htmlencode(trim(datos(13,i)))
			diferencia = server.htmlencode(trim(datos(14,i)))
			'plazo = server.htmlencode(trim(datos(15,i)))
			plazo = trim(datos(15,i))
			statusIncidencia = server.htmlencode(trim(datos(16,i)))
			sucursal = server.htmlencode(trim(datos(17,i)))
			fechaRegistro = cdate(trim(datos(18,i)))
			CodBTT = trim(datos(19,i))
			diaFecha = formateaParaFecha(day(fechaRegistro))
			mesFecha = formateaParaFecha(month(fechaRegistro))
			anioFecha = year(fechaRegistro)

			resultado = resultado & " <tr> "
			resultado = resultado & " <td>"&numeroIncidencia&"</td> "
			resultado = resultado & " <td>"&grupoAsignado&"</td> "
			resultado = resultado & " <td>"&fechaIngreso&"</td> "
			
			resultado = resultado & " <td>"&descripcion&"</td> "
			resultado = resultado & " <td>"&asignacion&"</td> "
			resultado = resultado & " <td>"&nombre&"</td> "
			resultado = resultado & " <td>"&apellido&"</td> "
			resultado = resultado & " <td>"&ultimaModificacion&"</td> "
			resultado = resultado & " <td>"&ultimaResolucion&"</td> "
			resultado = resultado & " <td>"&fechaCierre&"</td> "
			resultado = resultado & " <td>"&agente&"</td> "
			resultado = resultado & " <td>"&grupos&"</td> "
			resultado = resultado & " <td>"&sla&"</td> "
			resultado = resultado & " <td>"&diferencia&"</td> "
			resultado = resultado & " <td>"&plazo&"</td> "
			resultado = resultado & " <td>"&statusIncidencia&"</td> "
			resultado = resultado & " <td>"&sucursal&"</td> "

			resultado = resultado & " </tr> "
		next
		resultado = resultado & " </tbody> "
		resultado = resultado & " </table> "
	end if
	if traeDatos = "1" then
		archivo = fecha&" Mesa de ayuda "&"CodBTT-"&CodBTT&".xls"		
	else
		archivo = fecha&" Mesa de ayuda.xls"
	end if
end if
response.write(resultado)


' ////////////////// esto es para la salida y el nombre del archivo'
Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo 
%>