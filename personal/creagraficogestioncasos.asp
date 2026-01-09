<!--#include file="../funciones.asp"-->
<%
	tipo = request("tipo")
	fecha = request("fecha")
	idPerfil = request("idPerfil")
	idUsuario = request("idUsuario")
%>

<% if tipo = 1 then 'GEBERA GRAFICO DE CASOS 

  	sql = ""
  	sql = sql & "set dateformat dmy "
	sql = sql & "select z.fecha_registro, "
	sql = sql & "sum(z.ingresados) as ingresados, "
	sql = sql & "sum(z.entransito) as entransito, "
	sql = sql & "sum(z.cerrados) as cerrados from ( "
	sql = sql & "select fecha_registro, a.caso_id_sucursal, "
	sql = sql & "isnull((select count(*) from SUC_casos b where a.caso_id_sucursal = b.caso_id_sucursal and a.fecha_registro = b.fecha_registro),0) as INGRESADOS, "
   	sql = sql & "isnull((select count(*) from SUC_casos b where a.caso_id_sucursal = b.caso_id_sucursal and a.fecha_registro = b.fecha_registro and b.id_caso_paso <> 5),0) as ENTRANSITO, "
  	sql = sql & "isnull((select count(*) from SUC_casos b where a.caso_id_sucursal = b.caso_id_sucursal and a.fecha_registro = b.fecha_registro and b.id_caso_paso = 5),0) as CERRADOS "
	sql = sql & "from SUC_casos a "
	sql = sql & "where "
	sql = sql & "year(fecha_registro) = year(getdate()) and "
	sql = sql & "month(fecha_registro) = month(getdate()) "
	if idPerfil = "2" then
		sql = sql & "and a.caso_id_sucursal in (select id_sucursal from SUC_usuario_sucursal where id_usuario = "& idUsuario &") "
	end if
	sql = sql & "group by fecha_registro, a.caso_id_sucursal "
	sql = sql & ") as z "
	sql = sql & "group by z.fecha_registro "
	sql = sql & "order by z.fecha_registro "

	
	'response.write(sql)
	'response.end()

	set rs = db.execute(sql)
    if not rs.eof then
        datos = rs.GetRows()%>		
		<div class="oculto">
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
		</div>
	<% end if %>							
        
<script type="text/javascript">		
	$(document).ready(function(){
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
    			/*height: 500*/
            },
            title: {
                text: 'Gestión de Casos'
            },
            subtitle: {
                text: 'Casos por Estado'
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
            plotOptions: {
            	series: {
	                cursor: 'pointer',
	                point: {
	                    events: {
	                        click: function () {
	                        	//alert('Category: ' + this.category + ', value: ' + this.y);

	                        	var div = 'listaCasos';
	                        	var datos = 'tipo=2&idPerfil=<%=idPerfil%>&idUsuario=<%=idUsuario%>&fecha='+this.category;
	                        	var pagina = 'personal/creagraficogestioncasos.asp';	
	                        	enviaDatos(pagina,div,datos);

	                            $('#grafico').addClass('oculto').hide();
	                            $('#listaCasos').removeClass('oculto').show();
	                        }
	                    }
	                }
                },		            	
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
    });
</script>
<% end if %>

<% if tipo = 2 then 'LISTA DE CASOS POR FECHA %>

<%
	sql = ""
	sql = sql & "set dateformat dmy "
	sql = sql & "select z.*, case "
	sql = sql & "when z.id_caso_paso_macro = 5 and z.sla_diff <= z.caso_sla then 'DP'  "
	sql = sql & "when z.id_caso_paso_macro = 5 and z.sla_diff > z.caso_sla then 'FP' "
	sql = sql & "when z.id_caso_paso_macro <> 5 and z.sla_diff <= z.caso_sla then 'DP' "
	sql = sql & "when z.id_caso_paso_macro <> 5 and z.sla_diff > z.caso_sla then 'FP' "
	sql = sql & "end SLA "
	sql = sql & "from ( "
	sql = sql & "select "
	sql = sql & "E.id_sucursal, E.cod_bantotal, E.suc_nombre, A.id_caso, A.caso_titulo, B.caso_categoria, "
	sql = sql & "C.caso_motivo, isnull(A.caso_creado_por,0) as caso_creado_por, "
	sql = sql & "convert(varchar(12), isnull(A.caso_fecha_cre, getdate()), 105) as caso_fecha_cre, "
	sql = sql & "convert(varchar(12), isnull(A.caso_hora_cre, getdate()), 108) as caso_hora_cre, "
	sql = sql & "convert(varchar(12), isnull(A.caso_fecha_mod, getdate()), 105) as caso_fecha_mod, "
	sql = sql & "convert(varchar(12), isnull(A.caso_hora_mod, getdate()), 108) as caso_hora_mod, "
	sql = sql & "D.caso_paso_macro, D.id_caso_paso_macro, F.proveedor, C.caso_sla, "
	sql = sql & "case "
	sql = sql & "when A.id_caso_paso = 5 and cast(caso_fecha_cre as date) = cast(caso_fecha_mod as date) then "
	sql = sql & "datediff(minute, caso_hora_cre, caso_hora_mod) "
	sql = sql & "when A.id_caso_paso = 5 and cast(caso_fecha_cre as date) < cast(caso_fecha_mod as date) then "
	sql = sql & "datediff(minute, caso_hora_cre, caso_hora_mod ) + datediff(minute, caso_fecha_cre, cast(caso_fecha_mod as date)) "
	sql = sql & "when A.id_caso_paso <> 5 and cast(caso_fecha_cre as date) = cast(getdate() as date) then "
	sql = sql & "datediff(minute, caso_hora_mod, cast(getdate() as time)) "
	sql = sql & "when A.id_caso_paso <> 5 and cast(caso_fecha_cre as date) < cast(getdate() as date) then "
	sql = sql & "datediff(minute, caso_hora_mod, cast(getdate() as time)) + datediff(minute, caso_fecha_cre, cast(getdate() as date)) "
	sql = sql & "end SLA_DIFF "
	sql = sql & "from SUC_casos A "
	sql = sql & "inner join SUC_sucursal E on A.caso_id_sucursal = E.id_sucursal "
	sql = sql & "inner join SUC_sucursal_proveedor F on E.cod_bantotal = F.cod_bantotal "
	sql = sql & "inner join SUC_casos_config_categoria B on A.caso_categoria = B.id_caso_categoria "
	sql = sql & "inner join SUC_casos_config_motivo C on A.caso_motivo = C.id_caso_motivo "
	sql = sql & "inner join SUC_casos_pasos_macro D on A.id_caso_paso = D.id_caso_paso_macro "
	sql = sql & ") as z "
	sql = sql & "where z.caso_fecha_cre = '"& fecha &"' "
	if idPerfil = "2" then
		sql = sql & "and z.id_sucursal in (select id_sucursal from SUC_usuario_sucursal where id_usuario = "& idUsuario &") "
	end if
	sql = sql & "order by z.id_caso desc "

	'response.write(sql)
	'response.end

	set rs = db.execute(sql)
	if not rs.EOF then %>

	<table class="table table-bordered table-condensed table-hover" id="tablaCasos">
		<thead>
		<tr>
			<th style="font-size:10px;">CASO</th>
			<!--<th style="font-size:10px;">COD BTT</th>-->
			<th style="font-size:10px;">SUCURSAL</th>
			<th style="font-size:10px;">CATEGORIA</th>
			<th style="font-size:10px;">MOTIVO</th>
			<th style="font-size:10px;">FECHA CREACION</th>
			<th style="font-size:10px;">FECHA MODIFICACION</th>
			<th style="font-size:10px;">ESTADO</th>
			<th style="font-size:10px;">SLA</th>
			<th style="font-size:10px;">PROVEEDOR</th>				
		</tr>
		</thead>
		<tbody>
		<% do while not rs.eof 
			caso_id = cint(trim(rs("id_caso")))
			id_sucursal = trim(rs("id_sucursal"))
			cod_bantotal = trim(rs("cod_bantotal"))
			suc_nombre = server.htmlencode(trim(rs("suc_nombre")))
			caso_titulo = server.htmlencode(trim(rs("caso_titulo")))
			caso_categoria = server.htmlencode(trim(rs("caso_categoria")))
			caso_motivo = server.htmlencode(trim(rs("caso_motivo")))
			caso_creado_por = server.htmlencode(trim(rs("caso_creado_por")))
			caso_fecha_cre = server.htmlencode(trim(rs("caso_fecha_cre")))
			caso_hora_cre = server.htmlencode(trim(rs("caso_hora_cre")))
			caso_fecha_mod = server.htmlencode(trim(rs("caso_fecha_mod")))
			caso_hora_mod = server.htmlencode(trim(rs("caso_hora_mod")))
			caso_paso_macro = server.htmlencode(trim(rs("caso_paso_macro")))
			caso_sla = server.htmlencode(trim(rs("SLA")))
			proveedor = server.htmlencode(trim(rs("proveedor")))
		%>
			<tr class="mano casoTraking" data-idSucursal="<%=id_sucursal%>" data-idCaso="<%=caso_id%>">
				<td style="font-size:10px;"><%=caso_id%></td>
				<!--<td style="font-size:10px;"><%=cod_bantotal%></td>-->
				<td style="font-size:10px;"><%=suc_nombre%></td>				
				<td style="font-size:10px;"><%=caso_categoria%></td>
				<td style="font-size:10px;"><%=caso_motivo%></td>
				<td style="font-size:10px;"><%=caso_fecha_cre%>:<%=caso_hora_cre%></td>
				<td style="font-size:10px;"><%=caso_fecha_mod%>:<%=caso_hora_mod%></td>
				<td style="font-size:10px;"><%=caso_paso_macro%></td>
				<td style="font-size:10px;"><%=caso_sla%></td>
				<td style="font-size:10px;"><%=proveedor%></td>				
			</tr>
		<%rs.MoveNext
  		loop
  			rs.Close
  			set rs.ActiveConnection = nothing
  			set rs=nothing
  		%>	
		</tbody>
	</table>

	<script type="text/javascript">
		$(document).ready(function(){
			$('.casoTraking').click(function(){
				var idCaso = $(this).attr("data-idCaso");
				var idSucursal = $(this).attr("data-idSucursal");
				var div = 'detalleCaso';
            	var datos = 'tipo=3&arrCasos='+idCaso;
            	var pagina = 'personal/creagraficogestioncasos.asp';	
            	enviaDatos(pagina,div,datos);

            	$('#listaCasos').hide();
            	$('#detalleCaso').show('slow');

            	//alert("idCaso:"+idCaso+' idSucursal:'+idSucursal);
			});

			$('#tablaCasos').dataTable( {
				"iDisplayLength": 11,	
				"aaSorting": [[0, 'desc']],
				"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {
				"sLengthMenu": "_MENU_ registros por página",
				"paging":   false,
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
		});
	</script>	
<%	end if %>

<% end if %>

<% if tipo = "3" then 'DETALLE DE CASO POR ID %>
<%  
	arrCasos = request("arrCasos") 

	sql = ""
	sql = sql & "select z.*, case "
	sql = sql & "when z.id_caso_paso_macro = 5 and z.sla_diff <= z.caso_sla then 'DP'  "
	sql = sql & "when z.id_caso_paso_macro = 5 and z.sla_diff > z.caso_sla then 'FP' "
	sql = sql & "when z.id_caso_paso_macro <> 5 and z.sla_diff <= z.caso_sla then 'DP' "
	sql = sql & "when z.id_caso_paso_macro <> 5 and z.sla_diff > z.caso_sla then 'FP' "
	sql = sql & "end SLA "
	sql = sql & "from ( "
	sql = sql & "select "
	sql = sql & "E.id_sucursal, A.caso_id_sucursal, E.cod_bantotal, E.suc_nombre, A.id_caso, A.caso_titulo, A.caso_obs, B.caso_categoria, "
	sql = sql & "C.caso_motivo, isnull(A.caso_creado_por,0) as caso_creado_por, "
	sql = sql & "convert(varchar(12), isnull(A.caso_fecha_cre, getdate()), 105) as caso_fecha_cre, "
	sql = sql & "convert(varchar(12), isnull(A.caso_hora_cre, getdate()), 108) as caso_hora_cre, "
	sql = sql & "convert(varchar(12), isnull(A.caso_fecha_mod, getdate()), 105) as caso_fecha_mod, "
	sql = sql & "convert(varchar(12), isnull(A.caso_hora_mod, getdate()), 108) as caso_hora_mod, "
	sql = sql & "D.caso_paso_macro, D.id_caso_paso_macro, F.proveedor, C.caso_sla, "
	sql = sql & "case "
	sql = sql & "when A.id_caso_paso = 5 and cast(caso_fecha_cre as date) = cast(caso_fecha_mod as date) then "
	sql = sql & "datediff(minute, caso_hora_cre, caso_hora_mod) "
	sql = sql & "when A.id_caso_paso = 5 and cast(caso_fecha_cre as date) < cast(caso_fecha_mod as date) then "
	sql = sql & "datediff(minute, caso_hora_cre, caso_hora_mod ) + datediff(minute, caso_fecha_cre, cast(caso_fecha_mod as date)) "
	sql = sql & "when A.id_caso_paso <> 5 and cast(caso_fecha_cre as date) = cast(getdate() as date) then "
	sql = sql & "datediff(minute, caso_hora_mod, cast(getdate() as time)) "
	sql = sql & "when A.id_caso_paso <> 5 and cast(caso_fecha_cre as date) < cast(getdate() as date) then "
	sql = sql & "datediff(minute, caso_hora_mod, cast(getdate() as time)) + datediff(minute, caso_fecha_cre, cast(getdate() as date)) "
	sql = sql & "end SLA_DIFF, "
	sql = sql & "G.u_nombres, "
	sql = sql & "G.u_apellidos "
	sql = sql & "from SUC_casos A "
	sql = sql & "inner join SUC_sucursal E on A.caso_id_sucursal = E.id_sucursal "
	sql = sql & "inner join SUC_sucursal_proveedor F on E.cod_bantotal = F.cod_bantotal "
	sql = sql & "inner join SUC_casos_config_categoria B on A.caso_categoria = B.id_caso_categoria "
	sql = sql & "inner join SUC_casos_config_motivo C on A.caso_motivo = C.id_caso_motivo "
	sql = sql & "inner join SUC_casos_pasos_macro D on A.id_caso_paso = D.id_caso_paso_macro "
	sql = sql & "inner join SUC_usuario G on A.caso_creado_por = G.id_usuario "	
	sql = sql & ") as z "
	sql = sql & "where z.id_caso in ("& arrCasos &") "
	
	'response.write(sql)
	'response.end

	set casoDsMulti = db.execute(sql)
	if not casoDsMulti.EOF then
	%>
		<p>
			<!--<span class="label label-important"><i class="icon-book"></i> CASOS SELECCIONADOS</span>-->
			<a class="btn btn-primary smCasosvolver"><i class="icon-hand-left"></i> <span style="font-size: 10px"><strong>VOLVER</strong></span></a>
		</p>
	<% 
		do while not casoDsMulti.eof 
			caso_titulo = server.htmlencode(trim(casoDsMulti("caso_titulo")))
			caso_obs = trim(casoDsMulti("caso_obs"))
			caso_categoria = server.htmlencode(trim(casoDsMulti("caso_categoria")))
			caso_motivo = server.htmlencode(trim(casoDsMulti("caso_motivo")))
			caso_id_sucursal = server.htmlencode(trim(casoDsMulti("caso_id_sucursal")))
			caso_sucursal = server.htmlencode(trim(casoDsMulti("suc_nombre")))
			caso_fecha_cre = server.htmlencode(trim(casoDsMulti("caso_fecha_cre")))
			caso_hora_cre = server.htmlencode(trim(casoDsMulti("caso_hora_cre")))
			caso_fecha_mod = server.htmlencode(trim(casoDsMulti("caso_fecha_mod")))
			caso_hora_mod = server.htmlencode(trim(casoDsMulti("caso_hora_mod")))						

			usuarioIngreso = server.htmlencode(trim(casoDsMulti("u_nombres"))) & " " & server.htmlencode(trim(casoDsMulti("u_apellidos"))) 
			caso_paso_macro_head = trim(casoDsMulti("caso_paso_macro"))
			'caso_paso_macro_idHead = trim(casoDsMulti("id_caso_paso"))
	%>

			<p><span class="label label-info"><i class="icon-book"></i> DETALLE CASO</span></p>
			<table class="table table-bordered table-hover table-condensed">
				<thead>
					<tr>
						<th>Ingresado por: <%=usuarioIngreso%></th>
						<th>Fecha: <%=caso_fecha_cre%></th>
						<th>Hora: <%=caso_hora_cre%></th>
						<th>Sucursal: <%=caso_sucursal%></th>
					</tr>
					<tr>
						<th>T&iacute;tulo: <%=caso_titulo%></th>
						<th>Categor&iacute;a: <%=caso_categoria%></th>
						<th colspan="2">Motivo: <%=caso_motivo%></th>
					</tr>			
				</thead>
				<tbody>					
					<tr>
						<td colspan="4"><strong>Obs:</strong> <%=caso_obs%></td>
					</tr>			
				</tbody>
			</table>
			<div id="casoRespuestas"></div>

	<%	casoDsMulti.MoveNext
  	  	loop
	end if
%>	
	<script type="text/javascript">
		$(document).ready(function(){
			var div = 'casoRespuestas';
            var datos = 'tipo=4&idCaso=<%=arrCasos%>';
            var pagina = 'personal/cuadroControlGC_sql.asp';	
            enviaDatos(pagina,div,datos);

			$('.smCasosvolver').click(function(){				
				var div = 'listaCasos';
            	var datos = 'tipo=2&fecha=<%=caso_fecha_cre%>';
            	var pagina = 'personal/creagraficogestioncasos.asp';	
            	enviaDatos(pagina,div,datos);

                $('#detalleCaso').hide();
                $('#listaCasos').show().removeClass('oculto');
			})
		})
	</script>
<% end if %>


