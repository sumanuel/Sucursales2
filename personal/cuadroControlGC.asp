<!--#include file="../conexion/conexion.asp"-->
<div id="dvCentralGC">
	<br/>	
	<input type="hidden" id="idCaso" value=""/>
	<input type="hidden" id="idBack" value="1"/>	
	<div id="dvCentralListaGC" class="dvCentralListaGC"></div>
	<div id="casoDetalle" class="oculto"></div>
	<div id="dvcasoSelMulti" class="oculto"></div>

	<script type="text/javascript">
		$(document).ready(function(){
			var div = 'dvCentralListaGC';
			var datos = 'tipo=5';
			var pagina = 'cuadroControlGC_sql.asp';
			enviaDatos(pagina,div,datos);			
		});		
	</script>	
</div>