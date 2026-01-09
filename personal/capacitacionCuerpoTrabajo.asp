
<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
perfilUsuario = trim(request("perfilUsuario"))%>
<div class="row-fluid">
	<div class="row-fluid">
		<ul class="nav nav-tabs" id="menuCapacitacion" data-idUsuario="<%=idUsuario%>" data-perfilMain="<%=perfilMain%>" data-perfilUsuario="<%=perfilUsuario%>">
			<li hidden  id="liInicioCapacitaciones">
				<a href="#">
					<i class="icon-folder-open"></i> Inicio Capacitaciones
				</a>
			</li>
			<li  id="liIngresoCapacitaciones">
				<a href="#">
					<i class="icon-list-alt"></i> Ingreso Capacitaciones
				</a>
			</li>
			<li  id="liDetalleCapacitaciones">
				<a href="#">
					<i class="icon-list-alt"></i> Detalle Capacitaciones
				</a>
			</li>		
			<li hidden id="liFormulariosCapacitaciones">
				<a href="#">
					<i class="icon-list-alt"></i> Formularios 
				</a>
			</li>		
		</ul>
	</div>
	<div class="row-fluid" id="capacitacionCuerpoTrabajo">
		
	</div>
</div>

<script type="text/javascript">

	$(function(){
		var idUsuario= $('#menuCapacitacion').attr('data-idUsuario');
		var perfilMain= $('#menuCapacitacion').attr('data-perfilMain');
		var perfilUsuario= $('#menuCapacitacion').attr('data-perfilUsuario');

		var div = 'capacitacionCuerpoTrabajo';
	    var datos = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&perfilUsuario='+perfilUsuario+'&idSucursal=0&vista=1'
	    var pagina = 'capacitacion_DetalleCapacitacion.asp';    
	    enviaDatos(pagina,div,datos);

		$('li#liDetalleCapacitaciones').addClass('active');
	});

	$('#liIngresoCapacitaciones').click(function(){

		var idUsuario= $('#menuCapacitacion').attr('data-idUsuario');
		var perfilMain= $('#menuCapacitacion').attr('data-perfilMain');
		var perfilUsuario= $('#menuCapacitacion').attr('data-perfilUsuario');

		var div = 'capacitacionCuerpoTrabajo';
	    var datos = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&perfilUsuario='+perfilUsuario
	    var pagina = 'capacitacion_AsignaCapacitacionCajero.asp';    
	    enviaDatos(pagina,div,datos);

		$('ul#menuCapacitacion > li').each(function(){
			$(this).removeClass('active');
		});
		$('li#liIngresoCapacitaciones').addClass('active');
	});

	$('#liDetalleCapacitaciones').click(function(){

		var idUsuario= $('#menuCapacitacion').attr('data-idUsuario');
		var perfilMain= $('#menuCapacitacion').attr('data-perfilMain');
		var perfilUsuario= $('#menuCapacitacion').attr('data-perfilUsuario');

		var div = 'capacitacionCuerpoTrabajo';
	    var datos = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&perfilUsuario='+perfilUsuario+'&idSucursal=0&vista=1'
	    var pagina = 'capacitacion_DetalleCapacitacion.asp';    
	    enviaDatos(pagina,div,datos);

		$('ul#menuCapacitacion > li').each(function(){
			$(this).removeClass('active');
		});
		$('li#liDetalleCapacitaciones').addClass('active');
	});


</script>
