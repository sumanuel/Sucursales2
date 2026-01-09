<%
idPersonal = trim(request("idPersonal"))
%>
<ul class="nav nav-tabs seleccionaTab" data-idPersonalSeleccionado="<%=idPersonal%>" data-tabActivo="">
  <li class="active" data-activo="1"><a href="#" data-toggle="tab">Presentes</a></li>
  <li class="" data-activo="2"><a href="#" data-toggle="tab">Ausentes</a></li>
  <li class="" data-activo="3"><a href="#" data-toggle="tab">Sin Registro</a></li>	
</ul>
<div class="row-fluid">
	<div class="span12" id="datosPersonal"></div>    
</div>
<script type="text/javascript">
$(document).ready(function(){
	var tipoPersonal = 1;
	if ($(".seleccionaTab").attr('data-idPersonalSeleccionado'))
		tipoPersonal = $(".seleccionaTab").attr('data-idPersonalSeleccionado');	
	else{
		tipoPersonal = 1;
		$(".seleccionaTab").attr('data-idPersonalSeleccionado', tipoPersonal);
	}
	
	var pagina = 'personal/listaPersonal.asp';
	var div = 'datosPersonal';
	var datos='tipoPersonal='+tipoPersonal+'&tipoAsistencia='+1;  	  
	enviaDatos(pagina,div,datos);	
	
	$(".seleccionaTab li").click(function(){
		var tipoPersonal = $(".seleccionaTab").attr('data-idPersonalSeleccionado');
		var tipoAsistencia = $(this).attr('data-activo');
		
		//console.log("tipoPersonal:"+tipoPersonal);
		//console.log("tipoAsistencia:"+tipoAsistencia);
		
		var pagina = 'personal/listaPersonal.asp';
	  	var div = 'datosPersonal';
	  	var datos='tipoPersonal='+tipoPersonal+'&tipoAsistencia='+tipoAsistencia;  	  
	  	enviaDatos(pagina,div,datos);	
	});
});
</script>
