
<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))%>
<div class="row-fluid">
	<div class="row-fluid">		
		<ul class="nav nav-tabs" id="menuevaluacion" data-idUsuario="<%=idUsuario%>" data-perfilMain="<%=perfilMain%>">
			<li  id="liEvaluacionGeneral">
				<a href="#">
					<i class="icon-signal"></i> Evaluaciones generales
				</a>
			</li>
			<li  id="liEvaluacionDetalle">
				<a href="#">
					<i class="icon-signal"></i> Evaluaciones detalle
				</a>
			</li>		
		</ul>
	</div>
	<div class="row-fluid" id="evaluacionCuerpoTrabajo">
		
	</div>
</div>

<script type="text/javascript">

	$(function(){
		var idUsuario= $('#menuevaluacion').attr('data-idUsuario');
		var perfilMain= $('#menuevaluacion').attr('data-perfilMain');

		var div = 'evaluacionCuerpoTrabajo';
	    var datos = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain
	    var pagina = 'evaluacion_EvaGeneral.asp';    
	    enviaDatos(pagina,div,datos);

		$('li#liEvaluacionGeneral').addClass('active');
	});

	$('#liEvaluacionGeneral').click(function(){

		var idUsuario= $('#menuevaluacion').attr('data-idUsuario');
		var perfilMain= $('#menuevaluacion').attr('data-perfilMain');

		var div = 'evaluacionCuerpoTrabajo';
	    var datos = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain
	    var pagina = 'evaluacion_EvaGeneral.asp';    
	    enviaDatos(pagina,div,datos);

		$('ul#menuevaluacion > li').each(function(){
			$(this).removeClass('active');
		});
		$('li#liEvaluacionGeneral').addClass('active');
	});

	$('#liEvaluacionDetalle').click(function(){

		var idUsuario= $('#menuevaluacion').attr('data-idUsuario');
		var perfilMain= $('#menuevaluacion').attr('data-perfilMain');

		var div = 'evaluacionCuerpoTrabajo';
	    var datos = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain
	               +'&periodo=0&sucursal=0'
	    var pagina = 'evaluacion_DetalleEvaluacion.asp';    
	    enviaDatos(pagina,div,datos);

		$('ul#menuevaluacion > li').each(function(){
			$(this).removeClass('active');
		});
		$('li#liEvaluacionDetalle').addClass('active');
	});


</script>
