<!--#include file="../funciones.asp"-->
<%fechaActual = date()%>
<div class="row-fluid">
	<div class="span12">
		<table id="tablaPafoAfp1" class="table table-bordered table-hover table-condensed">
			<tr>
				<th rowspan="2">Pagos</th>
				<th colspan="2">Misma Suc</th>
				<th colspan="2">Otra Suc</th>
			</tr>
			<tr>
				<th>Qty</th>
				<th>Tot$</th>
				<th>Qty</th>
				<th>Tot$</th>
			</tr>
			<tr>
				<td>Hoy</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-107">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-108">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-109">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-110">
						0
					</span>
				</td>
			</tr>
			<tr>
				<td>Rezagos</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-117">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-118">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-119">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-120">
						0
					</span>
				</td>
			</tr>
			<tr>
				<td class="negritas">Total</td>
				<td class="textoDerecha">
					<span class="numero negritas" id="pga-207">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero negritas" id="pga-208">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero negritas" id="pga-209">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero negritas" id="pga-210">
						0
					</span>
				</td>
			</tr>
		</table>
	</div>
</div>
<div class="row-fluid tablaDatos1">
	<div class="span12">
		<table id="tablaPafoAfp2" class="table table-bordered table-hover table-condensed">
			<tr>
				<th rowspan="2">Rezagos</th>
				<th colspan="2">Misma Suc</th>
				<th colspan="2">De otra Suc</th>
			</tr>
			<tr>
				<th>Qty</th>
				<th>Tot$</th>
				<th>Qty</th>
				<th>Tot$</th>
			</tr>
			<tr>
				<td>
					<%mes = DateAdd("m",0,fechaActual)
					nombreMes = primeraMayuscula(monthName(month(mes)))
					response.write(nombreMes)%>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-127">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-128">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-129">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-130">
						0
					</span>
				</td>
			</tr>
			<tr>
				<td>
					<%mes = DateAdd("m",-1,fechaActual)
					nombreMes = primeraMayuscula(monthName(month(mes)))
					response.write(nombreMes)%>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-137">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-138">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-139">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-140">
						0
					</span>
				</td>
			</tr>
			<tr>
				<td>
					<%mes = DateAdd("m",-2,fechaActual)
					nombreMes = primeraMayuscula(monthName(month(mes)))
					response.write(nombreMes)%>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-147">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-148">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-149">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-150">
						0
					</span>
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('.tablaDatos1').slideUp('fast');
});
$('.abreTablaPago1').click(function(){
	$('.tablaDatos1').slideToggle('fast');
});
</script>