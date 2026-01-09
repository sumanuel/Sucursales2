<%mes = trim(request("mes"))%>
<div class="row-fluid">
	<div class="span2 offset5">
		<span class="label label-info">
			Distribuci&oacute;n de los Rezagos
		</span>	
	</div>
</div>
<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid">
			<div class="span1 offset11">
				<span class="label label-info mano" id="muestraDetalleT2" data-tipo="1">
					<span id="iconoT2"><i class="icon-chevron-down"></i></span> Detalles
				</span>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12">
				<table id="tablaRedMovilT2" class="table table-bordered table-hover table-condensed" data-mes="<%=mes%>">
					<thead>
						<tr>
							<th rowspan="2">
								Rezagos
							</th>
							<th colspan="2">
								Programados
							</th>
							<th colspan="2">
								En ruta
							</th>
							<th colspan="2">
								Pagados
							</th>
							<th colspan="2">
								Bloqueados
							</th>
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
					</thead>
					<tbody>
						
					</tbody>
				</table>	
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$('#muestraDetalleT2').click(function(){
	var tipo = $(this).attr('data-tipo');
	if (tipo ==='1')
	{
		$('#iconoT2').html('<i class="icon-chevron-up"></i>');
		$(this).attr('data-tipo', '2');
	}
	else
	{
		$('#iconoT2').html('<i class="icon-chevron-down"></i>');
		$(this).attr('data-tipo', '1');
	}
});
</script>