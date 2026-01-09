<!--#include file="../funciones.asp"-->
<%fechaActual = date()
mes = trim(request("mes"))%>
<div class="row-fluid">
	<div class="span2 offset5">
		<span class="label label-info">
			Red Movil en Red Fija
		</span>	
	</div>
</div>
<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span1 offset11">
				<span class="label label-info mano" id="muestraDetalleT3" data-tipo="1">
					<span id="iconoT3"><i class="icon-chevron-down"></i></span> Detalles
				</span>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12">
				<table id="tablaRedMovilT3" class="table table-bordered table-hover table-condensed" data-mes="<%=mes%>">
					<thead>
						<tr>
							<th rowspan="2">
								Rezagos
							</th>
							<th colspan="2">
								Programados
							</th>

							<th colspan="2">
								Bloqueados
							</th>
							<th colspan="2">
								Pagados
							</th>
						</tr>
						<tr>
							<th>Qty</th>
							<th>Tot$</th>
							<th>Qty</th>
							<th>Tot$</th>
							<th>Qty</th>
							<th>Tot$</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td></td>
							<td class="textoDerecha">
								<span id="rm-101">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-102">0</span>
							</td>
							<td class="textoDerecha">
								<span id="rm-133">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-134">0</span>	
							</td>
							<td class="textoDerecha">
								<span id="rm-103">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-104">0</span>
							</td>
						</tr>
					</tbody>
				</table>	
			</div>
		</div>
		<div class="row-fluid" id="masDatosRMRF">
			<div class="span12">
				<table class="table table-bordered table-condensed">
					<thead>
						<tr>
							<th rowspan="2">Rezagos</th>
							<th colspan="2">Programados</th>
							<th colspan="2">Bloqueados</th>
							<th colspan="2">Pagados</th>
						</tr>
						<tr>
							<th>Qty</th>
							<th>Total $</th>
							<th>Qty</th>
							<th>Total $</th>
							<th>Qty</th>
							<th>Total $</th>
						</tr>
					</thead>
					<tbody>
						<%mes = DateAdd("m",0,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<tr>
							<td>
								<%=nombreMes%>
							</td>
							<td class="textoDerecha">
								<span id="rm-105">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-106">0</span>
							</td>
							<td class="textoDerecha">
								<span id="rm-135">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-136">0</span>
							</td>
							<td class="textoDerecha">
								<span id="rm-111">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-112">0</span>
							</td>
						</tr>
						<%mes = DateAdd("m",-1,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<tr>
							<td>
								<%=nombreMes%>
							</td>
							<td class="textoDerecha">
								<span id="rm-107">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-108">0</span>
							</td>
							<td class="textoDerecha">
								<span id="rm-137">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-138">0</span>
							</td>
							<td class="textoDerecha">
								<span id="rm-113">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-114">0</span>
							</td>
						</tr>
						<%mes = DateAdd("m",-2,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<tr>
							<td>
								<%=nombreMes%>
							</td>
							<td class="textoDerecha">
								<span id="rm-109">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-110">0</span>
							</td>
							<td class="textoDerecha">
								<span id="rm-139">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-140">0</span>
							</td>
							<td class="textoDerecha">
								<span id="rm-115">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-116">0</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('#masDatosRMRF').hide();
});
$('#muestraDetalleT3').click(function(){
	var tipo = $(this).attr('data-tipo');
	if (tipo ==='1')
	{
		$('#iconoT3').html('<i class="icon-chevron-up"></i>');
		$(this).attr('data-tipo', '2');
		$('#masDatosRMRF').slideDown('slow');
	}
	else
	{
		$('#iconoT3').html('<i class="icon-chevron-down"></i>');
		$(this).attr('data-tipo', '1');
		$('#masDatosRMRF').slideUp('slow');
	}
});
var url = 'maestroPagos/datosPagos.asp?tipo=1';
$.when($.ajax(url)).then(function(data) {
	$.each( data.datos, function( key, valoresDatos ) {
		var area = valoresDatos.area;
		var tipo = valoresDatos.tipo;
		var valor = valoresDatos.valor;
		var areaTipo = area+'-'+tipo;
		$('#'+areaTipo).text(valor);
	});
});
</script>