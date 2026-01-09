<!--#include file="../conexion/conexion.asp"-->
    
<span class="">
<%
	carga = request("carga")
	cargaCuadrocontrol = request("cargaCuadrocontrol")
%>
	<input type="hidden" name="fecha_reg" id="fecha_reg" class="cfecha_reg" value="0"/>
	<input type="hidden" name="carga" id="carga" class="carga" value="<%=carga%>"/>
	<input type="hidden" name="cargaCuadrocontrol" id="cargaCuadrocontrol" class="cargaCuadrocontrol" value="<%=cargaCuadrocontrol%>"/>
<div id="controlCentral" class="controlCentral">
<% if cargaCuadrocontrol = "1" then %>	    
	<div class="dvControlOnline" id="dvControlOnline">
		<%
			Dim prog1
			sql = ""	
			sql = sql & " select SUM(titulares) as titulares, "
			sql = sql & " SUM(titulares_presentes) as titulares_presentes, "
			sql = sql & " SUM(titulares_ausentes) as titulares_ausentes, "	
			sql = sql & " SUM(titulares_sinreg) as titulares_sinreg, "	
			sql = sql & " SUM(titulares_atrasos) as titulares_atrasos, "	
			sql = sql & " SUM(reemplazos) as reemplazos, "	
			sql = sql & " SUM(reemplazos_presentes) as reemplazos_presentes, "	
			sql = sql & " SUM(reemplazos_ausentes) as reemplazos_ausentes, "	
			sql = sql & " SUM(reemplazos_sinreg) as reemplazos_sinreg, "	
			sql = sql & " SUM(reemplazos_atrasos) as reemplazos_atrasos, "	
			sql = sql & " SUM(cajeros_layout) as cajeros_layout,proveedor "	
			sql = sql & " from vw_controlDetalleAsistenciaTitulares "	
			sql = sql & " group by proveedor "	
			'Response.Write(sql)
			'Response.End()
			set prog1 = db.execute(sql)
		%>

		<span class="label label-info titulo1" id="titulo1">CONTROL CAJEROS DIARIO</span>
		<span class="label label-inverse titulo01" id="titulo01" ><i> FORMULA: TOTAL TITULARES - (TITULARES PRESENTES + REEMPLAZOS PRESENTES) </i></span>
		<table class="table table-bordered table-hover table-condensed" style="margin-bottom:10px;">
			<thead>
				<tr class="success">
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
					<th>Cajeros Layout</th>
					<th>Proveedor</th>				
				</tr>
			</thead>
			<tbody>
				<%do until prog1.EOF%>
				<tr class="info">
					<% sumTituReem = (prog1("titulares") - (prog1("titulares_presentes") + prog1("reemplazos_presentes"))) %>
					<style type="text/css">
						 img.imgAlert{width: 12px; height: 12px;}				
					</style>
					<%if sumTituReem <> 0 then %>
						<td><img src="../img/projo.png" class="imgAlert"></td>
					<%else%>
						<td><img src="../img/pverde.png" class="imgAlert"></td>
					<% end if %>
					<td><%=sumTituReem%></td>
					<td><%=prog1("titulares")%></td>
					<td><%=prog1("titulares_presentes")%></td>
					<td><%=prog1("titulares_ausentes")%></td>
					<td><%=prog1("titulares_sinreg")%></td>
					<td><%=prog1("titulares_atrasos")%></td>
					<td><%=prog1("reemplazos")%></td>
					<td><%=prog1("reemplazos_presentes")%></td>
					<td><%=prog1("reemplazos_ausentes")%></td>
					<td><%=prog1("reemplazos_sinreg")%></td>
					<td><%=prog1("reemplazos_atrasos")%></td>
					<td><%=prog1("cajeros_layout")%></td>
					<td><%=prog1("proveedor")%></td>				
				<%prog1.Movenext 
				Loop%>
			</tbody>
		</table>
	</div>	
	<div>
		<a class="btn btn-success btnMostrarDetalle" id="btnMostrarDetalle">
			<i class="icon-user icon-large"></i>
			&nbsp;<span class="bajaLetra"><b>MOSTRAR DETALLE</b></span>
		</a>
		<a class="btn btn-primary btnDescargarDetalle" id="btnDescargarDetalle">
			<i class="icon-save icon-large"></i>
			&nbsp;<span class="bajaLetra"><b>DESCARGAR</b></span>
		</a>
		<a class="btn btn-danger btnOcultarDetalle oculto" id="btnOcultarDetalle">
			<i></i>
			&nbsp;<span class="bajaLetra"><b>CERRAR DETALLE</b></span>
		</a>
	</div><br/>	
	<div id="muestraDetalle"></div>
	<div id="muestraDetalleSucursal">			
		<div id="muestraDetalleSucursalOnline"></div>
	</div>
	<div class="muestraDetalleDimen oculto" id="muestraDetalleDimen"></div>
<%end if%>

<% if cargaCuadrocontrol = "2" then %> 
	<div class="dvControlCierresDelMes" id="dvControlCierresDelMes">
		<%
			Dim prog3
			sql = ""	
			sql = sql & " SELECT fecha_respaldo, "
			sql = sql & " titulares, "
			sql = sql & " titulares_presentes, "	
			sql = sql & " titulares_ausentes, "	
			sql = sql & " titulares_sinreg, "	
			sql = sql & " titulares_atrasos, "	
			sql = sql & " reemplazos,"	
			sql = sql & " reemplazos_presentes, "	
			sql = sql & " reemplazos_ausentes, "	
			sql = sql & " reemplazos_sinreg, "	
			sql = sql & " reemplazos_atrasos "	
			sql = sql & " FROM vw_controlDetalleAsistenciaTitularesMes "
			sql = sql & " WHERE YEAR(FECHA_RESPALDO) = YEAR(utilidades.dbo.fn_diaHabilAnterior(GETDATE())) AND "
			sql = sql & " MONTH(fecha_respaldo) = MONTH(utilidades.dbo.fn_diaHabilAnterior(GETDATE())) "
			sql = sql & " ORDER BY FECHA_RESPALDO DESC "

			'Response.Write(sql)
			'Response.End()
			set prog3 = db.execute(sql)
		%>

		<span class="label label-info titulo1" id="titulo1">CONTROL CAJEROS CIRRES DEL MES</span>
		<span class="label label-inverse titulo01" id="titulo01" ><i> FORMULA: TOTAL TITULARES - (TITULARES PRESENTES + REEMPLAZOS PRESENTES) </i></span>
		</br>		
		<table class="table table-bordered table-hover table-condensed">
			<tr class="success">
				<th>Estado</th>
				<th>Presentes vs Dotación</th>
				<th>Fecha de Respaldo</th>
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
			<%do until prog3.EOF%>
			<tr class="info">

				<%
				sumTituReem2 = (prog3.Fields.Item("titulares").Value - ( prog3.Fields.Item("titulares_presentes").Value + prog3.Fields.Item("reemplazos_presentes").Value ))
				%>

				<style type="text/css">
					 img.imgAlert{width: 12px; height: 12px;}				
				</style>

				<%if sumTituReem2 <> 0 then %>
					<td><img src="../img/projo.png" class="imgAlert"></td>
				<%else%>
					<td><img src="../img/pverde.png" class="imgAlert"></td>
				<% end if %>

				<td><%=sumTituReem2%></td>

				<td><%=prog3.Fields.Item("fecha_respaldo").Value%></td>				
				<td><%=prog3.Fields.Item("titulares").Value%></td>
				<td><%=prog3.Fields.Item("titulares_presentes").Value%></td>
				<td><%=prog3.Fields.Item("titulares_ausentes").Value%></td>
				<td><%=prog3.Fields.Item("titulares_sinreg").Value%></td>
				<td><%=prog3.Fields.Item("titulares_atrasos").Value%></td>
				<td><%=prog3.Fields.Item("reemplazos").Value%></td>
				<td><%=prog3.Fields.Item("reemplazos_presentes").Value%></td>
				<td><%=prog3.Fields.Item("reemplazos_ausentes").Value%></td>
				<td><%=prog3.Fields.Item("reemplazos_sinreg").Value%></td>
				<td><%=prog3.Fields.Item("reemplazos_atrasos").Value%></td>	
				<td>						
					<i class="icMostrarDetalleMes icon-file icon-large mano" id="icMostrarDetalleMes" data-fecha="<%=prog3.Fields.Item("fecha_respaldo").Value%>"></i>
				</td>
			  </tr>
			<%prog3.Movenext 
			Loop%>
		</table>
	</div>

	<div class="dvControlCierresDelMesDetalle" id="dvControlCierresDelMesDetalle"></div>

		<script type="text/javascript">
			$('.icMostrarDetalleMes').click(function(){			
				var fechaRespaldo = $(this).attr('data-fecha');
				var pagina = 'cuadroControl_sql.asp';
				var datos = 'cargaCuadrocontrol=3&fechaRespaldo='+fechaRespaldo;

				$.ajax({
				url: pagina,
				data: datos,
				type: "GET",
				dataType: "html",
				cache:false,
				//async:true,
				timeout:120000,
				success: function(source){  
					$('#dvControlCierresDelMes').slideUp();
					$('#dvControlCierresDelMesDetalle').addClass('oculto').slideUp();
					$('#dvControlCierresDelMesDetalle').html(source);
					$('#dvControlCierresDelMesDetalle').slideDown();
				},
				error: function(source){
				  alert('error');
				}
			});
			    $('.btnOcultarDetalle').removeClass('oculto').show('slow');
			});
		</script>
<%end if%>

<script type="text/javascript">
	$(document).ready(function(){
		$('.btnMostrarDetalle').click(function(){
		    $('.tabDetalle').removeClass('oculto');
		    $('#muestraDetalleSucursalOnline').html('');
			$('#muestraDetalleSucursal').slideUp();

		    var pagina, div, datos
		    	pagina = 'cuadroControlTabla.asp';
		    	div = 'muestraDetalle';
		    	datos='pagina=1&cargaCuadrocontrol='+$('#cargaCuadrocontrol').val();
		    	enviaDatos(pagina,div,datos);

		    $('.titulo2').removeClass('oculto');
			$('.titulo02').removeClass('oculto');
			$('#muestraDetalle').slideDown();
		});

		$('.btnDescargarDetalle').click(function(){
			$(this).attr({
		        'download': 'titulares_CControl.xls',
		        'href': 'cuadroControl_sql.asp?cargaCuadrocontrol=4',
		        'target': '_blank'
		    });
		});
	 });
</script>