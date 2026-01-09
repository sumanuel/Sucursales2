<!--#include file="../funciones.asp"-->
<%tipoUsuario = trim(request("idTipoUsuario"))
idSucursal = trim(request("idSucursal"))
perfil = trim(request("perfil"))%>
<div class="row-fluid">
	<div class="span12">
		<span class="botonVuelveSeleccion pull-right mano">
			<i class="icon-reply icon-2x"></i>
			Volver
		</span>
	</div>
</div>
<div class="row-fluid">
	<div class="span12">
		<span class="seleccionaTodos pull-right mano">
			<i class="icon-certificate icon-2x"></i>
			Seleccionar todos
		</span>
	</div>
</div>
<div class="control-group">
	<label class="control-label" for="idUsuarioDestino">
		<strong>
			Enviar mensaje a:
		</strong>
	</label>
	<div class="controls">
		<input type="hidden" name="idUsuarioDestino" id="idUsuarioDestino">
		<input type="hidden" name="totalUsuarios" id="totalUsuarios">
		<input type="hidden" name="mensajeTipo" id="mensajeTipo">
		<span id="usuarioDestino"></span>
	</div>
</div>
<script type="text/javascript">
$(function(){
<%select case perfil
	case "1":
		select case tipoUsuario
			case "2":
				sql = ""
				sql = sql & " select id_zonal, zonal "
				sql = sql & " from suc_zonales "
				sql = sql & " where id_usuario in "
				sql = sql & " (select id_zonal "
				sql = sql & " from SUC_zonales_sucursal "
				sql = sql & " where id_sucursal = '"&idSucursal&"')"
				set rs = db.execute(sql)
				if not rs.eof then
					idUsuario = trim(rs(0))
					nombreUsuario = server.htmlencode(trim(rs(1)))
					totalUsuarios = "1"
				end if
				rs.Close
				set rs.ActiveConnection = nothing
				set rs=nothing%>
				$('#usuarioDestino').html('<%=nombreUsuario%>').addClass('badge');
				$('#idUsuarioDestino').val('<%=idUsuario%>');
				$('#totalUsuarios').val('<%=totalUsuarios%>');
				$('.seleccionaTodos').addClass('oculto');
				$('#mensajeTipo').val('6');
				var pagina = 'mensajes/cuerpoMensaje.asp';
				var div = 'cuerpoMensaje';
				var datos = '';
				try{
					enviaDatos(pagina,div,datos);
				}
				catch(err){}
				return false;
			<%case "3":%>
				$('#usuarioDestino').html('Operaciones').addClass('badge');
				$('#idUsuarioDestino').val('0');
				$('#totalUsuarios').val('1');
				$('.seleccionaTodos').addClass('oculto');
				$('#mensajeTipo').val('5');
				var pagina = 'mensajes/cuerpoMensaje.asp';
				var div = 'cuerpoMensaje';
				var datos = '';
				try{
					enviaDatos(pagina,div,datos);
				}
				catch(err){}
				return false;
		<%end select
	case "2"
		select case tipoUsuario
			case "1":%>
				$('#mensajeTipo').val('4');
				var pagina = 'mensajes/seleccionaSucursales.asp';
				var div = 'cuerpoMensaje';
				var datos = '';
				try{
					enviaDatos(pagina,div,datos);
				}
				catch(err){}
				return false;
			<%case "3":%>
				$('#usuarioDestino').html('Operaciones').addClass('badge');
				$('#idUsuarioDestino').val('0');
				$('#totalUsuarios').val('1');
				$('.seleccionaTodos').addClass('oculto');
				$('#mensajeTipo').val('3');
				var pagina = 'mensajes/cuerpoMensaje.asp';
				var div = 'cuerpoMensaje';
				var datos = '';
				try{
					enviaDatos(pagina,div,datos);
				}
				catch(err){}
				return false;
		<%end select
	case "3"
		select case tipoUsuario
			case "2":%>
				var pagina = 'mensajes/seleccionaZonales.asp';
				var div = 'cuerpoMensaje';
				var datos = 'clickZonal=0'
				$('#mensajeTipo').val('1');
				try{
					enviaDatos(pagina,div,datos);
				}
				catch(err){}
			<%case "1":%>
				$('#mensajeTipo').val('2');
				var pagina = 'mensajes/seleccionaZonales.asp';
				var div = 'cuerpoMensaje';
				var datos = 'clickZonal=1'
				try{
					enviaDatos(pagina,div,datos);
				}
				catch(err){}
				return false;
		<%end select
end select%>
})
$('.botonVuelveSeleccion').click(function(){
	$('.botonesSeleccion').removeClass('oculto').slideDown('slow');
	$('#destinatario').slideUp('slow');
	$('#cuerpoMensaje').slideUp('slow');
	return false;
});
$('.seleccionaTodos').click(function(){
	$('#cuerpoMensaje').slideUp();
	$('#usuarioDestino').text('');
	var muestraTodos = '<span class="badge badge-success">Todos</span>';
	$('#usuarioDestino').append(muestraTodos);
	$('#idUsuarioDestino').val('todos');
	var pagina = 'mensajes/cuerpoMensaje.asp';
	var div = 'cuerpoMensaje';
	var datos = '';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
});
</script>