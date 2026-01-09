<!--#include file="../../funciones.asp"-->
<div class="row-fluid">
	<div class="span12">
		<% perfil = trim(request("perfilMain"))
		idUsuario = trim(request("idUsuarioMain"))
		sql = ""
		sql = sql & " declare @diaAnterior as date "
		sql = sql & " set @diaAnterior = (select utilidades.dbo.fn_diaHabilAnterior(GETDATE())) "
		sql = sql & " select z.suc_zonal_rut, "
		sql = sql & " z.suc_zonal, "
		sql = sql & " sum(z.afi_normal) as afi_normal, "
		sql = sql & " sum(z.afi_pbs) as afi_pbs, "
		sql = sql & " sum(z.afi_ffaa) as afi_ffaa, "
		sql = sql & " (sum(z.afi_normal)+sum(z.afi_pbs)+sum(z.afi_ffaa)) as afi_total, "
		sql = sql & " (select COUNT(*) "
		sql = sql & " from SUC_sucursal c "
		sql = sql & " where c.suc_zonal_rut = z.suc_zonal_rut "
		sql = sql & " and suc_foco = 1) as num_sucs, "
		sql = sql & " (cast((sum(z.afi_normal)+sum(z.afi_pbs)+sum(z.afi_ffaa)) as float)"
		sql = sql & " /cast((select COUNT(*) "
		sql = sql & " from SUC_sucursal c "
		sql = sql & " where c.suc_zonal_rut = z.suc_zonal_rut "
		sql = sql & " and suc_foco = 1) as float)) as afi_prom "
		sql = sql & " from (select b.suc_zonal_rut, "
		sql = sql & " b.suc_zonal, "
		sql = sql & " a.cod_sucursal, "
		sql = sql & " a.nombre_sucursal, "
		sql = sql & " a.afi_normal, "
		sql = sql & " a.afi_pbs, "
		sql = sql & " a.afi_ffaa, "
		sql = sql & " a.fecha "
		sql = sql & " from SUC_transacciones_diarias a "
		sql = sql & " inner join SUC_sucursal b on a.cod_sucursal = b.cod_bantotal "
		sql = sql & " where year(a.fecha) = year(@diaAnterior) "
		sql = sql & " and month(a.fecha) = month(@diaAnterior) " 
		sql = sql & " and (a.afi_normal <> 0 or a.afi_pbs <> 0) "
		sql = sql & " and a.cod_sucursal in (select cod_bantotal "
		sql = sql & " from SUC_sucursal "
		sql = sql & " where suc_foco = 1) "
		sql = sql & " ) as z "
		sql = sql & " group by z.suc_zonal_rut, z.suc_zonal "
		sql = sql & " order by afi_prom desc "
		
		'response.Write(sql)
		'response.end()
		set rs = db.execute(sql)
		if not rs.eof then
			datos = rs.GetRows()%>
			<table class="table table-bordered table-hover table-condensed" id="tablaPromedioFocoAfiliaciones">
				<thead>
					<tr>
						<th class="h7"><strong>Zonal</strong></th>
						<th class="h7"><strong>Normal</strong></th>
						<th class="h7"><strong>Pbs</strong></th>
                        <th class="h7"><strong>FFAA</strong></th>
						<th class="h7"><strong>Total</strong></th>
						<th class="h7"><strong>Prom Total</strong></th>
					</tr>
				</thead>
				<tbody>
					<%sumaNormal=0
					sumaPbs = 0
					sumaFfaa = 0
					sumaTotal = 0
					sumaPromSumMonto = 0
					for i=0 to ubound(datos,2)
						rut = trim(datos(0,i))
						zonal = server.htmlencode(trim(datos(1,i)))
						normal = trim(datos(2,i))
						sumaNormal = sumaNormal + normal
						pbs = trim(datos(3,i))
						sumaPbs = sumaPbs + pbs
						ffaa = trim(datos(4,i))
						sumaFfaa = sumaFfaa + ffa
						total = trim(datos(5,i))
						sumaTotal = sumaTotal + total
						promSumMonto = formatnumber(trim(datos(7,i)),2)
						if right(promSumMonto,2) ="00" then
							promSumMonto = clng(promSumMonto)
						end if
						sumaPromSumMonto = sumaPromSumMonto + promSumMonto
						'numSuc = trim(datos(6,i))%>
						<tr>
							<td class="h7"><%=zonal%></td>
							<td class="h7"><%=normal%></td>
							<td class="h7" ><%=pbs%></td>
                            <td class="h7" ><%=ffaa%></td>
							<td class="h7"><%=total%></td>
							<td class="h7"><%=promSumMonto%></td>
						</tr>
					<%next%>
					<tr>
						<td class="h7">Suma total</td>
						<td class="h7"><%=sumaNormal%></td>
						<td class="h7" ><%=sumaPbs%></td>
						<td class="h7" ><%=sumaFfaa%></td>
						<td class="h7"><%=sumaTotal%></td>
						<td class="h7"><%=sumaPromSumMonto%></td>						
					</tr>
				</tbody>
			</table>
		<%else%>
			No existen datos a mostrar
		<%end if%>
	</div>
</div>
<div class="row-fluid">
	<div class="span12">
		<% perfil = trim(request("perfil"))
		idUsuario = trim(request("idUsuario"))
		sql = ""
		sql = sql & " declare @diaAnterior as date "
		sql = sql & " set @diaAnterior = (select utilidades.dbo.fn_diaHabilAnterior(GETDATE())) "
		sql = sql & " select suc_jeps_short, " 
		sql = sql & " SUM(afi_normal) as afi_normal, "
		sql = sql & " SUM(afi_pbs) as afi_pbs, "
		sql = sql & " SUM(afi_ffaa) as afi_ffaa, "
		sql = sql & " (SUM(afi_normal)+SUM(afi_pbs)+SUM(afi_ffaa)) as total "
		sql = sql & " from ( select b.suc_jeps_short, "
		sql = sql & " a.cod_sucursal, "
		sql = sql & " a.nombre_sucursal, "
		sql = sql & " a.afi_normal, "
		sql = sql & " a.afi_pbs, "
		sql = sql & " a.afi_ffaa, "
		sql = sql & " a.fecha "
		sql = sql & " from SUC_transacciones_diarias a "
      	sql = sql & " inner join SUC_sucursal b on a.cod_sucursal = b.cod_bantotal "
		sql = sql & " where year(a.fecha) = year(@diaAnterior) "
		sql = sql & " and month(a.fecha) = month(@diaAnterior) "
		sql = sql & " and b.suc_foco = 1 "
		sql = sql & " ) as z "
		sql = sql & " where z.suc_jeps_short <> '' and (afi_normal <> 0 or afi_pbs <> 0) "
		sql = sql & " group by z.suc_jeps_short "
		sql = sql & " order by total desc"
		'Response.Write(sql)
		set rs = db.execute(sql)
		if not rs.eof then
			datos = rs.GetRows()%>
			<table class="table table-bordered table-hover table-condensed" id="tablaPromedioFocoAfiliacionesSucursal">
				<thead>
					<tr>
						<th class="h7"><strong>Jeps</strong></th>
						<th class="h7"><strong>Normal</strong></th>
						<th class="h7"><strong>Pbs</strong></th>
                        <th class="h7"><strong>FFAA</strong></th>
						<th class="h7"><strong>Total</strong></th>
					</tr>
				</thead>
				<tbody>
					<%for i=0 to ubound(datos,2)
						Jeps = server.htmlencode(trim(datos(0,i)))
						normal = trim(datos(1,i))
						pbs = trim(datos(2,i))
						ffaa = trim(datos(3,i))
						total = trim(datos(4,i))%>
						<tr>
							<td class="h7" ><%=Jeps%></td>
							<td class="h7"><%=normal%></td>
							<td class="h7" ><%=pbs%></td>
                            <td class="h7" ><%=ffaa%></td>
							<td class="h7"><%=total%></td>
						</tr>
					<%next%>
				</tbody>
			</table>
			<script type="text/javascript">
			$(function(){
				$('#tablaPromedioFocoAfiliacionesSucursal').dataTable( {
					"iDisplayLength": 14,
					"bFilter": false,
					"bInfo": false,
					"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span12'p>>",
					"sPaginationType": "bootstrap",
					"oLanguage": {
						"sLengthMenu": "_MENU_ Muestra",
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
							"sNext":     "",
							"sPrevious": ""
						},
						"oAria": {
							"sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
							"sSortDescending": ": Activar para ordenar la columna de manera descendente"
						}
					},
				});
				try{
					pagina = 'transacciones/foco/graficoFocoAfiliacionesEspecial.asp';
					div = 'graficoAfiliacionesEspecial';
					datos='';
					enviaDatos(pagina,div,datos);
				}
				catch(err){}
			});
			</script>
		<%else%>
			No existen datos a mostrar
		<%end if%>
	</div>
</div>