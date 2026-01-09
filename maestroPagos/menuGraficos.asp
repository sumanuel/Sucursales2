<div class="row-fluid">
	<div class="span12">
		<span class="btn graficoTotales" data-numeroGrafico="1" id="menuGrafico1" >
			Totales
		</span>
		<span id="menuGrafico2" data-numeroGrafico="2" class="btn graficoTotales">
				Ips
		</span>
		<span id="menuGrafico3" data-numeroGrafico="3" class=" btn graficoTotales">
				Afp
		</span>	
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('.graficoTotales').each(function(){
		$(this).removeClass('btn-success');
	});
	var idGrafico = $('#menuGrafico1').attr('data-numeroGrafico');
	$('#menuGrafico1').addClass('btn-success');
	var pagina = 'maestroPagos/creaGraficoTotales.asp';
	var div = 'graficoTotales';
	var datos='idGrafico='+idGrafico;
	enviaDatos(pagina,div,datos);
});
$('.graficoTotales').click(function(){
	var idGrafico = $(this).attr('data-numeroGrafico');
	$('.graficoTotales').removeClass('btn-success');
	$('#menuGrafico'+idGrafico).addClass('btn-success');
	var pagina = 'maestroPagos/creaGraficoTotales.asp';
	var div = 'graficoTotales';
	var datos='idGrafico='+idGrafico;
	enviaDatos(pagina,div,datos);
});
</script>