<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))%>
<div class="row-fluid">
	<div class="row-fluid">
		<ul class="nav nav-tabs" id="menuGestionCasos" data-idUsuario="<%=idUsuario%>" data-perfilMain="<%=perfilMain%>">
			<li  id="liGestionCasos1">
				<a href="#">
					<i class="icon-home"></i> Gestion de Casos (Grafico)
				</a>
			</li>
			<li  id="liGestionCasos2">
				<a href="#">
					<i class="icon-folder-open"></i> Gestion de Casos (Detalle)
				</a>
			</li>		
		</ul>
	</div>

	<div class="row-fluid" id="reclamosCuerpoTrabajo">
		
	</div>
</div>
<script type="text/javascript">
	$(function(){
		//var idUsuario= $('#menuPrincipal').attr('data-idUsuario');
		//var perfilMain= $('#menuPrincipal').attr('data-perfilMain');

		var div = 'reclamosCuerpoTrabajo';
	    var datos = 'tipoVista=1&filtroPeriodo=0';
	    var pagina = 'reclamosDivPeriodo.asp';    
	    enviaDatos(pagina,div,datos);

		$('li#liGestionCasos1').addClass('active');
	});

	$('#liGestionCasos1').click(function(){

		var periodoSeleccionado= $('select#cboPeriodoSelectReclamo option:selected').val();

		var div = 'reclamosCuerpoTrabajo';
	    var datos = 'tipoVista=1&filtroPeriodo='+periodoSeleccionado;
	    var pagina = 'reclamosDivPeriodo.asp';    
	    enviaDatos(pagina,div,datos);

		$('ul#menuGestionCasos > li').each(function(){
			$(this).removeClass('active');
		});
		$('li#liGestionCasos1').addClass('active');
	});

	$('#liGestionCasos2').click(function(){

		var periodoSeleccionado= $('select#cboPeriodoSelectReclamo option:selected').val();

		var div = 'reclamosCuerpoTrabajo';
	    var datos = 'tipoVista=2&filtroPeriodo='+periodoSeleccionado;
	    var pagina = 'reclamosDivPeriodo.asp';    
	    enviaDatos(pagina,div,datos);

		
		$('ul#menuGestionCasos > li').each(function(){
			$(this).removeClass('active');
		});
		$('li#liGestionCasos2').addClass('active');
	});
</script>