<!--#include file="../funciones.asp"-->
<%grafico = trim(request("grafico"))
if grafico = "1" then
	sql = ""
	sql = sql & " select cast(MAX(hora_ingreso) as datetime) as horaUltimaActualizacion, fecha_ingreso from SUC_index_ips where fecha = cast(GETDATE() as date) group by fecha_ingreso "
	set rs = db.execute(sql)
	if not rs.eof then
		horaUltimaActualizacion = cdate(trim(rs("fecha_ingreso"))&" "&right(trim(rs("horaUltimaActualizacion")),8))
		fechaActual = now()
		diferenciaMin = DateDiff("s", horaUltimaActualizacion,fechaActual)
		diferenciaMin = diferenciaMin * -1
	end if	

	sql = ""
	sql = sql & " select "
	sql = sql & " YEAR(y.fecha) anio, "
	sql = sql & " SUM(pagos_prog_qty) as pagos_prog_qty, "
	sql = sql & " SUM(pagos_prog_monto) as pagos_prog_monto, "
	sql = sql & " SUM(pagos_real_qty) as pagos_real_qty, "
	sql = sql & " SUM(pagos_real_monto) as pagos_real_monto, "
	sql = sql & " SUM(rezago_qty) as rezago_qty, "
	sql = sql & " SUM(rezago_monto) as rezago_monto "
	sql = sql & " from ( "
	sql = sql & " select "
	sql = sql & " z.fecha, "
	sql = sql & " isnull((select SUM(a.valor) "
	sql = sql & " from SUC_index_ips a where a.tipo = 1 "
	sql = sql & " and a.fecha = z.fecha group by a.fecha),0) as pagos_prog_qty, "
	sql = sql & " isnull((select SUM(a.valor) "
	sql = sql & " from SUC_index_ips a where a.tipo = 2 "
	sql = sql & " and a.fecha = z.fecha group by a.fecha),0) as pagos_prog_monto, "
	sql = sql & " isnull((select SUM(a.valor) "
	sql = sql & " from SUC_index_ips a where a.tipo = 3 "
	sql = sql & " and a.fecha = z.fecha group by a.fecha),0) as pagos_real_qty, "
	sql = sql & " isnull((select SUM(a.valor) "
	sql = sql & " from SUC_index_ips a where a.tipo = 4 "
	sql = sql & " and a.fecha = z.fecha group by a.fecha),0) as pagos_real_monto, "
	sql = sql & " isnull((select SUM(a.valor) "
	sql = sql & " from SUC_index_ips a where a.tipo = 20 "
	sql = sql & " and (a.fecha = z.fecha and a.fecha = cast(GETDATE() as date))),0) as rezago_qty, "
	sql = sql & " isnull((select SUM(a.valor) "
	sql = sql & " from SUC_index_ips a where a.tipo = 21 "
	sql = sql & " and (a.fecha = z.fecha and a.fecha = cast(GETDATE() as date))),0) as rezago_monto "
	sql = sql & " from ( "
	sql = sql & " select fecha from SUC_index_ips group by fecha ) as z ) as y "
	sql = sql & " group by YEAR(y.fecha) "
	sql = sql & " order by YEAR(y.fecha) desc "
	
	set rs = db.execute(sql)
    if not rs.eof then
        datos = rs.GetRows()%>
        <div class="row-fluid">
        	<div class="span2">
        		<p>
        			<a class="btn btn-primary downRezagos" href=""><i class="icon-cloud-download"></i>&nbsp;<b><span class="bajaLetra">REZAGO</span></b></a>
        		</p>
        	</div>
        	<div class="span3 offset7" class="fechaMaxima" id="fechaMaxima" data-minutos="<%=diferenciaMin%>">
        		<span class="badge badge-info"> Ultima actualización: 
        			<span id="muestraMinutos"></span>
        		</span>
        	</div>
        </div>
        <div class="row-fluid">
        	<div class="span12">
		   		<table class="table table-bordered table-hover">
			   		<thead>
			   			<tr>
			   				<th>Año</th>
			   				<th>Pagos Prog Cantidad</th>
			   				<th>Pagos Prog Monto</th>
			   				<th>Pagos Reales Cantidad</th>
			   				<th>Pagos Reales Monto</th>
			   				<th>Rezago Cantidad</th>
			   				<th>Rezago Monto</th>
			   			</tr>
			   		</thead>
			   		<tbody>
						<%For i = 0 to ubound(datos, 2) %>
							<tr>
								<td>
									<%=trim(datos(0,i))%>
									<%if aviso <> "" then%>
										<span class="label label-info">
											<%=aviso%>
										</span>
									<%end if%>
								</td>
								<td>
									<%=formatnumber(trim(datos(1,i)),0)%>
								</td>
								<td>
									$<%=formatnumber(trim(datos(2,i)),0)%>
								</td>
								<td>
									<%=formatnumber(trim(datos(3,i)),0)%>
								</td>
								<td>
									$<%=formatnumber(trim(datos(4,i)),0)%>
								</td>
								<td>
									<%=formatnumber(trim(datos(5,i)),0)%>
								</td>
								<td>
									$<%=formatnumber(trim(datos(6,i)),0)%>
								</td>
							</tr>
						<%pintaColor = 0
						next%>
					</tbody>
			</table>
		</div>
	</div>
	<script type="text/javascript">
		$(function(){
			moment.lang('es');
			moment().format();
			var minutos = parseInt($('#fechaMaxima').attr('data-minutos'));
			minutos = minutos / 60
			var totalMinutos = moment.duration(minutos, "minutes").humanize(true);
			$('#muestraMinutos').text(totalMinutos);

			$('.downRezagos').click(function(){					
				$(this).attr({
			        'download': 'rezagos.xls',
			        'href': 'especial/downMaestroPagos.asp?down=1',
			        'target': '_blank'
			    });
			});
		});
	</script>
	<%end if
end if
if grafico = "2" then
	sql = ""
	sql = sql &  " select "
  	sql = sql &  " YEAR(y.fecha) anio, MONTH(y.fecha) mes, "
  	sql = sql &  " SUM(y.pagos_prog_qty) as pagos_prog_qty, SUM(y.pagos_prog_monto) as pagos_prog_monto, "
  	sql = sql &  " SUM(y.pagos_real_qty) as pagos_real_qty, SUM(y.pagos_real_monto) as pagos_real_monto, "
  	sql = sql &  " SUM(y.pagosBM_prog_qty) as pagosBM_prog_qty, SUM(y.pagosBM_prog_monto) as pagosBM_prog_monto, "
  	sql = sql &  " SUM(y.pagosBM_real_qty) as pagosBM_real_qty, SUM(y.pagosBM_real_monto) as pagosBM_real_monto "
	sql = sql &  " from ( "
	sql = sql &  " select  "
   	sql = sql &  " z.fecha, "
  	sql = sql &  " isnull((select SUM(a.valor) "
  	sql = sql &  " from SUC_index_ips a where "
  	sql = sql &  " a.tipo = 1 and a.fecha = z.fecha group by a.fecha),0) as pagos_prog_qty, "
  	sql = sql &  " isnull((select SUM(a.valor) "
  	sql = sql &  " from SUC_index_ips a "
  	sql = sql &  " where a.tipo = 2 "
  	sql = sql &  " and a.fecha = z.fecha group by a.fecha),0) as pagos_prog_monto, "
  	sql = sql &  " isnull((select SUM(a.valor) "
  	sql = sql &  " from SUC_index_ips a "
  	sql = sql &  " where a.tipo = 3 and a.fecha = z.fecha group by a.fecha),0) as pagos_real_qty, "
  	sql = sql &  " isnull((select SUM(a.valor) "
  	sql = sql &  " from SUC_index_ips a "
  	sql = sql &  " where a.tipo = 4 and a.fecha = z.fecha group by a.fecha),0) as pagos_real_monto, "
  	sql = sql &  " isnull((select sum(a.valor) "
  	sql = sql &  " from SUC_index_bonos a "
  	sql = sql &  " where a.tipo = 30 and a.fecha = z.fecha),0) as pagosBM_prog_qty, "
  	sql = sql &  " isnull((select sum(a.valor) "
  	sql = sql &  " from SUC_index_bonos a "
  	sql = sql &  " where a.tipo = 31 and a.fecha = z.fecha),0) as pagosBM_prog_monto, "
  	sql = sql &  " isnull((select sum(a.valor) "
  	sql = sql &  " from SUC_index_bonos a "
  	sql = sql &  " where a.tipo = 32 and a.fecha = z.fecha),0) as pagosBM_real_qty, "
  	sql = sql &  " isnull((select sum(a.valor) "
  	sql = sql &  " from SUC_index_bonos a "
  	sql = sql &  " where a.tipo = 33 and a.fecha = z.fecha),0) as pagosBM_real_monto "
	sql = sql &  " from ( "
	sql = sql &  " select fecha from SUC_index_ips group by fecha "
	sql = sql &  " ) as z ) as y "
	sql = sql &  " group by YEAR(y.fecha), MONTH(y.fecha) "
	sql = sql &  " order by YEAR(y.fecha), MONTH(y.fecha) "
	set rs = db.execute(sql)
    if not rs.eof then
        datos = rs.GetRows()%>
        <div class="row-fluid">
        	<div class="span12">
				<table class="table table-bordered table-hover oculto" id="tablaDatosReal">
					<thead>
						<tr>
							<th id="textoTitulo">Fecha</th>
							<th id="textoSerieValorProg">Pagos Prog Cantidad</th>
							<th id="textoSerieValorReal">Pagos Reales Cantidad</th>
							<th id="textoSerieValorBonoMarzoProgramado">Pagos Prog B. Marzo</th>
							<th id="textoSerieValorBonoMarzoPagado">Pagos Reales B. Marzo</th>
						</tr>
					</thead>
					<tbody>
					<%For i = 0 to ubound(datos, 2)
						fechaAnio = trim(datos(0,i))
						fechaMes = primeraMayuscula(monthname(trim(datos(1,i))))
						fecha = fechaMes&" "&fechaAnio
						valorProg = trim(datos(2,i))
						valorReal = trim(datos(4,i))
						valorBonoMarzoProgramado = trim(datos(6,i))
						valorBonoMarzoPagado = trim(datos(8,i))%>
						<tr>
							<td class="fechaPago" data-fecha="<%=fecha%>">
								<%=fecha%>
							</td>
							<td class="serieValorProg" data-valorProg="<%=valorProg%>">
								<%=valorProg%>
							</td>
							<td class="serieValorReal" data-valorReal="<%=valorReal%>">
								<%=valorReal%>
							</td>
							<td class="serieValorBonoMarzoProgramado" data-valorBonoMarzoProgramado="<%=valorBonoMarzoProgramado%>">
								<%=valorBonoMarzoProgramado%>
							</td>
							<td class="serieValorBonoMarzoPagado" data-valorBonoMarzoPagado="<%=valorBonoMarzoPagado%>">
								<%=valorBonoMarzoPagado%>
							</td>
						</tr>
					<%next%>
				</tbody>
			</table>
		</div>
	</div>
	<div class="row-fluid">
		<div id="grafico" class="span9"></div>
	</div>		
	<script type="text/javascript">
	$(function () {
		var rowCount = $('#tablaDatosReal tr').length -1;
		var habilita;
		if (rowCount <=35)
		{
			habilita = true;
		}
		else
		{
			habilita = false;   
		}
		var fechaPago;
		var valoresCategorias = [];
		var serieValorProg = [];
		var serieValorReal = [];
		var serieValorBonoMarzoProgramado = [];
		var serieValorBonoMarzoPagado = [];
		$('.fechaPago').each(function(){
			valoresCategorias.push($(this).attr('data-fecha'));
		});
		$('.serieValorProg').each(function(){
			serieValorProg.push(parseInt($(this).attr('data-valorProg')));
		});
		$('.serieValorReal').each(function(){
			serieValorReal.push(parseInt($(this).attr('data-valorReal')));
		});
		$('.serieValorBonoMarzoProgramado').each(function(){
			serieValorBonoMarzoProgramado.push(parseInt($(this).attr('data-valorBonoMarzoProgramado')));
		});
		$('.serieValorBonoMarzoPagado').each(function(){
			serieValorBonoMarzoPagado.push(parseInt($(this).attr('data-valorBonoMarzoPagado')));
		});

		$('#grafico').highcharts({
			chart: {
				type: 'column'
			},
			title: {
				text: 'Pagos IPS mensual'
			},
			subtitle: {
				text: 'Cantidad de pagos programados v/s reales'
			},
			xAxis: {
				categories: valoresCategorias,
				labels: {
					rotation: -45,
					align: 'right',
					style: {
						fontSize: '11px',
						fontFamily: 'Verdana, sans-serif'
					},
				enabled: habilita
				}
			},
			yAxis: {
				min: 0,
				title: {
					text: 'Totales'
				}
			},
			tooltip: {
				headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
				pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +'<td style="padding:0"><b>{point.y} </b></td></tr>',
				footerFormat: '</table>',
				shared: true,
				useHTML: true
			},
			plotOptions: {
				column: {
					pointPadding: 0.2,
					borderWidth: 0
					}
				},
				series: [{
					name: $('#textoSerieValorProg').text(),
					data: serieValorProg
				},
				{
					name: $('#textoSerieValorReal').text(),
					data: serieValorReal
				},
				{
					name: $('#textoSerieValorBonoMarzoProgramado').text(),
					data: serieValorBonoMarzoProgramado
				},
				{
					name: $('#textoSerieValorBonoMarzoPagado').text(),
					data: serieValorBonoMarzoPagado
				}]
			});
		});
	</script>
	<%end if
end if
if grafico = "3" then
	fechaInicio = trim(request("fechaInicio"))
	fechaTermino = trim(request("fechaTermino"))
	sql = ""
	sql = sql &  " set dateformat dmy "
	sql = sql & " select "
   	sql = sql & " z.fecha, "
  	sql = sql & " (select SUM(a.valor) "
  	sql = sql & " from SUC_index_ips a "
  	sql = sql & " where a.tipo = 1 "
  	sql = sql & " and a.fecha = z.fecha group by a.fecha) as pagos_prog_qty, "
  	sql = sql & " (select SUM(a.valor) "
  	sql = sql & " from SUC_index_ips a "
  	sql = sql & " where a.tipo = 2 "
  	sql = sql & " and a.fecha = z.fecha "
  	sql = sql & " group by a.fecha) as pagos_prog_monto, "
  	sql = sql & " (select SUM(a.valor) "
  	sql = sql & " from SUC_index_ips a "
  	sql = sql & " where a.tipo = 3 "
  	sql = sql & " and a.fecha = z.fecha "
  	sql = sql & " group by a.fecha) as pagos_real_qty, "
  	sql = sql & " (select SUM(a.valor) "
  	sql = sql & " from SUC_index_ips a "
  	sql = sql & " where a.tipo = 4 "
  	sql = sql & " and a.fecha = z.fecha "
  	sql = sql & " group by a.fecha) as pagos_real_monto, "
  	sql = sql & " isnull((select sum(a.valor) "
  	sql = sql & " from SUC_index_bonos a "
  	sql = sql & " where a.tipo = 30 "
  	sql = sql & " and a.fecha = z.fecha),0) as pagosBM_prog_qty, "
  	sql = sql & " isnull((select sum(a.valor) "
  	sql = sql & " from SUC_index_bonos a "
  	sql = sql & " where a.tipo = 31 and a.fecha = z.fecha),0) as pagosBM_prog_monto, "
  	sql = sql & " isnull((select sum(a.valor) "
  	sql = sql & " from SUC_index_bonos a "
  	sql = sql & " where a.tipo = 32 "
  	sql = sql & " and a.fecha = z.fecha),0) as pagosBM_real_qty, "
  	sql = sql & " isnull((select sum(a.valor) "
  	sql = sql & " from SUC_index_bonos a "
  	sql = sql & " where a.tipo = 33 "
  	sql = sql & " and a.fecha = z.fecha),0) as pagosBM_real_monto "
	sql = sql & " from ( "
	sql = sql & " select fecha from SUC_index_ips group by fecha "
	sql = sql & " ) as z "
	sql = sql & " where z.fecha >= '"&fechaInicio&"' and z.fecha <= '"&fechaTermino&"'"
	sql = sql & " order by z.fecha "
	set rs = db.execute(sql)
    if not rs.eof then
        datos = rs.GetRows()%>
        <div class="row-fluid">
        	<div class="span12">
				<table class="table table-bordered table-hover oculto" id="tablaDatosReal">
			   		<thead>
			   			<tr>
			   				<th id="textoTitulo">Fecha</th>
			   				<th id="textoSerieValorProg">Pagos Prog Cantidad</th>
			   				<!--<th>Pagos Prog Monto</th>-->
			   				<th id="textoSerieValorReal">Pagos Reales Cantidad</th>
			   				<!--<th>Pagos Reales Monto</th>-->
			   				<th id="textoSerieValorBonoMarzoProgramado">Pagos Prog B. Marzo</th>
			   				<th id="textoSerieValorBonoMarzoPagado">Pagos Reales B. Marzo</th>
			   			</tr>
			   		</thead>
			   		<tbody>
						<%For i = 0 to ubound(datos, 2)
							fecha = trim(datos(0,i))
							valorProg = trim(datos(1,i))
							valorReal = trim(datos(3,i))
							valorBonoMarzoProgramado = trim(datos(5,i))
							valorBonoMarzoPagado = trim(datos(7,i))%>
							<tr>
								<td class="fechaPago" data-fecha="<%=fecha%>">
									<%=fecha%>
								</td>
								<td class="serieValorProg" data-valorProg="<%=valorProg%>">
									<%=valorProg%>
								</td>
								<td class="serieValorReal" data-valorReal="<%=valorReal%>">
									<%=valorReal%>
								</td>
								<td class="serieValorBonoMarzoProgramado" data-valorBonoMarzoProgramado="<%=valorBonoMarzoProgramado%>">
									<%=valorBonoMarzoProgramado%>
								</td>
								<td class="serieValorBonoMarzoPagado" data-valorBonoMarzoPagado="<%=valorBonoMarzoPagado%>">
									<%=valorBonoMarzoPagado%>
								</td>
							</tr>
						<%next%>
					</tbody>
				</table>
			</div>
        </div>
        <div class="row-fluid">
        	<div id="grafico" class="span9"></div>
        </div>
		<script type="text/javascript">
			$(function () {
				var rowCount = $('#tablaDatosReal tr').length -1;
				var habilita;
				if (rowCount <=35)
				{
					habilita = true;
				}
				else
				{
					habilita = false;   
				}
				var fechaPago;
				var valoresCategorias = [];
				var serieValorProg = [];
				var serieValorReal = [];
				var serieValorBonoMarzoProgramado = [];
				var serieValorBonoMarzoPagado = [];
				$('.fechaPago').each(function(){
					valoresCategorias.push($(this).attr('data-fecha'));
				});
				$('.serieValorProg').each(function(){
					serieValorProg.push(parseInt($(this).attr('data-valorProg')));
				});
				$('.serieValorReal').each(function(){
					serieValorReal.push(parseInt($(this).attr('data-valorReal')));
				});
				$('.serieValorBonoMarzoProgramado').each(function(){
					serieValorBonoMarzoProgramado.push(parseInt($(this).attr('data-valorBonoMarzoProgramado')));
				});
				$('.serieValorBonoMarzoPagado').each(function(){
					serieValorBonoMarzoPagado.push(parseInt($(this).attr('data-valorBonoMarzoPagado')));
				});
				
		        $('#grafico').highcharts({
		            chart: {
		                type: 'column'
		            },
		            title: {
		                text: 'Pagos IPS'
		            },
		            subtitle: {
		                text: 'Cantidad de pagos programados v/s reales'
		            },
		            xAxis: {
                    	categories: valoresCategorias,
                    	labels: {
                        	rotation: -45,
                        	align: 'right',
                        	style: {
                            	fontSize: '11px',
                            	fontFamily: 'Verdana, sans-serif'
                        	},
                        	enabled: habilita
                    	},
                    },
		            yAxis: {
		                min: 0,
		                title: {
		                    text: 'Totales'
		                }
		            },
		            tooltip: {
		                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
		                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
		                    '<td style="padding:0"><b>{point.y} </b></td></tr>',
		                footerFormat: '</table>',
		                shared: true,
		                useHTML: true
		            },
		            plotOptions: {
		                column: {
		                    pointPadding: 0.2,
		                    borderWidth: 0
		                }
		            },
		            series: [{
		                name: $('#textoSerieValorProg').text(),
		                data: serieValorProg
		    
		            }, {
		                name: $('#textoSerieValorReal').text(),
		                data: serieValorReal
		            }, {
		                name: $('#textoSerieValorBonoMarzoProgramado').text(),
		                data: serieValorBonoMarzoProgramado
		            }, {
		                name: $('#textoSerieValorBonoMarzoPagado').text(),
		                data: serieValorBonoMarzoPagado
		            }]
		        });
		    });
		</script>
	<%end if
end if
if grafico = "4" then 'LISTADO DE PAGOS POR REGION
	fecha = trim(request("fecha"))
	if fecha = "" then fecha = date()
	sql = ""
	sql = sql &  " set dateformat dmy "
	sql = sql &  " select y.id_region, y.region, y.orden, "
  	sql = sql &  " sum(y.pagos_prog_qty) as pagos_prog_qty, " 
  	sql = sql &  " sum(y.pagos_prog_monto) as pagos_prog_monto, "
  	sql = sql &  " sum(y.pagos_real_qty) as pagos_real_qty, "
  	sql = sql &  " sum(y.pagos_real_monto) as pagos_real_monto, "
  	sql = sql &  " sum(y.pagosBM_prog_qty) as pagosBM_prog_qty, "
  	sql = sql &  " sum(y.pagosBM_prog_monto) as pagosBM_prog_monto, "
  	sql = sql &  " sum(y.pagosBM_real_qty) as pagosBM_real_qty, "
  	sql = sql &  " sum(y.pagosBM_real_monto) as pagosBM_real_monto, "
  	sql = sql &  " sum(y.rezago_qty) as rezago_qty, "
	sql = sql &  " sum(y.rezago_monto) as rezago_monto "
	sql = sql &  " from ( "
	sql = sql &  " select z.id_region, z.region, z.orden, "
  	sql = sql &  " isnull((select sum(a.valor) from SUC_index_ips a "
  	sql = sql &  " where a.tipo = 1 and a.fecha = CAST('"&fecha&"' as date) "
  	sql = sql &  " and a.cod_bantotal = z.cod_bantotal),0) as pagos_prog_qty, "
  	sql = sql &  " isnull((select sum(a.valor) from SUC_index_ips a "
  	sql = sql &  " where a.tipo = 2 and a.fecha = CAST('"&fecha&"' as date) "
  	sql = sql &  " and a.cod_bantotal = z.cod_bantotal),0) as pagos_prog_monto, "
  	sql = sql &  " isnull((select sum(a.valor) from SUC_index_ips a "
  	sql = sql &  " where a.tipo = 3 and a.fecha = CAST('"&fecha&"' as date) "
  	sql = sql &  " and a.cod_bantotal = z.cod_bantotal),0) as pagos_real_qty, "
  	sql = sql &  " isnull((select sum(a.valor) from SUC_index_ips a where a.tipo = 4 "
  	sql = sql &  " and a.fecha = CAST('"&fecha&"' as date) "
  	sql = sql &  " and a.cod_bantotal = z.cod_bantotal),0) as pagos_real_monto, "
  	sql = sql &  " isnull((select sum(a.valor) from SUC_index_bonos a "
  	sql = sql &  " where a.tipo = 30 and a.fecha = CAST('"&fecha&"' as date) "
  	sql = sql &  " and a.cod_bantotal = z.cod_bantotal),0) as pagosBM_prog_qty, "
  	sql = sql &  " isnull((select sum(a.valor) from SUC_index_bonos a "
  	sql = sql &  " where a.tipo = 31 and a.fecha = CAST('"&fecha&"' as date) "
  	sql = sql &  " and a.cod_bantotal = z.cod_bantotal),0) as pagosBM_prog_monto, "
  	sql = sql &  " isnull((select sum(a.valor) from SUC_index_bonos a "
  	sql = sql &  " where a.tipo = 32 and a.fecha = CAST('"&fecha&"' as date) "
  	sql = sql &  " and a.cod_bantotal = z.cod_bantotal),0) as pagosBM_real_qty, "
  	sql = sql &  " isnull((select sum(a.valor) from SUC_index_bonos a "
  	sql = sql &  " where a.tipo = 33 and a.fecha = CAST('"&fecha&"' as date) "
  	sql = sql &  " and a.cod_bantotal = z.cod_bantotal),0) as pagosBM_real_monto, "
	sql = sql &  " isnull((select sum(a.valor) from SUC_index_ips a "
	sql = sql &  " where a.tipo = 20 and a.fecha = CAST('"&fecha&"' as date) "
	sql = sql &  " and a.cod_bantotal = z.cod_bantotal),0) as rezago_qty, "
	sql = sql &  " isnull((select sum(a.valor) from SUC_index_ips a "
	sql = sql &  " where a.tipo = 21 and a.fecha = CAST('"&fecha&"' as date) "
	sql = sql &  " and a.cod_bantotal = z.cod_bantotal),0) as rezago_monto "
	sql = sql &  " from ( "
	sql = sql &  " select a.cod_bantotal, a.suc_nombre, b.region, c.id_region, c.orden "
	sql = sql &  " from SUC_sucursal a "
  	sql = sql &  " inner join SUC_sucursal_region b on a.id_sucursal = b.id_sucursal "
  	sql = sql &  " inner join SUC_regiones c on b.id_region = c.id_region "
	sql = sql &  " where a.suc_estado = 1) as z ) as y "
	sql = sql &  " group by y.id_region, y.region, y.orden "
	sql = sql &  " order by y.orden "
	set rs = db.execute(sql)
    if not rs.eof then
        datos = rs.GetRows()
        fecha2 = fecha%>
        <input type="hidden" name="fecha2" id="fecha2" value="<%=fecha2%>">
        <div class="row-fluid">
        	<div class="span5 offset7">
        		<div id="divfecha" class="input-append">
					<span class="badge">
						Fecha
					</span>
					<input data-format="dd/MM/yyyy" type="text" id="fecha" name="fecha" value="<%=fecha%>"/>
					<span class="add-on">
						<i data-time-icon="icon-time" data-date-icon="icon-calendar"></i>
					</span>
				</div>
				<span class="oculto text-error" id="mensajeFechaSelecciona">
					La fecha no tiene datos
				</span>
        	</div>
        </div>
        <div class="row-fluid">
        	<div class="span12">
		   		<table class="table table-bordered table-hover" id="tablaDatosMuestra">
		   		<thead>
		   			<tr>
						<th class="bajaLetra">Región</th>
						<th class="bajaLetra">IPS Prg QTY</th>
						<th class="bajaLetra">IPS Prg $</th>
						<th class="bajaLetra">IPS Real QTY</th>
						<th class="bajaLetra">IPS Real $</th>
						<th class="bajaLetra">BM Prg QTY</th>
						<th class="bajaLetra">BM Prg $</th>
						<th class="bajaLetra">BM Real QTY</th>
						<th class="bajaLetra">BM Real $</th>
						<th class="bajaLetra">Rezago. QTY</th>
						<th class="bajaLetra">Rezago. $</th>
		   			</tr>
		   		</thead>
		   		<tbody>
					<%For i = 0 to ubound(datos, 2)
						idRegion=trim(datos(0,i))%>
						<tr>
							<td class="mano abreRegion" id="region<%=trim(datos(0,i))%>" data-idRegion="<%=trim(datos(0,i))%>" data-apertura="0" data-fecha="<%=fecha%>">
								<%=server.htmlEncode(trim(datos(1,i)))%>
							</td>
							<td>
								<%=formatnumber(trim(datos(3,i)),0)%>
							</td>
							<td>
								$<%=formatnumber(trim(datos(4,i)),0)%>
							</td>
							<td>
								<%=formatnumber(trim(datos(5,i)),0)%>
							</td>
							<td>
								$<%=formatnumber(trim(datos(6,i)),0)%>
							</td>
							<td>
								<%=formatnumber(trim(datos(7,i)),0)%>
							</td>
							<td>
								$<%=formatnumber(trim(datos(8,i)),0)%>
							</td>
							<td>
								<%=formatnumber(trim(datos(9,i)),0)%>
							</td>
							<td>
								$<%=formatnumber(trim(datos(10,i)),0)%>
							</td>
							<td>
								<%=formatnumber(trim(datos(11,i)),0)%>
							</td>
							<td>
								$<%=formatnumber(trim(datos(12,i)),0)%>
							</td>
						</tr>
						<tr id="trRegion<%=trim(datos(0,i))%>" class="oculto">
							<td colspan="11" id="tdRegion<%=trim(datos(0,i))%>"></td>
						</tr>
					<%next%>
				</tbody>
			</table>
		</div>
	</div>
	<script type="text/javascript">
		$(function(){
			$('#divfecha').datetimepicker({
				language: 'es-Cl',
				pickTime: false
			}).on('changeDate',function(){

				//hoy atra pagos
				// mañana emisiones fin abril
				var valor = $('#fecha').val();
				var pagina = 'especial/creaGrafico.asp';
				var div = 'graficoRegional';
				var datos = 'fecha='+valor+'&grafico=4';
				enviaDatos(pagina,div,datos);
			});
		});
		$('.abreRegion').click(function(){
			var apertura = $(this).attr('data-apertura');
			var idRegion = $(this).attr('data-idRegion');
			var fecha = $(this).attr('data-fecha');
			if (apertura ==='0')
			{
				$('#tdRegion'+idRegion).html('');
				$('#trRegion'+idRegion).removeClass('oculto').slideDown('fast');
				var pagina = 'especial/listaRegionSucursal.asp'
				var div = 'tdRegion'+idRegion;
				var datos = 'idRegion='+idRegion+'&fecha='+fecha;
				$(this).attr('data-apertura','1');
				enviaDatos(pagina,div,datos)
			}
			else
			{
				$('#trRegion'+idRegion).slideUp('fast').addClass('oculto');
				$('#tdRegion'+idRegion).html('');
				$(this).attr('data-apertura','0');
			}
			return false;			
		});
	</script>
	<%end if
end if%>