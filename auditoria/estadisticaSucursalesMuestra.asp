<!--#include file="../funciones.asp"-->
<%tipo = trim(request("tipo"))
tiene = trim(request("tiene"))
if tipo = "1" then
	if tiene = "1" then
		sql = ""
		sql = sql & " select id_auditoria, "
		sql = sql & " a.id_sucursal, "
		sql = sql & " b.suc_nombre, "
		sql = sql & " b.suc_jeps_short, "
		sql = sql & " b.suc_zonal, "
		sql = sql & " a.archivo, "
		sql = sql & " a.fecha_auditoria "
		sql = sql & " from SUC_sucursal_auditoria a "
		sql = sql & " inner join SUC_sucursal b on "
		sql = sql & " a.id_sucursal = b.id_sucursal "
		sql = sql & " where fecha_auditoria = "
		sql = sql & " (select max(distinct fecha_auditoria ) "
		sql = sql & " from SUC_sucursal_auditoria b "
		sql = sql & " where a.id_sucursal = b.id_sucursal) "
	end if
	if tiene="0" then
		sql = ""
		sql = sql & " select id_sucursal, "
		sql = sql & " suc_nombre, "
		sql = sql & " suc_jeps, "
		sql = sql & " suc_zonal "
		sql = sql & " from SUC_sucursal "
		sql = sql & " where id_sucursal not in ( "
		sql = sql & " select id_sucursal "
		sql = sql & " from SUC_sucursal_auditoria a "
		sql = sql & " where fecha_auditoria = "
		sql = sql & " (select max(distinct fecha_auditoria ) "
		sql = sql & " from SUC_sucursal_auditoria b "
		sql = sql & " where a.id_sucursal = b.id_sucursal)) "
		sql = sql & " and suc_estado = 1 "
		sql = sql & " order by suc_zonal, suc_nombre "
	end if
	set rs = db.execute(sql)
  	if not rs.eof then
    	datos = rs.GetRows()%>
	<table class="table table-bordered table-hover" id="tablaDatos">
		<thead>
			<tr>
				<th>Nombre Suc</th>
				<th>Zonal</th>
				<th>Jeps</th>
				<%if tiene= "1" then %>
					<th>Fecha Auditoría</th>
					<th>Archivo</th>
				<%end if%>
			</tr>
		</thead>
		<tbody>
			<%for i = 0 to ubound(datos,2)
				if tiene= "1" then
					idAuditoria = trim(datos(0,i))
					idSucursal = trim(datos(1,i))
					nombreSucursal = server.htmlencode(trim(datos(2,i)))
					nombreJeps = server.htmlencode(trim(datos(3,i)))
					nombreZonal = server.htmlencode(trim(datos(4,i)))
					archivo = trim(datos(5,i))
					fechaAuditoria = cdate(trim(datos(6,i)))
				end if
				if tiene = "0" then
					idSucursal = trim(datos(0,i))
					nombreSucursal = server.htmlencode(trim(datos(1,i)))
					nombreJeps = server.htmlencode(trim(datos(2,i)))
					nombreZonal = server.htmlencode(trim(datos(3,i)))
				end if%>
			<tr>
				<td><%=nombreSucursal%></td>
				<td><%=nombreJeps%></td>
				<td><%=nombreZonal%></td>
				<%if tiene= "1" then %>
					<td><%=fechaAuditoria%></td>
					<td>
						<span class="icon-stack icon-large mano descargaArchivo" data-descarga="<%=archivo%>" data-isSucursal="<%=idSucursal%>">
							<i class="icon-check-empty icon-stack-base"></i>
							<i class="icon-download-alt"></i>
						</span>
				<%end if%>
			</tr>
			<%next%>
		</tbody>
	<%end if%>
	</table>
<%end if
if tipo= "2" then
	sql = ""
	sql = sql & " select id_auditoria, "
	sql = sql & " archivo, "
	sql = sql & " fecha_auditoria, "
	sql = sql & " observacion, "
	sql = sql & " puntaje, "
	sql = sql & " a.id_sucursal, "
	sql = sql & " b.suc_nombre, "
	sql = sql & " b.suc_jeps, "
	sql = sql & " b.suc_zonal "
	sql = sql & " from SUC_sucursal_auditoria a "
	sql = sql & " inner join SUC_sucursal b on a.id_sucursal = b.id_sucursal "
	sql = sql & " where fecha_auditoria = "
	sql = sql & " (select max(distinct fecha_auditoria ) "
	sql = sql & " from SUC_sucursal_auditoria b "
	sql = sql & " where a.id_sucursal = b.id_sucursal) "
	if tiene = "1" then
		sql = sql & " and evaluacion = 1 "
	end if
	if tiene = "0" then
		sql = sql & " and evaluacion = 2 "
	end if
	sql = sql & " order by b.suc_nombre "
	set rs = db.execute(sql)
  	if not rs.eof then
    	datos = rs.GetRows()%>
	<table class="table table-bordered table-hover" id="tablaDatos">
    	<thead>
    		<tr>
    			<th>Sucursal</th>
    			<th>Jeps</th>
    			<th>Zonal</th>
    			<th>Fecha</th>
    			<th>Archivo</th>
    			<th>Obervación</th>
    			<th>Puntaje</th>
    		</tr>
    	</thead>
    	<tbody>
    	<%for i = 0 to ubound(datos,2)
    		idAuditoria = trim(datos(0,i))
    		archivo = trim(datos(1,i))
    		fechaAuditoria = cdate(trim(datos(2,i)))
    		observacion = server.htmlencode(trim(datos(3,i)))
    		puntaje = trim(datos(4,i))
    		idSucursal = trim(datos(5,i))
    		nombreSucursal = server.htmlencode(trim(datos(6,i)))
    		nombreJeps = server.htmlencode(trim(datos(7,i)))
    		nombreZonal = server.htmlencode(trim(datos(8,i)))%>
    		<tr>
    			<td><%=nombreSucursal%></td>
    			<td><%=nombreJeps%></td>
    			<td><%=nombreZonal%></td>
    			<td><%=fechaAuditoria%></td>
    			<td>
					<span class="icon-stack icon-large mano descargaArchivo" data-descarga="<%=archivo%>" data-isSucursal="<%=idSucursal%>">
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-download-alt"></i>
					</span>
    			</td>
    			<td><%=observacion%></td>
    			<td><%=puntaje%></td>
    		</tr>
    	<%next%>
    	</tbody>
    </table>
	<%end if
end if%>
<script type="text/javascript" src="js/jquery.dataTables.js"></script>
<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>
<script type="text/javascript">
/* Table initialisation */
$(function(){
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
	});
});
$('.descargaArchivo').click(function(e){
	e.preventDefault();
	var archivo = $(this).attr('data-descarga');
	var idSucursal = $(this).attr('data-isSucursal');
	window.open('auditoria/archivos/'+idSucursal+'/'+archivo,'_blank');
});
</script>