<!--#include file="../funciones.asp"-->
<%
	sql = ""
	sql = sql & " set dateformat dmy "
	sql = sql & " select fecha_registro, "
	sql = sql & " (select count(*) "
	sql = sql & " from SUC_casos b "
	sql = sql & " where a.fecha_registro = b.fecha_registro) as INGRESADOS, "
   	sql = sql & " (select count(*) "
   	sql = sql & " from SUC_casos b "
   	sql = sql & " where a.fecha_registro = b.fecha_registro and b.id_caso_paso <> 5) as ENTRANSITO, "
  	sql = sql & " (select count(*) "
  	sql = sql & " from SUC_casos b "
  	sql = sql & " where a.fecha_registro = b.fecha_registro and b.id_caso_paso = 5) as CERRADOS "
  	sql = sql & " from SUC_casos a "
  	sql = sql & " where "
  	sql = sql & " year(fecha_registro) = year(getdate()) and "
  	sql = sql & " month(fecha_registro) = month(getdate()) "
  	sql = sql & " group by fecha_registro "
  	sql = sql & " order by fecha_registro "

	'response.write(sql)
	'response.end()

	set rs = db.execute(sql)
    if not rs.eof then
        datos = rs.GetRows()%>
				<div class="row-fluid">
					<div class="span3 offset1">
						<%
							sql = ""
							sql = sql & "select a.id_caso_categoria, a.caso_cod_categoria, "
							sql = sql & "a.caso_categoria, b.id_caso_motivo, b.caso_cod_motivo, "
							sql = sql & "b.caso_motivo "
							sql = sql & "from SUC_casos_config_categoria a "
							sql = sql & "inner join SUC_casos_config_motivo b "
							sql = sql & "on a.id_caso_categoria = b.id_caso_categoria "
							sql = sql & "order by a.id_caso_categoria, b.id_caso_motivo "

							'response.write(sql)
							'response.end

							set rs2 = db.execute(sql)							
						%>
						<table class="table table-bordered table-condensed">
							<thead>
								<th>CATEGORIAS</th>								
								<th>TOT.</th>
								<th>DP</th>
								<th>FP</th>
							</thead>
							<tbody>
								<% if not rs2.eof then
									catAux = 0
									do while not rs2.eof 	
										idCasoCategoria = rs2("id_caso_categoria")
										casoCodCategoria = rs2("caso_cod_categoria") 
										casoCategoria = rs2("caso_categoria") 
										idCasoMotivo = rs2("id_caso_motivo") 
										casoCodMotivo = rs2("caso_cod_motivo") 
										casoMotivo = rs2("caso_motivo") 

										if catAux <> idCasoCategoria then
											catAux = idCasoCategoria
										%>
											<tr>
												<td><strong><%=casoCategoria%></strong></td>												
												<td id="catt<%=idCasoCategoria%>">0</td>
												<td id="catdp<%=idCasoCategoria%>">0</td>
												<td id="catfp<%=idCasoCategoria%>">0</td>
											</tr>
										<%
										end if
										%>
											<tr>												
												<td style="padding-left:30px;"><%=casoMotivo%></td>
												<td id="mott<%=idCasoMotivo%>">0</td>
												<td id="motdp<%=idCasoMotivo%>">0</td>
												<td id="motfp<%=idCasoMotivo%>">0</td>
											</tr>
										<%
									rs2.MoveNext
       								loop
								   end if
								%>
							</tbody>
						</table>
						<script type="text/javascript">
							$(document).ready(function(){
								var pagina = 'cuadroControlGC_sql.asp?tipo=10';
								$.getJSON(pagina, 
									function(data){
										$.each(data.datos, function(i,dato){
											if(dato.item.indexOf("cat") != -1)
							            		$('#'+dato.item).html('<strong>'+dato.qty+'</strong>');
							            	else
							            		$('#'+dato.item).html(dato.qty);
							          });
									}
								);
							});
						</script>
					</div>
					<div class="span7">
						<div class="row-fluid">							
							<div class="span12">
								<div id="grafico"></div>
							</div>							
						</div>	
						<div class="row-fluid">							
							<div class="span12">
								<div id="grafico2"></div>
							</div>							
						</div>						
					</div>
				<div class="row-fluid">
						<div class="span12">
							<table class="oculto" id="tablaDatosReal">
								<thead>
									<tr>
										<th id="textoTitulo">Fecha registro</th>
										<th id="textoIngresados">Ingresados</th>			   				
										<th id="textoEnTransito">En Transito</th>			   				
										<th id="textoCerrados">Cerrados</th>			   				
									</tr>
								</thead>
								<tbody>
								<%For i = 0 to ubound(datos, 2)
									fecha = trim(datos(0,i))
									ingresados = trim(datos(1,i))
									enTransito = trim(datos(2,i))
									cerrados = trim(datos(3,i)) %>							
									<tr>
										<td class="fechaPago" data-fecha="<%=fecha%>">
											<%=fecha%>
										</td>
										<td class="ingresados" data-ingresados="<%=ingresados%>">
											<%=ingresados%>
										</td>
										<td class="enTransito" data-enTransito="<%=enTransito%>">
											<%=enTransito%>
										</td>
										<td class="cerrados" data-cerrados="<%=cerrados%>">
											<%=cerrados%>
										</td>
									</tr>
								<%next%>
							</tbody>
						</table>
						<table class="oculto">
							<thead>
								<th>ESTADO</th>									
							</thead>	
							<tbody>
								<tr>
									<td class="casoest1" id="casoest1" attr-titulo="" attr-qty="0">INGRESADO</td>									
								</tr>
								<tr>
									<td class="casoest2" id="casoest2" attr-titulo="" attr-qty="0">EN REVISION A BACK CAJEROS</td>									
								</tr>
								<tr>
									<td class="casoest3" id="casoest3" attr-titulo="" attr-qty="0">DERIVADO A PROVEEDOR</td>									
								</tr>
								<tr>
									<td class="casoest4" id="casoest4" attr-titulo="" attr-qty="0">INFORMADO A SUCURSAL</td>									
								</tr>
								<tr>
									<td class="casoest5" id="casoest5" attr-titulo="" attr-qty="0">CERRADO</td>									
								</tr>
							</tbody>
						</table>
						</div>	
					</div>						
				</div>
        <%end if%>

		<script type="text/javascript">	
			$(document).ready(function(){
				var pagina = 'cuadroControlGC_sql.asp?tipo=11';
				$.getJSON(pagina, 
					function(data){
						$.each(data.datos, function(i,dato){
			            	$('.'+dato.est).html(dato.casoPasoMacro);
			            	$('.'+dato.est).attr('attr-titulo',dato.casoPasoMacro);
			            	$('.'+dato.est).attr('attr-qty',dato.qty);
			          });
					}
				).done(function(){					

					var rowCount = $('#tablaDatosReal tr').length -1;
					var habilita;				

					var fechaPago;
					var valoresCategorias = [];
					var ingresados = [];
					var enTransito = [];
					var cerrados = [];				

					$('.fechaPago').each(function(){
						valoresCategorias.push($(this).attr('data-fecha'));
					});
					$('.ingresados').each(function(){
						ingresados.push(parseInt($(this).attr('data-ingresados')));					
					});
					$('.enTransito').each(function(){
						enTransito.push(parseInt($(this).attr('data-enTransito')));
					});				
					$('.cerrados').each(function(){
						cerrados.push(parseInt($(this).attr('data-cerrados')));	
					});

			        $('#grafico').highcharts({		        	
			            chart: {
			                type: 'column',
			                width: 850,
	            			height: 400,
	            			backgroundColor: 'rgba(255, 255, 255, 0.1)'			            
			            },
			            title: {
			                text: 'Gestión de Casos'
			            },
			            subtitle: {
			                text: 'Total de Casos por Estado'
			            },
			            legend: {
			                align: 'right',
			                x: -35,
			                verticalAlign: 'top',
			                y: 10,
			                floating: true,
			                backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
			                borderColor: '#CCC',
			                borderWidth: 1,
			                shadow: false
			            },
			            xAxis: {
	                    	categories: valoresCategorias,
	                    	labels: {
	                        	rotation: -45,	
	                        	align: 'right',
	                        	style: {
	                            	fontSize: '11px',
	                            	fontFamily: 'Verdana, sans-serif'
	                        	}
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
			                    borderWidth: 0,
			                    stacking: 'normal',
			                    dataLabels: {
				                    enabled: true,
				                    color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
				                    style: {
				                        textShadow: '0 0 3px black, 0 0 3px black'
				                    }
				                }
			                }
			            },
			            series: [		            
			            {
			                name: $('#textoIngresados').text(),
			                data: ingresados,
			                stack: 'total'
			    
			            }, {
			                name: $('#textoEnTransito').text(),
			                data: enTransito,
			                stack: 'flujo'
			            }, {
			                name: $('#textoCerrados').text(),
			                data: cerrados,
			                stack: 'flujo'
			            }]
			        });

					$('#grafico2').highcharts({
				        chart: {
				            type: 'pie',
				            options3d: {
				                enabled: true,
				                alpha: 45
				            }
				        },
				        title: {
				            text: 'Flujo de Estados'
				        },
				        subtitle: {
				            text: 'Qty Casos por Estado'
				        },
				        plotOptions: {
				            pie: {
				                innerSize: 100,
				                depth: 45
				            }
				        },
				        series: [{
				            name: 'Qty casos',
				            data: [
				                ['INGRESADO', parseInt($('#casoest1').attr('attr-qty'))],
				                ['EN REVISION A BACK CAJEROS', parseInt($('#casoest2').attr('attr-qty'))],
				                ['DERIVADO A PROVEEDOR', parseInt($('#casoest3').attr('attr-qty'))],
				                ['INFORMADO A SUCURSAL', parseInt($('#casoest4').attr('attr-qty'))],
				                ['CERRADO', parseInt($('#casoest5').attr('attr-qty'))]
				            ]
				        }]
				    });
				});
			});
			
		</script>


