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
		Abrir Caja
	</span>
<%end if%>
<%if idEstado = "202" then
	if enteroPorcentaje = "100" then%>
		<span class="btn btn-mini btn-warning cambiaEstado" id="cambiaEstado" data-codigoBarras="<%=codigoBarras%>" class="cambiaCodigoBarras" data-botonera="<%=botonera%>" data-nuevoEstado="203" data-totalDocumentos="<%=totalDocumentos%>">
			Cerrar Caja
		</span>
	<%end if
	if enteroPorcentaje = "0" then
	'ver si no tiene check
		if totalDocumentos = "0" then%>
			<span class="btn btn-mini btn-warning cambiaEstado" id="cambiaEstado" data-codigoBarras="<%=codigoBarras%>" class="cambiaCodigoBarras" data-botonera="<%=botonera%>" data-nuevoEstado="299" data-totalDocumentos="<%=totalDocumentos%>">
				Eliminar Caja
			</span>
		<%else%>
			<span class="badge badge-important cambiaEstado"  id="cambiaEstado" data-codigoBarras="<%=codigoBarras%>" class="cambiaCodigoBarras" data-botonera="<%=botonera%>" data-totalDocumentos="<%=totalDocumentos%>"> La caja no se puede cerrar ni eliminar</span>
			<script type="text/javascript">
			setTimeout(function() {
				$('#estadoActual<%=botonera%>').text('Abierta');
				$('#botonera<%=botonera%>').html('<span id="btnModifica<%=botonera%>" data-idEstado="<%=idEstado%>" class="modificaEstado btn btn-mini btn-danger" data-codigoBarras="<%=codigoBarras%>" data-modifica="0" data-porcentaje="<%=enteroPorcentaje%>" onClick="modificaEstado(<%=botonera%>);" data-botonera="<%=botonera%>">Modificar Estado</span>');
			}, 2000);
			</script>
		<%end if%>
	<%end if
	if enteroPorcentaje <> "100" and enteroPorcentaje <> "0" then%>
		<span class="badge badge-importan cambiaEstadot"  id="cambiaEstado" data-codigoBarras="<%=codigoBarras%>" class="cambiaCodigoBarras" data-botonera="<%=botonera%>" data-totalDocumentos="<%=totalDocumentos%>"> La caja no se puede cerrar ni eliminar</span>
		<script type="text/javascript">
		setTimeout(function() {
			$('#estadoActual<%=botonera%>').text('Abierta');
			$('#botonera<%=botonera%>').html('<span id="btnModifica<%=botonera%>" data-idEstado="<%=idEstado%>" class="modificaEstado btn btn-mini btn-danger" data-codigoBarras="<%=codigoBarras%>" data-modifica="0" data-porcentaje="<%=enteroPorcentaje%>" onClick="modificaEstado(<%=botonera%>);" data-botonera="<%=botonera%>">Modificar Estado</span>');
		}, 2000);
		</script>
	<%end if
end if
if idEstado = "203" then%>
	<span class="btn btn-mini btn-warning cambiaEstado" id="cambiaEstado" data-codigoBarras="<%=codigoBarras%>" class="cambiaCodigoBarras" data-botonera="<%=botonera%>" data-nuevoEstado="204" data-totalDocumentos="<%=totalDocumentos%>">
			Enviar Caja
	</span>
	<span class="btn btn-mini btn-warning cambiaEstado" id="cambiaEstado2" data-codigoBarras="<%=codigoBarras%>" class="cambiaCodigoBarras" data-botonera="<%=botonera%>" data-nuevoEstado="202" data-totalDocumentos="<%=totalDocumentos%>">
		Abrir Caja
	</span>
<%end if%>
<span class="btn btn-mini btn-danger cierraBotonera" data-codigoBarras="<%=codigoBarras%>" data-botonera="<%=botonera%>" data-estado="<%=idEstado%>" data-porcentaje="<%=enteroPorcentaje%>" data-totalDocumentos="<%=totalDocumentos%>">Cancelar</span>
<script type="text/javascript">
$('.cambiaEstado').click(function() {
	var codigoBarras = $(this).attr('data-codigoBarras');
	var botonera = $(this).attr('data-botonera');
	var valorCambia = $(this).attr('data-nuevoEstado');
	var idUsuario = $.trim($('#idUsuario').val());
	var idUsuarioEnvioCaj = <%=idUsuarioMain%>;
	var idSucursalCaja = <%=idSucursalMain%>;
	var pagina, div, datos;	
	if (valorCambia == '204'){
		$('#modalFecEnvio').modal({
   		keyboard: false,
    	show: true,
        backdrop: true,
        remote: 'CheckListCredito/FechaEnvioCaja.asp?codigoBarras='+codigoBarras+'&valorEstado='+valorCambia+'&idAccion=2&botonera='+botonera+'&idUsuario='+idUsuarioEnvioCaj+'&idSucursalCaja='+idSucursalCaja
  		});

  		$('#modalFecEnvio').on('hidden', function () {
  			var idSucursalCaja = <%=idSucursalMain%>;
			var idUsuarioMainCaja = <%=idUsuarioMain%>;
			$('#listaCajasIng').html('').hide();			
			var pagina = 'CheckListCredito/cajas.asp';
			var div = 'listaCajasIng';
			var datos='idSucursalCaja='+idSucursalCaja+'&idUsuarioMainCaja='+idUsuarioMainCaja;
			enviaDatos(pagina,div,datos)		  
		});
	}
	else{
		var pagina = 'CheckListCredito/sqlCajas.asp';
		var datos = 'codigoBarras='+codigoBarras+'&valorEstado='+valorCambia+'&idAccion=2&botonera='+botonera+'&idUsuario='+idUsuario;
		var div='botonera'+botonera;
		enviaDatos(pagina,div,datos);
	}
	
});
$('.cierraBotonera').click(function(){
	var botonera = $(this).attr('data-botonera');
	var estado = $(this).attr('data-estado');
	var codigoBarras = $(this).attr('data-codigoBarras');
	var porcentaje = $(this).attr('data-porcentaje');
	var totalDocumentos = $(this).attr('data-totalDocumentos');
	$('#botonera'+botonera).html('<span id="btnModifica'+botonera+'" data-idEstado="'+estado+'" class="modificaEstado btn btn-mini btn-danger" data-codigoBarras="'+codigoBarras+'" data-modifica="0" data-porcentaje="'+porcentaje+'" onClick="modificaEstado('+botonera+');" data-botonera="'+botonera+'" data-totalDocumentos="'+totalDocumentos+'">Modificar Estado	</span>');
});
</script>