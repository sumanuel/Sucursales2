<!--#include file="../funciones.asp"-->
<%
	perfil = trim(request("idPerfil"))
	idUsuario = trim(request("idUsuario"))
	idSucursal = trim(request("idSucursal"))
%>

<input type="hidden" name="id_Perfil" id="id_Perfil" value="<%=perfil%>"/>
<input type="hidden" name="id_Usuario" id="id_Usuario" value="<%=idUsuario%>"/>
<input type="hidden" name="id_Sucursal" id="id_Sucursal" value="<%=idSucursal%>"/>

<ul class="nav nav-tabs" id="subMenuAistenciaCajeros" data-idSucursal="<%=idSucursal%>" data-idUsuario="<%=idUsuario%>" data-perfil="<%=perfil%>">
	<li  id="inicio">
		<a href="#">
			<i class="icon-home"></i> Asistencia Cajeros
		</a>
	</li>
	<li  id="idRaclamos">
		<a href="#">
			<i class="icon-folder-open"></i> Reclamos
		</a>
	</li>
	<li id="idFaltante" data-tipoMenu="2">
		<a href="#">
			<i class="icon-sitemap"></i> Faltantes
		</a>
	</li>
	<li  id="idCapacit">
		<a href="#">
			<i class="icon-folder-open"></i> Capacitación
		</a>
	</li>
</ul>
<script type="text/javascript">
	$(function(){
		$('#cargaCajeroCuerpoTabla').html('');
		var pagina, div, datos, idSucursal, idUsuario, idPerfil;
		idSucursal = $('#subMenuAistenciaCajeros').attr('data-idSucursal');
		idUsuario = $('#subMenuAistenciaCajeros').attr('data-idUsuario');
		idPerfil = $('#subMenuAistenciaCajeros').attr('data-perfil');

		$('ul#subMenuAistenciaCajeros > li').each(function() {
			$(this).removeClass('active')	
		});

		$('li#inicio').addClass('active');
			pagina = 'sucursales/asistenciaSucursalCajeros.asp';
			div = 'cargaCajeroCuerpoTabla';
			datos='idSucursal='+idSucursal+'&idUsuario='+idUsuario+'&perfilMain='+perfil;
			enviaDatos(pagina,div,datos);
		$('#cargaCajeroCuerpoTabla').html('');
	});

	$('#inicio').click(function() {
		var pagina, div, datos, idSucursal, idUsuario, idPerfil;
		idSucursal = $('#subMenuAistenciaCajeros').attr('data-idSucursal');
		idUsuario = $('#subMenuAistenciaCajeros').attr('data-idUsuario');
		idPerfil = $('#subMenuAistenciaCajeros').attr('data-perfil');

		$('ul#subMenuAistenciaCajeros > li').each(function() {
			$(this).removeClass('active');
		});
		$('#inicio').addClass('active');
			pagina = 'sucursales/asistenciaSucursalCajeros.asp';
			div = 'cargaCajeroCuerpoTabla';
			datos='idSucursal='+idSucursal+'&idUsuario='+idUsuario+'&perfilMain='+perfil;
			enviaDatos(pagina,div,datos);	
	});

	$('#idRaclamos').click(function() {
		var pagina, div, datos, idSucursal, idUsuario, idPerfil;
		idSucursal = $('#subMenuAistenciaCajeros').attr('data-idSucursal');
		idUsuario = $('#subMenuAistenciaCajeros').attr('data-idUsuario');
		idPerfil = $('#subMenuAistenciaCajeros').attr('data-perfil');

		$('ul#subMenuAistenciaCajeros > li').each(function() {
			$(this).removeClass('active');
		});
		$('#idRaclamos').addClass('active');
			pagina = 'sucursales/reclamoCajeros.asp';
			div = 'cargaCajeroCuerpoTabla';
			datos='idSucursalMain='+idSucursal+'&idUsuarioMain='+idUsuario+'&perfilMain='+perfil;
			enviaDatos(pagina,div,datos);
		$('#cargaCajeroCuerpoTabla').html('');	
	});


	$('#idFaltante').click(function() {
		var pagina, div, datos, idSucursal, idUsuario, idPerfil;
		idSucursal = $('#subMenuAistenciaCajeros').attr('data-idSucursal');
		idUsuario = $('#subMenuAistenciaCajeros').attr('data-idUsuario');
		idPerfil = $('#subMenuAistenciaCajeros').attr('data-perfil');

		$('ul#subMenuAistenciaCajeros > li').each(function() {
			$(this).removeClass('active');
		});
		$('#idFaltante').addClass('active');
			pagina = 'sucursales/cajeroFaltantes.asp';
			div = 'cargaCajeroCuerpoTabla';
			datos='idSucursal='+idSucursal+'&idUsuario='+idUsuario+'&idPerfil='+perfil;
			enviaDatos(pagina,div,datos);
		$('#cargaCajeroCuerpoTabla').html('');	
	});

	$('#idCapacit').click(function() {
		var pagina, div, idSucursal, idUsuario, idPerfil;
		idSucursal = $('#subMenuAistenciaCajeros').attr('data-idSucursal');
		idUsuario = $('#subMenuAistenciaCajeros').attr('data-idUsuario');
		idPerfil = $('#subMenuAistenciaCajeros').attr('data-perfil');

		$('ul#subMenuAistenciaCajeros > li').each(function() {
			$(this).removeClass('active');
		});
		$('#idCapacit').addClass('active');
			pagina = 'sucursales/cajeroCapacitacion.asp';
			div = 'cargaCajeroCuerpoTabla';
			var datos='idSucursal='+idSucursal+'&idUsuario='+idUsuario+'&perfil='+perfil;
			enviaDatos(pagina,div,datos);
		$('#cargaCajeroCuerpoTabla').html('');	
	});

</script>