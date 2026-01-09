<%grafico= trim(request("graficoDash"))
idSucursal = trim(request("idSucursalMain"))
perfil = trim(request("perfilMain"))

if grafico <= 3 or grafico=7 then
    tipoGrafico = "pie"
end if
if grafico = "1" then
    titulo="Sucursales Abiertas-Cerradas"
end if
if grafico = "1" then
    titulo="Apertura sucursal"
 end if
if grafico = "2" then
    titulo="Cajeros"
 end if
if grafico = "3" then
    titulo="Guardias"
 end if
if grafico = "7" then
    titulo="Desbordes"
end if
if tipoGrafico = "pie" then%>
<script type="text/javascript">
Highcharts.setOptions({
    lang: {decimalPoint: ',',thousandsSep: '.'},tooltip: {yDecimals: 2},
    <%if grafico = "1" then%>
    colors: ['#7CA34B', '#E0D236','#FF0000']
    <%else%>
    colors: ['#7CA34B','#FF0000']
    <%end if%>
});
$(function(){
        var options = {
        chart: {
            renderTo: 'graficoDash<%=grafico%>',
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            spacingBottom: 10,
            spacingTop: 10,
            spacingLeft: -100,
            spacingRight: 0,
            width: 300,
            height: 250,
            type: 'pie'
        },
        title: {
            text: '<%=titulo%>'
        },
         series: [{
            name: '<%=titulo%>',
            data: []
        }]
    };
    $.getJSON("dashboard/data.asp?tipo=<%=grafico%>&idSucursal=<%=idSucursal%>&perfil=<%=perfil%>", function(json) {
        options.series[0].data = json;
        var chart = new Highcharts.Chart(options);
    });
});
</script>
<%else
    if grafico="4" then
        titulo="Pagos IPS"
    end if
    if grafico="5" then
        titulo="Pagos AFP"
    end if
    if grafico="6" then
        titulo="Pagos bonos"
    end if
    if grafico = "4" or grafico = "6" then%>
    <script type="text/javascript">
  $(function () {
        var dataSet = [];
        var textoSerie1, textoSerie2,textoSerie3,textoSerie4,valorSerie1,valorSerie2,valorSerie3,valorSerie4;
        var serie1 = [];
        var serie2 =[];
        var serie3 =[];
        var serie4 =[];
        var serie5 =[];
        var serie6 =[];
        var textos = [];

        $.getJSON("dashboard/data.asp?tipo=<%=grafico%>&idSucursal=<%=idSucursal%>&perfil=<%=perfil%>", function(data) {
            textoSerie1 = data[0][0];
            textos.push(textoSerie1);

            valorSerie1 = data[0][1];
            serie1.push(valorSerie1);

            textoSerie2 = data[1][0];
            textos.push(textoSerie2);

            valorSerie2 = data[1][1];
            serie2.push(valorSerie2);

            <%if grafico = "6" then%>
                textoSerie3 = data[2][0];
                textos.push(textoSerie3);                
                valorSerie3 = data[2][1];
                serie3.push(valorSerie3);
                
                textoSerie4 = data[3][0];
                textos.push(textoSerie4);                
                valorSerie4 = data[3][1];
                serie4.push(valorSerie4);

                textoSerie5 = data[4][0];
                textos.push(textoSerie5);                
                valorSerie5 = data[4][1];
                serie5.push(valorSerie5);

                textoSerie6 = data[5][0];
                textos.push(textoSerie6);                
                valorSerie6 = data[5][1];
                serie6.push(valorSerie6);
            <%end if%>
            $('#graficoDash<%=grafico%>').highcharts({
                chart: {
                    type: 'column',
                    width: 640,
                    height: 250,
                },
                title: {
                    text: '<%=titulo%>'
                },
                yAxis: {
                    allowDecimals: false,
                    min: 0,
                    title: {
                        minorGridLineDashStyle: 'longdash',
                        minorTickInterval: 'auto',
                        minorGridLineColor: '#F0F0F0',
                        text: 'N° Pagos'
                    },
                    labels: {
                        formatter: function () {
                        return this.value;
                        }
                    }
                },
    
            tooltip: {
                formatter: function() {
                      return  '<b>'+this.series.name +': </b>'+ this.y +'<br/>';
                }
            },
            plotOptions: {
                column: {
                    stacking: 'normal'
                }
            },
    
            series: [
            <%if grafico <> "6" then%>
            {
                name: textoSerie1,
                data: serie1,
                stack: textoSerie1,
                color: '#ff0000'
            }, 
            {
                name: textoSerie2,
                data: serie2,
                stack: textoSerie2,
                color: '#2A9138'
            },
            <% end if %>
            <%if grafico = "6" then%>             
            {
                name: textoSerie3,
                data: serie3,
                stack: textoSerie3,
                color: '#407ADE '
            }
            , 
            {
                name: textoSerie4,
                data: serie4,
                stack: textoSerie4,
                color: '#636975'
            }
            ,
            {
                name: textoSerie5,
                data: serie5,
                stack: textoSerie5,
                color: '#407ADE '
            }
            , 
            {
                name: textoSerie6,
                data: serie6,
                stack: textoSerie6,
                color: '#636975'
            }
            <%end if%>
            ]
        });
  
        });
      });    
    </script>
    <%end if
    if grafico="5" then%>
    <script type="text/javascript">
      $(function () {
        var dataSet = [];
        var textoSerie1, textoSerie2,valorSerie1,valorSerie2,textoSerie3, textoSerie4,valorSerie3,valorSerie4;
        var serie1 = [];
        var serie2 =[];
        var serie3 = [];
        var serie4 =[];
        var textos = [];

        $.getJSON("dashboard/data.asp?tipo=<%=grafico%>&idSucursal=<%=idSucursal%>&perfil=<%=perfil%>", function(data) {
            textoSerie1 = data[0][0];
            textos.push(textoSerie1);
            valorSerie1 = data[0][1];
            serie1.push(valorSerie1);
            textoSerie2 = data[1][0];
            textos.push(textoSerie2);
            valorSerie2 = data[1][1];
            serie2.push(valorSerie2);

            textoSerie3 = data[2][0];
            textos.push(textoSerie3);
            valorSerie3 = data[2][1];
            serie3.push(valorSerie3);

            textoSerie4 = data[3][0];
            textos.push(textoSerie4);
            valorSerie4 = data[3][1];
            serie4.push(valorSerie4);

            $('#graficoDash<%=grafico%>').highcharts({
                chart: {
                    type: 'column',
                    width: 640,
                    height: 250,
                },
                title: {
                    text: '<%=titulo%>'
                },
            yAxis: {
                    allowDecimals: false,
                    min: 0,
                    title: {
                        minorGridLineDashStyle: 'longdash',
                        minorTickInterval: 'auto',
                        minorGridLineColor: '#F0F0F0',
                        text: 'N° Pagos'
                    },
                    labels: {
                        formatter: function () {
                        return this.value;
                        }
                    }
                },
    
            tooltip: {
                formatter: function() {
                      return  '<b>'+this.series.name +': </b>'+ this.y +'<br/>';
                }
            },
            plotOptions: {
                column: {
                    stacking: 'normal'
                }
            },
    
            series: [{
                name: textoSerie1,
                data: serie1,
                stack: textoSerie1,
                color: '#ff0000'
            }, 
            {
                name: textoSerie2,
                data: serie2,
                stack: textoSerie2,
                color: '#2A9138'
            }, 
            {
                name: textoSerie3,
                data: serie3,
                stack: textoSerie3,
                color: '#407ADE'
            }, 
            {
                name: textoSerie4,
                data: serie4,
                stack: textoSerie4,
                color: '#636975'
            }]
        });
  
        });
      });    
    </script>
    <%end if
end if%>
<div class="row-fluid">
    <div id="graf" class="span12"></div>
</div>
