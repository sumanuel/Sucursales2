<!--#include file="../../funciones.asp"-->
<%grafico=trim(request("grafico"))
render = trim(request("render"))
sql = ""
sql = ""
sql = sql & " select suc_jeps_short, " 
sql = sql & " SUM(afi_normal) as afi_normal, "
sql = sql & " SUM(afi_pbs) as afi_pbs, "
sql = sql & " SUM(afi_ffaa) as afi_ffaa, "
sql = sql & " (SUM(afi_normal)+SUM(afi_pbs)+SUM(afi_ffaa)) as total "
sql = sql & " from ( select b.suc_jeps_short, "
sql = sql & " a.cod_sucursal, "
sql = sql & " a.nombre_sucursal, "
sql = sql & " a.afi_normal, "
sql = sql & " a.afi_pbs, "
sql = sql & " a.afi_ffaa, "
sql = sql & " a.fecha "
sql = sql & " from SUC_transacciones_diarias a "
sql = sql & " inner join SUC_sucursal b on a.cod_sucursal = b.cod_bantotal "
sql = sql & " where year(a.fecha) = year((select utilidades.dbo.fn_diaHabilAnterior(GETDATE()))) "
sql = sql & " and month(a.fecha) = month((select utilidades.dbo.fn_diaHabilAnterior(GETDATE()))) "
sql = sql & " and b.suc_foco = 1 "
sql = sql & " ) as z "
sql = sql & " where z.suc_jeps_short <> '' and (afi_normal <> 0 or afi_pbs <> 0) "
sql = sql & " group by z.suc_jeps_short order by total desc"
'Response.Write(sql)
'Response.End()
set rs = db.execute(sql)
if not rs.eof then
datos = rs.GetRows()%>
<div class="row-fluid">
    <div class="span12">
    <div id="graficoAfiliacionesEspecial"></div>
    <table class="oculto hidden" id="tablaDatosEspecial">
        <thead>
            <th>Zonal</th>
            <th>Normal</th>
            <th>PBS</th>
            <th>FFAA</th>
            <th>Acumulado</th>
        </thead>
        <tbody>
            <%For i = 0 to ubound(datos, 2)
                zonal = trim(datos(0,i))
                valor1 = trim(datos(1,i))
                valor2 = trim(datos(2,i))
				valor3 = trim(datos(3,i))
                valor4 = trim(datos(4,i))
				%>
                <tr>
                    <td>
                        <%=server.htmlencode(zonal)%>
                    </td>
                    <td>
                        <%=valor1%>
                    </td>
                    <td>
                        <%=valor2%>
                    </td>
                    <td>
                        <%=valor3%>
                    </td>
                    <td class="total">
                        <%=valor4%>
                    </td>
                </tr>
            <%next%>
        </tbody>
        </table>
    </div>
</div>
<script type="text/javascript">

$(function () {
    var maximoValor = 0;
    $('.total').each(function()
    {
       $this = parseInt( $(this).text() );
       if ($this > maximoValor) maximoValor = $this;
    });
    $('#graficoAfiliacionesEspecial').highcharts({
        data: {
            table: document.getElementById('tablaDatosEspecial')
        },
        
        series: [{type: 'column'},{type:'column'},{type:'column'},{type:'column'}],
        title: {
            text: 'Jeps'
        },
         xAxis: {
                labels: {
                rotation: -45,
                align: 'right',
                style: {
                    fontSize: '10px',
                    fontFamily: 'Verdana, sans-serif'
                }
            }             
        },
        plotOptions: {
            column: {size:'100%'}
        },
        yAxis: {
            allowDecimals: false,
            max: maximoValor,
            title: {
                text: 'Units'
            }
        },
        tooltip: {
            formatter: function() {
                return '<b>'+ this.series.name +'</b><br/>'+
                    this.y +' '+ this.x.toUpperCase();
            }
        }
    });
});

</script>
<style type="text/css">
.chart-wrapper {
 position: relative;
    width:100%;
    float:left;
}

.chart-inner {
position: absolute;
    width: 100%; height: 100%;
}
</style>
<%end if%>