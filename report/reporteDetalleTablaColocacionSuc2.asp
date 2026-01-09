<!--#include file="../funciones2.asp"-->
<%idSucursalMain = trim(request("idSucursalMain1"))
idUsuarioMain = trim(request("idUsuarioMain1"))
perfilMain = trim(request("perfilMain1"))
idProducto = trim(request("idProducto"))
idItem = trim(request("idItem"))
periodo = trim(request("periodo"))
numNotario = trim(request("valorNotario"))
idCodigoNotario = trim(request("idCodigoNotario"))
selectIdCodigoNotario = trim(request("selectIdCodigoNotario"))
selectIdCodigoBarra = trim(request("selectIdCodigoBarra"))
%>
<div class="modal hide fade" id="modalCambiaCodigoCaja" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-header">
      <span class="close" data-dismiss="modal" aria-hidden="true">×</span>
        <h3 id="myModalLabel">
          Cambia Codigo
        </h3>
    </div>
    <div class="modal-body"></div>
    <div class="modal-footer">
      <span class="btn btn-danger cierraModal" data-dismiss="modal" >Cerrar</span>
    </div>
  </div>
<div class="modal hide fade" id="modalCheck" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-header">
      	<span class="close" data-dismiss="modal" aria-hidden="true">×</span>
        	<h3 id="myModalLabel">
         	 Check List
        	</h3>
    </div>
    <div class="modal-body"></div>
    <div class="modal-footer">
      <span class="btn btn-danger" data-dismiss="modal" >Cerrar</span>
      <!--<span class="btn btn-info" onClick="paso2Check();" id="botonPaso2Modal">Modificar caja</span>-->
    </div>
</div>

<table id="tablaDetalleColocacion2" class="table table-bordered table-hover table-condensed table-striped" data-perfil="<%=perfilMain%>" data-usuario="<%=idUsuarioMain%>" data-sucursal="<%=idSucursalMain%>" data-periodo="<%=periodo%>"data-idProducto="<%=idProducto%>" data-idItem="<%=idItem%>" data-numNotario="<%=numNotario%>" data-idCodigoNotario="<%=idCodigoNotario%>" data-selectIdCodigoNotario="<%=selectIdCodigoNotario%>" data-selectIdCodigoBarra="<%=selectIdCodigoBarra%>">
<thead>
<tr>
	<th><strong>Carpeta</strong></th>
	<th><strong>Numero Crédito</strong></th>
	<th><strong>Fecha Colocación</strong></th>
	<th><strong>Sucursal</strong></th>
	<th><strong>Rut Cliente</strong></th>
	<th><strong>Numero Caja</strong></th>
	<th><strong>%</strong></th>
    <th><strong>Accion</strong></th>
    <td></td>
    <td></td>
</tr>
</thead>
<tbody>
<script type="text/javascript">
$(document).ready(function (){
	var idAccion = '';
	var periodo, idUsuarioMain, idSucursalMain, perfilMain, idProducto, idItem, numNotario, idCodigoNotario, selectIdCodigoBarra;
	periodo = $('#tablaDetalleColocacion2').attr('data-periodo');
	idUsuarioMain = $('#tablaDetalleColocacion2').attr('data-usuario');
	idSucursalMain = $('#tablaDetalleColocacion2').attr('data-sucursal');
	perfilMain = $('#tablaDetalleColocacion2').attr('data-perfil');
	idProducto = $('#tablaDetalleColocacion2').attr('data-idProducto');
	idItem = $('#tablaDetalleColocacion2').attr('data-idItem');
	numNotario = $('#tablaDetalleColocacion2').attr('data-numNotario');
	idCodigoNotario = $('#tablaDetalleColocacion2').attr('data-idCodigoNotario');
	selectIdCodigoNotario = $('#tablaDetalleColocacion2').attr('data-selectIdCodigoNotario');
	selectIdCodigoBarra = $('#tablaDetalleColocacion2').attr('data-selectIdCodigoBarra');
	idAccion = perfilMain;
	var url = 'report/datosTotalDetalleSuc.asp?periodo='+periodo+'&idSucursalMain1='+idSucursalMain+'&idUsuarioMain1='+idUsuarioMain+'&perfilMain1='+perfilMain+'&idProducto='+idProducto+'&idItem='+idItem+'&idAccion='+idAccion+'&selectIdCodigoNotario='+selectIdCodigoNotario;
	$('#tablaDetalleColocacion2').dataTable( {
	    "ajax": url,    
	    "sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
	    "sPaginationType": "bootstrap",
	        "columns": [
	            { "data": "idCarpeta" },
	            { "data": "numCredito"},
	            { "data": "fechaColocacion" },            
	            { "data": "nomSucursal" },
	            { "data": "rutCliente" },
	            { "data": "numCaja" },         
	            { "data": "totalPorcentaje" },
	            {
	                data: null,
	                className: "center",
	                defaultContent: '<span class="botonera"></span>'
	            },
	            { "data": "alerta" },
	            { "data": "estadoCaja" }
	          ]       
	});

	$('#tablaDetalleColocacion2').on( 'draw.dt', function() {
		$('#tablaDetalleColocacion2 tbody > tr').each(function(){
			var perfilMain = $('#tablaDetalleColocacion2').attr('data-perfil');
			var numNotario = $('#tablaDetalleColocacion2').attr('data-numNotario');
		 	var idCarpeta = $('td:eq(0)', this).text();
		 	var numCaja = $('td:eq(5)', this).text();
		 		if (idCarpeta != "---"){
		 			var idEstadoNotario = $(this).attr('data-idEstadoNotario');
		 			var tipoInsDel = $(this).attr('data-tipoInsDel');
		 			var estadoCaja = $('td:eq(9)', this).text();
		 			var alerta = $('td:eq(8)', this).text();
		 			var pCheck = $('td:eq(6)', this).text();
		 			if(pCheck === "100%" && idEstadoNotario === "0"){
		 				if (numNotario !== '' || parseInt(numNotario) > 0){	
		 					$('td:eq(7)', this).html('<span class="label label-info ayuda mano" onClick="abreModalCheck('+idCarpeta+');" title="CheckList"><i class="icon-check-sign"></i></span> <span class = "ayuda mano" id="spanAgregaCarpeta_'+idCarpeta+'" data-tipoInsDel="'+tipoInsDel+'" onClick="addCarpetaNumNotario('+idCarpeta+');" title="Agrega Carpeta a Envío Notario"><i class="icon-plus-sign icon-large"></i></span>');
		 				}else{
		 					$('td:eq(7)', this).html('<span class="label label-info ayuda mano" onClick="abreModalCheck('+idCarpeta+');" title="CheckList"><i class="icon-check-sign"></i></span>');
		 					$('#btnEnviaNotario').hide();
		 				}
					}else if (pCheck !== "100%" && idEstadoNotario === "0"){
						$('td:eq(7)', this).html('<span class="label label-info ayuda mano" onClick="abreModalCheck('+idCarpeta+');" title="CheckList"><i class="icon-check-sign"></i></span>');
						$('#btnEnviaNotario').hide();

					}else if(pCheck === "100%" && idEstadoNotario === "1" && idItem === "1"){
						$('td:eq(7)', this).html('<span class="label label-info ayuda mano" onClick="abreModalCheck('+idCarpeta+');" title="CheckList"><i class="icon-check-sign"></i></span>');
					
					}else if(pCheck === "100%" && idEstadoNotario === "3" && idItem === "1"){
						$('td:eq(7)', this).html('<span class="label label-important ayuda mano" onClick="abreModalCheck('+idCarpeta+');" title="CheckList"><i class="icon-check-sign"></i></span>');

					}else if(pCheck === "100%" && idEstadoNotario === "2"){
						$('td:eq(7)', this).html('<span class="label label-success ayuda mano" onClick="abreModalCheck('+idCarpeta+');" title="CheckList"><i class="icon-check-sign"></i></span>  <span class="label label-info ayuda mano" onClick="modalCambioCaja('+idCarpeta+','+numCaja+',202);" title="Modifica Caja"><i class="icon-archive"></i></span>');

					}else if (pCheck === "100%" && idEstadoNotario === "1" && idItem === "4"){
						$('td:eq(7)', this).html('<span class="label label-info ayuda mano" onClick="enNotario('+idCarpeta+','+idEstadoNotario+');" id="spanEnviaNotario_'+idCarpeta+'"data-tipoInsDel="'+tipoInsDel+'" title="Recepcionar"><i class="icon-circle-arrow-left icon-large"></i></span> <span class="label label-important ayuda mano" onClick="enNotarioNoRecep('+idCarpeta+','+idEstadoNotario+');" id="spanEnNotarioNoRecep_'+idCarpeta+'"data-tipoInsDel="'+tipoInsDel+'" title="No Recep Notario"><i class="icon-exclamation-sign icon-large"></i></span>');
						$('#divSelectNumNotario').show();	


					}else if (pCheck === "100%" && idEstadoNotario === "3" && idItem === "6"){
						$('td:eq(7)', this).html('<span class="label label-info ayuda mano" onClick="noRecepNotarioRecep('+idCarpeta+','+idEstadoNotario+');" id="spanNoRecepNotario_'+idCarpeta+'"data-tipoInsDel="'+tipoInsDel+'" title="Recepcionar"><i class="icon-circle-arrow-left icon-large"></i></span> <span class="label label-important ayuda mano" onClick="noRecepEnNotario('+idCarpeta+','+idEstadoNotario+');" id="spanNoRecepEnNotario_'+idCarpeta+'"data-tipoInsDel="'+tipoInsDel+'" title="En Notario"><i class="icon-exclamation-sign icon-large"></i></span>');
						$('#divSelectNumNotario').show();	
					}
					if(estadoCaja === "204" || estadoCaja === "203"){
						if (alerta === "1"){
							$('td:eq(7)', this).html('<span class="label label-important ayuda mano" onClick="abreModalCheck('+idCarpeta+');" title="CheckList"><i class="icon-check-sign"></i></span>');
						}else{
							$('td:eq(7)', this).html('<span class="label label-info ayuda mano" onClick="abreModalCheck('+idCarpeta+');" title="CheckList"><i class="icon-check-sign"></i></span>');	
						}
					}else if (estadoCaja === "202" && pCheck !== "100%"){
						$('td:eq(7)', this).html('<span class="label label-info ayuda mano" onClick="abreModalCheck('+idCarpeta+');" title="CheckList"><i class="icon-check-sign"></i></span>');	
					}

					if (pCheck != "--") {
						if (pCheck === "100%") {
							$('td:eq(6)', this).html('<span class="label label-success">'+pCheck+'</span>');
						}else if (pCheck != "100%") {
							$('td:eq(6)', this).html('<span class="label label-important">'+pCheck+'</span>');
						}
					}

					if (tipoInsDel === "0" && idEstadoNotario === "0"){
						$('#spanAgregaCarpeta_'+idCarpeta).html('<span class = "ayuda mano" id="spanAgregaCarpeta_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'" title="Agrega Carpeta a Envío Notario"><i class="icon-plus-sign icon-large"></i></span>');
					}else if (tipoInsDel === "1" && idEstadoNotario === "0"){
						$('#spanAgregaCarpeta_'+idCarpeta).html('<span class = "ayuda mano" id="spanAgregaCarpeta_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'" title="Quita Carpeta a Envío Notario"><i class="icon-minus-sign icon-large"></i></span>');
						$('#btnEnviaNotario').show();
					}
					if(estadoCaja !== "204" || estadoCaja !== "203"){
						if (selectIdCodigoBarra !== '' || parseInt(selectIdCodigoBarra) > 0){	
		 					$('td:eq(7)', this).html('<span class="label label-success ayuda mano" onClick="abreModalCheck('+idCarpeta+');" title="CheckList"><i class="icon-check-sign"></i></span> <span class="label label-info ayuda mano" onClick="modalCambioCaja('+idCarpeta+','+numCaja+',202);" title="Modifica Caja"><i class="icon-archive"></i></span> <span class = "ayuda mano" id="spanAgregaCarpeta_'+idCarpeta+'" data-tipoAgregaCarpeta="'+tipoInsDel+'" onClick="addCarpetaCaja('+idCarpeta+','+selectIdCodigoBarra+');" title="Agrega Carpeta a Caja"><i class="icon-plus-sign icon-large"></i></span>');
		 				}
		 			}
					$('td:nth-child(9),th:nth-child(9)').hide();
					$('td:nth-child(10),th:nth-child(10)').hide();
				}else{
					$('td:eq(7)', this).html('---');
					$('td:nth-child(9),th:nth-child(9)').hide();
					$('td:nth-child(10),th:nth-child(10)').hide();
				}	
			
		});	
		
	});
});

function addCarpetaNumNotario(idCarpeta){
	var idUsuarioMain, idSucursalMain, perfilMain, numNotario, tipoInsDel, idCodigoNotario, pagina, div, datos;
	periodo = $('#tablaDetalleColocacion2').attr('data-periodo');
	idUsuarioMain = $('#tablaDetalleColocacion2').attr('data-usuario');
	idSucursalMain = $('#tablaDetalleColocacion2').attr('data-sucursal');
	perfilMain = $('#tablaDetalleColocacion2').attr('data-perfil');
	numNotario = $('#tablaDetalleColocacion2').attr('data-numNotario');
	tipoInsDel = $('#spanAgregaCarpeta_'+idCarpeta).attr('data-tipoInsDel');
	idCodigoNotario = $('#tablaDetalleColocacion2').attr('data-idCodigoNotario');

	if (tipoInsDel === "0"){
		$('#btnEnviaNotario').show();
		$('#spanAgregaCarpeta_'+idCarpeta).attr('data-tipoInsDel','1');
		$('#spanAgregaCarpeta_'+idCarpeta).html('<span class = "ayuda mano" id="spanAgregaCarpeta_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'"title="Quita Carpeta a Envío Notario"><i class="icon-minus-sign icon-large"></i></span>');
		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'msgAddInsCred';
		datos='action=3&idUsuarioMain1='+idUsuarioMain+'&numNotario='+numNotario+'&idCarpeta='+idCarpeta+'&tipoInsDel='+tipoInsDel+'&idSucursalMain1='+idSucursalMain+'&idCodigoNotario='+idCodigoNotario;
		enviaDatos(pagina,div,datos);	
	}else{
		$('#spanAgregaCarpeta_'+idCarpeta).attr('data-tipoInsDel','0');
		$('#spanAgregaCarpeta_'+idCarpeta).html('<span class = "ayuda mano" id="spanAgregaCarpeta_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'" title="Agrega Carpeta a Envío Notario"><i class="icon-plus-sign icon-large"></i></span>');
		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'msgAddInsCred';
		datos='action=3&idUsuarioMain1='+idUsuarioMain+'&numNotario='+numNotario+'&idCarpeta='+idCarpeta+'&tipoInsDel='+tipoInsDel+'&idSucursalMain1='+idSucursalMain+'&idCodigoNotario='+idCodigoNotario;
		enviaDatos(pagina,div,datos);
	
	}
}

function enNotario(idCarpeta, idEstadoNotario){
	var idUsuarioMain, idSucursalMain, perfilMain, tipoInsDel, selectIdCodigoNotario, pagina, div, datos ;
	periodo = $('#tablaDetalleColocacion2').attr('data-periodo');
	idUsuarioMain = $('#tablaDetalleColocacion2').attr('data-usuario');
	idSucursalMain = $('#tablaDetalleColocacion2').attr('data-sucursal');
	perfilMain = $('#tablaDetalleColocacion2').attr('data-perfil');
	tipoInsDel = $('#spanEnviaNotario_'+idCarpeta).attr('data-tipoInsDel');
	selectIdCodigoNotario = $('#tablaDetalleColocacion2').attr('data-selectIdCodigoNotario');

	if (tipoInsDel === "1"){
		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'msgAddInsCred';
		datos='action=5&idUsuarioMain1='+idUsuarioMain+'&idCarpeta='+idCarpeta+'&tipoInsDel='+tipoInsDel+'&idSucursalMain1='+idSucursalMain+'&selectIdCodigoNotario='+selectIdCodigoNotario+'&idEstadoNotario='+idEstadoNotario;
		enviaDatos(pagina,div,datos);	
		$('#spanEnviaNotario_'+idCarpeta).attr('data-tipoInsDel','0');
		$('#spanEnviaNotario_'+idCarpeta).html('<span class="ayuda mano" id="spanEnviaNotario_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'" title="En Notario"><i class="icon-check-sign icon-large"></i></span>').removeClass('label-info').addClass('label-success');
	}else{
		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'msgAddInsCred';
		datos='action=5&idUsuarioMain1='+idUsuarioMain+'&idCarpeta='+idCarpeta+'&tipoInsDel='+tipoInsDel+'&idSucursalMain1='+idSucursalMain+'&selectIdCodigoNotario='+selectIdCodigoNotario+'&idEstadoNotario='+idEstadoNotario;
		enviaDatos(pagina,div,datos);
		$('#spanEnviaNotario_'+idCarpeta).attr('data-tipoInsDel','1');
		$('#spanEnviaNotario_'+idCarpeta).html('<span class = "ayuda mano" id="spanEnviaNotario_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'" title="Recepcionar"><i class="icon-circle-arrow-left icon-large"></i></span>').removeClass('label-success').addClass('label-info');
	}		
}

function noRecepNotarioRecep(idCarpeta, idEstadoNotario){
	var idUsuarioMain, idSucursalMain, perfilMain, tipoInsDel, selectIdCodigoNotario, pagina, div, datos;
	periodo = $('#tablaDetalleColocacion2').attr('data-periodo');
	idUsuarioMain = $('#tablaDetalleColocacion2').attr('data-usuario');
	idSucursalMain = $('#tablaDetalleColocacion2').attr('data-sucursal');
	perfilMain = $('#tablaDetalleColocacion2').attr('data-perfil');
	tipoInsDel = $('#spanNoRecepNotario_'+idCarpeta).attr('data-tipoInsDel');
	selectIdCodigoNotario = $('#tablaDetalleColocacion2').attr('data-selectIdCodigoNotario');
	if (tipoInsDel === "1"){
		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'msgAddInsCred';
		datos='action=5&idUsuarioMain1='+idUsuarioMain+'&idCarpeta='+idCarpeta+'&tipoInsDel='+tipoInsDel+'&idSucursalMain1='+idSucursalMain+'&selectIdCodigoNotario='+selectIdCodigoNotario+'&idEstadoNotario='+idEstadoNotario;
		enviaDatos(pagina,div,datos);	
		$('#spanNoRecepNotario_'+idCarpeta).attr('data-tipoInsDel','0');
		$('#spanNoRecepNotario_'+idCarpeta).html('<span class="ayuda mano" id="spanNoRecepNotario_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'"title="Recepcionar"><i class="icon-check-sign icon-large"></i></span>').removeClass('label-info').addClass('label-success');
	}else{
		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'msgAddInsCred';
		datos='action=5&idUsuarioMain1='+idUsuarioMain+'&idCarpeta='+idCarpeta+'&tipoInsDel='+tipoInsDel+'&idSucursalMain1='+idSucursalMain+'&selectIdCodigoNotario='+selectIdCodigoNotario+'&idEstadoNotario='+idEstadoNotario;
		enviaDatos(pagina,div,datos);
		$('#spanNoRecepNotario_'+idCarpeta).attr('data-tipoInsDel','1');
		$('#spanNoRecepNotario_'+idCarpeta).html('<span class = "ayuda mano" id="spanNoRecepNotario_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'" title="No Recepcionar"><i class="icon-circle-arrow-left icon-large"></i></span>').removeClass('label-success').addClass('label-info');
	}		
}

function addCarpetaCaja (idCarpeta, selectIdCodigoBarra){
	var idUsuarioMain, idSucursalMain, perfilMain, tipoInsDel, pagina, div, datos;
	periodo = $('#tablaDetalleColocacion2').attr('data-periodo');
	idUsuarioMain = $('#tablaDetalleColocacion2').attr('data-usuario');
	idSucursalMain = $('#tablaDetalleColocacion2').attr('data-sucursal');
	perfilMain = $('#tablaDetalleColocacion2').attr('data-perfil');
	tipoInsDel = $('#spanAgregaCarpeta_'+idCarpeta).attr('data-tipoAgregaCarpeta');
	//console.log('tipoAgregaCarpeta'+tipoInsDel);
	if (tipoInsDel === "1"){
		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'msgAddInsCred';
		datos='action=6&idUsuarioMain1='+idUsuarioMain+'&idCarpeta='+idCarpeta+'&tipoInsDel='+tipoInsDel+'&idSucursalMain1='+idSucursalMain+'&selectIdCodigoBarra='+selectIdCodigoBarra;
		enviaDatos(pagina,div,datos);	
		$('#spanAgregaCarpeta_'+idCarpeta).attr('data-tipoAgregaCarpeta','0');
		$('#spanAgregaCarpeta_'+idCarpeta).html('<span class="ayuda mano" id="spanAgregaCarpeta_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'"title="Quita Carpeta a Caja""><i class="icon-minus-sign icon-large"></i></span>');
		$('#'+idCarpeta+' > td:eq( 5 )').html(selectIdCodigoBarra);
	}else{
		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'msgAddInsCred';
		datos='action=6&idUsuarioMain1='+idUsuarioMain+'&idCarpeta='+idCarpeta+'&tipoInsDel='+tipoInsDel+'&idSucursalMain1='+idSucursalMain+'&selectIdCodigoBarra='+selectIdCodigoBarra;
		enviaDatos(pagina,div,datos);
		$('#spanAgregaCarpeta_'+idCarpeta).attr('data-tipoAgregaCarpeta','1');
		$('#spanAgregaCarpeta_'+idCarpeta).html('<span class = "ayuda mano" id="spanAgregaCarpeta_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'" title="Agrega Carpeta a Caja"><i class="icon-plus-sign icon-large"></i></span>');
		$('#'+idCarpeta+' > td:eq( 5 )').html('0');
	}		
}

function enNotarioNoRecep(idCarpeta, idEstadoNotario){
	var idUsuarioMain, idSucursalMain, perfilMain, tipoInsDel, selectIdCodigoNotario, pagina, div, datos ;
	periodo = $('#tablaDetalleColocacion2').attr('data-periodo');
	idUsuarioMain = $('#tablaDetalleColocacion2').attr('data-usuario');
	idSucursalMain = $('#tablaDetalleColocacion2').attr('data-sucursal');
	perfilMain = $('#tablaDetalleColocacion2').attr('data-perfil');
	tipoInsDel = $('#spanEnNotarioNoRecep_'+idCarpeta).attr('data-tipoInsDel');
	selectIdCodigoNotario = $('#tablaDetalleColocacion2').attr('data-selectIdCodigoNotario');

	if (tipoInsDel === "1"){
		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'msgAddInsCred';
		datos='action=7&idUsuarioMain1='+idUsuarioMain+'&idCarpeta='+idCarpeta+'&tipoInsDel='+tipoInsDel+'&idSucursalMain1='+idSucursalMain+'&selectIdCodigoNotario='+selectIdCodigoNotario+'&idEstadoNotario='+idEstadoNotario;
		enviaDatos(pagina,div,datos);	
		$('#spanEnNotarioNoRecep_'+idCarpeta).attr('data-tipoInsDel','0');
		$('#spanEnNotarioNoRecep_'+idCarpeta).html('<span class="ayuda mano" id="spanEnNotarioNoRecep_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'" title="En Notario"><i class="icon-check-sign icon-large"></i></span>').removeClass('label-important').addClass('label-warning');
	}else{
		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'msgAddInsCred';
		datos='action=7&idUsuarioMain1='+idUsuarioMain+'&idCarpeta='+idCarpeta+'&tipoInsDel='+tipoInsDel+'&idSucursalMain1='+idSucursalMain+'&selectIdCodigoNotario='+selectIdCodigoNotario+'&idEstadoNotario='+idEstadoNotario;
		enviaDatos(pagina,div,datos);
		$('#spanEnNotarioNoRecep_'+idCarpeta).attr('data-tipoInsDel','1');
		$('#spanEnNotarioNoRecep_'+idCarpeta).html('<span class = "ayuda mano" id="spanEnNotarioNoRecep_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'" title="No Recep Notario"><i class="icon-exclamation-sign icon-large"></i></span>').removeClass('label-warning').addClass('label-important');
	}		
}

function noRecepEnNotario(idCarpeta, idEstadoNotario){
	var idUsuarioMain, idSucursalMain, perfilMain, tipoInsDel, selectIdCodigoNotario, pagina, div, datos ;
	periodo = $('#tablaDetalleColocacion2').attr('data-periodo');
	idUsuarioMain = $('#tablaDetalleColocacion2').attr('data-usuario');
	idSucursalMain = $('#tablaDetalleColocacion2').attr('data-sucursal');
	perfilMain = $('#tablaDetalleColocacion2').attr('data-perfil');
	tipoInsDel = $('#spanNoRecepEnNotario_'+idCarpeta).attr('data-tipoInsDel');
	selectIdCodigoNotario = $('#tablaDetalleColocacion2').attr('data-selectIdCodigoNotario');

	if (tipoInsDel === "1"){
		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'msgAddInsCred';
		datos='action=8&idUsuarioMain1='+idUsuarioMain+'&idCarpeta='+idCarpeta+'&tipoInsDel='+tipoInsDel+'&idSucursalMain1='+idSucursalMain+'&selectIdCodigoNotario='+selectIdCodigoNotario+'&idEstadoNotario='+idEstadoNotario;
		enviaDatos(pagina,div,datos);	
		$('#spanNoRecepEnNotario_'+idCarpeta).attr('data-tipoInsDel','0');
		$('#spanNoRecepEnNotario_'+idCarpeta).html('<span class="ayuda mano" id="spanNoRecepEnNotario_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'" title="No Recep Notario"><i class="icon-check-sign icon-large"></i></span>').removeClass('label-important').addClass('label-warning');
	}else{
		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'msgAddInsCred';
		datos='action=8&idUsuarioMain1='+idUsuarioMain+'&idCarpeta='+idCarpeta+'&tipoInsDel='+tipoInsDel+'&idSucursalMain1='+idSucursalMain+'&selectIdCodigoNotario='+selectIdCodigoNotario+'&idEstadoNotario='+idEstadoNotario;
		enviaDatos(pagina,div,datos);
		$('#spanNoRecepEnNotario_'+idCarpeta).attr('data-tipoInsDel','1');
		$('#spanNoRecepEnNotario_'+idCarpeta).html('<span class = "ayuda mano" id="spanNoRecepEnNotario_'+idCarpeta+' data-tipoInsDel="'+tipoInsDel+'" title="En Notario"><i class="icon-exclamation-sign icon-large"></i></span>').removeClass('label-warning').addClass('label-important');
	}		
}

function abreModalCheck(idCarpeta){
	var idUsuarioMain, idSucursalMain, perfilMain;
	idUsuarioMain = $('#tablaDetalleColocacion2').attr('data-usuario');
	idSucursalMain = $('#tablaDetalleColocacion2').attr('data-sucursal');
	perfilMain = $('#tablaDetalleColocacion2').attr('data-perfil');
	$('#modalCheck').attr('data-idCarpeta', idCarpeta);
	$('#modalCheck').modal({
	keyboard: false,
	show: true,
	backdrop: true,
	remote: 'report/checkList.asp?idCarpeta='+idCarpeta+'&idUsuarioMain1='+idUsuarioMain+'&perfilMain1='+perfilMain+'&idSucursalMain1='+idSucursalMain
	});
	$('#'+idCarpeta+' > td:eq( 6 )').addClass('modificaCheck'+idCarpeta);
}

$('#modalCheck').on('hidden', function () {
	var pagina, div, datos, idCarpeta, codigoBarras, idUsuarioMain;
	idUsuarioMain = $.trim($('#idUsuarioMain').val());
	idCarpeta = $('#modalCheck').attr('data-idCarpeta');
	codigoBarras = $.trim($('#codigoBarras'+idCarpeta).text()); 
	$(this).removeData('modal');
	pagina = 'report/porcentajeCheckCarpeta.asp';
	div = 'modificaCheck'+idCarpeta;
	datos='idCarpeta='+idCarpeta+'&idUsuarioMain1='+idUsuarioMain+'&codigoBarras='+codigoBarras;
	enviaDatosClase(pagina,div,datos);
});

function modalCambioCaja(idCarpeta){
    var idUsuarioMain, idSucursalMain, perfilMain;
    idUsuarioMain = $('#tablaDetalleColocacion2').attr('data-usuario');
    idSucursalMain = $('#tablaDetalleColocacion2').attr('data-sucursal');
    perfilMain = $('#tablaDetalleColocacion2').attr('data-perfil');	
    var codigoBarra = $('#'+idCarpeta+' > td:eq(5)').html();	
    $('#modalCambiaCodigoCaja').attr('data-idCarpeta',idCarpeta);
    $('#modalCambiaCodigoCaja').attr('data-codigoBarra',codigoBarra);
    $('#modalCambiaCodigoCaja').modal({
	 keyboard: false,
	 show: true,
	 backdrop: true,	
	 remote: 'report/cambiaValorCaja.asp?idCarpeta='+idCarpeta+'&idUsuarioMain1='+idUsuarioMain+'&perfilMain1='+perfilMain+'&idSucursalMain1='+idSucursalMain
	});
	$('#'+idCarpeta+ '> td:eq( 5 )').addClass('modificaCarpeta'+idCarpeta);
}

$('#modalCambiaCodigoCaja').on('hidden', function(){	
	var pagina, div, datos, idCarpeta, codigoBarra;
	codigoBarra = $('#modalCambiaCodigoCaja').attr('data-codigoBarra');
	idCarpeta = $('#modalCambiaCodigoCaja').attr('data-idCarpeta');
	$(this).removeData('modal');
	pagina = 'report/buscaValorCaja.asp';
	div = 'modificaCarpeta'+idCarpeta;
	datos = 'action=1&idCarpeta='+idCarpeta;
	enviaDatosClase(pagina,div,datos);
	$('#btnModalCodigo'+idCarpeta).attr('onClick','modalCambioCaja('+idCarpeta+','+codigoBarra+',202);');
});

</script>