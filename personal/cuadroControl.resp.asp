<!--#include file="../conexion/conexion.asp"-->

<span class="">
<%

	carga = request("carga")
	cargaCuadrocontrol = request("cargaCuadrocontrol")

%>
	<input type="hidden" name="fecha_reg" id="fecha_reg" class="cfecha_reg" value="0"/>
	<input type="hidden" name="carga" id="carga" class="carga" value="<%=carga%>"/>
	<input type="hidden" name="cargaCuadrocontrol" id="cargaCuadrocontrol" class="cargaCuadrocontrol" value="<%=cargaCuadrocontrol%>"/>
<br/>
<div id="controlCentral" class="controlCentral">
<% if cargaCuadrocontrol = "1" then %>	    
	<div class="dvControlOnline oculto" id="dvControlOnline">
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
		<table class="table table-bordered table-hover">
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
			<%do until prog1.EOF%>
			<tr class="info">

				<%
				sumTituReem = (prog1.Fields.Item("titulares").Value - ( prog1.Fields.Item("titulares_presentes").Value + prog1.Fields.Item("reemplazos_presentes").Value ))
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
				<td><%=prog1.Fields.Item("titulares").Value%></td>
				<td><%=prog1.Fields.Item("titulares_presentes").Value%></td>
				<td><%=prog1.Fields.Item("titulares_ausentes").Value%></td>
				<td><%=prog1.Fields.Item("titulares_sinreg").Value%></td>
				<td><%=prog1.Fields.Item("titulares_atrasos").Value%></td>
				<td><%=prog1.Fields.Item("reemplazos").Value%></td>
				<td><%=prog1.Fields.Item("reemplazos_presentes").Value%></td>
				<td><%=prog1.Fields.Item("reemplazos_ausentes").Value%></td>
				<td><%=prog1.Fields.Item("reemplazos_sinreg").Value%></td>
				<td><%=prog1.Fields.Item("reemplazos_atrasos").Value%></td>
				<td><%=prog1.Fields.Item("cajeros_layout").Value%></td>
				<td><%=prog1.Fields.Item("proveedor").Value%></td>				
			<%prog1.Movenext 
			Loop%>
		</table>
	</div>

	<div class="dvControlOnlineDetalle" id="dvControlOnlineDetalle">
	<%
		Dim prog2
		sql = ""	
		sql = sql & " select  cod_bantotal,suc_nombre,titulares, "
		sql = sql & " titulares_presentes,titulares_ausentes,titulares_sinreg, "
		sql = sql & " titulares_atrasos,reemplazos, reemplazos_presentes, reemplazos_ausentes,reemplazos_sinreg, "
		sql = sql & " reemplazos_atrasos, cajeros_layout, proveedor "
		sql = sql & " from vw_controlDetalleAsistenciaTitulares "
		sql = sql & " order by suc_nombre asc "								
		'Response.Write(sql)
		'Response.End()
		set prog2 = db.execute(sql)
	%>	
	<div class="navbar admTitulo2">
		<div>
			<a class="btn btn-success btnMostrarDetalle" id="btnMostrarDetalle">
				<i class="icon-user icon-large"></i>
				&nbsp;<span class="bajaLetra"><b>MOSTRAR DETALLE</b></span>
			</a>

			<a class="btn btn-danger btnOcultarDetalle" id="btnOcultarDetalle">
				<i></i>
				&nbsp;<span class="bajaLetra"><b>CERRAR DETALLE</b></span>
			</a>
		</div>
		<br/>
		<span class="label label-info titulo2 oculto" id="titulo2" >CONTROL CAJEROS DIARIO DETALLE</span>
		<span class="label label-inverse titulo02 oculto" id="titulo02" ><i> FORMULA: TOTAL TITULARES - (TITULARES PRESENTES + REEMPLAZOS PRESENTES) </i></span>
		<input type="hidden" id="ctrl_detalleOnline" value="" data-codSucusal="" />
		<table class="table table-bordered table-condensed tabDetalle oculto table-hover">
			<tr class="success">
				<th>Estado</th>
				<th>Presentes vs Dotación</th>
				<th>Cod BTT</th>								
				<th>Sucursal</th>
				<th>Titulares</th>
				<th>Titulares Presentes</th>
				<th>Titulares Ausentes</th>
				<th>Titulares Sin Reg.</th>
				<th>Titulares Atrasos</th>
				<th>Reemplazos</th>
				<th>Reemplazos Presentes</th>
				<th>Reemplazos Ausentes</th>
				<th>Reemplazos Sin Reg.</th>
				<th>Reemplazos Atrasos</th>
				<th>Cajeros Layout</th>
				<th>Proveedor</th>
				<th>---</th>
			</tr>
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
			%>
			<tr class="" id="tr_sucursal_head<%=cod_bantotal%>">
				<% 'sumTituReem2 = (prog2.Fields.Item("titulares").Value - ( prog2.Fields.Item("titulares_presentes").Value + prog2.Fields.Item("reemplazos_presentes").Value )) %>
				<% sumTituReem2 = (total_titulares - ( total_titulares_presentes + total_reemplazos_presentes )) %>

				<style type="text/css">
					 img.imgAlert{width: 12px; height: 12px;}				
				</style>

				<%if sumTituReem2 <> 0 then %>
					<td><img src="../img/projo.png" class="imgAlert" align="center"></td>
				<%else%>
					<td><img src="../img/pverde.png" class="imgAlert" align="center"></td>
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
				<td>&nbsp;<i class="icon-file icon-large mano detalleOnline" data-codSucursal="<%=cod_bantotal%>"></i></td>
			</tr>
			<tr class="info tr_sucursal<%=cod_bantotal%> oculto">
				<td colspan="17"><div id="sucursal<%=cod_bantotal%>"></div></td>
			</tr>
			<%prog2.Movenext 
			Loop%>
		</table>
		</span>
	</div> 
</div> 
<%end if%>

<% if cargaCuadrocontrol = "2" then %> 
	<div class="dvControlCierresDelMes oculto" id="dvControlCierresDelMes">
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
			<table class="table table-bordered table-hover">
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
				<tr class="success">

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

				<%prog3.Movenext 
				Loop%>
			</table>
		</div>

		<div class="dvControlCierresDelMesDetalle oculto" id="dvControlCierresDelMesDetalle"></div>

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
			        	$('#dvControlCierresDelMesDetalle').removeClass('oculto').slideDown();
			        },
			        error: function(source){
			          alert('error');
			        }
			    });
			});
		</script>
<%end if%>

<script type="text/javascript">
	$(document).ready(function(){
		var cargaCuadrocontrol = $('.cargaCuadrocontrol').val();
		//alert(cargaCuadrocontrol);

		if (cargaCuadrocontrol == '1')
			$('.dvControlOnline').removeClass('oculto');				
		else
			$('.dvControlOnline').addClass('oculto');

		if (cargaCuadrocontrol == '2'){
			$('.dvControlCierresDelMes').removeClass('oculto');
			$('.btnOcultarDetalle').addClass('oculto');			
			$('.btnMostrarDetalle').addClass('oculto');
		}				
		else{
			$('.dvControlCierresDelMes').addClass('oculto');
			$('.btnOcultarDetalle').removeClass('oculto');
			$('.btnMostrarDetalle').removeClass('oculto');
		}

		$('.btnMostrarDetalle').click(function(){
		    $('.tabDetalle').removeClass('oculto');		    
		    $('.titulo2').removeClass('oculto');
			$('.titulo02').removeClass('oculto');			
		});

		$('.btnOcultarDetalle').click(function(){
		    $('.tabDetalle').addClass('oculto'); 
		    $('.titulo2').addClass('oculto');
			$('.titulo02').addClass('oculto');			
		});

		$('.detalleOnline').click(function(){
			var div_open = $('#ctrl_detalleOnline').attr('data-codSucusal');
			var cod_sucursal = $(this).attr('data-codSucursal');
			
			var div = '';
			var pagina = '';
			var datos = '';

			if(cod_sucursal != div_open)
			{
				if(div_open == ''){
					$('#ctrl_detalleOnline').attr('data-codSucusal', cod_sucursal);
					
					div = 'sucursal'+cod_sucursal;
					pagina = 'asistenciaSucursal_view.asp';
					datos = 'tipo=1&codBantotal=' + cod_sucursal;
					enviaDatos(pagina,div,datos);
					$('.tr_sucursal'+cod_sucursal).slideDown().removeClass('oculto');
					$('#tr_sucursal_head'+cod_sucursal).removeClass('success').addClass('info');
				}else{					
					$('.tr_sucursal'+div_open).slideUp().addClass('oculto');
					$('#ctrl_detalleOnline').attr('data-codSucusal', cod_sucursal);
					$('#tr_sucursal_head'+div_open).removeClass('info').addClass('success');
					
					div = 'sucursal'+cod_sucursal;
					pagina = 'asistenciaSucursal_view.asp';
					datos = 'tipo=1&codBantotal=' + cod_sucursal;
					enviaDatos(pagina,div,datos);
					$('.tr_sucursal'+cod_sucursal).slideDown().removeClass('oculto');
					$('#tr_sucursal_head'+cod_sucursal).removeClass('success').addClass('info');
				}
			}else{
				$('.tr_sucursal'+div_open).slideUp();
				$('#tr_sucursal_head'+cod_sucursal).removeClass('info').addClass('success');
				$('#ctrl_detalleOnline').attr('data-codSucusal', '');
			}						
							
			setTimeout(function(){ 
				var htmlResult = $('#sucursal'+cod_sucursal).html();
				htmlResult = $.trim(htmlResult);			
				if(htmlResult == ''){
					$('#sucursal'+cod_sucursal).html('<strong>SIN REGISTROS</strong>');
				}
			}, 1000);		
		});
 });
</script>