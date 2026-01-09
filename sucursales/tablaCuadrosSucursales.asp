<!--#include file="../funciones2.asp"-->
<%idRegional = trim(request("idRegional"))
idZonal = trim(request("idZonal"))
'fecha = "2015-02-17"
fecha = date()
sql = ""
sql = sql & " select id_sucursal, "
sql = sql & " suc_jeps, "
sql = sql & " suc_nombre "
sql = sql & " from suc_sucursal "
sql = sql & " where suc_estado = 1 "
sql = sql & " and id_sucursal in "
sql = sql & " (select id_sucursal "
sql = sql & " from SUC_usuario_sucursal "
sql = sql & " where id_usuario = '"&idZonal&"') "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows
end if%>
<div class="row-fluid">
	<div class="span12">
		<table class="table table-bordered table-hover table-condensed" id="tablaDatosSucursalesReg<%=idRegional%>Zon<%=idZonal%>">
			<thead>
				<tr>
					<th>
						Nombre Sucursal
					</th>
					<th>
						Jeps
					</th>
					<th>
						Hora Apertura
					</th>
					<th>
						Hora Cierre
					</th>
					<th>
						Normal
					</th>
					<th>
						IPS
					</th>
					<th>
						AFP
					</th>
				</tr>
			</thead>
			<tbody>
				<%for i = 0 to ubound(datos,2)
					idSucursal = trim(datos(0,i))
					nombreJeps = server.htmlencode(trim(datos(1,i)))
					nombreSucursal = server.htmlencode(trim(datos(2,i)))
					sql = ""
					sql = sql & " set dateformat dmy "
					sql = sql & " select cast(isnull(hora_ingreso,'00:00') as char(5) )"
					sql = sql & " from suc_sucursal_apertura "
					sql = sql & " where id_sucursal = '"&idSucursal&"' "
					sql = sql & " and fecha_ingreso = CAST('"&fecha&"' as date) "
					sql = sql & " and tipo = 1 "
					set rs = db.execute(sql)
					if not rs.eof then
						apertura = 1
						horaApertura = trim(rs(0))
						claseApertura = "label label-success"
						textoApertura = "Abierta"
					else
						apertura = 0
						horaApertura = "---"
						claseApertura = "label label-important"
						textoApertura = "Sin apertura"
					end if
					sql = ""
					sql = sql & " set dateformat dmy "
					sql = sql & " select cast(isnull(hora_ingreso,'00:00') as char(5) )"
					sql = sql & " from suc_sucursal_apertura "
					sql = sql & " where id_sucursal = '"&idSucursal&"' "
					sql = sql & " and fecha_ingreso = CAST('"&fecha&"' as date) "
					sql = sql & " and tipo = 2 "
					set rs = db.execute(sql)
					if not rs.eof then
						Cierre = 1
						horaCierre = trim(rs(0))
						claseCierre = "label label-success"
						textoCierre = "Cerrada"
					else
						Cierre = 0
						horaCierre = "---"
						claseCierre = "label label-important"
						textoCierre = "---"
					end if
					sql = ""
					sql = sql & " set dateformat dmy "
					sql = sql & " select situacion, "
					sql = sql & " tipo ,"
					sql = sql & " CAST(hora as CHAR(5)) as hora "
					sql = sql & " from SUC_desbordes "
					sql = sql & " where id_des = (select MAX(id_des) from SUC_desbordes "
					sql = sql & " where fecha = cast('"&fecha&"' as date)  "
					sql = sql & " and id_sucursal = '"&idSucursal&"' "
					sql = sql & " and tipo = 0 )"
					set rs = db.execute(sql)
					if not rs.eof then
						nombreSituacion = server.htmlEncode(trim(rs(0)))
						tipo = trim(rs(1))
						hora = trim(rs(2))
						if tipo = "0" then
							nombreTipo = ""
						end if
						textoDesNormal = nombreSituacion&" ("&hora&")"
					else
						textoDesNormal = "--"
					end if
					sql = ""
					sql = sql & " set dateformat dmy "
					sql = sql & " select situacion, "
					sql = sql & " tipo ,"
					sql = sql & " CAST(hora as CHAR(5)) as hora "
					sql = sql & " from SUC_desbordes "
					sql = sql & " where id_des = (select MAX(id_des) from SUC_desbordes "
					sql = sql & " where fecha = cast('"&fecha&"' as date)  "
					sql = sql & " and id_sucursal = '"&idSucursal&"' "
					sql = sql & " and tipo = 1 )"
					set rs = db.execute(sql)
					if not rs.eof then
						nombreSituacion = server.htmlEncode(trim(rs(0)))
						tipo = trim(rs(1))
						hora = trim(rs(2))
						if tipo = "0" then
							nombreTipo = ""
						end if
						textoDesIps = nombreSituacion&" ("&hora&")"
					else
						textoDesIps = "--"
					end if
					sql = ""
					sql = sql & " set dateformat dmy "
					sql = sql & " select situacion, "
					sql = sql & " tipo ,"
					sql = sql & " CAST(hora as CHAR(5)) as hora "
					sql = sql & " from SUC_desbordes "
					sql = sql & " where id_des = (select MAX(id_des) from SUC_desbordes "
					sql = sql & " where fecha = cast('"&fecha&"' as date)  "
					sql = sql & " and id_sucursal = '"&idSucursal&"' "
					sql = sql & " and tipo = 2 )"
					set rs = db.execute(sql)
					if not rs.eof then
						nombreSituacion = server.htmlEncode(trim(rs(0)))
						tipo = trim(rs(1))
						hora = trim(rs(2))
						if tipo = "0" then
							nombreTipo = ""
						end if
						textoDesAfp = nombreSituacion&" ("&hora&")"
					else
						textoDesAfp = "--"
					end if%>
					<tr>
						<td>
							<%=nombreSucursal%>
						</td>
						<td>
							<%=nombreJeps%>
						</td>
						<td>
							<%=horaApertura%>
						</td>
						<td>
							<%=horaCierre%>
						</td>
						<td>
							<%=textoDesNormal%>
						</td>
						<td>
							<%=textoDesIps%>
						</td>
						<td>
							<%=textoDesAfp%>
						</td>
					</tr>
				<%next%>
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
	$('#tablaDatosSucursalesReg<%=idRegional%>Zon<%=idZonal%>').dataTable( {
		"aaSorting": [[5, 'desc']],
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
</script>