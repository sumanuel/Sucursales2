<!--#include file="../funciones.asp"-->
<%perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
idCalitem = trim(request("idCalItem"))
fecha = trim(request("fecha"))
fechaAnio = left(fecha,4)
fechaMes = right(left(fecha,6),2)
idTarea = trim(request("idTarea"))
sql = ""
sql = sql & " select fecha_f2, "
sql = sql & " item_titulo, "
sql = sql & " item_obs, "
sql = sql & " cast(item_hora as datetime) as item_hora, "
sql = sql & " suc_nombre, "
sql = sql & " suc_tipo, "
sql = sql & " suc_direccion, "
sql = sql & " suc_jeps, "
sql = sql & " id_calitem "
sql = sql & " from SUC_calendario a "
sql = sql & " inner join SUC_calendario_item b "
sql = sql & " on a.id_cal = b.id_cal "
sql = sql & " inner join SUC_calendario_item_tipo c "
sql = sql & " on b.id_calitipo = c.id_calitipo "
sql = sql & " inner join SUC_sucursal d "
sql = sql & " on b.id_suc = d.id_sucursal "
sql = sql & " inner join SUC_usuario e "
sql = sql & " on b.id_usuario = e.id_usuario "
sql = sql & " where b.id_calitem = '"&idCalitem&"'"
set rs = db.execute(sql)
if not rs.eof then
	fecha = trim(rs("fecha_f2"))
	diaFecha = day(fecha)
	if len(diaFecha) = 1 then diaFecha = "0"&diaFecha
	mesFecha = month(fecha)
	if len(mesFecha) = 1 then mesFecha = "0"&mesFecha
	anioFecha = year(fecha)
	muestraFecha = primeraMayuscula(server.htmlencode(FormatDateTime(diaFecha&"/"&mesFecha&"/"&anioFecha,1)))
	accion= server.htmlencode(trim(rs("item_titulo")))
	observacion = server.htmlencode(trim(rs("item_obs")))
	hora = hour(trim(rs("item_hora")))
	if len(hora) = 1 then hora = "0"&hora
	minutos = minute(trim(rs("item_hora")))
	if len(minutos) = 1 then minutos = "0"&hora
	muestraHora = hora&":"&minutos
	nombreSucursal = server.htmlencode(trim(rs("suc_nombre")))
	tipoSucursal = server.htmlencode(trim(rs("suc_tipo")))
	direccion = server.htmlencode(trim(rs("suc_direccion")))
	jeps = server.htmlencode(trim(rs("suc_jeps")))
	id_calitem = trim(rs("id_calitem"))
end if%>
<div class="row-fluid" id="listaVisitas">
	<div class="span12">
		<table class="table table-bordered table-hover">
			<tbody>
				<tr>
					<td width="30%">Sucursal</td>
					<td><%=nombreSucursal%> (<%=tipoSucursal%>)</td>
				</tr>
				<tr>
					<td>Dirección</td>
					<td>
						<%=direccion%>
						<input type="hidden" name="direccion" id="direccion" value="<%=direccion%>">
					</td>
				</tr>
				<tr>
					<td>Jeps</td>
					<td><%=jeps%></td>
				</tr>
				<tr>
					<td>Accción</td>
					<td><%=accion%></td>
				</tr>
				<tr>
					<td>Fecha</td>
					<td><%=muestraFecha%></td>
				</tr>
				<tr>
					<td>Hora</td>
					<td><%=muestraHora%></td>
				</tr>
				<tr>
					<td>Observación</td>
					<td><%=observacion%></td>
				</tr>
			</tbody>
		</table>
	</div>
</div>