<!--#include file="../../funciones.asp"-->
<%valor = trim(request("valor"))
anio = left(valor,4)
mes = cint(right(valor,2))
nombreMes = primeraMayuscula(monthname(mes))
nombreArchivo = nombreMes&" - "&anio&".xls"
sql = ""
sql = sql & " select a.cod_sucursal as cod_btt, "
sql = sql & " a.nombre_sucursal, "
sql = sql & " a.colPenCred, "
sql = sql & " a.colPenCred_monto, "
sql = sql & " a.colTraCred, "
sql = sql & " a.colTraCred_monto, "
sql = sql & " a.afi_normal, "
sql = sql & " a.afi_pbs, "
sql = sql & " a.afi_ffaa, "
sql = sql & " cast(a.fecha as date) as fecha "
sql = sql & " from SUC_transacciones_diarias a "
sql = sql & " inner join SUC_sucursal b "
sql = sql & " on a.cod_sucursal = b.cod_bantotal "
sql = sql & " and b.suc_foco = 1 "
sql = sql & " where year(a.fecha) = '"&anio&"' "
sql = sql & " and month(a.fecha) = '"&mes&"' " 
sql = sql & " order by a.fecha "
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
				Cod btt
			</th>
			<th>
				Nombre sucursal
			</th>
			<th>
				Creditos pensionados
			</th>
			<th>
				Creditos pensionados monto
			</th>
			<th>
				Creditos trabajadores
			</th>
			<th>
				Creditos trabajadores monto
			</th>
			<th>
				Afiliaciones normal
			</th>
			<th>
				Afiliaciones Pbs
			</th>
			<th>
				Afiliaciones FFAA
			</th>
			<th>
				Fecha
			</th>
		</tr>
	</thead>
	<tbody>
		<%for i = 0 to ubound(datos,2)
			codBtt = trim(datos(0,i))
			nombreSucursal = trim(datos(1,i))
			credPen = trim(datos(2,i))
			credPenM = trim(datos(3,i))
			credTrab = trim(datos(4,i))
			credTrabM = trim(datos(5,i))
			afiN = trim(datos(6,i))
			afiPbs = trim(datos(7,i))
			afiFFAAA = trim(datos(8,i))
			fecha = trim(datos(9,i))%>
			<tr>
				<td>
					<%=codBtt%>
				</td>
				<td>
					<%=nombreSucursal%>
				</td>
				<td>
					<%=credPen%>
				</td>
				<td>
					$<%=credPenM%>
				</td>
				<td>
					<%=credTrab%>
				</td>
				<td>
					$<%=credTrabM%>
				</td>
				<td>
					<%=afiN%>
				</td>
				<td>
					<%=afiPbs%>
				</td>
				<td>
					<%=afiFFAAA%>
				</td>
				<td>
					<%=fecha%>
				</td>
			</tr>
		<%next%>
	</tbody>
</table>
<%Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & nombreArchivo 
end if%>