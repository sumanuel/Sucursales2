<div id="fechaVisita" class="input-append date">
	<input type="text" name="campoFechaVisita" id="campoFechaVisita" placeholder="Seleccione fecha" title="Seleccione fecha"/>
	<span class="add-on">
		<i data-time-icon="icon-time" data-date-icon="icon-calendar" class="icon-calendar"></i>
	</span>
</div>
<script type="text/javascript">
$(function(){
	$('#fechaVisita').datetimepicker({
		format: 'dd/MM/yyyy',
		language: 'es-Cl',
		pickTime: false
	});
});
</script>