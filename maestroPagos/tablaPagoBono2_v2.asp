<!--#include file="../funciones.asp"-->
<%fechaActual = date()
var_anio=year(fechaActual)%>
<div class="row-fluid">

<div class="span12">

		<div class="row-fluid">
			<div class="span12">
				<div class="row-fluid">
					<div class="span2 offset10 abreDatosBono1_v2 mano" data-abiertoVV="1">
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
									<span class="numero" id="bmf-125-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-126-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-127-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-128-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-149-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-150-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-151-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-152-2">
										0
									</span>
								</td>
							</tr>
							<tr>
								<td>Mañana</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-129-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-130-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-131-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-132-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-153-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-154-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-155-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-156-2">
										0
									</span>
								</td>
							</tr>
							<tr>
								<td>Rezagos</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-133-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-134-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-135-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-136-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-157-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-158-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero" id="bmf-159-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero" id="bmf-160-2">
										0
									</span>
								</td>
							</tr>
							<tr>
								<td>Total</td>
								<td class="textoDerecha">
									<span class="numero negritas" id="bmf-207-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero negritas" id="bmf-208-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero negritas" id="bmf-209-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero negritas" id="bmf-210-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero negritas" id="bmf-211-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero negritas" id="bmf-212-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									<span class="numero negritas" id="bmf-213-2">
										0
									</span>
								</td>
								<td class="textoDerecha">
									$<span class="numero negritas" id="bmf-214-2">
										0
									</span>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="row-fluid masDatosBono1_v2">
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
							<span class="numero" id="bmf-137-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-138-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-139-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-140-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-161-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-162-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-163-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-164-2">
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
							<span class="numero" id="bmf-141-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-142-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-143-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-144-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-165-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-166-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-167-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-168-2">
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
							<span class="numero" id="bmf-145-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-146-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-147-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-148-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-169-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-170-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							<span class="numero" id="bmf-171-2">
								0
							</span>
						</td>
						<td class="textoDerecha">
							$<span class="numero" id="bmf-172-2">
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
	$('.masDatosBono1_v2').hide('fast');

});
$('.abreDatosBono1_v2').click(function(){
	var abierto = $(this).attr('data-abiertoVV');
	if (abierto === '1')
	{
		$('.masDatosBono1_v2').slideDown('slow');
		$('.abreDatosBono1_v2').attr('data-abiertoVV', '0');
		$('#iconoBono1').html('<i class="icon-collapse-top"></i>');
	}
	else
	{
		$('.masDatosBono1_v2').slideUp('fast');
		$('.abreDatosBono1_v2').attr('data-abiertoVV', '1');
		$('#iconoBono1').html('<i class="icon-collapse"></i>');
	}
});
</script>