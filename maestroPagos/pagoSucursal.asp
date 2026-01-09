<!--#include file="../funciones.asp"-->
<%pago = trim(request("pago"))
if pago = "1" then
	pago = "IPS"
else
	pago = "AFP"
end if
fechaActual = date()
mes = month(fechaActual)
anio = year(fechaActual)
nombreMes = primeraMayuscula(monthname(cint(right(mes,2)))) & " - " &anio
sql = ""
sql = sql & " SELECT  SucBT "
sql = sql & " , Sucursal "
sql = sql & " , Qty_Misma_H "
sql = sql & " , Qty_MismaMonto_H "
sql = sql & " , Qty_Otra_H "
sql = sql & " , Qty_OtraMonto_H "
sql = sql & " , Qty_Misma_M "
sql = sql & " , Qty_MismaMonto_M "
sql = sql & " , Qty_Otra_M "
sql = sql & " , Qty_OtraMonto_M "
sql = sql & " FROM  SCSS.dbo.vw_Total_Pagados_Sucursal_Dia_Totales "
sql = sql & " where pago = '"&pago&"' "
sql = sql & " order by SucBT, "
sql = sql & " Pago "
'response.write(sql)
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getrows()
	tieneDatos = 1
end if
if tieneDatos = 1 then%>
	<table border="1">
		<thead>
			<tr>
				<th>
					Sucursal
				</th>
				<th>
					Cod btt
				</th>
				<th>
					QTY misma sucursal hoy
				</th>
				<th>
					QTY misma sucursal monto hoy
				</th>
				<th>
					QTY de otra sucursal hoy 
				</th>
				<th>
					QTY de otra sucursal monto hoy
				</th>
				<th>
					QTY misma sucursal ma&ntilde;ana
				</th>
				<th>
					QTY misma sucursal monto ma&ntilde;ana
				</th>
				<th>
					QTY de otra sucursal ma&ntilde;ana 
				</th>
				<th>
					QTY de otra sucursal monto ma&ntilde;ana
				</th>
			</tr>
		</thead>
		<tbody>
			<%sumaQty_Misma_H = 0
			sumaQty_MismaMonto_H = 0
			sumaQty_Otra_H = 0
			sumaQty_OtraMonto_H = 0
			sumaQty_Misma_M = 0
			sumaQty_MismaMonto_M = 0
			sumaQty_Otra_M = 0
			sumaQty_OtraMonto_M = 0
			for i = 0 to ubound(datos,2)
				codBtt = trim(datos(0,i))
				sucursal = server.htmlencode(trim(datos(1,i)))
				Qty_Misma_H = trim(datos(2,i))
				Qty_MismaMonto_H = trim(datos(3,i))
				Qty_Otra_H = trim(datos(4,i))
				Qty_OtraMonto_H = trim(datos(5,i))
				Qty_Misma_M = trim(datos(6,i))
				Qty_MismaMonto_M = trim(datos(7,i))
				Qty_Otra_M = trim(datos(8,i))
				Qty_OtraMonto_M = trim(datos(9,i))
				sumaQty_Misma_H = sumaQty_Misma_H + clng(Qty_Misma_H)
				sumaQty_MismaMonto_H = sumaQty_MismaMonto_H + clng(Qty_MismaMonto_H)
				sumaQty_Otra_H = sumaQty_Otra_H + clng(Qty_Otra_H)
				sumaQty_OtraMonto_H = sumaQty_OtraMonto_H + clng(Qty_OtraMonto_H)
				sumaQty_Misma_M = sumaQty_Misma_M + clng(Qty_Misma_M)
				sumaQty_MismaMonto_M = sumaQty_MismaMonto_M + clng(Qty_MismaMonto_M)
				sumaQty_Otra_M = sumaQty_Otra_M + clng(Qty_Otra_M)
				sumaQty_OtraMonto_M = sumaQty_OtraMonto_M + clng(Qty_OtraMonto_M)%>
				<tr>
					<td>
						<%=codBtt%>
					</td>
					<td>
						<%=sucursal%>
					</td>
					<td>
						<%=formatnumber(Qty_Misma_H,0)%>
					</td>
					<td>
						$<%=formatnumber(Qty_MismaMonto_H,0)%>
					</td>
					<td>
						<%=formatnumber(Qty_Otra_H,0)%>
					</td>
					<td>
						$<%=formatnumber(Qty_OtraMonto_H,0)%>
					</td>
					<td>
						<%=formatnumber(Qty_Misma_M,0)%>
					</td>
					<td>
						$<%=formatnumber(Qty_MismaMonto_M,0)%>
					</td>
					<td>
						<%=formatnumber(Qty_Otra_M,0)%>
					</td>
					<td>
						$<%=formatnumber(Qty_OtraMonto_M,0)%>
					</td>
				</tr>
			<%next%>
			<tr>
				<td></td>
				<td>
					Total 
				</td>
				<td>
					<%=formatnumber(sumaQty_Misma_H,0)%>
				</td>
				<td>
					$<%=formatnumber(sumaQty_MismaMonto_H,0)%>
				</td>
				<td>
					<%=formatnumber(sumaQty_Otra_H,0)%>
				</td>
				<td>
					$<%=formatnumber(sumaQty_OtraMonto_H,0)%>
				</td>
				<td>
					<%=formatnumber(sumaQty_Misma_M,0)%>
				</td>
				<td>
					$<%=formatnumber(sumaQty_MismaMonto_M,0)%>
				</td>
				<td>
					<%=formatnumber(sumaQty_Otra_M,0)%>
				</td>
				<td>
					$<%=formatnumber(sumaQty_OtraMonto_M,0)%>
				</td>
			</tr>
		</tbody>
	</table>
	<%nombreArchivo = pago&" "&nombreMes&".xls"
	'response.write(nombreArchivo)
else
nombreArchivo = "noExistenDatos.xls"%>
<table border="1">
	<thead>
		<tr>
			<th>No existen datos</th>
		</tr>
	</thead>
</table>
<%end if
Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition", "attachment; filename="&nombreArchivo%>