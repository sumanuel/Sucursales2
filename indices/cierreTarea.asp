<%idTarea = trim(request("idTarea"))
tipo = trim(request("tipo"))
horarioActual = Time()
horaActual = hour(horarioActual)
idUsuario = trim(request("idUsuario"))%>
<div class="row-fluid" >
	<div class="span12" id="divRegistroTarea<%=idTarea%>">
		<form id="registroTarea<%=idTarea%>" name="registroTarea<%=idTarea%>">
			<input type="hidden" name="idTarea" id="idTarea" value="<%=idTarea%>">
			<input type="hidden" name="tipo" id="tipo" value="<%=tipo%>">
			<input type="hidden" name="idUsuario" id="idUsuario" value="<%=idUsuario%>">
			<table>
				<tr>
					<td>Seleccione Hora y Minutos</td>
					<td>
						<select name="hora" id="hora" class="span5" title="Debe seleccionar hora">
							<option value="">[Hora]</option>
							<%for hora=6 to horaActual
								muestraHora = hora
								if len(muestraHora) = "1" then
									muestraHora = "0"&muestraHora
								end if%>
								<option value="<%=muestraHora%>"><%=muestraHora%></option>
							<%Next%>
						</select>
						:
						<select name="minutos" id="minutos" class="span5" title="Debe seleccionar minutos">
							<option value="">[Minutos]</option>
							<%for minutos=0 to 59
								muestraMinutos = minutos
								if len(muestraMinutos) = "1" then
									muestraMinutos = "0"&muestraMinutos
								end if%>
								<option value="<%=muestraMinutos%>"><%=muestraMinutos%></option>
							<%Next%>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						Observación
					</td>
					<td>
						<textarea rows="3" id="observacion" name="observacion"></textarea>
					</td>
				</tr>
				<tr align="center">
					<td colspan="2" align="center">
						<input type="submit" value="Guardar" class="btn btn-primary btn-small" id="botonRegistro<%=idTarea%>">
						<input class="btn noAplica btn-warning" type="button" id="botonNoAplicaRegistro<%=idTarea%>" data-idTarea="<%=idTarea%>" value="No Aplica">
						<input class="btn btn-mini btn-danger escondeCierra" type="button" id="botonCerrarRegistro<%=idTarea%>" data-idTarea="<%=idTarea%>" value="Cerrar">

					</td>
				</tr>
			</table>
		</form>
	</div>
</div>

<script src="js/jquery.validate.js"></script>
<script src="js/additional-methods.js"></script>
<script type="text/javascript">
var idTarea = $('#idTarea').val();
var tipo = $('#tipo').val();
var fechaActual = new Date();
var horaActual = fechaActual.getHours();
var minutoActual = fechaActual.getMinutes();
if (horaActual < 10) {horaActual = "0" + horaActual}
if (minutoActual < 10) {minutoActual = "0" + minutoActual}
horaIngreso = horaActual+':'+minutoActual;


$('#botonNoAplicaRegistro'+idTarea).click(function(){
	var numero = '&v='+ Math.random() * 999;
	$('#minutos').val(minutoActual);
	$('#hora').val(horaActual);
	$('#observacion').val('No aplica');
	var valores = $('#registroTarea'+idTarea).serialize(); 
	
	$('#hora'+idTarea).html('<i class="icon-refresh icon-spin"></i>');
	$.ajax({
		type:'GET',
		url:'indices/sql.asp', //la pagina que se van los datos
		cache:false,
		//async:true,
		global:false,
		dataType:"html",
		data:valores,
		timeout:10000, //tiempo que espera
		success:function(contenido) //cargo la pagina correctamente
		{
			$('#tarea'+idTarea).html('');
			$('#hora'+idTarea).html(contenido);
			$('#horaIngreso'+idTarea).html(horaIngreso);
			$('.cierraTarea').show();
			$('td#cierra'+idTarea).html('<i class="icon-check"></i>');
			if (tipo == "2")
	    	{
	    		enviaDatos('indicadores/indicadorGestiones.asp','gDocumental','tipo=2');
	    	}
	    	if (tipo == "3")
	    	{
	    		enviaDatos('indicadores/indicadorGestiones.asp','gContable','tipo=3');
	    	}
	    	if (tipo == "4")
	    	{
	    		enviaDatos('indicadores/indicadorGestiones.asp','gAdministrativa','tipo=4');
	    	}
	    	return false;
		},
		error:function() //si no carga la pagina
		{
			alert('Error, disculpa los inconvenientes: favor contacta a soportecanales@losheroes.cl');
			return false;
		}
	});

});
$("#registroTarea"+idTarea).validate({
	ignore:":not(:visible)", 
    onsubmit: true,
    rules: {
    hora:{
		required:true 
    	},
	minutos: {
	    required: true
    	}
	},
	submitHandler: function(form) {
	var numero = '&v='+ Math.random() * 999;
    var valores = $('#registroTarea'+idTarea).serialize(); 
	valores += numero ;
	$('#hora'+idTarea).html('<i class="icon-refresh icon-spin"></i>');
	$.ajax( 
		{
			type:'GET',
			url:'indices/sql.asp', //la pagina que se van los datos
			cache:false,
			//async:true,
			global:false,
			dataType:"html",
			data:valores,
			timeout:10000, //tiempo que espera
			success:function(contenido) //cargo la pagina correctamente
			{
				$('#tarea'+idTarea).html('');
				$('#hora'+idTarea).html(contenido);
				$('#horaIngreso'+idTarea).html(horaIngreso);
				$('.cierraTarea').show();
				$('td#cierra'+idTarea).html('<i class="icon-check"></i>');
				if (tipo == "2")
		    	{
		    		enviaDatos('indicadores/indicadorGestiones.asp','gDocumental','tipo=2');
		    	}
		    	if (tipo == "3")
		    	{
		    		enviaDatos('indicadores/indicadorGestiones.asp','gContable','tipo=3');
		    	}
		    	if (tipo == "4")
		    	{
		    		enviaDatos('indicadores/indicadorGestiones.asp','gAdministrativa','tipo=4');
		    	}
		    	return false;
			},
			error:function() //si no carga la pagina
			{
				alert('Algo Salio Mal.');
				return false;
			}
		});
	}
});
$('.escondeCierra').click(function(){
	var idCierra = $(this).attr('data-idTarea');
	$('#hora'+idCierra).html('');
	$('#tarea'+idCierra).removeClass('oculto').addClass('btn btn-success');
	$('#botonGira'+idCierra).addClass('oculto');
	$('.cierraTarea').show();
});
</script>