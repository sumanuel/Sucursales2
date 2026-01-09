<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuarioMain"))
idPerfil = trim(request("perfilMain"))
sucursalesAbiaertasFueraPlazo = 0
sucursalesAbiaertasDentroPlazo = 0
sucursalesAbiaertas = 0
tipo=trim(request("tipo"))


if tipo = "4" then
	sql = sql & " where id_sucursal not in ( "
	sql = sql & " select id_sucursal "
	sql = sql & " from SUC_sucursal_apertura "
	sql = sql & " where tipo = 1 and fecha_ingreso = cast(GETDATE() as date)  "
	if idPerfil = "2" then
	  sql = sql & " and id_sucursal in (select id_sucursal "
	  sql = sql & " from SUC_usuario_sucursal "
	  sql = sql & " where id_usuario = '"&idUsuario&"') "
	end if
	if idPerfil = "55" then
		sql = sql & " and id_sucursal in  (select id_sucursal  "
		sql = sql & " from SUC_zonales_comercial_sucursal  where id_zonal = '"&idUsuario&"' ) "
	End if
	if idPerfil = "66" then
		sql = sql & " and id_sucursal in  (select id_sucursal  "
		sql = sql & " from SUC_zonales_comercial_mas_sucursal  where id_zonal = '"&idUsuario&"' ) "
	End if
end if

if tipo = "1" then
	sql = ""
	sql = sql & " select suc_nombre, " 
	sql = sql & " suc_jeps, suc_zonal, "
	sql = sql & " suc_direccion, "
	sql = sql & " suc_jeps_enexo, "
	sql = sql & " suc_jeps_celular, "
	sql = sql & " suc_tipo  "
	sql = sql & " from SUC_sucursal "
	sql = sql & " where id_sucursal in ( select id_sucursal "
	sql = sql & " from SUC_sucursal_apertura "
	sql = sql & " where tipo = 1 "
	sql = sql & " and fecha_ingreso = cast(GETDATE() as date) "
	sql = sql & " and hora_ingreso <= '08:45' "
	sql = sql & " and fecha_ingreso = cast(GETDATE() as date)) "
	if idPerfil = "2" then
		sql = sql & " and id_sucursal in (select id_sucursal "
		sql = sql & " from SUC_usuario_sucursal where id_usuario = '"&idUsuario&"')"
	end if
	if idPerfil = "55" then
		sql = sql & " and id_sucursal in  (select id_sucursal  "
		sql = sql & " from SUC_zonales_comercial_sucursal  where id_zonal = '"&idUsuario&"' ) "
	End if
	if idPerfil = "66" then
		sql = sql & " and id_sucursal in  (select id_sucursal  "
		sql = sql & " from SUC_zonales_comercial_mas_sucursal  where id_zonal = '"&idUsuario&"' ) "
	End if
	sql = sql & " and suc_estado = 1 "
end if

if tipo = "2" then
	sql = ""
	sql = sql & " select suc_nombre, " 
	sql = sql & " suc_jeps, suc_zonal, "
	sql = sql & " suc_direccion, "
	sql = sql & " suc_jeps_enexo, "
	sql = sql & " suc_jeps_celular, "
	sql = sql & " suc_tipo  "
	sql = sql & " from SUC_sucursal "
	sql = sql & " where id_sucursal in ( select id_sucursal "
	sql = sql & " from SUC_sucursal_apertura "
	sql = sql & " where tipo = 1 "
	sql = sql & " and fecha_ingreso = cast(GETDATE() as date) "
	sql = sql & " and hora_ingreso > '08:45' "
	sql = sql & " and fecha_ingreso = cast(GETDATE() as date)) "
	if idPerfil = "2" then
		sql = sql & " and id_sucursal in (select id_sucursal "
		sql = sql & " from SUC_usuario_sucursal where id_usuario = '"&idUsuario&"')"
	end if
	if idPerfil = "55" then
		sql = sql & " and id_sucursal in  (select id_sucursal  "
		sql = sql & " from SUC_zonales_comercial_sucursal  where id_zonal = '"&idUsuario&"' ) "
	End if
	if idPerfil = "66" then
		sql = sql & " and id_sucursal in  (select id_sucursal  "
		sql = sql & " from SUC_zonales_comercial_mas_sucursal  where id_zonal = '"&idUsuario&"' ) "
	End if
	sql = sql & " and suc_estado = 1 "
end if

if tipo = "3" then
	sql = ""
	sql = sql & " select suc_nombre, " 
	sql = sql & " suc_jeps, suc_zonal, "
	sql = sql & " suc_direccion, "
	sql = sql & " suc_jeps_enexo, "
	sql = sql & " suc_jeps_celular, "
	sql = sql & " suc_tipo  "
	sql = sql & " from SUC_sucursal "
	sql = sql & " where id_sucursal in ( select id_sucursal "
	sql = sql & " from SUC_sucursal_apertura "
	sql = sql & " where tipo = 2 "
	sql = sql & " and fecha_ingreso = cast(GETDATE() as date) "
	sql = sql & " and hora_ingreso > '08:45' "
	sql = sql & " and fecha_ingreso = cast(GETDATE() as date)) "
	if idPerfil = "2" then
		sql = sql & " and id_sucursal in (select id_sucursal "
		sql = sql & " from SUC_usuario_sucursal where id_usuario = '"&idUsuario&"')"
	end if
	if idPerfil = "55" then
		sql = sql & " and id_sucursal in  (select id_sucursal  "
		sql = sql & " from SUC_zonales_comercial_sucursal  where id_zonal = '"&idUsuario&"' ) "
	End if
	if idPerfil = "66" then
		sql = sql & " and id_sucursal in  (select id_sucursal  "
		sql = sql & " from SUC_zonales_comercial_mas_sucursal  where id_zonal = '"&idUsuario&"' ) "
	End if
	sql = sql & " and suc_estado = 1 "
end if

if tipo = "4" then
	sql = ""
	sql = sql & " select suc_nombre, "
	sql = sql & " suc_jeps, "
	sql = sql & " suc_zonal, "
	sql = sql & " suc_direccion, "
	sql = sql & " suc_jeps_enexo, "
	sql = sql & " suc_jeps_celular, "
	sql = sql & " suc_tipo "
	sql = sql & " from SUC_sucursal "
	sql = sql & " where id_sucursal not in ( select id_sucursal "
	sql = sql & " from SUC_sucursal_apertura "
	sql = sql & " where fecha_ingreso = cast(GETDATE() as date) "
	sql = sql & " and fecha_ingreso = cast(GETDATE() as date)) "
	if idPerfil = "2" then
		sql = sql & " and id_sucursal in (select id_sucursal "
		sql = sql & " from SUC_usuario_sucursal where id_usuario = '"&idUsuario&"') "
	end if
	if idPerfil = "55" then
		sql = sql & " and id_sucursal in  (select id_sucursal  "
		sql = sql & " from SUC_zonales_comercial_sucursal  where id_zonal = '"&idUsuario&"' ) "
	End if
	if idPerfil = "66" then
		sql = sql & " and id_sucursal in  (select id_sucursal  "
		sql = sql & " from SUC_zonales_comercial_mas_sucursal  where id_zonal = '"&idUsuario&"' ) "
	End if
	sql = sql & " and suc_estado = 1 "
end if

'response.write(sql)
'response.end
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()%>
<div class="row-fluid">
	<div class="span12">
		<table id="tablaInfoSucursal" class="table table-bordered table-condensed">
			<thead>
				<tr>
					<th>Sucursal</th>
					<th>Jeps</th>
					<th>Zonal</th>
					<th>Dirección</th>
					<th>Anexo</th>
					<th>Celular Jeps</th>
					<th>Tipo Sucursal</th>
				</tr>
			</thead>
			<tbody>
				<%For i = 0 to ubound(datos, 2)
					nombreSucursal = server.htmlencode(trim(datos(0,i)))
					jeps = server.htmlencode(trim(datos(1,i)))
					zonal = server.htmlencode(trim(datos(2,i)))
					direccion = server.htmlencode(trim(datos(3,i)))
					anexo = server.htmlencode(trim(datos(4,i)))
					celular = server.htmlencode(trim(datos(5,i)))
					tipoSucursal = server.htmlencode(trim(datos(6,i)))%>
					<tr>
						<td><%=nombreSucursal%></td>
						<td><%=jeps%></td>
						<td><%=zonal%></td>
						<td><%=direccion%></td>
						<td><%=anexo%></td>
						<td><%=celular%></td>
						<td><%=tipoSucursal%></td>
					</tr>
				<%next%>
			</tbody>
		</table>
	</div>
</div>
<link href="css/tablaSort.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="js/jquery.dataTables.js"></script>
	<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>
	<script type="text/javascript">
	$(function(){
		$('#tablaInfoSucursal').dataTable( {
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
<%else%>
	<div class="row-fluid">
		<div class="span4"></div>
		<%if tipo <> "4" then%>
		<div class="span3 alert alert-danger">
			No existen datos
		</div>
		<%end if
		if tipo = "4" then%>
		<div class="span3 alert alert-success">
			<strong>
				Todas las sucursales abiertas <i class="icon-check"></i>
			</strong>
		</div>
		<%end if%>
		<div class="span5"></div>
	</div>
<%end if%>