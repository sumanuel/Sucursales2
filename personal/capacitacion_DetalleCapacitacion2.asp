<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
idAsignacion = trim(request("idAsignacion"))
perfilUsuario = trim(request("perfilUsuario"))
vista = trim(request("vista"))

sql = ""
sql = sql + "exec SCSS_prc_capa_get_detalle_formulario_evaluacion " + idAsignacion + " "


tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
	datosFomulario = rs.getrows()
	tieneDatos = 1
end if
if tieneDatos = 1 then
	for i = 0 to ubound(datosFomulario,2)
	   	id_asignacion = trim(datosFomulario(0,i))
		id_personal	= trim(datosFomulario(1,i))
		nombrePersona = trim(datosFomulario(2,i))
		id_formulario = trim(datosFomulario(3,i))
		nombre_formulario = trim(datosFomulario(4,i))
		id_estado = trim(datosFomulario(5,i))
		estado = trim(datosFomulario(6,i))
		id_sucursal_asig = trim(datosFomulario(7,i))
		suc_nombre = trim(datosFomulario(8,i))
		Usuario_Evaluacion = trim(datosFomulario(9,i))
		fecha_agendada = trim(datosFomulario(10,i))
		TipoCap	= trim(datosFomulario(11,i))
		dias_diff = trim(datosFomulario(12,i))
		fecha_termino = trim(datosFomulario(13,i))
		Ult_Modificacion = trim(datosFomulario(14,i))
		fecha_ingreso = trim(datosFomulario(15,i))
		nombres_usuario_ingresa	= trim(datosFomulario(16,i))
		nota = trim(datosFomulario(17,i))
		obs_final = trim(datosFomulario(18,i))
		dv = trim(datosFomulario(19,i))
		resultado_nota = trim(datosFomulario(20,i))
		estado_sla = trim(datosFomulario(21,i))
		dias_cap = trim(datosFomulario(22,i))
	next
else				
    id_asignacion	= "---"
	id_personal	= "---"
	nombrePersona	= "---"
	id_formulario	= "---"
	nombre_formulario	= "---"
	id_estado	= "---"
	estado	= "---"
	id_sucursal_asig	= "---"
	suc_nombre	= "---"
	Usuario_Evaluacion	= "---"
	fecha_agendada	= "---"
	TipoCap	= "---"
	dias_diff	= "---"
	fecha_termino	= "---"
	Ult_Modificacion	= "---"
	fecha_ingreso	= "---"
	nombres_usuario_ingresa	= "---"
	nota	= "---"
	obs_final	= "---"
	dv	= "---"
	resultado_nota = "---"
	estado_sla = "---"
	dias_cap = "---"
end if	

Glosa1 = "Anulara el formulario y esta asignacion quedara guardada sin uso (No afectara a futuras calificaciones). </br> Para poder anular solicita de forma obligatoria una observación."
Glosa2 = ""

%>
<form id="formTablaIngresoCapacitacion2" data-idUsuario="<%=idUsuario%>" data-perfilMain="<%=perfilMain%>" data-perfilUsuario="<%=perfilUsuario%>" data-idAsignacion="<%=idAsignacion%>" data-id_estado="<%=id_estado%>" data-vista="<%=vista%>">

	<div style="width: 80%; margin: 0 auto;">
		<table class="table table-bordered table-conde" style="background: #f2f2f2; border: 1px solid #cccccc">
			<tr >
				<td ><b>Formulario</b></td>
				<td colspan="3">	
					<b><%=id_formulario%> - <%=server.htmlencode(nombre_formulario)%></b>
				</td>				
			</tr>
			<tr >
				<td ><b>Rut</b></td>
				<td >	
					<%=id_personal%>-<%=dv%>
				</td>
				<td><b>Nombre Persona</b></td>
				<td >	
					<%=server.htmlencode(nombrePersona)%>
				</td>
			</tr>
			<tr >
				<td ><b>Sucursal</b></td>
				<td >	
					(<%=id_sucursal_asig%>) <%=server.htmlencode(suc_nombre)%>
				</td>
				<td><b>Ingresado por</b></td>
				<td >	
					<%=server.htmlencode(nombres_usuario_ingresa)%>
				</td>
			</tr>				
			<tr><td><b>Encargado de Evaluar</b></td>
				<td colspan="3" style="color: red;">	
					<%=server.htmlencode(Usuario_Evaluacion)%>
				</td>				
			</tr>
		</table>
		<table class="table table-bordered table-conde" style="background: #f2f2f2; border: 1px solid #cccccc">
			<tr>
				<td><b>Fecha Agendada</b></td>
				<td>	
					<%=fecha_agendada%>
				</td>
				<td><b>F. Ultima Modificación</b></td>
				<td >	
					<%=Ult_Modificacion%>
				</td>
			</tr>
			<tr>
				<td><b>Tiempo Sla</b></td>
				<td>	
					<%=dias_diff%> <%if dias_diff = 1 then %> Día <% else %> Días <% end if%> <%=estado_sla%>
				</td>
				<td><b>Nota Capacitación</b></td>
				<td>				
					<% if resultado_nota = "Aprobado" then %>		
						<div><span class="label label-default"><%=nota%></span> <span class="label label-success"><%=resultado_nota%></span></div>
					<% end if 
					if resultado_nota = "Reprobado" then %>	
						<div><span class="label label-default"><%=nota%></span> <span class="label label-warning"><%=resultado_nota%></span></div>
					<% end if %>
				</td>
			</tr>
			<tr>
				<td><b>% Avance Ult. Modificación</b></td>
				<td >	
					<div id="divAvanceCapacitacion"><span id="spanCantAvance" class="label label-success"></span></div>
				</td>
				<td><b>Estado Capacitación</b></td>
				<td>	
					<%=server.htmlencode(estado)%>
				</td>				
			</tr>
			<tr>
				<td colspan="4">
					<b>Observación:</b>
					<div class="controls">
						<% if ((vista = 1) and (id_estado = 1 or id_estado = 3)) then %>
							<textarea class="span12" rows="3" id="txtObsCapacitacion" onkeypress="return soloLetrasyNumeros(event);" name="txtObsCapacitacion" placeholder="Ingrese una observación" maxlength="200" ><%=obs_final%></textarea>
						<% else 
							if ((perfilUsuario = 1) and (id_estado = 1 or id_estado = 3 or id_estado = 4)) then %>
								<textarea class="span12" rows="3" id="txtObsCapacitacion" onkeypress="return soloLetrasyNumeros(event);" name="txtObsCapacitacion" placeholder="Ingrese una observación" maxlength="200" ><%=obs_final%></textarea>
							<% else %>
								<textarea class="span12" disabled rows="3" id="txtObsCapacitacion" onkeypress="return soloLetrasyNumeros(event);" name="txtObsCapacitacion" placeholder="Ingrese una observación" maxlength="200" ><%=obs_final%></textarea>
							<% end if %>
						<% end if %>
					</div>
				</td>
			</tr>
			<% if ((vista = 1) and (id_estado = 1 or id_estado = 3)) then %>
				<tr >
					<td colspan="4">
						<button type="button" id="btnAnularFormularioCapacitacion" class="btn btn-danger" data-toggle="popover" data-placement="right" data-trigger="hover" data-content="<%=Glosa1%>">Anular</button>
						<img id="gifCargandoAnulaCapacitacion" class="oculto" src="../img/loading2.gif">
						<div id="msgErrorAnulaFormulario"></div>
					</td>				
				</tr>
			<% end if %>
		</table>
		<table class="table table-bordered table-conde" style="background: #f2f2f2; border: 1px solid #cccccc">			
			<tr style="border-bottom: 0px">
				<td><b>Preguntas</b>				
			</tr>
			<tr >
				<td ><div class="text-center" style="height: 500px; overflow-y: auto;">
					<table id="tablaRespuestasCapacitacion" class="table table-bordered table-conde" style="background: #ffffff; border: 1px solid #cccccc;">
						<tbody >							
						</tbody>
					</table>
				</div></td>				
			</tr>
			<tr>
				<td>
					<% if ((vista = 2 and  perfilUsuario = 1) and (id_estado = 5)) then %>
						<button type="button" class="btn btn-danger" data-toggle="popover" data-placement="right" data-trigger="hover" disabled data-content="Esperando Aprobación de personal de Cajeros.">Esperando Aprobación</button>
					<% end if %>
					<% if ((vista = 2 and  perfilUsuario = 1) and (id_estado = 1 or id_estado = 3 or id_estado = 4)) then %>
						<button type="button" id="btnGuardarCambiosFormularioCapacitacion" class="btn btn-danger" data-toggle="popover" data-placement="right" data-trigger="hover" data-content="Guardar cambios para continuar mas tarde">Guardar Cambios</button>
						<button type="button" id="btnFinalizaFormularioCapacitacion" class="btn btn-danger" data-toggle="popover" data-placement="right" data-trigger="hover" data-content="Una vez terminada todas las preguntas podra Enviar la capacitacion a personal de cajero para su validación.">Finalizar Capacitación</button>
					<% end if %>
					<% if (vista = 1 and id_estado = 5) then %>
						<button type="button" id="btnValidaFormularioCapacitacion" class="btn btn-danger" data-toggle="popover" data-placement="right" data-trigger="hover" data-content="Con este paso usted valida que la capacitacion se realizo y pasa a estado <b>cerrado.</b>">Validar</button>
					<% end if %>
					<% if vista = 1 then %>
						<img id="gifCargandoFinalizaCapacitacion" class="oculto" src="../img/loading2.gif">
					<% else %>
						<img id="gifCargandoFinalizaCapacitacion" class="oculto" src="./img/loading2.gif">
					<% end if %>
					<div id="msgErrorTerminoFormulario"></div>
				</td>
			</tr>
		</table>
	</div>
</form>

<% if vista = 1 then %>
	<script type="text/javascript" src="../js/personal/valida_campos.js"></script>
<% else %>
	<script type="text/javascript" src="./js/personal/valida_campos.js"></script>
<% end if %>

<script type="text/javascript">
	var lista_idPreguntas = [];
	var lista_Respuestas = [];
	var cantPreguntasSinResponder = 0;
	var cantRespuestas = 0;
	var porcentajeAvance = 0;
	var notaFinal = 0;

	$(document).ready(function(){
	    $('[data-toggle="popover"]').popover({
	    	 html:true
	    });   		
	});

	$(function(){
		var idAsignacion = $('#formTablaIngresoCapacitacion2').attr('data-idAsignacion');
		var perfilUsuario= $('#formTablaIngresoCapacitacion2').attr('data-perfilUsuario');
		var estadoFormulario= $('#formTablaIngresoCapacitacion2').attr('data-id_estado');
		var vista= $('#formTablaIngresoCapacitacion2').attr('data-vista');
		
	   	obtenerPreguntasFormularioCapacitacion();

		if (vista == 2 && estadoFormulario == 1){
			if (perfilUsuario == 1){				
				modEstadoCapacitacion(idAsignacion,3,2);
			}
		}
	});

	
	$("#btnFinalizaFormularioCapacitacion").click(function (e) {
		var idAsignacion = $('#formTablaIngresoCapacitacion2').attr('data-idAsignacion');
    	var valida = true;
		var mensaje = ''
		var cant1 = 0;
		var cant2 = 0;
		var cant3 = 0;
		$('#gifCargandoFinalizaCapacitacion').removeClass('oculto');
    	for (var x=0; x<lista_idPreguntas.length; x++){
    		if($('#rdop1'+lista_idPreguntas[x]).is(":checked")===true)
			{
				lista_Respuestas[x] = 1;
				cant1 = cant1 + 1;
			}
			if($('#rdop2'+lista_idPreguntas[x]).is(":checked")===true)
			{
				lista_Respuestas[x] = 2;
				cant2 = cant2 + 1;
			};
			if($('#rdop3'+lista_idPreguntas[x]).is(":checked")===true)
			{
				lista_Respuestas[x] = 3;
				cant3 = cant3 + 1;
			};

			if (lista_Respuestas[x] > 0){
				cantRespuestas = cantRespuestas + 1;
				cantPreguntasSinResponder = cantPreguntasSinResponder - 1;

				guardarRespuestaCapacitacion(idAsignacion,lista_idPreguntas[x],lista_Respuestas[x]);

    			//console.log('id_Pregunta: '+ lista_idPreguntas[x] + ' | respuesta: ' + lista_Respuestas[x])
			}else{
				valida = false;
				mensaje = '- Faltan preguntas por responder. </br>'
			}			    		
    	}   

    	

		if ($('#txtObsCapacitacion').val() == ''){
			valida = false;
			mensaje += '- Debe ingresar una observación sobre el capacitado para poder finalizar y enviar a validar.'
		}

    	if (valida == true){
    		porcentajeAvance = ((cantRespuestas / (cantRespuestas + cantPreguntasSinResponder)) * 100);

	    	if (porcentajeAvance < 10){
				$('#spanCantAvance').html(' '+porcentajeAvance.toString().substring(0, 4)+'% ');
			}else{
				$('#spanCantAvance').html(' '+porcentajeAvance.toString().substring(0, 5)+'% ');
			}

			notaFinal = (cant1 / (cant2 + cant1));	 

    		modEstadoCapacitacion(idAsignacion,5,4);
			$('#gifCargandoFinalizaCapacitacion').addClass('oculto');
    	}else{
    		$('#msgErrorTerminoFormulario').html('<div class="alert alert-error text-rigth" id="msg" data-msg="2"><strong>'+mensaje+'</strong></div>');
			$('#msgErrorTerminoFormulario').show();
			setTimeout(function() {
				$('#msgErrorTerminoFormulario').slideUp('fast');
				$('#msgErrorTerminoFormulario').html('');
				$('#gifCargandoFinalizaCapacitacion').addClass('oculto');
			}, 3000);
    	}
    	
    });

	$("#btnGuardarCambiosFormularioCapacitacion").click(function (e) {
		var idAsignacion = $('#formTablaIngresoCapacitacion2').attr('data-idAsignacion');
		$('#gifCargandoFinalizaCapacitacion').removeClass('oculto');
    	for (var x=0; x<lista_idPreguntas.length; x++){

    		if($('#rdop1'+lista_idPreguntas[x]).is(":checked")===true)
			{
				lista_Respuestas[x] = 1;
			}
			if($('#rdop2'+lista_idPreguntas[x]).is(":checked")===true)
			{
				lista_Respuestas[x] = 2;
			};
			if($('#rdop3'+lista_idPreguntas[x]).is(":checked")===true)
			{
				lista_Respuestas[x] = 3;
			};

			if (lista_Respuestas[x] > 0){
				cantRespuestas = cantRespuestas + 1;
				cantPreguntasSinResponder = cantPreguntasSinResponder - 1;

				guardarRespuestaCapacitacion(idAsignacion,lista_idPreguntas[x],lista_Respuestas[x]);

    			//console.log('id_Pregunta: '+ lista_idPreguntas[x] + ' | respuesta: ' + lista_Respuestas[x])
			}

			porcentajeAvance = ((cantRespuestas / (cantRespuestas + cantPreguntasSinResponder)) * 100);

			if (porcentajeAvance < 10){
				$('#spanCantAvance').html(' '+porcentajeAvance.toString().substring(0, 4)+'% ');
			}else{
				$('#spanCantAvance').html(' '+porcentajeAvance.toString().substring(0, 5)+'% ');
			}	
    		
    	}    	
    	modEstadoCapacitacion(idAsignacion,4,3);
		$('#gifCargandoFinalizaCapacitacion').addClass('oculto');
    });

    $("#btnValidaFormularioCapacitacion").click(function (e) {
		var idAsignacion = $('#formTablaIngresoCapacitacion2').attr('data-idAsignacion');

		$('#gifCargandoFinalizaCapacitacion').removeClass('oculto');
    	modEstadoCapacitacion(idAsignacion,6,1);
    });

    $("#btnAnularFormularioCapacitacion").click(function (e) {    	
		var idAsignacion = $('#formTablaIngresoCapacitacion2').attr('data-idAsignacion');
		var idUsuario= $('#formTablaIngresoCapacitacion2').attr('data-idUsuario');
		var perfilMain= $('#formTablaIngresoCapacitacion2').attr('data-perfilMain');
		var perfilUsuario= $('#formTablaIngresoCapacitacion2').attr('data-perfilUsuario');
		var vista= $('#formTablaIngresoCapacitacion2').attr('data-vista');

		var valida = true;
		var mensaje = ''
		if ($('#txtObsCapacitacion').val() == ''){
			valida = false;
			mensaje = 'Debe ingresar una observación breve para anular.'
		}

		//msgErrorAnulaFormulario

		if (valida == true){
			modEstadoCapacitacion(idAsignacion,7,3);
			$('#cuerpoTrabajoDetalleCapacitacion2').html('');
	     	
	     	var urlDatos1 = 'capacitacion_DetalleCapacitacion2.asp';	     	
			var div1 = 'cuerpoTrabajoDetalleCapacitacion2';
			var datos1 = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&perfilUsuario='+perfilUsuario+'&idAsignacion='+idAsignacion+'&vista='+vista;
			enviaDatos(urlDatos1,div1,datos1);
		}else{
			$('#msgErrorAnulaFormulario').html('<div class="alert alert-error text-rigth" id="msg" data-msg="2"><strong>'+mensaje+'</strong></div>');
			$('#msgErrorAnulaFormulario').show();
			setTimeout(function() {
				$('#msgErrorAnulaFormulario').slideUp('fast');
				$('#msgErrorAnulaFormulario').html('');
			}, 3000);
		}
		
    });


	function obtenerPreguntasFormularioCapacitacion(){
		var idAsignacion = $('#formTablaIngresoCapacitacion2').attr('data-idAsignacion');
		var idUsuario= $('#formTablaIngresoCapacitacion2').attr('data-idUsuario');
		var perfilMain= $('#formTablaIngresoCapacitacion2').attr('data-perfilMain');
		var perfilUsuario= $('#formTablaIngresoCapacitacion2').attr('data-perfilUsuario');
		var estadoFormulario= $('#formTablaIngresoCapacitacion2').attr('data-id_estado');
		var vista= $('#formTablaIngresoCapacitacion2').attr('data-vista');
		if (vista == 1){
     		var urlDatos = 'capacitacion_DetalleCapacitacion_datos.asp';
     	}else{
     		var urlDatos = './personal/capacitacion_DetalleCapacitacion_datos.asp';
     	} 
		var datosTabla = '';
		var tipoVista = 2;
		var categoriaAnterior = 0;
		var i = 0;

		$.ajax({url:urlDatos,data:{'idUsuario':idUsuario,'perfilMain':perfilMain,'perfilUsuario':perfilUsuario,'idAsignacion':idAsignacion,'tipoVista':tipoVista},method:'GET'}).then(function(datos) {
			$.each(datos.datosTablaDC2, function(key,datosTablaDC2){
				var id_respuesta = datosTablaDC2.id_respuesta
				var orden_categoria = datosTablaDC2.orden_categoria
				var categoria = datosTablaDC2.categoria
				var orden_pegunta = datosTablaDC2.orden_pegunta
				var pregunta = datosTablaDC2.pregunta
				var respuesta = datosTablaDC2.respuesta
				lista_idPreguntas[i] = id_respuesta;
				lista_Respuestas[i] = respuesta;

				if (orden_categoria != categoriaAnterior){
					datosTabla += '<tr style="background: #f2f2f2;">'
					datosTabla += '<td><div class="text-center"><b>'+orden_categoria+' - '+categoria+'</b></div></td>';
					datosTabla += '</tr>';
					categoriaAnterior = orden_categoria;
				}

				datosTabla += '<tr>'
				datosTabla += '<td><div>'+orden_categoria+'.'+orden_pegunta+' - '+pregunta+'</div>'+agregarRadioButtons(id_respuesta,respuesta,perfilUsuario,estadoFormulario)+'</td>';
				datosTabla += '</tr>';

				if (respuesta == 0){
					cantPreguntasSinResponder = cantPreguntasSinResponder + 1;
				}else{
					cantRespuestas = cantRespuestas + 1;
				}

				i = i + 1;
			})
			$('#tablaRespuestasCapacitacion > tbody').append(datosTabla);		

			porcentajeAvance = ((cantRespuestas / (cantRespuestas + cantPreguntasSinResponder)) * 100);
			if (porcentajeAvance < 10){
				$('#spanCantAvance').html(' '+porcentajeAvance.toString().substring(0, 4)+'% ');
			}else{
				$('#spanCantAvance').html(' '+porcentajeAvance.toString().substring(0, 5)+'% ');
			}
					
		});
	}

	function modEstadoCapacitacion(idAsignacion,id_estado,tipoMod){
		var tipoVista = 0;
		var adicional1= '';
		if (tipoMod == 1){
			var idUsuario= $('#formTablaIngresoCapacitacion2').attr('data-idUsuario');
			var perfilMain= $('#formTablaIngresoCapacitacion2').attr('data-perfilMain');
			var perfilUsuario= $('#formTablaIngresoCapacitacion2').attr('data-perfilUsuario');
			var vista= $('#formTablaIngresoCapacitacion2').attr('data-vista');
			if (vista == 1){
	     		var urlDatos = 'capacitacion_DetalleCapacitacion_datos.asp';
	     	}else{
	     		var urlDatos = './personal/capacitacion_DetalleCapacitacion_datos.asp';
	     	} 
			tipoVista = 3;
			$.ajax({url:urlDatos,data:{'idUsuario':idUsuario,'perfilMain':perfilMain,'perfilUsuario':perfilUsuario,'idAsignacion':idAsignacion,'tipoVista':tipoVista,'id_estado':id_estado,'tipoMod':tipoMod,'adicional1':adicional1},method:'GET'}).then(function(datos) {
				$.each(datos.datosMensajeModEstado, function(key,datosMensajeModEstado){
					mensaje = datosMensajeModEstado.mensaje
				})
				if (mensaje == 1){
					//console.log(mensaje);
					$('#cuerpoTrabajoDetalleCapacitacion2').html('');
					if (vista == 1){
			     		var urlDatos1 = 'capacitacion_DetalleCapacitacion2.asp';
			     	}else{
			     		var urlDatos1 = './personal/capacitacion_DetalleCapacitacion2.asp';
			     	}
					var div1 = 'cuerpoTrabajoDetalleCapacitacion2';
					var datos1 = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&perfilUsuario='+perfilUsuario+'&idAsignacion='+idAsignacion+'&vista='+vista;
					enviaDatos(urlDatos1,div1,datos1);
				}
			});
			$('#gifCargandoFinalizaCapacitacion').addClass('oculto');
		}
		if (tipoMod == 2){
			var mensaje= '';
			var idUsuario= $('#formTablaIngresoCapacitacion2').attr('data-idUsuario');
			var perfilMain= $('#formTablaIngresoCapacitacion2').attr('data-perfilMain');
			var perfilUsuario= $('#formTablaIngresoCapacitacion2').attr('data-perfilUsuario');
			var vista= $('#formTablaIngresoCapacitacion2').attr('data-vista');
			if (vista == 1){
	     		var urlDatos = 'capacitacion_DetalleCapacitacion_datos.asp';
	     	}else{
	     		var urlDatos = './personal/capacitacion_DetalleCapacitacion_datos.asp';
	     	} 
			tipoVista = 3;
			$.ajax({url:urlDatos,data:{'idUsuario':idUsuario,'perfilMain':perfilMain,'perfilUsuario':perfilUsuario,'idAsignacion':idAsignacion,'tipoVista':tipoVista,'id_estado':id_estado,'tipoMod':tipoMod,'adicional1':adicional1},method:'GET'}).then(function(datos) {
				$.each(datos.datosMensajeModEstado, function(key,datosMensajeModEstado){
					mensaje = datosMensajeModEstado.mensaje
				})
				if (mensaje == 1){
					//console.log(mensaje);
					$('#cuerpoTrabajoDetalleCapacitacion2').html('');
					if (vista == 1){
			     		var urlDatos1 = 'capacitacion_DetalleCapacitacion2.asp';
			     	}else{
			     		var urlDatos1 = './personal/capacitacion_DetalleCapacitacion2.asp';
			     	}	
					var div1 = 'cuerpoTrabajoDetalleCapacitacion2';
					var datos1 = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&perfilUsuario='+perfilUsuario+'&idAsignacion='+idAsignacion+'&vista='+vista;
					enviaDatos(urlDatos1,div1,datos1);
				}
			});
		}
		if (tipoMod == 3){
			var idUsuario= $('#formTablaIngresoCapacitacion2').attr('data-idUsuario');
			var perfilMain= $('#formTablaIngresoCapacitacion2').attr('data-perfilMain');
			var perfilUsuario= $('#formTablaIngresoCapacitacion2').attr('data-perfilUsuario');
			var vista= $('#formTablaIngresoCapacitacion2').attr('data-vista');
			var adicional1= $('#txtObsCapacitacion').val();
			//console.log(adicional1);
			if (vista == 1){
	     		var urlDatos = 'capacitacion_DetalleCapacitacion_datos.asp';
	     	}else{
	     		var urlDatos = './personal/capacitacion_DetalleCapacitacion_datos.asp';
	     	} 	
			var div = '';
			tipoVista = 3;
			$.ajax({url:urlDatos,data:{'idUsuario':idUsuario,'perfilMain':perfilMain,'perfilUsuario':perfilUsuario,'idAsignacion':idAsignacion,'tipoVista':tipoVista,'id_estado':id_estado,'tipoMod':tipoMod,'adicional1':adicional1},method:'GET'}).then(function(datos) {
				$.each(datos.datosMensajeModEstado, function(key,datosMensajeModEstado){
					mensaje = datosMensajeModEstado.mensaje
				})
				if (mensaje == 1){
					//console.log(mensaje);
					$('#cuerpoTrabajoDetalleCapacitacion2').html('');
					if (vista == 1){
			     		var urlDatos1 = 'capacitacion_DetalleCapacitacion2.asp';
			     	}else{
			     		var urlDatos1 = './personal/capacitacion_DetalleCapacitacion2.asp';
			     	}		
					var div1 = 'cuerpoTrabajoDetalleCapacitacion2';
					var datos1 = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&perfilUsuario='+perfilUsuario+'&idAsignacion='+idAsignacion+'&vista='+vista;
					enviaDatos(urlDatos1,div1,datos1);
				}
			});
			$('#gifCargandoFinalizaCapacitacion').addClass('oculto');
		}	
		if (tipoMod == 4){
			var idUsuario= $('#formTablaIngresoCapacitacion2').attr('data-idUsuario');
			var perfilMain= $('#formTablaIngresoCapacitacion2').attr('data-perfilMain');
			var perfilUsuario= $('#formTablaIngresoCapacitacion2').attr('data-perfilUsuario');
			var vista= $('#formTablaIngresoCapacitacion2').attr('data-vista');
			var adicional1= $('#txtObsCapacitacion').val();
			var notaFinalCapacitacion = notaFinal;
			//console.log(notaFinalCapacitacion);
			if (vista == 1){
	     		var urlDatos = 'capacitacion_DetalleCapacitacion_datos.asp';
	     	}else{
	     		var urlDatos = './personal/capacitacion_DetalleCapacitacion_datos.asp';
	     	} 	
			var div = '';
			tipoVista = 5;
			$.ajax({url:urlDatos,data:{'idUsuario':idUsuario,'perfilMain':perfilMain,'perfilUsuario':perfilUsuario,'idAsignacion':idAsignacion,'tipoVista':tipoVista,'id_estado':id_estado,'tipoMod':tipoMod,'adicional1':adicional1,'notaFinalCapacitacion':notaFinalCapacitacion},method:'GET'}).then(function(datos) {
				$.each(datos.datosMensajeModEstado, function(key,datosMensajeModEstado){
					mensaje = datosMensajeModEstado.mensaje
				})
				if (mensaje == 1){
					//console.log(mensaje);
					$('#cuerpoTrabajoDetalleCapacitacion2').html('');
					if (vista == 1){
			     		var urlDatos1 = 'capacitacion_DetalleCapacitacion2.asp';
			     	}else{
			     		var urlDatos1 = './personal/capacitacion_DetalleCapacitacion2.asp';
			     	}		
					var div1 = 'cuerpoTrabajoDetalleCapacitacion2';
					var datos1 = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&perfilUsuario='+perfilUsuario+'&idAsignacion='+idAsignacion+'&vista='+vista;
					enviaDatos(urlDatos1,div1,datos1);
				}
			});
			$('#gifCargandoFinalizaCapacitacion').addClass('oculto');
		}	
	}

	function agregarRadioButtons(id_respuesta,respuesta,perfilUsuario,estadoFormulario){
		var vista= $('#formTablaIngresoCapacitacion2').attr('data-vista');

		var radioButtonsAditionals = '';
		if (vista == 2 && perfilUsuario == 1){
			if (estadoFormulario == 2 || estadoFormulario == 6 || estadoFormulario == 7 || estadoFormulario == 5){
				if (respuesta == 1){
					radioButtonsAditionals += '<div><label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop1'+id_respuesta+'" checked disabled> Si</label>'
				}else{
					radioButtonsAditionals += '<div><label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop1'+id_respuesta+'" disabled> Si</label>'
				}
				if (respuesta == 2){
					radioButtonsAditionals += '<label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop2'+id_respuesta+'" checked disabled>No</label>'
				}else{
					radioButtonsAditionals += '<label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop2'+id_respuesta+'" disabled>No</label>'
				}
				if (respuesta == 3){
					radioButtonsAditionals += '<label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop3'+id_respuesta+'" checked disabled>No Obs</label></div>';
				}else{
					radioButtonsAditionals += '<label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop3'+id_respuesta+'" disabled>No Obs</label></div>';
				}		
			}else{
				if (respuesta == 0){
					radioButtonsAditionals += '<div style="color: red;"><label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop1'+id_respuesta+'"> Si</label><label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop2'+id_respuesta+'">No</label><label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop3'+id_respuesta+'">No Obs</label></div>';				
				}else if(respuesta > 0){
					if (respuesta == 1){
						radioButtonsAditionals += '<div><label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop1'+id_respuesta+'" checked> Si</label>'
					}else{
						radioButtonsAditionals += '<div><label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop1'+id_respuesta+'"> Si</label>'
					}
					if (respuesta == 2){
						radioButtonsAditionals += '<label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop2'+id_respuesta+'" checked>No</label>'
					}else{
						radioButtonsAditionals += '<label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop2'+id_respuesta+'">No</label>'
					}
					if (respuesta == 3){
						radioButtonsAditionals += '<label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop3'+id_respuesta+'" checked>No Obs</label></div>';
					}else{
						radioButtonsAditionals += '<label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop3'+id_respuesta+'">No Obs</label></div>';
					}
				}else{					
					radioButtonsAditionals += ' --- ';
				}
			}			
		}else{
			if (respuesta == 0){
				radioButtonsAditionals +='<div style="color: red;"><label class="radio-inline" style="padding-left: 25px;" disabled><input type="radio" name="optradio'+id_respuesta+'" disabled id="rdop1'+id_respuesta+'"> Si</label><label class="radio-inline" style="padding-left: 25px;" disabled><input type="radio" name="optradio'+id_respuesta+'" disabled id="rdop2'+id_respuesta+'">No</label><label class="radio-inline" style="padding-left: 25px;" disabled><input type="radio" name="optradio'+id_respuesta+'" disabled id="rdop3'+id_respuesta+'">No Obs</label></div>';		
			}else if(respuesta > 0){
				if (respuesta == 1){
					radioButtonsAditionals += '<div><label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop1'+id_respuesta+'" checked disabled> Si</label>'
				}else{
					radioButtonsAditionals += '<div><label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop1'+id_respuesta+'" disabled> Si</label>'
				}
				if (respuesta == 2){
					radioButtonsAditionals += '<label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop2'+id_respuesta+'" checked disabled>No</label>'
				}else{
					radioButtonsAditionals += '<label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop2'+id_respuesta+'" disabled>No</label>'
				}
				if (respuesta == 3){
					radioButtonsAditionals += '<label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop3'+id_respuesta+'" checked disabled>No Obs</label></div>';
				}else{
					radioButtonsAditionals += '<label class="radio-inline" style="padding-left: 25px;"><input type="radio" name="optradio'+id_respuesta+'" id="rdop3'+id_respuesta+'" disabled>No Obs</label></div>';
				}		
			}else{					
				radioButtonsAditionals += ' --- ';
			}
		}		
		return radioButtonsAditionals;
	}

	function guardarRespuestaCapacitacion(idAsignacion,idRespuesta,respuesta){

		var idUsuario= $('#formTablaIngresoCapacitacion2').attr('data-idUsuario');
		var perfilMain= $('#formTablaIngresoCapacitacion2').attr('data-perfilMain');
		var perfilUsuario= $('#formTablaIngresoCapacitacion2').attr('data-perfilUsuario');
		var vista= $('#formTablaIngresoCapacitacion2').attr('data-vista');
		var tipoVista = 4;
		if (vista == 1){
     		var urlDatos = 'capacitacion_DetalleCapacitacion_datos.asp';
     	}else{
     		var urlDatos = './personal/capacitacion_DetalleCapacitacion_datos.asp';
     	}	

		$.ajax({url:urlDatos,data:{'idUsuario':idUsuario,'perfilMain':perfilMain,'perfilUsuario':perfilUsuario,'idAsignacion':idAsignacion,'tipoVista':tipoVista,'idRespuesta':idRespuesta,'respuesta':respuesta},method:'GET'}).then(function(datos) {
			$.each(datos.datosMensajeRespuesta, function(key,datosMensajeRespuesta){
				mensaje = datosMensajeRespuesta.mensaje
			})			
		});
	}



</script>