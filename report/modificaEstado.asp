<!--#include file="../funciones2.asp"-->
<%codigoBarras = trim(request("codigoBarras"))
idEstado = trim(request("idEstado"))
botonera = trim(request("botonera"))
enteroPorcentaje = trim(request("porcentaje"))
idUsuarioMain = trim(request("idUsuarioMain"))
idSucursalMain = trim(request("idSucursalMain"))

if enteroPorcentaje = "" then enteroPorcentaje="0"
	totalDocumentos = trim(request("totalDocumentos"))

if totalDocumentos = "undefined" then totalDocumentos = "0"
if idEstado = "201" then%>
	<span class="btn btn-mini btn-warning cambiaEstado" id="cambiaEstado" data-codigoBarras="<%=codigoBarras%>" class="cambiaCodigoBarras" data-botonera="<%=botonera%>" data-nuevoEstado="202" data-totalDocumentos="<%=totalDocumentos%>">
		Abrir
	</span>
<%end if%>

<%if idEstado = "202" then
	if enteroPorcentaje = "100" then%>
		<span class="btn btn-mini btn-warning cambiaEstado cambiaCodigoBarras" id="cambiaEstado" data-codigoBarras="<%=codigoBarras%>" data-botonera="<%=botonera%>" data-nuevoEstado="203" data-totalDocumentos="<%=totalDocumentos%>" data-porcentaje="<%=enteroPorcentaje%>" data-toggle="tooltip" title="Modifica Estado Caja">
			Cerrar
		</span>
	<%end if

	if enteroPorcentaje = "0" then
		if totalDocumentos = "0" then%>
			<span class="btn btn-mini btn-warning cambiaEstado" id="cambiaEstado" data-codigoBarras="<%=codigoBarras%>" class="cambiaCodigoBarras" data-botonera="<%=botonera%>" data-nuevoEstado="299" data-totalDocumentos="<%=totalDocumentos%>" data-porcentaje="<%=enteroPorcentaje%>" data-toggle="tooltip" title="Modifica Estado Caja">
				Eliminar
			</span>
		<%else%>
			<span class="badge badge-important cambiaEstado"  id="cambiaEstado" data-codigoBarras="<%=codigoBarras%>" class="cambiaCodigoBarras" data-botonera="<%=botonera%>" data-totalDocumentos="<%=totalDocumentos%>"> No se puede cerrar</span>
			<script type="text/javascript">
			setTimeout(function() {
				$('#estadoActual<%=botonera%>').text('Abierta');
				$('#botonera<%=botonera%>').html('<span id="btnModifica<%=botonera%>" data-idEstado="<%=idEstado%>" class="modificaEstado btn btn-mini btn-info" data-codigoBarras="<%=codigoBarras%>" data-modifica="0" data-porcentaje="<%=enteroPorcentaje%>" onClick="modificaEstado(<%=botonera%>);" data-botonera="<%=botonera%>"><i class="icon-edit icon-large"></i></span> <span id="listaContenido" class="btn btn-success btn-mini" data-codigoBarras="<%=codigoBarras%>" onClick="listaContenido(<%=codigoBarras%>)"><i class="icon-eye-open icon-large"></i></span>');
				//$('#botonera<%=botonera%>').html('<span id="listaContenido" class="btn btn-success btn-mini" data-codigoBarras="<%=codigoBarras%>" onClick="listaContenido(<%=codigoBarras%>)"><i class="icon-eye-open icon-large"></i></span>');
			}, 1500);
			</script>
		<%end if%>

	<%end if
	if enteroPorcentaje <> "100" and enteroPorcentaje <> "0" then%>
		<span class="badge badge-importan cambiaEstado"  id="cambiaEstado" data-codigoBarras="<%=codigoBarras%>" class="cambiaCodigoBarras" data-botonera="<%=botonera%>" data-totalDocumentos="<%=totalDocumentos%>" data-toggle="tooltip" title="Modifica Estado Caja"> Complete checklist</span>
		<script type="text/javascript">
		setTimeout(function() {
			$('#estadoActual<%=botonera%>').text('Abierta');
			$('#botonera<%=botonera%>').html('<span id="btnModifica<%=botonera%>" data-idEstado="<%=idEstado%>" class="modificaEstado btn btn-mini btn-info" data-codigoBarras="<%=codigoBarras%>" data-modifica="0" data-porcentaje="<%=enteroPorcentaje%>" onClick="modificaEstado(<%=botonera%>);" data-botonera="<%=botonera%>"><i class="icon-edit icon-large"></i></span> <span id="listaContenido" class="btn btn-success btn-mini" data-codigoBarras="<%=codigoBarras%>" onClick="listaContenido(<%=codigoBarras%>)"><i class="icon-eye-open icon-large"></i></span>');
		}, 1500);
		</script>
	<%end if
end if

if idEstado = "203" then%>
	<span class="btn btn-mini btn-warning cambiaEstado" id="cambiaEstado" data-codigoBarras="<%=codigoBarras%>" class="cambiaCodigoBarras" data-botonera="<%=botonera%>" data-nuevoEstado="204" data-totalDocumentos="<%=totalDocumentos%>" data-toggle="tooltip" title="Modifica Estado Caja">Enviar</span>

	<span class="btn btn-mini btn-warning cambiaEstado" id="cambiaEstado" data-codigoBarras="<%=codigoBarras%>" class="cambiaCodigoBarras" data-porcentaje="<%=enteroPorcentaje%>" data-botonera="<%=botonera%>" data-nuevoEstado="202" data-totalDocumentos="<%=totalDocumentos%>" data-toggle="tooltip" title="Modifica Estado Caja">Abrir</span>
<%end if%>
<span class="btn btn-mini btn-danger cierraBotonera" data-codigoBarras="<%=codigoBarras%>" data-botonera="<%=botonera%>" data-estado="<%=idEstado%>" data-porcentaje="<%=enteroPorcentaje%>" data-totalDocumentos="<%=totalDocumentos%>" id="btnCierra"><i class="icon-remove icon-large"></i></span>

<script type="text/javascript">
	$('.cambiaEstado').click(function() {
		$('#cambiaEstado').tooltip('show');
		var codigoBarras = $(this).attr('data-codigoBarras');
		var botonera = $(this).attr('data-botonera');
		var valorCambia = $(this).attr('data-nuevoEstado');
		var idUsuarioMain = <%=idUsuarioMain%>;
		var idSucursalCaja = <%=idSucursalMain%>;
		if (valorCambia == '204'){
			$('#modalFecEnvio').modal({
	   		keyboard: false,
	    	show: true,
	        backdrop: true,
	        remote: 'report/fechaEnvioCaja.asp?codigoBarras='+codigoBarras+'&valorEstado='+valorCambia+'&idAccion=2&botonera='+botonera+'&idUsuarioMain1='+idUsuarioMain+'&idSucursalCaja='+idSucursalCaja
	  		});

	  		$('#modalFecEnvio').on('hidden', function () {
	  			var idSucursalCaja = <%=idSucursalMain%>;
				var idUsuarioMain = <%=idUsuarioMain%>;
				//$('#listaCajasIng').html('').hide();			
				var pagina = 'report/cajas.asp';
				var div = 'divMuestraCaja';
				var datos='idSucursalCaja='+idSucursalCaja+'&idUsuarioMain1='+idUsuarioMain;
				enviaDatos(pagina,div,datos)		  
			});
		}else{
			var pagina, div, datos, porcentaje;
			porcentaje = $(this).attr('data-porcentaje');
			pagina = 'report/sqlCajas.asp';
			div='botonera'+botonera;
			datos = 'codigoBarras='+codigoBarras+'&valorEstado='+valorCambia+'&idAccion=2&botonera='+botonera+'&idUsuarioMain1='+idUsuarioMain+'&porcentaje='+porcentaje;
			enviaDatos(pagina,div,datos);
		}
	});

$('.cierraBotonera').click(function(){
	var botonera, estado, codigoBarras, porcentaje, totalDocumentos, idEstado;
	idEstado = $(this).attr('data-estado');
	botonera = $(this).attr('data-botonera');
	estado = $(this).attr('data-estado');
	codigoBarras = $(this).attr('data-codigoBarras');
	porcentaje = $(this).attr('data-porcentaje');
	totalDocumentos = $(this).attr('data-totalDocumentos');
	if (idEstado === "202" && porcentaje === "100"){
		$('#botonera'+botonera).html('<span id="btnModifica'+botonera+'" data-idEstado="'+estado+'" class="modificaEstado btn btn-info btn-mini" data-codigoBarras="'+codigoBarras+'" data-modifica="0" data-porcentaje="'+porcentaje+'" onClick="modificaEstado('+botonera+');" data-botonera="'+botonera+'" data-totalDocumentos="'+totalDocumentos+'"><i class="icon-edit icon-large"></i></span> <span id="listaContenido" class="btn btn-success btn-mini" data-codigoBarras="<%=codigoBarras%>" onClick="listaContenido(<%=codigoBarras%>)"><i class="icon-eye-open icon-large"></i></span>');
	}else if (idEstado === "203"){
		$('#botonera'+botonera).html('<span id="btnModifica'+botonera+'" data-idEstado="'+estado+'" class="modificaEstado btn btn-info btn-mini" data-codigoBarras="'+codigoBarras+'" data-modifica="0" data-porcentaje="'+porcentaje+'" onClick="modificaEstado('+botonera+');" data-botonera="'+botonera+'" data-totalDocumentos="'+totalDocumentos+'"><i class="icon-edit icon-large"></i></span> <span id="listaContenido" class="btn btn-success btn-mini" data-codigoBarras="<%=codigoBarras%>" onClick="listaContenido(<%=codigoBarras%>)"><i class="icon-eye-open icon-large"></i></span>');
	}else{
		$('#botonera'+botonera).html('<span id="btnModifica'+botonera+'" data-idEstado="'+estado+'" class="modificaEstado btn btn-info btn-mini" data-codigoBarras="'+codigoBarras+'" data-modifica="0" data-porcentaje="'+porcentaje+'" onClick="modificaEstado('+botonera+');" data-botonera="'+botonera+'" data-totalDocumentos="'+totalDocumentos+'"><i class="icon-edit icon-large"></i></span>');
	}
});

</script>