<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))%>

<%if perfilMain = "1" then%>
	<ul class="nav nav-tabs" id="menuPrincipal" data-idUsuario="<%=idUsuario%>" data-perfilMain="<%=perfilMain%>">
		<li  id="inicio">
			<a href="#">
				<i class="icon-home"></i> Inicio
			</a>
		</li>
		<li  id="idAsistencia">
			<a href="#">
				<i class="icon-folder-open"></i> Asistencia
			</a>
		</li>
		<!--<li  id="idDimensionamiento">
			<a href="#">
				<i class="icon-folder-open"></i> Dimensionamiento
			</a>
		</li>-->
		<li id="idReclamos" data-tipoMenu="2">
			<a href="#">
				<i class="icon-sitemap"></i> Reclamos
			</a>
		</li>
		<!--<li id="idCapacitacion" data-tipoMenu="2">
			<a href="#">
				<i class="icon-sitemap"></i> Capacitaciones
			</a>
		</li>-->
	</ul>
<%end if%>
<%if perfilMain="2" then%>
	<ul class="nav nav-tabs" id="menuPrincipal">
		<li  id="inicio">
			<a href="#">
				Objeto 1
			</a>
		</li>
		<li  id="idAsistencia">
			<a href="#">
				Objeto 2
			</a>
		</li>
		<li  id="busqueda3">
			<a href="#">
				Objeto 3
			</a>
		</li>
		<li  id="busqueda4">
			<a href="#">
				Objeto 4
			</a>
		</li>
	</ul>
<%end if%>
<script type="text/javascript">
$(function(){
	var idUsuario= $('#idUsuario').val();
	var perfilMain= $('#perfilMain').val();
	var pagina, div, datos;
	$('ul#menuPrincipal > li').each(function(){
		$(this).removeClass('active');
	});
	if (perfilMain !== "0" || perfilMain !== "" )
	{
		pagina = 'admin_personal_ing.asp';
		$('li#inicio').addClass('active');

	}
	else{
		pagina = 'ctrolDefault.asp';
	}
	div = 'cajaTrabajo';
	datos='perfilMain='+perfilMain;
	enviaDatos(pagina,div,datos);
});
$('#inicio').click(function(){

	$('#MarcoGeneral').show();
	$('#CuerpoControlCajeros').hide();

	var pagina, div, datos;
	pagina = 'admin_personal_ing.asp';
	div = 'cajaTrabajo';
	datos='';
	enviaDatos(pagina,div,datos);
	$('ul#menuPrincipal > li').each(function(){
		$(this).removeClass('active');
	});
	$('li#inicio').addClass('active');
});
$('#idAsistencia').click(function(){
	var idUsuario= $('#menuPrincipal').attr('data-idUsuario');
	var perfilMain= $('#menuPrincipal').attr('data-perfilMain');

	$('#MarcoGeneral').hide();
	$('#CuerpoControlCajeros').show();

	pagina = 'ctrolCajeroCargaSubMenu.asp';
	div = 'cajaTrabajo';
	datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain;
	enviaDatos(pagina,div,datos);
	$('ul#menuPrincipal > li').each(function(){
		$(this).removeClass('active');
	});
	$('li#idAsistencia').addClass('active');
});
$('#idDimensionamiento').click(function(){
	var idUsuario= $('#menuPrincipal').attr('data-idUsuario');
	var perfilMain= $('#menuPrincipal').attr('data-perfilMain');
	var pagina, div, datos;
	$('#MarcoGeneral').hide();
	$('#CuerpoControlCajeros').hide();

	pagina = 'ctrolCajeroDimSubMenu.asp';
	div = 'cajaTrabajo';
	datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain;
	enviaDatos(pagina,div,datos);
	
	$('ul#menuPrincipal > li').each(function(){
		$(this).removeClass('active');
	});
	$('li#idDimensionamiento').addClass('active');
});
$('#idReclamos').click(function(){
	var idUsuario= $('#menuPrincipal').attr('data-idUsuario');
	var perfilMain= $('#menuPrincipal').attr('data-perfilMain');

	$('#MarcoGeneral').hide();
	$('#CuerpoControlCajeros').hide();

	
	
	var div = 'cajaTrabajo';
    var datos = '';
    var pagina = 'reclamosCuerpoTrabajo.asp';    
    enviaDatos(pagina,div,datos);
	
	$('ul#menuPrincipal > li').each(function(){
		$(this).removeClass('active');
	});
	$('li#idReclamos').addClass('active');
});
</script>