<!--#include file="../funciones.asp"-->
<%
idUsuario = trim(request("idUsuarioMain"))
idSucursal = trim(request("idSucursal"))
FechaActual =  date()
diaActual = Day(FechaActual) 
mesActual = Month(FechaActual)
anioActual = Year(FechaActual)
muestraIncidencias = trim(request("muestraIncidencias"))
perfil = trim(request("perfilMain"))
puedeCerrar = "0"
if perfil = "2" or perfil = "55" or perfil = "66" then 
	puedeCerrar = "1"
end if

if muestraIncidencias = "" then muestraIncidencias = "0"
	if perfil = "1" then
		sql = ""
		sql = sql & " select a.id_gest_inc, "
		sql = sql & " a.id_gest_inc_tipo, "
		sql = sql & " b.gest_inc_tipo, "
		sql = sql & " gest_inc_estado, "
		sql = sql & " gest_inc_obs, "
		sql = sql & " cast(ingreso_fecha as datetime) as fechaRegistro , "
		sql = sql & " ticket, "
		sql = sql & " subtipo, "
		sql = sql & " id_gest_inc_subtipo "
		if muestraIncidencias <> "0" then
			sql = sql & " ,cierra_usuario "
		end if
		sql = sql & " from SUC_gest_inc a, "
		sql = sql & " SUC_gest_inc_tipo b "
		sql = sql & " where a.id_gest_inc_tipo = b.id_gest_inc_tipo "
		if muestraIncidencias = "0" then
			sql = sql & " and gest_inc_estado = 0 "
		else
			sql = sql & " and gest_inc_estado <> 0 "
		end if
		sql = sql & " and id_sucursal in ( "
		sql = sql & " select id_sucursal "
		sql = sql & " from SUC_usuario_sucursal "
		sql = sql & " where id_usuario = '"&idUsuario&"') "
		sql = sql & " order by fechaRegistro desc "
	end if
	if perfil = "2" then 
		sql = ""
		sql = sql & " select a.id_gest_inc, "
		sql = sql & " a.id_gest_inc_tipo, "
		sql = sql & " b.gest_inc_tipo, gest_inc_estado, "
		sql = sql & " gest_inc_obs, "
		sql = sql & " cast(ingreso_fecha as datetime) as fechaRegistro , "
		sql = sql & " suc_nombre, "
		sql = sql & " ticket, "
		sql = sql & " subtipo, "
		sql = sql & " id_gest_inc_subtipo "
		if muestraIncidencias <> "0" then
			sql = sql & " ,cierra_usuario "
		else
			sql = sql & ", ingreso_id_usuario "
		end if

		sql = sql & " from SUC_gest_inc a, "
		sql = sql & " SUC_gest_inc_tipo b, "
		sql = sql & " SUC_sucursal c "
		sql = sql & " where a.id_gest_inc_tipo = b.id_gest_inc_tipo "
		sql = sql & " and a.id_sucursal = c.id_sucursal "
		sql = sql & " and a.id_sucursal in ( "
		sql = sql & " select id_sucursal "
		sql = sql & " from SUC_zonales_sucursal "
		sql = sql & " where id_zonal = '"&idUsuario&"' ) "
		if muestraIncidencias = "0" then
			sql = sql & " and gest_inc_estado = 0 "
		else
			sql = sql & " and gest_inc_estado <> 0 "
		end if
		sql = sql & " order by fechaRegistro desc "
	end if
	if perfil = "3" or perfil = "4" then
		sql = ""
		sql = sql & " select a.id_gest_inc, "
		sql = sql & " a.id_gest_inc_tipo, "
		sql = sql & " b.gest_inc_tipo, gest_inc_estado, "
		sql = sql & " gest_inc_obs, "
		sql = sql & " cast(ingreso_fecha as datetime) as fechaRegistro , "
		sql = sql & " suc_nombre, "
		sql = sql & " ticket, "
		sql = sql & " subtipo, "
		sql = sql & " id_gest_inc_subtipo "
		if muestraIncidencias <> "0" then
			sql = sql & " ,cierra_usuario "
		else
			sql = sql & ", ingreso_id_usuario "
		end if
		sql = sql & " from SUC_gest_inc a, "
		sql = sql & " SUC_gest_inc_tipo b, "
		sql = sql & " SUC_sucursal c "
		sql = sql & " where a.id_gest_inc_tipo = b.id_gest_inc_tipo "
		sql = sql & " and a.id_sucursal = c.id_sucursal "
		if muestraIncidencias = "0" then
			sql = sql & " and gest_inc_estado = 0 "
		else
			sql = sql & " and gest_inc_estado <> 0 "
		end if
		sql = sql & " order by fechaRegistro desc "
	end if
	if perfil = "55" then
		sql = ""
		sql = sql & " select a.id_gest_inc, "
		sql = sql & " a.id_gest_inc_tipo, "
		sql = sql & " b.gest_inc_tipo, gest_inc_estado, "
		sql = sql & " gest_inc_obs, "
		sql = sql & " cast(ingreso_fecha as datetime) as fechaRegistro , "
		sql = sql & " suc_nombre, "
		sql = sql & " ticket, "
		sql = sql & " subtipo, "
		sql = sql & " id_gest_inc_subtipo "
		if muestraIncidencias <> "0" then
			sql = sql & " ,cierra_usuario "
		else
			sql = sql & ", ingreso_id_usuario "
		end if
		sql = sql & " from SUC_gest_inc a, "
		sql = sql & " SUC_gest_inc_tipo b, "
		sql = sql & " SUC_sucursal c "
		sql = sql & " where a.id_gest_inc_tipo = b.id_gest_inc_tipo "
		sql = sql & " and a.id_sucursal = c.id_sucursal "
		sql = sql & " and a.id_sucursal in ( "
		sql = sql & " select id_sucursal "
		sql = sql & " from SUC_zonales_comercial_sucursal "
		sql = sql & " where id_zonal = '"&idUsuario&"' ) "
		if muestraIncidencias = "0" then
			sql = sql & " and gest_inc_estado = 0 "
		else
			sql = sql & " and gest_inc_estado <> 0 "
		end if
		sql = sql & " order by fechaRegistro desc "
	end if
	if perfil = "66" then
		sql = ""
		sql = sql & " select a.id_gest_inc, "
		sql = sql & " a.id_gest_inc_tipo, "
		sql = sql & " b.gest_inc_tipo, gest_inc_estado, "
		sql = sql & " gest_inc_obs, "
		sql = sql & " cast(ingreso_fecha as datetime) as fechaRegistro , "
		sql = sql & " suc_nombre, "
		sql = sql & " ticket, "
		sql = sql & " subtipo, "
		sql = sql & " id_gest_inc_subtipo "
		if muestraIncidencias <> "0" then
			sql = sql & " ,cierra_usuario "
		else
			sql = sql & ", ingreso_id_usuario "
		end if
		sql = sql & " from SUC_gest_inc a, "
		sql = sql & " SUC_gest_inc_tipo b, "
		sql = sql & " SUC_sucursal c "
		sql = sql & " where a.id_gest_inc_tipo = b.id_gest_inc_tipo "
		sql = sql & " and a.id_sucursal = c.id_sucursal "
		sql = sql & " and a.id_sucursal in ( "
		sql = sql & " select id_sucursal "
		sql = sql & " from SUC_zonales_comercial_mas_sucursal "
		sql = sql & " where id_zonal = '"&idUsuario&"' ) "
		if muestraIncidencias = "0" then
			sql = sql & " and gest_inc_estado = 0 "
		else
			sql = sql & " and gest_inc_estado <> 0 "
		end if
		sql = sql & " order by fechaRegistro desc "
	end if
	set rs = db.execute(sql)
	if not rs.eof then
	datos = rs.GetRows()%>
<div class="row-fluid">
	<div class="span12">
		<table cellpadding="0" cellspacing="0" border="0" class="table table-striped table-bordered" id="tablaIncidencia">
			<thead>
				<tr>	
					<th>Tipo de gestión</th>
					<th>Observación</th>
					<th id="fechaR">Fecha de registro</th>
					<%if perfil <> "1" then%>
						<th>Sucursal</th>
					<%end if%>
					<th>Estado</th>
					<%if muestraIncidencias = "0" and puedeCerrar = "1" then %>
						<th>Cambiar Estado</th>
					<%end if%>
					<th>Ticket</th>
					<%if muestraIncidencias <> "0"  then%>
						<th>Cerrado por</th>
					<%else%>
						<%if perfil <> "1" then%>
							<th>Ingresado por</th>
						<%end if%>
					<%end if%>	
				</tr>
			</thead>
			<tbody>
				<%for i = 0 to ubound(datos, 2)
					idGestion = trim(datos(0,i))
					idTipo = trim(datos(1,i))
					nombreTipo = server.htmlencode(trim(datos(2,i)))
					observacion = trim(datos(4,i))
					fechaCompleta = cdate(trim(datos(5,i)))
					estado = trim(datos(3,i))
					ticket = ""
					if perfil <> "1" then
						nombreSucursal = server.htmlencode(trim(datos(6,i)))
						ticket = trim(datos(7,i))
						subTipo = trim(datos(8,i))
						tipoSubtipo = trim(datos(9,i))
					else
						ticket = trim(datos(6,i))
						subTipo = trim(datos(7,i))
						tipoSubtipo = trim(datos(9,i))
					end if
					if muestraIncidencias <> "0" then
						usuarioCierra = trim(datos(10,i))
					else
						if perfil <> "1" then
							usuarioAbre = trim(datos(10,i))
						end if
					end if

					if estado ="0" then
						textoEstado="Activo"
					end if
					if estado ="1" then
						textoEstado="Inactivo"
					end if
					if estado ="2" then
						textoEstado="Eliminado por error"
					end if
					if estado ="3" then
						textoEstado="Cerrado"
					end if
					nombreSubTipo = ""
					if subTipo ="1" then
						sql2 = ""
						sql2 = sql2 & " select  "
						sql2 = sql2 & " gest_inc_subtipo "
						sql2 = sql2 & " from SUC_gest_inc_subtipo "
						sql2 = sql2 & " where id_gest_inc_tipo = '"&idTipo&"' "
						sql2 = sql2 & " and  id_gest_inc_subtipo = '"&tipoSubtipo&"'"
						sql2 = sql2 & " order by gest_inc_subtipo"
						set rs2 = db.execute(sql2)
						if not rs2.eof then
							nombreSubTipo = trim(rs2(0))
						end if
						claseSubtipo = ""
							if nombreSubTipo = "MEDIA" then
								claseSubtipo = "warning"
							end if
							if nombreSubTipo = "ALTA" then
								claseSubtipo = "success2"
							end if
							if nombreSubTipo = "INFORMATIVA" then
								claseSubtipo = "info"
							end if
						else
							claseSubtipo = ""
					end if%>
					<tr id="<%=idGestion%>" class="<%=claseSubtipo%>">
						<td class="tipo" id="<%=idGestion%>">
							<%response.write(nombreTipo)
							if subtipo = "1" then
								response.write("   -   "&nombreSubTipo)
							end if%>
						</td>
						<td class="observacion" id="<%=idGestion%>">
							<%=observacion%>
						</td>
						<td class="fecha" id="<%=idGestion%>">
							<%=fechaCompleta%>
						</td>
						<%if perfil <> "1" then%>
							<td class="sucursal" id="<%=idGestion%>">
								<%=nombreSucursal%>
							</td>
						<%end if%>
						<td class="estado" id="estado<%=idGestion%>" >
							<%=textoEstado%> 
						</td>
						<%if muestraIncidencias = "0" and puedeCerrar = "1" then %>
							<td class="cambiaEstadoGestion" id="<%=idGestion%>" data-idGestion="<%=idGestion%>">
								<div id="divCambiaEstadoGestion" data-idGestion="<%=idGestion%>" class="<%=idGestion%> mano divCambiaEstadoGestion">
									<span class="btn btn-mini btn-success botonCambiaEstadoIncidencia" data-idGestion="<%=idGestion%>">
										<i class="icon-wrench"></i>
									</span>
								</div>
							</td>
						<%end if%>	
						<td class="ticket" id="<%=idGestion%>"><%=ticket%></td>
						<%if muestraIncidencias <> "0" then%>
							<td>
								<%if usuarioCierra <> "" then
									sql2 = ""
									sql2 = sql2 & "select u_nombres+' '+u_apellidos "
									sql2 = sql2 & " from suc_usuario where id_usuario = '"&usuarioCierra&"'" 
									set rs2 = db.execute(sql2)
									if not rs2.eof then
										response.write(server.htmlencode(trim(rs2(0))))
									end if
								else
									response.write("-")
								end if%>
							</td>
						<%else
							if perfil <> "1" then%>
								<td>
									<%sql2 = ""
									sql2 = sql2 & "select u_nombres+' '+u_apellidos "
									sql2 = sql2 & " from suc_usuario where id_usuario = '"&usuarioAbre&"'" 
									set rs2 = db.execute(sql2)
									if not rs2.eof then
										response.write(server.htmlencode(trim(rs2(0))))
									end if
							else
									response.write("-")%>
								</td>
							<%end if
						end if%>
					</tr>
				<%next%>
			</tbody>
		</table>
	</div>
</div>
<%else%>
	<div class="row-fluid">
		<div class="alert alert-success span3 offset4 text-center">
			No existen incidencias
		</div>
	</div>
<%end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
DB.Close
set DB=nothing%>
<link href="css/tablaSort.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="js/incidencias.js"></script>
<script type="text/javascript" src="js/jquery.dataTables.js"></script>
<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>
<script type="text/javascript">
$(function(){
	$('#tablaIncidencia').dataTable( {
		"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
		"sPaginationType": "bootstrap",
		"oLanguage": {
			"sLengthMenu": "_MENU_ registros por página",
			"sProcessing":     "Procesando...",
		    "sZeroRecords":    "No se encontraron resultados",
		    "sEmptyTable":     "Ningún dato disponible en esta tabla",
		    "sInfo":           "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
		    "sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
		    "sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
		    "sInfoPostFix":    "",
		    "sSearch":         "Buscar:",
		    "sUrl":            "",
		    "sInfoThousands":  ",",
		    "sLoadingRecords": "Cargando...",
		    "oPaginate": {
		        "sFirst":    "Primero",
		        "sLast":     "Último",
		        "sNext":     "Siguiente",
		        "sPrevious": "Anterior"
		    },
		    "oAria": {
		        "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
		        "sSortDescending": ": Activar para ordenar la columna de manera descendente"
		    }
		},
	});
});
</script>