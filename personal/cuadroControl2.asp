<!--#include file="../conexion/conexion.asp"-->
<%
	cargaCuadrocontrol = request("cargaCuadrocontrol")
	fechaRespaldo = request("fechaRespaldo")
%>
<input type="hidden" name="cargaCuadrocontrol" id="cargaCuadrocontrol" class="cargaCuadrocontrol" value="<%=cargaCuadrocontrol%>"/>
<% if cargaCuadrocontrol = "1" then %>	
	<%
		Dim estado, prog1
		sql = ""	
		sql = sql & " SELECT (SUM(TOTAL_ADICIONALES) - SUM(ADICIONALES_PRESENTES)) AS PRESENTES_VS_DOTACION ,SUM(TOTAL_ADICIONALES) as TOTAL_ADICIONALES, "
		sql = sql & " SUM(ADICIONALES_PRESENTES) as ADICIONALES_PRESENTES, "
		sql = sql & " SUM(ADICIONALES_AUSENTES) as ADICIONALES_AUSENTES, "	
		sql = sql & " SUM(ADICIONALES_SIN_REGISTROS) as ADICIONALES_SIN_REGISTROS, proveedor "	
		sql = sql & " from vw_controlDetalleAsistenciaAdicional group by proveedor "		
		'Response.Write(sql)
		'Response.End()
		set prog1 = db.execute(sql)
	%>			
		<span class="label label-info titulo1" id="titulo1">CONTROL CAJEROS ADICIONALES DIARIO</span>
		<span class="label label-inverse titulo01" id="titulo01" ><i> FORMULA: TOTAL ADICIONALES - TOTAL PRESENTES </i></span>
		<table class="table table-bordered table-condensed table-hover" style="margin-bottom:10px;">
			<thead>
				<tr class="info">
					<th>Estado</th>
					<th>Pesentes vs Dotacion</th>
					<th>Total Adicionales</th>
					<th>Adicionales Presentes</th>
					<th>Adicionales Ausentes</th>
					<th>Adicionales Sin Registros</th>
					<th>Proveedor</th>
				</tr>
			</thead>
			<tbody>
			<%do until prog1.EOF%>
				<tr class="info">
					<% sumTituReem = (prog1("PRESENTES_VS_DOTACION")) %>
					<style type="text/css">
						 img.imgAlert{width: 12px; height: 12px;}				
					</style>
					<%if sumTituReem <> 0 then %>
						<td><img src="../img/projo.png" class="imgAlert"></td>
					<%else%>
						<td><img src="../img/pverde.png" class="imgAlert"></td>
					<% end if %>

					<td><%=sumTituReem%></td>				
					<td><%=prog1("TOTAL_ADICIONALES")%></td>
					<td><%=prog1("ADICIONALES_PRESENTES")%></td>
					<td><%=prog1("ADICIONALES_AUSENTES")%></td>
					<td><%=prog1("ADICIONALES_SIN_REGISTROS")%></td>
					<td><%=prog1("proveedor")%></td>	
				<tr/>		
				<%prog1.Movenext 
				Loop%>
			</tbody>
		</table>

		<%
			Dim estado2, prog2
			sql = ""	
			sql = sql & " SELECT B.COD_BANTOTAL, B.SUC_NOMBRE, TOTAL_ADICIONALES, "
			sql = sql & " ADICIONALES_PRESENTES, ADICIONALES_AUSENTES, "
			sql = sql & " ADICIONALES_SIN_REGISTROS, proveedor "
			sql = sql & " FROM vw_controlDetalleAsistenciaAdicional AS A"
			sql = sql & " INNER JOIN SUC_SUCURSAL AS B ON"
			sql = sql & " A.COD_BANTOTAL = B.COD_BANTOTAL"					
			'Response.Write(sql)
			'Response.End()
			set prog2 = db.execute(sql)
		%>	
		<div class="navbar admTitulo2">
		<div id="divBotones">
			<a class="btn btn-success btnMostrarDetalle" id="btnMostrarDetalle">
				<i class="icon-user icon-large"></i>
				&nbsp;<span class="bajaLetra"><b>MOSTRAR DETALLE</b></span>
			</a>

			<a class="btn btn-primary btnDescargarDetalle" id="btnDescargarDetalle">
				<i class="icon-save icon-large"></i>
				&nbsp;<span class="bajaLetra"><b>DESCARGAR</b></span>
			</a>

			<a class="btn btn-primary btnDescargarDimen" id="btnDescargarDimen">
				<i class="icon-save icon-large"></i>
				&nbsp;<span class="bajaLetra"><b>DESCARGAR DIMEN.</b></span>
			</a>

			<a class="btn btn-danger btnOcultarDetalle oculto" id="btnOcultarDetalle">
				<i></i>
				&nbsp;<span class="bajaLetra"><b>CERRAR DETALLE</b></span>
			</a>
		</div>
		<br/>
		<span class="label label-info titulo2 oculto" id="titulo2" >CONTROL CAJEROS ADICIONALES DIARIO DETALLE</span>&nbsp;		
		<span class="label label-inverse titulo02 oculto" id="titulo02" ><i> FORMULA: TOTAL ADICIONALES - TOTAL PRESENTES </i></span>
		<input type="hidden" id="ctrl_detalleAdOnline" value="" data-codSucusal=""/>
		<div id="muestraDetalle"></div>
		<div id="muestraDetalleSucursal">
			<div id="muestraDetalleSucursalOnline"></div>	
		</div>
		<div class="muestraDetalleDimen oculto" id="muestraDetalleDimen"></div>
	</div> 

	<script type="text/javascript">
	$(document).ready(function(){
		$('.detalleDimen').click(function(){
			var cod_sucursal = $(this).attr('data-codSucursal');
			var div = 'muestraDetalleDimen';
			var datos = 'tipoDimen=1&codBantotal='+cod_sucursal;
			var pagina = 'cuadroControlDimen.asp';

			enviaDatos(pagina,div,datos);
			$('#muestraDetalle').slideUp();
			$('#muestraDetalleDimen').removeClass('oculto');
			$('#muestraDetalleDimen').slideDown();
			//$('#divBotones').hide();
		});

		$('.btnMostrarDetalle').click(function(){
			var pagina, div, datos
		    	pagina = 'cuadroControlTabla.asp';
		    	div = 'muestraDetalle';
		    	datos='pagina=2&cargaCuadrocontrol='+$('#cargaCuadrocontrol').val();
		    	enviaDatos(pagina,div,datos);
		    $('.tabDetalle').removeClass('oculto');
		    $('.titulo2').removeClass('oculto');
			$('.titulo02').removeClass('oculto');

			$('#muestraDetalle').slideDown();
			$('#muestraDetalleSucursalOnline').html('');
			$('#muestraDetalleSucursal').slideUp();			
		});		

		$('.btnDescargarDetalle').click(function(){
			$(this).attr({
		        'download': 'adicionales_CControl.xls',
		        'href': 'cuadroControl_sql.asp?cargaCuadrocontrol=5',
		        'target': '_blank'
		    });
		});
		
		$('.btnDescargarDimen').click(function(){
			$(this).attr({
		        'download': 'dimensionamiento.xls',
		        'href': 'cuadroControl_sql.asp?cargaCuadrocontrol=7',
		        'target': '_blank'
		    });
		});

		$('.detalleAdicionalOnline').click(function(){
			var codSucursal = $(this).attr('data-codSucursal');
			var div_open = $('#ctrl_detalleAdOnline').attr('data-codSucusal');
			
			var div = 'sucursal_adOn'+codSucursal;
			var pagina = 'asistenciaSucursal_view.asp';
			var datos = 'tipo=1&codBantotal=' + codSucursal;

			if(codSucursal != div_open)
			{
				if(div_open == ''){
					$('#ctrl_detalleAdOnline').attr('data-codSucusal', codSucursal);					
					
					enviaDatos(pagina,div,datos);
					$('.tr_adOn_sucursal'+codSucursal).slideDown().removeClass('oculto');
					$('#tr_adOn_sucursal_head'+codSucursal).removeClass('success').addClass('info');
				}else{					
					$('.tr_adOn_sucursal'+div_open).slideUp().addClass('oculto');
					$('#ctrl_detalleAdOnline').attr('data-codSucusal', codSucursal);
					$('#tr_adOn_sucursal_head'+div_open).removeClass('info').addClass('success');					
					
					enviaDatos(pagina,div,datos);
					$('.tr_adOn_sucursal'+codSucursal).slideDown().removeClass('oculto');
					$('#tr_adOn_sucursal_head'+codSucursal).removeClass('success').addClass('info');
				}
			}else{
				$('.tr_adOn_sucursal'+div_open).slideUp();
				$('#tr_adOn_sucursal_head'+codSucursal).removeClass('info').addClass('success');
				$('#ctrl_detalleAdOnline').attr('data-codSucusal', '');
			}						
							
			setTimeout(function(){ 
				var htmlResult = $('#sucursal_adOn'+codSucursal).html();
				htmlResult = $.trim(htmlResult);			
				if(htmlResult == ''){
					$('#sucursal_adOn'+codSucursal).html('<strong>SIN REGISTROS</strong>');
				}
			}, 1000);
		});

		$('.detalleAdicionalRespaldo').click(function(){
			var codBantotal = $(this).attr('data-codSucursal');				
		});
	});
	</script>
<% end if 
   if cargaCuadrocontrol = "2" then %>
	<span class="">
	<%
		Dim estado3, prog3
		sql = ""
		sql = sql & " "
		sql = sql & " SELECT FECHA_RESPALDO, "
		sql = sql & " SUM((TOTAL_ADICIONALES - ADICIONALES_PRESENTES)) AS PRESENTES_VS_DOTACION "
		sql = sql & " ,SUM(TOTAL_ADICIONALES) AS TOTAL_ADICIONALES "
		sql = sql & " ,SUM (ADICIONALES_PRESENTES) AS ADICIONALES_PRESENTES "
		sql = sql & " ,SUM (ADICIONALES_AUSENTES) AS ADICIONALES_AUSENTES "
		sql = sql & " ,SUM(ADICIONALES_SIN_REGISTROS) AS ADICIONALES_SIN_REGISTROS "
		sql = sql & " FROM dbo.vw_controlDetalleAsistenciaAdicionalMes "		
		sql = sql & " WHERE YEAR(fecha_respaldo) = YEAR(utilidades.dbo.fn_diaHabilAnterior(GETDATE())) AND "
		sql = sql & " MONTH(fecha_respaldo) = MONTH(utilidades.dbo.fn_diaHabilAnterior(GETDATE())) "
		sql = sql & " GROUP BY FECHA_RESPALDO "
		sql = sql & " ORDER BY FECHA_RESPALDO DESC "

		'Response.Write(sql)
		'Response.End()
		set prog3 = db.execute(sql)
	%>
	<div id="controlCajerosAdicionalesMes" class="controlCajerosAdicionalesMes">
		<br/>
		<span class="label label-info titulo1" id="titulo1"><%=fechaRespaldo%>&nbsp;CONTROL CAJEROS ADICIONALES CIRRES DEL MES</span>
		<span class="label label-inverse titulo04" id="titulo04" ><i> FORMULA: TOTAL ADICIONALES - TOTAL PRESENTES </i></span>		
		<table class="table table-bordered table-condensed table-hover" style="margin-bottom:10px;">
			<tr class="info">
				<th>Estado</th>
				<th>Presentes vs Dotacion</th>
				<th>Fecha Respaldo</th>
				<th>Total Adicionales</th>
				<th>Adicionales Presentes</th>
				<th>Adicionales Ausentes</th>
				<th>Adicionales Sin Resgistros</th>
				<th>--</th>	
			</tr>

			<%do until prog3.EOF%>
			<tr class="info">

				<%
					sumTituReem = (prog3.Fields.Item("PRESENTES_VS_DOTACION").Value)
				%>

				<style type="text/css">
					 img.imgAlert{width: 12px; height: 12px;}				
				</style>

				<%if sumTituReem <> 0 then %>
					<td><img src="../img/projo.png" class="imgAlert"></td>
				<%else%>
					<td><img src="../img/pverde.png" class="imgAlert"></td>
				<% end if %>

				<td><%=sumTituReem%></td>				
				<td><%=prog3.Fields.Item("FECHA_RESPALDO").Value%></td>
				<td><%=prog3.Fields.Item("TOTAL_ADICIONALES").Value%></td>				
				<td><%=prog3.Fields.Item("ADICIONALES_PRESENTES").Value%></td>
				<td><%=prog3.Fields.Item("ADICIONALES_AUSENTES").Value%></td>
				<td><%=prog3.Fields.Item("ADICIONALES_SIN_REGISTROS").Value%></td>
				<td>						
					<i class="icMostrarDetalleMes icon-file icon-large mano" id="icMostrarDetalleMes" data-fecha="<%=prog3.Fields.Item("fecha_respaldo").Value%>"></i>
				</td>
			<%prog3.Movenext 
			Loop%>
		</table>
	 </div>

	 <div id="controlCajerosAdicionalesMesDetalle" class="controlCajerosAdicionalesMesDetalle oculto">
		<%
			Dim estado4, prog4
			sql = ""	
			sql = sql & " SELECT B.COD_BANTOTAL, B.SUC_NOMBRE, TOTAL_ADICIONALES, "
			sql = sql & " ADICIONALES_PRESENTES, ADICIONALES_AUSENTES, "
			sql = sql & " ADICIONALES_SIN_REGISTROS, proveedor "
			sql = sql & " FROM vw_controlDetalleAsistenciaAdicional AS A"
			sql = sql & " INNER JOIN SUC_SUCURSAL AS B ON"
			sql = sql & " A.COD_BANTOTAL = B.COD_BANTOTAL"					
			'Response.Write(sql)
			'Response.End()
			set prog4 = db.execute(sql)
		%>
		<br/>

		<span class="label label-info titulo2 oculto" id="titulo2"><%=fechaRespaldo%>&nbsp;CONTROL CAJEROS ADICIONALES DETALLE</span>		
		<input type="hidden" id="ctrl_detalleAdOnline" value="" data-codSucusal=""/>
		<table class="table table-bordered table-condensed  tabDetalle oculto table-hover">
			<tr class="">
				<th>Estado</th>
				<th>Presentes vs Dotacion</th>			
				<th>Cod Sucursal</th>
				<th>Nombre Sucursal</th>
				<th>Total Adicionales</th>
				<th>Adicionales Presentes</th>	
				<th>Adicionales Ausentes</th>
				<th>Adicionales Sin Registros</th>
				<th>Proveedor</th>
				<th>---</th>
			</tr>
			<%do until prog4.EOF		
				cod_bantotal = prog4.Fields.Item("COD_BANTOTAL").Value
				suc_nombre = server.htmlencode(Trim(prog4.Fields.Item("SUC_NOMBRE").Value))
				total_adicionales = prog4.Fields.Item("TOTAL_ADICIONALES").Value
				total_presentes = prog4.Fields.Item("ADICIONALES_PRESENTES").Value
				total_ausentes = prog4.Fields.Item("ADICIONALES_AUSENTES").Value
				total_sinreg = prog4.Fields.Item("ADICIONALES_SIN_REGISTROS").Value
				proveedor = prog4.Fields.Item("proveedor").Value

				formula_adicionales = Cint(total_adicionales) - Cint(total_presentes)
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
				<td><%=cod_bantotal%></td>
				<td><%=suc_nombre%></td>
				<td><%=total_adicionales%></td>
				<td><%=total_presentes%></td>
				<td><%=total_ausentes%></td>
				<td><%=total_sinreg%></td>
				<td><%=proveedor%></td>
				<td>&nbsp;<i class="icon-file icon-large mano detalleAdicionalOnline" data-codSucursal="<%=cod_bantotal%>"></i></td>
			</tr>
			<tr class="info tr_adOn_sucursal<%=cod_bantotal%> oculto">
				<td colspan="10"><div id="sucursal_adOn<%=cod_bantotal%>"></div></td>
			</tr>
			<%prog4.Movenext 
			Loop%>
		</table>
		</span>
		<div id="detAdFechaRespaldo"></div>	

	<script type="text/javascript">	
	$(document).ready(function(){
		$('.btnMostrarDetalle').click(function(){
		    $('.tabDetalle').removeClass('oculto');
		    $('.titulo2').removeClass('oculto');			
		});

		$('.btnOcultarDetalle').click(function(){
		    $('.tabDetalle').addClass('oculto'); 
		    $('.titulo2').addClass('oculto');					
		});

		$('.detalleAdicionalOnline').click(function(){
			var codSucursal = $(this).attr('data-codSucursal');
			var div_open = $('#ctrl_detalleAdOnline').attr('data-codSucusal');
			
			var div = 'sucursal_adOn'+codSucursal;
			var pagina = 'asistenciaSucursal_view.asp';
			var datos = 'tipo=1&codBantotal=' + codSucursal;

			if(codSucursal != div_open)
			{
				if(div_open == ''){
					$('#ctrl_detalleAdOnline').attr('data-codSucusal', codSucursal);					
					
					enviaDatos(pagina,div,datos);
					$('.tr_adOn_sucursal'+codSucursal).slideDown().removeClass('oculto');
					$('#tr_adOn_sucursal_head'+codSucursal).removeClass('success').addClass('info');
				}else{					
					$('.tr_adOn_sucursal'+div_open).slideUp().addClass('oculto');
					$('#ctrl_detalleAdOnline').attr('data-codSucusal', codSucursal);
					$('#tr_adOn_sucursal_head'+div_open).removeClass('info').addClass('success');					
					
					enviaDatos(pagina,div,datos);
					$('.tr_adOn_sucursal'+codSucursal).slideDown().removeClass('oculto');
					$('#tr_adOn_sucursal_head'+codSucursal).removeClass('success').addClass('info');
				}
			}else{
				$('.tr_adOn_sucursal'+div_open).slideUp();
				$('#tr_adOn_sucursal_head'+codSucursal).removeClass('info').addClass('success');
				$('#ctrl_detalleAdOnline').attr('data-codSucusal', '');
			}						
							
			setTimeout(function(){ 
				var htmlResult = $('#sucursal_adOn'+codSucursal).html();
				htmlResult = $.trim(htmlResult);			
				if(htmlResult == ''){
					$('#sucursal_adOn'+codSucursal).html('<strong>SIN REGISTROS</strong>');
				}
			}, 1000);
		});

		$('.detalleAdicionalRespaldo').click(function(){
			var codBantotal = $(this).attr('data-codSucursal');				
		});

		$('.icMostrarDetalleMes').click(function(){
			var fechaRespaldo = $(this).attr('data-fecha');			
			var pagina = 'cuadroControl2.asp';
			var datos = 'cargaCuadrocontrol=3&fechaRespaldo='+fechaRespaldo;
			var div = 'detAdFechaRespaldo'

			enviaDatos(pagina,div,datos);

			$('#controlCajerosAdicionalesMes').slideUp();
			$('#controlCajerosAdicionalesMesDetalle').slideUp().removeClass('oculto').slideDown();
		});
	});
	</script>

<% end if
	if cargaCuadrocontrol = "3" then
		fechaRespaldo = request("fechaRespaldo")
%>	
<%
	sql = ""
	sql = sql & "SET dateformat dmy "
	sql = sql & "SELECT FECHA_RESPALDO, "
	sql = sql & "SUM(TOTAL_ADICIONALES) AS TOTAL_ADICIONALES, "
	sql = sql & "SUM(ADICIONALES_PRESENTES) AS ADICIONALES_PRESENTES, "
	sql = sql & "SUM(ADICIONALES_AUSENTES) AS ADICIONALES_AUSENTES, "
	sql = sql & "SUM(ADICIONALES_SIN_REGISTROS) AS ADICIONALES_SIN_REGISTROS, "
	sql = sql & "PROVEEDOR "
	sql = sql & "FROM dbo.vw_controlDetalleAsistenciaAdicionalMes "
	sql = sql & "WHERE fecha_respaldo = '"& fechaRespaldo &"' "
	sql = sql & "GROUP BY FECHA_RESPALDO, PROVEEDOR "

	set prog5 = db.execute(sql)
%>
	<p>
		<a class="btn btn-danger btnOcultarDetalleAdicionale9" id="btnOcultarDetalleAdicionale9">			
			<span class="bajaLetra"><b>CERRAR DETALLE ADICIONAL &nbsp; <%=fechaRespaldo%></b></span>
		</a>
	</p>			
	<span class="label label-info titulo2" id="titulo2"><%=fechaRespaldo%>&nbsp;CONTROL CAJEROS ADICIONALES DETALLE</span>
	<span class="label label-inverse titulo02" id="titulo02" ><i> FORMULA: TOTAL ADICIONALES - TOTAL PRESENTES </i></span>
	<input type="hidden" id="ctrl_detalleAdOnline" value="" data-codSucusal=""/>
	<input type="hidden" id="fechaRespaldo" value="<%=fechaRespaldo%>" data-fechaRespaldo=""/>
	<table class="table table-bordered table-condensed table-hover tabDetalle" style="margin-bottom:10px;">
		<tr class="">
			<th>Fecha</th>
			<th>Estado</th>
			<th>Presentes vs Dotacion</th>							
			<th>Total Adicionales</th>
			<th>Adicionales Presentes</th>	
			<th>Adicionales Ausentes</th>
			<th>Adicionales Sin Registros</th>
			<th>Proveedor</th>				
		</tr>
		<%do until prog5.EOF
			total_fecha = prog5("FECHA_RESPALDO")										
			total_adicionales = prog5("TOTAL_ADICIONALES")
			total_presentes = prog5("ADICIONALES_PRESENTES")
			total_ausentes = prog5("ADICIONALES_AUSENTES")
			total_sinreg = prog5("ADICIONALES_SIN_REGISTROS")
			proveedor = prog5("proveedor")

			formula_adicionales = Cint(total_adicionales) - Cint(total_presentes)
		%>
		<style type="text/css">
			 img.imgAlert{width: 12px; height: 12px;}				
		</style>
		<tr class="info" id="tr_adOn_sucursal_head<%=cod_bantotal%>">
			<td><%=total_fecha%></td>
			<td>
				<%if formula_adicionales <> 0 then %>
					<img src="../img/projo.png" class="imgAlert">
				<%else%>
					<img src="../img/pverde.png" class="imgAlert">
				<% end if %>
			</td>
			<td><%=formula_adicionales%></td>				
			<td><%=total_adicionales%></td>
			<td><%=total_presentes%></td>
			<td><%=total_ausentes%></td>
			<td><%=total_sinreg%></td>
			<td><%=proveedor%></td>				
		</tr>			
		<%prog5.Movenext 
		Loop%>
	</table>
	</span>
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
		<span class="label label-info titulo2" id="titulo2"><%=fechaRespaldo%>&nbsp;CONTROL CAJEROS ADICIONALES DETALLE</span>
		<span class="label label-inverse titulo02" id="titulo02" ><i> FORMULA: TOTAL ADICIONALES - TOTAL PRESENTES </i></span>		
	</div>
	<div id="dvAdicionalesRespaldo"></div>
	<div id="dvAdicionalesRespaldoDetalle"></div>
	<script type="text/javascript">
		$(document).ready(function(){
			$('.btnMostrarDetalle').click(function(){
				var fechaRespaldo = $('#fechaRespaldo').val();

				var div = 'dvAdicionalesRespaldo';
				var pagina = 'cuadroControlTabla.asp';
				var datos = 'pagina=2&cargaCuadrocontrol=2&fechaRespaldo=' + fechaRespaldo;
				enviaDatos(pagina,div,datos);	

				$('#AdRespTitulos').removeClass('oculto').show('slow');					
			});			
		});
	</script>
	
	
<script type="text/javascript">		
	$(document).ready(function(){
		$('.btnOcultarDetalleAdicionale9').click(function(){					
			$('.controlCajerosAdicionalesMes').slideDown();
			$('.controlCajerosAdicionalesMesDetalle').slideUp();
		});
	});	
</script>
</div>
<% end if%>

