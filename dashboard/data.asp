<!--#include file="../funciones.asp"-->
<%
tipo = trim(request("tipo"))
idSucursal = trim(request("idSucursal"))
idPerfil = trim(request("perfil"))
if tipo = "1" then
	sucursalesAbiaertasFueraPlazo = 0
	sucursalesAbiaertasDentroPlazo = 0
	sucursalesAbiaertas = 0
	sql = ""
	sql = sql & " select COUNT(id_sucursal) as fp "
	sql = sql & " from SUC_sucursal_apertura "
	sql = sql & " where fecha_ingreso = cast(GETDATE() as date)  "
	sql = sql & " and hora_ingreso > '08:45' "
	if idPerfil = "2" then
	  sql = sql & " and id_sucursal in (select id_sucursal "
	  sql = sql & " from SUC_usuario_sucursal "
	  sql = sql & " where id_usuario = '"&idUsuario&"') "
	end if
	set rs = db.execute(sql)
	if not rs.eof then
	  sucursalesAbiaertasFueraPlazo = clng(trim(rs("fp")))
	end if
	sql = ""
	sql = sql & " select COUNT(id_sucursal) as total_sucursales "
	sql = sql & " from SUC_sucursal "
	sql = sql & " where suc_estado = 1 "
	if idPerfil <> "3" then
	  sql = sql & " and id_sucursal in ( "
	  sql = sql & " select id_sucursal "
	  sql = sql & " from SUC_usuario_sucursal "
	  sql = sql & " where id_usuario = '"&idUsuario&"' )"
	end if	
	set rs = db.execute(sql)
	if not rs.eof then
	  totalSucursales = trim(rs(0))
	end if
	sql = ""
	sql = sql & " select COUNT(id_sucursal) as dp "
	sql = sql & " from SUC_sucursal_apertura "
	sql = sql & " where fecha_ingreso = cast(GETDATE() as date)  "
	sql = sql & " and hora_ingreso <= '08:45' "
	if idPerfil = "2" then
	  sql = sql & " and id_sucursal in (select id_sucursal "
	  sql = sql & " from SUC_usuario_sucursal "
	  sql = sql & " where id_usuario = '"&idUsuario&"') "
	end if
	set rs = db.execute(sql)
	if not rs.eof then
	  sucursalesAbiaertasDentroPlazo = clng(trim(rs("dp")))
	end if
	sucursalesAbiaertas = sucursalesAbiaertasFueraPlazo + sucursalesAbiaertasDentroPlazo
	sucursalesCerradas = clng(totalSucursales) - clng(sucursalesAbiaertas)
	Response.ContentType = "application/json"
	Response.Write "["
	Response.Write "[""Abiertas DP"", " & sucursalesAbiaertasDentroPlazo & "], "
	Response.Write "[""Abiertas FP"", " & sucursalesAbiaertasFueraPlazo & "], "
	Response.Write "[""Cerradas"", " & sucursalesCerradas & "]]"
end if
if tipo = "2" then
	'ausentes'
	sql = ""
	sql = sql & " select ausente =  COUNT(*)  "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where (rut_personal in "
	sql = sql & " (select rut_personal "
	sql = sql & " from SUC_sucursal_personal "
	sql = sql & " where id_cargo=1) or "
	sql = sql & " rut_personal in (select rut_reemp "
	sql = sql & " from SUC_sucursal_reemplazos where "
	sql = sql & " id_cargo in (1,6))) "
	sql = sql & " and isnull(asistencia,'no')='no'  "
	if idPerfil = "2" then
		sql = sql & " and id_sucursal in (select id_sucursal from SUC_usuario_sucursal where id_usuario = '"&idUsuario&"') "
	end if
	sql = sql & " group by asistencia "
	set rs = db.execute(sql)
	if not rs.eof then
		totalAusentes = clng(trim(rs(0)))
	else
		totalAusentes = 0

	end if
	'presentes'
	sql = ""
	sql = sql & " select ausente =  COUNT(*)  "
	sql = sql & " from SUC_sucursal_asistencia_personal "
	sql = sql & " where (rut_personal in "
	sql = sql & " (select rut_personal "
	sql = sql & " from SUC_sucursal_personal "
	sql = sql & " where id_cargo=1) or "
	sql = sql & " rut_personal in (select rut_reemp "
	sql = sql & " from SUC_sucursal_reemplazos where "
	sql = sql & " id_cargo in (1,6))) "
	sql = sql & " and isnull(asistencia,'no')='si'  "
	if idPerfil = "2" then
		sql = sql & " and id_sucursal in (select id_sucursal from SUC_usuario_sucursal where id_usuario = '"&idUsuario&"') "
	end if
	sql = sql & " group by asistencia "
	set rs = db.execute(sql)
	if not rs.eof then
		totalPresentes = clng(trim(rs(0)))
	else
		totalPresentes = 0
	end if
	total = totalPresentes+totalAusentes
	Response.ContentType = "application/json"
	Response.Write "["
	Response.Write "[""Presentes"", " & totalPresentes & "], "
	Response.Write "[""Ausentes"", " & totalAusentes & "]]"
end if
if tipo = "3" then
	idUsuario = trim(request("idUsuario"))
	idPerfil = trim(request("idPerfil"))
	horaActual = Time()
	minutosHoraActual=hour(horaActual)*60
	minutosHoraActual = minutosHoraActual + minute(horaActual)
	if minutosHoraActual >= 480 then
		'=================================================================================
		'--> TITULARES Y REEMPLZOS
		'=================================================================================
		sql = ""
		if idPerfil = "2" then
		codSucursal = ""
		sqlSucs = ""		
		sqlSucs = sqlSucs & " select cod_bantotal "
		sqlSucs = sqlSucs & " from SUC_sucursal "
		sqlSucs = sqlSucs & " where id_sucursal in "
		sqlSucs = sqlSucs & " (select id_sucursal "
		sqlSucs = sqlSucs & " from SUC_usuario_sucursal "
		sqlSucs = sqlSucs & " where id_usuario = " & idUsuario & ") "			
		set rsSucs = db.execute(sqlSucs)		
		if not rsSucs.eof then
		dataSucs = rsSucs.GetRows()
		end if
		for y=0 to ubound(dataSucs,2)
		codSucursal = codSucursal & dataSucs(0,y) & ","
		next
		codSucursal = left(codSucursal, (len(codSucursal)-1))
		'Response.Write("idSucursal: "&idSucursal & "<br>")		
		rsSucs.close: set rsSucs = nothing 

		sql = sql & " select "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_guardias_asistencia "
		sql = sql & " where cod_bantotal in "
		sql = sql & " ("&codSucursal&")) as totalguardias, "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_guardias_asistencia "
		sql = sql & " where tipo_suc = 'titular' "
		sql = sql & " and cod_bantotal in ("&codSucursal&")) as totalguardiastitulares, "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_guardias_asistencia "
		sql = sql & " where tipo_suc = 'reemplazo' "
		sql = sql & " and cod_bantotal in ("&codSucursal&")) as totalguardiasreemplazos, "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_guardias_asistencia "
		sql = sql & " where (asistencia = 'si' "
		sql = sql & " and asistencia is not null) "
		sql = sql & " and cod_bantotal in ("&codSucursal&")) as totalguardiaspresentes, "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_guardias_asistencia "
		sql = sql & " where (asistencia = 'no' "
		sql = sql & " or asistencia is null) "
		sql = sql & " and cod_bantotal in ("&codSucursal&")) as totalguardiasausentes "
		else
		sql = sql & " select "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_guardias_asistencia) as totalguardias, "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_guardias_asistencia "
		sql = sql & " where tipo_suc = 'titular') as totalguardiastitulares, "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_guardias_asistencia "
		sql = sql & " where tipo_suc = 'reemplazo') as totalguardiasreemplazos, "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_guardias_asistencia "
		sql = sql & " where (asistencia = 'si' "
		sql = sql & " and asistencia is not null)) as totalguardiaspresentes, "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_guardias_asistencia "
		sql = sql & " where (asistencia = 'no' "
		sql = sql & " or asistencia is null)) as totalguardiasausentes "
		end if
		set rs = db.execute(sql)
		totalTitu = 0
		totalRempl = 0
		if not rs.eof then 
		totalGuardias = rs("totalguardias")
		totalTitu = rs("totalguardiastitulares")
		totalPres = rs("totalguardiaspresentes")
		totalRempl = rs("totalguardiasreemplazos")
		totalAus = rs("totalguardiasausentes")
		end if
	else
		totalPres = 0
		totalAus = 0
	end if
	Response.ContentType = "application/json"
	Response.Write "["
	Response.Write "[""Presentes"", " & totalPres & "], "
	Response.Write "[""Ausentes"", " & totalAus & "]]"
end if
if tipo="4" then
	
	sql = ""
	sql = sql & " select disponibles_c, "
	sql = sql & " pagados_c "
	sql = sql & " from indices..control_ips2 "
	sql = sql & " where fecha = cast(GETDATE() as DATE) "
	sql = sql & " and hora = "
	sql = sql & " (select MAX(hora) "
	sql = sql & " from indices..control_ips2 "
	sql = sql & " where fecha = cast(GETDATE() as DATE)) "
	set rs = db.execute(sql)
	if not rs.eof then
		programado = trim(rs("disponibles_c"))
		pagado = trim(rs("pagados_c"))
	else
		programado = 0
		pagado = 0
	end if
	Response.ContentType = "application/json"
	Response.Write "["
	Response.Write "[""Programados"", " & programado & "] "
	Response.Write ",[""Pagados"", " & pagado & "]]"
end if
if tipo="5" then
	sql = ""
	sql = sql & " select t_apago_d_qty as alDia, "
	sql = sql & " t_pagado_d_qty as pagadoAlDia, "
	sql = sql & " t_apago_r_qty as rezago, "
	sql = sql & " t_pagado_r_qty rezagoPagado "
	sql = sql & " from indices..control_afp "
	sql = sql & " where fecha = cast(GETDATE() as DATE) "
	sql = sql & " and hora = (select MAX(hora) from indices..control_afp "
	sql = sql & " where fecha = cast(GETDATE() as DATE))"
	set rs = db.execute(sql)
	if not rs.eof then
		programado = trim(rs("alDia"))
		pagado = trim(rs("pagadoAlDia"))
		rezagoAldia = trim(rs("rezago"))
		rezagoPagado = trim(rs("rezagoPagado"))
	else
		programado = 0
		pagado = 0
		rezagoAldia = 0
		rezagoPagado = 0
	end if
	Response.ContentType = "application/json"
	Response.Write "["
	Response.Write "[""Programados"", " & programado & "], "
	Response.Write "[""Pagados"", " & pagado & "], "
	Response.Write "[""Rezago"", " & rezagoAldia & "], "
	Response.Write "[""Rezago pagado"", " & rezagoPagado & "]]"
end if
if tipo = "6" then
	sql = ""
	sql = sql & " select a.disponibles_c, "
	sql = sql & " a.pagados_c, "
	sql = sql & " a.tipo, "
	sql = sql & " a.fecha, "
	sql = sql & " a.hora "
	sql = sql & " from indices..control_ips a "
 	sql = sql & " where a.fecha = cast(getdate() as date) "
 	sql = sql & " and a.hora = (select max(b.hora) "
 	sql = sql & " from indices..control_ips b "
 	sql = sql & " where a.fecha = b.fecha and a.tipo = b.tipo) "
	set rs = db.execute(sql)
	if not rs.eof then
		do while not rs.eof
			tipo_c = rs("tipo")
			disponibles_c = rs("disponibles_c")
			pagados_c = rs("pagados_c")

			if tipo_c = "2" then
				programado = disponibles_c
				pagado = pagados_c
			end if

			if tipo_c = "3" then
				programadoBM = disponibles_c
				pagadoBM = pagados_c
			end if

			if tipo_c = "4" then
				programadoBM2015 = disponibles_c
				pagadoBM2015 = pagados_c
			end if

		rs.MoveNext
		loop
	end if

	'sql = sql & " select disponibles_c, "
	'sql = sql & " pagados_c "
	'sql = sql & " from indices..control_ips "
	'sql = sql & " where tipo = 2 "
	'sql = sql & " and fecha = cast(GETDATE() as date) "
	'sql = sql & " and hora = (select MAX(hora) "
	'sql = sql & " from indices..control_ips "
	'sql = sql & " where tipo = 2 "
	'sql = sql & " and fecha = cast(GETDATE() as date)) "
	'set rs = db.execute(sql)
	'if not rs.eof then
	''	programado = trim(rs("disponibles_c"))
	''	pagado = trim(rs("pagados_c"))
	'else
	''	programado = 0
	''	pagado = 0
	'end if
	'sql = ""
	'sql = sql & " select disponibles_c, "
	'sql = sql & " pagados_c "
	'sql = sql & " from indices..control_ips "
	'sql = sql & " where tipo = 3 "
	'sql = sql & " and fecha = cast(GETDATE() as date) "
	'sql = sql & " and hora = (select MAX(hora) "
	'sql = sql & " from indices..control_ips "
	'sql = sql & " where tipo = 3 "
	'sql = sql & " and fecha = cast(GETDATE() as date)) "
	'set rs = db.execute(sql)
	'if not rs.eof then
	''	programadoBM = trim(rs("disponibles_c"))
	''	pagadoBM = trim(rs("pagados_c"))
	'else
	''	programadoBM = 0
	''	pagadoBM = 0
	'end if
	'response.write(sql)
	'response.end
	Response.ContentType = "application/json"
	Response.Write "["
	Response.Write "[""Programados"", " & programado & "] "
	Response.Write ",[""Pagados"", " & pagado & "] "
	Response.Write ",[""BM 2014 Prog."", "&programadoBM&"] "
	Response.Write ",[""BM 2014 Pag."", "&pagadoBM&"]"
	Response.Write ",[""BM 2015 Prog."", "&programadoBM2015&"] "
	Response.Write ",[""BM 2015 Pag."", "&pagadoBM2015&"]]"
end if%>