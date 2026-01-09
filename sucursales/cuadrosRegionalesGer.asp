<!--#include file="../funciones.asp"-->
<%idRegional = trim(request("idRegional"))%>
<div class="row-fluid muestraBotonesRegional" data-idRegional="<%=idRegional%>">
	<div class="span12">
		<div class="row-fluid" id="divBotoneraRegional<%=idRegional%>">
				<div class="span1 ayuda mano" data-placement="top" data-original-title="Gestiones">
					<span class="icon-stack icon-muted iconoBoton icon-2x 1" data-idRegional="<%=idRegional%>" data-menuCuadro="1"> 
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-wrench"></i>
					</span>
				</div>
				<div class="span1 ayuda mano" data-placement="top" data-original-title="Cajeros">
					<span class="icon-stack icon-muted iconoBoton icon-2x 2" data-idRegional="<%=idRegional%>" data-menuCuadro="2"> 
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-user icon-2x mano"></i>
					</span>
				</div>
				<div class="span1 ayuda mano" data-placement="top" data-original-title="Guardias">
					<span class="icon-stack icon-muted iconoBoton icon-2x 3" data-idRegional="<%=idRegional%>" data-menuCuadro="3"> 
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-shield icon-2x mano icon-2x mano"></i>
					</span>
				</div>
				<div class="span1 ayuda mano" data-placement="top" data-original-title="Sucursales">
					<span class="icon-stack icon-muted iconoBoton icon-2x 3" data-idRegional="<%=idRegional%>" data-menuCuadro="4"> 
						<i class="icon-check-empty icon-stack-base"></i>
						<i class="icon-briefcase icon-2x mano icon-2x mano"></i>
					</span>
				</div>
			</div>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="areaTrabajoCuadros"></div>
</div>
<script type="text/javascript">
$(function(){
	$('.iconoBoton').first().removeClass('icon-muted').addClass('iconoActivo');
	var idRegional = $('.iconoBoton').first().attr('data-idRegional');
	var pagina, div, datos;
	pagina = 'gestiones/gestionesRegional.asp';
	div = 'areaTrabajoCuadros';
	datos='idRegional='+idRegional;
	enviaDatos(pagina,div,datos);
});
$('.iconoBoton').mouseenter(function() {
	idRegional = $(this).attr('data-idRegional');
		$(this).removeClass('icon-muted')
}).mouseleave(function() {
	idRegional = $(this).attr('data-idRegional');
	if (!$(this).hasClass('iconoActivo'))
	{
		$(this).addClass('icon-muted');
	}
}).click(function() {
	$('.iconoBoton').each(function(){
		$(this).addClass('icon-muted').removeClass('iconoActivo');
	});
	$(this).removeClass('icon-muted').addClass('iconoActivo');
	var idRegional = $(this).attr('data-idRegional');
	var menuCuadro = $(this).attr('data-menuCuadro');
	//alert(idRegional+'-----'+menuCuadro)
	var pagina, div, datos;
	switch(menuCuadro) 
	{
		case "1":
			pagina = 'gestiones/gestionesRegional.asp';
			break
		case "2":
			pagina = 'gestiones/cajerosRegional.asp';
			break;
		case "3" :
			pagina = 'gestiones/guardiasRegional.asp'
			break;
		case "4" :
			pagina = 'gestiones/sucursalesRegional.asp'
			break;
	}
	div = 'areaTrabajoCuadros';
	datos='idRegional='+idRegional;
	enviaDatos(pagina,div,datos);
	
});

</script>