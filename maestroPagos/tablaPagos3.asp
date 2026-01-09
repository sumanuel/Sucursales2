<!--#include file="../funciones.asp"-->
<%fechaActual = date()%>
<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span12 text-center">
				<span class="label label-info">
					Red movil en Red Fija
				</span>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12">
				<table class="table table-bordered table-condensed">
					<tr>
						<th rowspan="3">Rezagos</th>
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
					<tr>
						<td class="textoDerecha">
							<span id="rm-101" class="numero">0</span>
						</td>
						<td class="textoDerecha">
							$<span id="rm-102" class="numero">0</span>
						</td>
						<td class="textoDerecha">
							<span id="rm-133" class="numero">0</span>
						</td>
						<td class="textoDerecha">
							$<span id="rm-134" class="numero">0</span>	
						</td>
						<td class="textoDerecha">
							<span id="rm-103" class="numero">0</span>
						</td>
						<td class="textoDerecha">
							$<span id="rm-104" class="numero">0</span>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="row-fluid masDatos2 oculto">
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
								<span id="rm-105" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-106" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								<span id="rm-135" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-136" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								<span id="rm-111" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-112" class="numero">0</span>
							</td>
						</tr>
						<%mes = DateAdd("m",-1,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<tr>
							<td>
								<%=nombreMes%>
							</td>
							<td class="textoDerecha">
								<span id="rm-107" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-108" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								<span id="rm-137" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-138" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								<span id="rm-113" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-114" class="numero">0</span>
							</td>
						</tr>
						<%mes = DateAdd("m",-2,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<tr>
							<td>
								<%=nombreMes%>
							</td>
							<td class="textoDerecha">
								<span id="rm-109" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-110" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								<span id="rm-139" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-140" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								<span id="rm-115" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="rm-116" class="numero">0</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>