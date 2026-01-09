<!--#include file="../conexion/conexion.asp"-->
<%
	cargaCuadrocontrol = request("cargaCuadrocontrol")
	fechaRespaldo = request("fechaRespaldo")
%>

<% if cargaCuadrocontrol = "3" then %>
<div>
	<a class="btn btn-danger btnOcultarDetalleMes" id="btnOcultarDetalleMes">
		<i></i>
		&nbsp;<span class="bajaLetra"><b>CERRAR DETALLE <%=fechaRespaldo%></b></span>
	</a>
</div>
<input type="hidden" id="fechaRespaldo" value="<%=fechaRespaldo%>"/>
<link href="../css/tablaSort.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../js/jquery.dataTables.js"></script>
<script type="text/javascript" src="../js/jquery.dataTables.bootstrap.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		$('.btnOcultarDetalleMes').click(function(){			
			$('.dvControlCierresDelMesDetalle').slideUp();
			$('.dvControlCierresDelMes').slideDown();
		});
	});
</script>
<%		
	Dim prog5
	sql = ""
	sql = sql & " SET dateformat dmy "
	sql = sql & " SELECT "
	sql = sql & " FECHA_RESPALDO, PROVEEDOR, SUM(TITULARES) AS titulares, "
	sql = sql & " SUM(TITULARES_PRESENTES) AS titulares_presentes, "
	sql = sql & " SUM(TITULARES_AUSENTES) AS titulares_ausentes, "
	sql = sql & " SUM(TITULARES_SINREG) AS titulares_sinreg, "
	sql = sql & " SUM(TITULARES_ATRASOS) AS titulares_atrasos, "
	sql = sql & " SUM(REEMPLAZOS) AS reemplazos, "
	sql = sql & " SUM(REEMPLAZOS_PRESENTES) AS reemplazos_presentes, "
	sql = sql & " SUM(REEMPLAZOS_AUSENTES) AS reemplazos_ausentes, "
	sql = sql & " SUM(REEMPLAZOS_SINREG) AS reemplazos_sinreg, "
	sql = sql & " SUM(REEMPLAZOS_ATRASOS) AS reemplazos_atrasos "
	sql = sql & " FROM dbo.SUC_control_detalle_asistenciaTitulares "
	sql = sql & " WHERE FECHA_RESPALDO = '"&fechaRespaldo&"' "
	sql = sql & " GROUP BY FECHA_RESPALDO, PROVEEDOR "
	set prog5 = db.execute(sql)
%>
	<span class="label label-info titulo4" id="titulo4"><%=fechaRespaldo%> RESUMEN PROVEEDOR</span>
	<span class="label label-inverse titulo04" id="titulo04" ><i>FORMULA: TOTAL TITULARES - (TITULARES PRESENTES + REEMPLAZOS PRESENTES)</i></span>
	
	<br/>
	<table class="table table-bordered table-condensed tbControlDetalleMesProveedor table-hover" id="tbControlDetalleMesProveedor">
		<tr class="info">
			<th>Fecha de Respaldo</th>
			<th>Proveedor</th>
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
		</tr>
		<%do until prog5.EOF%>
		<tr class="info">

			<% sumTituReem4 = (prog5.Fields.Item("titulares").Value - ( prog5.Fields.Item("titulares_presentes").Value + prog5.Fields.Item("reemplazos_presentes").Value )) %>

			<style type="text/css">
				 img.imgAlert{width: 12px; height: 12px;}				
			</style>

			<td><%=prog5.Fields.Item("fecha_respaldo").Value%></td>
			<td><%=prog5.Fields.Item("PROVEEDOR").Value%></td>
			<%if sumTituReem4 <> 0 then %>
				<td><img src="../img/projo.png" class="imgAlert"></td>
			<%else%>
				<td><img src="../img/pverde.png" class="imgAlert"></td>
			<% end if %>
			<td><%=sumTituReem4%></td>			
			<td><%=prog5.Fields.Item("titulares").Value%></td>
			<td><%=prog5.Fields.Item("titulares_presentes").Value%></td>
			<td><%=prog5.Fields.Item("titulares_ausentes").Value%></td>
			<td><%=prog5.Fields.Item("titulares_sinreg").Value%></td>
			<td><%=prog5.Fields.Item("titulares_atrasos").Value%></td>
			<td><%=prog5.Fields.Item("reemplazos").Value%></td>
			<td><%=prog5.Fields.Item("reemplazos_presentes").Value%></td>
			<td><%=prog5.Fields.Item("reemplazos_ausentes").Value%></td>
			<td><%=prog5.Fields.Item("reemplazos_sinreg").Value%></td>
			<td><%=prog5.Fields.Item("reemplazos_atrasos").Value%></td>					
		<%prog5.Movenext 
		Loop%>
	</table>	
<%
	Dim prog4
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
	set prog4 = db.execute(sql)
%>
	<div>
		<a class="btn btn-success btnMostrarDetalle" id="btnMostrarDetalle">
			<i class="icon-user icon-large"></i>
			&nbsp;<span class="bajaLetra"><b>MOSTRAR DETALLE</b></span>
		</a>

		<a class="btn btn-primary btnDescargarDetalle" id="btnDescargarDetalle">
			<i class="icon-save icon-large"></i>
			&nbsp;<span class="bajaLetra"><b>DESCARGAR</b></span>
		</a>

		<a class="btn btn-danger btnOcultarDetalleRespaldo oculto" id="btnOcultarDetalleRespaldo">
			<i></i>
			&nbsp;<span class="bajaLetra"><b>CERRAR DETALLE</b></span>
		</a>
	</div>
	<br/>
	<div class="oculto" id="AdRespTitulos">
		<span class="label label-info titulo4" id="titulo4"><%=fechaRespaldo%> CONTROL CAJEROS DETALLE</span>
		<span class="label label-inverse titulo04" id="titulo04" ><i>FORMULA: TOTAL TITULARES - (TITULARES PRESENTES + REEMPLAZOS PRESENTES)</i></span>	
	</div>	
	<div id="dvDetalleDiarioRespaldoTabla"></div>
	<div id="dvDetalleDiarioRespaldo"></div>
	<script type="text/javascript">
		$(document).ready(function(){
			$('.btnMostrarDetalle').click(function(){
				var fechaRespaldo = $('#fechaRespaldo').val();

				var div = 'dvDetalleDiarioRespaldoTabla';
				var pagina = 'cuadroControlTabla.asp';
				var datos = 'pagina=1&cargaCuadrocontrol=2&fechaRespaldo=' + fechaRespaldo;
				enviaDatos(pagina,div,datos);	

				$('#AdRespTitulos').removeClass('oculto').show('slow');					
			});	
			$('#btnOcultarDetalleRespaldo').click(function(){
				$('#dvDetalleDiarioRespaldo').slideUp();
				$('#dvDetalleDiarioRespaldoTabla').slideDown();
			});
		});
	</script>
	<script type="text/javascript">
		$(function(){
			$('#tbControlDetalleMes').dataTable( {
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
		});
		$('.detalleDiarioRespaldo').click(function(){			
			var codSucursal = $(this).attr('data-codSucursal');
			var fechaRespaldo = $(this).attr('data-fechaRespaldo');			

			var div = 'dvDetalleDiarioRespaldo';
			var pagina = 'asistenciaSucursal_view.asp';
			var datos = 'tipoControl=1&tipo=2&codBantotal=' + codSucursal + '&fechaRespaldo=' + fechaRespaldo;

			$('#dvDetalleDiarioRespaldoTabla').slideUp();
			enviaDatos(pagina,div,datos);			
			$('#dvDetalleDiarioRespaldo').slideDown();
		});
	</script>
<% end if%>

<% if cargaCuadrocontrol = "4" then 
	Dim prog9
	sql = ""	
	sql = sql & " select  cod_bantotal,suc_nombre,titulares, "
	sql = sql & " titulares_presentes,titulares_ausentes,titulares_sinreg, "
	sql = sql & " titulares_atrasos,reemplazos, reemplazos_presentes, reemplazos_ausentes,reemplazos_sinreg, "
	sql = sql & " reemplazos_atrasos, cajeros_layout, proveedor "
	sql = sql & " from vw_controlDetalleAsistenciaTitulares "
	sql = sql & " order by suc_nombre asc "	
	set prog9 = db.execute(sql)
%>		
<table border="1">
	<tr>
		<th style="background-color:blue;color:#FFFFFF;">Estado</th>
		<th style="background-color:blue;color:#FFFFFF;">Presentes vs Dotacion</th>
		<th style="background-color:blue;color:#FFFFFF;">Cod BTT</th>
		<th style="background-color:blue;color:#FFFFFF;">Sucursal</th>
		<th style="background-color:blue;color:#FFFFFF;">Titulares</th>
		<th style="background-color:blue;color:#FFFFFF;">Titulares Presentes</th>
		<th style="background-color:blue;color:#FFFFFF;">Titulares Ausentes</th>
		<th style="background-color:blue;color:#FFFFFF;">Titulares Sin Reg.</th>
		<th style="background-color:blue;color:#FFFFFF;">Titulares Atrasos</th>
		<th style="background-color:blue;color:#FFFFFF;">Reemplazos</th>
		<th style="background-color:blue;color:#FFFFFF;">Reemplazos Presentes</th>
		<th style="background-color:blue;color:#FFFFFF;">Reemplazos Ausentes</th>
		<th style="background-color:blue;color:#FFFFFF;">Reemplazos Sin Reg.</th>
		<th style="background-color:blue;color:#FFFFFF;">Reemplazos Atrasos</th>
		<th style="background-color:blue;color:#FFFFFF;">Cajeros Layout</th>
		<th style="background-color:blue;color:#FFFFFF;">Proveedor</th>
	</tr>
	<%do until prog9.EOF
		cod_bantotal = prog9("cod_bantotal")
		suc_nombre = server.htmlencode(Trim(prog9("suc_nombre")))
		total_titulares = prog9("titulares")
		total_titulares_presentes = prog9("titulares_presentes")
		total_titulares_ausentes = prog9("titulares_ausentes")
		total_titulares_sinreg = prog9("titulares_sinreg")
		total_titulares_atrasos = prog9("titulares_atrasos")
		total_reemplazos = prog9("reemplazos")
		total_reemplazos_presentes = prog9("reemplazos_presentes")
		total_reemplazos_ausentes = prog9("reemplazos_ausentes")
		total_reemplazos_sinreg = prog9("reemplazos_sinreg")
		total_reemplazos_atrasos = prog9("reemplazos_atrasos")
		cajeros_layout = prog9("cajeros_layout")
		proveedor = server.htmlencode(Trim(prog9("proveedor")))
	%>
	<tr>	
		<% sumTituReem2 = (total_titulares - ( total_titulares_presentes + total_reemplazos_presentes )) %>		

		<%if sumTituReem2 <> 0 then %>
			<td>NO OK</td>
		<%else%>
			<td>OK</td>
		<% end if %>

		<td><%=sumTituReem2%></td>
		<td><%=cod_bantotal%></td>									
		<td><%=suc_nombre%></td>									
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
	</tr>	
	<%prog9.Movenext 
	Loop%>
</table>
<%
	Response.Buffer = TRUE
	Response.Charset = "UTF-8"
	Response.ContentType = "application/vnd.ms-excel" 
	Response.AddHeader "Content-Disposition", "attachment; filename=Titulares_CControl.xls" 
end if%>

<% if cargaCuadrocontrol = "5" then %>

	<%
		Dim prog10
		sql = ""	
		sql = sql & " SELECT B.COD_BANTOTAL, B.SUC_NOMBRE, TOTAL_ADICIONALES, "
		sql = sql & " ADICIONALES_PRESENTES, ADICIONALES_AUSENTES, "
		sql = sql & " ADICIONALES_SIN_REGISTROS, proveedor "
		sql = sql & " FROM vw_controlDetalleAsistenciaAdicional AS A"
		sql = sql & " INNER JOIN SUC_SUCURSAL AS B ON"
		sql = sql & " A.COD_BANTOTAL = B.COD_BANTOTAL"					
		'Response.Write(sql)
		'Response.End()
		set prog10 = db.execute(sql)
	%>			
	<table border="1">
		<tr>
			<th style="background-color:blue;color:#FFFFFF;">Estado</th>
			<th style="background-color:blue;color:#FFFFFF;">Presentes vs Dotacion</th>
			<th style="background-color:blue;color:#FFFFFF;">Cod BTT</th>
			<th style="background-color:blue;color:#FFFFFF;">Sucursal</th>
			<th style="background-color:blue;color:#FFFFFF;">Total Adicionales</th>
			<th style="background-color:blue;color:#FFFFFF;">Adicionales Presentes</th>
			<th style="background-color:blue;color:#FFFFFF;">Adicionales Ausentes</th>
			<th style="background-color:blue;color:#FFFFFF;">Adicionales Sin Registros</th>
			<th style="background-color:blue;color:#FFFFFF;">Proveedor</th>
		</tr>
		<%do until prog10.EOF		
			cod_bantotal = prog10("COD_BANTOTAL")
			suc_nombre = server.htmlencode(Trim(prog10("SUC_NOMBRE")))
			total_adicionales = prog10("TOTAL_ADICIONALES")
			total_presentes = prog10("ADICIONALES_PRESENTES")
			total_ausentes = prog10("ADICIONALES_AUSENTES")
			total_sinreg = prog10("ADICIONALES_SIN_REGISTROS")
			proveedor = prog10("proveedor")

			formula_adicionales = Cint(total_adicionales) - Cint(total_presentes)
		%>
		<tr>
			<td>
				<%if formula_adicionales <> 0 then %>
					NO OK
				<%else%>
					OK
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
		</tr>		
		<%prog10.Movenext 
		Loop%>
	</table>
<%
	Response.Buffer = TRUE
	Response.Charset = "UTF-8"
	Response.ContentType = "application/vnd.ms-excel" 
	Response.AddHeader "Content-Disposition", "attachment; filename=Adicionales_CControl.xls" 
end if%>

<% if cargaCuadrocontrol = "7" then
		sql = ""
		sql = sql & "select cod_bantotal, "
		sql = sql & "suc_nombre, "
		sql = sql & "nro_adicional, "
		sql = sql & "fecha, "
		sql = sql & "proveedor "
		sql = sql & "from SUC_sucursal_cajeros_dimen "
		sql = sql & "where year(fecha) = year(getdate()) and "
		sql = sql & "month(fecha) = month(getdate()) "
		sql = sql & "order by fecha, suc_nombre "

		set downDimen = db.execute(sql)
		if not downDimen.EOF then
%>
		<table border="1">
			<tr>
				<th style="background-color:blue;color:#FFFFFF;">PROVEEDOR</th>
				<th style="background-color:blue;color:#FFFFFF;">COD BTT</th>
				<th style="background-color:blue;color:#FFFFFF;">SUCURSAL</th>
				<th style="background-color:blue;color:#FFFFFF;">NRO ADICIONAL</th>
				<th style="background-color:blue;color:#FFFFFF;">FECHA</th>
			</tr>
			<%do until downDimen.EOF %>
			<tr>
				<td><%=downDimen("proveedor")%></td>
				<td><%=downDimen("cod_bantotal")%></td>
				<td><%=downDimen("suc_nombre")%></td>
				<td><%=downDimen("nro_adicional")%></td>
				<td><%=downDimen("fecha")%></td>
			</tr>
			<%downDimen.Movenext 
				Loop%>
		</table>
<%		end if
	Response.Buffer = TRUE
	Response.Charset = "UTF-8"
	Response.ContentType = "application/vnd.ms-excel" 
	Response.AddHeader "Content-Disposition", "attachment; filename=dimensionamiento.xls" 
   end if
%>

<% 
cargaCuadrocontrol = request.form("cargaCuadrocontrol")
if cargaCuadrocontrol = "6" then 'GUARDAR DIMENSIONAMIENTO 
	xmlData = request.form("xmlData")
	codBantotal = request.form("codBantotal")	
	userwin = request.form("userwin")
	sql = ""
	sql = sql & "exec SUC_prc_dimen_ing @codBantotal="&codBantotal&", @xml='"&xmlData&"', @userwin='"&userwin&"'"
	'response.Write(sql)
	'response.end()

	db.execute(sql)	
 end if %>


