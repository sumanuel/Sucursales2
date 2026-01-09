<!--#include file="../funciones2.asp"-->
<% periodo = trim(request("periodo"))
idSucursalMain = trim(request("idSucursalMain"))
idUsuarioMain = trim(request("idUsuarioMain"))
perfilMain = trim(request("perfilMain"))

%>
<div class="row-fluid">
	<div class="span12">
		<table class="table table-bordered table-hover table-condensed" id="tablaReporteTotalAlerta" data-periodo="<%=periodo%>" data-usuario="<%=idUsuarioMain%>" data-sucursal="<%=idSucursalMain%>" data-perfil="<%=perfilMain%>">
			<thead>
				<thead>
				<tr>
					<th>
						Concepto
					</th>
					<th>
						Total
					</th>
				</tr>
			</thead>
			<tbody>
				<tr id="procesoSuc">
					<td class="nombreCampo" data-nombreCampo="procesoSuc">
						<span class="label label-success">Proceso Sucursal</span>
					</td>
					<td class="valorProcesoSuc" data-valor="<%=totalProcesoSuc%>">
						<span class="label label-success">
							<!--<%=cint(totalRevisadoCheck)+cint(totalAlerta)+cint(totalCP)%>-->
						</span>
					</td>
				</tr>
				<tr id="colocacionSuc" class="mano" onclick="verDetalle(1,1)">
					<td class="nombreCampo" data-nombreCampo="colocacionSuc">
						<i class="icon-ok-sign"></i>
						Colocaciones
					</td>
					<td class="valorColocacionSuc" data-dato="datoColo">
						 <span id="valorColocacionSuc" class="jsonAct"></span>
					</td>
				</tr>
				<tr id="enValidaSuc" class="mano" onclick="verDetalle(1,2)">
					<td class="nombreCampo" data-nombreCampo="enValidaSuc">
						<i class="icon-minus-sign"></i>
						En validación
					</td>
					<td class="valorEnValidaSuc" data-valor="<%=totalEnValidaSuc%>">
						<span id="valorEnValidaSuc" class="jsonAct"></span>
					</td>
				</tr>
				<tr id="validadoSuc" class="mano" onclick="verDetalle(1,3)">
					<td class="nombreCampo" data-nombreCampo="validadoSuc">
						<i class="icon-home"></i>
						Validado Sucursal
					</td>
					<td class="valorValidadoSuc" data-valor="<%=totalValidadoSuc%>">
						<span id="valorValidadoSuc" class="jsonAct"></span>
					</td>
				</tr>

				<tr id="enNotarioSuc" class="mano" onclick="verDetalle(1,4)">
					<td class="nombreCampo" data-nombreCampo="enNotarioSuc">
						<i class="icon-suitcase"></i>
						En Notario
					</td>
					<td class="valorEnNotarioSuc" data-valor="<%=totalEnNotarioSuc%>">
						<span id="valorEnNotarioSuc" class="jsonAct"></span>
					</td>
				</tr>

				<tr id="recepcionadoNotarioSuc" class="mano" onclick="verDetalle(1,5)">
					<td class="nombreCampo" data-nombreCampo="recepcionadoNotarioSuc">
						<i class="icon-share"></i>
						Recepcionado Notario
					</td>
					<td class="valorRecepcionadoNotarioSuc" data-valor="<%=totalRecepcionadoNotarioSuc%>">
						<span id="valorRecepcionadoNotarioSuc" class="jsonAct"></span>
					</td>
				</tr>
				<tr id="noRecepcionadoNotarioSuc" class="mano" onclick="verDetalle(1,6)">
					<td class="nombreCampo" data-nombreCampo="noRecepcionadoNotarioSuc">
						<i class="icon-warning-sign"></i>
							<span class="label label-important">No Recep Notario</span>
					</td>
					<td class="valorNoRecepcionadoNotarioSuc" data-valor="<%=totalNoRecepcionadoNotarioSuc%>">
						<span id="valorNoRecepcionadoNotarioSuc" class="jsonAct"></span>
					</td>
				</tr>

				<tr id="enviadaSuc" class="mano" onclick="verDetalle(1,7)">
					<td class="nombreCampo" data-nombreCampo="enviadaSuc">
						<i class="icon-truck"></i>
						Enviadas
					</td>
					<td class="valorEnviadaSuc" data-valor="<%=totalEnviadaSuc%>">
						<span id="valorEnviadaSuc" class="jsonAct"></span>
					</td>
				</tr>
				<tr id="procesoCheck">
					<td class="nombreCampo" data-nombreCampo="procesoCheck">
						<span class="label label-success">Proceso de Validación Central</span>
					</td>
					<td class="valorProcesoCheck" data-valor="<%=totalProcesoCheck%>">
						<span class="label label-success">
							<!--<%=cint(totalValidado)+cint(totalAlerta)+cint(totalCP)%>-->
						</span>
					</td>
				</tr>
				<tr id="enValidacionCheck" class="mano" onclick="verDetalle(2,1)">
					<td class="nombreCampo" data-nombreCampo="enValidacionCheck">
						<i class="icon-minus-sign"></i>
						En Validación
					</td>
					<td class="valorEnValidacionCheck" data-valor="<%=totalEnValidacionCheck%>">
						<span id="valorEnValidacionCheck" class="jsonAct"></span>
					</td>
				</tr>
				<tr id="validadoCheck" class="mano" onclick="verDetalle(2,2)">
					<td class="nombreCampo" data-nombreCampo="validadoCheck">
						<i class="icon-ok-sign"></i>
						Validado DMS
					</td>
					<td class="valorValidadoCheck" data-valor="<%=totalValidadoCheck%>">
						<span id="valorValidadoCheck" class="jsonAct"></span>
					</td>
				</tr>
				<tr id="alertaCheck" class="mano" onclick="verDetalle(2,3)">
					<td class="nombreCampo" data-nombreCampo="alertaCheck">
						<i class="icon-warning-sign"></i>
						<span class="label label-important">Alertas</span>
					</td>
					<td class="valorAlertaCheck" data-valor="<%=totalAlertaCheck%>">
						<span id="valorAlertaCheck" class="jsonAct"></span>
					</td>
				</tr>
				<tr id="pendienteCheck">
				<td class="nombreCampo" data-nombreCampo="pendienteCheck">
				<i class="icon-minus"></i>
					<span class="label label-success" class="jsonAct">Pendientes</span>
				</td>
					<td class="valorPendienteCheck" data-valor="<%=totalPendienteCheck%>">
						<span class="label label-success">
							<!--<%=cint(totalValidado)+cint(totalAlerta)+cint(totalCP)%>-->
						</span>
					</td>
				</tr>
				<tr id="recepcionadoCheck" class="mano" onclick="verDetalle(3,1)">
					<td class="nombreCampo" data-nombreCampo="recepcionadoCheck">
						<li>Recepcionado</li>
					</td>
					<td class="valorRecepcionadoCheck" data-valor="<%=totalRecepcionadoCheck%>">
						<span id="valorRecepcionadoCheck" class="jsonAct"></span>
					</td>
				</tr>
				<tr id="noIngresadoCheck" class="mano" onclick="verDetalle(3,2)">
					<td class="nombreCampo" data-nombreCampo="noIngresadoCheck">
						<li>No Ingresado</li>
					<td class="valorNoIngresadoCheck" data-valor="<%=totalRecepcionadoCheck%>">
						<span id="valorNoIngresadoCheck" class="jsonAct"></span>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>

<script type="text/javascript">
$(function(){
	var periodo = $('#tablaReporteTotalAlerta').attr('data-periodo');
	cargaIndicadores();
});
function cargaIndicadores(){
	var idAccion = '';
	var periodo = $('#tablaReporteTotalAlerta').attr('data-periodo');
	var idUsuarioMain = $('#tablaReporteTotalAlerta').attr('data-usuario');
	var idSucursalMain = $('#tablaReporteTotalAlerta').attr('data-sucursal');
	var perfilMain = $('#tablaReporteTotalAlerta').attr('data-perfil');

	idAccion = perfilMain;
	var pagina = 'report/datosTotalAlerta.asp'
	var datos = 'idAccion='+idAccion+'&periodo='+periodo+'&idUsuarioMain='+idUsuarioMain+'&idSucursalMain='+idSucursalMain;
	var loadData = $.ajax({
		url: pagina,
		data: datos,
		type: "GET",
		dataType: "json",
		success: function(source){
			data = source;
			dispatchInfo();
		},
		error: function(dato){
			alert("ERROR");
		}
	});
	var dispatchInfo = function(){
		setTimeout(function() {
			renderData(data);
		}, 200);
	}

	valColo = 0;
	valEnviaSuc = 0;
	valValidadoCheck = 0;

	$('.jsonAct').html('<img src="../cdn/img/loading.gif">');
	var perfilMain = $('#tablaReporteTotalAlerta').attr('data-perfil');
	if (perfilMain === "3"){
		$('#colocacionSuc, #enValidaSuc, #validadoSuc, #validadoSuc, #enviadaSuc, #enValidacionCheck, #validadoCheck, #alertaCheck, #recepcionadoCheck, #noIngresadoCheck, #noRecepcionadoNotarioSuc, #enNotarioSuc, #recepcionadoNotarioSuc').removeClass('mano');
	}else{
		$('#colocacionSuc, #enValidaSuc, #validadoSuc, #validadoSuc, #enviadaSuc, #enValidacionCheck, #validadoCheck, #alertaCheck, #recepcionadoCheck, #noIngresadoCheck, #noRecepcionadoNotarioSuc, #enNotarioSuc, #recepcionadoNotarioSuc').addClass('mano');
	}

	var renderData = function(objectJson){
	//console.log(objectJson);
		//$('.jsonAct').html('-');
		setTimeout(function() {
			$.each(objectJson, function(index, value) {
		    valColo = value.idx_sucColocaciones;
		    valEnviaSuc = value.idx_sucEnviados;
		    valValidadoCheck = value.idx_dmsValidado;
			$('#valorColocacionSuc').html(value.idx_sucColocaciones);
			$('#valorEnValidaSuc').html(value.idx_sucEnValidacion);
			$('#valorValidadoSuc').html(value.idx_sucValidado);
			$('#valorEnNotarioSuc').html(value.idx_SucEnNotario);
			$('#valorRecepcionadoNotarioSuc').html(value.idx_SucRecepNotario);
			$('#valorNoRecepcionadoNotarioSuc').html(value.idx_SucNoRecepNotario);
			$('#valorEnviadaSuc').html(value.idx_sucEnviados);
			$('#valorEnValidacionCheck').html(value.idx_dmsEnValidacion);
			$('#valorValidadoCheck').html(value.idx_dmsValidado);
			$('#valorAlertaCheck').html(value.idx_dmsAlertas);
			$('#valorRecepcionadoCheck').html(value.idx_dmsRecepcionado);
			$('#valorNoIngresadoCheck').html(value.idx_dmsNoIngresado);
		});
			cargaGrafico();
		}, 300);
		//console.log("valColo:" + valColo);
	}
}

function cargaGrafico(){
	var pagina,div,datos;
	pagina = 'report/reporteTotalGraficoAlerta.asp';
	div = 'reporteTotalGraficoAlerta';
	datos ='';
	enviaDatos(pagina,div,datos);
	setTimeout(function() {
		$('#serieColo').attr('data-serie', valColo);
		$('#serieColo').html(valColo);
		$('#valEnviaSuc').attr('data-serie', valEnviaSuc);
		$('#valEnviaSuc').html(valEnviaSuc);
		$('#valValidadoCheck').attr('data-serie', valValidadoCheck);
		$('#valValidadoCheck').html(valValidadoCheck);

		var valorSerieColocacion = [];
		$('#serieColo').each(function(){
			valorSerieColocacion.push(parseInt($(this).attr('data-serie')));
		});

		var valorSerieEnviaSuc = [];
		$('#valEnviaSuc').each(function(){
			valorSerieEnviaSuc.push(parseInt($(this).attr('data-serie')));
		});

		var valorSerieTotalValDMS = [];
		$('#valValidadoCheck').each(function(){
			valorSerieTotalValDMS.push(parseInt($(this).attr('data-serie')));
		});

		$('#graficoTotales').highcharts({
			    chart: {
			        type: 'column',
					width: 700,
					height: 410,
					options3d: {
						enabled: true,
						alpha: -2,
						beta: 30,
						depth: 70
					}
			    },
			    title: {
			        text: 'Validación Integrada de Documentos'
			    },

			    xAxis: {
	            	crosshair: true
				},
			    subtitle: {
			        text: 'DMS - SUCURSALES'
			    },
			    tooltip: {
			        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
			        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
			            '<td style="padding:0"><b>{point.y} </b></td></tr>',
			        footerFormat: '</table>',
			        shared: true,
			        useHTML: true
			    },

			  	plotOptions: {
		            column: {
		                pointPadding: 0.2,
		                borderWidth: 0
		            }
		        },
			    series: [{
			        name: 'Colocación',//$('.nomColocacion').attr('data-nombre'),
			        data: valorSerieColocacion,
			        //type: 'bar'
			    },{
			        name: 'Enviado Sucursal',//$('.nomEnviada').attr('data-nombre'),
			        data: valorSerieEnviaSuc,
			        //type: 'bar'
			    },{
			        name: 'Validado DMS',//$('.nomTotalValDMS').attr('data-nombre'),
			        data: valorSerieTotalValDMS,
			        //type: 'bar'
			    }]
			});
	}, 200);
}

function verDetalle(producto,item)
{
	var perfilMain = $('#tablaReporteTotalAlerta').attr('data-perfil');
	if (perfilMain === "3"){
		$('#divMenuTrabPens').slideDown('fast');
		$('#divReporteDetalleTabla').slideDown('fast');
	}
	else{
		var pagina, div, datos, periodo, idUsuarioMain, idSucursalMain, perfilMain;

		idUsuarioMain = $('#tablaReporteTotalAlerta').attr('data-usuario');
		idSucursalMain = $('#tablaReporteTotalAlerta').attr('data-sucursal');
		perfilMain = $('#tablaReporteTotalAlerta').attr('data-perfil');
		periodo = $('#tablaReporteTotalAlerta').attr('data-periodo');
		pagina = 'report/menuColoTipoTrabPens2.asp';
		div = 'menuTrabPens';
		datos= 'idProducto='+producto+"&idItem="+item+'&periodo='+periodo+'&idUsuarioMain1='+idUsuarioMain+'&idSucursalMain1='+idSucursalMain+'&perfilMain1='+perfilMain;
		enviaDatos(pagina,div,datos);
		$('#listarContenido').slideUp('fast');
		$('#divMenuTrabPens').slideDown('fast');
		$('#divReporteDetalleTabla').slideDown('fast');
	}

}
//Carga los indicadores sin hacer la llamada a los graficos usado en modicaEstado.asp
function cargaIndicadoresCaja(){
	var idAccion = '';
	var periodo = $('#tablaReporteTotalAlerta').attr('data-periodo');
	var idUsuarioMain = $('#tablaReporteTotalAlerta').attr('data-usuario');
	var idSucursalMain = $('#tablaReporteTotalAlerta').attr('data-sucursal');
	var perfilMain = $('#tablaReporteTotalAlerta').attr('data-perfil');

	idAccion = perfilMain;
	var pagina = 'report/datosTotalAlerta.asp'
	var datos = 'idAccion='+idAccion+'&periodo='+periodo+'&idUsuarioMain='+idUsuarioMain+'&idSucursalMain='+idSucursalMain;
	var loadData = $.ajax({
		url: pagina,
		data: datos,
		type: "GET",
		dataType: "json",
		success: function(source){
			data = source;
			dispatchInfo();
		},
		error: function(dato){
			alert("ERROR");
		}
	});
	var dispatchInfo = function(){
		setTimeout(function() {
			renderData(data);
		}, 200);
	}

	valColo = 0;
	valEnviaSuc = 0;
	valValidadoCheck = 0;

	$('.jsonAct').html('<img src="../cdn/img/loading.gif">');
	var perfilMain = $('#tablaReporteTotalAlerta').attr('data-perfil');
	if (perfilMain === "3"){
		$('#colocacionSuc, #enValidaSuc, #validadoSuc, #validadoSuc, #enviadaSuc, #enValidacionCheck, #validadoCheck, #alertaCheck, #recepcionadoCheck, #noIngresadoCheck, #noRecepcionadoNotarioSuc, #enNotarioSuc, #recepcionadoNotarioSuc').removeClass('mano');
	}else{
		$('#colocacionSuc, #enValidaSuc, #validadoSuc, #validadoSuc, #enviadaSuc, #enValidacionCheck, #validadoCheck, #alertaCheck, #recepcionadoCheck, #noIngresadoCheck, #noRecepcionadoNotarioSuc, #enNotarioSuc, #recepcionadoNotarioSuc').addClass('mano');
	}

	var renderData = function(objectJson){
	//console.log(objectJson);
		//$('.jsonAct').html('-');
			$.each(objectJson, function(index, value) {
		    valColo = value.idx_sucColocaciones;
		    valEnviaSuc = value.idx_sucEnviados;
		    valValidadoCheck = value.idx_dmsValidado;
			$('#valorColocacionSuc').html(value.idx_sucColocaciones);
			$('#valorEnValidaSuc').html(value.idx_sucEnValidacion);
			$('#valorValidadoSuc').html(value.idx_sucValidado);
			$('#valorEnNotarioSuc').html(value.idx_SucEnNotario);
			$('#valorRecepcionadoNotarioSuc').html(value.idx_SucRecepNotario);
			$('#valorNoRecepcionadoNotarioSuc').html(value.idx_SucNoRecepNotario);
			$('#valorEnviadaSuc').html(value.idx_sucEnviados);
			$('#valorEnValidacionCheck').html(value.idx_dmsEnValidacion);
			$('#valorValidadoCheck').html(value.idx_dmsValidado);
			$('#valorAlertaCheck').html(value.idx_dmsAlertas);
			$('#valorRecepcionadoCheck').html(value.idx_dmsRecepcionado);
			$('#valorNoIngresadoCheck').html(value.idx_dmsNoIngresado);
		});
		//console.log("valColo:" + valColo);
	}

}

</script>
