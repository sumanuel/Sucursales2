<!--#include file="../funciones.asp"-->
<table border="1">
	<thead>
		<tr>
			<th>Grupo</th>
			<th>Zonal</th>
			<th>Sucursal</th>
			<th>Cod Btt.</th>
			<th>Direccion</th>
			<th>Jeps</th>
			<th>G. Doc</th>
			<th>G. Adm.</th>
			<th>G. Cont</th>
		</tr>
	</thead>
	<tbody>
		<%sql = ""
		sql = sql & " select distinct(id_zona), grupo from SUC_zonales "
		set rs = db.execute(sql)
		if not rs.eof then
			datos = rs.GetRows()
			For i = 0 to ubound(datos, 2)
				idGrupo = trim(datos(0,i))
				nombreGrupo = trim(datos(1,i))%>
				<tr>
					<td><%=nombreGrupo%></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<%sql2 = ""
				sql2 = sql2 & "select id_usuario, zonal from suc_zonales where id_zona = '"&idGrupo&"' and estado_zonal = '1' "
				set rs2 = db.execute(sql2)
				if not rs2.eof then
					datos2 = rs2.GetRows()
					For x = 0 to ubound(datos2, 2)
						idZonal = trim(datos2(0,x))
						nombreZonal = trim(datos2(1,x))
						sql4 =""
						sql4 = sql4 & " select isnull(AVG(porc_cumpl),0) as porc_cumpl "
						sql4 = sql4 & " from SUC_gest_admin_control "
						sql4 = sql4 & " where fecha_operacion = cast(GETDATE() as date) and "
						sql4 = sql4 & " estado = 1 and "
						sql4 = sql4 & " id_sucursal in "
						sql4 = sql4 & " (select id_sucursal from SUC_zonales_sucursal "
						sql4 = sql4 & " where id_zonal = '"&idZonal&"') "
						
						set rs4 = db.execute(sql4)

						if not rs4.eof then
							promedioAdm = rs4("porc_cumpl")
						else
							promedioAdm = 0
						end if
						promedioAdm = validaPorcentaje(promedioAdm)
						
						sql4 =""
						sql4 = sql4 & " select "
						sql4 = sql4 & " isnull (AVG(a.porc_cumpl),0) as porc_cumpl  "
						sql4 = sql4 & " from SUC_gest_cont_control a "
						sql4 = sql4 & " where a.fecha_operacion = cast(GETDATE() as DATE) "
						sql4 = sql4 & " and a.estado = 1 "
						sql4 = sql4 & " and a.id_sucursal in (select id_sucursal from SUC_zonales_sucursal "
						sql4 = sql4 & " where id_zonal = '"&idZonal&"') "
						
						set rs4 = db.execute(sql4)

						if not rs4.eof then
							promedioCont = rs4("porc_cumpl")
						else
							promedioCont = 0
						end if
						promedioCont = validaPorcentaje(promedioCont)
						sql4 =""
						sql4 = sql4 & " select "
						sql4 = sql4 & " isnull (AVG(a.porc_cumpl),0) as porc_cumpl  "
						sql4 = sql4 & " from SUC_gest_doc_control a "
						sql4 = sql4 & " where a.fecha_operacion = cast(GETDATE() as DATE) "
						sql4 = sql4 & " and a.estado = 1 "
						sql4 = sql4 & " and a.id_sucursal in (select id_sucursal from SUC_zonales_sucursal "
						sql4 = sql4 & " where id_zonal = '"&idZonal&"') "
						
						set rs4 = db.execute(sql4)
						if not rs4.eof then
							promedioDoc = rs4("porc_cumpl")
						else
							promedioDoc = 0
						end if
						promedioDoc = validaPorcentaje(promedioDoc)%>
						<tr>
							<td></td>
							<td><%=nombreZonal%></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td><%=promedioDoc%>%</td>
							<td><%=promedioAdm%>%</td>
							<td><%=promedioCont%>%</td>
						</tr>
						<%sql3 = ""
						sql3 = sql3 & " select a.id_sucursal, "
						sql3 = sql3 & " a.suc_nombre, "
						sql3 = sql3 & " suc_direccion, "
						sql3 = sql3 & " suc_jeps, "
						sql3 = sql3 & " cod_bantotal "
						sql3 = sql3 & " from SUC_sucursal a, "
						sql3 = sql3 & " SUC_zonales_sucursal b "
						sql3 = sql3 & " where a.id_sucursal = b.id_sucursal "
						sql3 = sql3 & " and b.id_zonal = '"&idZonal&"' "
						sql3 = sql3 & " order by suc_nombre"
						set rs3 = db.execute(sql3)
						if not rs3.eof then
							datos3 = rs3.GetRows()
							For z = 0 to ubound(datos3, 2)
								idSucursal = trim(datos3(0,z))
								nombreSucursal = trim(datos3(1,z))
								direccionSucursal = trim(datos3(2,z))
								nombreJeps = trim(datos3(3,z))
								codBtt = trim(datos3(4,z))
								porcentajecDoc = ""
								porcentajeAdm = ""
								porcentajeCont = ""
								sql4 =""
								sql4 = sql4 & " select a.porc_cumpl "
								sql4 = sql4 & " from SUC_gest_admin_control  a"
								sql4 = sql4 & " where a.fecha_operacion = cast(GETDATE() as DATE) "
								sql4 = sql4 & " and a.estado = 1 "
								sql4 = sql4 & " and a.id_sucursal = '"&idSucursal&"' "
								set rs4 = db.execute(sql4)
								if not rs4.eof then
									datos4 = rs4.GetRows()
									For a = 0 to ubound(datos4, 2)
										porcentajeAdm = trim(datos4(0,a))
									next
								else
									porcentajeAdm = 0
								end if
								porcentajeAdm = validaPorcentaje(porcentajeAdm)
								sql4 =""
								sql4 = sql4 & " select a.porc_cumpl "
								sql4 = sql4 & " from SUC_gest_cont_control  a"
								sql4 = sql4 & " where a.fecha_operacion = cast(GETDATE() as DATE) "
								sql4 = sql4 & " and a.estado = 1 "
								sql4 = sql4 & " and a.id_sucursal = '"&idSucursal&"' "
								set rs4 = db.execute(sql4)
								if not rs4.eof then
									datos4 = rs4.GetRows()
									For a = 0 to ubound(datos4, 2)
										porcentajeCont = trim(datos4(0,a))
									next
								else
									porcentajeCont = 0
								end if
								porcentajeCont = validaPorcentaje(porcentajeCont)
								sql4 =""
								sql4 = sql4 & " select a.porc_cumpl "
								sql4 = sql4 & " from SUC_gest_doc_control  a"
								sql4 = sql4 & " where a.fecha_operacion = cast(GETDATE() as DATE) "
								sql4 = sql4 & " and a.estado = 1 "
								sql4 = sql4 & " and a.id_sucursal = '"&idSucursal&"' "
								set rs4 = db.execute(sql4)
								
								if not rs4.eof then
									datos4 = rs4.GetRows()
									For a = 0 to ubound(datos4, 2)
										porcentajecDoc = trim(datos4(0,a))
									next
								else
									porcentajeDoc = 0
								end if
								porcentajecDoc = validaPorcentaje(porcentajecDoc)%>
								<tr>
									<td></td>
									<td></td>
									<td><%=nombreSucursal%></td>
									<td><%=codBtt%></td>
									<td><%=direccionSucursal%></td>
									<td><%=nombreJeps%></td>
									<td><%=porcentajecDoc%>%</td>
									<td><%=porcentajeAdm%>%</td>
									<td><%=porcentajeCont%>%</td>
								</tr>
							<%next' sucursal
						end if
					next'zonal
				end if
			next'grupo
		end if%>
	</tbody>
</table>
<%Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=DetalleOperacional.xls"  %>