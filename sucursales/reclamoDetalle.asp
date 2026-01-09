<!--#include file="../funciones.asp"-->
<%  idSucursal = request("idSucursal")
	idCaso = request("idCaso")
%>

<%
	sql = ""
	sql = sql & "select "
	sql = sql & "caso_titulo, "
	sql = sql & "caso_obs, "
	sql = sql & "B.caso_categoria, "
	sql = sql & "C.caso_motivo, "
	sql = sql & "caso_id_sucursal, "	
	sql = sql & "convert(varchar(12), caso_fecha_cre, 105) as caso_fecha_cre, "
	sql = sql & "convert(varchar(12), caso_hora_cre, 108) as caso_hora_cre, "
	sql = sql & "convert(varchar(12), caso_fecha_mod, 105) as caso_fecha_mod, "
	sql = sql & "convert(varchar(12), caso_hora_mod, 108) as caso_hora_mod, "
	sql = sql & "isnull(caso_rutPersonal,'') as caso_rutPersonal, "	
	sql = sql & "convert(varchar(12), fecha_registro, 105) as fecha_registro, "
	sql = sql & "convert(varchar(12), hora_registro, 108) as hora_registro "
	sql = sql & "from SUC_casos A "
	sql = sql & "inner join SUC_casos_config_categoria B "
	sql = sql & "on A.caso_categoria = B.id_caso_categoria "
	sql = sql & "inner join SUC_casos_config_motivo C "
	sql = sql & "on A.caso_motivo = C.id_caso_motivo "
	sql = sql & "where id_caso = " & idCaso

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
<div class="span12" style="margin-bottom: 10px">
	<div class="span4"><span class="label label-info"><i class="icon-book"></i> DETALLE CASO</span></div>
<div class="span8 text-right">
		<span>
		      <span class="btn btn-info" id="btnVolverReclamo"><i class="icon-arrow-left" ></i><span style="font-size: 10px;"><strong> Volver</strong></span></span>		      
		</span>
</div>
</div>
	<table class="table table-bordered table-hover table-condensed">
		<thead>
			<tr>
				<th>Titulo: <%=caso_titulo%></th>
				<th>Categoria: <%=caso_categoria%></th>
				<th>Motivo: <%=caso_motivo%></th>
				<th>N Caso: <%=idCaso%></th>
			</tr>			
		</thead>
		<tbody>
			<tr>
				<td colspan="4"><strong>Personal Asociado:</strong> 
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
				<td colspan="4"><strong>Obs:</strong> <%=caso_obs%></td>
			</tr>			
		</tbody>
	</table>
	<%
		sql = ""
		sql = sql & "select "
		sql = sql & "A.id_caso_respuesta, "
		sql = sql & "A.id_caso, "
		sql = sql & "B.u_nombres, "
		sql = sql & "B.u_apellidos, "
		sql = sql & "A.caso_respuesta, "		
		sql = sql & "convert(varchar(12), A.fecha_ingreso, 105) AS fecha_ingreso, "
		sql = sql & "convert(varchar(12), A.hora_ingreso, 108) AS hora_ingreso, "
		sql = sql & "A.usuarioWin, row_number() over(PARTITION BY A.id_caso order by A.fecha_ingreso ,A.hora_ingreso ) as cant "
		sql = sql & "from SUC_casos_respuesta A "
		sql = sql & "inner join SUC_usuario B "
		sql = sql & "on A.usuarioWin = B.usuario_nombre2 "
		sql = sql & "where A.id_caso = " & idCaso
		sql = sql & " order by A.fecha_ingreso desc,A.hora_ingreso desc  "

		set rs4 = db.execute(sql)
	%>
	<p><span class="label label-warning"><i class="icon-book"></i> RESPUESTA</span></p>
		
	<div class="accordion" id="accordion3"  style=" overflow-y: auto;">			
	<% if not rs4.eof then
		z = 0
		y = 0
		do while not rs4.eof %>
			
			<% y = rs4("cant") %>		
			<% if (y = "4") then %>
				<script type="text/javascript">
					$(function(){
						var divGroup4 = document.getElementById('accordion3'); 
						divGroup4.style.height="200px";
					});
				</script>						
			<% end if %>

			<% if z = 0 then %>
				<div class="accordion-group">
					<div class="accordion-heading" style="background-color: #e6e6e6;">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion3" href="#collapse<%=z%>">
						<b>Back: <%=server.htmlencode(trim(rs4("u_nombres") + " " + rs4("u_apellidos")))%></b>
						<br>
						Fecha: <%=rs4("fecha_ingreso")%>
						Hora: <%=rs4("hora_ingreso")%>
						</a>
					</div>
					<div id="collapse<%=z%>" class="accordion-body collapse in" style="background-color: #ffffff;">
						<div class="accordion-inner" ><strong>Resp:</strong> <%=rs4("caso_respuesta")%>
						</div>
					</div>
				</div>

			<% else %>
				<div class="accordion-group">
					<div class="accordion-heading" style="background-color: #e6e6e6;">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion3" href="#collapse<%=z%>">
						<b>Back: <%=server.htmlencode(trim(rs4("u_nombres") + " " + rs4("u_apellidos")))%></b>
						<br>
						Fecha: <%=rs4("fecha_ingreso")%>
						Hora: <%=rs4("hora_ingreso")%></a>
					</div>
					<div id="collapse<%=z%>" class="accordion-body collapse" style="background-color: #ffffff;">
						<div class="accordion-inner" ><strong>Resp:</strong> <%=rs4("caso_respuesta")%>
						</div>
					</div>
				</div>
			<% end if %>	
	<% 
		z = z + 1
		rs4.MoveNext
		loop
		end if %>
	</div>


	<p><span class="label label-success"><i class="icon-book"></i> FLUJO CASO</span></p>
	<table class="table table-bordered table-hover table-condensed">
		<thead>
			<tr>
				<th>--</th>
				<th>ESTADO</th>
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
				%>
					<tr>
						<td><%=nro_flujo%></td>
						<td><%=caso_paso_macro%></td>
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
<%		
	rs.Close
  	set rs.ActiveConnection = nothing
 	set rs=nothing
 end if
%>



<script type="text/javascript">
$('span#btnVolverReclamo').click(function() {
		var pagina, div, datos,canal;		
		var idSucursal = $('#idSucursalMain').val();	
		
		pagina = 'sucursales/reclamoTablaDetalle.asp';
		div = 'divAreaTrabajoReclamo';
		datos= 'idSucursal='+ idSucursal;
		enviaDatos(pagina,div,datos);  	
	});

</script>