<!--#include file="../../funciones.asp"-->
<%grafico=trim(request("grafico"))
render = trim(request("render"))
sql = ""
sql = sql & " declare @diaAnterior as date "
sql = sql & " set @diaAnterior = (select utilidades.dbo.fn_diaHabilAnterior(GETDATE())) "
sql = sql & " select "
sql = sql & " b.suc_zonal as zonal, "
if grafico = "1" then
   sql = sql & " sum(a.colCred) as num_op "
   titulo = "Numero de operaciones"
   orden = "num_op"
end if
if grafico = "2" then
   sql = sql & " sum(a.colCred_monto) as monto "
   orden = "monto"
   titulo = "Monto"
end if
if grafico = "3" then
    sql = sql & " (cast(sum(a.colCred) as float) "
    sql = sql & " / cast( "
    sql = sql & " (select COUNT(*) "
    sql = sql & " from SUC_sucursal c "
    sql = sql & " where c.suc_zonal_rut = b.suc_zonal_rut) as float)) as prom_sum_op "
    titulo = "Promedio suma de operaciones"
    orden = "prom_sum_op"
end if
if grafico = "4" then
    sql = sql & " (cast(sum(a.colCred_monto) as float) "
    sql = sql & " /cast((select COUNT(*) "
    sql = sql & " from SUC_sucursal c "
    sql = sql & " where c.suc_zonal_rut = b.suc_zonal_rut) as float)) as prom_monto "
    orden ="prom_monto"
    titulo = "Promedio de montos"
end if
sql = sql & " from SUC_transacciones_diarias a "
sql = sql & " inner join SUC_sucursal b on a.cod_sucursal = b.cod_bantotal "
sql = sql & " where YEAR(a.fecha) = year(@diaAnterior) "
sql = sql & " and MONTH(a.fecha) = MONTH(@diaAnterior) "
sql = sql & " and b.suc_foco = 1 "
sql = sql & " and a.colCred <> 0 "
sql = sql & " group by b.suc_zonal_rut, "
sql = sql & " b.suc_zonal order by "&orden&" desc,  b.suc_zonal  "
set rs = db.execute(sql)
if not rs.eof then
datos = rs.GetRows()%>
<div class="row-fluid">
    <div id="<%=render%>"></div>
    <div class="span12 hidden oculto">
        <table id="tablaDatos">
            <thead>
                <th>Zonal</th>
                <th><%=titulo%></th>
            </thead>
            <tbody>
            <%For i = 0 to ubound(datos, 2)
                zonal = trim(datos(0,i))
                valor = trim(datos(1,i))%>
                <tr>
                    <td>
                        <%=server.htmlencode(zonal)%>
                    </td>
                    <td>
                        <%=valor%>
                    </td>
                </tr>
            <%next%>
            </tbody>
        </table>
    </div>
</div>



<script type="text/javascript">
var ConvertStringToFloat  = function( datas ) {
    return $(datas).map(function(i, el) {
        var str = $(el).text();
        return parseFloat(str.replace(",", "."));
    });
}

var GetLabels = function( els ) {
    return $(els).map(function(i, el) {
        return $(el).text();
    });
}

textoTitulo = '<%=titulo%>';
Highcharts.setOptions({lang: {decimalPoint: ',',thousandsSep: '.'},tooltip: {yDecimals: 2}});
$(function () {
    $('#<%=render%>').highcharts({

        xAxis: {
            categories:  GetLabels($("#tablaDatos tr td:first-of-type")),
            labels: {
                rotation: -45,
                align: 'right',
                style: {
                    fontSize: '11px',
                    fontFamily: 'Verdana, sans-serif'
                },
                text: textoTitulo
            },
            title: {
                text: textoTitulo
            },
             
        },
         yAxis: {
            title: {
                minorGridLineDashStyle: 'longdash',
                minorTickInterval: 'auto',
                text: 'Valores',
                minorGridLineColor: '#F0F0F0'
            },
            labels: {
                formatter: function () {
                    return this.value;
                }
            },
            gridLineDashStyle: 'longdash'
            
        },
        tooltip: {

            shared: true,
            useHTML: true,
            headerFormat: '<small>{point.key}</small><table>',
            pointFormat: '<tr><td style="color: {series.color}">'+textoTitulo+': </td>' +
            '<td style="text-align: right"><b>{point.y}</b></td></tr>',
            footerFormat: '</table>',
            valueDecimals: 2
        },
        exporting: {
            filename: textoTitulo
        },
        rangeSelector: {
            selected: 1
        },
        chart: {
            type: 'column',
            width: 550
        },
        title: {
            text: textoTitulo
        },
        series: [{
            showInLegend: false,
            data: ConvertStringToFloat ( $("#tablaDatos tr td:last-child") ),
            name: textoTitulo
        }]

    });
});
</script>
<%end if%>