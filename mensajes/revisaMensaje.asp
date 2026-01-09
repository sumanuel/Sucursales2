<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
idMensaje = trim(request("idMensaje"))
tipo = trim(request("tipo"))
if perfil = "3" then idUsuario = "0"%>
<div class="row-fluid">
	<div class="span12">
		<span class="pull-right cierraRevisaMensaje">
			<a class="close " href="#">
				&times;
			</a>
		</span>
	</div>
</div>
<%if perfil = "2" then
	sql2 = ""
	sql2 = sql2 & "select id_zonal from SUC_zonales where id_usuario = '"&idUsuario&"'"
	set rs2 = db.execute(sql2)
	if not rs2.eof then
		idUsuario = trim(rs2("id_zonal"))
	end if
end if
if tipo = "1" then
	sql = ""
	sql = sql & " select a.id_msg as idMensaje, "
	sql = sql & " a.msg as mensaje, "
	sql = sql & " sub as asunto, "
	sql = sql & " a.ingreso_fecha as fecha, "
	sql = sql & " cast(a.ingreso_hora as datetime) as hora " 
   	sql = sql & " from SUC_msg a "
	sql = sql & " inner join SUC_msg_tipo c on a.id_msgtipo = c.id_msgtipo "
   	sql = sql & " where a.id_msg = '"&idMensaje&"'  "
else
	'enviados'
	sql = ""
	sql = sql & "select id_msg as idMensaje,  sub as asunto, msg as mensaje, "
	sql = sql & " ingreso_fecha as fecha, "
	sql = sql & " cast(ingreso_hora as datetime) as hora "
	sql = sql & "from SUC_msg where "
	sql = sql & " id_msg = '"&idMensaje&"' order by fecha desc "
end if
set rs = db.execute(sql)
if not rs.eof then
	idMensaje = trim(rs("idMensaje"))
	fechaMensaje = trim(rs("fecha"))
	horaMensaje = sacaHora(trim(rs("hora")))
	asuntoMensaje = server.htmlencode(trim(rs("asunto")))
	mensaje = server.htmlencode(trim(rs("mensaje")))
	if tipo = "1" then
		sql2 =""
		sql2 = sql2 & " select isnull(readMsg,0) as readMsg "
		sql2 = sql2 & " from SUC_msg_dest "
		sql2 = sql2 & " where id_msg = '"&idMensaje&"' "
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			txtMensajeLeido = trim(rs2("readMsg"))
		else
			txtMensajeLeido = "0"
		end if
		rs2.Close
  		set rs2.ActiveConnection = nothing
  		set rs2=nothing
		if txtMensajeLeido = "0" then			
			sql2 = " exec SUC_prc_msg_up '"&idMensaje&"', '"&idUsuario&"'"
			set rs2 = db.execute(sql2)%>
			<script type="text/javascript">
				$('.mensajeLeido<%=idMensaje%>').html('<i class="icon-envelope-alt"></i>');
			</script>
		<%end if
	end if%>
	<div class="row-fluid">
		<div class="span12">
			<table>
				<tr>
					<td width="30%">
						Asunto 
						<span class="pull-right">
							:
						</span>
					</td>
					<td>
						<%=asuntoMensaje%>
					</td>
				</tr>
				<tr>
					<td>
						Fecha 
						<span class="pull-right">
							:
						</span>
					</td>
					<td>
						<%=server.htmlencode(FormatDateTime(fechaMensaje,1))%>
					</td>
				</tr>
				<tr>
					<td>
						Hora 
						<span class="pull-right">
							:
						</span>
					</td>
					<td>
						<%=horaMensaje%>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<strong>
							<%=mensaje%>
						</strong>
					</td>
				</tr>
			</table>
		</div>
	</div>	
<%end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
DB.Close
set DB=nothing%>
<script type="text/javascript">
$('.cierraRevisaMensaje').click(function(){
	$('#separacionBotones').addClass('span7').removeClass('span9');
	$('#revisaMensajes').slideUp('slow');
	$('#botonNuevoMensaje').fadeIn('slow');
	return false;
});
</script>