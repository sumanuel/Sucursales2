<!--#include file="../funciones.asp"-->
<%idZonal = trim(request("idZonal"))
tipo = trim(request("tipo"))
sql=""
sql = sql & " select id_zonal_ppto_gasto, "
sql = sql & " zonal_ppto_gasto_titulo, "
sql = sql & " zonal_ppto_gasto, "
sql = sql & " zonal_ppto_gasto_obs, "
sql = sql & " zonal_ppto_gasto_archivo, "
sql = sql & " zonal_ppto_gasto_mes, "
sql = sql & " zonal_ppto_gasto_ano, "
sql = sql & " zonal_ppto_gasto_fecha "
sql = sql & " from SUC_zonales_ppto_gastos "
sql = sql & " where id_zonal = '"&idZonal&"' "
sql = sql & " and id_zonal_ppto_tipo = '"&tipo&"'"
sql = sql & " and zonal_ppto_gasto_mes = month(GETDATE()) "
sql = sql & " and zonal_ppto_gasto_ano = year(GETDATE()) "

'Response.Write(sql)
'Response.End

set rs = db.execute(sql)
if not rs.eof then
    	datos = rs.GetRows()%>
<div class="row-fluid">
	<div class="span12">
		<table class="table table-bordered table-hover" id="tablaDatos">
			<thead>
				<tr>
					<th>Título</th>
					<th>Gasto</th>
					<th>Observación</th>
					<th>Archivo</th>
					<th>Fecha</th>
				</tr>
			</thead>
			<tbody>
				<%for i = 0 to ubound(datos,2)
					idZonalPptoGasto = trim(datos(0,i))
					titulo=server.htmlencode(trim(datos(1,i)))
					gasto = formatnumber(trim(datos(2,i)),0)
					obs = trim(datos(3,i))
					archivo = trim(datos(4,i))
					fecha=cdate(trim(datos(7,i)))%>
					<tr>
						<td>
							<%=titulo%>
						</td>
						<td>
							<%=gasto%>
						</td>
						<td><%=obs%></td>
						<td>
							<%if archivo <> "" then%>
							<span class="icon-stack icon-large mano descargaArchivo" data-descarga="<%=archivo%>" data-tipo="<%=tipo%>"data-idZonal="<%=idZonal%>">
								<i class="icon-check-empty icon-stack-base"></i>
								<i class="icon-download-alt"></i>
							</span>
							<%end if%>
						</td>
						<td><%=fecha%></td>
					</tr>
				<%next%>
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript" src="js/jquery.dataTables.js"></script>
<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>
<script type="text/javascript">
/* Table initialisation */
$(document).ready(function() {
	$('#tablaDatos').dataTable( {
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
	$('.descargaArchivo').click(function(e){
		e.preventDefault(e);
		var archivo = $(this).attr('data-descarga');
		var idZonal = $(this).attr('data-idZonal');
		var tipo = $(this).attr('data-tipo');
		window.open('gastos/archivos/'+idZonal+'/'+tipo+'/'+archivo,'_blank');
	});
});
</script>
<%end if%>