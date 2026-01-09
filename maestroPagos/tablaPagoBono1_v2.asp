<!--#include file="../funciones.asp"-->
<%fechaActual = date()
var_anio=year(fechaActual)%>
<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span12"></div>
		</div>
		<div class="row-fluid">
			<div class="span12">
				<table class="table table-bordered table-condensed">
					<thead>
						<tr>
							<th colspan="7" class="textoCentrado">
								<span class="label label-info">
									Bono Marzo (<%=var_anio%>) - Red Fija
								</span>
							</th>
						</tr>
						<tr>
							<th rowspan="2">
								Bono Marzo
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
								<span id="bmf-101-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="bmf-102-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								<span id="bmf-173-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="bmf-174-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								<span id="bmf-107-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="bmf-108-2" class="numero">0</span>
							</td>
						</tr>
						<tr>
							<td>
								Mañana
							</td>
							<td class="textoDerecha">
								<span id="bmf-103-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="bmf-104-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								<span id="bmf-175-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="bmf-176-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								<span id="bmf-109-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="bmf-110-2" class="numero">0</span>
							</td>
						</tr>
						<tr>
							<td>
								Rezagos
							</td>
							<td class="textoDerecha">
								<span id="bmf-105-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="bmf-106-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								<span id="bmf-177-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="bmf-178-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								<span id="bmf-111-2" class="numero">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="bmf-112-2" class="numero">0</span>
							</td>
						</tr>
						<tr>
							<td>
								<span class="negritas">Total</span>
							</td>
							<td class="textoDerecha">
								<span id="bmf-201-2" class="numero negritas">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="bmf-202-2" class="numero negritas">0</span>
							</td>
							<td class="textoDerecha">
								<span id="bmf-203-2" class="numero negritas">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="bmf-204-2" class="numero negritas">0</span>
							</td>
							<td class="textoDerecha">
								<span id="bmf-205-2" class="numero negritas">0</span>
							</td>
							<td class="textoDerecha">
								$<span id="bmf-206-2" class="numero negritas">0</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="row-fluid masDatosBono1_v2 oculto">
			<div class="span12">
				<div class="row-fluid">
					<div class="span12">
						<table class="table table-bordered table-condensed">
							<tr>
								<th rowspan="2">Rezagos</th>
								<th colspan="2">Programados</th>
								<th colspan="2">Bloqueados</th>
								<th colspan="2">Pagados</th>
							</tr>
							<tr>
								<th>Qty</th>
								<th>Tot$</th>
								<th>Qty</th>
								<th>Tot$</th>
								<th>Qty</th>
								<th>Tot$</th>
							</tr>
							<%mes = DateAdd("m",-0,fechaActual)
							nombreMes = primeraMayuscula(monthName(month(mes)))%>
							<tr>
								<td>
									<%=nombreMes%>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-113-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-114-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-179-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-180-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-119-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-120-2">
										0
									</span>
								</td>
							</tr>
							<%mes = DateAdd("m",-1,fechaActual)
							nombreMes = primeraMayuscula(monthName(month(mes)))%>
							<tr>
								<td>
									<%=nombreMes%>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-115-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-116-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-181-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-182-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-121-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-122-2">
										0
									</span>
								</td>
							</tr>
							<%mes = DateAdd("m",-2,fechaActual)
							nombreMes = primeraMayuscula(monthName(month(mes)))%>
							<tr>
								<td>
									<%=nombreMes%>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-117-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-118-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-183-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-184-2">
										0	
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-123-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-124-2">
										0
									</span>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>