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
			<th class="textoCentrado">
				Titulares
			</th>
			<th class="textoCentrado">
				Reemplazo
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
		sql = ""
		sql = sql & " select sum(z.titulares_dot) as totalguardiastitulares ,  "
		sql = sql & " sum(z.reemplazos_dot) as totalguardiasreemplazos ,  "
		sql = sql & " sum(z.titulares_p)+SUM(z.reemp_p) as totalguardiaspresentes ,  "
		sql = sql & " sum(z.ausencia) as totalguardiasausentes ,  "
		sql = sql & " sum(sinRegistro) as totalguardiassinregistro from  ( "
		sql = sql & " select *,   "
		sql = sql & " case  when y.total >= y.titulares_dot then 0  "
		sql = sql & " else y.titulares_a + y.reemp_a   end ausencia  " 
		sql = sql & " from ( select *,   "
		sql = sql & " ((titulares_p)+(reemp_p)) as total  "
		sql = sql & " from (  "
		sql = sql & " select a.cod_bantotal,  "
		sql = sql & " count(*) titulares_dot , " 
		sql = sql & " isnull((select count(*)  "
		sql = sql & " from SUC_sucursal_guardias_asistencia b  "
		sql = sql & " where a.cod_bantotal = b.cod_bantotal  "
		sql = sql & " and b.asistencia = 'si'  "
		sql = sql & " and b.tipo_suc = 'titular'),0) as titulares_p ,  "
		sql = sql & " isnull((select count(*)  "
		sql = sql & " from SUC_sucursal_guardias_asistencia b  "
		sql = sql & " where a.cod_bantotal = b.cod_bantotal  "
		sql = sql & " and (b.asistencia = 'no' "
		sql = sql & " or b.asistencia is null)  "
		sql = sql & " and b.tipo_suc = 'titular'),0) as titulares_a ,  "
		sql = sql & " isnull((select COUNT(gr.guardia_rut_titular)  "
		sql = sql & " from SUC_sucursal_guardias_r gr  "
		sql = sql & " where gr.guardia_rut_titular = a.guardia_rut  "
		sql = sql & " and gr.cod_bantotal = a.cod_bantotal  "
		sql = sql & " and CONVERT(date,gr.desde) <= CONVERT(date,GETDATE())),0)as reemplazos_dot ,  "
		sql = sql & " isnull((select count(*)  "
		sql = sql & " from SUC_sucursal_guardias_asistencia b  "
		sql = sql & " inner join SUC_sucursal_guardias_r gr  "
		sql = sql & " on gr.guardia_rut = b.guardia_rut  "
		sql = sql & " and gr.cod_bantotal = b.cod_bantotal "  
		sql = sql & " where a.cod_bantotal = b.cod_bantotal "
		sql = sql & " and b.asistencia = 'si'  "
		sql = sql & " and b.tipo_suc = 'reemplazo'  "
		sql = sql & " and CONVERT(date,desde) <= CONVERT(date,GETDATE())),0) as reemp_p,  "
		sql = sql & " isnull((select count(*)  "
		sql = sql & " from SUC_sucursal_guardias_asistencia b  "
		sql = sql & " inner join SUC_sucursal_guardias_r gr  "
		sql = sql & " on gr.guardia_rut = b.guardia_rut  "
		sql = sql & " and gr.cod_bantotal = b.cod_bantotal "  
		sql = sql & " where a.cod_bantotal = b.cod_bantotal " 
		sql = sql & " and (b.asistencia = 'no' "
		sql = sql & " or b.asistencia is null)  "
		sql = sql & " and b.tipo_suc = 'reemplazo'  "
		sql = sql & " and CONVERT(date,desde) <= CONVERT(date,GETDATE()) ),0) as reemp_a ,  "
		sql = sql & " (select COUNT(*)  "
		sql = sql & " from SUC_sucursal_guardias_asistencia b  "
		sql = sql & " where b.asistencia is null "
		sql = sql & " and b.cod_bantotal = a.cod_bantotal) as sinRegistro  "
		sql = sql & " from SUC_sucursal_guardias_t a  "
		sql = sql & " group by a.cod_bantotal,a.guardia_rut ) as z ) as y  "
		sql = sql & " where y.cod_bantotal in (  select cod_bantotal  	"
		sql = sql & " from suc_sucursal  where suc_estado = 1  and id_sucursal = '"&idSucursal&"')) as z  "
		'response.write(sql)
		'response.end
		set rs = db.execute(sql)
		if not rs.eof then
			guardiasTitulares = rs("totalguardiastitulares")
			guardiasReemplazo = rs("totalguardiasreemplazos")
			guardiasPresentes = rs("totalguardiaspresentes")
			guardiasAusentes = rs("totalguardiasausentes")
			guardiasSinRegistro = rs("totalguardiassinregistro")
		
		else
			guardiasTitulares = 0
			guardiasReemplazo = 0
			guardiasPresentes = 0
			guardiasAusentes = 0
			guardiasSinRegistro = 0
		
		end if%>
			<tr>
				<td>
					<%=nombreSucursal%>
				</td>
				<td>
					<%=nombreJeps%>
				</td>
				<td>
					<%=guardiasTitulares%>
				</td>
				<td>
					<%=guardiasReemplazo%>
				</td>
				<td>
					<%=guardiasPresentes%>
				</td>
				<td>
					<%=guardiasAusentes%>
				</td>
				<td>
					<%=guardiasSinRegistro%>
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