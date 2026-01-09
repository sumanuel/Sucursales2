<!--#include file="../funciones.asp"-->
<%fechaActual = date()%>
<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span12 text-center">
				<span class="label label-info">
					Red Fija
				</span>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12">
				<table class="table table-bordered table-condensed">
					<thead>
						<tr>
							<th rowspan="2">
								Pagos
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
							<th>
								Qty
							</th>
							<th>
								Total
							</th>
							<th>
								Qty
							</th>
							<th>
								Total
							</th>
							<th>
								Qty
							</th>
							<th>
								Total
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>
								Hoy
							</td>
							<td class="textoDerecha">
								<span id="pg-101" class="numero programadosq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-102" class="numero programadosm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-149" class="numero bloqueadosq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-150" class="numero bloqueadosm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-107" class="numero pagadosq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-108" class="numero pagadosm">0</span>
							</td>
						</tr>
						<tr>
							<td>
								Mañana
							</td>
							<td class="textoDerecha">
								<span id="pg-103" class="numero programadosq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-104" class="numero programadosm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-151" class="numero bloqueadosq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-152" class="numero bloqueadosm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-109" class="numero pagadosq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-110" class="numero pagadosm">0</span>
							</td>
						</tr>
						<tr>
							<td>
								Rezagos
							</td>
							<td class="textoDerecha">
								<span id="pg-105" class="numero programadosq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-106" class="numero programadosm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-153" class="numero bloqueadosq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-154" class="numero bloqueadosm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-111" class="numero pagadosq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-112" class="numero pagadosm">0</span>
							</td>
						</tr>
						<tr>
							<td>
								Totales
							</td>
							<td class="textoDerecha">
								<strong><span id="pg-201" class="numero">0</span></strong>
							</td>
							<td class="textoDerecha">
								$<strong><span id="pg-202" class="numero">0</span></strong>
							</td>
							<td class="textoDerecha">
								<strong><span id="pg-203" class="numero">0</span></strong>
							</td>
							<td class="textoDerecha">
								$<strong><span id="pg-204" class="numero">0</span></strong>
							</td>
							<td class="textoDerecha">
								<strong><span id="pg-205" class="numero">0</span></strong>
							</td>
							<td class="textoDerecha">
								$<strong><span id="pg-206" class="numero">0</span></strong>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="row-fluid masDatos1">
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
								<span id="pg-113" class="numero progMesq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-114" class="numero progMesm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-155" class="numero bloqueadosMq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-156" class="numero bloqueadosMm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-119" class="numero pagadosMq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-120" class="numero pagadosMm">0</span>
							</td>
						</tr>
						<%mes = DateAdd("m",-1,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<tr>
							<td>
								<%=nombreMes%>
							</td>
							<td class="textoDerecha">
								<span id="pg-115" class="numero progMq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-116" class="numero progMm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-157" class="numero bloqueadosMq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-158" class="numero bloqueadosMm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-121" class="numero pagadosMq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-122" class="numero pagadosMm">0</span>
							</td>
						</tr>
						<%mes = DateAdd("m",-2,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<tr>
							<td>
								<%=nombreMes%>
							</td>
							<td class="textoDerecha">
								<span id="pg-117" class="numero progMesq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-118" class="numero progMesm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-159" class="numero bloqueadosMq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-160" class="numero bloqueadosMm">0</span>
							</td>
							<td class="textoDerecha">
								<span id="pg-123" class="numero pagadosMq">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="pg-124" class="numero pagadosMm">0</span>
							</td>
						</tr>
						<!--<tr>
							<td>
								Total
							</td>
							<td class="textoDerecha">
								<strong><span id="tablaM1" class="numero">0</span></strong>
							</td>
							<td class="textoDerecha">
								<strong>$<span id="tablaM2" class="numero ">0</span></strong>
							</td>
							<td class="textoDerecha">
								<strong><span id="tablaM3" class="numero ">0</span></strong>
							</td>
							<td class="textoDerecha">
								<strong>$<span id="tablaM4" class="numero ">0</span></strong>
							</td>
							<td class="textoDerecha">
								<strong><span id="tablaM5" class="numero ">0</span></strong>
							</td>
							<td class="textoDerecha">
								<strong>$<span id="tablaM6" class="numero ">0</span></strong>
							</td>
						</tr>-->
					</tbody>
				</table>
			</div>
		</div>		
	</div>
</div>
