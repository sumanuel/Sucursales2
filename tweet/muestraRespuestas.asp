<!--#include file="../funciones.asp"-->
<%idMensaje = trim(request("idMensaje"))
usuarioActual = trim(request("idUsuario"))
fechaActual =  now()
sql3 = sql3 & " select id_mensaje_tw, "
sql3 = sql3 & " a.id_usuario, "
sql3 = sql3 & " a.id_sucursal, "
sql3 = sql3 & " b.id_perfil, "
sql3 = sql3 & " a.mensaje, "
sql3 = sql3 & " a.id_usuario_respuesta, "
sql3 = sql3 & " b.u_nombres +' '+b.u_apellidos as usuarioEnvia, "
sql3 = sql3 & " a.fecha "
sql3 = sql3 & " from SUC_timeline a, "
sql3 = sql3 & " SUC_usuario b "
sql3 = sql3 & " where "
sql3 = sql3 & " a.id_usuario = b.id_usuario "
sql3 = sql3 & " and id_inicia = '"&idMensaje&"' "
sql3 = sql3 & " order by id_mensaje_tw asc "
set rs3 = db.execute(sql3)
if not rs3.eof then
	datos2 = rs3.GetRows()
	datosMuestra2 = ""
	for x=0 to ubound(datos2,2)
		idMensaje2 = trim(datos2(0,x))
		idUsuario2 = trim(datos2(1,x))
		usuarioActual2 = trim(request("idUsuario"))
		idSucursal2 = trim(datos2(2,x))
		idPerfil2 = trim(datos2(3,x))
		if idPerfil2 <> "1" then
			if idPerfil2 = "2" then
				nombreSucursal2 = "Zonal"
				icono2 = "icon-building"
			end if
			if idPerfil2 = "3" then
				nombreSucursal2 = "Operaciones"
				icono2= "icon-briefcase"
			end if
			if idPerfil2 = "4" then
				nombreSucursal2 = "Divisional"
				icono2 = "icon-group"
			end if
		else
			sql4 = ""
			sql4 = sql4 & " select suc_nombre from suc_sucursal where id_sucursal = '"&idSucursal&"'"
			set rs4 = db.execute(sql4)
			if not rs2.eof then
				nombreSucursal2 = trim(rs4(0))
				icono2 = "icon-home"
			end if
		end if
		if idUsuario2 = usuarioActual then
			nombreSucursal2 = "Yo" 
		else
		end if
		mensaje2 = trim(datos2(4,x))
		idUsuarioRespuesta2 = trim(datos2(5,x))
		nombreUsuario2 = server.htmlencode(trim(datos2(6,x)))
		fechaMensaje2 = cdate(trim(datos2(7,x)))
		fechaMensaje2 = DateDiff("n",fechaMensaje2,fechaActual)%>
		<div class="row-fluid">
			<div class="span12 alert alert-danger seleccionaSucursalTl2 mano" data-idMensaje="<%=idMensaje%>" data-nombreSucursal="<%=nombreSucursal2%>" data-nombreUsuario="<%=nombreUsuario2%>">
				<div class="row-fluid">
					<div class="span5">
						<span class="badge badge-inverse">
							<i class="<%=icono2%>"></i>
								<%=nombreUsuario2%>
						</span>
					</div>
					<div class="span4 ">
						<span class="badge">
							<%=nombreSucursal2%>
						</span>
					</div>
					<div class="span3">
						<%if idUsuarioRespuesta2 <> "0" then%>
							<span class="badge badge-inverse">
								<i class="icon-reply-all"></i>
							</span>
						<%end if%>
						<span class="badge badge-inverse horaMensajex" id="horax<%=idMensaje2%>" data-minutos="<%=fechaMensaje2%> " data-idMensaje="<%=idMensaje2%>">
							<span id="muestraMinutosx<%=idMensaje2%>"></span>
						</span>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span11">
						<div class="row-fluid ">
							<div class="span12 ">
								<%=mensaje2%>
							</div>
						</div>						
					</div>
				</div>
			</div>
		</div>
	<%next
end if%>
<script type="text/javascript">
moment.lang('es');
moment().format();
$('.horaMensajex').each(function(){
	var idMensaje = $(this).attr('data-idMensaje');
	var minutos = -1 * parseInt($(this).attr('data-minutos'));
	var totalMinutos = moment.duration(minutos, "minutes").humanize(true);
	$('#muestraMinutosx'+idMensaje).text(totalMinutos);
});
$('.seleccionaSucursalTl2').click(function(){
	var idMensaje = $(this).attr('data-idMensaje');
	var nombreSucursal = $(this).attr('data-nombreSucursal');
	var nombreUsuario = $(this).attr('data-nombreUsuario');
	$('#textoMensajes').slideUp('fast');
	$('#formularioMensaje').slideDown('slow');
	$('#respondiendo').slideDown('slow').text('A: '+nombreUsuario);
	$('#respuesta').val(idMensaje);
	return false;
});
</script>