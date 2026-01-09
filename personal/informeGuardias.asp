<!--#include file="../funciones.asp"-->
<%valorFecha = trim(request("valorFecha"))
tipoInforme = trim(request("tipoInforme"))

'response.write("valorFecha: " & valorFecha)
'response.write("tipoInforme: " & tipoInforme)


if tipoInforme = "1" then

	sql = ""
	sql = sql & " select "
	sql = sql & " y.cod_bantotal, "    
	sql = sql & " y.suc_nombre, "
	sql = sql & " y.desde, "
	sql = sql & " y.hasta, "
	sql = sql & " y.guardia_rut, "
	sql = sql & " y.guardia_nombre, "
	sql = sql & " y.tipo_suc, "             
	sql = sql & " y.control_reemplazo, "
	sql = sql & " y.reemplazo_guardia_rut, " 
	sql = sql & " y.reemplazo_guardia_nombre, "     
	sql = sql & " y.empresa, "
	sql = sql & " y.asistencia, "
	sql = sql & " y.hora_llegada, "
	sql = sql & " y.ingreso_sucursal, "
	sql = sql & " y.atraso, "
	sql = sql & " y.hora_salida, "
	sql = sql & " y.salida_sucursal, "
	sql = sql & " y.hora_extra, "
	sql = sql & " y.titular_areemplazar, "
	sql = sql & " isnull(e.guardia_nombre,'') as titular_areemplazar_nombre "
	sql = sql & " from ( "
	sql = sql & " select x.*, " 
	sql = sql & " case "
	sql = sql & " when isnull(d.guardia_rut,'') = '' then 'NO' "
	sql = sql & " when isnull(d.guardia_rut,'') <> '' then 'SI' "
	sql = sql & " end control_reemplazo, "
	sql = sql & " rtrim(ltrim(isnull(d.guardia_rut,''))) as reemplazo_guardia_rut, "
	sql = sql & " rtrim(ltrim(isnull(d.guardia_nombre,''))) as reemplazo_guardia_nombre     "              
	sql = sql & " from ( "
	sql = sql & " select z.*, isnull(c.desde,'') as desde, isnull(c.hasta,'') as hasta, isnull(c.guardia_rut_titular,'') as titular_areemplazar "
	sql = sql & " from ( "
	sql = sql & " select "
	sql = sql & " a.cod_bantotal, b.suc_nombre, a.guardia_rut, a.guardia_nombre, a.tipo_suc, a.empresa, "
	sql = sql & " case "
	sql = sql & " when isnull(a.asistencia,'') = 'si' then 'presente' "
	sql = sql & " when isnull(a.asistencia,'') = 'no' then 'ausente' "
	sql = sql & " when isnull(a.asistencia,'') = '' then 'S/R' "
	sql = sql & " end as asistencia, "
	sql = sql & " (isnull(entrada_hora,'00')+':'+isnull(entrada_min,'00')) as hora_llegada, "
	sql = sql & " '08:30' as ingreso_sucursal, "
	sql = sql & " case              "
	sql = sql & " when cast(isnull(entrada_hora,'00')+':'+isnull(entrada_min,'00') as time) = CAST('00:00' AS time) then 'N/A' "
	sql = sql & " when cast(isnull(entrada_hora,'00')+':'+isnull(entrada_min,'00') as time) <= CAST('08:30' AS time) then 'Ok' "
	sql = sql & " when cast(isnull(entrada_hora,'00')+':'+isnull(entrada_min,'00') as time) > CAST('08:30' AS time) then 'atraso' "
	sql = sql & " end atraso, "
	sql = sql & " (isnull(salida_hora,'00')+':'+isnull(salida_min,'00')) as hora_salida, "
	sql = sql & " '18:30' as salida_sucursal, "
	sql = sql & " case              "
	sql = sql & " when cast(isnull(salida_hora,'00')+':'+isnull(salida_min,'00') as time) = CAST('00:00' AS time) then 'N/A' "
	sql = sql & " when cast(isnull(salida_hora,'00')+':'+isnull(salida_min,'00') as time) = CAST('18:30' AS time) then 'Ok' "
	sql = sql & " when cast(isnull(salida_hora,'00')+':'+isnull(salida_min,'00') as time) > CAST('18:30' AS time) then 'hora extra' "
	sql = sql & " when cast(isnull(salida_hora,'00')+':'+isnull(salida_min,'00') as time) < CAST('18:30' AS time) then 'retiro temprano' "
	sql = sql & " end hora_extra "    
	sql = sql & " from SUC_sucursal_guardias_asistencia a "
	sql = sql & " inner join SUC_sucursal b on a.cod_bantotal = b.cod_bantotal "
	sql = sql & " ) as z "
	sql = sql & " left join SUC_sucursal_guardias_r c on z.guardia_rut = c.guardia_rut "
	sql = sql & " ) as x "
	sql = sql & " left join SUC_sucursal_guardias_r d on x.guardia_rut = d.guardia_rut_titular "
	sql = sql & " ) as y "
	sql = sql & " left join SUC_sucursal_guardias_t e on y.titular_areemplazar = e.guardia_rut "
	sql = sql & " order by y.suc_nombre "
	'response.write(sql)
	'response.end
	set rs = db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
	end if
else 
	sql = ""
	sql = sql & " set dateformat dmy "
	sql = sql & " select "
	sql = sql & " y.fecha_respaldo, "
	sql = sql & " y.cod_bantotal, "   
	sql = sql & " y.suc_nombre, "
	sql = sql & " y.desde, "
	sql = sql & " y.hasta, "
	sql = sql & " y.guardia_rut, "
	sql = sql & " y.guardia_nombre, "
	sql = sql & " y.tipo_suc, "
	sql = sql & " y.control_reemplazo, "
	sql = sql & " y.reemplazo_guardia_rut, "
	sql = sql & " y.reemplazo_guardia_nombre, "      
	sql = sql & " y.empresa, "
	sql = sql & " y.asistencia, "
	sql = sql & " y.hora_llegada, "
	sql = sql & " y.ingreso_sucursal, "
	sql = sql & " y.atraso, "
	sql = sql & " y.hora_salida, "
	sql = sql & " y.salida_sucursal, "
	sql = sql & " y.hora_extra, "
	sql = sql & " y.titular_areemplazar, "
	sql = sql & " isnull(e.guardia_nombre,'') as titular_areemplazar_nombre "
	sql = sql & " from ( "
	sql = sql & " select x.*,  "
	sql = sql & " case "
	sql = sql & " when isnull(d.guardia_rut,'') = '' then 'NO' "
	sql = sql & " when isnull(d.guardia_rut,'') <> '' then 'SI' "
	sql = sql & " end control_reemplazo, "
	sql = sql & " rtrim(ltrim(isnull(d.guardia_rut,''))) as reemplazo_guardia_rut, "
	sql = sql & " rtrim(ltrim(isnull(d.guardia_nombre,''))) as reemplazo_guardia_nombre "          
	sql = sql & " from ( "
	sql = sql & " select z.*, isnull(c.desde,'') as desde, isnull(c.hasta,'') as hasta"
	sql = sql & " ,isnull(c.guardia_rut_titular,'') as titular_areemplazar "
	sql = sql & " from ( "
	sql = sql & " select "
	sql = sql & "  a.fecha_respaldo,"
	sql = sql & "  a.cod_bantotal, b.suc_nombre, a.guardia_rut, a.guardia_nombre "
	sql = sql & " ,a.tipo_suc, a.empresa, "
	sql = sql & "   case when isnull(a.asistencia,'') = 'si' then 'presente' "
	sql = sql & "        when isnull(a.asistencia,'') = 'no' then 'ausente' "
	sql = sql & "        when isnull(a.asistencia,'') = '' then 'S/R' end as asistencia, "
	sql = sql & "   (isnull(entrada_hora,'00')+':'+isnull(entrada_min,'00')) as hora_llegada, '08:30' as ingreso_sucursal, "
	sql = sql & "   case when cast(isnull(entrada_hora,'00')+':'+isnull(entrada_min,'00') as time) = CAST('00:00' AS time) "
	sql = sql & " then 'N/A' "
	sql = sql & "  when cast(isnull(entrada_hora,'00')+':'+isnull(entrada_min,'00') as time) <= CAST('08:30' AS time) then 'Ok' "
	sql = sql & "  when cast(isnull(entrada_hora,'00')+':'+isnull(entrada_min,'00') as time) > CAST('08:30' AS time) then 'atraso' " 
	sql = sql & "  end atraso, "
	sql = sql & "  (isnull(salida_hora,'00')+':'+isnull(salida_min,'00')) as hora_salida, '18:30' as salida_sucursal, "
	sql = sql & "  case when cast(isnull(salida_hora,'00')+':'+isnull(salida_min,'00') as time) = CAST('00:00' AS time) then 'N/A' "
	sql = sql & "   when cast(isnull(salida_hora,'00')+':'+isnull(salida_min,'00') as time) = CAST('18:30' AS time) then 'Ok' "
	sql = sql & "   when cast(isnull(salida_hora,'00')+':'+isnull(salida_min,'00') as time) > CAST('18:30' AS time) then 'hora extra' "
	sql = sql & "   when cast(isnull(salida_hora,'00')+':'+isnull(salida_min,'00') as time) < CAST('18:30' AS time) then 'retiro temprano' "
	sql = sql & "  end hora_extra "     
	sql = sql & "  from SUC_sucursal_guardias_asistencia_respaldo a "
	sql = sql & "  inner join SUC_sucursal b on a.cod_bantotal = b.cod_bantotal "
	sql = sql & "  where fecha_respaldo = '"&valorFecha&"' "    
	sql = sql & " ) as z "
	sql = sql & " left join SUC_sucursal_guardias_r_resp c on z.guardia_rut = c.guardia_rut "
	sql = sql & " and z.fecha_respaldo = c.fecha_respaldo "
	sql = sql & " ) as x left join SUC_sucursal_guardias_r_resp d on x.guardia_rut = d.guardia_rut_titular "
	sql = sql & " and x.fecha_respaldo = d.fecha_respaldo "
	sql = sql & " ) as y "
	sql = sql & " left join SUC_sucursal_guardias_t_resp e on y.titular_areemplazar = e.guardia_rut "
	sql = sql & " and e.fecha_respaldo = y.fecha_respaldo "
	sql = sql & " order by y.suc_nombre "
	'response.write(sql)
	'response.end
	set rs = db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
	end if
end if
%>
<table border="1">
	<thead>
		<tr>
			<th style="background-color:#36F; color:#FFF; font-weight:bold;">BT Sucursal</th>
			<th style="background-color:#36F; color:#FFF; font-weight:bold;">Nombre Sucursal</th>
			<th style="background-color:#FF0; color:#000; font-weight:bold;">Reemplazo Desde</th>
			<th style="background-color:#FF0; color:#000; font-weight:bold;">Reemplazo Hasta</th>
			<th style="background-color:#36F; color:#FFF; font-weight:bold;">Rut personal</th>
			<th style="background-color:#36F; color:#FFF; font-weight:bold;">Nombre Personal</th>
			<th style="background-color:#36F; color:#FFF; font-weight:bold;">Tipo</th>
			<th style="background-color:#FF0; color:#000; font-weight:bold;">Control Reemplazo</th>
            <th style="background-color:#FF0; color:#000; font-weight:bold;">Rut Reemplazo</th>
			<th style="background-color:#FF0; color:#000; font-weight:bold;">Nombre Reemplazo</th>
			<th style="background-color:#36F; color:#FFF; font-weight:bold;">Empresa</th>
			<th style="background-color:#0C9; color:#FFF; font-weight:bold;">Asistencia</th>
			<th style="background-color:#36F; color:#FFF; font-weight:bold;">Hora Llegada</th>
			<th style="background-color:#36F; color:#FFF; font-weight:bold;">Ingreso Sucursal</th>
			<th style="background-color:#36F; color:#FFF; font-weight:bold;">Atraso</th>
			<th style="background-color:#36F; color:#FFF; font-weight:bold;">Hora Salida</th>
			<th style="background-color:#36F; color:#FFF; font-weight:bold;">Salida Sucursal</th>
			<th style="background-color:#FF0; color:#000; font-weight:bold;">Hora Extra</th>
            <th style="background-color:#FF0; color:#000; font-weight:bold;">Titular a Reemplazar Rut</th>
            <th style="background-color:#FF0; color:#000; font-weight:bold;">Titular a Reemplazar Nombre</th>
		</tr>
	</thead>
	<tbody>
		<%
		set rs = db.execute(sql)
		if not rs.eof then
		do while not rs.eof
			'for i=0 to ubound(datos,2)
			codSucursal = server.htmlencode(trim(rs("cod_bantotal")))
			sucNombre = server.htmlencode(trim(rs("suc_nombre")))
			desde = server.htmlencode(trim(rs("desde")))
			hasta = server.htmlencode(trim(rs("hasta")))
			guardiaRut = server.htmlencode(trim(rs("guardia_rut")))
			guardiaNombre = server.htmlencode(trim(rs("guardia_nombre")))
			guardiaTipo = server.htmlencode(trim(rs("tipo_suc")))
			controlReemplazo = server.htmlencode(trim(rs("control_reemplazo")))
			reemplazoGuardiaRut = server.htmlencode(trim(rs("reemplazo_guardia_rut")))
			reemplazoGuardiaNombre = server.htmlencode(trim(rs("reemplazo_guardia_nombre")))
			empresa = server.htmlencode(trim(rs("empresa")))
			asistencia = server.htmlencode(trim(rs("asistencia")))
			horaLlegada = server.htmlencode(trim(rs("hora_llegada")))
			ingresoSucursal = server.htmlencode(trim(rs("ingreso_sucursal")))
			atraso = server.htmlencode(trim(rs("atraso")))
			horaSalida = server.htmlencode(trim(rs("hora_salida")))
			salidaSucursal = server.htmlencode(trim(rs("salida_sucursal")))
			horaExta = server.htmlencode(trim(rs("hora_extra")))
			titularAReemplazarRut = server.htmlencode(trim(rs("titular_areemplazar")))
			titularAReemplazarNombre = server.htmlencode(trim(rs("titular_areemplazar_nombre")))
			
		%>
			<tr>
				<td><%=codSucursal%></td>
				<td><%=sucNombre%></td>
				<td><%=desde%></td>
				<td><%=hasta%></td>
				<td><%=guardiaRut%></td>
				<td><%=guardiaNombre%></td>
				<td><%=guardiaTipo%></td>
				<td><%=controlReemplazo%></td>
				<td><%=reemplazoGuardiaRut%></td>
				<td><%=reemplazoGuardiaNombre%></td>
				<td><%=empresa%></td>
				<td><%=asistencia%></td>
				<td><%=horaLlegada%></td>
				<td><%=ingresoSucursal%></td>
				<td><%=atraso%></td>
				<td><%=horaSalida%></td>
				<td><%=salidaSucursal%></td>
                <td><%=horaExta%></td>
                <td><%=titularAReemplazarRut%></td>
                <td><%=titularAReemplazarNombre%></td>
			</tr>
		<%
			'next
			
			rs.MoveNext
			Loop
		end if
		%>
	</tbody>
</table>
<%
Response.Charset = "UTF-8"
fecha  =date()
archivo = "Reporte horario Guardias "&fecha&".xls"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo 
%>