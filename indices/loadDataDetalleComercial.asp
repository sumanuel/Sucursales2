<!--#include file="../funciones.asp"-->
<%
sql = ""
sql = sql & " select id_usuario "
sql = sql & " from SUC_zonales_comercial "
sql = sql & " where estado_zonal = 1 "
if idZonal <> "" then
	sql = sql & " and id_zona = '"&idZona&"' "
end if
set rs = db.execute(sql)
if not rs.eof then
	Response.ContentType = "application/json"
	Response.Write "{"
	Response.Write "  ""datos"": ["
	count = 0
	datos = rs.GetRows()
	For i = 0 to ubound(datos, 2)
		idZonal = trim(datos(0,i))
		count = count + 1
		If count > 1 Then
			Response.Write ", "
		End If
		Response.Write "{ "      
		Response.Write "   ""idZonal"": """ & idZonal & """, "
  		sql2 =""
		sql2 = sql2 & " select isnull(AVG(porc_cumpl),0) as porc_cumpl "
		sql2 = sql2 & " from SUC_gest_admin_control "
		sql2 = sql2 & " where fecha_operacion = cast(GETDATE() as date) and "
		sql2 = sql2 & " estado = 1 and "
		sql2 = sql2 & " id_sucursal in "
		sql2 = sql2 & " (select id_sucursal from SUC_zonales_comercial_sucursal "
		sql2 = sql2 & " where id_zonal = '"&idZonal&"') "
		
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			promedioAdm = rs2("porc_cumpl")
		else
			promedioAdm = 0
		end if
		promedioAdm = validaPorcentaje(promedioAdm)
		Response.Write "   ""promedioAdm"": """ & promedioAdm & """, "
		sql2 =""
		sql2 = sql2 & " select "
		sql2 = sql2 & " isnull (AVG(a.porc_cumpl),0) as porc_cumpl  "
		sql2 = sql2 & " from SUC_gest_cont_control a "
		sql2 = sql2 & " where a.fecha_operacion = cast(GETDATE() as DATE) "
		sql2 = sql2 & " and a.estado = 1 "
		sql2 = sql2 & " and a.id_sucursal in (select id_sucursal from SUC_zonales_comercial_sucursal "
		sql2 = sql2 & " where id_zonal = '"&idZonal&"') "
		
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			promedioCont = rs2("porc_cumpl")
		else
			promedioCont = 0
		end if
		promedioCont = validaPorcentaje(promedioCont)
		Response.Write "   ""promedioCont"": """ & promedioCont & """, "
		sql2 =""
		sql2 = sql2 & " select "
		sql2 = sql2 & " isnull (AVG(a.porc_cumpl),0) as porc_cumpl  "
		sql2 = sql2 & " from SUC_gest_doc_control a "
		sql2 = sql2 & " where a.fecha_operacion = cast(GETDATE() as DATE) "
		sql2 = sql2 & " and a.estado = 1 "
		sql2 = sql2 & " and a.id_sucursal in (select id_sucursal from SUC_zonales_comercial_sucursal "
		sql2 = sql2 & " where id_zonal = '"&idZonal&"') "
		
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			promedioDoc = rs2("porc_cumpl")
		else
			promedioDoc = 0
		end if
		promedioDoc = validaPorcentaje(promedioDoc)
		Response.Write "   ""promedioDoc"": """ & promedioDoc & """, "
'################################################################################

		sql2 = ""
		sql2 = sql2 & " select z.id_zonal_c, "
		sql2 = sql2 & " z.id_usuario, "
		sql2 = sql2 & " COUNT(*) as nro, " 
		sql2 = sql2 & " (select COUNT(*) "
		sql2 = sql2 & " from SUC_sucursal_asistencia_personal "
		sql2 = sql2 & " where tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') "
		sql2 = sql2 & " and bt_sucursal in "
		sql2 = sql2 & " (select cod_bantotal "
		sql2 = sql2 & " from SUC_sucursal "
		sql2 = sql2 & " where id_sucursal in "
		sql2 = sql2 & " (select id_sucursal "
		sql2 = sql2 & " from SUC_zonales_comercial_sucursal "
		sql2 = sql2 & " where id_zonal = z.id_usuario))) as totalcajeros, "
		sql2 = sql2 & " (cast((COUNT(*)*100) as float)/cast((select COUNT(*) "
		sql2 = sql2 & " from SUC_sucursal_asistencia_personal "
		sql2 = sql2 & " where tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') "
		sql2 = sql2 & " and bt_sucursal in "
		sql2 = sql2 & " (select cod_bantotal "
		sql2 = sql2 & " from SUC_sucursal "
		sql2 = sql2 & " where id_sucursal in "
		sql2 = sql2 & " (select id_sucursal "
		sql2 = sql2 & " from SUC_zonales_comercial_sucursal "
		sql2 = sql2 & " where id_zonal = z.id_usuario))) "
		sql2 = sql2 & " as float)) as porc "
		sql2 = sql2 & " from( "
		sql2 = sql2 & " select a.id_zonal_c, "
		sql2 = sql2 & " a.id_usuario, "
		sql2 = sql2 & " a.zonal, "
		sql2 = sql2 & " c.id_sucursal, "
		sql2 = sql2 & " c.suc_nombre, "
		sql2 = sql2 & " d.bt_sucursal, "
		sql2 = sql2 & " d.rut_personal, "
		sql2 = sql2 & " d.tipo, "
		sql2 = sql2 & " d.tipo_personal, "
		sql2 = sql2 & " d.asistencia "
		sql2 = sql2 & " from SUC_zonales_comercial a "
		sql2 = sql2 & " inner join SUC_zonales_comercial_sucursal b "
		sql2 = sql2 & " on a.id_usuario = b.id_zonal "
		sql2 = sql2 & " inner join SUC_sucursal c "
		sql2 = sql2 & " on b.id_sucursal = c.id_sucursal "
		sql2 = sql2 & " inner join SUC_sucursal_asistencia_personal d "
		sql2 = sql2 & " on c.cod_bantotal = d.bt_sucursal "
		sql2 = sql2 & " where a.id_usuario = '"&idZonal&"' and "
		sql2 = sql2 & " d.tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') "
		sql2 = sql2 & " and d.asistencia = 'si') as z "
		sql2 = sql2 & " group by z.id_zonal_c, z.id_usuario "

		set rs2 = db.execute(sql2)
		if not rs2.eof then
			datos2 = rs2.GetRows()
			For x = 0 to ubound(datos2, 2)
				porcentajeCajerosZonalP = trim(datos2(4,x))
			next
		else
			porcentajeCajerosZonalP = 0
		end if
		porcentajeCajerosZonalP = validaPorcentaje(porcentajeCajerosZonalP)
		Response.Write "   ""porcentajeCajerosZonalP"": """ & porcentajeCajerosZonalP & """, "

		sql2 = ""
		sql2 = sql2 & " select z.id_zonal_c, "
		sql2 = sql2 & " z.id_usuario, "
		sql2 = sql2 & " COUNT(*) as nro, "
		sql2 = sql2 & " (select COUNT(*) "
		sql2 = sql2 & " from SUC_sucursal_asistencia_personal "
		sql2 = sql2 & " where tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') and "
		sql2 = sql2 & " bt_sucursal in "
		sql2 = sql2 & " (select cod_bantotal "
		sql2 = sql2 & " from SUC_sucursal "
		sql2 = sql2 & " where id_sucursal in "
		sql2 = sql2 & " (select id_sucursal "
		sql2 = sql2 & " from SUC_zonales_comercial_sucursal "
		sql2 = sql2 & " where id_zonal = z.id_usuario))) as totalcajeros, "
		sql2 = sql2 & " (cast((COUNT(*)*100) as float)/cast((select COUNT(*) "
		sql2 = sql2 & " from SUC_sucursal_asistencia_personal "
		sql2 = sql2 & " where tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') and "
		sql2 = sql2 & " bt_sucursal in "
		sql2 = sql2 & " (select cod_bantotal "
		sql2 = sql2 & " from SUC_sucursal "
		sql2 = sql2 & " where id_sucursal in "
		sql2 = sql2 & " (select id_sucursal "
		sql2 = sql2 & " from SUC_zonales_comercial_sucursal "
		sql2 = sql2 & " where id_zonal = z.id_usuario))) as float)) as porc "
		sql2 = sql2 & " from( "
		sql2 = sql2 & " select a.id_zonal_c, "
		sql2 = sql2 & " a.id_usuario, "
		sql2 = sql2 & " a.zonal, "
		sql2 = sql2 & " c.id_sucursal, "
		sql2 = sql2 & " c.suc_nombre, "
		sql2 = sql2 & " d.bt_sucursal, "
		sql2 = sql2 & " d.rut_personal, "
		sql2 = sql2 & " d.tipo, "
		sql2 = sql2 & " d.tipo_personal, "
		sql2 = sql2 & " d.asistencia "
		sql2 = sql2 & " from SUC_zonales_comercial a "
		sql2 = sql2 & " inner join SUC_zonales_comercial_sucursal b "
		sql2 = sql2 & " on a.id_usuario = b.id_zonal "
		sql2 = sql2 & " inner join SUC_sucursal c "
		sql2 = sql2 & " on b.id_sucursal = c.id_sucursal "
		sql2 = sql2 & " inner join SUC_sucursal_asistencia_personal d "
		sql2 = sql2 & " on c.cod_bantotal = d.bt_sucursal "
		sql2 = sql2 & " where a.id_usuario = '"&idZonal&"' and "
		sql2 = sql2 & " d.tipo_personal in "
		sql2 = sql2 & " ('Cajero', 'CAJERO ADICIONAL') "
		sql2 = sql2 & " and d.asistencia = 'no' "
		'sql2 = sql2 & " or d.asistencia is null) "
		sql2 = sql2 & " ) as z "
		sql2 = sql2 & " group by z.id_zonal_c, z.id_usuario "

		set rs2 = db.execute(sql2)
		if not rs2.eof then
			datos2 = rs2.GetRows()
			For x = 0 to ubound(datos2, 2)
				porcentajeCajerosZonalA = trim(datos2(4,x))
			next
		else
			porcentajeCajerosZonalA = 0
		end if
		porcentajeCajerosZonalA = validaPorcentaje(porcentajeCajerosZonalA)
		Response.Write "   ""porcentajeCajerosZonalA"": """ & porcentajeCajerosZonalA & """, "

'##########################################################################

	sql2 = ""
	sql2 = sql2 & " select "
	sql2 = sql2 & " z.id_zonal_c, "
	sql2 = sql2 & " z.id_usuario, "
	sql2 = sql2 & " COUNT(*) as nro, "
	sql2 = sql2 & " (select COUNT(*) "
	sql2 = sql2 & " from SUC_sucursal_asistencia_personal "
	sql2 = sql2 & " where tipo_personal in ('Cajero', 'CAJERO ADICIONAL') and "
	sql2 = sql2 & " bt_sucursal in (select cod_bantotal from SUC_sucursal "
	sql2 = sql2 & " where id_sucursal in (select id_sucursal from "
	sql2 = sql2 & " SUC_zonales_comercial_sucursal where "
	sql2 = sql2 & " id_zonal = z.id_usuario))) as totalcajeros, "
	sql2 = sql2 & " (cast((COUNT(*)*100) as float)/cast((select "
	sql2 = sql2 & " COUNT(*) from SUC_sucursal_asistencia_personal "
	sql2 = sql2 & " where tipo_personal in ('Cajero', 'CAJERO ADICIONAL') and "
	sql2 = sql2 & " bt_sucursal in (select cod_bantotal from SUC_sucursal "
	sql2 = sql2 & " where id_sucursal in (select id_sucursal "
	sql2 = sql2 & " from SUC_zonales_comercial_sucursal where "
	sql2 = sql2 & " id_zonal = z.id_usuario))) as float)) as porc "
	sql2 = sql2 & " from( select "
	sql2 = sql2 & " a.id_zonal_c, "
	sql2 = sql2 & " a.id_usuario, "
	sql2 = sql2 & " a.zonal, "
	sql2 = sql2 & " c.id_sucursal, "
	sql2 = sql2 & " c.suc_nombre, "
	sql2 = sql2 & " d.bt_sucursal, "
	sql2 = sql2 & " d.rut_personal, "
	sql2 = sql2 & " d.tipo, "
	sql2 = sql2 & " d.tipo_personal, "
	sql2 = sql2 & " d.asistencia "
	sql2 = sql2 & " from SUC_zonales_comercial a "
	sql2 = sql2 & " inner join SUC_zonales_comercial_sucursal b "
	sql2 = sql2 & " on a.id_usuario = b.id_zonal "
	sql2 = sql2 & " inner join SUC_sucursal c on "
	sql2 = sql2 & " b.id_sucursal = c.id_sucursal "
	sql2 = sql2 & " inner join SUC_sucursal_asistencia_personal d "
	sql2 = sql2 & " on c.cod_bantotal = d.bt_sucursal "
	sql2 = sql2 & " where a.id_usuario = '"&idZonal&"' "
	sql2 = sql2 & " and d.tipo_personal "
	sql2 = sql2 & " in ('Cajero', 'CAJERO ADICIONAL') "
	sql2 = sql2 & " and d.asistencia is null) as z "
	sql2 = sql2 & " group by z.id_zonal_c, z.id_usuario "
	set rs2 = db.execute(sql2)
	if not rs2.eof then
		porcentajeCajerosZonalSR = rs2("porc")
	else 
		porcentajeCajerosZonalSR = 0
	end if
	
	porcentajeCajerosZonalSR = validaPorcentaje(porcentajeCajerosZonalSR)
	Response.Write "   ""porcentajeCajerosZonalSR"": """ & porcentajeCajerosZonalSR & """, "
	
'##########################################################################

		sql2 = ""
		sql2 = sql2 & " select "
		sql2 = sql2 & " (cast((select COUNT(id_asistencia) "
		sql2 = sql2 & " from SUC_sucursal_guardias_asistencia "
		sql2 = sql2 & " where id_sucursal  in "
		sql2 = sql2 & " (select id_sucursal from SUC_zonales_comercial_sucursal "
		sql2 = sql2 & " where id_zonal = '"&idZonal&"') "
		sql2 = sql2 & " and asistencia = 'si') as float)*100) "
		sql2 = sql2 & " / "
		sql2 = sql2 & " cast( (select COUNT(id_asistencia) "
		sql2 = sql2 & " from SUC_sucursal_guardias_asistencia "
		sql2 = sql2 & " where id_sucursal in "
		sql2 = sql2 & " (select id_sucursal from SUC_zonales_comercial_sucursal "
		sql2 = sql2 & " where id_zonal = '"&idZonal&"')) as float) as porc_guardias"
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			porcentajeGuardiasZonal = rs2("porc_guardias")
		else 
			porcentajeGuardiasZonal = 0
		end if
		porcentajeGuardiasZonal = validaPorcentaje(porcentajeGuardiasZonal)
		
		Response.Write "   ""porcentajeGuardiasZonal"": """ & porcentajeGuardiasZonal & """, "
'##########################################################################################'

		sql2 = ""
		sql2 = sql2 & " select y.id_usuario, y.zonal, y.porc_apertura, y.porc_sinr, y.porc_cerradas "
		sql2 = sql2 & " from ( "
		sql2 = sql2 & " select z.id_usuario, z.zonal, "
		sql2 = sql2 & " (cast((z.total_apertura*100) as float)/cast(z.total as float)) as porc_apertura, "
		sql2 = sql2 & " (cast((z.total-z.total_apertura)*100 as float)/cast(z.total as float)) as porc_sinr, "
		sql2 = sql2 & " (cast((z.total_cerrada*100) as float)/cast(z.total as float)) as porc_cerradas "
		sql2 = sql2 & " from (select w.*, "
		sql2 = sql2 & " (select COUNT(*) from SUC_sucursal_apertura "
		sql2 = sql2 & " where fecha_ingreso = cast(GETDATE() as DATE) and tipo = 1 and "
		sql2 = sql2 & " id_sucursal in ( "
		sql2 = sql2 & " select id_sucursal from SUC_zonales_comercial_sucursal where id_zonal = w.id_usuario)) as total_apertura, "
		sql2 = sql2 & " (select COUNT(*) from SUC_sucursal_apertura "
		sql2 = sql2 & " where fecha_ingreso = cast(GETDATE() as DATE) and tipo = 2 and "
		sql2 = sql2 & " id_sucursal in ( "
		sql2 = sql2 & " select id_sucursal from SUC_zonales_comercial_sucursal where id_zonal = w.id_usuario)) as total_cerrada  "
		sql2 = sql2 & " from ( "
		sql2 = sql2 & " select z.id_usuario, z.zonal, "
		sql2 = sql2 & " (select COUNT(*) from SUC_zonales_comercial_sucursal where id_zonal = z.id_usuario) as total "
		sql2 = sql2 & " from ( "
		sql2 = sql2 & " select id_usuario, zonal from SUC_zonales_comercial where id_usuario = '"&idZonal&"' "
		sql2 = sql2 & " ) as z) as w) as z) as y "
		set rs2 = db.execute(sql2)
		'response.Write(sql2)
		'response.end
		if not rs2.eof then
			porcentajeApertura = trim(rs2("porc_apertura"))
			porcentajeSinRegistro = trim(rs2("porc_sinr"))
			porcentajeCerradas = trim(rs2("porc_cerradas"))
		end if
		Response.Write "   ""porcentajeApertura"": """ & porcentajeApertura & """, "
		Response.Write "   ""porcentajeSinRegistro"": """ & porcentajeSinRegistro & """, "
		Response.Write "   ""porcentajeCerradas"": """ & porcentajeCerradas & """ "

		Response.Write "}"
	next
	Response.Write "]}"
else
	sql2 = ""
	sql2 = sql2 & " select id_zonal, "
	sql2 = sql2 & " id_sucursal "
	sql2 = sql2 & " from SUC_zonales_comercial_sucursal "
	sql2 = sql2 & " where id_zonal in ( "
	sql2 = sql2 & " select id_zonal "
	sql2 = sql2 & " from SUC_zonales_comercial_sucursal "
	sql2 = sql2 & " where id_zona='"&idZona&"') "
	sql2 = sql2 & " order by id_zonal "
	set rs2 = db.execute(sql2)
	if not rs2.eof then
		Response.ContentType = "application/json"
		Response.Write "{"
		Response.Write "  ""datos"": ["
		count = 0
		datos = rs2.GetRows()
		For i = 0 to ubound(datos, 2)
			idZonal = trim(datos(0,i))
            promedioAdm = 0
            promedioCont = 0
            promedioDoc = 0
            porcentajeCajerosZonal = 0
            porcentajeGuardiasZonal = 0
            porcentajeCajerosZonalP = 0
            porcentajeCajerosZonalA = 0
			count = count + 1
			If count > 1 Then
				Response.Write ", "
			End If
			Response.Write "{ "      
			Response.Write "   ""idZonal"": """ & idZonal & """, "
			
            Response.Write "   ""promedioAdm"": """ & promedioAdm & """, "
            Response.Write "   ""promedioCont"": """ & promedioCont & """, "
            Response.Write "   ""promedioDoc"": """ & promedioDoc & """, "
            
            Response.Write "   ""porcentajeCajerosZonalP"": """ & porcentajeCajerosZonalP & """, "
            Response.Write "   ""porcentajeCajerosZonalA"": """ & porcentajeCajerosZonalA & """, "
            
            Response.Write "   ""porcentajeGuardiasZonal"": """ & porcentajeGuardiasZonal & """ "
			Response.Write "}"
		next
		Response.Write "]}"
	end if
end if%>

