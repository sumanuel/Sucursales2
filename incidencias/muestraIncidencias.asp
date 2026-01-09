<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursalMain"))
FechaActual =  date()
diaActual = Day(FechaActual) 
mesActual = Month(FechaActual)
anioActual = Year(FechaActual) 
sql = ""
sql = sql & " select a.id_gest_inc, "
sql = sql & " a.id_gest_inc_tipo, "
sql = sql & " b.gest_inc_tipo, "
sql = sql & " gest_inc_estado, "
sql = sql & " gest_inc_obs, "
sql = sql & " ticket, "
sql = sql & " cast(ingreso_fecha as datetime) as fechaRegistro, "
sql = sql & " subtipo, "
sql = sql & " id_gest_inc_subtipo "
sql = sql & " from SUC_gest_inc a, "
sql = sql & " SUC_gest_inc_tipo b "
sql = sql & " where a.id_gest_inc_tipo = b.id_gest_inc_tipo "
sql = sql & " and a.id_sucursal = '"&idSucursal&"' "
set rs = db.execute(sql)%>
<div class="row-fluid">
	<div class="span12">
		<span class="btn btn-success registraNuevaIncidencia">Registrar incidencia</span>
	</div>
</div>
<div class="row-fluid oculto" id="nuevaIncidenciaDiv">
	<div id="nuevaIncidencia" class="well span12"></div>
</div>
<div class="row-fluid">
	<div class="span12">
		<%if not rs.eof then%>
			<table class="table table-bordered table-hover" id="tablaIncidencia">
				<thead>
					<tr>
						<th>Tipo de gestión</th>
						<th>Observación</th>
						<th>Ticket</th>
						<th>Fecha de registro</th>
						<th>Estado</th>
					</tr>
				</thead>
				<tbody>
					<%do while not rs.eof
						idGestion = trim(rs("id_gest_inc"))
						nombreTipo = server.htmlencode(trim(rs("gest_inc_tipo")))
						observacion = server.htmlencode(trim(rs("gest_inc_obs")))
						fechaCompleta = cdate(trim(rs("fechaRegistro")))
						ticket = trim(rs("ticket"))
						'fechaRegistro = Day(fechaCompleta)&"/"&(m,fechaCompleta)&"/"&DatePart(yyyy,fechaCompleta)
						estado = trim(rs("gest_inc_estado"))
						subtipo = "0"
						subtipo = trim(rs("subtipo"))
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
						if subtipo = "1" then
							sql2 = ""
							sql2 = sql2 & " select  "
							sql2 = sql2 & " gest_inc_subtipo "
							sql2 = sql2 & " from SUC_gest_inc_subtipo "
							sql2 = sql2 & " where id_gest_inc_tipo = '"&trim(rs("id_gest_inc_tipo"))&"' "
							sql2 = sql2 & " and  id_gest_inc_subtipo = '"&trim(rs("id_gest_inc_subtipo"))&"'"
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
						end if
						%>
					<tr>
						<td class="tipo <%=claseSubtipo%>" id="<%=idGestion%>">
							<%response.write(nombreTipo)
							if subtipo = "1" then
								response.write("   -   "&nombreSubTipo)
							end if%>
						</td>
						<td class="observacion" id="<%=idGestion%>"><%=observacion%></td>
						<td class="ticket" id="<%=idGestion%>"><%=ticket%></td>
						<td class="fecha" id="<%=idGestion%>"><%=fechaCompleta%></td>
						<td class="estado" id="estado<%=idGestion%>" >
							<%=textoEstado%> 
						</td>
					</tr>
						<%rs.movenext
					loop%>
				</tbody>
			</table>
		<%else%>
			<div class="alert alert-success"> No registra incidencias</div>
		<%end if
		rs.Close
		set rs.ActiveConnection = nothing
		set rs=nothing
		DB.Close
		set DB=nothing%>		
	</div>
</div>
<link href="css/tablaSort.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="js/jquery.dataTables.js"></script>
<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>
<script type="text/javascript">
var pagina,div,datos
$(function(){
	$('#tablaIncidencia').dataTable( {
		"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
		"sPaginationType": "bootstrap",
		"aaSorting": [[2,'desc']],// "aoColumnDefs": [ { "sType": "date-eu", "aTargets": [ 2 ] } ],
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
$('.registraNuevaIncidencia').click(function(){
	$(this).addClass('oculto');
	$('#nuevaIncidenciaDiv').removeClass('oculto');
	pagina = 'incidencias/nuevaIncidencia.asp';
	div = 'nuevaIncidencia';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
});
/*$('.estado').on('mouseover',function(){
	$(this).find('span').removeClass('oculto').addClass('mano');
}).on('mouseout',function(){
	$(this).find('span').addClass('oculto');
});
$('.eliminaIncidencia').on('click',function(){
	var idGestion = $(this).attr('data-id');
	$('#estado'+idGestion).text('Eliminado por error');
});*/
</script>