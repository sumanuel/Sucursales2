<!--#include file="../funciones.asp"-->
<div class="row-fluid">
	<div class="span12" id="cargaTL"></div>
</div>
<script type="text/javascript">
$(function(){
	var pagina, div, datos;
	pagina = 'tweet/tl.asp';
	div = 'cargaTL';
	datos = '';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
	
});
</script>
