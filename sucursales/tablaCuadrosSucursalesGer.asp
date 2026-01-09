<!--#include file="../funciones.asp"-->
<%idRegional = trim(request("idRegional"))
idZonal = trim(request("idZonal"))
sql = ""
sql = sql & " select y.id_zonal, "
sql = sql & " y.id_regional_p, "
sql = sql & " y.id_sucursal, "
sql = sql & " y.suc_nombre, "
sql = sql & " y.suc_jeps, "
sql = sql & " sum(y.gest_admin_ok) as gest_admin_ok, "
sql = sql & " sum(y.gest_admin_nok) as gest_admin_nok, "
sql = sql & " left(((cast(sum(y.gest_admin_ok) as float))/(cast(sum(y.gest_admin_ok)+sum(y.gest_admin_nok) as float))*100),4) as porct_admin, "
sql = sql & " sum(y.gest_cont_ok) as gest_cont_ok, "
sql = sql & " sum(y.gest_cont_nok) as gest_cont_nok, "
sql = sql & " ((cast(sum(y.gest_cont_ok) as float))/(cast(sum(y.gest_cont_ok)+sum(y.gest_cont_nok) as float))*100) as porct_gest, "
sql = sql & " sum(y.gest_doc_ok) as gest_doc_ok, "
sql = sql & " sum(y.gest_doc_nok) as gest_doc_nok, "
sql = sql & " ((cast(sum(y.gest_doc_ok) as float))/(cast(sum(y.gest_doc_ok)+sum(y.gest_doc_nok) as float))*100) as porct_doc "
sql = sql & " from ( select "
sql = sql & " z.id_zonal, "
sql = sql & " z.id_regional_p, "
sql = sql & " z.id_sucursal, "
sql = sql & " z.suc_nombre, "
sql = sql & " z.suc_jeps, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_admin x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_admin_estado = 1) as gest_admin_ok, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_admin x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_admin_estado = 0) as gest_admin_nok, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_cont x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_cont_estado = 1) as gest_cont_ok, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_cont x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_cont_estado = 0) as gest_cont_nok, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_doc x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_doc_estado = 1) as gest_doc_ok, "
sql = sql & " (select count(*) "
sql = sql & " from SUC_gest_doc x "
sql = sql & " where x.fecha_operacion = z.fecha "
sql = sql & " and x.id_sucursal = z.id_sucursal "
sql = sql & " and gest_doc_estado = 0) as gest_doc_nok "
sql = sql & " from ( select a.id_zonal, "
sql = sql & " a.id_regional_p, "
sql = sql & " c.id_sucursal, "
sql = sql & " c.suc_nombre, "
sql = sql & " c.suc_jeps, "
sql = sql & " cast(getdate() as date) as fecha "
sql = sql & " from SUC_zonales a "
sql = sql & " inner join SUC_zonales_sucursal b "
sql = sql & " on a.id_usuario = b.id_zonal "
sql = sql & " and a.estado_zonal = 1 "
sql = sql & " inner join SUC_sucursal c "
sql = sql & " on b.id_sucursal = c.id_sucursal "
sql = sql & " ) as z ) as y where y.id_regional_p = '"&idRegional&"' "
sql = sql & " and y.id_zonal = '"&idZonal&"' "
sql = sql & " group by y.id_zonal, "
sql = sql & " y.id_regional_p, "
sql = sql & " y.id_sucursal, "
sql = sql & " y.suc_nombre, "
sql = sql & " y.suc_jeps "
set rs = db.execute(sql)
if not rs.eof then
	datosSucursales = rs.GetRows()
end if%>

<table class="table table-bordered table-hover table-condensed" id="tablaDatosSucursalesGerZon<%=idZonal%>Reg<%=idRegional%>">
	<thead>
		<tr>
			<th>
				Nombre Sucursal
			</th>
			<th>
				Jeps
			</th>
			<th colspan="3" class="textoCentrado">
				Gestion Administrativa
			</th>
			<th colspan="3" class="textoCentrado">
				Gestion Contable
			</th>
			<th colspan="3" class="textoCentrado">
				Gestion Documental
			</th>
		</tr>
		<tr>
			<th colspan="2"></th>
			<th>
				Total terminadas
			</th>
			<th>
				Total activas
			</th>
			<th>
				Cumplimiento
			</th>
			<th>
				Total terminadas
			</th>
			<th>
				Total activas
			</th>
			<th>
				Cumplimiento
			</th>
			<th>
				Total terminadas
			</th>
			<th>
				Total activas
			</th>
			<th>
				Cumplimiento
			</th>
		</tr>
	</thead>
	<tbody>
		<%for i = 0 to ubound(datosSucursales,2)
			idZonal = trim(datosSucursales(0,i))
			idRegional = trim(datosSucursales(1,i))
			idSucursal = trim(datosSucursales(2,i))
			nombreSucursal = server.htmlencode(trim(datosSucursales(3,i)))
			nombreJeps = server.htmlencode(trim(datosSucursales(4,i)))
			gestAdminOk = trim(datosSucursales(5,i))
			gestAdminNok = trim(datosSucursales(6,i))
			porctAdmin = replace(trim(datosSucursales(7,i)),".",",")
			gestContOk = trim(datosSucursales(8,i))
			gestContNok = trim(datosSucursales(9,i))
			porctCont = replace(trim(datosSucursales(10,i)),".",",")
			gestDocOk = trim(datosSucursales(11,i))
			gestDocNok = trim(datosSucursales(12,i))
			porctDoc = replace(trim(datosSucursales(13,i)),".",",")
			%>
			<tr>
				<td>
					<%=nombreSucursal%>
				</td>
				<td>
					<%=nombreJeps%>
				</td>
				<td>
					<%=gestAdminOk%>
				</td>
				<td>
					<%=gestAdminNok%>
				</td>
				<td>
					<%=porctAdmin%>%
				</td>
				<td>
					<%=gestContOk%>
				</td>
				<td>
					<%=gestContNok%>
				</td>
				<td>
					<%=porctCont%>%
				</td>
				<td>
					<%=gestDocOk%>
				</td>
				<td>
					<%=gestDocNok%>
				</td>
				<td>
					<%=porctDoc%>%
				</td>
			</tr>
		<%next%>
	</tbody>
</table>
<script type="text/javascript">
$('#tablaDatosSucursalesGerZon<%=idZonal%>Reg<%=idRegional%>').dataTable( {
	"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
	"sPaginationType": "bootstrap",
	/*"oLanguage": {
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
	}*/
});
</script>