<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuario"))
fechaActual =  now()
sql = ""
sql = sql & " select id_mensaje_tw, "
sql = sql & " a.id_usuario, "
sql = sql & " a.id_sucursal, "
sql = sql & " b.id_perfil, "
sql = sql & " a.mensaje, "
sql = sql & " a.id_usuario_respuesta, "
sql = sql & " b.u_nombres +' '+b.u_apellidos as usuarioEnvia, "
sql = sql & " a.fecha "
sql = sql & " from SUC_timeline a, "
sql = sql & " SUC_usuario b "
sql = sql & " where "
'sql = sql & " id_mensaje_tw in (select top 20(id_mensaje_tw) "
'sql = sql & " from SUC_timeline order by id_mensaje_tw) "
sql = sql & " a.id_usuario = b.id_usuario "
'sql = sql & " and id_inicia = '0' "
sql = sql & " order by id_mensaje_tw desc "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	datosMuestra = ""
	tabla = ""
	for i=0 to ubound(datos,2)
		idMensaje = trim(datos(0,i))
		idUsuario = trim(datos(1,i))
		usuarioActual = trim(request("idUsuario"))
		idSucursal = trim(datos(2,i))
		idPerfil = trim(datos(3,i))
		if idPerfil <> "1" then
			if idPerfil = "2" then
				nombreSucursal = "Zonal"
				icono = "icon-building"
			end if
			if idPerfil = "3" then
				nombreSucursal = "Operaciones"
				icono= "icon-briefcase"
			end if
			if idPerfil = "4" then
				nombreSucursal = "Divisional"
				icono = "icon-group"
			end if
		else
			sql2 = ""
			sql2 = sql2 & " select suc_nombre from suc_sucursal where id_sucursal = '"&idSucursal&"'"
			set rs2 = db.execute(sql2)
			if not rs2.eof then
				nombreSucursal = trim(rs2(0))
				icono = "icon-home"
			end if
		end if
		if idUsuario = usuarioActual then
			nombreSucursal = "Yo" 
			selecciona = "  "
		else
			selecciona = " seleccionaSucursalTl mano  "
		end if
		mensaje = trim(datos(4,i))
		idUsuarioRespuesta = trim(datos(5,i))
		nombreUsuario = server.htmlencode(trim(datos(6,i)))
		fechaMensaje = cdate(trim(datos(7,i)))
		fechaMensaje = DateDiff("n",fechaMensaje,fechaActual)%>
		<div class="row-fluid mensajeTl" id="<%=idMensaje%>">
			<div class="span12">
				<div class="row-fluid">
					<div class="span5 <%=selecciona%>"  data-idMensaje="<%=idMensaje%>" data-nombreSucursal="<%=nombreSucursal%>" data-nombreUsuario="<%=nombreUsuario%>" id="<%=idMensaje%>">
						<span class="badge badge-inverse">
							<i class="<%=icono%>"></i>
								<%=nombreUsuario%>
						</span>
					</div>
					<div class="span4 <%=selecciona%>"  data-idMensaje="<%=idMensaje%>" data-nombreSucursal="<%=nombreSucursal%>" data-nombreUsuario="<%=nombreUsuario%>">
						<span class="badge">
							<%=server.htmlencode(nombreSucursal)%>
						</span>
					</div>
					<div class="span3">
						<%if idUsuarioRespuesta <> "0" then%>
							<a href="#<%=idUsuarioRespuesta%>" class="noLink" data-usuarioRespuesta="<%=idUsuarioRespuesta%>">
								<span class="badge badge-inverse">
									<i class="icon-reply-all"></i>
								</span>
							</a>
						<%end if%>
						<span class="badge badge-inverse horaMensaje" id="hora<%=idMensaje%>" data-minutos="<%=fechaMensaje%> " data-idMensaje="<%=idMensaje%>">
							<span id="muestraMinutos<%=idMensaje%>"></span>
						</span>
						<%sql2 = ""
						sql2 = sql2 & "select count(id_mensaje_tw) from SUC_timeline where id_inicia = '"&idMensaje&"'"
						set rs2 = db.execute(sql2)
						if not rs2.eof then
							totalHijos = trim(rs2(0))
						end if
						if totalHijos > 0 then%>
							<span class="badge badge-info mano buscaRespuestas" data-idMensaje="<%=idMensaje%>">
								<%if totalHijos = "1" then%>
									1 respuesta
								<%else%>
									<%=totalHijos%> Respuestas
								<%end if%>
							</span>
						<%end if%>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<div class="row-fluid">
							<div class="span12 alert alert-success">
								<%=server.htmlencode(mensaje)%>
							</div>
						</div>						
					</div>
					<div class="row-fluid oculto" id="respuestas<%=idMensaje%>">
						<div class="span12" id="respuesta<%=idMensaje%>"></div>
					</div>
				</div>
			</div>
		</div>
	<%next
end if%>
<script type="text/javascript">
moment.lang('es');
moment().format();
$('.seleccionaSucursalTl').click(function(){
	var idMensaje = $(this).attr('data-idMensaje');
	var nombreSucursal = $(this).attr('data-nombreSucursal');
	var nombreUsuario = $(this).attr('data-nombreUsuario');
	$('#textoMensajes').slideUp('fast');
	$('#formularioMensaje').slideDown('slow');
	$('#respondiendo').slideDown('slow').text('A: '+nombreUsuario);
	$('#respuesta').val(idMensaje);
	return false;
});
$('.horaMensaje').each(function(){
	var idMensaje = $(this).attr('data-idMensaje');
	var minutos = -1 * parseInt($(this).attr('data-minutos'));
	var totalMinutos = moment.duration(minutos, "minutes").humanize(true);
	$('#muestraMinutos'+idMensaje).text(totalMinutos);
});
$('.buscaRespuestas').click(function(){
	idMensaje = $(this).attr('data-idMensaje');
	$('#'+idMensaje).removeClass('mensajeTl').addClass('mensajeTl2');
	setTimeout(function() {
		$('#'+idMensaje).removeClass('mensajeTl2').addClass('mensajeTl');
	}, 2000);
	$('#respuestas'+idMensaje).removeClass('oculto');
	var pagina, div, datos
	pagina = 'tweet/muestraRespuestas.asp';
	div = 'respuesta'+idMensaje;
	datos = 'idMensaje='+idMensaje;
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('.noLink').click(function(){
	idMensaje = $(this).attr('data-usuarioRespuesta');
	$('#'+idMensaje).removeClass('mensajeTl').addClass('mensajeTl2');
	setTimeout(function() {
		$('#'+idMensaje).removeClass('mensajeTl2').addClass('mensajeTl');
	}, 2000);
	$('#respuestas'+idMensaje).removeClass('oculto');
	var pagina, div, datos
	pagina = 'tweet/muestraRespuestas.asp';
	div = 'respuesta'+idMensaje;
	datos = 'idMensaje='+idMensaje;
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
</script>