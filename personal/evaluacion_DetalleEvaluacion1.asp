<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
periodo = trim(request("periodo"))
sucursal = trim(request("sucursal"))

%>
<style>
	.cuerpoTabla{
		background: #f2f2f2;		
	}	
	.table-hover1>tbody>tr:hover>td, .table-hover1>tbody>tr:hover>th {
  		background-color: #d9ffb3;
  		color:#0d0d0d;
	}
	.text-wrap{
    white-space:normal;
	}
	.width-200{
	    width:150px;
	}	
 	.th, .td { white-space: nowrap; }
    dataTables_wrapper {
        margin: 0 auto;
    }
    
</style>
<form id="cuerpoTrabajoDetalleEvaluacion" data-idUsuario="<%=idUsuario%>" data-perfilMain="<%=perfilMain%>"  data-periodo="<%=periodo%>" data-sucursal="<%=sucursal%>">
<%
sql = "exec SUC_prc_eva_get_periodo "
set rs = db.execute(sql)
if not rs.eof then
	PeriodoRS = rs.getrows()
end if
%>

	<div class="row-fluid" id="tablaCasosFiltro" style="padding-top: 5px">
		<span >Periodo</span> 
		<select id='idperiodoEvaluacion' name='idperiodoEvaluacion' class='form-control' required style= 'width : 250px;'>
			<option value='0'>Seleccione Periodo</option>
			<%for i = 0 to ubound(PeriodoRS,2)
				periodoSel = trim(PeriodoRS(0,i))
			    if periodo = 0 then	
					if i = 0 then%>
						<option value="<%=periodoSel%>" selected><%=periodoSel%></option>
					<%else%>
						<option value="<%=periodoSel%>"><%=periodoSel%></option>
					<%end if
				else
					if periodoSel = periodo then%>
						<option value="<%=periodoSel%>" selected><%=periodoSel%></option>
					<%else%>
						<option value="<%=periodoSel%>"><%=periodoSel%></option>
					<%end if
				end if
			next%>
		<%
		sql = "exec SUC_prc_eva_get_sucursales 0 "
		set rs = db.execute(sql)
		if not rs.eof then
			sucursalRS = rs.getrows()
		end if
		%>
		</select> <span>Sucursal</span> <select id='idsucursalEvaluacion' name='idsucursalEvaluacion' class='form-control' required style= 'width : 250px;'>
			<option value='0'>Seleccione Sucursal</option>
			<%for i = 0 to ubound(sucursalRS,2)
				cod_btt = trim(sucursalRS(0,i))	
				nom_suc = server.htmlencode(trim(sucursalRS(1,i)))
				if sucursal = 0 then	
					 if i = 0 then%>
						<option value="<%=cod_btt%>" selected><%=nom_suc%></option>
					<%else%>
						<option value="<%=cod_btt%>"><%=nom_suc%></option>
					<%end if
				else
					if sucursal = cod_btt then%>
						<option value="<%=cod_btt%>" selected><%=nom_suc%></option>
					<%else%>
						<option value="<%=cod_btt%>"><%=nom_suc%></option>
					<%end if
				end if
				next%>
		</select>		 
	</div>
	<div id="filtrosDescargaDetalleEvaluacion"></div>
	</br>
	<div class="outer" id="tabladetalleEva">
	 		<div class="inner">
	 	 	<table id="tablaDetalleEvaluacion" class="table table-bordered mano table-hover1 no-footer dataTable cuerpoTabla stripe row-border order-column" style="border-collapse: collapse;" border="1px" >
				<thead style="background-color: #e6e6ff">
					<tr>						
						<th>Rut</th>
						<th>Nombre</th>
						<th>Sucursal</th>
						<th>Tipo</th>
						<th>Cantidad Trx</th>
						<th>Promedio Trx</th>
						<th>Evaluacion Trx</th>
						<th>Cantidad Atrasos</th>
						<th>Evaluacion Atrasos</th>
						<th>Cantidad Faltantes</th>
						<th>Evaluacion Faltantes</th>
						<th>Cantidad Reclamos</th>
						<th>Evaluacion Reclamos</th>
						<th>Evaluacion Final</th>
					</tr>
				</thead>
				<tbody>						
				</tbody>
			</table>
	 		</div>
	</div>
	</br>
	<div id="DetalleCajero"></div>
</form>

<script type="text/javascript">	

	$(document).ready(function(){
		$('#DetalleCajero').hide();
	    $('[data-toggle="popover"]').popover({
	    	 html:true
	    }); 
		cargaevaluacion ();	

	});	

	function detallecajero(rut){
		$('#tabladetalleEva').hide();
		var sucursal = $('#idsucursalEvaluacion').val();
		var periodo = $('#idperiodoEvaluacion').val();
		var div = 'DetalleCajero';
	    var datos = 'rut='+rut+'&periodo='+periodo+'&sucursal='+sucursal
	    var pagina = 'evaluacion_DetalleCajero.asp';    
	    enviaDatos(pagina,div,datos);
	    $('#DetalleCajero').show();
	}

	$('#idperiodoEvaluacion').change(function(){
	    var per=$(this).val();	
	    var urlDatos = 'evaluacion_FillSucursal.asp';
	    $('#idsucursalEvaluacion').html('');
	    $('#idsucursalEvaluacion').append('<option value="0" >Seleccione Sucursal</option>');
	    $.ajax({url:urlDatos,data:{'per':per},method:'GET'}).then(function(datos) {
			$.each(datos.datosTablaSUC, function(key,datosTablaSUC){
				var codbtt = datosTablaSUC.codbtt
				var nombre = datosTablaSUC.nombre	
				$('#idsucursalEvaluacion').append('<option value="'+codbtt+'" >'+nombre+'</option>');		
			})			
		});
	});

	$('#idsucursalEvaluacion').change(function(){
		$('#DetalleCajero').hide();
		$('#tabladetalleEva').show();
	   	if ( $.fn.dataTable.isDataTable( '#tablaDetalleEvaluacion' ) ) {
		    table = $('#tablaDetalleEvaluacion').DataTable();
		    table.destroy();

		    $('#tablaDetalleEvaluacion > tbody').html('');
		}
		if ( $.fn.dataTable.isDataTable( '#tabladetallecajero' ) ) {
		    table = $('#tabladetallecajero').DataTable();
		    table.destroy();

		    $('#tabladetallecajero > tbody').html('');
		}		
	    var datosTabla = "";
		var periodo= $('#formDetalleEvaluacion').attr('data-periodo');
		var sucursal= $('#formDetalleEvaluacion').attr('data-sucursal');
		var idUsuario= $('#cuerpoTrabajoDetalleEvaluacion').attr('data-idUsuario');
		var perfilMain= $('#cuerpoTrabajoDetalleEvaluacion').attr('data-perfilMain');
		var sucursal = $('#idsucursalEvaluacion').val();
		var periodo = $('#idperiodoEvaluacion').val();
		
		var urlDatos = 'evaluacion_DetalleEvaluacion_datos.asp';
		$.ajax({url:urlDatos,data:{'idUsuario':idUsuario,'perfilMain':perfilMain,'periodo':periodo,'sucursal':sucursal},method:'GET'}).then(function(datos) {
			$.each(datos.datosTablaDC1, function(key,datosTablaDC1){
				var rut = datosTablaDC1.rut
				var nombre = datosTablaDC1.nombre
				var sucursal = datosTablaDC1.sucursal
				var tipo = datosTablaDC1.tipo
				var cantpagos = datosTablaDC1.cantpagos
				var prompagos = datosTablaDC1.prompagos
				var evatrx = datosTablaDC1.evatrx
				var cantatrasos = datosTablaDC1.cantatrasos
				var evaatrasos = datosTablaDC1.evaatrasos
				var cantfaltantes = datosTablaDC1.cantfaltantes
				var evafaltantes = datosTablaDC1.evafaltantes
				var cantrec = datosTablaDC1.cantrec
				var evarec = datosTablaDC1.evarec
				var evafinal = datosTablaDC1.evafinal		


				datosTabla += '<tr onclick="detallecajero('+rut+')">'				
				datosTabla += '<td>'+rut+'</td>';
				datosTabla += '<td>'+nombre+'</td>';
				datosTabla += '<td>'+sucursal+'</td>';
				datosTabla += '<td>'+tipo+'</td>';
				datosTabla += '<td>'+cantpagos+'</td>';
				datosTabla += '<td>'+prompagos+'</td>';
				datosTabla += '<td>'+evatrx+'</td>';
				datosTabla += '<td>'+cantatrasos+'</td>';
				datosTabla += '<td>'+evaatrasos+'</td>';
				datosTabla += '<td>'+cantfaltantes+'</td>';
				datosTabla += '<td>'+evafaltantes+'</td>';
				datosTabla += '<td>'+cantrec+'</td>';
				datosTabla += '<td>'+evarec+'</td>';

				if (evafinal ==="BUENO") {
					datosTabla += '<td style="background-color:#51a351">'+evafinal+'</td>';	
				}
				if (evafinal ==="NORMAL"){
					datosTabla += '<td style="background-color:#f89406">'+evafinal+'</td>';
				}
				if (evafinal ==="MALO"){
					datosTabla += '<td style="background-color:#bd362f">'+evafinal+'</td>';
				}	
				datosTabla += '</tr>';

			})

			$('#tablaDetalleEvaluacion > tbody').append(datosTabla);
			crearTablaDetalleEvaluacion();
			
		});
	});

	function cargaevaluacion(){
		var datosTabla = "";
		var periodo= $('#formDetalleEvaluacion').attr('data-periodo');
		var sucursal= $('#formDetalleEvaluacion').attr('data-sucursal');
		var idUsuario= $('#cuerpoTrabajoDetalleEvaluacion').attr('data-idUsuario');
		var perfilMain= $('#cuerpoTrabajoDetalleEvaluacion').attr('data-perfilMain');
		if (sucursal ===0){
			var sucursal = $('#idsucursalEvaluacion').val();
		}			
		if (periodo ===0){
			var periodo = $('#idperiodoEvaluacion').val();
		}	
		var urlDatos = 'evaluacion_DetalleEvaluacion_datos.asp';
		$.ajax({url:urlDatos,data:{'idUsuario':idUsuario,'perfilMain':perfilMain,'periodo':periodo,'sucursal':sucursal},method:'GET'}).then(function(datos) {
			$.each(datos.datosTablaDC1, function(key,datosTablaDC1){
				var rut = datosTablaDC1.rut
				var nombre = datosTablaDC1.nombre
				var sucursal = datosTablaDC1.sucursal
				var tipo = datosTablaDC1.tipo
				var cantpagos = datosTablaDC1.cantpagos
				var prompagos = datosTablaDC1.prompagos
				var evatrx = datosTablaDC1.evatrx
				var cantatrasos = datosTablaDC1.cantatrasos
				var evaatrasos = datosTablaDC1.evaatrasos
				var cantfaltantes = datosTablaDC1.cantfaltantes
				var evafaltantes = datosTablaDC1.evafaltantes
				var cantrec = datosTablaDC1.cantrec
				var evarec = datosTablaDC1.evarec
				var evafinal = datosTablaDC1.evafinal		


				datosTabla += '<tr onclick="detallecajero('+rut+')">'				
				datosTabla += '<td>'+rut+'</td>';
				datosTabla += '<td>'+nombre+'</td>';
				datosTabla += '<td>'+sucursal+'</td>';
				datosTabla += '<td>'+tipo+'</td>';
				datosTabla += '<td>'+cantpagos+'</td>';
				datosTabla += '<td>'+prompagos+'</td>';
				datosTabla += '<td>'+evatrx+'</td>';
				datosTabla += '<td>'+cantatrasos+'</td>';
				datosTabla += '<td>'+evaatrasos+'</td>';
				datosTabla += '<td>'+cantfaltantes+'</td>';
				datosTabla += '<td>'+evafaltantes+'</td>';
				datosTabla += '<td>'+cantrec+'</td>';
				datosTabla += '<td>'+evarec+'</td>';
				if (evafinal ==="BUENO") {
					datosTabla += '<td style="background-color:#51a351">'+evafinal+'</td>';	
				}
				if (evafinal ==="NORMAL"){
					datosTabla += '<td style="background-color:#f89406">'+evafinal+'</td>';
				}
				if (evafinal ==="MALO"){
					datosTabla += '<td style="background-color:#bd362f">'+evafinal+'</td>';
				}	
				datosTabla += '</tr>';

			})
			$('#tablaDetalleEvaluacion > tbody').append(datosTabla);
			crearTablaDetalleEvaluacion();
			
		});

		
	}



	function crearTablaDetalleEvaluacion(){	

		$('#tablaDetalleEvaluacion').DataTable( {
			"language": {
	            "lengthMenu": "Mostrando _MENU_ reg. por página",
	            "zeroRecords": "Sin datos encontrados",
	            "info": "Mostrando página _PAGE_ de _PAGES_",
	            "infoEmpty": "Sin registros disponibles",
	            "infoFiltered": "(filtrado desde _MAX_ total de registros)"
        	 	},
	 		PaginationType: "bootstrap",
	 		//scrollX:        true,
	 		//scrollY:        "400px",
	        scrollCollapse: true,
	        paging:         true,	      
	        initComplete: function () {
	               // var div=$('#tablaCasos_wrapper');
	    			//div.find("#filtroEstadoReclamoPersonal").prepend("Filtro Estado:<select id='idEstadoReclamo' name='idEstadoReclamo' class='form-control' required style= 'width : 250px;'><option value=''>Todos</option></select>");

	    			$('#tablaDetalleEvaluacion_length').removeClass('tablaDetalleEvaluacion_length');



	    			var div=$('#tablaDetalleEvaluacion_length');
	    			div.append("&nbsp;<div class='btn-group' ><input id='btnDescargarArchExcel_DC1' class='btn btn-info' type='button' value='Excel'> <input id='btnDescargarArchPDF_DC1' class='btn btn-info' type='button' value='PDF'> <input id='btnDescargarArchPrint_DC1' class='btn btn-info' type='button' value='Print'></div>&nbsp;<i style='font-size: 12px' class='icon-comment' data-toggle='popover' title='Glosa' data-trigger='hover' data-content='Estos botones descargan lo visible en la tabla, si desea descargar todos</br> los datos debe seleccinar en paginas <b>Todos</b> y luego el boton a descargar'>Descargar</i> ");

	    			$('[data-toggle="popover"]').popover({
				    	 html:true
				    }); 
	    		}
	    } );	

	    $("#btnDescargarArchExcel_DC1").click(function (e) {
	    //getting values of current time for generating the file name
	    var dt = new Date();
	    var day = dt.getDate();
	    var month = dt.getMonth() + 1;
	    var year = dt.getFullYear();
	    var hour = dt.getHours();
	    var mins = dt.getMinutes();
	    var postfix = day + "." + month + "." + year + "_" + hour + "." + mins;
	    //creating a temporary HTML link element (they support setting file names)
	    var a = document.createElement('a');
	    //getting data from our div that contains the HTML table
	    var data_type = 'data:application/vnd.ms-excel;';
	    
	    var table_html = $('#tablaDetalleEvaluacion')[0].outerHTML;
	//    table_html = table_html.replace(/<div class="outer"[\s\S.]*class="dataTables_scroll">/gmi, '');
	 //   table_html = table_html.replace(/<div class="row-fluid"[\s\S.]*div>/gmi, '');
	//    console.log(table_html);
	//    table_html = table_html.replace(/ /g, '%20');
	//    table_html = table_html.replace(/<tfoot[\s\S.]*tfoot>/gmi, '');
	    
	    var css_html = '<style>td {border: 0.5pt solid #c0c0c0} .tRight { text-align:right} .tLeft { text-align:left} </style>';
	//    css_html = css_html.replace(/ /g, '%20');
	    
	    a.href = data_type + ',' + encodeURIComponent('<html><head>' + css_html + '</' + 'head><body>' + table_html + '</body></html>');
	    
	    //setting the file name
	    a.download = 'LISTA_evaluaciones_' + postfix + '.xls';
	    //triggering the function
	    a.click();
	    //just in case, prevent default behaviour
	    e.preventDefault();
	});


	$("#btnDescargarArchPrint_DC1").click(function (e) {
		console.log(1)
		var divToPrint=document.getElementById("tablaDetalleEvaluacion");
		newWin= window.open("");
		newWin.document.write(divToPrint.outerHTML);
		newWin.print();
		newWin.close();
	});

	$("#btnDescargarArchPDF_DC1").click(function (e) { 
		var dt = new Date();
		var day = dt.getDate();
	    var month = dt.getMonth() + 1;
	    var year = dt.getFullYear();
	    var hour = dt.getHours();
	    var mins = dt.getMinutes();
	    var postfix = day + "." + month + "." + year + "_" + hour + "." + mins;

	  	var doc = new jsPDF('landscape', 'pt','a4');

	  	var res = doc.autoTableHtmlToJson(document.getElementById("tablaDetalleEvaluacion"));
	 

  		var header = function(data) {
	    doc.setFontSize(8);
	    doc.setTextColor(20);
	    doc.setFontStyle('normal');
	    //doc.addImage(headerImgData, 'JPEG', data.settings.margin.left, 20, 50, 50);
	    doc.text("LISTA Evaluaciones", data.settings.margin.left, 20);
		  };
/*
	  var options = {
	    beforePageContent: header,
	    margin: {
	      top: 20
	    },
	    startY: doc.autoTableEndPosY() + 30
	  };
*/ 
	 // doc.autoTable(res.columns, res.data, options);
		doc.autoTable(res.columns, res.data, {margin: {top: 30}});
		doc.save('LISTA_evaluaciones_' + postfix + '.pdf');		
	}); 	
	};


	

</script>