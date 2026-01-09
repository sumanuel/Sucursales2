<!--#include file="../funciones.asp"-->
<%fechaActual = date()%>
<div class="row-fluid">
	<div class="span5">
		<div class="row-fluid">
			<div class="span5 offset3">
				<span class="label muestraTablaDisponible totalesTablaDisponible mano">Totales</span>
				<span class="label muestraTablaDisponible ipsTablaDisponible mano">Hoy IPS</span>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12" id="divTablaDisponibles"></div>
		</div>
	</div>
	<div class="span7"  id="divTablaRezagos">
	</div>
</div>
<script type="text/javascript">
$(function(){
	var pagina, div, datos;
	pagina = 'maestroPagos/muestraTablaDisponibles.asp';
	div = 'divTablaDisponibles';
	datos='totales=0';
	enviaDatos(pagina,div,datos);
	eliminaClase();
	$('.totalesTablaDisponible').removeClass('label-important').addClass('label-success');
	pagina = 'maestroPagos/grafico1.asp';
	div = 'divGrafico1';
	datos='';
	enviaDatos(pagina,div,datos);
	var pagina, div, datos;
	pagina = 'maestroPagos/tablaRezagos.asp';
	div = 'divTablaRezagos';
	datos='';
	enviaDatos(pagina,div,datos);
});
function eliminaClase()
{
	$('.muestraTablaDisponible').each(function(){
		$(this).removeClass('label-success').addClass('label-important');
	});
}
$('.ipsTablaDisponible').click(function(){
	eliminaClase();
	$(this).removeClass('label-important').addClass('label-success');
	var pagina, div, datos;
	pagina = 'maestroPagos/muestraTablaDisponibles.asp';
	div = 'divTablaDisponibles';
	datos='totales=1';
	enviaDatos(pagina,div,datos);
	pagina = 'maestroPagos/grafico1.asp';
	div = 'divGrafico1';
	datos='';
	enviaDatos(pagina,div,datos);
});
$('.totalesTablaDisponible').click(function(){
	eliminaClase();
	$(this).removeClass('label-important').addClass('label-success');
	var pagina, div, datos;
	pagina = 'maestroPagos/muestraTablaDisponibles.asp';
	div = 'divTablaDisponibles';
	datos='totales=0';
	enviaDatos(pagina,div,datos);
	pagina = 'maestroPagos/grafico1.asp';
	div = 'divGrafico1';
	datos='';
	enviaDatos(pagina,div,datos);
});

</script>