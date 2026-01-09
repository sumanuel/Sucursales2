<!--#include file="../funciones.asp"-->
<table class="table table-bordered table-condensed" id="tablaDatosGerencia">
	<thead>
		<tr>
			<th>
				Zona
			</th>
			<th>
				<div id="gDocumentalGer">
					<i class="icon-archive icon-2x ayuda" data-placement="top" data-original-title="Gestión documental"></i>
				</div>
			</th>
			<th>
				<div id="gContableGer" class="ayuda" data-placement="top" >
					<i class="icon-money icon-2x ayuda" data-placement="top" data-original-title="Gestión contable"></i>
				</div>
			</th>
			<th>
				<div id="gAdministrativaGer">
					<i class="icon-group icon-2x ayuda" data-placement="top" data-original-title="Gestión Administrativa"></i>
				</div>
			</th>
			<th>
				Apertura
			</th>
			<th>
				Estado
			</th>
			<th colspan="3">
				Cajeros
			</th>
			<th>
				Guardias
			</th>
		</tr>
	</thead>
	<tbody>
		<%sql2 = ""
		sql2 = sql2 & " select id_zonal_mas, zonal_mas,id_usuario from SUC_zonales_comercial_mas"
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			datosZonal = rs2.GetRows()
		end if
		for x=0 to ubound(datosZonal,2)
			idZonal = trim(datosZonal(2,x))
			nombreZonal = server.htmlencode(trim(datosZonal(1,x)))%>
			<tr class="abreTrSucursales mano muestra info" data-idZonal="<%=idZonal%>">
				<td id="nombreZonal">
					<%=nombreZonal%>
					<span id="iconoZonal<%=idZonal%>" class="label label-danger oculto">
						<i class="icon-collapse"></i>   
						Cerrar
					</span>
				</td>
				<td>
					<div id="detalleDocumentalZonal<%=idZonal%>" data-idTipo="2">
						<img src="img/loading.gif">
					</div>
				</td>
				<td>
					<div id="detalleContableZonal<%=idZonal%>" data-idTipo="3">
						<img src="img/loading.gif">
					</div>
				</td>
				<td>
					<div id="detalleAdministrativaZonal<%=idZonal%>" data-idTipo="4">
						<img src="img/loading.gif">
					</div>
				</td>
				<td>
					<div id="aperturaSucursalZonal<%=idZonal%>">
						<span id="porcentajeApertura<%=idZonal%>" class="badge badge-success ayuda" data-placement="top" data-original-title="Sucursales Abiertas"></span>&nbsp;&nbsp;
						<span id="porcentajeAperturaSr<%=idZonal%>" class="badge ayuda" data-placement="top" data-original-title="Sucursales sin apertura"></span>&nbsp;&nbsp;
						<span id="porcentajeCerrado<%=idZonal%>" class="badge badge-info ayuda" data-placement="top" data-original-title="Sucursales cerradas"></span>
					</div>
				</td>
				<td>
					<div id="horaAperturaZonal<%=idZonal%>"></div>
				</td>
				<td>
					<div id="cajerosZonalP<%=idZonal%>">
						<img src="img/loading.gif">
					</div>&nbsp;
                </td>
                <td>
					<div id="cajerosZonalA<%=idZonal%>">
						<img src="img/loading.gif">
					</div>
                </td>
                 <td>
                    <div id="cajerosZonalSR<%=idZonal%>">
                    	<img src="img/loading.gif">
                    </div>
				</td>
				<td>
					<div id="guardiasZonal<%=idZonal%>"><img src="img/loading.gif"></div>
				</td>
			</tr>
			<%sql3 = ""
			sql3 = sql3 & " select id_sucursal, "
			sql3 = sql3 & " suc_nombre "
			sql3 = sql3 & " from suc_sucursal "
			sql3 = sql3 & " where id_sucursal in "
			sql3 = sql3 & " (select id_sucursal "
			sql3 = sql3 & " from SUC_zonales_comercial_mas_sucursal "
			sql3 = sql3 & " where id_zonal = '"&idZonal&"') "
			sql3 = sql3 & " and suc_estado = 1 "
			sql3 = sql3 & " order by suc_nombre "
			set rs3 = db.execute(sql3)
			if not rs3.eof then
				datosSucursal = rs3.GetRows()
			end if
			for y=0 to ubound(datosSucursal,2)
				idSucursal = trim(datosSucursal(0,y))
				nombreSucursal = server.htmlencode(trim(datosSucursal(1,y)))%>
				<tr class="oculto <%=idZonal%>" id="trSucursal<%=idSucursal%>">
					<td>
						<span class="nombreSucursal" data-idSucursal="<%=idSucursal%>">
							<%=nombreSucursal%>
						</span>
						<span id="botonAbreSucursal<%=idSucursal%>" data-idSucursal="<%=idSucursal%>"></span>
						<span id="enviaDatosSucursal<%=idSucursal%>" class="oculto"></span>
						<span id="sucursalAbierta<%=idSucursal%>" class="oculto pull-right"></span>
					</td>
					<td>
						<div id="detallePorcentajeDocSucursal<%=idSucursal%>">
							<img src="img/loading.gif">
						</div>
					</td>
					<td>
						<div id="detallePorcentajeContSucursal<%=idSucursal%>"></div>
					</td>
					<td>
						<div id="detallePorcentajeAdmSucursal<%=idSucursal%>"></div>
					</td>
					<td>
						<div id="detalleAperturaGer<%=idSucursal%>"></div>
					</td>
					<td>
						<div id="situacionSucursal<%=idSucursal%>"></div>
					</td>
					<td>
						<div id="cajerosSucursalP<%=idSucursal%>"></div>
                    </td>
                    <td>
						<div id="cajerosSucursalA<%=idSucursal%>"></div>
					</td>
                    <td>
                    	<div id="cajerosSucursalSR<%=idSucursal%>"></div>
                    </td>
					<td>
						<div id="guardiasSucursal<%=idSucursal%>"></div>
					</td>
				</tr>
			<%next%>
		<%next%>
	</tbody>
</table>
<script type="text/javascript" src="js/control.js"></script>
<script type="text/javascript">
loadData();
$(function () {
	$('.ayuda').tooltip();
});
</script>