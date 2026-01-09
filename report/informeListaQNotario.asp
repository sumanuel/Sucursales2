<!--#include file="../funciones2.asp"-->
<% idSucursalEnvio = trim(request("idSucursalEnvio"))
idUsuarioMainEnvio = trim(request("idUsuarioMainEnvio"))
periodoEnvio = trim(request("periodoEnvio"))%>
<%
sql = ""
sql = sql & " EXEC SCSS_prc_lista_total_Envio_Notario '"&periodoEnvio&"','"&idSucursalEnvio&"' "
'response.write(sql)
'response.end
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
  datos = rs.getrows()
  tieneDatos = 1
end if
nombreArchivo ="Informe Envio Notario Q Carpetas"%>
<table>
	<thead>
		<tr>
			<th><strong>C&oacute;digo Notario</strong></th>
			<th><strong>Fecha Env&iacute;o</strong></th>
			<th><strong>Usuario</strong></th>
			<th><strong>Estado Env&iacute;o</strong></th>
			<th><strong>Sucursal</strong></th>
			<th><strong>Q carpetas</strong></th>
			<th><strong>% Env&iacute;o</strong></th>
		</tr>
	</thead>
	<tbody>
	<%if tieneDatos = 1 then
		for i = 0 to ubound(datos,2)
		   	codigoNotario = trim(datos(1,i))
		    fechaEnvio = trim(datos(2,i))    
		    idUsuario = server.htmlencode(trim(datos(3,i)))
		    estadoEnvio = server.htmlencode(trim(datos(4,i)))
		    nomSucursal = server.htmlencode(trim(datos(5,i)))
			total_carpeta = trim(datos(6,i))
			total_item = trim(datos(7,i))
		    total_checkOK = trim(datos(8,i))
		    if total_checkOK <> 0 then
		    	porcentajeMarca = formatpercent(total_checkOK/total_item,1)
		    	if right(porcentajeMarca,3) = ",0%" then
					enteroPorcentaje = cint(replace(porcentajeMarca,"%",""))
					porcentajeMarca = enteroPorcentaje&"%"
				end if
			else
				porcentajeMarca = "0%"
			end if
			idEstadoNotario = trim(datos(9,i))
			idEstadoEnvioNotario = trim(datos(10,i))
		    %>
			<tr>
				<td><%=codigoNotario%></td>
				<td><%=fechaEnvio%></td>
				<td><%=idUsuario%></td>
				<td><%=estadoEnvio%></td>
				<td><%=nomSucursal%></td>
				<td><%=total_carpeta%></td>
				<td><%=porcentajeMarca%></td>
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
	</tr>
	<%Response.Charset = "UTF-8"
		Response.ContentType = "application/vnd.ms-excel"
		Response.AddHeader "content-disposition", "inline; filename="&nombreArchivo&".xls"
	end if%>



