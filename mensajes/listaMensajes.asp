<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
perfil = trim(request("perfil"))
tipo = trim(request("tipo"))
idUsuario = trim(request("idUsuario"))
if tipo = "1" then
			'recibidos'
	if perfil = "1" then
		sql = ""
		sql = sql & " select a.id_msg as idMensaje, "
		sql = sql & " a.ingreso_fecha as fecha, "
		sql = sql & " cast(a.ingreso_hora as datetime) as hora, "
		sql = sql & " a.sub as asunto "
		sql = sql & " from SUC_msg a "
		sql = sql & " inner join SUC_msg_dest b on a.id_msg = b.id_msg "
		sql = sql & " inner join SUC_msg_tipo c on a.id_msgtipo = c.id_msgtipo "
		sql = sql & " inner join SUC_usuario d on a.id_usuario = d.id_usuario "
		sql = sql & " where b.id_dest = '"&idUsuario&"' "
		sql = sql & " order by fecha desc, hora desc "
	end if
	if perfil = "2" then
		sql = ""
		sql = sql & " select id_zonal from SUC_zonales where id_usuario = '"&idUsuario&"'"
		set rs = db.execute(sql)
		if not rs.eof then
			idUsuario = trim(rs("id_zonal"))
		end if
		sql = ""
		sql = sql & " select a.id_msg as idMensaje, "
		sql = sql & " a.ingreso_fecha as fecha, "
		sql = sql & " cast(a.ingreso_hora as datetime) as hora, "
		sql = sql & " a.sub as asunto "
		sql = sql & " from SUC_msg a "
		sql = sql & " inner join SUC_msg_dest b on a.id_msg = b.id_msg "
		sql = sql & " inner join SUC_msg_tipo c on a.id_msgtipo = c.id_msgtipo "
		sql = sql & " where b.id_dest = '"&idUsuario&"' "
		sql = sql & " and c.id_msgtipo in (1,6) "
	end if
	if perfil="3"  then
		sql = ""
		sql = sql & " select a.id_msg as idMensaje, "
		sql = sql & " a.ingreso_fecha as fecha, "
		sql = sql & " cast(a.ingreso_hora as datetime) as hora, "
		sql = sql & " a.sub as asunto "
		sql = sql & " from SUC_msg a "
		sql = sql & " inner join SUC_msg_dest b on a.id_msg = b.id_msg "
		sql = sql & " inner join SUC_msg_tipo c on a.id_msgtipo = c.id_msgtipo "
		sql = sql & " inner join SUC_usuario d on a.id_usuario = d.id_usuario "
		sql = sql & " where b.id_dest = '0' "
		sql = sql & " order by fecha desc, hora desc "
	end if

''	if perfil = "1" or perfil = "2"  then
''		sql = sql & " where b.id_dest = '"&idUsuario&"' "
''	end if
''	sql = sql & " order by fecha desc, hora desc "
else
	'enviados'

		sql = ""
		sql = sql & "select id_msg as idMensaje,  "
		sql = sql & " ingreso_fecha as fecha, "
		sql = sql & " cast(ingreso_hora as datetime) as hora, "
		sql = sql & " sub as asunto "	
		sql = sql & "from SUC_msg "
		if perfil ="2" then
			sql = sql & " where id_usuario = (select id_usuario from SUC_zonales where id_usuario = '"&idUsuario&"')  "
		else
			sql = sql & " where id_usuario = '"&idUsuario&"'  "
		end if
		sql = sql & "order by fecha desc, hora desc"
end if
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()%>
	<div class="row-fluid">
		<div class="span12">
			<table class="table table-bordered table-hover" id="muestraMensajes">
				<thead>
					<tr>
						<td width="11%">Fecha</td>
						<td width="11%">Hora</td>
						<td>Asunto</td>
						<td>Estado</td>
					</tr>
				</thead>
				<tbody id="muestraMensajesBody">
					<%For i = 0 to ubound(datos, 2)
					idMensaje = trim(datos(0,i))
					fechaMensaje = trim(datos(1,i))
					horaMensaje = sacaHora(trim(datos(2,i)))
					asuntoMensaje = server.htmlencode(trim(datos(3,i)))%>
						<tr id="<%=idMensaje%>" class="revisaMensaje mano" data-idMensaje="<%=idMensaje%>" data-tipoMensaje="<%=tipo%>">
							<td>
								<%=fechaMensaje%>
							</td>
							<td>
								<%=horaMensaje%>
							</td>
							<td>
								<%=asuntoMensaje%>
							</td>
							<td class="mensajeLeido<%=idMensaje%>">
								<%sql2 =""
								sql2 = sql2 & " select isnull(readMsg,0) as readMsg "
								sql2 = sql2 & " from SUC_msg_dest "
								sql2 = sql2 & " where id_msg = '"&idMensaje&"' "
								set rs2 = db.execute(sql2)
								if not rs2.eof then
									txtMensajeLeido = trim(rs2("readMsg"))
								else
									txtMensajeLeido = "0"
								end if
								if txtMensajeLeido = "0" then%>
									<i class="icon-envelope"></i>
								<%else%>
									<i class="icon-envelope-alt"></i>
								<%end if%>
							</td>
						
						</tr>
					<%next%>
				</tbody>
			</table>
		</div>
	</div>
<%else%>
	<div class="row-fluid">
		<div class="span4"></div>
		<div class="span4 alert alert-success text-center">
			<span class="icon-stack">
				<i class="icon-envelope"></i>
				<i class="icon-ban-circle icon-stack-base text-error"></i>
			</span>
			<strong>
				No registran mensajes
			</strong>
		</div>
		<div class="span4"></div>
	</div>
<%end if%>
<script type="text/javascript">
$('.revisaMensaje').click(function(){
	var idMensaje = $(this).attr('data-idMensaje');
	var tipoMensaje = $(this).attr('data-tipoMensaje');
	$('#revisaMensajesDiv').removeClass('oculto');
	$('#separacionBotones').addClass('span9').removeClass('span7');
	$('#revisaMensajes').fadeIn('slow');
	$('#botonNuevoMensaje').slideUp('slow');
	var pagina = 'mensajes/revisaMensaje.asp';
	var div = 'revisaMensajes';
	var datos = 'idMensaje='+idMensaje+'&tipo='+tipoMensaje;
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
});
</script>