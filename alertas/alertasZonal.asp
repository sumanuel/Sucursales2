<div class="alert alert-danger alert-error">
	<ul class="unstyled" id="alertaRojo">

	</ul>
</div>
<div class="alert alert-block">
	<ul class="unstyled" id="alertaAmarilla">

	</ul>
</div>
<div class="alert alert-success alert-block">
	<ul class="unstyled" id="alertaVerde">

	</ul>
</div>
<script type="text/javascript">
var direccion = 'alertas/loadAlertas.asp';
/*var valores = $.getJSON(direccion,function(data){
	renderData(data['datos']);
});*/
function renderData(objectTable){
	var html = '';
	var div = '';
	$.each(objectTable, function(index, value) {
		var tipo = value.id_calitipo;
		var cantidad = value.num;
		
    	if (tipo == "1")
		{
        	div = 'alertaRojo'
		}
		if (tipo == "2")
		{
        	div = 'alertaAmarilla'
		}
		if (tipo == "3")
		{
        	div = 'alertaVerde'
		}
		$(div).append('<li>'+alerta+'</li>');
	});
};
</script>