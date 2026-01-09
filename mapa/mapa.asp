<script src="../js/jquery-1.10.2.min.js" type="text/javascript"></script>
<script src="mapa.js" type="text/javascript"></script>
<script src="../js/charts.data.js" type="text/javascript"></script>
<script src="cl.js"></script>


<div id="container" style="height: 500px; min-width: 310px; max-width: 800px; margin: 0 auto"></div>
<script type="text/javascript">
$(function () {

    $.getJSON('datosMapa.asp', function (data) {
        //var mapData = Highcharts.geojson(Highcharts.maps['countries/cl/cl-stgo']);
        var mapData = Highcharts.geojson(Highcharts.maps['countries/cl/cl-all']);
        
        // Assign id's
        $.each(data, function () {
            this.id = this.code;
        });
        $('#container').highcharts('Map', {
            chart: {
                events: {
                    /*load: function () {
                        this.mapZoom(0.3, -413, -3913);
                    },*/
                    click: function (e) {
                        var x = Math.round(e.xAxis[0].value),
                            y = Math.round(e.yAxis[0].value);
                            //alert(x +'***'+ y)
                    }    
                }
            },
            plotOptions: {
                series: {
                    tooltip: {
                        headerFormat: '',
                        pointFormat: '{point.nombre} <br>Estado : {point.estado} '
                    }
                }
            },
            mapNavigation: {
                enabled: true
            },
            colorAxis: {
                min: 1,
                max: 1000,
                type: 'logarithmic'
            },
            series : [{
                data : data,
                mapData: mapData,
                joinBy: ['num-region', 'region'],
                //name: 'Population density',
                allowPointSelect: true,
                cursor: 'pointer'
                /*states: {
                    hover: {
                        color: '#BADA55',
                        borderColor: 'gray'
                    }
                }*/
            }/*,
            {
                type: "mappoint",
                name: "Sucursales",

                data: data,
                states: {
                    hover: {
                        color: '#BADA55',
                        borderColor: 'gray'
                    }
                }
            }*/]
        });

    });
});
</script>