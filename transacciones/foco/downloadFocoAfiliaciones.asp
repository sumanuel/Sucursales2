<!--#include file="../../funciones.asp"-->
<% 
	perfil = trim(request("perfilMain"))
	idUsuario = trim(request("idUsuarioMain"))
%>
<table>
<tr>
<td>
	<% 
	sql = ""
	sql = sql & " select b.suc_zonal, "
	sql = sql & " a.cod_sucursal, "
	sql = sql & " a.nombre_sucursal, "
	sql = sql & " isnull(a.afi_normal,0) as afi_normal, "
	sql = sql & " isnull(a.afi_pbs,0) as afi_pbs, "
	sql = sql & " isnull(a.afi_ffaa,0) as afi_ffaa, "
	sql = sql & " cast(a.fecha as date) as fecha "
	sql = sql & " from SUC_transacciones_diarias a "
	sql = sql & " inner join SUC_sucursal b "
	sql = sql & " on a.cod_sucursal = b.cod_bantotal "
	sql = sql & " where year(a.fecha) = year((select utilidades.dbo.fn_diaHabilAnterior(GETDATE()))) "
	sql = sql & " and month(a.fecha) = month((select utilidades.dbo.fn_diaHabilAnterior(GETDATE()))) "
	sql = sql & " and (a.afi_normal <> 0 or a.afi_pbs <> 0) "
	sql = sql & " and a.cod_sucursal in "
	sql = sql & " (select cod_bantotal "
	sql = sql & " from SUC_sucursal "
	sql = sql & " where suc_foco = 1) "
	sql = sql & " order by a.cod_sucursal, "
	sql = sql & " a.fecha "
	set rs = db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()%>
		<table class="table table-bordered table-hover table-condensed" id="tablaSucursalesFocoColocaciones">
			<thead>
				<tr>
					<th class="h7"><b>Zonal</b></th>
					<th class="h7"><strong>BTT</strong></th>
					<th class="h7"><strong>Sucursal</strong></th>
					<th class="h7"><strong>Normal</strong></th>
					<th class="h7"><strong>PBS</strong></th>
					<th class="h7"><strong>FFAA</strong></th>
					<th class="h7"><strong>Fecha</strong></th>
				</tr>
			</thead>
			<tbody>
				<%for i=0 to ubound(datos,2)
					zonal = server.htmlencode(trim(datos(0,i)))
					codSucursal =trim(datos(1,i))
					sucursal =  server.htmlencode(trim(datos(2,i)))
					afiNormal = trim(datos(3,i))
					afiPbs = formatNumber(trim(datos(4,i)),0)
					afiFFAA = formatNumber(trim(datos(5,i)),0)
					fecha = cdate(trim(datos(6,i)))%>
					<tr>
						<td class="h7"><%=zonal%></td>
						<td class="h7"><%=codSucursal%></td>
						<td class="h7"><%=sucursal%></td>
						<td class="h7 colocaciones"><%=afiNormal%></td>
						<td class="h7 colocacioesMonto"><%=afiPbs%></td>
						<td class="h7 colocacioesMonto"><%=afiFFAA%></td>
						<td class="h7"><%=fecha%></td>
					</tr>
				<%next%>
			</tbody>
		</table>		
	<%else%>
	No existen datos a mostrar
	<%end if%>
</td>
<td></td>
<td>
<% 
	sql = ""
	sql = sql & " select z.suc_zonal_rut, "
	sql = sql & " z.suc_zonal, "
	sql = sql & " sum(z.afi_normal) as afi_normal, "
	sql = sql & " sum(z.afi_pbs) as afi_pbs, "
	sql = sql & " sum(z.afi_ffaa) as afi_ffaa, "
	sql = sql & " (sum(z.afi_normal)+sum(z.afi_pbs)+sum(z.afi_ffaa)) as afi_total, "
	sql = sql & " (select COUNT(*) "
	sql = sql & " from SUC_sucursal c "
	sql = sql & " where c.suc_zonal_rut = z.suc_zonal_rut "
	sql = sql & " and suc_foco = 1) as num_sucs, "
	sql = sql & " (cast((sum(z.afi_normal)+sum(z.afi_pbs)+sum(z.afi_ffaa)) as float)"
	sql = sql & " /cast((select COUNT(*) "
	sql = sql & " from SUC_sucursal c "
	sql = sql & " where c.suc_zonal_rut = z.suc_zonal_rut "
	sql = sql & " and suc_foco = 1) as float)) as afi_prom "
	sql = sql & " from (select b.suc_zonal_rut, "
	sql = sql & " b.suc_zonal, "
	sql = sql & " a.cod_sucursal, "
	sql = sql & " a.nombre_sucursal, "
	sql = sql & " a.afi_normal, "
	sql = sql & " a.afi_pbs, "
	sql = sql & " a.afi_ffaa, "
	sql = sql & " a.fecha "
	sql = sql & " from SUC_transacciones_diarias a "
	sql = sql & " inner join SUC_sucursal b on a.cod_sucursal = b.cod_bantotal "
	sql = sql & " where year(a.fecha) = year((select utilidades.dbo.fn_diaHabilAnterior(GETDATE()))) "
	sql = sql & " and month(a.fecha) = month((select utilidades.dbo.fn_diaHabilAnterior(GETDATE()))) " 
	sql = sql & " and (a.afi_normal <> 0 or a.afi_pbs <> 0) "
	sql = sql & " and a.cod_sucursal in (select cod_bantotal "
	sql = sql & " from SUC_sucursal "
	sql = sql & " where suc_foco = 1) "
	sql = sql & " ) as z "
	sql = sql & " group by z.suc_zonal_rut, z.suc_zonal "
	sql = sql & " order by afi_prom desc "
	
	'response.Write(sql)
	'response.end()
	set rs = db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()%>
		<table class="table table-bordered table-hover table-condensed" id="tablaPromedioFocoAfiliaciones">
			<thead>
				<tr>
					<th class="h7"><strong>Zonal</strong></th>
					<th class="h7"><strong>Normal</strong></th>
					<th class="h7"><strong>Pbs</strong></th>
					<th class="h7"><strong>FFAA</strong></th>
					<th class="h7"><strong>Total</strong></th>
					<th class="h7"><strong>Prom Total</strong></th>
				</tr>
			</thead>
			<tbody>
				<%sumaNormal=0
				sumaPbs = 0
				sumaFfaa = 0
				sumaTotal = 0
				sumaPromSumMonto = 0
				for i=0 to ubound(datos,2)
					rut = trim(datos(0,i))
					zonal = server.htmlencode(trim(datos(1,i)))
					normal = trim(datos(2,i))
					sumaNormal = sumaNormal + normal
					pbs = trim(datos(3,i))
					sumaPbs = sumaPbs + pbs
					ffaa = trim(datos(4,i))
					sumaFfaa = sumaFfaa + ffa
					total = trim(datos(5,i))
					sumaTotal = sumaTotal + total
					promSumMonto = formatnumber(trim(datos(7,i)),2)
					if right(promSumMonto,2) ="00" then
						promSumMonto = clng(promSumMonto)
					end if
					sumaPromSumMonto = sumaPromSumMonto + promSumMonto
					'numSuc = trim(datos(6,i))%>
					<tr>
						<td class="h7"><%=zonal%></td>
						<td class="h7"><%=normal%></td>
						<td class="h7" ><%=pbs%></td>
						<td class="h7" ><%=ffaa%></td>
						<td class="h7"><%=total%></td>
						<td class="h7"><%=promSumMonto%></td>
					</tr>
				<%next%>
				<tr>
					<td class="h7">Suma total</td>
					<td class="h7"><%=sumaNormal%></td>
					<td class="h7" ><%=sumaPbs%></td>
					<td class="h7" ><%=sumaFfaa%></td>
					<td class="h7"><%=sumaTotal%></td>
					<td class="h7"><%=sumaPromSumMonto%></td>						
				</tr>
			</tbody>
		</table>
	<%else%>
		No existen datos a mostrar
	<%end if%>
</td>
<td></td>
<td>
<% 
	sql = ""
	sql = sql & " select suc_jeps_short, " 
	sql = sql & " SUM(afi_normal) as afi_normal, "
	sql = sql & " SUM(afi_pbs) as afi_pbs, "
	sql = sql & " SUM(afi_ffaa) as afi_ffaa, "
	sql = sql & " (SUM(afi_normal)+SUM(afi_pbs)+SUM(afi_ffaa)) as total "
	sql = sql & " from ( select b.suc_jeps_short, "
	sql = sql & " a.cod_sucursal, "
	sql = sql & " a.nombre_sucursal, "
	sql = sql & " a.afi_normal, "
	sql = sql & " a.afi_pbs, "
	sql = sql & " a.afi_ffaa, "
	sql = sql & " a.fecha "
	sql = sql & " from SUC_transacciones_diarias a "
	sql = sql & " inner join SUC_sucursal b on a.cod_sucursal = b.cod_bantotal "
	sql = sql & " where year(a.fecha) = year((select utilidades.dbo.fn_diaHabilAnterior(GETDATE()))) "
	sql = sql & " and month(a.fecha) = month((select utilidades.dbo.fn_diaHabilAnterior(GETDATE()))) "
	sql = sql & " and b.suc_foco = 1 "
	sql = sql & " ) as z "
	sql = sql & " where z.suc_jeps_short <> '' and (afi_normal <> 0 or afi_pbs <> 0) "
	sql = sql & " group by z.suc_jeps_short "
	sql = sql & " order by total desc"
	'Response.Write(sql)
	set rs = db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()%>
		<table class="table table-bordered table-hover table-condensed" id="tablaPromedioFocoAfiliacionesSucursal">
			<thead>
				<tr>
					<th class="h7"><strong>Jeps</strong></th>
					<th class="h7"><strong>Normal</strong></th>
					<th class="h7"><strong>Pbs</strong></th>
					<th class="h7"><strong>FFAA</strong></th>
					<th class="h7"><strong>Total</strong></th>
				</tr>
			</thead>
			<tbody>
				<%for i=0 to ubound(datos,2)
					Jeps = server.htmlencode(trim(datos(0,i)))
					normal = trim(datos(1,i))
					pbs = trim(datos(2,i))
					ffaa = trim(datos(3,i))
					total = trim(datos(4,i))%>
					<tr>
						<td class="h7" ><%=Jeps%></td>
						<td class="h7"><%=normal%></td>
						<td class="h7" ><%=pbs%></td>
						<td class="h7" ><%=ffaa%></td>
						<td class="h7"><%=total%></td>
					</tr>
				<%next%>
			</tbody>
		</table>			
	<%else%>
		No existen datos a mostrar
	<%end if%>
</td>
</tr>
</table>
<%
Response.Charset = "UTF-8"
fecha  =date()
archivo = "Sucursales Foco - Afiliaciones "&fecha&".xls"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo %>

