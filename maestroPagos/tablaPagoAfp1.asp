<!--#include file="../funciones.asp"-->
<%fechaActual = date()%>
<div class="row-fluid">
	<div class="span12">
		<table id="tablaPagoAfp1" class="table table-bordered table-hover table-condensed">
			<tr>
				<th rowspan="2">Pagos</th>
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
			<tr>
				<td>Hoy</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-101">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-102">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-103">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-104">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-105">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-106">
						0
					</span>
				</td>
			</tr>
			<tr>
				<td>Rezagos</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-111">0</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-112">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-113">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-114">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-115">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-116">
						0
					</span>
				</td>
			</tr>
			<tr>
				<td class="negritas">Total</td>
				<td class="textoDerecha">
					<span class="numero negritas" id="pga-201">0</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero negritas" id="pga-202">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero negritas" id="pga-203">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero negritas" id="pga-204">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero negritas" id="pga-205">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero negritas" id="pga-206">
						0
					</span>
				</td>
			</tr>
		</table>
	</div>
</div>
<div class="row-fluid tablaDatos1">
	<div class="span12">
		<table id="tablaPagoAfp2" class="table table-bordered table-hover table-condensed">
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
			<tr>
				<td>
					<%mes = DateAdd("m",0,fechaActual)
					nombreMes = primeraMayuscula(monthName(month(mes)))
					response.write(nombreMes)%>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-121">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-122">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-123">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-124">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-125">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-126">
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
					<span class="numero" id="pga-131">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-132">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-133">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-134">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-135">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-136">
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
					<span class="numero" id="pga-141">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-142">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-143">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-144">
						0
					</span>
				</td>
				<td class="textoDerecha">
					<span class="numero" id="pga-145">
						0
					</span>
				</td>
				<td class="textoDerecha">
					$<span class="numero" id="pga-146">
						0
					</span>
				</td>
			</tr>
		</table>
	</div>
</div>
