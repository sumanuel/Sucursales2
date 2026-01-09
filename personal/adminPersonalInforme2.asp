<!--#include file="../funciones.asp"-->
<%
tipoInforme = trim(request("tipoInforme"))
'response.write(tipoInforme)
'response.end
'1= Personal titular asistente
'2 = Suplente asistente
'3 = titular ausente
'4 = suplente ausente
'5 = todos no informados
'6 = Todos los titulares
'7 = todos los suplentes%>
<HTML>
<BODY>
<TABLE WIDTH=100% BORDER=1 CELLSPACING=1 CELLPADDING=1>
<TR>
	<TD style="background-color:#36F; color:#FFF; font-weight:bold;"><strong>BT_Sucursal</strong></TD>
   	<TD style="background-color:#36F; color:#FFF; font-weight:bold;"><strong>Nombre Sucursal</strong></TD>
    
    <TD style="background-color:#FF0; color:#000; font-weight:bold;"><strong>Reemplazo Desde</strong></TD>
    <TD style="background-color:#FF0; color:#000; font-weight:bold;"><strong>Reemplazo Hasta</strong></TD>
    
    <TD style="background-color:#36F; color:#FFF; font-weight:bold;"><strong>RUT Personal</strong></TD>
    <TD style="background-color:#36F; color:#FFF; font-weight:bold;"><strong>Nombre Personal</strong></TD>
            
    <TD style="background-color:#36F; color:#FFF; font-weight:bold;"><strong>Cargo</strong></TD>    
    <TD style="background-color:#36F; color:#FFF; font-weight:bold;"><strong>Tipo</strong></TD>
    
    <TD style="background-color:#FF0; color:#000; font-weight:bold;"><strong>Control Reemplazo</strong></TD>
    <TD style="background-color:#FF0; color:#000; font-weight:bold;"><strong>Rut Reemplazo</strong></TD>
    <TD style="background-color:#FF0; color:#000; font-weight:bold;"><strong>Nombre Reemplazo</strong></TD>
    
    <TD style="background-color:#36F; color:#FFF; font-weight:bold;"><strong>Empresa</strong></TD>
    
    <TD style="background-color:#0C9; color:#FFF; font-weight:bold;"><strong>Asistencia</strong></TD>
    <TD style="background-color:#36F; color:#FFF; font-weight:bold;"><strong>Hora Llegada</strong></TD>
    <TD style="background-color:#36F; color:#FFF; font-weight:bold;"><strong>Ingreso Sucursal</strong></TD>        
    <TD style="background-color:#36F; color:#FFF; font-weight:bold;"><strong>Atraso</strong></TD>
    
    <TD style="background-color:#36F; color:#FFF; font-weight:bold;"><strong>Hora Salida</strong></TD>
    <TD style="background-color:#36F; color:#FFF; font-weight:bold;"><strong>Salida Sucursal</strong></TD>    
    <TD style="background-color:#36F; color:#FFF; font-weight:bold;"><strong>Hora Extra</strong></TD>
    
    <TD style="background-color:#FF0; color:#000; font-weight:bold;"><strong>Titular a Reemplazar Rut</strong></TD>
    <TD style="background-color:#FF0; color:#000; font-weight:bold;"><strong>Titular a Reemplazar Nombre</strong></TD>
</TR>
<%
if tipoInforme = "8" then
	valorFecha= trim(request("valorFecha"))
	if valorFecha ="" then
		sql = ""
		sql = sql & " select distinct"
		sql = sql & " d.bt_sucursal, "
		sql = sql & " d.suc_nombre, "
		sql = sql & " isnull(convert(varchar(20), e.desde),'') as reemplazo_desde, "
		sql = sql & " isnull(convert(varchar(20), e.hasta),'') as reemplazo_hasta,	"
		sql = sql & " d.rut_personal, "
		sql = sql & " d.nombre_personal, "
		sql = sql & " d.tipo_personal, "
		sql = sql & " d.tipo, "
		sql = sql & " d.control_reemplazo, "
		sql = sql & " d.rut_reemplazo, " 
		sql = sql & " d.nombre_reemplazo, "
		sql = sql & " d.empresa, "
		sql = sql & " d.asistencia, "
		sql = sql & " convert(varchar(30),cast(d.hora_llegada as time)) as hora_llegada, "
		sql = sql & " convert(varchar(30),cast(d.ingreso_sucursal as time)) as ingreso_sucursal, "
		sql = sql & " d.atraso, "
		sql = sql & " convert(varchar(30),cast(d.hora_salida as time)) as hora_salida, "
		sql = sql & " convert(varchar(30),cast(d.salida_sucursal as time)) as salida_sucursal, "
		sql = sql & " d.hora_extra, "
		sql = sql & " d.titular_areemplazar_rut, "
		sql = sql & " d.titular_areemplazar_nombre, "
		sql = sql & " convert(varchar(30),cast(isnull(d.hora_reg_asist, '00:00') as time)) as hora_reg_asist "
		sql = sql & " from ( "
		sql = sql & " select "
		sql = sql & " m.*, "
		sql = sql & " case "
		sql = sql & " when isnull(c.rut_reemp,'') = '' then 'NO' "
		sql = sql & " else 'SI' "
		sql = sql & " end as control_reemplazo, "
		sql = sql & " isnull(c.rut_reemp,'') as rut_reemplazo, " 
		sql = sql & " isnull(c.nombre_reemp,'') as nombre_reemplazo "
		sql = sql & " from ( "
		sql = sql & " select "
		sql = sql & " z.bt_sucursal, z.suc_nombre, z.rut_personal, z.nombre_personal, z.tipo, z.tipo_personal, z.empresa, "
		sql = sql & " case "
		sql = sql & " when ISNULL(z.asistencia,'') = '' then 'S/R' "
		sql = sql & " when z.asistencia = 'si' then 'presente' "
		sql = sql & " when z.asistencia = 'no' then 'ausente' "
		sql = sql & " end as asistencia, "
		sql = sql & " case "
		sql = sql & " when isnull(z.hora_llegada, '') = '' then '00:00' "
		sql = sql & " else (z.hora_llegada+':'+z.min_llegada) "
		sql = sql & " end as hora_llegada, "
		sql = sql & " convert(varchar(5), z.hora_ingreso) as ingreso_sucursal, "   
		sql = sql & " case " 
		sql = sql & " when isnull(z.hora_llegada, '') = '' then 'N/A' "
		sql = sql & " when cast((z.hora_llegada+':'+z.min_llegada) as time) <= CAST(z.hora_ingreso as time) then 'Ok' "
		sql = sql & " when cast((z.hora_llegada+':'+z.min_llegada) as time) > CAST(z.hora_ingreso as time) then 'Atraso' "
		sql = sql & " end atraso, "
		sql = sql & " case "
		sql = sql & " when isnull(z.hora_salida, '') = '' then '00:00' "
		sql = sql & " else (z.hora_salida+':'+z.min_salida) "
		sql = sql & " end as hora_salida, "
		sql = sql & " convert(varchar(5), z.hora_salida_p) as salida_sucursal, "
		sql = sql & " case "
		sql = sql & " when isnull(z.hora_salida, '') = '' then 'N/A' "
		sql = sql & " when cast((z.hora_salida+':'+z.min_salida) as time) = CAST(z.hora_salida_p as time) then 'Ok' "
		sql = sql & " when cast((z.hora_salida+':'+z.min_salida) as time) > CAST(z.hora_salida_p as time) then 'Hora Extra' "
		sql = sql & " when cast((z.hora_salida+':'+z.min_salida) as time) < CAST(z.hora_salida_p as time) then 'Retiro temprano' "
		sql = sql & " end hora_extra, "
		sql = sql & " isnull(y.rut_titular, '') as titular_areemplazar_rut, "
		sql = sql & " isnull(y.nombre_titular, '') as titular_areemplazar_nombre, "
		sql = sql & " z.hora_reg_asist "
		sql = sql & " from ( "
		sql = sql & " select "
		sql = sql & " a.bt_sucursal, c.suc_nombre, a.rut_personal, a.nombre_personal, a.tipo, a.tipo_personal, a.asistencia, " 
		sql = sql & " a.hora_llegada, a.min_llegada, a.hora_salida, a.min_salida ,a.empresa, a.hora_reg_asist,"
		sql = sql & " case "
		sql = sql & " when isnull(b.hora_ingreso, '00:00:00.0000000') = '00:00:00.0000000' then '08:45:00.0000000' "
		sql = sql & " else b.hora_ingreso "
		sql = sql & " end as hora_ingreso, "
		sql = sql & " case "
		sql = sql & " when isnull(b.hora_salida, '00:00:00.0000000') = '00:00:00.0000000' then '18:30:00.0000000' "
		sql = sql & " else b.hora_salida "
		sql = sql & " end as hora_salida_p "
		sql = sql & " from SUC_sucursal_asistencia_personal a "
		sql = sql & " left join SUC_sucursal_reemplazos b on a.rut_personal = b.rut_reemp "
		sql = sql & " inner join SUC_sucursal c on a.bt_sucursal = c.cod_bantotal "
		sql = sql & " ) as z "
		sql = sql & " left join SUC_sucursal_reemplazos y on z.rut_personal = y.rut_reemp "
		sql = sql & " ) as m "
		sql = sql & " left join SUC_sucursal_reemplazos c on m.rut_personal = c.rut_titular "
		sql = sql & " ) as d "	
		sql = sql & " left join SUC_sucursal_reemplazos e on d.rut_personal = e.rut_reemp "
		sql = sql & " order by d.suc_nombre "
	else
		sql = ""
		sql = sql & " set dateformat dmy "
		'sql = sql & " DECLARE @fecha_respaldo varchar(50) "
		'sql = sql & " SET @fecha_respaldo = '"&valorFecha&"' "
		sql = sql & " select distinct "
		sql = sql & " d.fecha_respaldo, "
		sql = sql & " d.bt_sucursal, "
		sql = sql & " d.suc_nombre, "
		sql = sql & " isnull(convert(varchar(20), e.desde),'') as reemplazo_desde, "
		sql = sql & " isnull(convert(varchar(20), e.hasta),'') as reemplazo_hasta, "
		sql = sql & " d.rut_personal, "
		sql = sql & " d.nombre_personal, "
		sql = sql & " d.tipo_personal, "
		sql = sql & " d.tipo, "
		sql = sql & " d.control_reemplazo, "
		sql = sql & " d.rut_reemplazo, "
		sql = sql & " d.nombre_reemplazo, "
		sql = sql & " d.empresa, "
		sql = sql & " d.asistencia, "
		sql = sql & " d.hora_llegada, "
		sql = sql & " d.ingreso_sucursal, "
		sql = sql & " d.atraso, "
		sql = sql & " d.hora_salida, "
		sql = sql & " d.salida_sucursal, "
		sql = sql & " d.hora_extra, "
		sql = sql & " d.titular_areemplazar_rut, "
		sql = sql & " d.titular_areemplazar_nombre "      
		sql = sql & " from ( "
		sql = sql & " select "
		sql = sql & " m.*, "
		sql = sql & " case "
		sql = sql & " when isnull(c.rut_reemp,'') = '' then 'NO' "
		sql = sql & " else 'SI' "
		sql = sql & " end as control_reemplazo, "
		sql = sql & " isnull(c.rut_reemp,'') as rut_reemplazo, "
		sql = sql & " isnull(c.nombre_reemp,'') as nombre_reemplazo "
		sql = sql & " from ( "
		sql = sql & " select z.fecha_respaldo, "
		sql = sql & " z.bt_sucursal, z.suc_nombre, "
		sql = sql & " z.rut_personal, z.nombre_personal, z.tipo, z.tipo_personal, z.empresa, "
		sql = sql & " case "
		sql = sql & " when ISNULL(z.asistencia,'') = '' then 'S/R' "
		sql = sql & " when z.asistencia = 'si' then 'presente' "
		sql = sql & " when z.asistencia = 'no' then 'ausente' "
		sql = sql & " end as asistencia, "
		sql = sql & " case "
		sql = sql & " when isnull(z.hora_llegada, '') = '' then '00:00' "
		sql = sql & " else (z.hora_llegada+':'+z.min_llegada) "
		sql = sql & " end as hora_llegada, "
		sql = sql & " convert(varchar(5), z.hora_ingreso) as ingreso_sucursal, "
		sql = sql & " case "
		sql = sql & " when isnull(z.hora_llegada, '') = '' then 'N/A' "
		sql = sql & " when cast((z.hora_llegada+':'+z.min_llegada) as time) <= CAST(z.hora_ingreso as time) then 'Ok' "
		sql = sql & " when cast((z.hora_llegada+':'+z.min_llegada) as time) > CAST(z.hora_ingreso as time) then 'Atraso' "
		sql = sql & " end atraso, "
		sql = sql & " case  "
		sql = sql & " when isnull(z.hora_salida, '') = '' then '00:00' "
		sql = sql & " else (z.hora_salida+':'+z.min_salida) "
		sql = sql & " end as hora_salida, "
		sql = sql & " convert(varchar(5), z.hora_salida_p) as salida_sucursal, "
		sql = sql & " case "
		sql = sql & " when isnull(z.hora_salida, '') = '' then 'N/A' "
		sql = sql & " when cast((z.hora_salida+':'+z.min_salida) as time) = CAST(z.hora_salida_p as time) then 'Ok' "
		sql = sql & " when cast((z.hora_salida+':'+z.min_salida) as time) > CAST(z.hora_salida_p as time) then 'Hora Extra' "
		sql = sql & " when cast((z.hora_salida+':'+z.min_salida) as time) "
		sql = sql & " < CAST(z.hora_salida_p as time) then 'Retiro temprano' "
		sql = sql & " end hora_extra, "
		sql = sql & " isnull(y.rut_titular, '') as titular_areemplazar_rut, "
		sql = sql & " isnull(y.nombre_titular, '') as titular_areemplazar_nombre "
		sql = sql & " from ( "
		sql = sql & " select a.fecha_respaldo, "
		sql = sql & " a.bt_sucursal, c.suc_nombre, a.rut_personal, "
		sql = sql & " a.nombre_personal, a.tipo, a.tipo_personal, a.asistencia, "
		sql = sql & " a.hora_llegada, a.min_llegada, a.hora_salida, a.min_salida ,a.empresa, "
		sql = sql & " case "
		sql = sql & " when isnull(b.hora_ingreso, '00:00:00.0000000') = '00:00:00.0000000' then '08:45:00.0000000' "
		sql = sql & " else b.hora_ingreso "
		sql = sql & " end as hora_ingreso, "
		sql = sql & " case "
		sql = sql & " when isnull(b.hora_salida, '00:00:00.0000000') = '00:00:00.0000000' then '18:30:00.0000000' "
		sql = sql & " else b.hora_salida "
		sql = sql & " end as hora_salida_p "
		sql = sql & " from SUC_sucursal_asistencia_personal_respaldo a "
		sql = sql & " left join SUC_sucursal_reemplazos_resp b on a.rut_personal = b.rut_reemp "
		sql = sql & " and a.fecha_respaldo = b.fecha_respaldo "
		sql = sql & " inner join SUC_sucursal c on a.bt_sucursal = c.cod_bantotal "
		sql = sql & " ) as z "
		sql = sql & " left join SUC_sucursal_reemplazos_resp y "
		sql = sql & " on z.rut_personal = y.rut_reemp and z.fecha_respaldo = y.fecha_respaldo "
		sql = sql & " ) as m "
		sql = sql & " left join SUC_sucursal_reemplazos_resp c "
		sql = sql & " on m.rut_personal = c.rut_titular and m.fecha_respaldo = c.fecha_respaldo "
		sql = sql & " ) as d "
		sql = sql & " left join SUC_sucursal_reemplazos_resp e on "
		sql = sql & " d.rut_personal = e.rut_reemp and d.fecha_respaldo = e.fecha_respaldo "
		sql = sql & " where d.fecha_respaldo = '"&valorFecha&"' "
		sql = sql & " order by d.suc_nombre "
	end if

	'response.write(sql)
	'response.end()

	set rs = db.execute(sql)	
 	if not rs.eof then 	
		do while not rs.eof
			bt_sucursal = rs("bt_sucursal")
			suc_nombre = server.htmlencode(trim(rs("suc_nombre")))			
			reemplazo_desde = server.htmlencode(trim(rs("reemplazo_desde")))
			reemplazo_hasta = server.htmlencode(trim(rs("reemplazo_hasta")))						
			rut_personal = server.htmlencode(trim(rs("rut_personal")))
			nombre_personal = server.htmlencode(trim(rs("nombre_personal")))
			tipo_personal = rs("tipo_personal")
			tipo = rs("tipo")			
			control_reemplazo = server.htmlencode(trim(rs("control_reemplazo")))
			rut_reemplazo = server.htmlencode(trim(rs("rut_reemplazo")))
			nombre_reemplazo = server.htmlencode(trim(rs("nombre_reemplazo")))
			empresa = server.htmlencode(trim(rs("empresa")))
			asistencia = rs("asistencia")
			hora_llegada = rs("hora_llegada")
			ingreso_sucursal = rs("ingreso_sucursal")
			atraso = rs("atraso")			
			hora_salida = server.htmlencode(trim(rs("hora_salida")))
			salida_sucursal = server.htmlencode(trim(rs("salida_sucursal")))
			hora_extra = server.htmlencode(trim(rs("hora_extra")))
			titular_areemplazar_rut = server.htmlencode(trim(rs("titular_areemplazar_rut")))
			titular_areemplazar_nombre = server.htmlencode(trim(rs("titular_areemplazar_nombre")))
			'hora_reg_asist = server.htmlencode(trim(rs("hora_reg_asist")))
			
			%>
				<TR>
					<TD><%=bt_sucursal%></TD>
                    <TD><%=suc_nombre%></TD>
                    <TD><%=reemplazo_desde%></TD>
                    <TD><%=reemplazo_hasta%></TD>
                    <TD><%=rut_personal%></TD>
                    <TD><%=nombre_personal%></TD>
                    
                    <TD><%=tipo_personal%></TD>
                    <TD><%=tipo%></TD>
                    
                    <TD><%=control_reemplazo%></TD>
                    <TD><%=rut_reemplazo%></TD>
                    <TD><%=nombre_reemplazo%></TD>
                    <TD><%=empresa%></TD>
                    
                    <TD><%=asistencia%></TD>
                    <TD><%=hora_llegada%></TD>
                    <TD><%=ingreso_sucursal%></TD>
                    <TD><%=atraso%></TD>
                    
                    <TD><%=hora_salida%></TD>
                    <TD><%=salida_sucursal%></TD>
                    <TD><%=hora_extra%></TD>
                    
                    <TD><%=titular_areemplazar_rut%></TD>
                    <TD><%=titular_areemplazar_nombre%></TD>
                    
                    
                </TR>
			<%
					
		rs.MoveNext
		Loop
	end if	
end if
' Clean up
rs.Close
set rs = Nothing
%>
</TABLE>
</BODY>
</HTML>
<%Response.Buffer = TRUE

Response.end()

Response.ContentType = "application/vnd.ms-excel"
if valorFecha = "" then
	nombreArchivo = "admin_personal_excel_atrasos.xls"
else
	nombreArchivo = "admin_personal_excel_atrasos_"&valorFecha&".xls"
	
end if
Response.AddHeader "Content-Disposition", "attachment; filename=" %>