<!--#include file="../funciones.asp"-->
<%tipoGrafico = trim(request("tipoGrafico"))
tipo = trim(request("btnTipo"))
sql = ""
sql = sql & " SELECT HoraPago, "
if tipo = "1" then
	sql = sql & " isnull(I_Qty,0) as I_Qty, "
	sql = sql & " isnull(I_Tot,0) as I_Tot "
	nombreGrafico = "Cantidad de pagos por horas IPS"
else
	sql = sql & " isnull(A_Qty,0) as A_Qty, "
	sql = sql & " isnull(A_Tot,0) as A_Tot "
	nombreGrafico = "Cantidad de pagos por horas AFP"
end if
sql = sql & " FROM SCSS.dbo.vw_Total_Pagos_Hora "
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getrows()
	tieneDatos = 1
end if
if tieneDatos = 1 then%>
	<div class="row-fluid">
		<div class="span3">
			<span class="label label-important mano " id="btnGrafico" data-muestra="1">Grafico</span>
			<span class="label label-info mano" id="btnCierraGrafico">Cerrar</span>
		</div>
	</div>
	<div class="row-fluid" id="muestraTablaPagosHora">
		<div class="span12">
			<table id="tablaHoras" class="table table-bordered table-hover table-condensed" data-nombreGrafico="<%=nombreGrafico%>">
				<thead>
					<tr>
						<th>Hora</th>
						<th>Cantidad</th>
						<th>Monto</th>
					</tr>
				</thead>
				<tbody>
					<%for i = 0 to ubound(datos,2)
						hora = trim(datos(0,i))
						if hora = "" then hora = 0
						cantidad = trim(datos(1,i))
						cantidad2 = trim(datos(1,i))
						monto = trim(datos(2,i))
						monto2 = trim(datos(2,i))
						if cantidad = "" then cantidad = 0
						if monto = "" then monto = 0
						if i = ubound(datos,2) then claseFinal = "final"%>
						<tr>
							<td class="hora <%=claseFinal%>" data-valor="<%=hora%>">
								<%=hora%>
							</td>
							<td class="cantidad <%=claseFinal%>" data-valor="<%=cantidad2%>">
								<span class="numero"><%=cantidad%></span>
							</td>
							<td class="monto <%=claseFinal%>" data-valor="<%=monto2%>">
								$<span class="numero"><%=monto%></span>
							</td>
						</tr>
					<%next%>
				</tbody>
			</table>
		</div>
	</div>
	<div class="row-fluid">
		<div class="span12" id="muestraGraficoPagosHora"></div>
	</div>
	<script type="text/javascript">
		$(function(){
			$('.numero').prettynumber();
		});
		$('#muestraGraficoPagosHora').slideUp('fast');
		$('#btnGrafico').click(function(){
			var muestra = $(this).attr('data-muestra');
			if (muestra ==='1')
			{
				$('#muestraTablaPagosHora').slideUp('fast');
				$('#muestraGraficoPagosHora').slideDown('slow');
				$('#btnGrafico').text('Tabla').attr('data-muestra','0');
				muestraGrafico2();
			}
			else
			{
				$('#muestraGraficoPagosHora').slideUp('fast');
				$('#muestraTablaPagosHora').slideDown('slow');
				$('#btnGrafico').text('Grafico').attr('data-muestra','1');
			}
		});
		function muestraGrafico2()
		{
			var valoresCategoriasGrafico = [];
			var cantidad = [];
			var monto = [];
			var valorCantidad, valorMonto, valorHora;
			$('.hora').each(function(){
				if (!$(this).hasClass('final'))
				{
					valorHora = $.trim($(this).attr('data-valor'));
					valoresCategoriasGrafico.push(valorHora);
				}
			});
			$('.cantidad').each(function(){
				if (!$(this).hasClass('final'))
				{
					valorCantidad = parseInt($.trim($(this).attr('data-valor')));
					cantidad.push(valorCantidad);
				}
			});
			var nombreGrafico = $('#tablaHoras').attr('data-nombreGrafico');
			$('#muestraGraficoPagosHora').highcharts({
				chart: {
					type: 'column',
					width: 550,
					height: 400,
					options3d: {
						enabled: true,
						alpha: 0,
						beta: 30,
						depth: 70
					}
				},
				plotOptions: {
					area: {
						color:'rgba(24,90,169,.75)',
						fillColor:'rgba(24,90,169,.25)',
						marker: {
							enabled: false,
							symbol:'circle'
						}
					},
					series: {
						shadow: false
					}
				},
				title: {
					text: nombreGrafico
				},
				xAxis: {
					categories: valoresCategoriasGrafico,
					labels: {
						rotation: -45,
						align: 'right',
						style: {
							fontSize: '11px',
							fontFamily: 'Verdana, sans-serif'
						}
					}
				},
				yAxis: {
					min: 0,
					title: {
						text: 'Totales'
					}
				},
				tooltip: {
					headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
					pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td><td style="padding:0"><b>{point.y} </b></td></tr>',
					footerFormat: '</table>',
					shared: true,
					useHTML: true
				},
				series: [{
					name: 'Cantidad',
					data: cantidad
				}]
			});
		}
		$('#btnCierraGrafico').click(function(){
			var pagina, div, datos;
			pagina = 'maestroPagos/grafico1a.asp';
			div = 'muestraGrafico1';
			datos='';
			enviaDatos(pagina,div,datos);
		});
	</script>
<%end if%>