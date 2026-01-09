<!--#include file="../funciones.asp"-->
<%idRegional = trim(request("idRegional"))
idZonal = trim(request("idZonal"))
idUsuarioZonal = trim(request("idUsuarioZonal"))
sql = ""
sql = sql & " select id_sucursal, "
sql = sql & " suc_jeps, "
sql = sql & " suc_nombre "
sql = sql & " from suc_sucursal "
sql = sql & " where suc_estado = 1 "
sql = sql & " and id_sucursal in "
sql = sql & " (select id_sucursal "
sql = sql & " from SUC_usuario_sucursal "
sql = sql & " where id_usuario = '"&idUsuarioZonal&"') "

set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows
end if%>

<table class="table table-bordered table-hover table-condensed" id="tablaDatosSucursalesCajZon<%=idZonal%>Reg<%=idRegional%>">
	<thead>
		<tr>
			<th>
				Nombre Sucursal
			</th>
			<th>
				Jeps
			</th>
			<th>
				Total cajeros
			</th>
			<th class="textoCentrado">
				Titulares
			</th>
			<th class="textoCentrado">
				Reemplazo
			</th>
			<th class="textoCentrado">
				Adicionales
			</th>
			<th class="textoCentrado">
				Presentes
			</th>
			<th class="textoCentrado">
				Ausentes
			</th>
			
			<th class="textoCentrado">
				Sin registro
			</th>		
		</tr>
	</thead>
	<tbody>
		<%for i = 0 to ubound(datos,2)
		idSucursal = trim(datos(0,i))
		nombreJeps = server.htmlencode(trim(datos(1,i)))
		nombreSucursal = server.htmlencode(trim(datos(2,i)))
		sql2 = ""  
		sql2 = sql2 & " and id_sucursal = '"&idSucursal&"'"
		sql = ""
		sql = sql & "select "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_asistencia_personal "
		sql = sql & " where tipo_personal = 'Cajero' "
		sql = sql & " and tipo = 'titular' "&sql2&") as cajerostitulares, "
		sql = sql & " (select COUNT(*) " 
		sql = sql & " from SUC_sucursal_asistencia_personal "
		sql = sql & " where tipo_personal = 'Cajero' "
		sql = sql & " and tipo = 'reemplazo' "&sql2&") as cajerosreemplazos, "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_asistencia_personal "
		sql = sql & " where tipo_personal = 'CAJERO ADICIONAL' "&sql2&") as cajerosadicionales, "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_asistencia_personal "
		sql = sql & " where tipo_personal in ('Cajero','CAJERO ADICIONAL') "
		sql = sql & " and asistencia = 'si' "&sql2&") as cajerospresentes, "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_asistencia_personal "
		sql = sql & " where tipo_personal in ('Cajero','CAJERO ADICIONAL') "
		sql = sql & " and asistencia = 'no' "&sql2&") as cajerosausentes, "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal_asistencia_personal "
		sql = sql & " where tipo_personal in ('Cajero','CAJERO ADICIONAL') "
		sql = sql & " and asistencia is null "&sql2&") as cajerossinregistro, "
		sql = sql & " ((select COUNT(*) "
		sql = sql & " from SUC_sucursal_asistencia_personal "
		sql = sql & " where tipo='titular' "
		sql = sql & " and tipo_personal = 'cajero' "
		sql = sql & " and asistencia = 'no' "&sql2&") "
		sql = sql & " - (select COUNT(*) "
		sql = sql & " from SUC_sucursal_asistencia_personal "
		sql = sql & " where tipo='reemplazo' "
		sql = sql & " and tipo_personal = 'cajero' "
		sql = sql & " and asistencia = 'si' "&sql2&") "
		sql = sql & " +(select COUNT(*) "
		sql = sql & " from SUC_sucursal_asistencia_personal "
		sql = sql & " where tipo='reemplazo' "
		sql = sql & " and tipo_personal = 'cajero' "
		sql = sql & " and asistencia = 'no' "&sql2&") "
		sql = sql & " +(select COUNT(*) "
		sql = sql & " from SUC_sucursal_asistencia_personal "
		sql = sql & " where tipo='reemplazo' "
		sql = sql & " and tipo_personal = 'cajero adicional' "
		sql = sql & " and asistencia = 'no' "&sql2&")) as cajerosausentes2 "
		'response.write(sql)
		'response.end
		set rs = db.execute(sql)
		if not rs.eof then
			totalCajerosTitulares = rs("cajerostitulares")
			totalCajerosReemplazos = rs("cajerosreemplazos")
			totalCajerosAdicionales = rs("cajerosadicionales")
			totalAusentes = rs("cajerosausentes")
			totalAusentes2 = rs("cajerosausentes2")
			totalAusentes2 = ABS(totalAusentes2)
			totalPresentes = rs("cajerospresentes")
			totalSinRegistro = rs("cajerossinregistro")
			totalCajeros = totalCajerosTitulares + totalCajerosAdicionales
		else
			totalCajerosTitulares = 0
			totalCajerosReemplazos = 0
			totalCajerosAdicionales = 0
			totalAusentes = 0
			totalAusentes2 = 0
			totalPresentes = 0
			totalSinRegistro =0
			totalCajeros = 0
		end if%>
			<tr>
				<td>
					<%=nombreSucursal%>
				</td>
				<td>
					<%=nombreJeps%>
				</td>
				<td>
					<%=totalCajeros%>
				</td>
				<td>
					<%=totalCajerosTitulares%>
				</td>
				<td>
					<%=totalCajerosReemplazos%>
				</td>
				<td>
					<%=totalCajerosAdicionales%>
				</td>
				<td>
					<%=totalPresentes%>
				</td>
				<td>
					<%=totalAusentes2%>
				</td>
				<td>
					<%=totalSinRegistro%>
				</td>
			</tr>
		<%next%>
	</tbody>
</table>
<script type="text/javascript">
$('#tablaDatosSucursalesCajZon<%=idZonal%>Reg<%=idRegional%>').dataTable( {
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
	}
});
</script>