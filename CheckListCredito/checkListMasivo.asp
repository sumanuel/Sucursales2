<!--#include file="../funciones2.asp"-->
<%
idSucursalMain = trim(request("idSucursalMain"))
idUsuarioMain = trim(request("idUsuarioMain"))
'response.write(idSucursalMain)
'response.end

%>
<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid" id="paginador" data-actual="" data-siguiente="" data-anterior="" data-posicionActual="">
			<div class="span3" id="anterior">
				<span class="label label-info mano" id="textoAnterior">
					<i class="icon-chevron-left"></i> <i class="icon-chevron-left"></i> Anterior
				</span>
			</div>
			<div class="span3 textoDerecha" id="siguiente">
				<span class="label label-info mano" id="textoSiguiente">
					<i class="icon-chevron-right"></i> <i class="icon-chevron-right"></i> Siguiente
				</span>
			</div>
			<div class="span3 offset3">
				<span class="label mano" id="volverTabla">
					Volver
				</span>
			</div>
		</div>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="poneCheck"></div>
</div>
<script type="text/javascript">
$(function(){
	posicion(0);
});
function posicion(posicionActual)
{
	var posicionSiguiente = posicionActual+ 1;
	var posicionAnterior = posicionActual - 1;
	var actual = arreglo[posicionActual];
	var siguiente = arreglo[posicionSiguiente];
	var anterior = arreglo[posicionAnterior];
	if (posicionAnterior === -1 )
	{
		$('#textoAnterior').slideUp('fast');
		$('#anterior').addClass('noSelecciona');
	}
	else
	{
		$('#textoAnterior').slideDown('fast');
		$('#anterior').removeClass('noSelecciona');
	}
	if (posicionSiguiente >= arreglo.length )
	{
		$('#textoSiguiente').slideUp('fast');
		$('#siguiente').addClass('noSelecciona');
	}
	else
	{
		$('#textoSiguiente').slideDown('fast');
		$('#siguiente').removeClass('noSelecciona');
	}
	$('#paginador').attr({
		'data-actual': actual,
		'data-siguiente': siguiente,
		'data-anterior' : anterior,
		'data-posicionActual': posicionActual
	});
	$('#muestraSeleccion > span.label').each(function() {
		$(this).removeClass('label-inverse').addClass('label-success');
	});
	$('#idLabel'+actual).removeClass('label-success').addClass('label-inverse');
	var idUsuario = $.trim($('#idUsuario').val());
	var pagina, div, datos;
	pagina = 'CheckListCredito/checkList2.asp';
	div = 'poneCheck';
	datos='idCarpeta='+actual+'&idUsuario='+idUsuario;
	enviaDatos(pagina,div,datos);
}
$('#siguiente').click(function(){
	if (!$(this).hasClass('noSelecciona'))
	{
		var posicionSiguiente = parseInt($('#paginador').attr('data-posicionActual'));
		var posicionSiguienteSuma = posicionSiguiente + 1;
		if (posicionSiguienteSuma > arreglo.length)
		{
			posicionSiguienteSuma = posicionSiguiente;
		}
		posicion(posicionSiguienteSuma);
	}
	
});
$('#anterior').click(function(){
	if (!$(this).hasClass('noSelecciona'))
	{
		var posicionSiguiente = parseInt($('#paginador').attr('data-posicionActual'));
		var posicionSiguienteResta = posicionSiguiente - 1;
		if (posicionSiguienteResta < 0)
		{
			posicionSiguienteResta = 0;
		}
		posicion(posicionSiguienteResta);
	}
});
$('.seleccionaCheck').click(function(){
	var valorElemento = parseInt($(this).attr('data-idElemento'));
	var valorPosicion = jQuery.inArray(valorElemento, arreglo);
	posicion(valorPosicion);
});
$('#volverTabla').click(function(){
	var idSucursalCaja = <%=idSucursalMain%>
	var idUsuarioMainCaja = <%=idUsuarioMain%>
	var pagina = 'CheckListCredito/cajas.asp';
	var div = 'cajaTrabajo';
	var datos='idSucursalCaja='+idSucursalCaja+'&idUsuarioMainCaja='+idUsuarioMainCaja;
	enviaDatos(pagina,div,datos);
});
</script>