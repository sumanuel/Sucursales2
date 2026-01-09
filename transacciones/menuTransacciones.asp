<div clss="row-fluid">
	<div class="span12">
		<ul class="nav nav-tabs" id="menuTransacciones">
			<li  class="active" id="transaccionesDiarias">
				<a href="#">
					<i class="icon-fixed-width icon-calendar-empty"></i>
					Diarias
				</a>
			</li>
			<li  class="" id="transaccionesMensuales">
				<a href="#">
					<i class="icon-fixed-width icon-calendar"></i>
					Acum.
				</a>
			</li>
		</ul>
	</div>
	<div class="span12">
		<ul class="nav nav-pills nav-stacked" id="menuSelecciona">
			<li class="active seleccionaTransaccion" data-tipoConsulta="1" data-consulta="1" id="1">
				<a href="#">
					Pagos 2%
				</a>
			</li>
			<li data-tipoConsulta="1" data-consulta="2" class="seleccionaTransaccion" id="2">
				<a href="#">
					Pagos PPAA
				</a>
			</li>
			<li data-tipoConsulta="1" data-consulta="3" class="seleccionaTransaccion" id="3">
				<a href="#">
					Pagos Leasing
				</a>
			</li>
			<li data-tipoConsulta="1" data-consulta="4" class="seleccionaTransaccion" id="4">
				<a href="#">
					Recaudación Nóminas
				</a>
			</li>
			<li data-tipoConsulta="1" data-consulta="5" class="seleccionaTransaccion" id="5">
				<a href="#">
					Recaudación Créditos (Prepago Voluntario Cliente)
				</a>
			</li>
			<li data-tipoConsulta="1" data-consulta="6" class="seleccionaTransaccion" id="6">
				<a href="#">
					Traspaso entre Cajas
				</a>
			</li>
			<li data-tipoConsulta="1" data-consulta="7" class="seleccionaTransaccion" id="7">
				<a href="#">
					Ingreso a Caja
				</a>
			</li>
			<li data-tipoConsulta="1" data-consulta="8" class="seleccionaTransaccion" id="8">
				<a href="#">
					Pago de Crédito Social
				</a>
			</li>
			<li data-tipoConsulta="1" data-consulta="9" class="seleccionaTransaccion" id="9">
				<a href="#">
					Recaudación por Distribuir
				</a>
			</li>
			<li data-tipoConsulta="1" data-consulta="10" class="seleccionaTransaccion" id="10">
				<a href="#">
					Pago Pensiones AFP
				</a>
			</li>
			<li data-tipoConsulta="1" data-consulta="11" class="seleccionaTransaccion" id="11">
				<a href="#">
					Pago Pensiones IPS
				</a>
			</li>
			<li data-tipoConsulta="1" data-consulta="12" class="seleccionaTransaccion" id="12">
				<a href="#">
					Pago Licencias
				</a>
			</li>
		</ul>
	</div>
</div>
<script type="text/javascript">
$(function(){});
$('ul#menuTransacciones > #transaccionesMensuales').click(function(){
	$('#transaccionesDiarias').removeClass('active');
	$(this).addClass('active');
	$('ul#menuSelecciona li').each(function(){
		$(this).attr('data-tipoConsulta','2');
	});
});
$('ul#menuTransacciones > #transaccionesDiarias').click(function(){
	$('#transaccionesMensuales').removeClass('active');
	$(this).addClass('active');
	$('ul#menuSelecciona li').each(function(){
		$(this).attr('data-tipoConsulta','1');
	});
});
$('.seleccionaTransaccion').click(function(){
	seleccionado = $(this).attr('data-consulta');
	$('ul#menuSelecciona li').each(function(){
		$(this).removeClass('active');
	});
	$('#'+seleccionado).addClass('active');
	try{
		consulta = $(this).attr('data-consulta');
		tipoConsulta = $(this).attr('data-tipoConsulta');
		pagina = 'transacciones/consultasTransacciones.asp';
		div = 'cargaTransacciones';
		datos='consulta='+consulta+'&tipoConsulta='+tipoConsulta;
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
</script>