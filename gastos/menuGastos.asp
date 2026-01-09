<%idZonal = trim(request("idZonal"))%>
<div class="row-fluid">
	<div class="span12">
		<ul class="nav nav-tabs seleccionaTab" data-idZonalSeleccionado="<%=idZonal%>" data-tabActivo="" id="seleccionaTab">
			<li class="active total" data-activo="1">
				<a href="#" data-toggle="tab">
					Total
				</a>
			</li>
			<li class="movilizacion" data-activo="2">
				<a href="#" data-toggle="tab">
					Movilización
					<i class="icon-plane"></i>
				</a>
			</li>
			<li class="alojamiento" data-activo="3">
				<a href="#" data-toggle="tab">
					Alojamiento 
					<i class="icon-h-sign"></i>
				</a>
			</li>
			<li class="alimentacion" data-activo="4">
				<a href="#" data-toggle="tab">
					Alimentación 
					<i class="icon-food"></i>
				</a>
			</li>
			<li class="viatico" data-activo="5">
				<a href="#" data-toggle="tab">
					Viático 
					<i class="icon-suitcase"></i>
				</a>
			</li>
		</ul>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="datosGastos"></div>
</div>
<script type="text/javascript">
$(function(){
	tabActivo = $('.seleccionaTab').attr('data-tabActivo');
	if (tabActivo=="")
	{
		$('.seleccionaTab').attr('data-tabActivo','total');
		var idZonal = $('.seleccionaTab').attr('data-idZonalSeleccionado');
		var pagina = 'gastos/gastosTotal.asp';
		var div = 'datosGastos';
		var datos='idZonal='+idZonal;
		try{
			enviaDatos(pagina,div,datos);
			return false;
		}
		catch(err){}
	}
});
$('.movilizacion').click(function(){

		$('ul#seleccionaTab li').each(function(){
			$(this).removeClass('active');
		});
		$(this).addClass('active');
		var idZonal = $('.seleccionaTab').attr('data-idZonalSeleccionado');
		var pagina = 'gastos/muestraGastos.asp';
		var div = 'datosGastos';
		var datos='idZonal='+idZonal+'&tipo=1';
		try{
				enviaDatos(pagina,div,datos);
			}
		catch(err){}
		return false;
	});
	$('.alojamiento').click(function(){
		$('ul#seleccionaTab li').each(function(){
			$(this).removeClass('active');
		});
		$(this).addClass('active');
		var idZonal = $('.seleccionaTab').attr('data-idZonalSeleccionado');
		var pagina = 'gastos/muestraGastos.asp';
		var div = 'datosGastos';
		var datos='idZonal='+idZonal+'&tipo=2';
		try{
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
		return false;
	});
	$('.alimentacion').click(function(){
		$('ul#seleccionaTab li').each(function(){
			$(this).removeClass('active');
		});
		$(this).addClass('active');
		var idZonal = $('.seleccionaTab').attr('data-idZonalSeleccionado');
		var pagina = 'gastos/muestraGastos.asp';
		var div = 'datosGastos';
		var datos='idZonal='+idZonal+'&tipo=3';
		try{
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
		return false;
	});
	$('.viatico').click(function(){
		$('ul#seleccionaTab li').each(function(){
			$(this).removeClass('active');
		});
		$(this).addClass('active');
		var idZonal = $('.seleccionaTab').attr('data-idZonalSeleccionado');
		var pagina = 'gastos/muestraGastos.asp';
		var div = 'datosGastos';
		var datos='idZonal='+idZonal+'&tipo=4';
		try{
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
		return false;
	});
	$('.total').click(function(){
		$('ul#seleccionaTab li').each(function(){
			$(this).removeClass('active');
		});
		$(this).addClass('active');
		$('.seleccionaTab').attr('data-tabActivo','total');
		var idZonal = $('.seleccionaTab').attr('data-idZonalSeleccionado');
		var pagina = 'gastos/gastosTotal.asp';
		var div = 'datosGastos';
		var datos='idZonal='+idZonal;
		try{
			enviaDatos(pagina,div,datos);
			return false;
		}
		catch(err){}
	});
</script>
