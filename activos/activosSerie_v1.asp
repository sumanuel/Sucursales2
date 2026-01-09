<%serieMax = trim(request("serieMax"))
serieMin = trim(request("serieMin"))
ayuda = trim(request("ayuda"))
modelo = trim(request("modelo"))%>
<div class="row-fluid" id="divSerie">
	<div class="span12" id="spanSerie">
		<label class="control-label" for="campoSerie">Serie</label>
			<div class="controls" id="controlSerie">
				<input type="text" name="campoSerie" id="campoSerie" data-rule-required="true" data-msg-required="El campo no puede estar vacio" data-rule-maxlength="<%=serieMax%>" data-rule-minlength="<%=serieMin%>" data-msg-minlength="La serie no puede ser menor a <%=serieMin%> caracteres" data-msg-maxlength="La serie no puede ser mayor a <%=serieMax%> caracteres">
			<%if ayuda = "1" then%>
				<i class="icon-question-sign icon-2x mano" id="iconoAyuda"></i>
			<%end if%>
			<span class="btn btn-mini btn-danger" id="btnSinSerie">Sin serie</span>
		</div>
	</div>
</div>

<%if ayuda = "1" then%>
	<div class="modal hide fade" id="myModal">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>Aviso!</h3>
		</div>
		<div class="modal-body">
			<img src="ayuda/<%=modelo%>.png">
		</div>
		<div class="modal-footer">
			<a href="#" class="btn" data-dismiss="modal">Cerrar <i class="icon-remove"></i></a>
		</div>
	</div>
	<script type="text/javascript">
	$('#iconoAyuda').click(function(){
		$('#myModal').modal({ 
			backdrop: 'static', 
			keyboard: true,
			show: true
		});
	});

	</script>
<%end if%>
<script type="text/javascript">
if ($('#tipoElemento').val() === '1' &&  $('#tipoFormulario').val() === '1')
{
	$('#btnSinSerie').addClass('oculto');
}
if ($('#tipoElemento').val() === '8' &&  $('#tipoFormulario').val() === '1')
{
	$('#btnSinSerie').addClass('oculto');
}
if ($('#tipoElemento').val() === '9' &&  $('#tipoFormulario').val() === '1')
{
	$('#btnSinSerie').addClass('oculto');
}
var valorModelo = $('#campoModelo option:selected').val()
if (valorModelo === '51' || valorModelo === '52' || valorModelo === '53')
{
	soloModelo2();
}
if (valorModelo ==='64')
{
	soloModelo3();
}
if (valorModelo ==='56')
{
	soloModelo2();
}
if (valorModelo ==='55' || valorModelo === '54')
{
	soloModelo2();
}
if (valorModelo === '17' || valorModelo === '16' || valorModelo === '18' || valorModelo === '19' || valorModelo === '5' || valorModelo === '8' || valorModelo === '10' || valorModelo === '9'|| valorModelo === '6' || valorModelo === '24' || valorModelo === '25' || valorModelo === '26' || valorModelo === '27' || valorModelo === '23' || valorModelo === '76' || valorModelo === '47' || valorModelo === '78' || valorModelo === '48' || valorModelo === '77')
{
	soloModelo4();
}

$('#btnSinSerie').click(function() {
	$('#divSerie').slideUp('slow');
});
if($('#campoMarca option:selected').val() ==='1')
{
	$('#campoSerie').attr('data-rule-verificaNumerosLetras','true');
}
if(valorModelo ==='48')
{
	$('#campoSerie').val('2K');
}


jQuery.validator.addMethod("verificaSerieInicio", function(value, element, param) { 
  return this.optional(element) || value === param;
}, jQuery.format("La serie debe comenzar con {0}"));
</script>