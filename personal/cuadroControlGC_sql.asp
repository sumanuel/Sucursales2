<!--#include file="../conexion/conexion.asp"-->
<%
	tipo = request("tipo")

	idUsrWin = request.servervariables("LOGON_USER")
	usuarios = split(idUsrWin,"\")
	usuarioWin = usuarios(1)
	dominio = usuarios(0)
%>


<% if tipo = "1" then  'DETALLE DE CASO POR ID 	
	idSucursal = request("idSucursal")
	idCaso = request("idCaso")

	sql = ""
	sql = sql & "select "
	sql = sql & "A.caso_titulo, "
	sql = sql & "A.caso_obs, "
	sql = sql & "B.caso_categoria, "
	sql = sql & "C.caso_motivo, "
	sql = sql & "C.caso_sla, "
	sql = sql & "A.caso_id_sucursal, "
	sql = sql & "D.caso_paso_macro, "
	sql = sql & "A.id_caso_paso, "
	sql = sql & "convert(varchar(12), A.caso_fecha_cre, 105) as caso_fecha_cre, "
	sql = sql & "convert(varchar(12), A.caso_hora_cre, 108) as caso_hora_cre, "
	sql = sql & "convert(varchar(12), A.caso_fecha_mod, 105) as caso_fecha_mod, "
	sql = sql & "convert(varchar(12), A.caso_hora_mod, 108) as caso_hora_mod, "
	sql = sql & "isnull(A.caso_rutPersonal,'') as caso_rutPersonal, "	
	sql = sql & "convert(varchar(12), A.fecha_registro, 105) as fecha_registro, "
	sql = sql & "convert(varchar(12), A.hora_registro, 108) as hora_registro, "
	sql = sql & "E.u_nombres, "
	sql = sql & "E.u_apellidos, "
	sql = sql & "F.suc_nombre "	
	sql = sql & "from SUC_casos A "
	sql = sql & "inner join SUC_casos_config_categoria B "
	sql = sql & "on A.caso_categoria = B.id_caso_categoria "
	sql = sql & "inner join SUC_casos_config_motivo C "
	sql = sql & "on A.caso_motivo = C.id_caso_motivo "
	sql = sql & "inner join SUC_casos_pasos_macro D "
	sql = sql & "on A.id_caso_paso = D.id_caso_paso_macro "
	sql = sql & "inner join SUC_usuario E "
	sql = sql & "on A.caso_creado_por = E.id_usuario "
	sql = sql & "inner join SUC_sucursal F on "
	sql = sql & "A.caso_id_sucursal = F.id_sucursal "
	sql = sql & "where id_caso = " & idCaso

	'response.write(sql)
	'response.end

	set rs = db.execute(sql)
	if not rs.eof then
		caso_titulo = server.htmlencode(trim(rs("caso_titulo")))
		caso_obs = server.htmlencode(trim(rs("caso_obs")))
		caso_categoria = server.htmlencode(trim(rs("caso_categoria")))
		caso_motivo = server.htmlencode(trim(rs("caso_motivo")))
		caso_id_sucursal = server.htmlencode(trim(rs("caso_id_sucursal")))
		caso_fecha_cre = server.htmlencode(trim(rs("caso_fecha_cre")))
		caso_hora_cre = server.htmlencode(trim(rs("caso_hora_cre")))
		caso_fecha_mod = server.htmlencode(trim(rs("caso_fecha_mod")))
		caso_hora_mod = server.htmlencode(trim(rs("caso_hora_mod")))
		caso_rutPersonal = server.htmlencode(trim(rs("caso_rutPersonal")))
		fecha_registro = server.htmlencode(trim(rs("fecha_registro")))
		hora_registro = server.htmlencode(trim(rs("hora_registro")))
		suc_nombre = server.htmlencode(trim(rs("suc_nombre")))
		sla = trim(rs("caso_sla"))

		if cint(sla) > 59 then 
			sla_text = (cint(sla)/60) & " horas"
		else 
			sla_text = sla & " minutos"
		end if

		usuarioIngreso = server.htmlencode(trim(rs("u_nombres"))) & " " & server.htmlencode(trim(rs("u_apellidos"))) 

		caso_paso_macro_head = trim(rs("caso_paso_macro"))
		caso_paso_macro_idHead = trim(rs("id_caso_paso"))

		if caso_paso_macro_idHead = "1" then
			sql = ""
			sql = sql & "exec SUC_prc_casos_flujo "
			sql = sql & "@id_caso = "& idCaso &", "
			sql = sql & "@id_caso_paso_next = 0, "
			sql = sql & "@usuario = '"& usuarioWin &"' "		

			'response.write(sql)
			'response.end()
			db.execute(sql)			
		end if

		if caso_rutPersonal <> "" then
			sql = ""
			sql = sql & "select "
			sql = sql & "rut_personal, "
			sql = sql & "nombre_personal, "
			sql = sql & "tipo, "
			sql = sql & "tipo_personal, "
			sql = sql & "empresa "
			sql = sql & "from SUC_sucursal_asistencia_personal "
			sql = sql & "where id_sucursal = "&idSucursal&" and "
			sql = sql & "rut_personal = '"&caso_rutPersonal&"'"

			'response.write(sql)
			'response.end()

			set rs2 = db.execute(sql)
			if not rs2.eof then
				p_rut_personal = server.htmlencode(trim(rs2("rut_personal")))
				p_nombre_personal = server.htmlencode(trim(rs2("nombre_personal")))
				p_tipo = server.htmlencode(trim(rs2("tipo")))
				p_tipo_personal = server.htmlencode(trim(rs2("tipo_personal")))
				p_empresa = server.htmlencode(trim(rs2("empresa")))
			end if
			rs2.Close
	  		set rs2.ActiveConnection = nothing
	  		set rs2=nothing
		end if

		strJson = ""	
		strJson = strJson & "{ ""datos"": ["
    	
    	strJson = strJson & "{ "
        strJson = strJson & """caso_titulo"": """ & caso_titulo & ""","
        strJson = strJson & """caso_obs"": """ & caso_obs & ""","
        strJson = strJson & """caso_categoria"": """ & caso_categoria & ""","
        strJson = strJson & """caso_motivo"": """ & caso_motivo & ""","
        strJson = strJson & """caso_id_sucursal"": """ & caso_id_sucursal & ""","
        strJson = strJson & """caso_fecha_cre"": """ & caso_fecha_cre & ""","
        strJson = strJson & """caso_hora_cre"": """ & caso_hora_cre & ""","
        strJson = strJson & """caso_fecha_mod"": """ & caso_fecha_mod & ""","
        strJson = strJson & """caso_hora_mod"": """ & caso_hora_mod & ""","
        strJson = strJson & """caso_rutPersonal"": """ & caso_rutPersonal & ""","
        strJson = strJson & """fecha_registro"": """ & fecha_registro & ""","
        strJson = strJson & """hora_registro"": """ & hora_registro & """"
        strJson = strJson & "}"	    
		
		strJson = strJson & "] }"
		'response.write(strJson)		
%>	
	<div class="well">		
		<p><a class="btn btn-danger pull-right btnClsCasoDetalle"><span class="bajaLetra"><strong>CERRAR CASO</strong><span></a></p>
		<script type="text/javascript">
			$('.btnClsCasoDetalle').click(function(){
				var div = 'dvCentralListaGC';
				var datos = 'tipo=5';
				var pagina = 'cuadroControlGC_sql.asp';

				$('#casoDetalle').slideUp();
				$('#dvCentralListaGC').html('');
				enviaDatos(pagina,div,datos);				
				$('#dvCentralListaGC').slideDown();

				$('.casoSelMultiple').show('slow');
			})
		</script>
		<p><span class="label label-info"><i class="icon-book"></i> DETALLE CASO</span></p>
		<table class="table table-bordered table-hover table-condensed">
			<thead>
				<tr>
					<th>Ingresado por: <%=usuarioIngreso%></th>
					<th>Fecha: <%=caso_fecha_cre%></th>
					<th>Hora: <%=caso_hora_cre%></th>
					<th>Sucursal: <%=suc_nombre%></th>
					<th>N Caso: <%=idCaso%></th>
				</tr>
				<tr>
					<th>Titulo: <%=caso_titulo%></th>
					<th>Categoria: <%=caso_categoria%></th>
					<th colspan="3">Motivo: <%=caso_motivo%> (SLA: <%=sla_text%>)</th>
				</tr>			
			</thead>
			<tbody>
				<tr>
					<td colspan="5"><strong>Personal Asociado:</strong> 
						<% if caso_rutPersonal <> "" then %>	
							<table class="table table-bordered table-condensed">													
								<tbody>
									<tr class="info">
										<td><strong>Rut Personal</strong></td>
										<td><strong>Nombre Personal</strong></td>
										<td><strong>Cargo</strong></td>
										<td><strong>Tipo</strong></td>
										<td><strong>Empresa</strong></td>
									</tr>
									<tr class="info">
										<td><%=p_rut_personal%></td>
										<td><%=p_nombre_personal%></td>
										<td><%=p_tipo_personal%></td>
										<td><%=p_tipo%></td>									
										<td><%=p_empresa%></td>
									</tr>
								</tbody>
							</table>
						<% else %>
							<strong>Sin personal asociado.</strong>
						<% end if %>
					</td>
				</tr>
				<tr>
					<td colspan="5"><strong>Obs:</strong> <%=caso_obs%></td>
				</tr>			
			</tbody>
		</table>
	</div>	
	<div class="well">
		<a class="btn btn-warning pull-right btnAddRespCasoDetalle"><span class="bajaLetra"><i class="icon-plus icon-large"></i>&nbsp;<strong>AGREGAR RESPUESTA</strong><span></a><br/>	
		<div class="casoBackRespList" id="casoBackRespList"></div>
		<div class="casoBackRespFrm oculto" id="casoBackRespFrm"></div>
		<div class="oculto" id="addCasoRespSucces"></div>
		<script type="text/javascript">
			$(document).ready(function(){
				var div = 'casoBackRespList'
    			var datos = 'tipo=4&idCaso='+<%=idCaso%>
    			var pagina = 'cuadroControlGC_sql.asp'
    			enviaDatos(pagina,div,datos);
			
				$('.btnAddRespCasoDetalle').click(function(){
					var div = 'casoBackRespFrm';
					var datos = 'tipo=8';
					var pagina = 'cuadroControlGC_sql.asp';
					enviaDatos(pagina,div,datos);

					setTimeout(function(){
						$('.casoBackRespList').slideUp();
						$('.casoBackRespFrm').removeClass("oculto").slideDown();	
					}, 1000);					
				})				
			});
		</script>	
	</div>

	<div class="well">
		<a class="btn btn-success pull-right btnModFlujoCasoDet"><span class="bajaLetra"><i class="icon-arrow-right icon-large"></i>&nbsp;<strong>MODIFICAR ESTADO</strong><span></a><br/>
		<div class="addCasoFlujoList" id="addCasoFlujoList"></div>
		<div class="oculto addCasoFlujoFrm" id="addCasoFlujoFrm"></div>	
		<div class="oculto addCasoFlujoSuccess" id="addCasoFlujoSuccess"></div>
		<script type="text/javascript">
			$(document).ready(function(){
				//Actualizar lista de casos
				var idCaso = $('#idCaso').val();
				var div = 'addCasoFlujoList';
				var datos = 'tipo=6&idCaso='+idCaso;
				var pagina = 'cuadroControlGC_sql.asp';
				enviaDatos(pagina,div,datos);	

				$('.btnModFlujoCasoDet').click(function(){
					var idCaso = $('#idCaso').val();
					var div = 'addCasoFlujoFrm';
					var datos = 'tipo=7&idCaso='+idCaso;
					var pagina = 'cuadroControlGC_sql.asp';
					enviaDatos(pagina,div,datos);

					setTimeout(function(){
						$('.addCasoFlujoList').slideUp();
						$('.addCasoFlujoFrm').removeClass("oculto").slideDown();	
					}, 1000);					
				});
			});			
		</script>		
	</div>
<%	
		rs.Close
  		set rs.ActiveConnection = nothing
  		set rs=nothing 
	end if
end if
%>
<% if tipo = "2" then 'INGRESO DE RESPUETAS POR CASO 
	idCaso = request("idCaso")
	backUser = request("idBack")
	casoResp = request("casoResp")

	sql = ""
	sql = sql & "exec SUC_prc_casos_resp_ingresar "
	sql = sql & "@id_caso = "& idCaso &", "
	sql = sql & "@back_user = "& backUser &", "
	sql = sql & "@caso_respuesta = '"& casoResp &"', " 
	sql = sql & "@usuarioWin = '" & usuarioWin &"' " 

	'response.write(sql)
	'response.end()

	db.execute(sql)	
 end if %>

<% if tipo = "3" then 'MODIFICACION ESTADO CASO
	idCaso = request("idCaso")
	backUser = request("idBack")
	idEstado = request("idEstado")

	sql = ""
	sql = sql & "exec SUC_prc_casos_estado_modificar "
	sql = sql & "@id_caso ="& idCaso &", "
	sql = sql & "@id_estado = " & idEstado &", "
	sql = sql & "@usuario = '" & usuarioWin &"' " 
	
	'response.write(sql)
	'response.end()

	db.execute(sql)	
end if %>

<% if tipo = "4" then 'RESPUESTAS POR ID DE CASO'
	idCaso = request("idCaso")

	sql = ""
	sql = sql & "select "
	sql = sql & "A.id_caso_respuesta, "
	sql = sql & "A.id_caso, "
	sql = sql & "B.u_nombres, "
	sql = sql & "B.u_apellidos, "
	sql = sql & "A.caso_respuesta, "		
	sql = sql & "convert(varchar(12), A.fecha_ingreso, 105) AS fecha_ingreso, "
	sql = sql & "convert(varchar(12), A.hora_ingreso, 108) AS hora_ingreso, "
	sql = sql & "A.usuarioWin "
	sql = sql & "from SUC_casos_respuesta A "
	sql = sql & "inner join SUC_usuario B "
	sql = sql & "on A.caso_respuesta_back_user = B.id_usuario "
	sql = sql & "where A.id_caso = " & idCaso
	sql = sql & "order by id_caso_respuesta "

	set rs4 = db.execute(sql)
%>
<p><span class="label label-warning"><i class="icon-book"></i> RESPUESTAS BACK CAJEROS</span></p>			
<% if not rs4.eof then
	do while not rs4.eof %>
<table class="table table-bordered table-hover table-condensed">
	<thead>
		<tr>
			<th style="width: 40%">Back: <%=rs4("usuarioWin")%></th>
			<th style="width: 30%">Fecha: <%=rs4("fecha_ingreso")%></th>
			<th style="width: 30%">Hora: <%=rs4("hora_ingreso")%></th>
		</tr>	
	</thead>		
	<tbody>
		<tr>
			<td colspan="3"><strong>Resp:</strong> <%=rs4("caso_respuesta")%></td>		
		</tr>	
	</tbody>
</table>		
<% 
	rs4.MoveNext
	loop
	end if %>
<% end if %>

<% if tipo = "5" then 'LISTADO DE CASOS COMPLETO' %>
	<link href="../css/tablaSort.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="../js/jquery.dataTables.js"></script>
	<script type="text/javascript" src="../js/jquery.dataTables.bootstrap.js"></script>
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
	sql = sql & "where year(z.caso_fecha_cre) = year(getdate()) and "
	sql = sql & "month(z.caso_fecha_cre) = month(getdate()) "
	sql = sql & "order by z.id_caso desc "

	'response.write(sql)
	'response.end()

	set rs = db.execute(sql)
%>
<p><a class="btn btn-primary casoSelMultiple"><i class="icon-list"></i> <span style="font-size: 10px"><strong>SELECCION MULTIPLE</strong></span></a></p>
<input type="hidden" name="msIdCasoSel" id="msIdCasoSel" value=""/>
<span class="label label-info titulo1" id="titulo1">LISTA CASOS SUCURSALES</span>
<% if not rs.eof then %>
	<table class="table table-bordered table-condensed table-hover" id="tablaCasos">
		<thead>
		<tr>
			<th>CASO</th>
			<th>COD BTT</th>
			<th>SUCURSAL</th>
			<!--<th>TITULO</th>-->
			<th>CATEGORIA</th>
			<th>MOTIVO</th>
			<th>FECHA CREACION</th>
			<th>FECHA MODIFICACION</th>
			<th>ESTADO</th>
			<th>R</th>
			<th>SLA</th>
			<th>PROVEEDOR</th>
			<th>--</th>
			<th class="">--</th>
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
			caso_sla = trim(rs("caso_sla"))
			sla = trim(rs("SLA"))
			proveedor = server.htmlencode(trim(rs("proveedor")))
			sla_diff = trim(rs("SLA_DIFF"))
			id_caso_paso_macro = trim(rs("id_caso_paso_macro"))

			sla_diff_text = ""
			resto_text = ""
			resto = (caso_sla-sla_diff)

			'<<<<<========= SLA FALTANTE =========>>>>>
			if id_caso_paso_macro = "5" then
				if sla = "FP" then 
					resto = (sla_diff-caso_sla)
					if resto > 59 then 
						resto_text = formatnumber((resto/60),0) & " hrs"
					else 
						resto_text = (resto) & " min"
					end if
				else 
					resto_text = ""
				end if				
			else 
				if sla = "DP" then 
					if resto > 59 then 
						resto_text = formatnumber((resto/60),0) & " hrs"
					else 
						resto_text = (resto) & " min"
					end if
				else
					resto_text = "0 min"
				end if 
			end if

			'<<<<<========= TIEMPO EN ESTADO =========>>>>>
			if id_caso_paso_macro = "5" then 
				sla_diff_text = ""
			else 
				if sla_diff > 59 then
					sla_diff_text = " (" & formatnumber((sla_diff/60),0) & " hrs)"
				else 
					sla_diff_text = " (" & (sla_diff) & " min)"
				end if 
			end if
		%>
			<tr>
				<td><%=caso_id%></td>
				<td><%=cod_bantotal%></td>
				<td><%=suc_nombre%></td>
				<!--<td><%=caso_titulo%></td>-->
				<td><%=caso_categoria%></td>
				<td><%=caso_motivo%></td>
				<td><%=caso_fecha_cre%>:<%=caso_hora_cre%></td>
				<td><%=caso_fecha_mod%>:<%=caso_hora_mod%></td>
				<td><%=caso_paso_macro%> <%=sla_diff_text%></td>
				<td><%=resto_text%></td>
				<td><%=sla%></td>
				<td><%=proveedor%></td>
				<td><i class="icon-folder-open icon-large mano casoTraking" data-idSucursal="<%=id_sucursal%>" data-idCaso="<%=caso_id%>"></i></td>			
				<td class=""><input type="checkbox" class="msCaso" data-idcaso="<%=caso_id%>"/></td>
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
			$('.casoSelMultiple').click(function(){				
				var idCasos = $('#msIdCasoSel').val();

				if(idCasos == ''){
					alert('favor seleccionar casos a revisar.');
				}
				else{
					var div = 'dvcasoSelMulti';
					var datos = 'tipo=9&arrCasos='+idCasos;
					var pagina = 'cuadroControlGC_sql.asp';
					enviaDatos(pagina,div,datos);

					$('#'+div).removeClass('oculto');
					$('#dvCentralListaGC').hide('slow');
					$('.casoSelMultiple').hide('slow');	
				}				
			});

			$('.msCaso').click(function(){
				var idCaso = $('#msIdCasoSel').val();
				//console.log("idCaso:" + idCaso);
				var arrIdCaso = [];

				if(idCaso.length > 0){
					arrIdCaso = idCaso.split(',');
				}
				//console.log(arrIdCaso.length);

				if ($(this).hasClass("msCasoSel")){
					$(this).removeClass("msCasoSel");					
					arrIdCaso.splice($.inArray($(this).attr('data-idcaso'), arrIdCaso),1);					
				}
				else{
					$(this).addClass("msCasoSel");
					arrIdCaso.push($(this).attr('data-idcaso'));
				}	
				
				$('#msIdCasoSel').val(arrIdCaso.toString());

				//mandar los datos a un hidden
				//formular como array para push-pop						
			});

			$('.casoTraking').click(function(){
				var idCaso = $(this).attr('data-idCaso');
				var idSucursal = $(this).attr('data-idSucursal');
				$('#idCaso').val(idCaso);				

				var div = 'casoDetalle'
				var datos = 'tipo=1&idCaso='+idCaso+'&idSucursal='+idSucursal;
				var pagina = 'cuadroControlGC_sql.asp'

				enviaDatos(pagina,div,datos);
				$('#dvCentralListaGC').slideUp();
				$('#casoDetalle').slideDown();

				$('.casoSelMultiple').hide('slow');
			});

			$('#tablaCasos').dataTable( {
				"iDisplayLength": 100,	
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
<% end if
 end if %>

<% if tipo = "6" then 'LISTADO FLUJO ESTADO POR CASOS' 
	idCaso = request("idCaso")
%>
	<p><span class="label label-success"><i class="icon-book"></i> FLUJO ESTADOS CASO</span></p>
	<table class="table table-bordered table-hover table-condensed">
		<thead>
			<tr>
				<th>--</th>
				<th>ESTADO</th>				
				<th>USUARIO</th>
				<th>FECHA</th>
				<th>HORA</th>				
			</tr>
		</thead>
		<tbody>
		<%
			sql = ""
			sql = sql & "select "			 
			sql = sql & "A.id_caso, " 
			sql = sql & "B.caso_paso_macro, "
			sql = sql & "A.usuario_flujo, "
			sql = sql & "convert(varchar(12), A.fecha_ingreso, 105) as fecha_ingreso, "
			sql = sql & "convert(varchar(12), A.hora_ingreso, 108) as hora_ingreso "
			sql = sql & "from SUC_casos_flujo A "
			sql = sql & "inner join SUC_casos_pasos_macro B "
			sql = sql & "on A.id_caso_paso = B.id_caso_paso_macro "
			sql = sql & "where A.id_caso = " & idCaso
			
			set rs3 = db.execute(sql)
			nro_flujo = 1
			if not rs3.eof then
				do while not rs3.eof
					caso_paso_macro = Trim(rs3("caso_paso_macro"))
					fecha_ingreso = Trim(rs3("fecha_ingreso"))
					hora_ingreso = Trim(rs3("hora_ingreso"))
					usuario_flujo = Trim(rs3("usuario_flujo"))
				%>
					<tr>
						<td><%=nro_flujo%></td>
						<td><%=caso_paso_macro%></td>						
						<td><%=usuario_flujo%></td>
						<td><%=fecha_ingreso%></td>
						<td><%=hora_ingreso%></td>
					</tr>
				<%	
				nro_flujo = nro_flujo + 1
				rs3.MoveNext
  	  			loop
			end if
			rs3.Close
	  		set rs3.ActiveConnection = nothing
	  		set rs3=nothing
		%>				
		</tbody>
	</table>
<% end if %>

<% if tipo = "7" then 'FORMULARIO MODIFICACION DE ESTADO FLUJO CASO 
	idCaso = request("idCaso")	

	sql = ""
	sql = sql & "select "
	sql = sql & "a.id_caso, "
	sql = sql & "a.caso_categoria, "
	sql = sql & "a.caso_motivo, "
	sql = sql & "a.id_caso_paso, "
	sql = sql & "b.caso_paso_macro "
	sql = sql & "from SUC_casos a "
	sql = sql & "inner join SUC_casos_pasos_macro b "
	sql = sql & "on a.id_caso_paso = b.id_caso_paso_macro "
	sql = sql & "where id_caso = " & idCaso

	set casoDs = db.execute(sql)

	if not casoDs.EOF then 
		caso_paso_macro_idHead = trim(casoDs("id_caso_paso"))
		caso_paso_macro_head = trim(casoDs("caso_paso_macro"))

		if caso_paso_macro_idHead = "5" then
			classOculto = "oculto"
		else
			classOculto = ""
		end if
	end if 	
%>
	<p><span class="label label-success"><i class="icon-book"></i> CAMBIAR FLUJO ESTADOS CASO</span></p>
	<form class="form-horizontal">	            
        <div class="control-group">
          <label class="control-label" for="casoObs"><span style="font-size:11px"><strong>ESTADO ACTUAL</strong></span></label>
          <div class="controls">
            <input type="text" disabled="disabled" value="<%=caso_paso_macro_head%>"/>
          </div>
        </div>

        <div class="control-group <%=classOculto%>">
          <label class="control-label" for="casoObs"><span style="font-size:11px"><strong>ESTADO FLUJO</strong></span></label>
          <div class="controls">
           <select id="casoCategoria" class="casoCategoria" style="font-size:11px;">
              <option value="0">--- Seleccione Estado ---</option>	
              <%
              	  sql = ""
              	  sql = sql & "select "
              	  sql = sql & "id_caso_paso_macro, "
              	  sql = sql & "caso_paso_macro "
              	  sql = sql & "from SUC_casos_pasos_macro "

              	  set flujoDs = db.execute(sql)
              	  if not flujoDs.EOF then 
              	  	do while not flujoDs.eof
              	  		idCasoPasoMacro = flujoDs("id_caso_paso_macro")
              	  		casoPasoMacro = flujoDs("caso_paso_macro")
              %>
              		<option value="<%=idCasoPasoMacro%>"><%=casoPasoMacro%></option>
              <%    flujoDs.MoveNext
  	  				loop
              	  end if %>
            </select>
          </div>
        </div>

        <div class="control-group">
          <div class="controls">          
            <a class="btn btn-primary addCasoFlujoSave <%=classOculto%>"><i class="icon-save"></i> <span style="font-size: 10px"><strong>GUARDAR</strong></span></a>
            <a class="btn btn-danger addCasoFlujoCerrar"><span style="font-size: 10px"><strong>CERRAR</strong></span></a>
          </div>
        </div>
    </form>
    <script type="text/javascript">
    	$(document).ready(function(){
    		$('.addCasoFlujoSave').click(function(){
				var idCaso = $('#idCaso').val();				
				var idBack = $('#idBack').val();
				var idEstado = $('#casoCategoria').val();

				$('.addCasoFlujoFrm').slideUp();			
				$('#addCasoFlujoSuccess').html('<div class="alert alert-success"><i class="icon-save icon-large"></i> <b>GUARDANDO ESTADO CASO</b><img src="../img/loader.gif"/></div>');
				$('#addCasoFlujoSuccess').slideDown();
				$('#addCasoFlujoList').html('');

				var div = ''
				var datos = 'tipo=3&idCaso='+idCaso+'&idEstado='+idEstado
				var pagina = 'cuadroControlGC_sql.asp'
				enviaDatos(pagina,div,datos);
				
				setTimeout(function(){
					//Actualizar lista de casos
					div = 'addCasoFlujoList';
					datos = 'tipo=6&idCaso='+idCaso;
					pagina = 'cuadroControlGC_sql.asp';
					enviaDatos(pagina,div,datos);
					$('#addCasoFlujoSuccess').addClass('oculto').slideUp();					
					$('.addCasoFlujoList').slideDown();						
				}, 2000);
			});
			$('.addCasoFlujoCerrar').click(function(){
				$('.addCasoFlujoFrm').addClass("oculto").slideUp();
				$('.addCasoFlujoList').slideDown();				
			});
    	});    	
    </script>
<% end if %>

<% if tipo = "8" then 'FORMULARIO INGRESO RESPUESTAS %>
	<p><span class="label label-warning"><i class="icon-book"></i> INGRESAR RESPUESTA BACK CAJEROS</span></p>
	<form class="form-horizontal">	            
		<div class="control-group">
		  <label class="control-label" for="casoObs"><span style="font-size:11px"><strong>RESPUESTA</strong></span></label>
		  <div class="controls">
			<textarea id="casoObs" style="margin: 0px; width: 754px; height: 88px;"></textarea>
		  </div>
		</div>

		<div class="control-group">
		  <div class="controls">          
			<a class="btn btn-primary addCasoRespSave"><i class="icon-save"></i> <span style="font-size: 10px"><strong>GUARDAR</strong></span></a>
			<a class="btn btn-danger addCasoRespCerrar"><span style="font-size: 10px"><strong>CERRAR</strong></span></a>
		  </div>
		</div>
	</form>
	<script type="text/javascript">
		$(document).ready(function(){
			$('.addCasoRespSave').click(function(){	
				var idCaso = $('#idCaso').val();
				var casoResp = $('#casoObs').val();
				var idBack = $('#idBack').val();

				$('.casoBackRespFrm').slideUp();			
				$('#addCasoRespSucces').html('<div class="alert alert-success"><i class="icon-save icon-large"></i> <b>GUARDANDO RESPUESTA CASO</b><img src="../img/loader.gif"/></div>');
				$('#addCasoRespSucces').slideDown();
				$('#casoBackRespList').html('');

				var div = ''
				var datos = 'tipo=2&idCaso='+idCaso+'&idBack='+idBack+'&casoResp='+casoResp
				var pagina = 'cuadroControlGC_sql.asp'

				enviaDatos(pagina,div,datos);

				div = 'casoBackRespList';
				datos = 'tipo=4&idCaso='+idCaso;
				pagina = 'cuadroControlGC_sql.asp';
				enviaDatos(pagina,div,datos);

				/*var executeResp = $.ajax({
			        url: pagina,
			        data: datos,
			        type: "GET",
			        dataType: "html",
			        cache:false,
			        //async:true,
			        timeout:120000,
			        success: function(source){			        	
			        	$('#casoBackRespList').html('');
			        	$('#casoBackRespList').html(source);
			        },
			        error: function(source){
			          alert('error');
			        }
			    });*/

				setTimeout(function(){
					$('#addCasoRespSucces').addClass('oculto').slideUp();    				
					$('.casoBackRespList').slideDown();	
				}, 3000);

				//CLEAN CAMPO RESP
				$('#casoObs').val('');
			});
			$('.addCasoRespCerrar').click(function(){
				$('.casoBackRespFrm').addClass("oculto").slideUp();
				$('.casoBackRespList').slideDown();				
			});
		});
	</script>
<% end if %>

<% if tipo = "9" then 'SELECCION MULTIPLE DE CASOS %>
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
			<span class="label label-important"><i class="icon-book"></i> CASOS SELECCIONADOS</span>
			<a class="btn btn-primary smCasosvolver"><i class="icon-hand-left"></i> <span style="font-size: 10px"><strong>VOLVER</strong></span></a>
		</p>
	<% 
		do while not casoDsMulti.eof 
			caso_id = server.htmlencode(trim(casoDsMulti("id_caso")))
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
						<th>N Caso: <%=caso_id%></th>
					</tr>
					<tr>
						<th>T&iacute;tulo: <%=caso_titulo%></th>
						<th>Categor&iacute;a: <%=caso_categoria%></th>
						<th colspan="3">Motivo: <%=caso_motivo%></th>
					</tr>			
				</thead>
				<tbody>					
					<tr>
						<td colspan="5"><strong>Obs:</strong> <%=caso_obs%></td>
					</tr>
					<tr>
						<td colspan="5" style="color:red;"><strong>Resp. Proveedor:</strong></td>
					</tr>
				</tbody>
			</table>

	<%	casoDsMulti.MoveNext
  	  	loop
	end if
%>	
	<script type="text/javascript">
		$(document).ready(function(){
			$('.smCasosvolver').click(function(){
				$('#dvcasoSelMulti').addClass('oculto');
				$('#dvCentralListaGC').show('slow');
				$('.casoSelMultiple').show('slow');
			})
		})
	</script>
<% end if %>

<% if tipo = "10" then 'JSON CASOS TOTALES - DP y FP %>
<%
	sql = ""	
	sql = sql & "select * from ( "
	sql = sql & "select 'catt'+convert(varchar(10),caso_categoria) as item, "
	sql = sql & "count(*) qty "
	sql = sql & "from SUC_casos group by caso_categoria "
	sql = sql & "union "
	sql = sql & "select 'mott'+convert(varchar(10),caso_motivo) as item, "
	sql = sql & "count(*) qty "
	sql = sql & "from SUC_casos "
	sql = sql & "group by caso_motivo "
	sql = sql & "union "
	sql = sql & "select 'cat'+sla+convert(varchar(10),caso_categoria) as item, "
	sql = sql & "count(*) as qty "
	sql = sql & "from view_casos_sla "
	sql = sql & "group by caso_categoria, sla "
	sql = sql & "union "
	sql = sql & "select 'mot'+sla+convert(varchar(10),caso_motivo) as item, "
	sql = sql & "count(*) as qty "
	sql = sql & "from view_casos_sla "
	sql = sql & "group by caso_motivo, sla "
	sql = sql & ") as z "
	
	set rs = db.execute(sql)
	strjson = ""
	if not rs.eof then
	   ' ====================================================
	   ' JSON	
	   ' ====================================================
		Response.ContentType = "application/json"

		Response.Write "{"
		Response.Write "  ""datos"": " 
		Response.Write "[ "

		do while not rs.eof 
			strjson = strjson & "{ "
			strjson = strjson & " ""item"": """&rs("item")&""", "
		 	strjson = strjson & " ""qty"": """&rs("qty")&""" "
		 	strjson = strjson & "}, "
	 	rs.MoveNext
       	loop

       	strjson = Mid(strjson, 1, len(strjson)-2)

       	Response.write strjson
       	'Response.end
		Response.Write "] }"
	end if
%>
<% end if %>

<% if tipo = "11" then 'JSON CASOS TOTALES - DP y FP %>
<%
	sql = ""
	sql = sql & "select 'casoest'+convert(varchar(10),b.id_caso_paso_macro) as est, "
	sql = sql & "b.caso_paso_macro, count(*) as qty "
	sql = sql & "from SUC_casos a "
	sql = sql & "inner join SUC_casos_pasos_macro b "
	sql = sql & "on a.id_caso_paso = b.id_caso_paso_macro "
	sql = sql & "group by b.id_caso_paso_macro, b.caso_paso_macro "
	sql = sql & "order by count(*) desc "

	'response.write(sql)
	'response.end

	set rs = db.execute(sql)	
	strjson = ""
	if not rs.eof then
	   ' ====================================================
	   ' JSON	
	   ' ====================================================
		Response.ContentType = "application/json"

		Response.Write "{"
		Response.Write "  ""datos"": " 
		Response.Write "[ "

		do while not rs.eof 
			strjson = strjson & "{ "
			strjson = strjson & " ""est"": """&rs("est")&""", "
			strjson = strjson & " ""casoPasoMacro"": """&rs("caso_paso_macro")&""", "
		 	strjson = strjson & " ""qty"": """&rs("qty")&""" "
		 	strjson = strjson & "}, "
	 	rs.MoveNext
       	loop

       	strjson = Mid(strjson, 1, len(strjson)-2)

       	Response.write strjson
		Response.Write "] }"
	end if
%>
<% end if %>