<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
periodo = trim(request("periodo"))
sucursal = trim(request("sucursal"))	
%>


<form class="form-inline" role="form" id="formDetalleEvaluacion" data-idUsuario="<%=idUsuario%>" data-perfilMain="<%=perfilMain%>" data-periodo="<%=periodo%>" data-sucursal="<%=sucursal%>">
	<div style="width: 95%; margin: 0 auto;">
		<div style="font-size: 20px;text-align: center; padding-bottom: 8px; color: #99b3ff"><b>Listado Evaluaciones</b></div>	
		</br>
		<div id="cuerpoTrabajoDetalleEvaluacion1"></div>
	</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){
	    $('[data-toggle="popover"]').popover({
	    	 html:true
	    });   

	    verTablaEvaluaciones();
	});	

	$('#cboPeriodoDetalleCapacitacion').change(function() {	
		verTablaEvaluaciones();
	});

	function verTablaEvaluaciones(){		
		$('#cuerpoTrabajoDetalleEvaluacion1').html("");
		var idUsuario= $('#formDetalleEvaluacion').attr('data-idUsuario');
		var perfilMain= $('#formDetalleEvaluacion').attr('data-perfilMain');
		var periodo= $('#formDetalleEvaluacion').attr('data-periodo');
		var sucursal= $('#formDetalleEvaluacion').attr('data-sucursal');

     	var pagina, div, datos;
	    pagina = 'evaluacion_DetalleEvaluacion1.asp';
		div = 'cuerpoTrabajoDetalleEvaluacion1';
		datos=	'idUsuario='+idUsuario
			   +'&perfilMain='+perfilMain
			   +'&periodo='+periodo
			   +'&sucursal='+sucursal;
		enviaDatos(pagina,div,datos);
	};

</script>