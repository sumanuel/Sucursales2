<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuario"))
perfil = trim(request("perfil"))
contador= 0
if perfil = "3" then
	idZonal = trim(request("idZonal"))
	sql = ""
	sql = sql & " select id_sucursal, "
	sql = sql & " suc_nombre "
	sql = sql & " from suc_sucursal "
	sql = sql & " where id_sucursal in "
	sql = sql & " (select id_sucursal "
	sql = sql & " from SUC_usuario_sucursal a, "
	sql = sql & " SUC_zonales b "
	sql = sql & " where a.id_usuario = b.id_usuario "
	sql = sql & " and b.id_zonal = '"&idZonal&"' )"
else
	sql = ""
	sql = sql & " select id_sucursal,"
	sql = sql & " suc_nombre "
	sql = sql & " from suc_sucursal "
	sql = sql & " where id_sucursal in "
	sql = sql & " (select id_sucursal "
	sql = sql & " from SUC_usuario_sucursal "
	sql = sql & " where id_usuario = '"&idUsuario&"')"	
end if
set rs = db.execute(sql)
if not rs.eof then%>
<div class="row-fluid">
	<div class="span12">
		<span id="textoSeleccionaSucursal">
			<strong>
				Seleccione Sucursal:
			</strong>
		</span>
			<%do while not rs.eof
				nombreSucursal = server.htmlencode(trim(rs("suc_nombre")))
				idSucursal = trim(rs("id_sucursal"))
				if contador= 0 then
					todos = todos&idSucursal
				else
					todos = todos&","&idSucursal
				end if%>
				<span class="seleccionado badge badge-important mano" id="<%=idSucursal%>" data-idSucursal="<%=idSucursal%>">
					<i class="icon-ok"></i>
					<%=nombreSucursal%>
				</span>
				&nbsp;
				<%rs.movenext
				contador = contador+1
			loop
		end if
		rs.Close
		set rs.ActiveConnection = nothing
		set rs=nothing
		DB.Close
		set DB=nothing%>
		<span class="oculto" id="maximoTodos" data-total="<%=contador%>" data-idSucursal="todos"></span>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="continuacionMensaje">
<div id="continuacionMensaje"></div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	var idUsuarioDestino = $('#idUsuarioDestino').val();
	var idTipoMensaje = $('#mensajeTipo').val();
	var arr = idUsuarioDestino.split(',')
	for (i=0 ; i <= arr.length; i++)
	{
		idSeleccionado = arr[i];
		$('.seleccionado').each(function(){
			var idNoSeleccionado = $(this).attr('data-idSucursal');
			if (idSeleccionado == idNoSeleccionado)
			{
				$(this).remove();
			}
		});
	}
	if (arr.length > "1")
	{
		var pagina = 'mensajes/cuerpoMensaje.asp';
		var div = 'continuacionMensaje';
		var datos = ''
		try{
			enviaDatos(pagina,div,datos);
		}
		catch(err){}	
	}
	return false;
})
$('.seleccionado').click(function(){
	var sucursal = '<span class="badge badge-success">'+$(this).text()+'</span>&nbsp;&nbsp;';
	var idSucursal = $(this).attr('data-idSucursal');
	var maximoParaTodos = parseInt($('#maximoTodos').data('total'));
	if (idSucursal != "todos")
	{
		$('#usuarioDestino').append(sucursal);
		$('#'+idSucursal).remove();
		var totalUsuarios = $('#totalUsuarios').val();
		if (totalUsuarios == '')
		{
			totalUsuarios = 1;
		}
		else
		{
			totalUsuarios = parseInt(totalUsuarios);
			totalUsuarios += 1;
		}
		$('#totalUsuarios').val(totalUsuarios);
		$("#idUsuarioDestino").addToArray(idSucursal);
		if (totalUsuarios == maximoParaTodos)
		{
			var muestraTodos = '<span class="badge badge-success">Todos</span>';
			$('#idUsuarioDestino').val('');
			$('#idUsuarioDestino').val('todos');
			$('#usuarioDestino').text('');
			$('#usuarioDestino').append(muestraTodos);
			$('#textoSeleccionaSucursal').remove();
			$('.seleccionaTodos').remove();
			$('.seleccionado').remove();
		}
	}
	else
	{
		var todos = $('#todos').data('valor');
		$('#idUsuarioDestino').attr('value','');
		$('#idUsuarioDestino').val(todos);
		muestraTodos = '<span class="badge badge-success">Todos</span>';
		totalUsuarios = $('#todos').attr('data-total');
		$('#totalUsuarios').val(totalUsuarios);
		$('#usuarioDestino').text('');
		$('#usuarioDestino').append(muestraTodos);
		$('.seleccionado').remove();

	}
	var pagina = 'mensajes/cuerpoMensaje.asp';
	var div = 'continuacionMensaje';
	var datos = ''
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
});
</script>
