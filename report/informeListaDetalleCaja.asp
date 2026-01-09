<!--#include file="../funciones2.asp"-->
<%idCodigoBarra = trim(request("idCodigoBarra"))

sql = ""
sql = sql & " SELECT a.id_carpeta, a.num_credito, a.rut_cliente, a.dv_cliente, a.nom_cliente, "
sql = sql & " 	a.fecha_colocacion, a.tipo_pens_trab, "
sql = sql & " 	(select COUNT(*) from SUC_vcc_checklist b , SUC_vcc_tipo_doc c where b.id_carpeta = "
sql = sql & " 		a.id_carpeta and b.check_OK = 0 "
sql = sql & " 		and b.ID_Tipo_Doc = c.ID_Tipo_Doc ) as si, "
sql = sql & " 	(select COUNT(*) from SUC_vcc_checklist b , SUC_vcc_tipo_doc c where b.id_carpeta = "
sql = sql & " 		a.id_carpeta and b.ID_Tipo_Doc = c.ID_Tipo_Doc ) as total, id_codigo_barra "
sql = sql & " FROM SUC_vcc_carpeta_credito a "
sql = sql & " WHERE a.id_codigo_barra = '"&idCodigoBarra&"' order by a.id_carpeta desc "
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
  datos = rs.getrows()
  tieneDatos = 1
end if
nombreArchivo ="Informe Detalle Caja"%>
<table>
	<thead>
		<tr>
			<th><strong>Carpeta</strong></th>
			<th><strong>N&uacute;mero Cr&eacute;dito</strong></th>
			<th><strong>Caja</strong></th>
			<th><strong>Rut</strong></th>
			<th><strong>Nombre</strong></th>
			<th><strong>Fecha Colocaci&oacute;n</strong></th>
			<th><strong>Tipo</strong></th>
			<th><strong>% CheckList</strong></th>
		</tr>
	</thead>
	<tbody>
	<%if tieneDatos = 1 then
		for i = 0 to ubound(datos,2)
				idCarpeta = trim(datos(0,i))
				numeroCredito = trim(datos(1,i))
				rutCliente = trim(datos(2,i))&"-"&trim(datos(3,i))
				nombreCliente = server.htmlencode(trim(datos(4,i)))
				fechaColocacion = trim(datos(5,i))
				tipo = trim(datos(6,i))
		  		if tipo = "30" then
					textoTipo = "Trabajador"
				else
					textoTipo = "Pensionado"
				end if
		  		completadoOk = cint(trim(datos(7,i)))
				total = cint(trim(datos(8,i)))
				if completadoOk = "0" and total = "0" then
					porcentajeCompletado = "0%"
				else
				porcentajeCompletado = formatpercent(completadoOk/total,1)
					if right(porcentajeCompletado,3) = ",0%" then
						porcentajeCompletado = replace(porcentajeCompletado,"%","")
						porcentajeCompletado = cint(porcentajeCompletado)
						porcentajeCompletado = porcentajeCompletado&"%"
					end if
				end if
				idCaja = trim(datos(9,i))
		    %>
			<tr>
				<td><%=idCarpeta%></td>
				<td>
					<span id="<%=idCarpeta%>">
						<%=numeroCredito%>
					</span>
				</td>
				<td><%=idCaja%></td>
				<td><%=rutCliente%></td>
				<td><%=nombreCliente%></td>
				<td><%=fechaColocacion%></td>
				<td><%=textoTipo%></td>
				<td><%=porcentajeCompletado%></td>
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
