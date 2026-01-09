<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
perfil = trim(request("perfilMain"))
tieneDatos = 0
noZonal = trim(request("noZonal"))
idUsuario = trim(request("idUsuarioMain"))
if noZonal = "" then noZonal = 0
if idSucursal <> "" then tieneDatos ="1" %>
<form class="form-horizontal" id="formAgendaZonal">
		<input type="hidden" name="idUsuario" id="idUsuario" value="<%=idUsuario%>">
		<%if perfil = "3" and noZonal = "1" then%>
		<div class="control-group" id="controlZonal">
			<label class="inline">Seleccione Zonal</label>
			<label class="inline">
				<span id="zonal"></span>
			</label>
			<label for="zonal" class="error"></label>
		</div>
	<%end if
	if idSucursal = "" then%>
		<div class="control-group" id="controlSucursales">
			<label class="inline">Seleccione Sucursal</label>
			<label class="inline">
				<span id="sucursal"></span>
			</label>
			<label for="sucursal" class="error"></label>
		</div>
	<%else%>
		<input type="hidden" name="sucursal" id="sucursal" value="<%=idSucursal%>">
	<%end if%>
	<div class="control-group" id="controlFecha">
		<label class="inline">Fecha y hora</label>
		<label class="inline">
			<div id="fechaVisita" class="input-append date">
				<input type="text" name="campoFechaVisita" id="campoFechaVisita" placeholder="Seleccione fecha y hora de visita" title="Seleccione fecha y hora de visita"/>
				<span class="add-on">
					<i data-time-icon="icon-time" data-date-icon="icon-calendar" class="icon-calendar"></i>
				</span>
			</div>
		</label>
		<label for="campoFechaVisita" class="error"></label>
	</div>
	<div class="control-group" id="controlMotivo">
		<label class="inline">Seleccione Motivo</label>
		<label class="inline">
			<span id="motivo"></span>
		</label>
		<label for="motivo" class="error"></label>
	</div>
	<div class="control-group" id="controlObservacion">
		<label class="inline">Observación</label>
		<label class="inline">
			<textarea rows="3" name="observacionVisita" id="observacionVisita" placeholder="Ingrese Observación"></textarea>
		</label>
		<label for="observacionVisita" class="error"></label>
	</div>
	<div class="control-group" id="controlObservacion">
		<label class="inline">
			<input type="hidden" name="tieneSucursal" id="tieneSucursal" value="<%=tieneDatos%>">
			<input type="submit" name="botonSubmit" value="Agendar Visita" id="botonSubmit" class="btn btn-primary"/>
		</label>
	</div>
	<div id="envia" class="oculto"></div>
</form>
<script type="text/javascript">
$(function(){
	var pagina, div,datos
	var tieneSucursal = $('#tieneSucursal').val();
	<%if perfil <> "3" then%>
		if (!$('#sucursalSeleccionada').hasClass('oculto'))
		{
			idSucursal = $('#sucursalSeleccionada').attr('data-idsucursal');
			$('#controlSucursales').html('<input type="hidden" name="sucursal" id="sucursal" value="'+idSucursal+'">');
			tieneSucursal = '1';
		}
	<%end if%>
		if (tieneSucursal == "0")
		{
			enviaDatos('sucursales/listaSucursales.asp','sucursal','');
		}
	<%if perfil ="3" then%>
		try{
			pagina = 'zonal/listaZonal.asp';
			div = 'zonal';
			datos = '';
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
		
	<%end if%>
	try{
		pagina = 'visitas/seleccionaMotivoVisita.asp';
		div = 'motivo';
		datos = '';
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	$('#fechaVisita').datetimepicker({
		format: 'dd/MM/yyyy hh:mm:ss',
		language: 'es-Cl'
	});

	$("#formAgendaZonal").validate({
    	ignore:":not(:visible)", //ignora los campos no visibles 
		onsubmit: true, //solo cuando el usuario hace submit 
		rules: { //comienzan las reglas
			<%if perfil ="3" then%>
				zonal:{
				required:true //campo requerido
				},
			<%end if%>
			sucursal:{
				required:true //campo requerido
			},
	    	campoFechaVisita: {
				required: true
			},
		    motivoVisita:{
		    	required: true
		    }
	   	},
	   	submitHandler: function(form) 
	   	{
			var numero = '&v='+ Math.random() * 999 
	    	var valores = $("#formAgendaZonal").serialize();
			valores += numero	
			$(':input').addClass('uneditable-input'); 
			$('#botonSubmit').hide('fast'); 
	    	$('#envia').removeClass('oculto').html('<strong>Guardando</strong> <img src="img/loader.gif"/>');
	    	$('#envia').delay(2000).queue(function( nxt ) { 
				$.ajax({
					type:'GET', 
					url:'visitas/sqlVisita.asp',
					cache:false,
					//async:true,
					global:false,
					dataType:"html",
					data:valores,
					timeout:10000, 
					success:function(contenido)
					{
						if (contenido =="1") 
						{
							$('#envia').html('<i class="icon-ok-sign"></i>Visita registrada con exito');
							setTimeout(function() {
								$('#nuevaVisitaZonal').slideUp('slow').addClass('oculto');
								$('#botoncierraNuevaVisita').addClass('oculto');
								$('#botonAgregaVisita').removeClass('oculto');
								tieneSucursal = $('#tieneSucursal').val();
								if (tieneSucursal == "0")
								{
									try{
										pagina = 'calendario/calendario.asp';
										div = 'agendaZonal';
										datos = ''
										enviaDatos(pagina,div,datos);
									}
									catch(err)
									{}
								}
								else
								{
									try{
										var idSucursal = $('#sucursal').val();
										pagina = 'calendario/calendario.asp';
										div = 'tareasZonal';
										datos = 'idSucursal='+idSucursal
										enviaDatos(pagina,div,datos);
									}
									catch(err){}
									
								}
							}, 2000);
						}
						else
						{
							$('#botonSubmit').show('fast');
							$(':input').removeClass('uneditable-input');
						}
					},
					error:function(){alert('Algo Salio Mal.');return false;}
				});
				nxt();
			});
		}
	});
<%if perfil ="3" then%>
	$('#zonal').change(function(){
		var valorComboZonal = $('#zonal option:selected').val();
		try{
			pagina = 'sucursales/listaSucursales.asp';
			div = 'sucursal';
			datos = 'idZonal='+valorComboZonal;
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
	});
});
<%else%>
});
<%end if%>
</script>
