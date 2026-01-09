<!--#include file="../funciones.asp"-->
<%
sql = ""
sql = sql & " select a.cod_bantotal, "
sql = sql & " b.suc_nombre, "
sql = sql & " a.tipo, "
sql = sql & " a.guardia_rut, "
sql = sql & " a.guardia_nombre, "
sql = sql & " a.tipo_suc, "
sql = sql & " a.asistencia, "
sql = sql & " a.entrada_hora, "
sql = sql & " a.entrada_min, "
sql = sql & " a.salida_hora, "
sql = sql & " a.salida_min, "
sql = sql & " a.empresa "
sql = sql & " from SUC_sucursal_guardias_asistencia a, "
sql = sql & " SUC_sucursal b "
sql = sql & " where a.cod_bantotal = b.cod_bantotal "
sql = sql & " order by sucursal"
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
sql = sql & " rtrim(ltrim(isnull(d.guardia_nombre,''))) as reemplazo_guardia_nombre	"	
sql = sql & " from ( "
sql = sql & " select z.*, isnull(c.desde,'') as desde, isnull(c.hasta,'') as hasta, isnull(c.guardia_rut_titular,'') as titular_areemplazar "
sql = sql & " from ( "
sql = sql & " select "
sql = sql & " a.cod_bantotal, b.suc_nombre, a.guardia_rut, a.guardia_nombre, a.tipo_suc, a.empresa, "
sql = sql & " case "
sql = sql & " when isnull(a.asistencia,'') = 'si' then 'presente' "
sql = sql & " when isnull(a.asistencia,'') = 'no' then 'ausente' "
sql = sql & " when isnull(a.asistencia,'') = '' then 'N/A' "
sql = sql & " end as asistencia, "
sql = sql & " (isnull(entrada_hora,'00')+':'+isnull(entrada_min,'00')) as hora_llegada, "
sql = sql & " '08:30' as ingreso_sucursal, "
sql = sql & " case	"
sql = sql & " when cast(isnull(entrada_hora,'00')+':'+isnull(entrada_min,'00') as time) = CAST('00:00' AS time) then 'N/A' "
sql = sql & " when cast(isnull(entrada_hora,'00')+':'+isnull(entrada_min,'00') as time) <= CAST('08:30' AS time) then 'Ok' "
sql = sql & " when cast(isnull(entrada_hora,'00')+':'+isnull(entrada_min,'00') as time) > CAST('08:30' AS time) then 'atraso' "
sql = sql & " end atraso, "
sql = sql & " (isnull(salida_hora,'00')+':'+isnull(salida_min,'00')) as hora_salida, "
sql = sql & " '18:30' as salida_sucursal, "
sql = sql & " case	"
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

'set rs = db.execute(sql)
'if not rs.eof then
'	datos = rs.GetRows()
'end if
%>
<table border="1">
	<thead>
		<tr>
			<th>BT Sucursal</th>
			<th>Nombre Sucursal</th>
			<th>Reemplazo Desde</th>
			<th>Reemplazo Hasta</th>
			<th>Rut personal</th>
			<th>Nombre Personal</th>
			<th>Tipo</th>
			<th>Control Reemplazo</th>
            <th>Rut Reemplazo</th>
			<th>Nombre Reemplazo</th>
			<th>Empresa</th>
			<th>Asistencia</th>
			<th>Hora Llegada</th>
			<th>Ingreso Sucursal</th>
			<th>Atraso</th>
			<th>Hora Salida</th>
			<th>Salida Sucursal</th>
			<th>Hora Extra</th>
            <th>Titular a Reemplazar Rut</th>
            <th>Titular a Reemplazar Nombre</th>
		</tr>
	</thead>
	<tbody>
		<%
		set rs = db.execute(sql)
		if not rs.eof then
		do while not rs.eof
			'for i=0 to ubound(datos,2)
			idSucursaBtt = trim(datos(0,i))
			nombreSucursal = server.htmlencode(trim(datos(1,i)))
			tipo = trim(datos(2,i))
			guardiaRut = trim(datos(3,i))
			guardiaNombre = server.htmlencode(trim(datos(4,i)))
			tipoSuc = trim(datos(5,i))
			asistenciaGuardia = trim(datos(6,i))
			if asistenciaGuardia = "si" then
				asistenciaGuardia = "presente"
			else
				asistenciaGuardia = "ausente"
			end if
			horaLlEgada = trim(datos(7,i))
			minutosLlegada = trim(datos(8,i))
			horaSalida = trim(datos(9,i))
			minutosSalida = trim(datos(10,i))
			trim(datos(8,i))
			if horaLlEgada <> "" then 
				atraso = clng(horaLlEgada) * 60
				atraso = atraso + clng(minutosLlegada)
				atraso = atraso - 510
				if atraso > 0 then
					atraso = "Atraso"
				else
					atraso = "OK"
				end if
				horaLlEgada = horaLlEgada&":"&minutosLlegada
			else
				horaLlEgada = ""
				atraso = "N/A"
			end if
			if horaSalida <> "" then
				horasExtras = clng(horaSalida) * 60
				horasExtras = horasExtras + clng(minutosSalida)
				horasExtras = horasExtras - 1110
				if horasExtras > 0 then
					horasExtras = "OK"
				else
					if horasExtras < 0 then
						horasExtras = "Retiro temprano"
					else
						horasExtras = "N/A"
					end if
				end if
				horaSalida = horaSalida&":"&minutosSalida
			else
				horaSalida = ""
				horasExtras = "N/A"
			end if
			guardiaRutReemplazo = ""
			guardiaNombreReemplazo = ""
			desde = ""
			hasta = ""
			empresaGuardia = server.htmlencode(trim(datos(11,i)))%>
			<tr>
				<td>
					<%=idSucursaBtt%>
				</td>
				<td>
					<%=nombreSucursal&" ("&tipo&")"%>
				</td>
				<td>
					<%if tipoSuc = "reemplazo" then 
						sql = ""
						sql = sql & " select desde, "
						sql = sql & " hasta "
						sql = sql & " from SUC_sucursal_guardias_r "
						sql = sql & " where guardia_rut = '"&guardiaRut&"'"
						set rs = db.execute(sql)
						if not rs.eof then
							desde = cdate(trim(rs(0)))
							hasta = cdate(trim(rs(1)))
						end if
					end if
					response.write(desde)%>
				</td>
				<td>
					<%=hasta%>
				</td>
				<td>
					<%=guardiaRut%>
				</td>
				<td>
					<%=guardiaNombre%>
				</td>
				<td>
					<%=tipoSuc%>
				</td>
				<td>
					<%if tipoSuc <> "reemplazo" then
						sql = ""
						sql = sql & " select guardia_rut, "
						sql = sql & " guardia_nombre "
						sql = sql & " from SUC_sucursal_guardias_r "
						sql = sql & " where guardia_rut_titular = '"&guardiaRut&"'"
						set rs = db.execute(sql)
						if not rs.eof then
							guardiaRutReemplazo = trim(rs(0))
							guardiaNombreReemplazo = trim(rs(1))
						end if
					end if
					response.write(guardiaRutReemplazo)%>
				</td>
				<td>
					<%=guardiaNombreReemplazo%>
				</td>
				<td>
					<%=empresaGuardia%>
				</td>
				<td>
					<%=asistenciaGuardia%>
				</td>
				<td>
					<%=horaLlEgada%>
				</td>
				<td>
					08:30
				</td>
				<td>
					<%=atraso%>
				</td>
				<td>
					<%=horaSalida%>
				</td>
				<td>
					18:30
				</td>
				<td>
					<%=horasExtras%>
				</td>
			</tr>
		<%
			'next
			
			rs.MoveNext
			Loop
		end if
		%>
	</tbody>
</table>
<%Response.Charset = "UTF-8"
fecha  =date()
archivo = "Reporte horario Guardias "&fecha&".xls"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo %>