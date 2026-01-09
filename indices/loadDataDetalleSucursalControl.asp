<!--#include file="../funciones.asp"-->
<%idZonal = trim(request("idZonal"))


sql = ""
sql = sql & " select id_sucursal "
sql = sql & " from SUC_zonales_comercial_mas_sucursal "
sql = sql & " where id_zonal = '"&idZonal&"'"

set rs = db.execute(sql)
if not rs.eof then
	Response.ContentType = "application/json"
	Response.Write "{"
	Response.Write "  ""datos"": ["
	count = 0
	datos = rs.GetRows()
	For i = 0 to ubound(datos, 2)
		idSucursal = trim(datos(0,i))
		count = count + 1
		If count > 1 Then
			Response.Write ", "
		End If
		Response.Write "{ "      
		Response.Write "   ""idSucursal"": """ & idSucursal & """, "

		sql2 =""
		sql2 = sql2 & " select a.porc_cumpl "
		sql2 = sql2 & " from SUC_gest_admin_control  a"
		sql2 = sql2 & " where a.fecha_operacion = cast(GETDATE() as DATE) "
		sql2 = sql2 & " and a.estado = 1 "
		sql2 = sql2 & " and a.id_sucursal = '"&idSucursal&"' "
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			datos2 = rs2.GetRows()
			For x = 0 to ubound(datos2, 2)
				porcentajeAdm = trim(datos2(0,x))
			next
		else
			porcentajeAdm = 0
		end if
		porcentajeAdm = validaPorcentaje(porcentajeAdm)

		Response.Write "   ""porcentajeAdm"": """ & porcentajeAdm & """, "

		sql2 =""
		sql2 = sql2 & " select a.porc_cumpl "
		sql2 = sql2 & " from SUC_gest_cont_control  a"
		sql2 = sql2 & " where a.fecha_operacion = cast(GETDATE() as DATE) "
		sql2 = sql2 & " and a.estado = 1 "
		sql2 = sql2 & " and a.id_sucursal = '"&idSucursal&"' "
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			datos2 = rs2.GetRows()
			For x = 0 to ubound(datos2, 2)
				porcentajeCont = trim(datos2(0,x))
			next
		else
			porcentajeCont = 0
		end if
		porcentajeCont = validaPorcentaje(porcentajeCont)
		Response.Write "   ""porcentajeCont"": """ & porcentajeCont & """, "

		sql2 =""
		sql2 = sql2 & " select a.porc_cumpl "
		sql2 = sql2 & " from SUC_gest_doc_control  a"
		sql2 = sql2 & " where a.fecha_operacion = cast(GETDATE() as DATE) "
		sql2 = sql2 & " and a.estado = 1 "
		sql2 = sql2 & " and a.id_sucursal = '"&idSucursal&"' "
		set rs2 = db.execute(sql2)
		
		if not rs2.eof then
			datos2 = rs2.GetRows()
			For x = 0 to ubound(datos2, 2)
				porcentajecDoc = trim(datos2(0,x))
			next
		else
			porcentajeDoc = 0
		end if
		porcentajecDoc = validaPorcentaje(porcentajecDoc)
		Response.Write "   ""porcentajeDoc"": """ & porcentajecDoc & """, "
		
		sql2 = ""
		sql2 = sql2 & " select cast(hora_ingreso as datetime) horaApertura "
		sql2 = sql2 & " from SUC_sucursal_apertura "
		sql2 = sql2 & " where id_sucursal = '"&idSucursal&"' "
		sql2 = sql2 & " and  fecha_ingreso = cast (GETDATE() as DATE) "
		sql2 = sql2 & " and tipo = 1 "
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			sucursalAbierta = 1
			horaApertura = trim(rs2("horaApertura"))
			horaMuestraHora = hour(horaApertura)
			minutoMuestraHora = minute(horaApertura)
			if len(horaMuestraHora) = 1 then
			  horaMuestraHora = "0"&horaMuestraHora
			end if
			if len(minutoMuestraHora) = 1 then
			  minutoMuestraHora = "0"&minutoMuestraHora
			end if
			muestraHora = horaMuestraHora&":"&minutoMuestraHora
			horaMinutosApertura = hour(horaApertura) * 60
			minutosApertura = horaMinutosApertura + minute(horaApertura)
			if minutosApertura >= 525 then 'minutos de las 8:45'
			  sucursalAbierta = 2
			end if
		else
			sucursalAbierta = 0
		end if

		Response.Write "   ""estadoSucursal"": """ & sucursalAbierta & """, "
		
		if sucursalAbierta <> "0" then
			Response.Write "   ""horaAperturaSucursal"": """ & muestraHora & """, "
		else
			Response.Write "   ""horaAperturaSucursal"": ""00:00"", "
		end if
		if sucursalAbierta = 1 or sucursalAbierta = 2 then
    		sql2 = ""
    		sql2 = sql2 & " select a.situacion "
    		sql2 = sql2 & " from SUC_desbordes a "
    		sql2 = sql2 & " where a.fecha=cast(GETDATE() as date) "
    		sql2 = sql2 & " and a.hora = (select MAX(b.hora) "
    		sql2 = sql2 & " from SUC_desbordes b "
    		sql2 = sql2 & " where b.fecha=a.fecha and b.id_sucursal=a.id_sucursal) "
    		sql2 = sql2 & " and a.id_sucursal = '"&idSucursal&"'"
    		set rs2 = db.execute(sql2)
    		if not rs2.eof then
      			situacionSucursal = trim(rs2("situacion"))
    		else
      			situacionSucursal = "Nadie"
    		end if
  		else
    		situacionSucursal = "Cerrada"
  		end if

  		Response.Write "   ""situacionSucursal"": """ & situacionSucursal & """, "
 '###########################################################################################################'

		sql2 = ""
		sql2 = sql2 & " select z.id_zonal_mas, "
		sql2 = sql2 & " z.id_usuario, "
		sql2 = sql2 & " z.bt_sucursal, "
		sql2 = sql2 & " z.id_sucursal, "
		sql2 = sql2 & " COUNT(*) as nroasistencia, "
		sql2 = sql2 & " (select COUNT(*) "
		sql2 = sql2 & " from SUC_sucursal_asistencia_personal "
		sql2 = sql2 & " where tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') "
		sql2 = sql2 & " and bt_sucursal = z.bt_sucursal) as totalcajeros, "
		sql2 = sql2 & " ((CAST(COUNT(*)*100 as float)/CAST( "
		sql2 = sql2 & " (select COUNT(*) "
		sql2 = sql2 & " from SUC_sucursal_asistencia_personal "
		sql2 = sql2 & " where tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') "
		sql2 = sql2 & " and bt_sucursal = z.bt_sucursal)as float))) as porc_asist "
		sql2 = sql2 & " from(select a.id_zonal_mas, "
		sql2 = sql2 & " a.id_usuario, "
		sql2 = sql2 & " a.zonal_mas, "
		sql2 = sql2 & " c.id_sucursal, "
		sql2 = sql2 & " c.suc_nombre, "
		sql2 = sql2 & " d.bt_sucursal, "
		sql2 = sql2 & " d.rut_personal, "
		sql2 = sql2 & " d.tipo, "
		sql2 = sql2 & " d.tipo_personal, "
		sql2 = sql2 & " d.asistencia "
		sql2 = sql2 & " from SUC_zonales_comercial_mas a "
		sql2 = sql2 & " inner join SUC_zonales_comercial_mas_sucursal b "
		sql2 = sql2 & " on a.id_usuario = b.id_zonal "
		sql2 = sql2 & " inner join SUC_sucursal c "
		sql2 = sql2 & " on b.id_sucursal = c.id_sucursal "
		sql2 = sql2 & " inner join SUC_sucursal_asistencia_personal d "
		sql2 = sql2 & " on c.cod_bantotal = d.bt_sucursal "
		sql2 = sql2 & " where b.id_sucursal = '"&idSucursal&"' "
		sql2 = sql2 & " and d.tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') "
		sql2 = sql2 & " and d.asistencia = 'si') as z "
		sql2 = sql2 & " group by z.id_zonal_mas, "
		sql2 = sql2 & " z.id_usuario, "
		sql2 = sql2 & " z.bt_sucursal, "
		sql2 = sql2 & " z.id_sucursal "
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			datos2 = rs2.GetRows()
			For x = 0 to ubound(datos2, 2)
				porcentajeCajerosSucursalP = trim(datos2(6,x))
			next
		else
			porcentajeCajerosSucursalP = 0
		end if
		porcentajeCajerosSucursalP = validaPorcentaje(porcentajeCajerosSucursalP)
		Response.Write "   ""porcentajeCajerosSucursalP"": """ & porcentajeCajerosSucursalP & """, "

		sql2 = ""
		sql2 = sql2 & " select z.id_zonal_mas, "
		sql2 = sql2 & " z.id_usuario, "
		sql2 = sql2 & " z.bt_sucursal, "
		sql2 = sql2 & " COUNT(*) as nroasistencia, "
		sql2 = sql2 & " (select COUNT(*) "
		sql2 = sql2 & " from SUC_sucursal_asistencia_personal "
		sql2 = sql2 & " where tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') "
		sql2 = sql2 & " and bt_sucursal = z.bt_sucursal) as totalcajeros, "
		sql2 = sql2 & " ((CAST(COUNT(*)*100 as float)/CAST( "
		sql2 = sql2 & " (select COUNT(*) "
		sql2 = sql2 & " from SUC_sucursal_asistencia_personal "
		sql2 = sql2 & " where tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') "
		sql2 = sql2 & " and bt_sucursal = z.bt_sucursal)as float))) as porc_asist "
		sql2 = sql2 & " from(select a.id_zonal_mas, "
		sql2 = sql2 & " a.id_usuario, "
		sql2 = sql2 & " a.zonal_mas, "
		sql2 = sql2 & " c.id_sucursal, "
		sql2 = sql2 & " c.suc_nombre, "
		sql2 = sql2 & " d.bt_sucursal, "
		sql2 = sql2 & " d.rut_personal, "
		sql2 = sql2 & " d.tipo, "
		sql2 = sql2 & " d.tipo_personal, "
		sql2 = sql2 & " d.asistencia "
		sql2 = sql2 & " from SUC_zonales_comercial_mas a "
		sql2 = sql2 & " inner join SUC_zonales_comercial_mas_sucursal b "
		sql2 = sql2 & " on a.id_usuario = b.id_zonal "
		sql2 = sql2 & " inner join SUC_sucursal c "
		sql2 = sql2 & " on b.id_sucursal = c.id_sucursal "
		sql2 = sql2 & " inner join SUC_sucursal_asistencia_personal d "
		sql2 = sql2 & " on c.cod_bantotal = d.bt_sucursal "
		sql2 = sql2 & " where d.id_sucursal = '"&idSucursal&"' "
		sql2 = sql2 & " and d.tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') "
		sql2 = sql2 & " and d.asistencia = 'no' "
		'sql2 = sql2 & " or d.asistencia is null)
		sql2 = sql2 & " ) as z "
		sql2 = sql2 & " group by z.id_zonal_mas, "
		sql2 = sql2 & " z.id_usuario, "
		sql2 = sql2 & " z.bt_sucursal "
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			datos2 = rs2.GetRows()
			For x = 0 to ubound(datos2, 2)
				porcentajeCajerosSucursalA = trim(datos2(5,x))
			next
		else
			porcentajeCajerosSucursalA = 0
		end if
		porcentajeCajerosSucursalA = validaPorcentaje(porcentajeCajerosSucursalA)
		Response.Write "   ""porcentajeCajerosSucursalA"": """ & porcentajeCajerosSucursalA & """, "

'################################################################################################################'

		sql2 = ""
		sql2 = sql2 & " select z.id_zonal_mas, "
		sql2 = sql2 & " z.id_usuario, "
		sql2 = sql2 & " z.bt_sucursal, "
		sql2 = sql2 & " COUNT(*) as nroasistencia, "
		sql2 = sql2 & " (select COUNT(*) "
		sql2 = sql2 & " from SUC_sucursal_asistencia_personal "
		sql2 = sql2 & " where tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') "
		sql2 = sql2 & " and bt_sucursal = z.bt_sucursal) as totalcajeros, "
		sql2 = sql2 & " ((CAST(COUNT(*)*100 as float)/CAST( "
		sql2 = sql2 & " (select COUNT(*) "
		sql2 = sql2 & " from SUC_sucursal_asistencia_personal "
		sql2 = sql2 & " where tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') "
		sql2 = sql2 & " and bt_sucursal = z.bt_sucursal)as float))) as porc_asist "
		sql2 = sql2 & " from(select a.id_zonal_mas, "
		sql2 = sql2 & " a.id_usuario, "
		sql2 = sql2 & " a.zonal_mas, "
		sql2 = sql2 & " c.id_sucursal, "
		sql2 = sql2 & " c.suc_nombre, "
		sql2 = sql2 & " d.bt_sucursal, "
		sql2 = sql2 & " d.rut_personal, "
		sql2 = sql2 & " d.tipo, "
		sql2 = sql2 & " d.tipo_personal, "
		sql2 = sql2 & " d.asistencia "
		sql2 = sql2 & " from SUC_zonales_comercial_mas a "
		sql2 = sql2 & " inner join SUC_zonales_comercial_mas_sucursal b "
		sql2 = sql2 & " on a.id_usuario = b.id_zonal "
		sql2 = sql2 & " inner join SUC_sucursal c "
		sql2 = sql2 & " on b.id_sucursal = c.id_sucursal "
		sql2 = sql2 & " inner join SUC_sucursal_asistencia_personal d "
		sql2 = sql2 & " on c.cod_bantotal = d.bt_sucursal "
		sql2 = sql2 & " where d.id_sucursal = '"&idSucursal&"' "
		sql2 = sql2 & " and d.tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') "
		'sql2 = sql2 & " and (d.asistencia = 'no' "
		sql2 = sql2 & " and d.asistencia is null) as z "
		sql2 = sql2 & " group by z.id_zonal_mas, "
		sql2 = sql2 & " z.id_usuario, "
		sql2 = sql2 & " z.bt_sucursal "
		
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			porcentajeCajerosSucursalSR = rs2("porc_asist")			
		else
			porcentajeCajerosSucursalSR = 0
		end if
		porcentajeCajerosSucursalSR = validaPorcentaje(porcentajeCajerosSucursalSR)
		Response.Write "   ""porcentajeCajerosSucursalSR"": """ & porcentajeCajerosSucursalSR & """, "

'################################################################################################################'

		sql2 = ""
		'sql2 = sql2 & " select COUNT(id_asistencia) "
'		sql2 = sql2 & " from SUC_sucursal_guardias_asistencia  "
'		sql2 = sql2 & " where id_sucursal  = '"&id_sucursal&"'"
'		set rs2 = db.execute(sql2)
'		if not rs2.eof then
'			datos2 = rs2.GetRows()
'			For x = 0 to ubound(datos2, 2)
'				totalGuardiasSucursal = formatnumber(trim(datos2(0,x)),2)
'			next
'			if totalGuardiasSucursal <> 0 then
'				sql2 = ""
'				sql2 = sql2 & " select COUNT(asistencia) "
'				sql2 = sql2 & " from SUC_sucursal_guardias_asistencia "
'				sql2 = sql2 & " where id_sucursal  = '"&id_sucursal&"'"
'				sql2 = sql2 & "  and asistencia is not NULL "
'				set rs2 = db.execute(sql2)
'				if not rs2.eof then
'					datos2 = rs2.GetRows()
'					For x = 0 to ubound(datos2, 2)
'						totalGuardiasPresentesSucursal = trim(datos2(0,x))
'					next
'				else
'					totalGuardiasPresentesSucursal= 0
'				end if
'			else
'				totalGuardiasPresentesSucursal = 0
'			end if
'			if totalGuardiasPresentesSucursal <> 0 then
'				porcentajeGuardiasSucursal = 100 - totalGuardiasPresentesSucursal
'				porcentajeGuardiasSucursal = porcentajeCajerosZonal / totalGuardiasSucursal
'			else
'				porcentajeGuardiasSucursal = 0
'			end if
'		else
'			porcentajeGuardiasSucursal = 0
'		end if

		sql2 = sql2 & " select case "
		sql2 = sql2 & " when COUNT(a.id_asistencia) = 0 then 0 "
		sql2 = sql2 & " when COUNT(a.id_asistencia) > 0 then "	
		sql2 = sql2 & " (cast((select COUNT(b.id_asistencia) "
		sql2 = sql2 & " from SUC_sucursal_guardias_asistencia b "
		sql2 = sql2 & " where b.id_sucursal = '"&idSucursal&"' and "
		sql2 = sql2 & " b.asistencia = 'si') as float)*100) "
		sql2 = sql2 & " / "
		sql2 = sql2 & " CAST(COUNT(a.id_asistencia) as float) "
		sql2 = sql2 & " end as asistguardia "
		sql2 = sql2 & " from SUC_sucursal_guardias_asistencia a "
		sql2 = sql2 & " where a.id_sucursal = '"&idSucursal&"' "
		
		'response.Write(sql2)
		'response.End()
		
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			porcentajeGuardiasSucursal = rs2("asistguardia")
		end if
		porcentajeGuardiasSucursal = validaPorcentaje(porcentajeGuardiasSucursal)
		
		Response.Write "   ""porcentajeGuardiasSucursal"": """ & porcentajeGuardiasSucursal & """ "

		Response.Write "}"
	next
	Response.Write "]}"
end if%>