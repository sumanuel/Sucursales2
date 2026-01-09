<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursalMain"))
idUsuario = trim(request("idUsuarioMain"))
sql = ""
sql = sql & "select id_gest_inc_tipo, gest_inc_tipo,subtipo from SUC_gest_inc_tipo "
set rsCombo = db.execute(sql)%>
<form class="form-horizontal" id="ingresoNuevaGestion" name="ingresoNuevaGestion">
	<input type="hidden" name="idSucursal" id="idSucursal" value="<%=idSucursal%>">
	<input type="hidden" name="idUsuario" id="idUsuario" value="<%=idUsuario%>">
  <div class="control-group">
    <label class="control-label" for="tipoGestionIncidencia">Tipo de Gestion</label>
    <div class="controls">
    	<%if not rsCombo.eof then%>
      	<select id="tipoGestionIncidencia" name="tipoGestionIncidencia" title="Debe selecionar tipo de incidencia">
      		<option value="">[Tipo de incidencia]</option>
      		<%do while not rsCombo.eof
      			idTipoGestion = trim(rsCombo("id_gest_inc_tipo"))
				nombreTipoGestion = server.htmlencode(trim(rsCombo("gest_inc_tipo")))
				subTipo = trim(rsCombo("subtipo"))%>
				<option value="<%=idTipoGestion%>" data-subTipo="<%=subtipo%>">
					<%=nombreTipoGestion%>
				</option>
      			<%rsCombo.movenext
			loop%>	
		</select>
		<%else
			response.write("error en la busqueda de tipos de incidencia")
		end if%>
    </div>
  </div>
  <div id="subtipo" class="hidden"></div>
  <div class="control-group" id="ticket">
    <label class="control-label" for="numTicket">Número de ticket</label>
    <div class="controls">
      <input type="text" id="numTicket" name="numTicket" title="Debe ingresar el número del ticket" placeholder="Número de ticket">
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="observacionIncidencia">Observación</label>
    <div class="controls">
      <textarea rows="3" id="observacionIncidencia" name="observacionIncidencia" title="Debe ingresar la observación" placeholder="Observacion"></textarea>
      <span id="totalCaracteres" class="badge"></span>
    </div>
  </div>
  <div class="control-group">
    <div class="controls">
      <button type="submit" class="btn btn-success">Ingresar</button>
      <button type="button" class="btn btn-danger cierraIngresoincidencia">Cerrar</button>
    </div>
  </div>
</form>
<%rsCombo.Close
set rsCombo.ActiveConnection = nothing
set rsCombo=nothing
DB.Close
set DB=nothing%>
<script type="text/javascript">
var pagina,div,datos
//
$(function(){
	(function($) {
	$.fn.extend( {
	limiter: function(limit, elem) {
	$(this).on("keyup focus", function() {
	setCount(this, elem);
	});
	function setCount(src, elem) {
	var chars = src.value.length;
	if (chars > limit) {
	src.value = src.value.substr(0, limit);
	chars = limit;
	elem.addClass("badge-important");
	}
	else
	{
	elem.removeClass("badge-important");
	}
	elem.html( limit - chars );
	}
	setCount($(this)[0], elem);
	}
	});
	})(jQuery);
	var elem = $("#totalCaracteres");
	$("#observacionIncidencia").limiter(400, elem);
	$("#ingresoNuevaGestion").validate({
		ignore:":not(:visible)", 
		onsubmit: true,
		rules: {
			tipoGestionIncidencia:{required:true},
			valorSubTipo:{required:true},
			numTicket:{required:false,number:true},
			observacionIncidencia: {required: true}
		},
		submitHandler: function(form) {
		var numero = '&v='+ Math.random() * 999;
		var valores = $('#ingresoNuevaGestion').serialize();
		var observacionIncidenciaValor = $('#observacionIncidencia').val();
		var tipoGestionIncidenciaValor = $('#tipoGestionIncidencia').find(":selected").text();
		valores += numero;
		$('#nuevaIncidencia').html('<i class="icon-refresh icon-spin"></i>Un momento guardando datos');
		$.ajax( 
			{
				type:'GET',
				url:'incidencias/sql.asp', //la pagina que se van los datos
				cache:false,
				//async:true,
				global:false,
				dataType:"html",
				data:valores,
				timeout:10000, //tiempo que espera
				success:function(contenido) //cargo la pagina correctamente
				{
					setTimeout("enviaDatos('incidencias/muestraIncidencias.asp','area','');",1500);
					setTimeout('$("#nuevaIncidencia").html("<i class=icon-check></i>Registrado con exito")',2000);
					setTimeout('$(".registraNuevaIncidencia").removeClass("oculto")',3000);
					setTimeout('$("#nuevaIncidencia").addClass("oculto")',3500);	    	
				},
				error:function() //si no carga la pagina
				{
					alert('Algo Salio Mal.');
				}
			});
		}
	});
});
$('#tipoGestionIncidencia').change(function(){
	if ($( "#tipoGestionIncidencia option:selected" ).attr('data-subTipo') == '1')	
	{
		tipo = $( "#tipoGestionIncidencia option:selected" ).val();
		if (tipo ==='14')
		{
			$('#ticket').slideUp('fast');
		}
		$('#subtipo').removeClass('hidden').html('');
		pagina = 'incidencias/subTipo.asp';
		div = 'subtipo';
		datos = 'tipo='+tipo;
		try{
			enviaDatos(pagina,div,datos);
			return false;
		}
		catch(err){}		
	}
	else
	{
		$('#subtipo').html('<input type="hidden" name="valorSubTipo" id="valorSubTipo" value="0">');
		$('#ticket').slideDown('fast');
	}
});
$('.escondeCierra').click(function(){
	var idCierra = $(this).attr('data-idTarea');
	$('#hora'+idCierra).html('');
	$('#tarea'+idCierra).html('<span class="btn btn-success" id="tarea'+idCierra+'">Cerrar Tarea</span>');
});
$('.cierraIngresoincidencia').click(function(){
	$('#nuevaIncidenciaDiv').addClass('oculto');
	$('.registraNuevaIncidencia').removeClass('oculto');
});




	
/*var fechaActual = new Date();
var horaActual = fechaActual.getHours();
var minutoActual = fechaActual.getMinutes();
if (horaActual < 10) {
	horaActual = "0" + horaActual;
}
if (minutoActual < 10) {
	minutoActual = "0" + minutoActual;
}
var horaIngreso = horaActual+':'+minutoActual;*/
</script>