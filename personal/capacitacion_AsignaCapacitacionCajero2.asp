<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
perfilUsuario = trim(request("perfilUsuario"))
rut = trim(request("rut"))
dv = trim(request("dv"))


'boxSucursales
sql = ""
sql = sql + "exec SCSS_prc_capa_get_box 3"
set rs = db.execute(sql)
if not rs.eof then
	datosSucursal = rs.getrows()
end if

'boxFormularios
sql1 = ""
sql1 = sql1 + "exec SCSS_prc_capa_get_box 4"
set rs1 = db.execute(sql1)
if not rs1.eof then
	datosFormularios = rs1.getrows()
end if

'boxTipoCapacitacion
sql2 = ""
sql2 = sql2 + "exec SCSS_prc_capa_get_box 5"
set rs2 = db.execute(sql2)
if not rs2.eof then
	datosTipoCapacitacion = rs2.getrows()
end if


GlosaAC1 = "Guarda capacitacion a sucursal asignada."
GlosaObligatorio = "Campo Obligatorio"
GlosaObligatorioFecha = "La fecha debe ser mayor o igual a la actual"
%>

<style>
	.slidecontainer {
	    width: 100%;
	}

	.slider {
	    -webkit-appearance: none;
	    width: 100%;
	    height: 15px;
	    border-radius: 5px;
	    background: #d3d3d3;
	    outline: none;
	    opacity: 0.7;
	    -webkit-transition: .2s;
	    transition: opacity .2s;
	}

	.slider:hover {
	    opacity: 1;
	}

	.slider::-webkit-slider-thumb {
	    -webkit-appearance: none;
	    appearance: none;
	    width: 25px;
	    height: 25px;
	    border-radius: 50%;
	    background: #4CAF50;
	    cursor: pointer;
	}

	.slider::-moz-range-thumb {
	    width: 25px;
	    height: 25px;
	    border-radius: 50%;
	    background: #4CAF50;
	    cursor: pointer;
	}
</style>
<form class="form-inline" role="form" id="formTablaAsignarFormulario" data-idUsuario="<%=idUsuario%>" data-perfilMain="<%=perfilMain%>" data-perfilUsuario="<%=perfilUsuario%>"  data-rut="<%=rut%>" data-dv="<%=dv%>">   
	<div>
		<legend >Asignar Formulario</legend>
	</div>
	<div>
		<table id="tableDatosAsignarFormulario" class="table table-bordered table-conde" style="background: #f2f2f2; border: 1px solid #cccccc" data-datosPersonal1="<%=datosPersonal1%>" data-datosPersonal2="<%=datosPersonal2%>" data-datosPersonal3="<%=datosPersonal3%>" data-datosPersonal4="<%=datosPersonal4%>">
			<tr >
				<td style="width: 150px;"><b>Formulario*</b></td>
				<td colspan="3">
					<select name="boxFormulario" id="cboFormularioAF" style="width: 60%">
						<option value="0">Seleccione Formulario</option>								
						<%for i = 0 to ubound(datosFormularios,2)
							datosFormularios1 = server.htmlencode(trim(datosFormularios(0,i)))
							datosFormularios2 = server.htmlencode(trim(datosFormularios(1,i)))%>
							<option value="<%=datosFormularios1%>"><%=datosFormularios2%></option>	
						<%next%> 			
					</select> 
					<span id="iconObligatorioFormulario_ACC2" class="oculto" data-toggle="popover" data-placement="bottom" data-trigger="hover" data-content="<%=GlosaObligatorio%>"><i class="icon-warning-sign" style="color:red;"></i></span>
				</td>
			</tr>
			
			<tr >
				<td style="width: 130px;"><b>Sucursal*</b></td>
				<td>
					<select name="boxTipo" id="cboSucursalAF" style="width: 90%">
						<option value="0">Asigne Sucursal*</option>		
						<%for i = 0 to ubound(datosSucursal,2)
							datosSucursal1 = server.htmlencode(trim(datosSucursal(0,i)))
							datosSucursal2 = server.htmlencode(trim(datosSucursal(1,i)))%>
							<option value="<%=datosSucursal1%>"><%=datosSucursal2%></option>	
						<%next%> 							
					</select>
					<span id="iconObligatorioSursal_ACC2" class="oculto" data-toggle="popover" data-placement="bottom" data-trigger="hover" data-content="<%=GlosaObligatorio%>"><i  class="icon-warning-sign" style="color:red;" ></i></span>
				</td>
				<td><b>Agendar Capacitación*</b></td>
				<td>
					<div id="divMensajeFecha"></div>
					<div class="controls">
						<div class="input-append date datetimepicker" id="dtpAF" data-placement="right" >
						    <input id="txtFechaAF" type="text" value="" readonly data-format="yyyy-MM-dd">
						    <span class="add-on" id="iconoFecha_ACC2"><i class="icon-th"  ></i></span>
						</div>						
					</div>
					<span id="iconObligatorioFA_ACC2" class="oculto" data-toggle="popover" data-placement="bottom" data-trigger="hover" data-content="<%=GlosaObligatorioFecha%>"><i  class="icon-warning-sign" style="color:red;" ></i></span>
				</td>	
			</tr>
			<tr >
				<td style="width: 130px;"><b>Tipo Capacitacion*</b></td>
				<td>
					<select name="boxTipo" id="cboTipoCapacitacionAF" style="width: 90%">
						<option value="0">Seleccione Tipo de Capacitación</option>						
						<%for i = 0 to ubound(datosTipoCapacitacion,2)
							datosTipoCapacitacion1 = server.htmlencode(trim(datosTipoCapacitacion(0,i)))
							datosTipoCapacitacion2 = server.htmlencode(trim(datosTipoCapacitacion(1,i)))%>
							<option value="<%=datosTipoCapacitacion1%>"><%=datosTipoCapacitacion2%></option>	
						<%next%> 								
					</select>
					<span id="iconObligatorioTC_ACC2" class="oculto" data-toggle="popover" data-placement="bottom" data-trigger="hover" data-content="<%=GlosaObligatorio%>"><i  class="icon-warning-sign" style="color:red;" ></i></span>
				</td>
				<td><b>SLA</b></td>
				<td>
					<div class="slidecontainer">
						<input type="range" min="1" max="5" value="1" class="slider" id="sliderSLAAF" style="width: 50%;"> Días: <b><span id="spanDiasSLAAF" ></span></b>
					</div>

				</td>	
			</tr>
			<tr >
				<td colspan="3" style="text-align: left;">
					<div id="msgAsignaCapacitacionCajero2"></div>
				</td>
				<td style="text-align: right; border-left: 0px;">
					<img id="gifCargandoAsignaCapacitacionCajero2" class="oculto" src="../img/loading2.gif"> <button type="button" class="btn btn-primary" id="btnAsignarAC" data-toggle="modal" data-target="#modalConfirmacion_ACC2">Asignar</button>
				</td>
			</tr>

		</table>	
	</div>		
	<div id="ConfirmaAsignacionFormulario" class="alert alert-warning text-center oculto">
		 <p><span id="txtConfirmacion_ACC2"></span></p>
	     <button type="button" id="btnEditaConfirmacion_ACC2" class="btn btn-default" data-toggle="popover" data-placement="left" title="Limpiar" data-trigger="hover" data-content="Editar datos antes de almacenar">Editar Datos</button>
	     <button type="button" id="btnConfirma_ACC2" class="btn btn-primary" data-toggle="popover" data-placement="right" title="Guardar" data-trigger="hover" data-content="<%=GlosaAC1%> ">Guardar Capacitación</button>
	</div>
	<div id="AsignaCapacitacionCajero2Error"></div>
	</br></br></br></br></br></br>
</form>

<script type="text/javascript">
	var slider = document.getElementById("sliderSLAAF");
	var output = document.getElementById("spanDiasSLAAF");
	var dia,mes, fechamin,fechapikeada;
	
	output.innerHTML = slider.value;

	slider.oninput = function() {
		output.innerHTML = this.value;
	}

	$(document).ready(function(){
	    $('[data-toggle="popover"]').popover({
	    	 html:true
	    });   
	});

	$(function(){
 		//console.log($('#cboFormularioAF option:selected').text());

		$('#btnAsignarAC').get(0).scrollIntoView(true); //esto permite mover el scroll para mostrar en pantalla el objeto.
		var f = new Date();	
		//console.log(f.getDate());
		if (f.getDate() < 10 ){
			dia = '0' + f.getDate()
		}else
		{
			dia =  f.getDate()
		}
		if ((f.getMonth()) < 10 ){
			mes = '0' + (f.getMonth() +1)
		}else{
			mes = (f.getMonth() +1)
		}


		fechamin = f.getFullYear() + "" + mes + "" + dia;
		//console.log(dia + "/" + mes + "/" + f.getFullYear());

		$('#txtFechaAF').val(f.getFullYear() + "-" + mes + "-" + dia);

		$("#dtpAF").datetimepicker({
        	pickTime: false  	
	    }).on('changeDate', function(ev){
	    	//console.log($('#txtFechaAF').val());
			//console.log(fechamin);
			fechapikeada = $('#txtFechaAF').val().replace("-","").replace("-","");
			//console.log(fechapikeada);
			if (fechapikeada < fechamin){
				$('#divMensajeFecha').html('<div class="alert alert-error text-rigth" id="msg" data-msg="2"><strong>Fecha no puede ser menor a la actual</strong></div>');
				$('#divMensajeFecha').show();
				setTimeout(function() {
					$('#divMensajeFecha').slideUp('fast');
					$('#divMensajeFecha').html('');
				}, 2000);
			}else{
				$(this).datetimepicker('hide');
			}
	    	
		}); 
	});




	$('#cboTipoCapacitacionAF').change(function() {
		if ($('#cboTipoCapacitacionAF').val() != 0){
			var opcion_seleccionada = $('#cboTipoCapacitacionAF option:selected').text();
			var textoFormateado = opcion_seleccionada.substring(0,8);
			textoFormateado = textoFormateado.replace('Días','').replace('(','').replace(')','').replace(' ','');
			var slider = document.getElementById("sliderSLAAF");
			var output = document.getElementById("spanDiasSLAAF");
			output.innerHTML = textoFormateado;
			slider.value = textoFormateado;
		}			
	});

	$('#btnAsignarAC').click(function(){
		$('#gifCargandoAsignaCapacitacionCajero2').removeClass('oculto');	
		var valida = true;
		var mensaje = 'Error </br>';

		var idUsuario= $('#formTablaAsignarFormulario').attr('data-idUsuario');
		var perfilMain= $('#formTablaAsignarFormulario').attr('data-perfilMain');
		var perfilUsuario= $('#formTablaAsignarFormulario').attr('data-perfilUsuario');
		var rut= $('#formTablaAsignarFormulario').attr('data-rut');
		var dv= $('#formTablaAsignarFormulario').attr('data-dv');
		var idformulario= $('select#cboFormularioAF option:selected').val();
		var idtipoCapacitacion= $('select#cboTipoCapacitacionAF option:selected').val();
		var slider = document.getElementById("sliderSLAAF");
		var cantDiasSLA= slider.value;
		var idsucusal= $('select#cboSucursalAF option:selected').val();
		var fechaAgendamiento= $('#txtFechaAF').val();

		$('#iconObligatorioFormulario_ACC2').addClass('oculto');
		$('#iconObligatorioTC_ACC2').addClass('oculto');
		$('#iconObligatorioSursal_ACC2').addClass('oculto');


		$("#cboFormularioAF").attr("disabled", true);
		$("#cboTipoCapacitacionAF").attr("disabled", true);
		$("#sliderSLAAF").attr("disabled", true);
		$("#cboSucursalAF").attr("disabled", true);	
		$("#iconoFecha_ACC2").attr("disabled", true);		


		if (idformulario == 0){			
			mensaje	= mensaje + '- Debe selecionar un Formuario a asignar.</br>';
			valida = false;	
			$('#iconObligatorioFormulario_ACC2').removeClass('oculto');
		}
		if (idtipoCapacitacion == 0){			
			mensaje	= mensaje + '- Debe selecionar un tipo de capacitación.</br>';
			valida = false;	
			$('#iconObligatorioTC_ACC2').removeClass('oculto');
		}
		if (idsucusal == 0){			
			mensaje	= mensaje + '- Debe seleccionar una sucursal a asignar.</br>';
			valida = false;	
			$('#iconObligatorioSursal_ACC2').removeClass('oculto');
		}		
		if (fechapikeada < fechamin){
			valida = false;
			mensaje = mensaje + '</br> - La Fecha no puede ser menor a la fecha actual.';
			$('#iconObligatorioFA_ACC2').removeClass('oculto');
		}

		if(valida == false){	
			$('#modalConfirmacion_ACC2').modal('hide');
			$('#gifCargandoAsignaCapacitacionCajero2').addClass('oculto');	
			$("#cboFormularioAF").attr("disabled", false);
			$("#cboTipoCapacitacionAF").attr("disabled", false);
			$("#sliderSLAAF").attr("disabled", false);
			$("#cboSucursalAF").attr("disabled", false);
			$("#iconoFecha_ACC2").attr("disabled", false);	

			$('#AsignaCapacitacionCajero2Error').html('<div class="alert alert-error text-rigth" id="msg" data-msg="2"><strong>'+mensaje+'</strong></div>');
			$('#AsignaCapacitacionCajero2Error').show();
			setTimeout(function() {
				$('#AsignaCapacitacionCajero2Error').slideUp('fast');
				$('#AsignaCapacitacionCajero2Error').html('');
			}, 3000);
		}else{
			
			var urlDatos ='capacitacion_AsignaCapacitacionCajero_datos.asp';
			var datosRespuesta = '';
			var mensaje = '';
			var tipoIngreso = 2;
			var tipoIngresoConsulta = 1;
			$.when($.ajax({url:urlDatos,data:{'tipoIngresoConsulta':tipoIngresoConsulta,'idUsuario':idUsuario, 'perfilMain':perfilMain,'perfilUsuario':perfilUsuario,'rut':rut, 'dv':dv,'tipoIngreso':tipoIngreso, 'idformulario':idformulario,'idtipoCapacitacion':idtipoCapacitacion,'idsucusal':idsucusal,'fechaAgendamiento':fechaAgendamiento,'cantDiasSLA':cantDiasSLA},method:'GET'})).then(function(datos) {
				$.each(datos.datosRespuestaAC2, function(key,valorRespuesta){
					mensaje = valorRespuesta.mensaje;
					datosRespuesta += '<p style="color:green;"><b>'+mensaje+'</b></p>';
				});

			//	$('#msgAsignaCapacitacionCajero1').html(datosRespuesta);
				$('#ConfirmaAsignacionFormulario').removeClass('oculto');

				$('#txtConfirmacion_ACC2').html(datosRespuesta);
			
				$('#gifCargandoAsignaCapacitacionCajero2').addClass('oculto');

				$('#ConfirmaAsignacionFormulario').get(0).scrollIntoView(true);

			});		
		}
	});

	$('#btnEditaConfirmacion_ACC2').click(function(){		
		$('#ConfirmaAsignacionFormulario').addClass('oculto');
		$("#cboFormularioAF").attr("disabled", false);
		$("#cboTipoCapacitacionAF").attr("disabled", false);
		$("#sliderSLAAF").attr("disabled", false);
		$("#cboSucursalAF").attr("disabled", false);			
		$("#iconoFecha_ACC2").attr("disabled", false);
	});

	$('#btnConfirma_ACC2').click(function(){
		$('#gifCargandoAsignaCapacitacionCajero2').removeClass('oculto');
		$('#ConfirmaAsignacionFormulario').addClass('oculto');
		var idUsuario= $('#formTablaAsignarFormulario').attr('data-idUsuario');
		var perfilMain= $('#formTablaAsignarFormulario').attr('data-perfilMain');
		var perfilUsuario= $('#formTablaAsignarFormulario').attr('data-perfilUsuario');
		var rut= $('#formTablaAsignarFormulario').attr('data-rut');
		var dv= $('#formTablaAsignarFormulario').attr('data-dv');
		var idformulario= $('select#cboFormularioAF option:selected').val();
		var idtipoCapacitacion= $('select#cboTipoCapacitacionAF option:selected').val();
		var slider = document.getElementById("sliderSLAAF");
		var cantDiasSLA= slider.value;
		var idsucusal= $('select#cboSucursalAF option:selected').val();
		var fechaAgendamiento= $('#txtFechaAF').val();

		var urlDatos ='capacitacion_AsignaCapacitacionCajero_datos.asp';
		var datosRespuesta = '';
		var mensaje = '';
		var tipoIngreso = 2;
		var tipoIngresoConsulta = 2;
		$.when($.ajax({url:urlDatos,data:{'tipoIngresoConsulta':tipoIngresoConsulta,'idUsuario':idUsuario, 'perfilMain':perfilMain,'perfilUsuario':perfilUsuario,'rut':rut, 'dv':dv,'tipoIngreso':tipoIngreso, 'idformulario':idformulario,'idtipoCapacitacion':idtipoCapacitacion,'idsucusal':idsucusal,'fechaAgendamiento':fechaAgendamiento,'cantDiasSLA':cantDiasSLA},method:'GET'})).then(function(datos) {
			$.each(datos.datosRespuestaAC2, function(key,valorRespuesta){
				mensaje = valorRespuesta.mensaje;
				datosRespuesta += '<p style="color:green;"><b>'+mensaje+'</b></p>';
			});

			$('#AsignaCapacitacionCajero1').html('');
			$('#AsignaCapacitacionCajero2').html('');	
			$('#btnLimpiarCapacitado').addClass('oculto');
			$('#btnBuscarCapacitado').removeClass('oculto');
			$("#txtRutCajero").attr("disabled", false);
			$("#txtDvCajero").attr("disabled", false);
			$("#txtRutCajero").val('');
			$("#txtDvCajero").val('');	
			$('#gifCargandoAsignaCapacitacionCajero2').addClass('oculto');

			$('#AsignaCapacitacionCajeroError').html('<div class="alert alert-success text-rigth" id="msg" data-msg="2"><strong>'+datosRespuesta+'</strong></div>');
			$('#AsignaCapacitacionCajeroError').show();
			setTimeout(function() {
				$('#AsignaCapacitacionCajeroError').slideUp('fast');
				$('#AsignaCapacitacionCajeroError').html('');
			}, 5000);
		})
	});
	

</script>