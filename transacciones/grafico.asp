<!--#include file="../funciones.asp"-->
<div class="row-fluid">
	<div class="span10 offset2" id="grafico"></div>
</div>
<%consulta = trim(request("consulta"))
tipoConsulta = trim(request("tipoConsulta"))
sucursal = trim(request("sucursal"))
Select Case (consulta)
	Case "1":
		campo = "pagos2"
		titulo = "Pagos 2%"
	Case "2":
		campo = "ppaa"
		titulo = "Pagos PPAA"
	Case "3":
		campo = "leasing"
		titulo = "Pagos Leasing"
	Case "4":
		campo = "nominas"
		titulo="Recaudación Nóminas"
	Case "5":
		campo = "recCred"
		titulo = "Recaudación Créditos (Prepago Voluntario Cliente)"
	case "6":
		campo = "trasCaja"
		titulo="Traspaso entre Cajas"
	case "7":
		campo = "ingCaja"
		titulo="Ingreso a Caja"
	case "8":
		campo = "creSocial"
		titulo="Pago de Crédito Social"
	case "9":
		campo = "reDistr"
		titulo="Recaudación por Distribuir"
	case "10":
		campo = "pagosAFP"
		titulo="Pago Pensiones AFP"
	case "11":
		campo = "pagosIPS"
		titulo="Pago Pensiones IPS"
	case "12":
		campo = "licencias"
		titulo="Pago Licencias"
End Select
mesActual=month(date())
anio = year(date())
if tipoConsulta = "1" then
	sql = ""
	sql = sql & " select sum("&campo&"), "
	sql = sql & " CONVERT(DATETIME, CONVERT(CHAR(8), fecha)) as fecha "
	sql = sql & " from SUC_transacciones_diarias a, "
	sql = sql & " SUC_sucursal b "
	sql = sql & " where a.cod_sucursal = b.cod_bantotal "
	sql = sql & " and b.suc_estado = 1 "
	sql = sql & " and month(CONVERT(DATETIME, CONVERT(CHAR(8), fecha))) = '"&mesActual&"' "
	sql = sql & " and year(CONVERT(DATETIME, CONVERT(CHAR(8), fecha))) = '"&anio&"' "
	sql = sql & " group by  fecha "
	sql = sql & " order by fecha asc "
	tipoGrafico = "line"
end if
if tipoConsulta = "2" then
	sql = ""
	sql = sql & " select sum("&campo&"), "
	sql = sql & " CONVERT(DATETIME, CONVERT(CHAR(8), fecha)) as fecha "
	sql = sql & " from SUC_transacciones_acumuladas a, "
	sql = sql & " SUC_sucursal b "
	sql = sql & " where a.cod_sucursal = b.cod_bantotal "
	'sql = sql & " and CONVERT(DATETIME, CONVERT(CHAR(8), fecha)) = ( "
	'sql = sql & " select max(CONVERT(DATETIME, CONVERT(CHAR(8), fecha))) "
	'sql = sql & " from SUC_transacciones_acumuladas) "
	sql = sql & " and b.suc_estado = 1 "
	sql = sql & " and month(CONVERT(DATETIME, CONVERT(CHAR(8), fecha))) = '"&mesActual&"' "
	sql = sql & " and year(CONVERT(DATETIME, CONVERT(CHAR(8), fecha))) = '"&anio&"' "
	sql = sql & " group by  fecha "
	sql = sql & " order by fecha asc "
end if
'response.write(sql)
'response.end
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	resultado = ""
	resultado = resultado & "<table id='datatable' class='oculto'>"
	resultado = resultado & "<thead>"
	resultado = resultado & "<tr>"
	resultado = resultado & "<th>Monto</th>"
	resultado = resultado & "<th>Fecha</th>"
	resultado = resultado & "</tr>"
	resultado = resultado & "</thead>"
	resultado = resultado & "<tbody>"
	for i=0 to ubound(datos,2)
		monto = trim(datos(0,i))
		fecha = trim(datos(1,i))
		anioFecha = year(fecha)
		mesFecha = month(fecha)
		diaFecha = day(fecha)
		resultado = resultado & "<tr>"
		resultado = resultado & "<td class='monto'>"&monto&"</td>"
		resultado = resultado & "<td class='fecha'>"&diaFecha&"/"&mesFecha&"/"&anioFecha&"</td>"
		resultado = resultado & "</tr>"
	next

	resultado = resultado & "</tbody>"
	resultado = resultado & "</table>"
	response.write(resultado)
end if%>
<script type="text/javascript">

$(function () {
	var serie1 = [];
	var serie2 = [];
	$('.monto').each(function(){
		valorSerie1 = $(this).text()
		serie1.push(parseInt(valorSerie1));
	});
	Array.prototype.max = function() {
		return Math.max.apply(null, this);
	};

	Array.prototype.min = function() {
		return Math.min.apply(null, this);
	};
	var valorMax = serie1.max();
	var valorMin = serie1.min();
	$('.fecha').each(function(){
		valorSerie2 = $(this).text()
		serie2.push(valorSerie2);
	});
	$('#grafico').highcharts({
		chart: {
		<%if tipoConsulta = "1" then%>
			type: '<%=tipoGrafico%>',
		<%end if%>
			width: 800,
			height: 450
		},
		title: {
			text: '<%=titulo%>'
		},
		xAxis: {
			categories: serie2,
			labels: {
				rotation: -45,
				align: 'right',
				style: {
					fontSize: '13px',
					fontFamily: 'Verdana, sans-serif'
				}
			}
		},
		yAxis: {
			min: 0,
				title: {
				text: 'Cantidad'
			},
			labels: {
				formatter: function () {
					return this.value;
				}
			},
			plotLines: [{
				value: 0,
				width: 1,
				color: '#808080'
			}]
		},
		legend: {
			enabled: false
		},
		/* tooltip: {
		pointFormat: 'Population in 2008: <b>{point.y:.1f} millions</b>',
		},*/
		exporting: {
			filename: '<%=titulo%>'
		},
		series: [{
			name: '<%=titulo%>',
			type: 'column',
			data: serie1,
			dataLabels: {
				enabled: true,
				rotation: -90,
				color: '#000000',
				align: 'right',
				x: 4,
				y: 10,
				style: {
					fontSize: '13px',
					fontFamily: 'Verdana, sans-serif'
				}
			}
		}<%if tipoConsulta = "2" then%>
		,{
			name:'Tendencia',
            type: 'line',
            marker: { enabled: false },
            enableMouseTracking: false,
            color: '#ff0000',
            /* function returns data for trend-line */
            data: (function() {
              return fitData(serie1).data;
            })()
          }
		<%end if%>
		]
	});
});
</script>
