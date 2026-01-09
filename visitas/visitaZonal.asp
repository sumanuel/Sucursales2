<!--#include file="../funciones.asp"-->
<%perfil = trim(request("perfilMain"))
idUsuario = trim(request("idUsuarioMain"))
if perfil= "2" or perfil ="3" then%>
<div class="row-fluid" id="botonNevaVisita">
	<div class="btn btn-success abreNuevaVisita span3" id="botonAgregaVisitaZonal"><i class="icon-pushpin"></i>  Agregar nueva visita</div>
	<div class="btn btn-info cierraNuevaVisita oculto" id="botoncierraNuevaVisitaZonal"><i class="icon-collapse-top"></i> Cerrar</div>
	<%if perfil = "3" then%>
		<div class="alert alert-error mano text-center offset9 botonVuelveZonal">Volver a vista zonales <i class="icon-reply"></i></div>
	<%end if%>
</div>
<div class="row-fluid oculto" id="nuevaVisitaZonal">
	<div class="span12 well" id="agregaAgendaZonal"></div>
</div>
<div class="row-fluid" id="areaZonal">
	<div class="span12" id="agendaZonal"></div>
</div>
<%end if%>
<script type="text/javascript">

$(function(){
	try{
		var pagina,div,datos
		pagina = 'visitas/agregaVisita.asp';
		div = 'agregaAgendaZonal';
		datos = 'noZonal=1';
		enviaDatos(pagina,div,datos);
		pagina = 'calendario/calendario.asp';
		div = 'agendaZonal';
		datos = '';
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	$('#botonAgregaVisitaZonal').click(function(){
		$('#nuevaVisitaZonal').slideDown('slow').removeClass('oculto');
		$('#botoncierraNuevaVisitaZonal').removeClass('oculto');
		$(this).addClass('oculto').hide();
		return false;
	});
	$('#botoncierraNuevaVisitaZonal').click(function(){
		$('#nuevaVisitaZonal').slideUp('slow').addClass('oculto');
		$(this).addClass('oculto');
		$('#botonAgregaVisitaZonal').removeClass('oculto').show();
		return false;
	});
	$('.botonVuelveZonal').click(function(){
		$('#areaTrabajoGerencia').slideUp('fast');
		$('#menuGer, #datosZona, #areaDivTabsGerencia').slideDown('slow');
		return false;
	});
})

</script>