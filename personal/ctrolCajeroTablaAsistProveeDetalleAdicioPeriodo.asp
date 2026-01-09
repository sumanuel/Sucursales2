<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
periodo = trim(request("periodo"))
%>


<%sql = ""
sql = sql & " EXEC SCSS_prc_cajeros_total_asistencia_adicional_por_proveedor '"&periodo&"','2' "
'response.write(sql)
'response.end
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
  datos = rs.getrows()
  tieneDatos = 1
end if%>
<style type="text/css"> 
    .cuerpoTabla{
        background: #f2f2f2;
    }              
    .table-hover2>tbody>tr:hover>td, 

    .table-hover2>tbody>tr:hover>th {
       background-color: #FFE49A;
       color:#0d0d0d;
    }
	.table thead {
	  color: #0A090A; 
	  background-color: #D9E8FF; /* Color de fondo de cabecera */
	}
	.table-hover2-cells > tbody > tr:hover > td:hover {
	    background-color: #93FE55;
	}
</style>
<table id="tablaTotalAsistProveeDetalleAdicioPeriodo" class="table table-bordered table-hover2 table-condensed table-striped cuerpoTabla table-hover2-cells" data-perfilMain="<%=perfilMain%>" data-idUsuario="<%=idUsuario%>" data-periodo="<%=periodo%>">
	<thead>
		<tr>
			<th style="background-color: #f2f2f2;"></th>
			<th style="background-color: #e6e6ff; text-align: center;" colspan="4">ECR</th>
			<th style="background-color: #e6f7ff; text-align: center;" colspan="4">Sinergy</th>
			<th style="background-color: #e6ffe6; text-align: center;" colspan="3">Totales</th>
		</tr>
		<tr>
			<th style="background-color: #f2f2f2; text-align: center;">Fecha</th>
			<th style="background-color: #e6e6ff; text-align: center;">Solic</th>
			<th style="background-color: #e6e6ff; text-align: center;">Lleg</th>
			<th style="background-color: #e6e6ff; text-align: center;">Rev</th>
			<th style="background-color: #e6e6ff; text-align: center;">Cob%</th>
			<th style="background-color: #e6f7ff; text-align: center;">Solic</th>
			<th style="background-color: #e6f7ff; text-align: center;">Lleg</th>
			<th style="background-color: #e6f7ff; text-align: center;">Rev</th>
			<th style="background-color: #e6f7ff; text-align: center;">Cob%</th>    
			<th style="background-color: #e6ffe6; text-align: center;">T.Solic</th>
			<th style="background-color: #e6ffe6; text-align: center;">T.LLeg</th>
			<th style="background-color: #e6ffe6; text-align: center;">Cob%</th>
		</tr>
	</thead>
	<tbody>
	<%if tieneDatos = 1 then
		for i = 0 to ubound(datos,2)
			fecha = trim(datos(0,i))
		   	solicitadoECR = trim(datos(1,i))
		   	llegaronECR = trim(datos(2,i))  
		    revisarECR = trim(datos(3,i))
		    ECR = trim(datos(4,i))
		    solicitadoSINE = trim(datos(5,i)) 
		    llegaronSINE = trim(datos(6,i)) 
		    revisarSINE = trim(datos(7,i)) 
		    SINERGY = trim(datos(8,i)) 
		    totalSolicitado = trim(datos(9,i)) 
		    totallegaron = trim(datos(10,i)) 
		    cobertura = trim(datos(11,i)) 
			%>
			<tr>
				<td style="background-color: #f2f2f2; text-align: center;"  class="nombreSerie" data-valor="<%=fecha%>"><%=fecha%></td>
				<td class="valorSerie1 mano" data-valor="<%=solicitadoECR%>" onclick="muestraDetalleAdic2(this,'1','<%=fecha%>')"><%=solicitadoECR%></td>
				<td class="valorSerie2 mano" data-valor="<%=llegaronECR%>" onclick="muestraDetalleAdic2(this,'1','<%=fecha%>')"><%=llegaronECR%></td>
				<td class="valorSerie3 mano" data-valor="<%=revisarECR%>" onclick="muestraDetalleAdic2(this,'1','<%=fecha%>')"><%=revisarECR%></td>
				<td style="background-color: #e6e6ff; text-align: center;" ><%=ECR%></td>
				<td class="mano" onclick="muestraDetalleAdic2(this,'2','<%=fecha%>')"><%=solicitadoSINE%></td>
				<td class="mano" onclick="muestraDetalleAdic2(this,'2','<%=fecha%>')"><%=llegaronSINE%></td>
				<td class="mano" onclick="muestraDetalleAdic2(this,'2','<%=fecha%>')"><%=revisarSINE%></td>
				<td style="background-color: #e6f7ff; text-align: center;"><%=SINERGY%></td>
				<td><%=totalSolicitado%></td>
				<td><%=totallegaron%></td>
				<td style="background-color: #e6ffe6; text-align: center;"><%=cobertura%></td>
			</tr>
		<%next
		else%>
	<tr>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
	</tr>
<%end if%>
	</tbody>
</table>

<!--<div class="row-fluid"><br></div>
<div class="row-fluid"></div>-->
<script type="text/javascript">
	$(function(){
		creaGrafico();
		
		$('#tablaTotalAsistProveeDetalleAdicioPeriodo').dataTable( {
			"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
			"sPaginationType": "bootstrap",
			"sLoadingRecords": "Cargando...",
		});
});


	function muestraDetalleAdic2(positionColumnAdic, idEmpresa, fecha) {
		var idEmpresa = idEmpresa;	
        var positionColumn =  positionColumnAdic.cellIndex;
        var fecha = fecha;

        var fechaFormateada =  fecha.substring(6,10) + "" +fecha.substring(3,5) + "" + fecha.substring(0,2);

        
        if (positionColumn == 5){
        	positionColumn = 1;
        	//console.log("4");
        }
        if (positionColumn == 6){
        	positionColumn = 2;
        	//console.log("5");
        }
        if (positionColumn == 7){
        	positionColumn = 3;
        	//console.log("6");
        }

 		//console.log("idEmpresa = " + idEmpresa + " | positionColumn = " + positionColumn + " | fechaFormateada = " + fechaFormateada);

    	var pagina, div, datos, idEmpresa, idUsuario, perfilMain;
    	idUsuario = $('#tablaTotalAsistProveeDetalleAdicioPeriodo').attr('data-idUsuario');
		perfilMain = $('#tablaTotalAsistProveeDetalleAdicioPeriodo').attr('data-perfilMain');
    	pagina = 'ctrolCajeroTablaAsistProveeDetalleAdicHoy.asp';
    	div = 'ctrolCajeroPeriodoDetalle';
    	datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&positionColumn='+positionColumn+'&idEmpresa='+idEmpresa+'&tipoVista=2&fechaFormateada='+fechaFormateada;
    	//console.log(datos)
    	enviaDatos(pagina,div,datos);

    	$('#ctrolCajeroCargaTablaDetalleMod').hide();
		$('#ctrolCajeroTablaSucursal').hide();
		$('#ctrolCajeroTablaSucursalAsist').hide();

		$('#ctrolCajeroPeriodoDetalle').show();
	}


	function creaGrafico(){
		var rowCount = $('#tablaTotalAsistProveeDetalleAdicioPeriodo tr').length -1;
		//console.log(rowCount);
		var habilita;
		if (rowCount <=35)
		{
			habilita = true;
		}
		else
		{
			habilita = false;   
		}
		var categorias = [];
		$('.nombreSerie').each(function(){
			categorias.push($(this).attr('data-valor'))
		});
		var valorSerie1 = [];
		$('.valorSerie1').each(function(){
			valorSerie1.push(parseInt($(this).attr('data-valor')));
		});
		var valorSerie2 = [];
		$('.valorSerie2').each(function(){
			valorSerie2.push(parseInt($(this).attr('data-valor')));
		});
		var valorSerie3 = [];
		$('.valorSerie3').each(function(){
			valorSerie3.push(parseInt($(this).attr('data-valor')));
		});
		
	$('#ctrolCajeroCargaTablaDetalle').highcharts({
	      chart: {
		        type: 'column',
				width: 600,
				height: 410,
				options3d: {
					enabled: true,
					alpha: 8,
					beta: 20,
					depth: 70
				}
		    },
		    title: {
		        text: 'Asistencia Cajeros Titulares'
		    },

		
			 xAxis: {
				categories: categorias,
				crosshair: true,
				 labels: {
            		skew3d: true,
           			style: {
                	fontSize: '12px',
                	fontStyle: 'Verdana',
                	color: 'black'

            }
        }
   			 },
		    subtitle: {
		        text: 'Totales Por Periodo'
		    },
		    tooltip: {
		        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
		        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
		            '<td style="padding:0"><b>{point.y} </b></td></tr>',
		        footerFormat: '</table>',
		        shared: true,
		        useHTML: true
		    },

		  	plotOptions: {
	            column: {
	                pointPadding: 0.2,
	                borderWidth: 0
	            }
	        },
		    series: [{
		        name: 'Solicitado',
		        data: valorSerie1, 
		    },{
		        name: 'Revision',
		        data: valorSerie3,
		      },{
		        name: 'Llegaron',
		        data: valorSerie2,
		}]
	});

	
	};
</script>
