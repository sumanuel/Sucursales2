<!--#include file="../funciones2.asp"-->
<%
idSucursalCaja = trim(request("idSucursalCaja"))
idUsuarioMain = trim(request("idUsuarioMainCaja"))
periodo = trim(request("periodo"))
perfilMain = trim(request("idPerfilMain"))%>

<%sql = ""
sql = sql & " EXEC SCSS_prc_lista_total_carpetas_x_caja '"&periodo&"','"&idSucursalCaja&"','"&perfilMain&"'"
'response.write(sql)
'response.end
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
  datos = rs.getrows()
  tieneDatos = 1
end if
nombreArchivo ="Informe Cajas Q Carpetas"%>
<table>
	<thead>
		<tr>
			<th><strong>Caja</strong></th>
			<th><strong>Carpetas</strong></th>
			<th><strong>% Caja</strong></th>
			<th><strong>Estado Caja</strong></th>
			<th><strong>Fecha Env&iacute;o</strong></th>
			<th><strong>Usuario</strong></th>
			<th><strong>Sucursal</strong></th>
		</tr>
	</thead>
	<tbody>
	<%if tieneDatos = 1 then
		for i = 0 to ubound(datos,2)
			codigoBarras = trim(datos(0,i))
			estado = server.htmlencode(trim(datos(5,i)))
			idEstado = trim(datos(4,i))
			fechaEnvio = trim(datos(6,i))
			Usuario = trim(datos(7,i))
			Sucursal = trim(datos(8,i))
			totalMarcado = clng(trim(datos(2,i)))
			totalMarca = clng(trim(datos(3,i)))
			if totalMarca <> 0 then
				porcentajeMarca = formatpercent(totalMarcado/totalMarca,1)
				if right(porcentajeMarca,3) = ",0%" then
					enteroPorcentaje = cint(replace(porcentajeMarca,"%",""))
					porcentajeMarca = enteroPorcentaje&"%"
				end if
			else
				porcentajeMarca = "0%"
			end if
			totalDocumentos = clng(trim(datos(1,i)))
			if totalDocumentos = "" then totalDocumentos = 0
			enteroPorcentaje = cint(replace(porcentajeMarca,"%",""))
			%>
			<tr>
				<td><%=codigoBarras%></td>
				<td><%=totalDocumentos%></td>
				<td><%=porcentajeMarca%></td>
				<td id="estadoActual<%=i%>"><%=estado%></td>
				<td><%=fechaEnvio%></td>
				<td><%=Usuario%></td>
				<td><%=Sucursal%></td>
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
