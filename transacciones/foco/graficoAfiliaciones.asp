<!--#include file="../../funciones.asp"-->
<%grafico=trim(request("grafico"))
render = trim(request("render"))
sql = ""
sql = sql & " declare @diaAnterior as date "
sql = sql & " set @diaAnterior = (select utilidades.dbo.fn_diaHabilAnterior(GETDATE())) "
sql = sql & " select z.suc_zonal, "
if grafico = "1" then
    sql = sql & " (sum(z.afi_normal)+sum(z.afi_pbs)+sum(z.afi_ffaa)) as afi_total"
    titulo = "Total afiliaciones"
    orden = "afi_total"
end if
if grafico = "2" then
    sql = sql & " (cast((sum(z.afi_normal)+sum(z.afi_pbs)+sum(z.afi_ffaa)) as float) /cast((select COUNT(*) "
    sql = sql & " from SUC_sucursal c "
    sql = sql & " where c.suc_zonal_rut = z.suc_zonal_rut and suc_foco = 1) as float)) as afi_prom "
    titulo = "Promedio afiliaciones"
    orden = "afi_prom"
end if

sql = sql & " from (select b.suc_zonal_rut, "
sql = sql & " b.suc_zonal, "
sql = sql & " a.cod_sucursal, "
sql = sql & " a.nombre_sucursal, "
sql = sql & " a.afi_normal, "
sql = sql & " a.afi_pbs, "
sql = sql & " a.afi_ffaa, "
sql = sql & " a.fecha "
sql = sql & " from SUC_transacciones_diarias a "
sql = sql & " inner join SUC_sucursal b "
sql = sql & " on a.cod_sucursal = b.cod_bantotal "
sql = sql & " where year(a.fecha) = year(@diaAnterior) "
sql = sql & " and month(a.fecha) = month(@diaAnterior) "
sql = sql & " and (a.afi_normal <> 0 or a.afi_pbs <> 0) "
sql = sql & " and a.cod_sucursal in (select cod_bantotal "
sql = sql & " from SUC_sucursal where suc_foco = 1) ) as z "
sql = sql & " group by z.suc_zonal_rut, "
sql = sql & " z.suc_zonal "
sql = sql & " order by "&orden&" desc "
set rs = db.execute(sql)
if not rs.eof then
datos = rs.GetRows()%>
<div id="<%=render%>"></div>

   
        <table class="" id="tablaDatos">
            <thead>
                <th>Zonal</th>
                <th><%=titulo%></th>
            </thead>
            <tbody>
                <%For i = 0 to ubound(datos, 2)
                    zonal = trim(datos(0,i))
                    valor = trim(datos(1,i))%>
                    <tr>
                        <td><%=server.htmlencode(zonal)%></td>
                        <td><%=valor%></td>
                    </tr>
                <%next%>
            </tbody>



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
            data: ConvertStringToFloat ( $("#tablaDatos tr td:last-child") )
        }]

    });
});
</script>
<%end if%>