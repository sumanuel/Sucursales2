<!--#include file="../funciones.asp"-->
<div class="row-fluid">
	<div class="span12">
		<%idRegion = trim(request("idRegion"))
		fecha = trim(request("fecha"))
		sql = ""
		sql = sql & "set dateformat dmy "
		sql = sql & " select z.id_region, z.region, z.id_sucursal, z.suc_nombre, "
      	sql = sql & " isnull((select sum(a.valor) "
      	sql = sql & " from SUC_index_ips a "
      	sql = sql & " where a.tipo = 1 and "
      	sql = sql & " a.fecha = CAST('"&fecha&"' as date) "
      	sql = sql & " and a.cod_bantotal = z.cod_bantotal),0) as pagos_prog_qty, "
 		sql = sql & " isnull((select sum(a.valor) "
 		sql = sql & " from SUC_index_ips a "
 		sql = sql & " where a.tipo = 2 "
 		sql = sql & " and a.fecha = CAST('"&fecha&"' as date) "
 		sql = sql & " and a.cod_bantotal = z.cod_bantotal),0) as pagos_prog_monto, "
		sql = sql & " isnull((select sum(a.valor) "
		sql = sql & " from SUC_index_ips a "
		sql = sql & " where a.tipo = 3 "
		sql = sql & " and a.fecha = CAST('"&fecha&"' as date) "
		sql = sql & " and a.cod_bantotal = z.cod_bantotal),0) as pagos_real_qty, "
		sql = sql & " isnull((select sum(a.valor) "
		sql = sql & " from SUC_index_ips a "
		sql = sql & " where a.tipo = 4 "
		sql = sql & " and a.fecha = CAST('"&fecha&"' as date) "
		sql = sql & " and a.cod_bantotal = z.cod_bantotal),0) as pagos_real_monto, "
		sql = sql & " isnull((select sum(a.valor) "
		sql = sql & " from SUC_index_bonos a "
		sql = sql & " where a.tipo = 30 "
		sql = sql & " and a.fecha = CAST('"&fecha&"' as date) "
		sql = sql & " and a.cod_bantotal = z.cod_bantotal),0) as pagosBM_prog_qty, "
		sql = sql & " isnull((select sum(a.valor) "
		sql = sql & " from SUC_index_bonos a "
		sql = sql & " where a.tipo = 31 "
		sql = sql & " and a.fecha = CAST('"&fecha&"' as date) "
		sql = sql & " and a.cod_bantotal = z.cod_bantotal),0) as pagosBM_prog_monto, "
		sql = sql & " isnull((select sum(a.valor) "
		sql = sql & " from SUC_index_bonos a "
		sql = sql & " where a.tipo = 32 "
		sql = sql & " and a.fecha = CAST('"&fecha&"' as date) "
		sql = sql & " and a.cod_bantotal = z.cod_bantotal),0) as pagosBM_real_qty, "
		sql = sql & " isnull((select sum(a.valor) "
		sql = sql & " from SUC_index_bonos a "
		sql = sql & " where a.tipo = 33 and "
		sql = sql & " a.fecha = CAST('"&fecha&"' as date) and "
		sql = sql & " a.cod_bantotal = z.cod_bantotal),0) as pagosBM_real_monto, "
		sql = sql & " isnull((select sum(a.valor) "
		sql = sql & " from SUC_index_ips a "
		sql = sql & " where a.tipo = 20 and "
		sql = sql & " a.fecha = CAST('"&fecha&"' as date) and "
		sql = sql & " a.cod_bantotal = z.cod_bantotal),0) as rezago_qty, "
		sql = sql & " isnull((select sum(a.valor) "
		sql = sql & " from SUC_index_ips a "
		sql = sql & " where a.tipo = 21 and "
		sql = sql & " a.fecha = CAST('"&fecha&"' as date) and "
		sql = sql & " a.cod_bantotal = z.cod_bantotal),0) as rezago_monto "
		sql = sql & " from ( "
		sql = sql & " select a.cod_bantotal, a.id_sucursal, a.suc_nombre, b.region, c.id_region, c.orden "
		sql = sql & " from SUC_sucursal a "
		sql = sql & " inner join SUC_sucursal_region b on a.id_sucursal = b.id_sucursal "
		sql = sql & " inner join SUC_regiones c on b.id_region = c.id_region "
		sql = sql & " where a.suc_estado = 1) as z "
		sql = sql & " where z.id_region = '"&idRegion&"' "
		'response.write(sql)
		'response.end
		set rs = db.execute(sql)
		if not rs.eof then
			datos = rs.GetRows()%>
			<table class="table table-bordered table-hover">
				<thead>
					<tr>
						<th class="bajaLetra">Sucursal</th>
						<th class="bajaLetra">IPS Prog QTY</th>
						<th class="bajaLetra">IPS Prog $</th>
						<th class="bajaLetra">IPS Real QTY</th>
						<th class="bajaLetra">IPS Real $</th>
						<th class="bajaLetra">B. P. Prog QTY</th>
						<th class="bajaLetra">B. P. Prog $</th>
						<th class="bajaLetra">B. P. Real QTY</th>
						<th class="bajaLetra">B. P. Real $</th>
						<th class="bajaLetra">Rezago. QTY</th>
						<th class="bajaLetra">Rezago. $</th>
					</tr>
				</thead>
				<tbody>
					<%
					For i = 0 to ubound(datos, 2)%>
					<tr>
						<td class="nombreSucursal<%=idRegion%>" data-nombreSucursal<%=idRegion%>="<%=server.htmlEncode(trim(datos(3,i)))%>" data-serieValorRealSucursal<%=idRegion%>="<%=trim(datos(6,i))%>">
							<%=server.htmlEncode(trim(datos(3,i)))%>
						</td>
						<td >
							<%=formatnumber(trim(datos(4,i)),0)%>
						</td>
						<td>
							$<%=formatnumber(trim(datos(5,i)),0)%>
						</td>
						<td class="serieValorRealSucursal" data-serieValorRealSucursal="<%=trim(datos(6,i))%>">
							<%=formatnumber(trim(datos(6,i)),0)%>
						</td>
						<td>
							$<%=formatnumber(trim(datos(7,i)),0)%>
						</td>
						<td>
							<%=formatnumber(trim(datos(8,i)),0)%>
						</td>
						<td>
							$<%=formatnumber(trim(datos(9,i)),0)%>
						</td>
						<td>
							<%=formatnumber(trim(datos(10,i)),0)%>
						</td>
						<td>
							$<%=formatnumber(trim(datos(11,i)),0)%>
						</td>
						<td>
							<%=formatnumber(trim(datos(12,i)),0)%>
						</td>
						<td>
							$<%=formatnumber(trim(datos(13,i)),0)%>
						</td>
					</tr>
					<%next%>
				</tbody>
			</table>
		<%end if%>
	</div>
</div>
<div class="row-fluid">
	<div class="span10" id="graficoSucursal<%=idRegion%>">
	</div>
</div>
<script type="text/javascript">
	$(function () {
    	var chart;
    	var valoresCategorias<%=idRegion%> = [];
		var nombreSucursal,serieValorRealSucursal,valorInserta;
		$('.nombreSucursal<%=idRegion%>').each(function(){
			var valoresSucursal<%=idRegion%> = [];
			nombreSucursal = $(this).attr('data-nombreSucursal<%=idRegion%>');
			valor = $(this).attr('data-serieValorRealSucursal<%=idRegion%>');
			//valorInserta = nombreSucursal
			valoresSucursal<%=idRegion%>.push(nombreSucursal);
			valoresSucursal<%=idRegion%>.push(parseInt(valor));
			//valoresCategorias.push(nombreSucursal,serieValorRealSucursal);
			valoresCategorias<%=idRegion%>.push(valoresSucursal<%=idRegion%>)
		});
    
    	$(document).ready(function () {
	    	
	    	// Build the chart
	        $('#graficoSucursal<%=idRegion%>').highcharts({
	            chart: {
	                plotBackgroundColor: null,
	                plotBorderWidth: null,
	                plotShadow: false
	            },
	            title: {
	                text: 'Cantidad de pagos por región'
	            },
	            tooltip: {
	        	    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
	            },
	            plotOptions: {
	                pie: {
	                    allowPointSelect: true,
	                    cursor: 'pointer',
	                    dataLabels: {
	                        enabled: false
	                    },
	                    showInLegend: true
	                }
	            },
	            series: [{
	                type: 'pie',
	                name: 'Cantidad de pagos',
	                data: valoresCategorias<%=idRegion%>
	            }]
	        });
	    });
    
	});
	
</script>