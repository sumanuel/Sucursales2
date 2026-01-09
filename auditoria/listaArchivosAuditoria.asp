<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
sql = ""
sql = sql & " select id_auditoria, "
sql = sql & " archivo, "
sql = sql & " fecha_auditoria, "
sql = sql & " observacion, "
sql = sql & " evaluacion, "
sql = sql & " puntaje "
sql = sql & " from SUC_sucursal_auditoria a, "
sql = sql & " SUC_sucursal b "
sql = sql & " where a.id_sucursal = b.id_sucursal "
sql = sql & " and a.id_sucursal = '"&idSucursal&"' "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()%>
	<div class="row-fluid">
		<div class="span12">
			<table class="table table-bordered table-hover" id="tablaListaArchivos">
				<thead>
					<tr>
						<th>Observación</th>
						<th>Evaluación</th>
						<th>Puntaje</th>
						<th>Fecha de auditoría</th>
						<th>Archivo</th>
					</tr>
				</thead>
				<tbody>
				<%for i = 0 to ubound(datos,2)
					idAuditoria = trim(datos(0,i))
					archivo = trim(datos(1,i))
					fechaAuditoria = fechaDMY(trim(datos(2,i)))
					observacion = server.htmlencode(trim(datos(3,i)))
					evaluacion = trim(datos(4,i))
					if evaluacion = "1" then
						textoEvaluacion = "Satisfactorio"
					end if
					if evaluacion = "2" then
						textoEvaluacion = "Insatisfactorio"
					end if
					puntaje = trim(datos(5,i))%>
					<tr>
						<td><%=observacion%></td>
						<td><%=textoEvaluacion%></td>
						<td><%=puntaje%></td>
						<td><%=fechaAuditoria%></td>
						<td>
							<span class="icon-stack icon-large mano descargaArchivo" data-descarga="<%=archivo%>">
								<i class="icon-check-empty icon-stack-base"></i>
								<i class="icon-download-alt"></i>
							</span>
						</td>
					</tr>
				<%next%>
				</tbody>
			</table>
		</div>
	</div>
<%else%>
	<div class="row-fluid">
		<div class="span12">
			La sucursal no tiene datos
		</div>
	</div>
<%end if%>
<script type="text/javascript" src="js/jquery.dataTables.js"></script>
<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>
<script type="text/javascript">
$(function(){
	$('#tablaListaArchivos').dataTable( {
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
$('.descargaArchivo').click(function(e){
  e.preventDefault();
  var archivo = $(this).attr('data-descarga');
  window.open('auditoria/archivos/<%=idSucursal%>/'+archivo,'_blank');
});
</script>