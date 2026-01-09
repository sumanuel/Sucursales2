<!--#include file="../funciones2.asp"-->
<%idSucursalMain = trim(request("idSucursalMain1"))
idUsuarioMain = trim(request("idUsuarioMain1"))
periodo = trim(request("periodo"))
idProducto = trim(request("idProducto"))
idItem = trim(request("idItem"))
idAccion = trim(request("idAccion"))
selectIdCodigoNotario = trim(request("selectIdCodigoNotario"))
if selectIdCodigoNotario = "" then
	selectIdCodigoNotario = 0
end if
%>

<%
sql = ""
sql = sql & " EXEC SCSS_prc_datos_check_por_suc2 '"&idProducto&"','"&idItem&"','"&idSucursalMain&"','"&idUsuarioMain&"','"&idAccion&"','"&periodo&"','"&selectIdCodigoNotario&"' "
'response.write(sql)
'response.end
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
  datos = rs.getrows()
  tieneDatos = 1
end if
nombreArchivo ="Informe Detalle Crédito"%>
<table>
	<thead>
		<tr>
			<th><strong>Carpeta</strong></th>
			<th><strong>N&uacute;mero Cr&eacute;dito</strong></th>
			<th><strong>Fecha Colocaci&oacute;n</strong></th>
			<th><strong>Sucursal</strong></th>
			<th><strong>Rut Cliente</strong></th>
			<th><strong>N&uacute;mero Caja</strong></th>
			<th><strong>% Cr&eacute;dito</strong></th>
			<th><strong>Estado Notario</strong></th>
		</tr>
	</thead>
	<tbody>
	<%if tieneDatos = 1 then
		for i = 0 to ubound(datos,2)
		   	idCarpeta = trim(datos(0,i))
		    numCredito = trim(datos(1,i))
		    fechaColocacion = trim(datos(2,i))
		    nomSucursal = server.htmlencode(trim(datos(3,i)))
		    rutCliente = trim(datos(4,i))
		    numCaja = trim(datos(5,i))
			totalPorcentaje = trim(datos(6,i))
			estadoCaja = trim(datos(7,i))
		    idEstadoNotario = trim(datos(8,i))
		    tipoInsDel = trim(datos(9,i))
		    estadoNotario = server.htmlencode(trim(datos(13,i)))%>
			<tr>
				<td><%=idCarpeta%></td>
				<td><%=numCredito%></td>
				<td><%=fechaColocacion%></td>
				<td><%=nomSucursal%></td>
				<td><%=rutCliente%></td>
				<td><%=numCaja%></td>
				<td><%=totalPorcentaje%></td>
				<td><%=estadoNotario%></td>
			</tr>
		<%next%>
	</tbody>
</table>
	<%Response.Charset = "UTF-8"
		Response.ContentType = "application/vnd.ms-excel"
		Response.AddHeader "content-disposition", "inline; filename="&nombreArchivo&".xls"%>
	<%else%>
	<tr>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
	</tr>
	<%Response.Charset = "UTF-8"
		Response.ContentType = "application/vnd.ms-excel"
		Response.AddHeader "content-disposition", "inline; filename="&nombreArchivo&".xls"
end if%>