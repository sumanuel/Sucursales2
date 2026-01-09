<!--#include file="../funciones.asp"-->
<%
'Response.Buffer = TRUE
'Response.ContentType = "application/vnd.ms-excel"

down = trim(request("down"))
if down = "1" then 'DETALLE DE REZAGOS	

	sql = ""
	sql = sql & " select "	
	sql = sql & " cod_bantotal, "
	sql = sql & " nombre_sucursal, "
	sql = sql & " institucion, "
	sql = sql & " nombre_institucion, "
	sql = sql & " pagos_qty, "
	sql = sql & " pagos_monto, "
	sql = sql & " fecha_ingreso as fecha " 
	sql = sql & " from SUC_index_ips_rezago "
	sql = sql & " where fecha_ingreso = (select max(a.fecha_ingreso) from SUC_index_ips_rezago a) "

	set rs = db.execute(sql)
    if not rs.eof then
        datos = rs.GetRows()%>
        
   		<table class="table table-bordered table-hover">
	   		<thead>
	   			<tr>
	   				<th>COD BTT</th>
	   				<th>SUCURSAL</th>
	   				<th>COD INSTITUCION</th>
	   				<th>INSTITUCION</th>
	   				<th>REZAGOS QTY</th>
	   				<th>REZAGOS MONTO</th>
	   				<th>REZAGOS FECHA</th>
	   			</tr>
	   		</thead>
	   		<tbody>
				<%For i = 0 to ubound(datos, 2) %>
					<tr>
						<td>
							<%=trim(datos(0,i))%>
						</td>
						<td>
							<%=trim(datos(1,i))%>
						</td>
						<td>
							<%=formatnumber(trim(datos(2,i)),0)%>
						</td>
						<td>
							<%=trim(datos(3,i))%>
						</td>
						<td>
							<%=formatnumber(trim(datos(4,i)),0)%>
						</td>
						<td>
							$<%=formatnumber(trim(datos(5,i)),0)%>
						</td>
						<td>
							<%=trim(datos(6,i))%>
						</td>
					</tr>
				<%next%>
			</tbody>
		</table>		
	<%end if
end if %>
