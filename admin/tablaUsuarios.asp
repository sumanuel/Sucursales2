<!--#include file="../funciones.asp"-->
<div class="row-fluid">
	<div class="span12" id="tablaUsuarios">
		<table cellpadding="0" cellspacing="0" border="0" class="table table-striped table-bordered" id="tablaDatosUsuarios">
			<thead>
				<tr>
					<th>Rut</th>
					<th>Nombre</th>
					<th>Apellido Paterno</th>
					<th>Apellido Materno</th>
					<th>Acciones</th>
				</tr>
			</thead>
			<tbody>
				<%sql = ""
				sql = sql & " select id_usuario, "
				sql = sql & " usuario_rut, "
				sql = sql & " usuario_dv, "
				sql = sql & " nombre, "
				sql = sql & " apellido_paterno, "
				sql = sql & " apellido_materno, "
				sql = sql & " usuario_estado "
				sql = sql & " from  SUC_m_usuarios "
				set rs = db.execute(sql)
				if not rs.eof then
					datos = rs.GetRows()
					for i=0 to ubound(datos,2)
						idUsuario = trim(datos(0,i))
						rutUsuario = trim(datos(1,i))&"-"&trim(datos(2,i))

						nombre = server.htmlencode(trim(datos(3,i)))
						appPat = server.htmlencode(trim(datos(4,i)))
						appMat = server.htmlencode(trim(datos(5,i)))
						estadoUsuario = trim(datos(6,i))%>	
						<tr>
							<td><%=rutUsuario%></td>
							<td><%=nombre%></td>
							<td><%=appPat%></td>
							<td><%=appMat%></td>
							<td>
								<span id="<%=idUsuario%>" class="modificaUsuario mano badge badge-info">
									<i class="icon-edit"></i> Modificar
								</span>
								<span id="<%=idUsuario%>" class="eliminaUsuario mano badge badge-important">
									<i class="icon-trash"></i>
								</span>
							</td>
						</tr>
					<%next
				end if%>
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
$(function(){

})
/* Table initialisation */
$(document).ready(function() {
	$('#tablaDatosUsuarios').dataTable( {
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

	} );
} );
$('.modificaUsuario').click(function(){
	var idUsuario = $(this).attr('id');
	$('#tablaUsuarios, #botonCreaUsuario').slideUp('slow');

	var pagina = 'modificaUsuario.asp';
	var div = 'registroUsuarios';
	var datos='idUsuario='+idUsuario;
	try{
		enviaDatos(pagina,div,datos);
		}
	catch(err){}
});

$('.eliminaUsuario').click(function(){
	var idUsuario = $(this).attr('id');
});
</script>
