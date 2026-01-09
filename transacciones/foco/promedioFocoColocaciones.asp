<!--#include file="../../funciones.asp"-->
<div class="row-fluid">
	<div class="span12">
		<% perfil = trim(request("perfilMain"))
		idUsuario = trim(request("idUsuarioMain"))
		sql = ""
		sql = sql & " declare @diaAnterior as date "
		sql = sql & " set @diaAnterior = (select utilidades.dbo.fn_diaHabilAnterior(GETDATE())) "
		sql = sql & " select b.suc_zonal_rut, "
		sql = sql & " b.suc_zonal as zonal, "
		sql = sql & " sum(a.colCred) as num_op, sum(a.colCred_monto) as monto, "
		sql = sql & " (cast(sum(a.colCred) as float)"
		sql = sql & " /cast((select COUNT(*) "
		sql = sql & " from SUC_sucursal c "
		sql = sql & " where c.suc_zonal_rut = b.suc_zonal_rut "
		sql = sql & " and suc_foco = 1) as float)) as prom_sum_op, "
       	sql = sql & " (cast(sum(a.colCred_monto) as float)"
       	sql = sql & " /cast((select COUNT(*) "
       	sql = sql & " from SUC_sucursal c "
       	sql = sql & " where c.suc_zonal_rut = b.suc_zonal_rut "
       	sql = sql & " and suc_foco = 1) as float)) as prom_monto, "
       	sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal c "
		sql = sql & " where c.suc_zonal_rut = b.suc_zonal_rut "
		sql = sql & " and suc_foco = 1) as num_suc "
		sql = sql & " from SUC_transacciones_diarias a "
		sql = sql & " inner join SUC_sucursal b "
		sql = sql & " on a.cod_sucursal = b.cod_bantotal "
		sql = sql & " where YEAR(a.fecha) = year(@diaAnterior) "
		sql = sql & " and MONTH(a.fecha) = MONTH(@diaAnterior) "
		sql = sql & " and b.suc_foco = 1 "
		sql = sql & " and a.colCred <> 0 "
		sql = sql & " group by b.suc_zonal_rut, "
		sql = sql & " b.suc_zonal "
		
		'response.Write(sql)
		'response.End()
		
		set rs = db.execute(sql)
		if not rs.eof then
			datos = rs.GetRows()%>
			<table class="table table-bordered table-hover table-condensed" id="tablaPromedioFocoColocaciones">
				<thead>
					<tr>
						<th class="h7"><strong>Zonal</strong></th>
						<th class="h7"><strong>Num OP</strong></th>
						<th class="h7"><strong>Monto</strong></th>
						<th class="h7"><strong>Prom op</strong></th>
						<th class="h7"><strong>Prom monto</strong></th>
					</tr>
				</thead>
				<tbody>
					<%sumaNumOP = 0
					sumaMonto = 0
					sumaPromSumMonto = 0
					promSumMonto = 0
					sumaPromSumaOp = 0
					for i=0 to ubound(datos,2)
						rut = trim(datos(0,i))
						zonal = server.htmlencode(trim(datos(1,i)))
						numOp = formatnumber(trim(datos(2,i)),2)						
						if right(numOp,2) ="00" then
							numOp = clng(numOp)
						end if
						
						sumaNumOP = sumaNumOP + numOp
						monto = formatnumber(trim(datos(3,i)),2)
						if right(monto,2) ="00" then
							monto = clng(monto)
						end if
						
						sumaMonto = sumaMonto + monto
						promSumOp = formatnumber(trim(datos(4,i)),2)
						if right(promSumOp,2) ="00" then
							promSumOp = clng(promSumOp)
						end if
												
						sumaPromSumaOp = sumaPromSumaOp + promSumOp
						promSumMonto = formatnumber(trim(datos(5,i)),2)
						if right(promSumMonto,2) ="00" then
							promSumMonto = clng(promSumMonto)
						end if
						
						sumaPromSumMonto = sumaPromSumMonto + promSumMonto
						numSuc = trim(datos(6,i))
						if right(numSuc,2) ="00" then
							numSuc = clng(numSuc)
						end if%>
                        
						<tr>
							<td class="h7"><%=zonal%></td>
							<td class="h7"><%=numOp%></td>
							<td class="h7" ><%=monto%></td>
							<td class="h7"><%=promSumOp%></td>
							<td class="h7"><%=promSumMonto%></td>
						</tr>
					<%next%>
					<tr>
						<td class="h7">Suma Total</td>
						<td class="h7"><%=sumaNumOP%></td>
						<td class="h7"><%=sumaMonto%></td>
						<td class="h7"><%=sumaPromSumaOp%></td>
						<td class="h7"><%=sumaPromSumMonto%></td>
					</tr>
				</tbody>
			</table>
		<%else%>
			No existen datos a mostrar
		<%end if%>
	</div>
</div>