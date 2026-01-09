<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
tipo = trim(request("tipo"))

horaActual = time()
horaMin = HOUR(horaActual) * 60
horaMin = horaMin + minute(horaActual)
if tipo = "2" then
	campo = "doc"
end if
if tipo = "3" then
	campo = "cont"
end if
if tipo = "4" then
	campo = "admin"
end if
sql = ""
sql = sql & " select a.id_gest_"&campo&", "
sql = sql & " a.id_gest_"&campo&"_tipo, "
sql = sql & " a.ingreso_fecha, "
sql = sql & " YEAR(ingreso_fecha) as anio_ingreso, "
sql = sql & " MONTH(ingreso_fecha) as mes_ingreso, "
sql = sql & " DAY(ingreso_fecha) as dia_ingreso, "
sql = sql & " datepart(HOUR,ingreso_fecha) as hora_ingreso, "
sql = sql & " datepart(MINUTE,ingreso_fecha) as minuto_ingreso, "
sql = sql & " a.gest_"&campo&"_estado as estadoTarea, "
sql = sql & " a.id_sucursal, "
sql = sql & " b.area, "
sql = sql & " b.gest_"&campo&"_tipo, "
sql = sql & " a.fecha_operacion, "
sql = sql & " cast(gest_hora_efectiva as varchar(10)) as gest_hora_efectiva, "
sql = sql & " datepart(HOUR,a.horacorte_ini) as horaCorteInicio, "
sql = sql & " datepart(minute,a.horacorte_ini) as minutoCorteInicio, "
sql = sql & " datepart(HOUR,a.horacorte_fin) as horaCorteFin, "
sql = sql & " datepart(MINUTE,a.horacorte_fin) as minutoCorteFin "
sql = sql & " from SUC_gest_"&campo&" a inner join SUC_gest_"&campo&"_tipo b on a.id_gest_"&campo&"_tipo = b.id_gest_"&campo&"_tipo "
sql = sql & " where a.fecha_operacion = CAST(getdate() as date) "
sql = sql & " and a.id_sucursal = '"&idSucursal&"' "
sql = sql & " order by a.orden"
set rs = db.execute(sql)
if not rs.eof then%>
<form id="formGest" name="formGest">
	<input type="hidden" name="tipo" id="tipo" value="<%=tipo%>">
	<table class="table table-bordered table-hover" id="tablaTareas">
		<thead>
			<tr>
				<td>Tarea</td>
				<td>Hora Ingreso</td>
				<td>Hora de Gestión</td>
			</tr>
		</thead>
		<tbody>
		<%do while not rs.eof
			tarea = server.htmlencode(trim(rs(11)))
			idGestAdm = trim(rs(0))
			tareaCerrada = trim(rs("estadoTarea"))
			if trim(rs(13)) <> "" then
				hEfectiva = left(trim(rs(13)),2)
				mEfectiva = right(left(trim(rs(13)),5),2)
				horaEfectiva = hEfectiva&":"&mEfectiva
			else
				horaEfectiva = ""
			end if
			horaCorteInicio = clng(trim(rs("horaCorteInicio"))) *60
			minutoCorteInicio = clng(trim(rs("minutoCorteInicio")))
			corteInicio = horaCorteInicio+minutoCorteInicio
			horaCorteFin = clng(trim(rs("horaCorteFin"))) * 60
			minutoCorteFin = clng(trim(rs("horaCorteFin")))
			corteFin = horaCorteFin+minutoCorteFin
			minutosFaltantesCierre = corteFin - horaMin
			if minutosFaltantesCierre <= 0 then
				fuerahorario = 1
			else
				fuerahorario = 0
			end if
			fecha = trim(rs("ingreso_fecha"))
			if fecha <> "" then
				dia = trim(rs("dia_ingreso"))
				if len(dia) = 1 then
					dia = "0"&dia
				end if
				mes = trim(rs("mes_ingreso"))
				if len(mes) = 1 then
					mes = "0"&dia
				end if
				hora = trim(rs("hora_ingreso"))
				if len(hora) = 1 then
					hora = "0"&hora
				end if
				minutos = trim(rs("minuto_ingreso"))
				if len(minutos) = 1 then
					minutos = "0"&minutos
				end if
				anio = trim(rs("anio_ingreso"))
				muestraFecha = dia&"/"&mes&"/"&anio
				muestraHora = hora&":"&minutos
			else
				muestraHora = ""
				muestraFecha = ""
			end if%>
			<tr data-fuerahorario="<%=fuerahorario%>" data-id="<%=idGestAdm%>" data-minutos="<%=minutosFaltantesCierre%>" data-cerrada="<%=tareaCerrada%>">
				<td>
					<%=tarea%>
				</td>
				<td id="horaIngreso<%=idGestAdm%>"><%=muestraHora%></td>
				<td id="hora<%=idGestAdm%>"><%=horaEfectiva%></td>
			</tr>
			<%rs.MoveNext
		loop%>
		</tbody>
	</table>
</form>
<div id="guardaDatos" class="oculto"></div>
<%end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
DB.Close
set DB=nothing%>
