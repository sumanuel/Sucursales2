<%
idPersonal = trim(request("idPersonal"))
%>
<div class="row-fluid">
	<div class="span12" id="datosPersonal"></div>    
</div>
<script type="text/javascript">
$(document).ready(function(){	
	var pagina = 'personal/listaPersonal_int.asp';
	var div = 'datosPersonal';
	var datos='tipoPersonal='+<%=idPersonal%>;	
	enviaDatos(pagina,div,datos);	
});
</script>
