<!--#include file="../funciones.asp"-->
<%fechaActual = date()
var_anio=(year(fechaActual))-1%>
<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span12">
				<div class="row-fluid">
					<div class="span2 offset10 abreDatosBono1 mano" data-abierto="1">
						<span class="label label-important"> 
							<span id="iconoBono1">
								<i class="icon-collapse"></i>
							</span>
							Mas datos
						</span>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<table class="table table-bordered table-condensed">
							<tr>
								<th colspan="5" class="textoCentrado">
									<span class="label label-info">
										Bono Marzo (<%=var_anio%>) - Clientes - RF
									</span>
								</th>
								<th colspan="4" class="textoCentrado">
									<span class="label label-info">
										Bono Marzo (<%=var_anio%>) - NO clientes - RF
									</span>
								</th>
							</tr>
							<tr>
								<th rowspan="2">Pagos</th>
								<th colspan="2">Programados</th>
								<th colspan="2">Pagados</th>
								<th colspan="2">Programados</th>
								<th colspan="2">Pagados</th>
							</tr>
							<tr>
								<td>Qty</td>
								<td>Tot$</td>
								<td>Qty</td>
								<td>Tot$</td>
								<td>Qty</td>
								<td>Tot$</td>
								<td>Qty</td>
								<td>Tot$</td>
							</tr>
							<tr>
								<td>Hoy</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-125-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-126-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-127-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-128-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-149-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-150-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-151-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-152-1">
										0
									</span>
								</td>
							</tr>
							<tr>
								<td>Mañana</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-129-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-130-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-131-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-132-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-153-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-154-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-155-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-156-1">
										0
									</span>
								</td>
							</tr>
							<tr>
								<td>Rezagos</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-133-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-134-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-135-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-136-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-157-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-158-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-159-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-160-1">
										0
									</span>
								</td>
							</tr>
							<tr>
								<td>Total</td>
								<td class="textoDerecha">
									<span class="numero negritas" id="bmf-207-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero negritas" id="bmf-208-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero negritas" id="bmf-209-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero negritas" id="bmf-210-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero negritas" id="bmf-211-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero negritas" id="bmf-212-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero negritas" id="bmf-213-1">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero negritas" id="bmf-214-1">
										0
									</span>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="row-fluid masDatosBono1">
			<div class="span12">
				<table class="table table-bordered table-condensed">
					<tr>
						<th rowspan="2">Rezagos</th>
						<th colspan="2">Programados</th>
						<th colspan="2">Pagados</th>
						<th colspan="2">Programados</th>
						<th colspan="2">Pagados</th>
					</tr>
					<tr>
						<th>Qty</th>
						<th>Tot$</th>
						<th>Qty</th>
						<th>Tot$</th>
						<th>Qty</th>
						<th>Tot$</th>
						<th>Qty</th>
						<th>Tot$</th>
					</tr>
					<tr>
						<%mes = DateAdd("m",0,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<td>
							<%=nombreMes%>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-137-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-138-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-139-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-140-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-161-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-162-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-163-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-164-1">
								0
							</span>
						</td>
					</tr>
					<tr>
						<%mes = DateAdd("m",-1,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<td>
							<%=nombreMes%>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-141-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-142-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-143-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-144-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-165-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-166-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-167-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-168-1">
								0
							</span>
						</td>
					</tr>
					<tr>
						<%mes = DateAdd("m",-2,fechaActual)
						nombreMes = primeraMayuscula(monthName(month(mes)))%>
						<td>
							<%=nombreMes%>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-145-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-146-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-147-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-148-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-169-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-170-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-171-1">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-172-1">
								0
							</span>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('.masDatosBono1').hide('fast');

});
$('.abreDatosBono1').click(function(){
	var abierto = $(this).attr('data-abierto');
	if (abierto === '1')
	{
		$('.masDatosBono1').slideDown('slow');
		$('.abreDatosBono1').attr('data-abierto', '0');
		$('#iconoBono1').html('<i class="icon-collapse-top"></i>');
	}
	else
	{
		$('.masDatosBono1').slideUp('fast');
		$('.abreDatosBono1').attr('data-abierto', '1');
		$('#iconoBono1').html('<i class="icon-collapse"></i>');
	}
});
</script>