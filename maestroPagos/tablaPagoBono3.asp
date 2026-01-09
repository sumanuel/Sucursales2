<!--#include file="../funciones.asp"-->
<%fechaActual = date()
var_anio=(year(fechaActual))-1%>
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
							<span class="numero" id="bmm-101-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-102-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-149-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-150-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-103-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-104-1">
								0
							</span>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="row-fluid masDatosBono2 oculto">
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
							<span class="numero" id="bmm-105-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-106-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-151-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-152-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-111-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-112-1">
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
							<span class="numero" id="bmm-107-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-104-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-153-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-154-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-113-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-114-1">
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
							<span class="numero" id="bmm-109-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-110-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-155-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-156-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmm-115-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmm-116-1">
								0
							</span>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>