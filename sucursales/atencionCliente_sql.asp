<!--#include file="../funciones.asp"-->
<%
	tipo = request("tipo")
	idCat = request("idCat")	

	idUsrWin = request.servervariables("LOGON_USER")
	usuarios = split(idUsrWin,"\")
	usuarioWin = usuarios(1)
	dominio = usuarios(0)

if tipo = "1" then 'CONSULTA CATEGORIAS'
	sql = ""
	sql = sql & "SELECT "
	sql = sql & "id_caso_categoria, "
	sql = sql & "caso_cod_categoria, "
	sql = sql & "caso_categoria "
	sql = sql & "FROM SUC_casos_config_categoria "
	sql = sql & "WHERE caso_categoria_activo = 1"

	set rsCat = db.execute(sql)
	if not rsCat.eof then

	strJson = ""	
	strJson = strJson & "{ ""datos"": ["
		do while not rsCat.eof

		id_caso_categoria = Trim(rsCat("id_caso_categoria"))
		caso_cod_categoria = Trim(rsCat("caso_cod_categoria"))
		caso_categoria = Trim(rsCat("caso_categoria"))

		strJson = strJson & "{ "
        strJson = strJson & """id_caso_categoria"": """ & id_caso_categoria & ""","
        strJson = strJson & """caso_cod_categoria"": """ & caso_cod_categoria & ""","
        strJson = strJson & """caso_categoria"": """ & caso_categoria & """"
        strJson = strJson & "},"

		rsCat.MoveNext
		loop 
	strJson = left(strJson,len(strJson)-1)
	strJson = strJson & "] }"

	response.write(strJson)
	end if 
	rsCat.Close
	set rsCat.ActiveConnection = nothing
	set rsCat=nothing
end if

if tipo = "2" then 'CONSULTA MOTIVOS'
	sql = ""
    sql = sql & "SELECT "
    sql = sql & "id_caso_motivo, "
    sql = sql & "id_caso_categoria, "
    sql = sql & "caso_cod_motivo, "
    sql = sql & "caso_flag_reqcajero, "
    sql = sql & "caso_motivo "
    sql = sql & "FROM SUC_casos_config_motivo "
    sql = sql & "where id_caso_categoria = " & idCat
    sql = sql & "and caso_motivo_activo = 1"

    set rsMot = db.execute(sql)

    if not rsMot.eof then

    strJson = ""	
	strJson = strJson & "{ ""datos"": ["
    do while not rsMot.eof
    	id_caso_motivo = Trim(rsMot("id_caso_motivo"))
    	id_caso_categoria = Trim(rsMot("id_caso_categoria"))
    	caso_cod_motivo = Trim(rsMot("caso_cod_motivo"))
    	caso_motivo = Trim(rsMot("caso_motivo"))
    	caso_flag_reqcajero = Trim(rsMot("caso_flag_reqcajero"))
    	
    	strJson = strJson & "{ "
        strJson = strJson & """id_caso_motivo"": """ & id_caso_motivo & ""","
        strJson = strJson & """id_caso_categoria"": """ & id_caso_categoria & ""","
        strJson = strJson & """caso_cod_motivo"": """ & caso_cod_motivo & ""","
        strJson = strJson & """caso_flag_reqcajero"": """ & caso_flag_reqcajero & ""","
        strJson = strJson & """caso_motivo"": """ & caso_motivo & """"
        strJson = strJson & "},"
    rsMot.MoveNext
	loop 

	strJson = left(strJson,len(strJson)-1)
	strJson = strJson & "] }"
	response.write(strJson)
	end if 
	
	rsMot.Close
	set rsMot.ActiveConnection = nothing
	set rsMot=nothing
end if

if tipo = "3" then 'INGRESAR CASO'
	idMot = request("idMot")
	casoTitulo = request("casoTitulo")
	casoObs = request("casoObs")
	idSucursal = request("idSucursal")
	rutPersonal = request("rutPersonal")
	idUsuario = request("idUsuario")

	sql = ""
	sql = sql & "exec SUC_prc_casos_ingresar "
	sql = sql & "@caso_categoria = "&idCat&", "
	sql = sql & "@caso_motivo = "&idMot&", "
	sql = sql & "@caso_titulo = '"&casoTitulo&"', "
	sql = sql & "@caso_obs = '"&casoObs&"', "
	sql = sql & "@caso_id_sucursal = " & idSucursal & ", "
	sql = sql & "@rutPersonal = '" & rutPersonal & "', "
	sql = sql & "@idUsuario = " & idUsuario & ", "
	sql = sql & "@usuario = '"& usuarioWin &"' "

	'response.write(sql)
	'response.end
	db.execute(sql)

end if
%>

<% if tipo = "4" then 'LISTA DE CASOS INGRESADOS POR SUCURSAL' 
	idSucursal = request("idSucursalSistema")
	'idSucursal = "1"
%>
	<link href="css/tablaSort.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="js/jquery.dataTables.js"></script>
	<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>
<%

	sql = ""
	sql = sql & "select A.id_caso, "
	sql = sql & "A.caso_titulo, "
	sql = sql & "A.caso_obs, "
	sql = sql & "B.caso_categoria, "
	sql = sql & "C.caso_motivo, "
	sql = sql & "isnull(A.caso_creado_por,0) as caso_creado_por, "	
	sql = sql & "convert(varchar(12), isnull(A.caso_fecha_cre, getdate()), 105) as caso_fecha_cre, "
	sql = sql & "convert(varchar(12), isnull(A.caso_hora_cre, getdate()), 108) as caso_hora_cre, "
	sql = sql & "convert(varchar(12), isnull(A.caso_fecha_mod, getdate()), 105) as caso_fecha_mod, "
	sql = sql & "convert(varchar(12), isnull(A.caso_hora_mod, getdate()), 108) as caso_hora_mod, "
	sql = sql & "D.caso_paso_macro "
	sql = sql & "from SUC_casos A "
	sql = sql & "inner join SUC_casos_config_categoria B "
	sql = sql & "on A.caso_categoria = B.id_caso_categoria "
	sql = sql & "inner join SUC_casos_config_motivo C "
	sql = sql & "on A.caso_motivo = C.id_caso_motivo "
	sql = sql & "inner join SUC_casos_pasos_macro D "
	sql = sql & "on A.id_caso_paso = D.id_caso_paso_macro "
	sql = sql & "where A.caso_id_sucursal = " & idSucursal & " "
	sql = sql & "order by A.id_caso desc "

	'response.write(sql)
	'response.end()

	set rs = db.execute(sql)
	if not rs.eof then
%>
	<table class="table table-bordered table-condensed" id="tablacasos">
		<thead>
		<tr>
			<th>N CASO</th>
			<th>TITULO</th>
			<th>CATEGORIA</th>
			<th>MOTIVO</th>
			<th>FECHA CREACION</th>
			<th>FECHA MODIFICACION</th>
			<th>ESTADO</th>
			<th>--</th>
		</tr>
		</thead>
		<tbody>
		<% do while not rs.eof 
			caso_id = trim(rs("id_caso"))
			caso_titulo = server.htmlencode(trim(rs("caso_titulo")))
			caso_obs = server.htmlencode(trim(rs("caso_obs")))
			caso_categoria = server.htmlencode(trim(rs("caso_categoria")))
			caso_motivo = server.htmlencode(trim(rs("caso_motivo")))
			caso_creado_por = server.htmlencode(trim(rs("caso_creado_por")))
			caso_fecha_cre = server.htmlencode(trim(rs("caso_fecha_cre")))
			caso_hora_cre = server.htmlencode(trim(rs("caso_hora_cre")))
			caso_fecha_mod = server.htmlencode(trim(rs("caso_fecha_mod")))
			caso_hora_mod = server.htmlencode(trim(rs("caso_hora_mod")))
			caso_paso_macro = server.htmlencode(trim(rs("caso_paso_macro")))
		%>
			<tr>
				<td><%=caso_id%></td>
				<td><%=caso_titulo%></td>
				<td><%=caso_categoria%></td>
				<td><%=caso_motivo%></td>
				<td><%=caso_fecha_cre%></td>
				<td><%=caso_fecha_mod%></td>
				<td><%=caso_paso_macro%></td>
				<td><i class="icon-folder-open icon-large mano casoTraking" data-idCaso="<%=caso_id%>"></i></td>				
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
			var idSucursal = $('#v_idSucursal').val();	    
		    var idCaso = $(this).attr('data-idCaso');
		    //alert('idCaso: '+ idCaso);
		    $('.verCasos').html('<i class="icon-remove-sign"></i> <span style="font-size: 10px"><strong>CERRAR DETALLE CASO</strong></span>');

		    var pagina = 'sucursales/atencionCliente_sql.asp';
		    var datos = 'tipo=6&idSucursal='+idSucursal+'&idCaso='+idCaso;

		    $.ajax({
	            url: pagina,
	            data: datos,
	            type: "GET",
	            dataType: "html",
	            cache:false,
	            //async:true,
	            timeout:120000,
	            success: function(source){	
	              $('#divAddCasoSucces').slideUp();
	              $('#divAddCasoSucces').removeClass('listCasosOpen');
	              $('#divCasoDetalle').html(source);
	              $('#divCasoDetalle').slideDown();
	            },
	            error: function(source){
	              alert('error');
	            }
	        });
		 });

		 $('#tablacasos').dataTable( {
				"iDisplayLength": 13,	
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
<% 	end if
  end if %>

<% if tipo = "5" then  'LISTA DE CAJEROS RELACIONADOS' 
	idSucursal = request("idSucursal")
		
	sql = ""
	sql = sql & "select "
	sql = sql & "bt_sucursal, "
	sql = sql & "rut_personal, "
	sql = sql & "nombre_personal, "	
	sql = sql & "tipo_personal, "
	sql = sql & "tipo, "
	sql = sql & "empresa "
	sql = sql & "from SUC_sucursal_asistencia_personal "
	sql = sql & "where tipo in ('titular','reemplazo') "
	sql = sql & "and tipo_personal in ('Cajero','Cajero Adicional') and "
	sql = sql & "id_sucursal = " & idSucursal

	set rs = db.execute(sql)
	if not rs.eof then
%>
	<table class="table table-bordered table-condensed">
	<thead>
	<tr>
		<th>RUT</th>
		<th>NOMBRE</th>
		<th>CARGO</th>
		<th>TIPO</th>
		<th>EMPRESA</th>		
		<th>--</th>
	</tr>
	</thead>
	<tbody>
<%  do while not rs.eof 
		bt_sucursal = trim(rs("bt_sucursal"))
		rut_personal = trim(rs("rut_personal"))
		nombre_personal = trim(rs("nombre_personal"))
		tipo_personal = trim(rs("tipo_personal"))
		tipo = trim(rs("tipo"))
		empresa = trim(rs("empresa"))
%>
	<tr>		
		<td><%=rut_personal%></td>
		<td><%=nombre_personal%></td>
		<td><%=tipo_personal%></td>
		<td><%=tipo%></td>
		<td><%=empresa%></td>		
		<td><i class="icon-file icon-large mano selPersonal" data-empresa="<%=empresa%>" data-tipo="<%=tipo%>" data-tipoPersonal="<%=tipo_personal%>" data-nombrePersonal="<%=nombre_personal%>" data-rutPersonal="<%=rut_personal%>" data-btSucursal="<%=bt_sucursal%>"></i></td>				
	</tr>
<%	  rs.MoveNext
  	  loop
  	    rs.Close
  		set rs.ActiveConnection = nothing
  		set rs=nothing  			
	end if
%>
	</tbody>
	</table>
	<script type="text/javascript">
		$('.selPersonal').click(function(){
			var data_rutPersonal = $(this).attr('data-rutPersonal');
			var data_nombrePersonal = $(this).attr('data-nombrePersonal');
			var data_btSucursal = $(this).attr('data-btSucursal');
			var data_empresa = $(this).attr('data-empresa');
			var data_tipo = $(this).attr('data-tipo');
			var data_tipoPersonal = $(this).attr('data-tipoPersonal');			

			var html = ''
			html += '<tr class="info">'
			html += '<td>'+data_rutPersonal+'</td>'
            html += '<td>'+data_nombrePersonal+'</td>'
            html += '<td>'+data_tipoPersonal+'</td>'
            html += '<td>'+data_tipo+'</td>'            
            html += '<td>'+data_empresa+'</td>'
			html += '</tr>'

			$('#v_rutPersonal').val(data_rutPersonal);

			$('#tbl_cajerosSeleccionado').append(html);
			$('#cajerosSeleccionado').slideDown();
			$('#cajerosRelacionados').html();
			$('#cajerosRelacionados').slideUp();

			//alert('data_rutPersonal: ' + data_rutPersonal + ' - data_btSucursal: ' + data_btSucursal);
		});
	</script>
<% end if %>

<% if tipo = "6" then  'DETALLE DE CASO POR ID 	
	idSucursal = request("idSucursal")
	idCaso = request("idCaso")

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
	<p><span class="label label-info"><i class="icon-book"></i> DETALLE CASO</span></p>
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
		sql = sql & "A.usuarioWin, "	
		sql = sql & "convert(varchar(12), A.fecha_ingreso, 105) AS fecha_ingreso, "
		sql = sql & "convert(varchar(12), A.hora_ingreso, 108) AS hora_ingreso "
		sql = sql & "from SUC_casos_respuesta A "
		sql = sql & "inner join SUC_usuario B "
		sql = sql & "on A.caso_respuesta_back_user = B.id_usuario "
		sql = sql & "where A.id_caso = " & idCaso
		sql = sql & "order by id_caso_respuesta "

		set rs4 = db.execute(sql)
		if not rs4.eof then		
	%>
	<p><span class="label label-warning"><i class="icon-book"></i> RESPUESTA</span></p>
		<% do while not rs4.eof %>
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
		end if 
	%>
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
end if
%>



