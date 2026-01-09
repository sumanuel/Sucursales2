<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursalMain"))
idIndice = trim(request("idIndice"))
traefecha = trim(request("traefecha"))
perfil = trim(request("perfilMain"))
idUsuario = trim(request("idUsuarioMain"))
if traefecha = "" then traefecha = "0"
'dato de la tabla debe salir de indices'
sql = ""
sql = sql & " select tituloIndice,tabla, area, tipo from SUC_indices where idIndice = '"&idIndice&"'"
set rs = db.execute(sql)
if not rs.eof then
    tabla = trim(rs("tabla"))
    nombreGrafico = trim(rs("tituloIndice"))
    area = trim(rs("area"))
    tipo = trim(rs("tipo"))
end if
if traefecha = "1" then
    meses  = clng(trim(request("cantidadMeses")))
    fecha = date()
    mesFecha = month(fecha)
    totalMeses = mesFecha - meses
    if totalMeses < 0 then
        anioFecha = year(fecha) -1
    else
        anioFecha = year(fecha)
    end if
else
    fechaActual = date()
    fecha = cdate(calculaUltimoDia(Date()))
    mesFecha = month(fecha)
    anioFecha = year(fecha)
end if

fecha3Meses = "02/02/2014"
fecha6Meses = "02/05/2014"
fecha12Meses = "02/08/2014"
if traefecha = "1" then
    sql = "" 
    sql = sql & " select a.fecha, sum(a.valor) "
    sql = sql & " from "&tabla&" a "
	sql = sql & " inner join SUC_sucursal b on a.cod_bantotal = b.cod_bantotal "
    sql = sql & " where MONTH(fecha) = (DATEADD (mm , -"&meses&" , getdate() ))"
    sql = sql & " and year(fecha) = '"&anioFecha&"'"
    if perfil = "1" then
		sql = sql & " and a.cod_sucursal = '"&idSucursal&"' "
	end if
    if perfil = "2" then 
        sql = sql & " and a.cod_sucursal in (select id_sucursal from SUC_zonales_sucursal where id_zonal = '"&idUsuario&"') "
    end if
    sql = sql & " and area = '"&area&"' and tipo = '"&tipo&"' "
else
    sql = ""
    sql = sql & " select a.fecha, sum(a.valor) "
    sql = sql & " from "&tabla&" a "
	sql = sql & " inner join SUC_sucursal b on a.cod_bantotal = b.cod_bantotal "
    sql = sql & " where YEAR(a.fecha) = '"&anioFecha&"' "
    sql = sql & " and MONTH(a.fecha) = '"&mesFecha&"' "
   if perfil = "1" then
        sql = sql & " and a.cod_sucursal = '"&idSucursal&"' "
    end if
    if perfil = "2" then 
        sql = sql & " and a.cod_sucursal in (select id_sucursal from SUC_zonales_sucursal where id_zonal = '"&idUsuario&"') "
    end if
    sql = sql & " and area = '"&area&"' and tipo  = '"&tipo&"' "
end if
sql = sql & " group by a.fecha "
sql = sql & " order by a.fecha asc "

'response.Write(sql)

set rs = db.execute(sql)
if not rs.eof then
    datos = rs.GetRows()%>
    <div class="row-fluid">
        <div class="span5"></div>
        <div class="span3 alert alert-info mano"  id="mostrarTablaValores">
            <strong>Mostrar como Tabla 
                <i class="icon-table"></i>
            </strong>
        </div>
        <div class="alert alert-info mano oculto" id="mostrarGrafico">
            <strong>
                Mostrar como Gráfico 
                <i class="icon-bar-chart"></i>
            </strong>
        </div>
        <div id="cierraGrafico" class="mano span3">
            <div class="alert alert-error">
                <div class="close" data-dismiss="alert"><i class="icon-collapse-top"></i></div>
                <strong>Cerrar Gráfico</strong> 
            </div>
        </div>
    </div>
    <div class="row-fluid">
        <div id="grafico" class="span11" style="max-width: 800px"></div> 
        <div id="tablaValoresGrafico" class="oculto">
            <table id="datatable" class="table table-bordered ">
                <thead>
                    <tr>
                        <th id="nombreGrafico" colspan="2"><%=nombreGrafico%></th>
                    </tr>
                </thead>
                <tbody>
                    <%For i = 0 to ubound(datos, 2)
                        valor1 = trim(datos(0,i))
                        valor2 = trim(datos(1,i))%>
                        <tr>
                            <td><%=valor1%></th>
                            <td id="valorGrafico" class="valoresGraficos"><%=valor2%></td>
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

textoTitulo = $('#nombreGrafico').text();
Highcharts.setOptions({lang: {decimalPoint: ',',thousandsSep: '.'},tooltip: {yDecimals: 2}});
$(function () {
    //var ancho = $(document).width() - 600;
    //alert(ancho);
    var alto = $(document).height();
    $('#grafico').highcharts({
        xAxis: {
            categories:  GetLabels($("#datatable tr td:first-of-type")),
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
            type: 'line'/*,
            width: ancho*/
        },
        title: {
            text: textoTitulo
        },
        series: [{
            data: ConvertStringToFloat ( $("#datatable tr td:last-child") ),
            name: textoTitulo
			//data: $("#datatable tr td:last-child") 
        }]
    });
});
$('#cierraGrafico').click(function(){
    $('#muestraGrafico').slideUp('slow');
    $('#muestraGraficoIndiceGer').slideUp('slow');
});
$('#mostrarTablaValores').click(function(){
    $('#grafico').slideUp('fast');
    $('#tablaValoresGrafico').slideDown('slow');
    $(this).addClass('oculto').removeClass('span3');
    $('#mostrarGrafico').removeClass('oculto').addClass('span3');
});
$('#mostrarGrafico').click(function(){
    $('#tablaValoresGrafico').slideUp('fast');
    $('#grafico').slideDown('slow');
    $(this).addClass('oculto').removeClass('span3');
    $('#mostrarTablaValores').removeClass('oculto').addClass('span3');
});

$('.valoresGraficos').each(function(){
    var valor = numberFormat($(this).text());
    $(this).text(valor);
});

$('.graficoMeses').click(function(){
    var cantidadMeses = $(this).attr('data-meses');
    var idSucursal = $(this).attr('data-idSucursal');
    var idIndice = $(this).attr('data-idIndice');
    var traeFecha = $(this).attr('data-traeFecha');
    var pagina = 'grafico/graficos.asp';
    var donde = 'muestraGrafico';
    var datos = 'idIndice='+idIndice+'&idSucursal='+idSucursal+'&cantidadMeses='+cantidadMeses+'&traefecha='+traeFecha;
    try{
           enviaDatos(pagina,div,datos);
    }catch(err){}
    return false;
});
</script>
<%else%>
<div class="row-fluid"  id="errorGrafico">
    <div class="span12 alert alert-error">
        <span class="icon-stack">
            <i class="icon-check-empty icon-stack-base text-error"></i>
            <i class="icon-remove text-error"></i>
        </span>
        No existen datos para este item
    </div>
</div>

    <script type="text/javascript">
        $('#muestraGrafico').removeClass('well');
        setTimeout(function() {
            $('#errorGrafico').fadeOut('slow');
        }, 1700);
    </script>
<%end if%>
