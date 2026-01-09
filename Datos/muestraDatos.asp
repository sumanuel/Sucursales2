<!--#include file="../funciones.asp"-->
<% idCategoria = trim(request("idCategoria"))
sql = ""
fechaActual = Now()
mes = month(fechaActual)
anio = year(fechaActual)
if idCategoria <> "" then
 	sql = ""
	sql = sql & "select idCategoria,nombreCategoria,tabla, area,tipo from categorias where idCategoria = '"&idCategoria&"'"
	set rs=db.execute(sql)
	if not rs.eof then
		tabla= trim(rs("tabla"))
		area = trim(rs("area"))
		tipo = trim(rs("tipo"))
		nombreCategoria = server.HTMLEncode(trim(rs("nombreCategoria")))
	end if
else
  response.Redirect("urldescarte.asp")
end if
	sql = ""
	sql = sql & "select * from "&tabla&" where "
	sql = sql & " area = '"&area&"' "
	sql = sql & " and tipo = '"&tipo&"' "
	sql = sql & " and ano = '"&anio&"'"
	set rs=db.execute(sql)
	i = 1
    if not rs.eof then%>
    <div id="graficoMuestraDatos" style="min-width: 400px; height: 400px; margin: 0 auto"></div>  
    <div id="nombreCategoria"><%=nombreCategoria%></div>
    <table class="table table-hover table-bordered" id="tablaDatos">
        <thead>
            <tr>
                <td id="ejeX">Mes</td>
                <td>Año</td>
                <td id="ejeY">Valor</td>
            </tr>
        </thead>
        <tbody>
        <%do while not rs.eof
			txtmes = monthname(trim(rs("periodo")))
			txtanio = trim(rs("ano"))
			txtvalor = trim(rs("valor"))%>
            <tr>
                <td id="mes<%=i%>"><%=txtmes%></td>
                <td id="anio"><%=txtanio%></td>
                <td id="valor<%=i%>"><%=txtvalor%></td>
            </tr>
			<%i = i+1
			rs.MoveNext
		loop%>   
        </tbody>
    </table>
    

<script type="text/javascript">
$(document).ready(function() {
	/*desde aca hasta abajo es el grafico*/
 $(function () {
    var Categorias = [];
    var graficoUno = [];
	var totalValores = <%=i%>-1; //al final siempre suma 1 asi que se lo resto
	var nombreGrafico = $('#nombreCategoria').text();
	var textoEjeX = $('#ejeX').text();
	var textoEjeY = $('#ejeY').text();
	
	for (var i=1; i<=totalValores; i++)
    {
		var valores = $('#valor'+i).text();
		graficoUno.push(parseInt(valores));
		
		var valoresCategorias = $('#mes'+i).text();
		Categorias.push(valoresCategorias);
	}
   
    chart1 = new Highcharts.Chart({
         chart: {
             renderTo: 'graficoMuestraDatos'
         },
        title: {
            text: nombreGrafico
        },
        xAxis: {
			title: {
                text: textoEjeX
            },
            categories: Categorias,
            lineColor: 'black',
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
            title: {
                text: textoEjeY/*,
                minorGridLineDashStyle: 'longdash',
                minorTickInterval: 'auto',
                minorGridLineColor: '#F0F0F0'*/
            },
            labels: {
                formatter: function () {
                    return this.value+'%';
                }
            },
            min: 0,
                minorGridLineWidth: 0,
                gridLineWidth: 0,
                alternateGridColor: null,
                plotBands: [ { // High wind
                    from: 0,
                    to: 200,
                    color: '#D70000',
                    label: {
                        text: 'nivel critico',
                        style: {
                            color: '#fff'
                        }
                    }
                },
				
				{ 
                    from: 200,
                    to: 300,
                    color: 'yellow',
                    label: {
                        text: 'normal',
                        style: {
                            color: '#606060'
                        }
                    }
                },{from: 300,
				to:999999000,
                    color: 'green',
                    label: {
                        text: 'valor ok',
                        style: {
                            color: '#fff'
                        }
                    }
                }]
            
        },
        tooltip: {
            formatter: function() {
                var s;
                if (this.point.name) { // para el grafico de torta
                    s = ''+
                        this.point.name +': '+ this.y ;
                } else {
                    s = ''+
                        this.x  +': '+ this.y+ '%';
                }
                return s;
            }
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
            x: -10,
            y: 100,
            borderWidth: 0
        },
        /*para los montos columnas*/
        series: [{
            type: 'column',
            name: textoEjeY,
            data: graficoUno,
            dataLabels: {
                enabled: true,
                rotation: -90,
                color: '#FFFFFF',
                align: 'right',
                x: 4,
                y: 10,
                style: {
                    fontSize: '13px',
                    fontFamily: 'Verdana, sans-serif'
                }
            }

        },
		{
            type: 'line',
            name: textoEjeY,
            data: graficoUno
        }],
		exporting: {
            enabled: true
        }
        });
    });
});
</script>
<%else%>
<div class="well span5 offset3">El indice no presenta datos</div>
<%end if%>