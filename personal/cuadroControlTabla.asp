<!--#include file="../conexion/conexion.asp"-->
<%
	cargaCuadrocontrol = trim(request("cargaCuadrocontrol"))
	pagina = trim(request("pagina"))
	fechaRespaldo = trim(request("fechaRespaldo")) 
%>

<link href="../css/tablaSort.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../js/jquery.dataTables.js"></script>
<script type="text/javascript" src="../js/jquery.dataTables.bootstrap.js"></script>

<% if pagina = "1" then 'CONTROL TITULARES
	if cargaCuadrocontrol = "1" then 'CONTROL ONLINE %>
<%
	Dim prog2
	sql = ""	
	sql = sql & " select A.cod_bantotal, A.suc_nombre, A.titulares, "
	sql = sql & " A.titulares_presentes, A.titulares_ausentes, A.titulares_sinreg, "
	sql = sql & " A.titulares_atrasos, A.reemplazos, A.reemplazos_presentes, A.reemplazos_ausentes, A.reemplazos_sinreg, "
	sql = sql & " A.reemplazos_atrasos, A.cajeros_layout, A.proveedor, "	
	sql = sql & " B.suc_jeps, B.suc_jeps_enexo, B.suc_jeps_celular "
	sql = sql & " from vw_controlDetalleAsistenciaTitulares A "
	sql = sql & " INNER JOIN SUC_sucursal B ON A.cod_bantotal = B.cod_bantotal "
	sql = sql & " order by A.suc_nombre asc"

	'response.write(sql)
	'response.end()
	set prog2 = db.execute(sql)
%>

	<style type="text/css">
		 img.imgAlert{width: 12px; height: 12px;}				
	</style>
		<span class="label label-info titulo2 " id="titulo2" >CONTROL CAJEROS DIARIO DETALLE</span>
		<span class="label label-inverse titulo02 " id="titulo02" ><i> FORMULA: TOTAL TITULARES - (TITULARES PRESENTES + REEMPLAZOS PRESENTES) </i></span>
		<input type="hidden" id="ctrl_detalleOnline" value="" data-codSucusal="" />
		<table class="table table-bordered table-condensed tabDetalle  table-hover" id="tablaCuadroDetalle">
			<thead>
			<tr class="success">
				<th>Est.</th>
				<th>Diff.</th>
				<th>Cod BTT</th>								
				<th>Sucursal</th>
				<th>TIT</th>
				<th>TIT PRE</th>
				<th>TIT AU</th>
				<th>TIT SIN REG.</th>
				<th>TIT AT</th>
				<th>REMP</th>
				<th>REMP PRE</th>
				<th>REMP AU</th>
				<th>REMP SIN REG.</th>
				<th>REMP AT</th>
				<th>LAYOUT</th>
				<th>PROVEEDOR</th>
				<th>---</th>
				<th>---</th>
			</tr>
			</thead>
			<tbody>
			<%do until prog2.EOF
				cod_bantotal = prog2.Fields.Item("cod_bantotal").Value
				suc_nombre = server.htmlencode(Trim(prog2.Fields.Item("suc_nombre").Value))
				total_titulares = prog2.Fields.Item("titulares").Value
				total_titulares_presentes = prog2.Fields.Item("titulares_presentes").Value
				total_titulares_ausentes = prog2.Fields.Item("titulares_ausentes").Value
				total_titulares_sinreg = prog2.Fields.Item("titulares_sinreg").Value
				total_titulares_atrasos = prog2.Fields.Item("titulares_atrasos").Value
				total_reemplazos = prog2.Fields.Item("reemplazos").Value
				total_reemplazos_presentes = prog2.Fields.Item("reemplazos_presentes").Value
				total_reemplazos_ausentes = prog2.Fields.Item("reemplazos_ausentes").Value
				total_reemplazos_sinreg = prog2.Fields.Item("reemplazos_sinreg").Value
				total_reemplazos_atrasos = prog2.Fields.Item("reemplazos_atrasos").Value
				cajeros_layout = prog2.Fields.Item("cajeros_layout").Value
				proveedor = server.htmlencode(Trim(prog2.Fields.Item("proveedor").Value))

				jeps = server.htmlencode(Trim(prog2.Fields.Item("suc_jeps").Value))
				jeps_anexo = server.htmlencode(Trim(prog2.Fields.Item("suc_jeps_enexo").Value))
				jeps_celular = server.htmlencode(Trim(prog2.Fields.Item("suc_jeps_celular").Value))
			%>
			<tr class="" id="tr_sucursal_head<%=cod_bantotal%>">
				<% 'sumTituReem2 = (prog2.Fields.Item("titulares").Value - ( prog2.Fields.Item("titulares_presentes").Value + prog2.Fields.Item("reemplazos_presentes").Value )) %>
				<% sumTituReem2 = (total_titulares - ( total_titulares_presentes + total_reemplazos_presentes )) %>

			

				<%if sumTituReem2 <> 0 then %>
					<td><img src="../img/projo.png" class="imgAlert" align="center"></td>
				<%else%>
					<td><img src="../img/pverde.png" class="imgAlert" align="center"></td>
				<% end if %>

				<td><%=sumTituReem2%></td>
				<td><%=cod_bantotal%></td>									
				<td><i class="icon icon-exclamation-sign mano infosuc" data-toggle="tooltip" data-html="true" data-title="<b style='color:red;'>JEPS:&nbsp;</b><%=jeps%><br/><b style='color:red;'>ANEXO:&nbsp;</b><%=jeps_anexo%><br/><b style='color:red;'>CEL:&nbsp;</b><%=jeps_celular%>"></i>&nbsp;<span style="font-size:10px"><%=suc_nombre%></span></td>
				<td><%=total_titulares%></td>
				<td><%=total_titulares_presentes%></td>
				<td><%=total_titulares_ausentes%></td>
				<td><%=total_titulares_sinreg%></td>
				<td><%=total_titulares_atrasos%></td>
				<td><%=total_reemplazos%></td>
				<td><%=total_reemplazos_presentes%></td>
				<td><%=total_reemplazos_ausentes%></td>
				<td><%=total_reemplazos_sinreg%></td>
				<td><%=total_reemplazos_atrasos%></td>
				<td><%=cajeros_layout%></td>
				<td><%=proveedor%></td>
				<td>&nbsp;<i class="icon-file icon-large mano detalleOnline" data-tipoControl="T" data-codSucursal="<%=cod_bantotal%>"></i></td>
				<td>&nbsp;<i class="icon-calendar icon-large mano detalleDimen" data-codSucursal="<%=cod_bantotal%>"></i></td>
			</tr>			
			<%prog2.Movenext 
			Loop%>
			</tbody>
		</table>
		</span>
<%end if%>
<%if cargaCuadrocontrol = "2" then 'CONTROL RESPALDO %>
<%
			Dim prog3			
			sql = ""
			sql = sql & " SET dateformat dmy "
			sql = sql & " SELECT FECHA_RESPALDO, COD_BANTOTAL, "
			sql = sql & " SUC_NOMBRE, PROVEEDOR, TITULARES, TITULARES_PRESENTES, "
			sql = sql & " TITULARES_AUSENTES, TITULARES_SINREG, TITULARES_ATRASOS, "	
			sql = sql & " REEMPLAZOS, REEMPLAZOS_PRESENTES, REEMPLAZOS_AUSENTES, "	
			sql = sql & " REEMPLAZOS_SINREG, REEMPLAZOS_ATRASOS "	
			sql = sql & " FROM SUC_control_detalle_asistenciaTitulares "	
			sql = sql & " WHERE fecha_respaldo = '"&fechaRespaldo&"'"
			sql = sql & " ORDER BY SUC_NOMBRE ASC "

			'Response.Write(sql)
			'Response.End()
			set prog3 = db.execute(sql)
		%>
			<table class="table table-bordered table-hover table-condensed" id="tablaCuadroDetalle">
			<thead>
				<tr class="">
					<th>Fecha de Respaldo</th>
					<th>Sucursal</th>
					<th>Estado</th>
					<th>Presentes vs Dotación</th>					
					<th>Titulares</th>	
					<th>Titulares Presentes</th>				
					<th>Titulares Ausentes</th>
					<th>Titulares Sin Registros</th>
					<th>Titulares Atrasos</th>
					<th>Reemplazos</th>
					<th>Reemplazos Presentes</th>
					<th>Reemplazos Ausentes</th>
					<th>Reemplazos Sin Registros</th>
					<th>Reemplazos Atrasos</th>	
					<th>--</th>				
				</tr>
				</thead>
				<tbody>
				<%do until prog3.EOF%>
				<tr class="">
					<% sumTituReem2 = (prog3("titulares") - ( prog3("titulares_presentes") + prog3("reemplazos_presentes"))) %>

					<style type="text/css">
						 img.imgAlert{width: 12px; height: 12px;}				
					</style>
					<td><%=prog3("fecha_respaldo")%></td>
					<td><%=prog3("suc_nombre")%></td>
					<%if sumTituReem2 <> 0 then %>
						<td><img src="../img/projo.png" class="imgAlert"></td>
					<%else%>
						<td><img src="../img/pverde.png" class="imgAlert"></td>
					<% end if %>
					<td><%=sumTituReem2%></td>					
					<td><%=prog3("titulares")%></td>
					<td><%=prog3("titulares_presentes")%></td>
					<td><%=prog3("titulares_ausentes")%></td>
					<td><%=prog3("titulares_sinreg")%></td>
					<td><%=prog3("titulares_atrasos")%></td>
					<td><%=prog3("reemplazos")%></td>
					<td><%=prog3("reemplazos_presentes")%></td>
					<td><%=prog3("reemplazos_ausentes")%></td>
					<td><%=prog3("reemplazos_sinreg")%></td>
					<td><%=prog3("reemplazos_atrasos")%></td>	
					<td>						
						<i class="icMostrarDetalleMes icon-file icon-large mano" id="icMostrarDetalleMes" data-codBantotal="<%=prog3("COD_BANTOTAL")%>" data-tipoControl="T" data-fecha="<%=prog3("fecha_respaldo")%>"></i>
					</td>
				<%prog3.Movenext 
				Loop%>
				</tbody>
			</table>
			<script type="text/javascript">
				$(document).ready(function(){
					$('.icMostrarDetalleMes').click(function(){
						var fechaRespaldo = $(this).attr('data-fecha');
						var codSucursal = $(this).attr('data-codBantotal');

						var div = 'dvDetalleDiarioRespaldo';
						var pagina = 'asistenciaSucursal_view.asp';
						var datos = 'tipoControl=1&tipo=2&codBantotal=' + codSucursal + '&fechaRespaldo=' + fechaRespaldo;
						enviaDatos(pagina,div,datos);

						$('#dvDetalleDiarioRespaldoTabla').slideUp();
						$('#dvDetalleDiarioRespaldo').slideDown();

						$('#AdRespTitulos').removeClass('oculto').show('slow');
						$('#btnOcultarDetalleRespaldo').removeClass('oculto').show('slow');
						$('#btnDescargarDetalle').hide('slow').addClass('oculto');
					});	
				});
			</script>
	<%end if%>
<%end if%>

<%if pagina = "2" then 'CONTROL ADICIONALES
	if cargaCuadrocontrol = "1" then
			sql = ""	
			sql = sql & " SELECT B.COD_BANTOTAL, B.SUC_NOMBRE, isnull(A.TOTAL_ADICIONALES,0) as TOTAL_ADICIONALES, "
			sql = sql & " isnull(A.ADICIONALES_PRESENTES,0) as ADICIONALES_PRESENTES, "
			sql = sql & " isnull(A.ADICIONALES_AUSENTES,0) as ADICIONALES_AUSENTES, "
			sql = sql & " B.suc_jeps, B.suc_jeps_enexo, B.suc_jeps_celular, "
			sql = sql & " isnull(A.ADICIONALES_SIN_REGISTROS, 0) as ADICIONALES_SIN_REGISTROS, A.proveedor, "
			sql = sql & " isnull((select C.NRO_ADICIONAL "
			sql = sql & " from SUC_sucursal_cajeros_dimen C "
			sql = sql & " where C.FECHA = cast(getdate() as date) and "
			sql = sql & " C.COD_BANTOTAL = B.COD_BANTOTAL),0) as dimen "
			sql = sql & " FROM vw_controlDetalleAsistenciaAdicional AS A "
			sql = sql & " INNER JOIN SUC_SUCURSAL AS B ON "
			sql = sql & " A.COD_BANTOTAL = B.COD_BANTOTAL "					
			'Response.Write(sql)
			'Response.End()
			set prog2 = db.execute(sql)
		%>
		<table class="table table-bordered table-condensed tabDetalle table-hover" id="tablaCuadroDetalle">
		<thead>
			<tr class="">
				<th>Estado</th>
				<th>Diff TOTAL vs PRE</th>
				<th>Alert Dimen.</th>
				<th>Diff Dimen.</th>		
				<th>Cod BTT</th>
				<th>Sucursal</th>
				<th>Dimen.</th>
				<th>Total AD.</th>
				<th>AD. PRE</th>	
				<th>AD. AU</th>
				<th>AD. SIN REG.</th>
				<th>Proveedor</th>
				<th>---</th>
				<th>---</th>
			</tr>
			</thead>
			<tbody>
			<%do until prog2.EOF		
				cod_bantotal = prog2("COD_BANTOTAL")
				suc_nombre = server.htmlencode(Trim(prog2("SUC_NOMBRE")))
				total_adicionales = prog2("TOTAL_ADICIONALES")
				total_presentes = prog2("ADICIONALES_PRESENTES")
				total_ausentes = prog2("ADICIONALES_AUSENTES")
				total_sinreg = prog2("ADICIONALES_SIN_REGISTROS")
				'response.end

				proveedor = prog2("proveedor")

				dimen = Trim(prog2("dimen"))

				jeps = server.htmlencode(Trim(prog2("suc_jeps")))
				jeps_anexo = server.htmlencode(Trim(prog2("suc_jeps_enexo")))
				jeps_celular = server.htmlencode(Trim(prog2("suc_jeps_celular")))

				formula_adicionales = Cint(total_adicionales) - Cint(total_presentes)
				formula_dimen = Cint(dimen)-Cint(total_presentes)
			%>
			<tr class="" id="tr_adOn_sucursal_head<%=cod_bantotal%>">				
				<td>
					<%if formula_adicionales <> 0 then %>
						<img src="../img/projo.png" class="imgAlert">
					<%else%>
						<img src="../img/pverde.png" class="imgAlert">
					<% end if %>
				</td>
				<td><%=formula_adicionales%></td>
				<td>
					<%if formula_dimen <> 0 then %>
						<img src="../img/pamarillo.png" class="imgAlert">
					<%else%>
						<img src="../img/pverde.png" class="imgAlert">
					<% end if %>
				</td>
				<td><%=formula_dimen%></td>				
				<td><%=cod_bantotal%></td>
				<td><i class="icon icon-exclamation-sign mano infosuc" data-toggle="tooltip" data-html="true" data-title="<b style='color:red;'>JEPS:&nbsp;</b><%=jeps%><br/><b style='color:red;'>ANEXO:&nbsp;</b><%=jeps_anexo%><br/><b style='color:red;'>CEL:&nbsp;</b><%=jeps_celular%>"></i>&nbsp;<span style="font-size:10px"><%=suc_nombre%></span></td>
				<td><%=dimen%></td>	
				<td><%=total_adicionales%></td>
				<td><%=total_presentes%></td>
				<td><%=total_ausentes%></td>
				<td><%=total_sinreg%></td>
				<td><%=proveedor%></td>
				<td>&nbsp;<i class="icon-file icon-large mano detalleOnline" data-tipoControl="A" data-codSucursal="<%=cod_bantotal%>"></i></td>
				<td>&nbsp;<i class="icon-calendar icon-large mano detalleDimen" data-codSucursal="<%=cod_bantotal%>"></i></td>
			</tr>
			<%prog2.Movenext 
			Loop%>
			</tbody>
		</table>
<%	end if
	if cargaCuadrocontrol = "2" then
		sql = ""
		sql = sql & "SET dateformat dmy "
		sql = sql & "SELECT FECHA_RESPALDO, "
		sql = sql & "COD_BANTOTAL, "
		sql = sql & "SUC_NOMBRE, "
		sql = sql & "TOTAL_ADICIONALES, "
		sql = sql & "ADICIONALES_PRESENTES, "
		sql = sql & "ADICIONALES_AUSENTES, "
		sql = sql & "ADICIONALES_SIN_REGISTROS, "
		sql = sql & "PROVEEDOR "
		sql = sql & "FROM dbo.vw_controlDetalleAsistenciaAdicionalMes "
		sql = sql & "WHERE fecha_respaldo = '"& fechaRespaldo &"' "	

		'Response.write(sql)
		'response.end()
		set prog6 = db.execute(sql)
	%>	
		<table class="table table-bordered table-condensed table-hover tabDetalle" id="tablaCuadroDetalle">
		<thead>
		<tr class="">
			<th>Fecha</th>
			<th>Estado</th>
			<th>Presentes vs Dotacion</th>							
			<th>Cod Bantotal</th>
			<th>Sucursal</th>
			<th>Total Adicionales</th>
			<th>Adicionales Presentes</th>	
			<th>Adicionales Ausentes</th>
			<th>Adicionales Sin Registros</th>
			<th>Proveedor</th>
			<th>---</th>
		</tr>
		</thead>
		<%do until prog6.EOF
			fecha_respaldo = prog6("FECHA_RESPALDO")
			cod_bantotal = prog6("COD_BANTOTAL")
			suc_nombre = prog6("SUC_NOMBRE")
			total_adicionales = prog6("TOTAL_ADICIONALES")
			total_presentes = prog6("ADICIONALES_PRESENTES")
			total_ausentes = prog6("ADICIONALES_AUSENTES")
			total_sinreg = prog6("ADICIONALES_SIN_REGISTROS")
			proveedor = prog6("proveedor")

			formula_adicionales = Cint(total_adicionales) - Cint(total_presentes)
		%>
		<style type="text/css">
			 img.imgAlert{width: 12px; height: 12px;}				
		</style>
		<tbody>
		<tr class="" id="tr_adOn_sucursal_head<%=cod_bantotal%>">
			<td><%=fecha_respaldo%></td>
			<td>
				<%if formula_adicionales <> 0 then %>
					<img src="../img/projo.png" class="imgAlert">
				<%else%>
					<img src="../img/pverde.png" class="imgAlert">
				<% end if %>
			</td>
			<td><%=formula_adicionales%></td>				
			<td><%=cod_bantotal%></td>
			<td><%=suc_nombre%></td>
			<td><%=total_adicionales%></td>
			<td><%=total_presentes%></td>
			<td><%=total_ausentes%></td>
			<td><%=total_sinreg%></td>
			<td><%=proveedor%></td>
			<td>&nbsp;<i class="icon-file icon-large mano detalleAdicionalMesRespaldo" data-fechaRespaldo="<%=fecha_respaldo%>" data-codSucursal="<%=cod_bantotal%>"></i></td>
		</tr>		
		<%prog6.Movenext 
		Loop%>
		</tbody>
	</table>
	<script type="text/javascript">
		$(document).ready(function(){
			$('.detalleAdicionalMesRespaldo').click(function(){			
				var codSucursal = $(this).attr('data-codSucursal');
				var fechaRespaldo = $(this).attr('data-fechaRespaldo');				

				var div = 'dvAdicionalesRespaldoDetalle';
				var pagina = 'asistenciaSucursal_view.asp';
				var datos = 'tipoControl=2&tipo=2&codBantotal=' + codSucursal + '&fechaRespaldo=' + fechaRespaldo;
				enviaDatos(pagina,div,datos);

				$('#dvAdicionalesRespaldo').slideUp();
				$('#dvAdicionalesRespaldoDetalle').slideDown();
				$('#btnOcultarDetalleRespaldo').removeClass('oculto').show('slow');
			});
		});
	</script>
<%	end if 
  end if%>


<script type="text/javascript">
	$(function(){		
		$('#tablaCuadroDetalle').dataTable( {
			"iDisplayLength": 300,
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

		$('.infosuc').tooltip();

		$('.detalleDimen').click(function(){
			var cod_sucursal = $(this).attr('data-codSucursal');
			var div = 'muestraDetalleDimen';
			var datos = 'tipoDimen=1&codBantotal='+cod_sucursal;
			var pagina = 'cuadroControlDimen.asp';

			enviaDatos(pagina,div,datos);
			$('#muestraDetalle').slideUp();
			$('#muestraDetalleDimen').removeClass('oculto');
			$('#muestraDetalleDimen').slideDown();
			$('#divBotones').hide();
		});

		$('.detalleOnline').click(function(){			
			var div_open = $('#ctrl_detalleOnline').attr('data-codSucusal');
			var tipo_control = $(this).attr('data-tipoControl');
			var cod_sucursal = $(this).attr('data-codSucursal');
			
			$('#muestraDetalle').slideUp();

			var tipoControl = '';
			if(tipo_control == 'A'){
				tipoControl = '2';
			}else{
				tipoControl = '1';
			}

			var div = 'muestraDetalleSucursalOnline';
			var pagina = 'asistenciaSucursal_view.asp';
			var datos = 'tipoControl='+tipoControl+'&tipo=1&codBantotal=' + cod_sucursal;
			enviaDatos(pagina,div,datos);
			$('#muestraDetalleSucursal').show();
			$('#muestraDetalleSucursal').slideDown();

			$('.btnOcultarDetalle').removeClass('oculto').show('slow');
			$('.btnDescargarDetalle').addClass('oculto').hide('slow');
		});

		$('#btnOcultarDetalle').click(function(){			
			$('#muestraDetalle').slideDown();
			$('#muestraDetalleSucursalOnline').html('');
			$('#muestraDetalleSucursal').slideUp();	

			$('.btnDescargarDetalle').removeClass('oculto').show('slow');

			$(this).hide('slow');
			setTimeout(function(){
				$(this).addClass('oculto');
			}, 1500);
			
		});

		$('#btnOcultarDetalleRespaldo').click(function(){						
			$('#dvAdicionalesRespaldoDetalle').html('');
			$('#dvAdicionalesRespaldoDetalle').slideUp();	
			$('#dvAdicionalesRespaldo ').slideDown();

			$('#btnDescargarDetalle').removeClass('oculto').show('slow');

			$(this).hide('slow');
			setTimeout(function(){
				$(this).addClass('oculto');
			}, 1500);
			
		});
	})
</script>