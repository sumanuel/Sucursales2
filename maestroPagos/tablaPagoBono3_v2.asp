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
					<tr>
						<th colspan="7" class="textoCentrado">
							<span class="label label-info">
								Bono Marzo (<%=var_anio%>) - Red Movil en Red Fija
							</span>
						</th>
					</tr>
					<tr>
						<th rowspan="3">Rezagos</th>
						<th colspan="2">Programados</th>
						<th colspan="2">Bloqueados</th>
						<th colspan="2">Pagados</th>
					</tr>
					<tr>
						<td>Qty</td>
						<td>Tot$</td>
						<td>Qty</td>
						<td>Tot$</td>
						<td>Qty</td>
						<td>Tot$</td>
					</tr>
					<tr>
						<td class="textoDerecha">
							<span class="numero" id="bmm-101-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-102-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-149-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-150-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-103-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-104-2">
								0
							</span>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="row-fluid masDatosBono2_v2 oculto">
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
					<%mes = DateAdd("m",0,fechaActual)
					nombreMes = primeraMayuscula(monthName(month(mes)))%>
					<tr>
						<td>
							<%=nombreMes%>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-105-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-106-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-151-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-152-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-111-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-112-2">
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
							<span class="numero" id="bmm-107-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-104-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-153-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-154-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-113-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-114-2">
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
							<span class="numero" id="bmm-109-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-110-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-155-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-156-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-115-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-116-2">
								0
							</span>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>