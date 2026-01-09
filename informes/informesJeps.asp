 <!--#include file="../funciones.asp"-->
<%
idUsuario = trim(request("idUsuario"))
perfil = trim(request("perfil"))
totalSucursales = 0
if perfil = "1" then

	sql = ""
	sql = sql & " select id_sucursal, "
	sql = sql & " suc_nombre "
	sql = sql & " from suc_sucursal "
	sql = sql & " where id_sucursal in "
	sql = sql & " (select id_sucursal "
	sql = sql & " from SUC_usuario_sucursal "
	sql = sql & " where id_usuario = '"&idUsuario&"') "
	sql = sql & " order by suc_nombre "
	set rs = db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
	end if
	sql = ""
	sql = sql & " select count(*) "
	sql = sql & " from suc_sucursal "
	sql = sql & " where id_sucursal in "
	sql = sql & " (select id_sucursal "
	sql = sql & " from SUC_usuario_sucursal "
	sql = sql & " where id_usuario = '"&idUsuario&"') "
	set rs = db.execute(sql)
	if not rs.eof then
		totalSucursales = trim(rs(0))
	end if
end if%>
<div class="row-fluid">
	<div class="span4 well">
		<div class="row-fluid">
			<div class="span12 text-center alert alert-success">
				<strong>Informes Diarios</strong>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 encuestaAseo mano">
				Encuesta Aseo
			</div>
			<%totalSucursales = 1
			if totalSucursales > 1 then
				span = 4%>
				<div class="span4 ">
					<span id="textoSeleccioneSucursalAseo" class="mano encuestaAseo">
						Seleccione sucursal
					</span>
					<span id="divSelectSucursalAseo" class="oculto">
						<select id="selectSucursalAseo" class="span12">
							<option value="">[Seleccione sucursal]</option>
							<%for i=0 to ubound(datos,2)
								idSucursal = trim(datos(0,i))
								nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
								<option value="<%=idSucursal%>">
									<%=nombreSucursal%>
								</option>
							<%next%>
						</select>
					</span>
				</div>
			<%else
				for i=0 to ubound(datos,2)
					idSucursal = trim(datos(0,i))
				next
				span = 8%>
				<input type="hidden" name="selectSucursalAseo" id="selectSucursalAseo" value = "<%=idSucursal%>">
			<%end if%>
			<div class="span<%=span%>">
				<h5>
					<span class="icon-stack icon-large iconoEncuestaAseo mano ayuda" data-placement="right" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosEncuestaAseo text-success ayuda" data-placement="right" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
				</h5>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 dotacion mano">
				Dotacion
			</div>
			<div class="span4 ">
				<span id="textoSeleccioneDotacion" class="mano dotacion">
					Seleccione sucursal 
				</span>
				<span id="divSelectDotacion" class="oculto">
					<select id="selectDotacion" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<span id="divFechaSelectDotacion" class="oculto">
					<select id="selectFechaDotacion" class="span12">
						<option value="">[Seleccione fecha]</option>
						<%sql = ""
						sql = sql & " select fecha_ingreso "
						sql = sql & " from SUC_sucursal_dotacion "
						sql = sql & " group by fecha_ingreso "
						sql = sql & " order by fecha_ingreso "
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()						
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next
						  end if
						%>
					</select>
				</span>
			</div>
			<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoDotacion mano ayuda" data-placement="right" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosDotacion text-success ayuda" data-placement="right" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaDotacion text-success ayuda" data-placement="right" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 afiliaciones mano">
				Afiliaciones
			</div>
			<div class="span4 ">
				<span id="textoSeleccioneAfiliaciones" class="mano afiliaciones">
					Seleccione sucursal 
				</span>
				<span id="divSelectAfiliaciones" class="oculto">
					<select id="selectAfiliaciones" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<%sql = ""
				sql = sql & " select cast((substring(a.creado_el, 7, 4)+"
				sql = sql & " substring(a.creado_el, 4, 2)"
				sql = sql & " +substring(a.creado_el, 1, 2)) as DATE) "
				sql = sql & " from SUC_index_afi_det a "
				sql = sql & " group by cast((substring(a.creado_el, 7, 4)"
				sql = sql & " +substring(a.creado_el, 4, 2)"
				sql = sql & " +substring(a.creado_el, 1, 2)) as DATE) "
				sql = sql & " order by cast((substring(a.creado_el, 7, 4)"
				sql = sql & " +substring(a.creado_el, 4, 2)"
				sql = sql & " +substring(a.creado_el, 1, 2)) as DATE) "%>
				<span id="divFechaSelecAfiliaciones" class="oculto">
					<select id="selectFechaAfiliaciones" class="span12">
						<option value="">[Seleccione fecha]</option>
						<%
						'Response.Write(sql)
						'Response.End()
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()
						end if
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next%>
					</select>
				</span>
			</div>
			<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoAfiliaciones mano ayuda" data-placement="right" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosAfiliaciones text-success ayuda" data-placement="right" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaAfiliaciones text-success ayuda" data-placement="right" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div>
		</div>
	</div>
	<div class="span4 well">
		<div class="row-fluid">
			<div class="span12  alert alert-success text-center">
				<strong>Reclamos</strong>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 gestorCasos mano">
				Gestor de Casos
			</div>
			<div class="span4 ">
				<span id="textoSeleccioneGestorCasos" class="mano gestorCasos">
					Seleccione sucursal 
				</span>
				<span id="divSelectGestorCasos" class="oculto">
					<select id="selectGestorCasos" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<span id="divFechaSelectGestorCasos" class="oculto">
					<select id="selectFechaGestorCasos" class="span12">
						<option value="">[Seleccione fecha]</option>
						<%sql = ""
						sql = sql & " select cast(fecha_registro as DATE) "
						sql = sql & " as fecha_registro "
						sql = sql & " from SUC_index_rec_det "
						sql = sql & " group by cast(fecha_registro as DATE) "
						sql = sql & " order by fecha_registro desc "
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()
						end if
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next%>
					</select>
				</span>
			</div>
			<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoGestorCasos mano ayuda" data-placement="right" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosGestorCasos text-success ayuda" data-placement="right" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaGestorCasos text-success ayuda" data-placement="right" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 mesaAyuda mano">
				Mesa de ayuda
			</div>
			<div class="span4 ">
				<span id="textoSeleccioneMesaAyuda" class="mano mesaAyuda">
					Seleccione sucursal
				</span>
				<span id="divSelectMesaAyuda" class="oculto">
					<select id="selectMesaAyuda" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<span id="divFechaSelectMesaAyuda" class="oculto">
					<select id="selectFechaMesaAyuda" class="span12">
						<option value="">[Seleccione fecha]</option>
						<%sql = ""
						sql = sql & " select cast(fecha_registro as DATE) "
						sql = sql & " as fecha_registro "
						sql = sql & " from SUC_index_ma_det "
						sql = sql & " group by cast(fecha_registro as DATE) "
						sql = sql & " order by fecha_registro desc "
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()
						end if
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next%>
					</select>
				</span>
			</div>
			<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoMesaAyuda mano ayuda" data-placement="right" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosMesaAyuda text-success ayuda" data-placement="right" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaMesaAyuda text-success ayuda" data-placement="right" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div>
		</div>
	</div>
	<div class="span4 well">
		<div class="row-fluid">
			<div class="span12  alert alert-success text-center">
				<strong>Licencias Medicas</strong>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 licenciasMedicas mano">
				Licencias medicas
			</div>
			<div class="span4 ">
				<span id="textoSeleccioneLicenciasMedicas" class="mano licenciasMedicas">
					Seleccione sucursal
				</span>
				<span id="divSelectLicenciaMedica" class="oculto">
					<select id="selectLicenciaMedica" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<span id="divFechaLicenciasMedicas" class="oculto">
					<select id="selectFechaLicenciaMedica" class="span12">
						<option value="">[Seleccione fecha]</option>
						<%sql = ""
						sql = sql & " select cast(fecha_registro as DATE) "
						sql = sql & " as fecha_registro "
						sql = sql & " from SUC_index_lm_det "
						sql = sql & " group by cast(fecha_registro as DATE) "
						sql = sql & " order by fecha_registro desc "
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()
						end if
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next%>
					</select>
				</span>
			</div>
			<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoLicenciaMedica mano ayuda" data-placement="left" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosLicenciaMedica text-success ayuda" data-placement="left" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaLicenciasMedica text-success ayuda" data-placement="right" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div>
		</div>
	</div>
</div>
<div class="row-fluid">
	<div class="span4 well">
		<div class="row-fluid">
			<div class="span12  alert alert-success text-center">
				<strong>Control</strong>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 saldoCajaBt mano">
				Saldo caja BT
			</div>
			<div class="span4 ">
				<span id="textoSeleccioneSaldoCajaBt" class="mano saldoCajaBt">
					Seleccione sucursal
				</span>
				<span id="divSelectSaldoCajaBt" class="oculto">
					<select id="selectSaldoCajaBt" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<span id="divFechaSaldoCajaBt" class="oculto">
					<select id="selectFechaSaldoCajaBt" class="span12">
						<option value="">[Seleccione fecha]</option>

						<%sql = ""
						sql = sql & " select cast(fecha_registro as DATE) "
						sql = sql & " as fecha_registro "
						sql = sql & " from SUC_index_controller_saldo_caja_btt_det "
						sql = sql & " group by cast(fecha_registro as DATE) "
						sql = sql & " order by fecha_registro desc "
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()
						end if
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next%>
					</select>
				</span>
			</div>
			<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoSaldoCajaBt mano ayuda" data-placement="left" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosSaldoCajaBt text-success ayuda" data-placement="left" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaSaldoCajaBt text-success ayuda" data-placement="right" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 saldoServiBanca mano">
				Saldo ServiBanca
			</div>
			<div class="span4 ">
				<span id="textoSeleccioneSaldoServiBanca" class="mano saldoServiBanca">
					Seleccione sucursal
				</span>
				<span id="divSelectSaldoServiBanca" class="oculto">
					<select id="selectSaldoServiBanca" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<span id="divFechaSaldoServiBanca" class="oculto">
					<select id="selectFechaSaldoServiBanca" class="span12">
						<option value="">[Seleccione fecha]</option>
						<%sql = ""
						sql = sql & " select cast(fecha_registro as date) as fecha_disponible "
						sql = sql & " from SUC_sucursal_saldos_servibanca "
						sql = sql & " where fecha_registro is not NULL "
						sql = sql & " GROUP BY fecha_registro "
						sql = sql & " order by fecha_registro desc "
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()
						end if
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next%>
					</select>
				</span>
			</div>
			<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoSaldoServiBanca mano ayuda" data-placement="left" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosSaldoServiBanca text-success ayuda" data-placement="left" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaSaldoServiBanca text-success ayuda" data-placement="right" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 remesas mano">
				Remesas por sucursal
			</div>
			<div class="span4 ">
				<span id="textoSeleccioneRemesas" class="mano remesas">
					Seleccione sucursal
				</span>
				<span id="divSelectRemesas" class="oculto">
					<select id="selectRemesas" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<span id="divFechaRemesas" class="oculto">
					<select id="selectFechaRemesas" class="span12">
						<option value="">[Seleccione fecha]</option>
						<%sql = ""
						sql = sql & " select cast(fecha as date) as fecha_registro "
						sql = sql & " from SUC_remesas "
						sql = sql & " where fecha is not NULL "
						sql = sql & " GROUP BY fecha "
						sql = sql & " order by fecha_registro desc "
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()
						end if
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next%>
					</select>
				</span>
			</div>
			<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoRemesas mano ayuda" data-placement="left" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosRemesas text-success ayuda" data-placement="left" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaRemesas text-success ayuda" data-placement="right" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div>
		</div>
	</div>
	<div class="span4 well">
		<div class="row-fluid">
			<div class="span12  alert alert-success text-center">
				<strong>Pagos</strong>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 pagosIps mano">
				IPS
			</div>
			<div class="span4 ">
				<span id="textoSeleccionePagoIps" class="mano pagosIps">
					Seleccione sucursal
				</span>
				<span id="divSelectPagoIps" class="oculto">
					<select id="selectPagoIps" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<span id="divFechaPagoIps" class="oculto">
					<select id="selectFechaPagoIps" class="span12">
						<option value="">[Seleccione fecha]</option>
						<%sql = ""		
						sql = sql & " select cast(fecha as date) as fecha_registro "		
						sql = sql & " from indices..control_ips2_historico "
						sql = sql & " group by cast(fecha as DATE) "
						sql = sql & " order by fecha_registro desc "
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()
						end if
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next%>
					</select>
				</span>
			</div>
			<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoPagoIps mano ayuda" data-placement="left" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosPagoIps text-success ayuda" data-placement="left" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaPagoIps text-success ayuda" data-placement="right" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 bonos mano">
				Bonos
			</div>
			<div class="span4 ">
				<span id="textoSeleccioneBonos" class="mano bonos">
					Seleccione sucursal
				</span>
				<span id="divSelectBonos" class="oculto">
					<select id="selectBonos" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<span id="divFechaBonos" class="oculto">
					<select id="selectFechaBonos" class="span12">
						<option value="">[Seleccione fecha]</option>
						<%sql = ""		
						sql = sql & " select cast(fecha as date) as fecha_registro "		
						sql = sql & " from indices..control_bonos_historico "
						sql = sql & " group by cast(fecha as DATE) "
						sql = sql & " order by fecha_registro desc "
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()
						end if
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next%>
					</select>
				</span>
			</div>
			<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoBonos mano ayuda" data-placement="left" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosBonos text-success ayuda" data-placement="left" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaBonos text-success ayuda" data-placement="right" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 entidadesPagadoras mano">
				Entidades Pagadoras
			</div>
			<div class="span4 ">
				<span id="textoSeleccioneEntidadesPagadoras" class="mano entidadesPagadoras">
					Seleccione sucursal
				</span>
				<span id="divSelectEntidadesPagadoras" class="oculto">
					<select id="selectEntidadesPagadoras" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<span id="divFechaEntidadesPagadoras" class="oculto">
					<select id="selectFechaEntidadesPagadoras" class="span12">
						<option value="">[Seleccione fecha]</option>
						<%sql = ""		
						sql = sql & " select MAX(cast(fecha as date)) as fecha_registro "		
						sql = sql & " from indices..control_afp_historico "
						sql = sql & " group by cast(fecha as DATE) "
						sql = sql & " order by fecha_registro desc "
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()
						end if
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next%>
					</select>
				</span>
			</div>
			<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoEntidadesPagadoras mano ayuda" data-placement="left" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosEntidadesPagadoras text-success ayuda" data-placement="left" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaEntidadesPagadoras text-success ayuda" data-placement="right" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div>
		</div>
	</div>
	<div class="span4 well">
		<div class="row-fluid">
			<div class="span12  alert alert-success text-center">
				<strong>Creditos</strong>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 stock mano">
				<strike>Stock</strike>
			</div>
			<div class="span4 ">
				<span id="textoSeleccioneStock" class="mano stock">
					Seleccione sucursal
				</span>
				<span id="divSelectStock" class="oculto">
					<select id="selectStock" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<span id="divFechaStock" class="oculto">
					<select id="selectFechaStock" class="span12">
						<option value="">[Seleccione fecha]</option>
						<%sql = ""		
						sql = sql & " select cast(fecha_operacion as date) as fecha_registro "		
						sql = sql & " from SUC_index_cr_det_inst "
						sql = sql & " group by cast(fecha_operacion as DATE) "
						sql = sql & " order by fecha_registro desc "
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()
						end if
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next%>
					</select>
				</span>
			</div>
			<!--<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoStock mano ayuda" data-placement="left" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosStock text-success ayuda" data-placement="left" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaStock text-success ayuda" data-placement="right" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div> -->
		</div>
		<div class="row-fluid">
			<div class="span4 intancias mano">
				Instancias
			</div>
			<div class="span4 ">
				<span id="textoSeleccioneIntancias" class="mano intancias">
					Seleccione sucursal
				</span>
				<span id="divSelectIntancias" class="oculto">
					<select id="selectIntancias" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<span id="divFechaIntancias" class="oculto">
					<select id="selectFechaIntancias" class="span12">
						<option value="">[Seleccione fecha]</option>
						<%sql = ""		
						sql = sql & " select cast(fecha_operacion as date) as fecha_registro "		
						sql = sql & " from SUC_index_cr_det_inst "
						sql = sql & " group by cast(fecha_operacion as DATE) "
						sql = sql & " order by fecha_registro desc "
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()
						end if
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next%>
					</select>
				</span>
			</div>
			<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoIntancias mano ayuda" data-placement="left" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosIntancias text-success ayuda" data-placement="left" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaIntancias text-success ayuda" data-placement="right" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span4 colocados mano">
				Colocados
			</div>
			<div class="span4 ">
				<span id="textoSeleccioneColocados" class="mano colocados">
					Seleccione sucursal
				</span>
				<span id="divSelectColocados" class="oculto">
					<select id="selectColocados" class="span12">
						<option value="">[Seleccione sucursal]</option>
						<%for i=0 to ubound(datos,2)
							idSucursal = trim(datos(0,i))
							nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idSucursal%>">
								<%=nombreSucursal%>
							</option>
						<%next%>
					</select>
				</span>
				<span id="divFechaColocados" class="oculto">
					<select id="selectFechaColocados" class="span12">
						<option value="">[Seleccione fecha]</option>
						<%sql = ""		
						sql = sql & " select cast(fecha_operacion as date) as fecha_registro "		
						sql = sql & " from SUC_index_cr_det_coloc "
						sql = sql & " group by cast(fecha_operacion as DATE) "
						sql = sql & " order by fecha_registro desc "
						set rs = db.execute(sql)
						if not rs.eof then
							datoFechaGestorCasos = rs.GetRows()
						end if
						for i=0 to ubound(datoFechaGestorCasos,2)
							fecha = trim(datoFechaGestorCasos(0,i))
							muestraFecha = cdate(trim(datoFechaGestorCasos(0,i)))
							diaMuestraFecha = formateaParaFecha(day(muestraFecha))
							mesMuestraFecha = formateaParaFecha(month(muestraFecha))
							anioMuestraFecha = year(muestraFecha)
							muestraFecha = diaMuestraFecha&"/"&mesMuestraFecha&"/"&anioMuestraFecha
							%>
							<option value="<%=fecha%>">
								<%=muestraFecha%>
							</option>
						<%next%>
					</select>
				</span>
			</div>
			<div class="span4">
				<h5>
					<span class="icon-stack icon-large iconoColocados mano ayuda" data-placement="left" data-original-title="Descargar informe para la sucursal seleccionada">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-cloud-download"></i>
					</span>
					<span class="icon-stack icon-large mano iconoTodosColocados text-success ayuda" data-placement="left" data-original-title="Descargar informe para todas sus sucursales">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
					<span class="icon-stack icon-large mano iconoFechaColocados text-success ayuda" data-placement="left" data-original-title="Seleccionar fecha">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-calendar"></i>
					</span>
				</h5>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript" src="js/informes.js"></script>