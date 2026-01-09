<!--#include file="../funciones.asp"-->
<%
	perfil = trim(request("idPerfil"))
	idUsuario = trim(request("idUsuario"))
	periodo = trim(request("periodo"))
	nomCajero = trim(request("nomCajero"))
	idFaltanteModEstado = trim(request("idFaltanteModEstado"))
	valija = trim(request("valija"))

	sql = ""
	sql = sql & " EXEC SUC_prc_sucursal_faltante_detalle_estado '"&idFaltanteModEstado&"' "
	'response.write(sql)
	'response.end
	tieneDatos = 0
	set rs = db.execute(sql)
	if not rs.eof then
	  datos = rs.getrows()
	  tieneDatos = 1
	end if%>

<table id="tablaFaltanteCajeroDetalle" class="table table-bordered table-hover1 dataTable cuerpoTabla stripe" data-perfil="<%=perfil%>" data-idUsuario="<%=idUsuario%>" data-idSucursal="<%=idSucursal%>" data-periodo="<%=periodo%>">
	<thead style="background-color: #e6e6ff">
		<tr>
			<th>Fecha Faltante</th>
			<th>Cajero</th>
			<th>Cuenta</th>
			<th>Fecha Creación</th>
			<th>Fecha Mod</th>
			<th>Estado</th>
			<th>SLA</th>
		</tr>
	</thead>
	<tbody>
	<%if tieneDatos = 1 then
		for i = 0 to ubound(datos,2)
			nomCajero = trim(datos(0,i))
			cuentaCajero = trim(datos(1,i))
		  	fecha = trim(datos(4,i))
		  	estado = trim(datos(5,i))
		  	valija = trim(datos(6,i))
		  	sla = trim(datos(7,i))
		  	rutCajero = trim(datos(10,i))
		  	idFaltanteModEstado = trim(datos(13,i))
		  	fechaCreacion = trim(datos(15,i))
		  	fechaMod = trim(datos(16,i))
			%>
			<tr>
				<td><%=fecha%></td>
				<td><%=nomCajero%></td>
				<td><%=cuentaCajero%></td>
				<td><%=fechaCreacion%></td>
				<td><%=fechaMod%></td>
				<td style="background: #A9EAFF;"><%=estado%></td>
				<%if sla = "0" then%>
					<td><%=sla%></td>
				<%else%>
					<td style="background: #FF7B91;"><%=sla%></td>
				<%end if%>
			</tr>
		<%next
		else%>
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
<%end if%>
	</tbody>
</table>
