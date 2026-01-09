<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
periodo = trim(request("periodo"))
perfilUsuario = trim(request("perfilUsuario"))
idSucursal =  trim(request("idSucursal"))
vista = trim(request("vista"))


Glosa2 = "Ver"
GlosaEstado = "Habilitado: Formulario disponible. </br>Aceptado: Formulario con evaluador asignado.</br>En Proceso: Formulario con avances.</br>Esperando Aprovación: Formulario a espera de ser aprobado.</br> Cerrado: Capacitación terminada.</br> Anulado: Capacitacion anulada."
GlosaSLA = "<span class='label label-info'>EA</span> = Esperando Agendamiento </br><span class='label label-success'>DP</span> = Dentro Plazo </br><span class='label label-warning'>DP</span> = Ultimo dia para terminar capacitación </br><span class='label label-danger'>FP</span> = Fuera de Plazo </br>"

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
</style>
<form id="cuerpoTrabajoDetalleCapacitacion" data-idUsuario="<%=idUsuario%>" data-perfilMain="<%=perfilMain%>" data-perfilUsuario="<%=perfilUsuario%>" data-periodo="<%=periodo%>" data-idSucursal="<%=idSucursal%>" data-vista="<%=vista%>">
	<div class="row-fluid" id="tablaCasosFiltro" style="padding-top: 5px">
		<span >Estado</span> <select id='idEstadoDetalleCapacitacion' name='idEstadoDetalleCapacitacion' class='form-control' required style= 'width : 250px;' data-toggle="popover" data-placement="right" data-trigger="hover" data-content="<%=GlosaEstado%>">
			<option value=''>Todos</option>
		</select> <span>SLA</span> <select id="idSLADetalleCapacitacion" name="idSLADetalleCapacitacion" class="form-control" required style= "width : 250px;" data-toggle="popover" data-placement="right" data-trigger="hover" data-content="<%=GlosaSLA%>">
			<option value=''>Todos</option>
		</select>
	</div>
	<div id="filtrosDescargaDetalleCapacitacion"></div>
	</br>
	<div>
	 	<div style="overflow: auto;">
	 	 	<table id="tablaDetalleCapacitacion" style="border-collapse: collapse;" border="1px" class="table table-bordered table-hover1 no-footer dataTable cuerpoTabla stripe row-border order-column">
				<thead style="background-color: #e6e6ff">
					<tr>
						<th style="width: 80px"></th>
						<th>Rut</th>
						<th style="width: 300px">Nombre Practicante/Cajero</th>
						<th style="width: 250px">Fomulario Asignado</th>
						<th>Estado</th>
						<th style="width: 150px">Sucursal Asignada</th>
						<th style="width: 250px">Encargado Evaluar</th>
						<th style="width: 100px">Fecha Agendada</th>
						<th>Tipo Capacitación</th>
						<th >Resultado</th>
						<th style="width: 80px">Tiempo Sla</th>
						<th style="width: 80px">Est. Sla</th>						
						<th style="width: 100px">Fecha Ult.Modificación</th>
					</tr>
				</thead>
				<tbody>						
				</tbody>
			</table>
	 		</div>
	</div>
</form>

<script type="text/javascript">	

	$(document).ready(function(){
	    $('[data-toggle="popover"]').popover({
	    	 html:true
	    });   
		var datosTabla = "";
		var idUsuario= $('#cuerpoTrabajoDetalleCapacitacion').attr('data-idUsuario');
		var perfilMain= $('#cuerpoTrabajoDetalleCapacitacion').attr('data-perfilMain');
		var periodo = $('#cuerpoTrabajoDetalleCapacitacion').attr('data-periodo');
		var idSucursal = $('#cuerpoTrabajoDetalleCapacitacion').attr('data-idSucursal');
		var vista = $('#cuerpoTrabajoDetalleCapacitacion').attr('data-vista');
		//console.log(periodo);
		var perfilUsuario = $('#cuerpoTrabajoDetalleCapacitacion').attr('data-perfilUsuario');
		if (vista == 1){
     		var urlDatos = 'capacitacion_DetalleCapacitacion_datos.asp';
     	}else{
     		var urlDatos = './personal/capacitacion_DetalleCapacitacion_datos.asp';
     	} 
		var tipoVista = "2";
		if (vista == 1){
			tipoVista = "1";
		}else{			
			tipoVista = "6";
		}
		//console.log(idSucursal);
		$.ajax({url:urlDatos,data:{'idUsuario':idUsuario,'perfilMain':perfilMain,'perfilUsuario':perfilUsuario,'periodo':periodo,'tipoVista':tipoVista,'idSucursal':idSucursal},method:'GET'}).then(function(datos) {
			$.each(datos.datosTablaDC1, function(key,datosTablaDC1){
				var id_asignacion = datosTablaDC1.id_asignacion
				var id_personal = datosTablaDC1.id_personal
				var nombrePersona = datosTablaDC1.nombrePersona
				var nombreFormulario = datosTablaDC1.nombreFormulario
				var estado = datosTablaDC1.estado
				var idestado = datosTablaDC1.idestado
				var suc_nombre = datosTablaDC1.suc_nombre
				var usuario_evaluacion = datosTablaDC1.usuario_evaluacion
				var fecha_agendada = datosTablaDC1.fecha_agendada
				var tipoCap = datosTablaDC1.tipoCap
				var dias_diff = datosTablaDC1.dias_diff
				var fecha_termino = datosTablaDC1.fecha_termino
				var ult_modificacion = datosTablaDC1.ult_modificacion
				var fecha_ingreso = datosTablaDC1.fecha_ingreso	
				var nota = datosTablaDC1.nota	
				var resultado_nota = datosTablaDC1.resultado_nota	
				var estado_sla = datosTablaDC1.estado_sla			
				var dias_cap = datosTablaDC1.dias_cap			

				datosTabla += '<tr>'
				datosTabla += '<td>'+agregaBtnesDetalleCapacitacion(id_asignacion,idestado)+'</td>';
				datosTabla += '<td>'+id_personal+'</td>';
				datosTabla += '<td>'+nombrePersona+'</td>';
				datosTabla += '<td>'+nombreFormulario+'</td>';
				datosTabla += '<td>'+estado+'</td>';
				datosTabla += '<td>'+suc_nombre+'</td>';
				datosTabla += '<td>'+usuario_evaluacion+'</td>';
				datosTabla += '<td>'+fecha_agendada+'</td>';
				datosTabla += '<td>'+tipoCap+'</td>';
				if (nota == 0){
				//	datosTabla += '<td><span class="label label-default">0</span></td>';
					datosTabla += '<td><span class="label label-default">Sin Evaluar</span></td>';
				}else{
				//	datosTabla += '<td><span class="label label-default">'+nota+'</span></td>';
					if (resultado_nota == 'Aprobado'){
						datosTabla += '<td><span class="label label-success">'+resultado_nota+'</span></td>';
					}else{
						datosTabla += '<td><span class="label label-warning">'+resultado_nota+'</span></td>';
					}
				}
				datosTabla += '<td>'+dias_diff+' Días</td>';
					if (dias_cap > dias_diff){
						if (estado_sla == 'EA'){
							datosTabla += '<td><span class="label label-info">'+estado_sla+'</span></td>';
						}else{
							datosTabla += '<td><span class="label label-success">'+estado_sla+'</span></td>';
						}
					}
					if (dias_cap < dias_diff){
						datosTabla += '<td><span class="label label-danger">'+estado_sla+'</span></td>';
					}
					if (dias_cap == dias_diff){
						datosTabla += '<td><span class="label label-warning">'+estado_sla+'</span></td>';
					}
			//	datosTabla += '<td>'+fecha_termino+'</td>';
				datosTabla += '<td>'+ult_modificacion+'</td>';
				//datosTabla += '<td>'+fecha_ingreso+'</td>';
				datosTabla += '</tr>';	

			})
			$('#tablaDetalleCapacitacion > tbody').append(datosTabla);
				
			crearTablaDetalleCapaciotaciones();
		});
	
	});	

	function crearTablaDetalleCapaciotaciones(){	

		$('#tablaDetalleCapacitacion').DataTable( {
	 		PaginationType: "bootstrap",
	 		//scrollX:        true,
	 		//scrollY:        "400px",
	        scrollCollapse: true,
	        paging:         true,
	       // fixedColumns: {
	         //   leftColumns: 3,
	     //       rightColumns: 1,
	        //},	   					     
	        initComplete: function () {
	               // var div=$('#tablaCasos_wrapper');
	    			//div.find("#filtroEstadoReclamoPersonal").prepend("Filtro Estado:<select id='idEstadoReclamo' name='idEstadoReclamo' class='form-control' required style= 'width : 250px;'><option value=''>Todos</option></select>");

	    			$('#tablaDetalleCapacitacion_length').removeClass('tablaDetalleCapacitacion_length');



	    			var div=$('#tablaDetalleCapacitacion_length');
	    			div.append("&nbsp;<div class='btn-group' ><input id='btnDescargarArchExcel_DC1' class='btn btn-info' type='button' value='Excel'> <input id='btnDescargarArchPDF_DC1' class='btn btn-info' type='button' value='PDF'> <input id='btnDescargarArchPrint_DC1' class='btn btn-info' type='button' value='Print'></div>&nbsp;<i style='font-size: 12px' class='icon-comment' data-toggle='popover' title='Glosa' data-trigger='hover' data-content='Estos botones descargan lo visible en la tabla, si desea descargar todos</br> los datos debe seleccinar en paginas <b>Todos</b> y luego el boton a descargar'>Descargar</i> ");

	    			$('[data-toggle="popover"]').popover({
				    	 html:true
				    }); 
	    			
					this.api().column(11).each(function () {
		                var column = this;
		                var select = $('#idSLADetalleCapacitacion')
		                //console.log(column.data());
		                
		                column.data().unique().sort().each(function (d, j) {
		                	//if (filtroSla == d){
							//	select.append('<option value="' + d + '" selected>' + d + '</option>')
							//	column.search( d ? '^'+d+'$' : '', true, false )
		                    //        .draw();
		                //	}else{   
	                    	select.append('<option >'+d+'</option>')
		                //	}

	                	});

		                $('#idSLADetalleCapacitacion').on('change',function(){
		                var val=$(this).val();
		                column.search( val ? '^'+val+'$' : '', true, false )
		                            .draw();
	                	});
		               
	            	});

	    			this.api().column(4).each(function () {
		                var column = this;
		                var select = $('#idEstadoDetalleCapacitacion')
		                //console.log(column.data());

		                column.data().unique().sort().each(function (d, j) {
	                    	select.append('<option value="' + d + '">' + d + '</option>')
	                	});

		                $('#idEstadoDetalleCapacitacion').on('change',function(){
		                var val=$(this).val();
		                column.search( val ? '^'+val+'$' : '', true, false )
		                            .draw();
	                	});		               
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
	    var data_type = 'data:application/vnd.ms-excel;charset=utf-8';
	    
	    var table_html = $('#tablaDetalleCapacitacion')[0].outerHTML;
	   // table_html = table_html.replace(/ /g, '%20');
	    table_html = table_html.replace(/<tfoot[\s\S.]*tfoot>/gmi, '');

	    var css_html = '<style>td {border: 0.5pt solid #c0c0c0} .tRight { text-align:right} .tLeft { text-align:left} </style>';
	   // css_html = css_html.replace(/ /g, '%20');
	    
	    a.href = data_type + ',' + encodeURIComponent('<html><head>' + css_html + '</' + 'head><body>' + table_html + '</body></html>');
	    //console.log(data_type + ',' + encodeURIComponent('<html><head>' + css_html + '</' + 'head><body>' + table_html + '</body></html>'));
	    
	    //setting the file name
	    a.download = 'LISTA_Capacitaciones_' + postfix + '.xls';
	    //triggering the function
	    a.click();
	    //just in case, prevent default behaviour
	    e.preventDefault();
	});


	$("#btnDescargarArchPrint_DC1").click(function (e) {
		console.log(1)
		var divToPrint=document.getElementById("tablaDetalleCapacitacion");
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

	  	var res = doc.autoTableHtmlToJson(document.getElementById("tablaDetalleCapacitacion"));
	 	//console.log(res);

  		var header = function(data) {
	    doc.setFontSize(8);
	    doc.setTextColor(20);
	    doc.setFontStyle('normal');
	    //doc.addImage(headerImgData, 'JPEG', data.settings.margin.left, 20, 50, 50);
	    doc.text("LISTA Capacitaciones", data.settings.margin.left, 20);
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
		doc.autoTable(res.columns, res.data, {margin: {top: 20}});
		doc.save('LISTA_Capacitaciones_' + postfix + '.pdf');		
	}); 	
	};


	function btnVerDetalleEvaluacion(idAsignacion){
		var idUsuario= $('#cuerpoTrabajoDetalleCapacitacion').attr('data-idUsuario');
		var perfilMain= $('#cuerpoTrabajoDetalleCapacitacion').attr('data-perfilMain');
		var perfilUsuario= $('#cuerpoTrabajoDetalleCapacitacion').attr('data-perfilUsuario');
		var vista= $('#cuerpoTrabajoDetalleCapacitacion').attr('data-vista');
		if (vista == 1){
     		var urlDatos = 'capacitacion_DetalleCapacitacion2.asp';
     	}else{
     		var urlDatos = './personal/capacitacion_DetalleCapacitacion2.asp';
     	} 
     	var div = 'cuerpoTrabajoDetalleCapacitacion2';
		var datos = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&perfilUsuario='+perfilUsuario+'&idAsignacion='+idAsignacion+'&vista='+vista
		
		enviaDatos(urlDatos,div,datos);
		if (vista == 1) {
			$('#cuerpoTrabajoDetalleCapacitacion1').addClass('oculto');
			$('#divcboPeriodoDetalleCapacitacion').addClass('oculto');	
			$('#divbtnVolverDetalleCapacitacion').removeClass('oculto');
		}else{
			$('#cuerpoTrabajoDetalleCapacitacion1').html('');
			$('#divcboPeriodoDetalleCapacitacion').addClass('oculto');	
			$('#divbtnVolverDetalleCapacitacion').removeClass('oculto');
		}
		
	}

	function agregaBtnesDetalleCapacitacion(id_asignacion,idEstado){
		var btnDetalleAsignaciones = '';
		if(idEstado == 1 || idEstado == 3 || idEstado == 4 || idEstado == 5 || idEstado == 6 || idEstado == 7){			
			btnDetalleAsignaciones += '<i class="mano icon-eye-open icon-2x" id="btnVerDetalleEvaluacion'+id_asignacion+'" onClick="btnVerDetalleEvaluacion('+id_asignacion+')" data-toggle="popover" data-placement="bottom" data-trigger="hover" data-content="<%=Glosa2%>"></i>';
		}else{					
			btnDetalleAsignaciones += ' --- ';
		}
		return btnDetalleAsignaciones;
	};
	
	

</script>