<!--#include file="../funciones.asp"-->
<%perfil = trim(request("perfilMain"))
  idUsuario = trim(request("idUsuarioMain"))
  idSucursal = trim(request("idSucursalMain"))
  if idSucursal = "0" then
    idSucursal = trim(request("idSucursal"))
  end if%>
<br/>
<div id="cuerpoAsistCajeros">
	<div id="divAsistCajero" class="oculto" data-idSucursal="<%=idSucursal%>" data-idUsuario="<%=idUsuario%>" data-perfil="<%=perfil%>"> </div>
	<div class="row-fluid">
		<div class="span12" id="cajeroAsistSubMenu"></div>
	</div>
	<div class="row-fluid" id="cajeroCuerpoTabla">
		<div class="span12" id="cargaCajeroCuerpoTabla"></div>
	</div>
	
</div>

<script type="text/javascript">
$(function(){
	var pagina, div, datos, idSucursal, idUsuario, idPerfil;
	idSucursal = $('#divAsistCajero').attr('data-idSucursal')
	idUsuario = $('#divAsistCajero').attr('data-idUsuario');
	idPerfil = $('#divAsistCajero').attr('data-perfil');
	pagina = 'sucursales/asistenciaSucursalCajerosSubMenu.asp';
	div = 'cajeroAsistSubMenu';
	datos = 'idSucursal='+idSucursal+'&idUsuario='+idUsuario+'&idPerfil='+idPerfil;
	enviaDatos(pagina,div,datos);
	$('#cajeroAsistSubMenu').html('');
});
</script>
