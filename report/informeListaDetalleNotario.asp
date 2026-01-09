<!--#include file="../funciones2.asp"-->
<%idSucursalEnvio = trim(request("idSucursalEnvio"))
idCodigoNotario = trim(request("idCodigoNotario"))
periodoEnvio = trim(request("periodoEnvio"))
idPerfilMainEnvio = trim(request("idPerfilMainEnvio"))%>

<%
sql = ""
sql = sql & " EXEC SCSS_prc_notario_detalle_total_credito_notario '"&periodoEnvio&"','"&idSucursalEnvio&"','"&idCodigoNotario&"','"&idPerfilMainEnvio&"' "
'response.write(sql)
'response.end
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
  datos = rs.getrows()
  tieneDatos = 1
end if
nombreArchivo ="Informe Detalle Envio Notario"%>
<table>
	<thead>
		<tr>
			<th><strong>Carpeta</strong></th>
			<th><strong>N&uacute;mero Cr&eacute;dito</strong></th>
			<th><strong>Fecha Colocaci&oacute;n</strong></th>
			<th><strong>Env&iacute;o Notario</strong></th>
			<th><strong>Estado Env&iacute;o</strong></th>
			<th><strong>Fecha Asoc Cred Env&iacute;o</strong></th>
			<th><strong>Rut Cliente</strong></th>
			<th><strong>Usuario</strong></th>
			<th><strong>Sucursal</strong></th>
		</tr>
	</thead>
	<tbody>
	<%if tieneDatos = 1 then
		for i = 0 to ubound(datos,2)
			idCarpeta = trim(datos(0,i))
		   	numCredito = trim(datos(1,i))
		   	codNotario = trim(datos(2,i))  
		    fechaCredito = trim(datos(3,i))
		    fechaColocacion = trim(datos(4,i))     
		    rutCliente = trim(datos(5,i)) 
		    estadoCredNotario = server.htmlencode(trim(datos(6,i)))
		    usuarioCred = 	server.htmlencode(trim(datos(7,i))) 
		    nomSucursal = server.htmlencode(trim(datos(8,i)))
			idCodigoNotario = trim(datos(9,i))
			idEstadoNotarioCred = trim(datos(10,i))
		    %>
			<tr>
				<td><%=idCarpeta%></td>
				<td><%=numCredito%></td>
				<td><%=fechaColocacion%></td>
				<td><%=codNotario%></td>
				<td><%=estadoCredNotario%></td>
				<td><%=fechaCredito%></td>
				<td><%=rutCliente%></td>
				<td><%=usuarioCred%></td>
				<td><%=nomSucursal%></td>
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
		<td>---</td>
	</tr>
	<%Response.Charset = "UTF-8"
	Response.ContentType = "application/vnd.ms-excel"
	Response.AddHeader "content-disposition", "inline; filename="&nombreArchivo&".xls"%>
<%end if%>

