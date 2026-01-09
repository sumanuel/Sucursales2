<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones.asp"-->
<%
dim usuarioLog
usuarioLog = "test"

'Obtener listado de sucursales para el dropdown
sql = ""
sql = sql & " select id_sucursal, cod_bantotal, suc_nombre from SUC_sucursal order by suc_nombre "
set rs = db.execute(sql)
if not rs.eof then
    datos = rs.GetRows()
end if
%>
<!DOCTYPE html>
<html lang="es">
<head>
	<meta charset="utf-8">
    <title>Sucursales</title>
    <link href="../css/bootstrap.css" rel="stylesheet" type="text/css">
    <link href="../css/estilo.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="../css/font-awesome.min.css" type="text/css">
    <script src="../js/jquery.js" type="text/javascript"></script>
</head>
<body topmargin="0">
	<div id="MarcoGeneral">
        <div id="Limite"></div>
        <div id="Central">
            <div id="Central">
            <div id="Central_Columna_mensual2">
            </br>
                <div class="row-fluid">
                <div class="span1">&nbsp;</div>
                    <span class="span10">
                        <span class="">
                            <a class="btn btn-danger btnCuadroDeControl" href="#">
                                <i class="icon-user icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>CONTROL CAJEROS TITULARES</b></span>
                            </a>
                        </span>
                        
                        &nbsp;&nbsp;
                        <span class="">
                            <a class="btn btn-danger btnControlOnline oculto" href="#" id="btnControlOnline">
                                <i class="icon-user icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>CONTROL ONLINE</b></span>
                            </a>
                        </span>

                        &nbsp;&nbsp;
                        <span class="">
                            <a class="btn btn-primary oculto btnCuadroDeControlMes" id="btnCuadroDeControlMes" href="#">
                                <i class="icon-user icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>CONTROL CIERRE MES</b></span>
                            </a>
                        </span>
                        &nbsp;&nbsp;
                        <span class="">
                            <a class="btn btn-warning oculto btnVolverAdmini" href="#">
                                <i class="icon-arrow-left icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>VOLVER AL INICIO</b></span>
                            </a>
                        </span>

                        <span class="">
                            <a class="btn btn-danger btnCuadroDeControl2" id="btnCuadroDeControl2" href="#">
                                <i class="icon-user icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>CONTROL CAJEROS ADICIONALES</b></span>
                            </a>
                        </span>
                        &nbsp;&nbsp;
                        <span class="">
                            <a class="btn btn-primary oculto btnCuadroControlAdMes" href="#">
                                <i class="icon-user icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>CONTROL CIERRE MES ADICIONALES</b></span>
                            </a>
                        </span>
                        &nbsp;&nbsp;
                        <span class="btnGestionCasos" id="btnGestionCasos">
                            <a class="btn btn-danger" href="#">
                                <i class="icon-book icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>GESTION DE CASOS (GRAFICO)</b></span>
                            </a>
                        </span>
                        <span class="btnGestionCasos2 oculto" id="btnGestionCasos2">
                            <a class="btn btn-primary btnGestionCasos2s" href="#">
                                <i class="icon-book icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>GESTION DE CASOS (GRAFICO)</b></span>
                            </a>
                        </span>
                        &nbsp;&nbsp;
                         <span class="btnGestionCasosDetalle oculto" id="btnGestionCasosDetalle">
                            <a class="btn btn-danger btnGestionCasosDetalles" id="btnGestionCasosDetalles" href="#">
                                <i class="icon-book icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>GESTION DE CASOS (DETALLE)</b></span>
                            </a>
                        </span>
                        &nbsp;&nbsp;
                         <span class="btnGestionCasosDetalle2 oculto" id="btnGestionCasosDetalle2">
                            <a class="btn btn-primary btnGestionCasosDetalle2s" id="btnGestionCasosDetalles" href="#">
                                <i class="icon-book icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>GESTION DE CASOS (DETALLE)</b></span>
                            </a>
                        </span>
                        &nbsp;&nbsp;
                        <span class="">
                            <a class="btn btn-warning btnVolverAdmini3 oculto" id="btnVolverAdmini3" href="#">
                                <i class="icon-arrow-left icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>VOLVER AL INICIO</b></span>
                            </a>
                        </span>
                        &nbsp;&nbsp;
                        <span class="">
                            <a class="btn btn-warning oculto btnVolverAdmini2" href="#">
                                <i class="icon-arrow-left icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>VOLVER AL INICIO</b></span>
                            </a>
                        </span>
                        &nbsp;&nbsp;
                        <span class="btnGestionProveedores" id="btnGestionProveedores">
                            <a class="btn btn-info" href="#">
                                <i class="icon-truck icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>GESTION DE PROVEEDORES</b></span>
                            </a>
                        </span>
                        &nbsp;&nbsp;
                        <span class="">
                            <a class="btn btn-warning oculto btnVolverAdmini4" href="#">
                                <i class="icon-arrow-left icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>VOLVER AL INICIO</b></span>
                            </a>
                        </span>
                        &nbsp;&nbsp;
                        <span class="btnSolicitudCajerosAdicionales" id="btnSolicitudCajerosAdicionales">
                            <a class="btn btn-success" href="#">
                                <i class="icon-calendar icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>SOLICITUD CAJEROS ADICIONALES</b></span>
                            </a>
                        </span>
                        &nbsp;&nbsp;
                        <span class="">
                            <a class="btn btn-warning oculto btnVolverAdmini5" href="#">
                                <i class="icon-arrow-left icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>VOLVER AL INICIO</b></span>
                            </a>
                        </span>
                    </span>
                </div>
                <br/>
                <div class="row-fluid dvTbCuadroDeControl oculto" id="dvTbCuadroDeControl">
                    <div class="span1">&nbsp;</div>
                    <div class="span10" id="tbCuadroDeControl"></div>
                </div>
                <br/>
                <div class="row-fluid dvTbAsistCajeros oculto" id="dvTbAsistCajeros">
                    <div class="span1">&nbsp;</div>
                    <div class="span10" id="tbAsistCajeros"></div>
                </div>
                <br/>
                <div class="row-fluid dvTbGestionProveedores oculto" id="dvTbGestionProveedores">
                    <div class="span1">&nbsp;</div>
                    <div class="span10" id="tbGestionProveedores"></div>
                </div>
                <br/>
                <div class="row-fluid dvTbSolicitudCajerosAdicionales oculto" id="dvTbSolicitudCajerosAdicionales">
                    <div class="span1">&nbsp;</div>
                    <div class="span10" id="tbSolicitudCajerosAdicionales"></div>
                </div>
            </div>

        	<div id="Central_Columna_mensual" class="row-fluid">
                <div class="span12">
            	<br />
                	<div class="row-fluid">
                        <div class="span1"></div>
                        <div class="span10 alert alert-info pagination pagination-centered">
                            <h4>Personal Titular</h4>
                        </div>
                    </div>
                    <div class="row-fluid">
                    	<div class="span1">&nbsp;</div>
                        <div class="span10">
                        	<span class="">
                                <a class="btn btn-warning excelTitulares" href="#">
                                    <i class="icon-cloud-download icon-large"></i>
                                    &nbsp;&nbsp;Personal Titular
                                </a>
                            </span>
                            <span class="">
                                <a class="btn btn-primary titulares_paso1"  href="#myModal" data-toggle="modal">
                                    <i class="icon-upload-alt icon-large"></i>
                                    &nbsp;&nbsp;Paso 1: subir listado titulares
                                </a>
                            </span>
                            <span class="">
                                <a class="btn btn-info titulares_paso2 oculto" href="#">
                                    <i class="icon-cogs icon-large"></i>
                                    &nbsp;&nbsp;Paso 2: cargar titulares
                                </a>
                            </span>
                        </div>
                    </div>
                    <div class="row-fluid oculto" id="contResultTit" style="padding-top:25px">
                    	<div class="span2"></div>
                        <div class="span8">
                        	 <div class="alert span11 oculto" id="resultTitulares"></div>
                        </div>
                    </div>
                    <div class="row-fluid">
                    	<div class="span1"></div>
                        <div class="span10 alert alert-info pagination pagination-centered">
                            <h4>Personal Reemplazo</h4>
                        </div>
                    </div>
                    <div class="row-fluid">
                    	<div class="span1">&nbsp;</div>
                        <div class="span10">
                        	<span class="">
                                <a class="btn btn-warning excelReemplazos" href="#">
                                    <i class="icon-cloud-download icon-large"></i>
                                    &nbsp;&nbsp;Personal Reemplazo
                                </a>
                            </span>
                            <span class="">
                                <a class="btn btn-primary reemplasos_paso1" href="#myModal2" data-toggle="modal">
                                    <i class="icon-upload-alt icon-large"></i>
                                    &nbsp;&nbsp;Paso 1: subir listado reemplazos
                                </a>
                            </span>
                            <span class="">
                                <a class="btn btn-info reemplasos_paso2 oculto" href="#">
                                    <i class="icon-cogs icon-large"></i>
                                    &nbsp;&nbsp;Paso 2: cargar reemplazos
                                </a>
                            </span>
                        </div>
                    </div>
                    <div class="row-fluid oculto" id="contResultReemp" style="padding-top:25px">
                    	<div class="span2"></div>
                        <div class="span8">
                        	 <div class="alert span11 oculto" id="resultReemplazos"></div>
                        </div>
                    </div>
                    <br/>
                    <div class="row-fluid">
                    	<div class="span1"></div>
                        <div class="span10 alert alert-info pagination pagination-centered">
                            <h4>Descargas Asistencia de Personal</h4>
                        </div>
                    </div>
                    <div class="row-fluid">
                    	<div class="span3"></div>
                        <div class="span6">
                            <span class="tool" rel="tooltip" title="(Listado con los registros del personal con atraso.)">
                                <a class="btn btn-danger excel6" href="#atrasos" data-fecha="" name="atrasos">
                                    <i class="icon-cloud-download icon-large"></i>
                                    &nbsp;&nbsp;Atrasos
                                </a>
                            </span>
                            <span>

                            </span>
                            <%
                            sql = ""
                            sql = sql & " set dateformat dmy "
                            sql = sql & " select fecha_respaldo "
                            sql = sql & " from SUC_sucursal_asistencia_personal_respaldo "
                            sql = sql & " where DATEADD(day,-60,GETDATE()) <= fecha_respaldo "
                            sql = sql & " group by fecha_respaldo "
                            sql = sql & " order by fecha_respaldo desc "
                            set rsAtraso = db.execute(sql)
                            dim datosFechaAtraso
                            if not rsAtraso.eof then
                                datosFechaAtraso = rsAtraso.getrows()
                            end if
                            %>
                            <span id="seleccionaFechasExcel6" class="oculto">
                                <select id="fechaExcel6" name="fechaExcel6">
                                    <option value="">[Seleccione Fecha]</option>
                                    <option value="<%=date()%>">Hoy</option>
                                    <%if isArray(datosFechaAtraso) then
                                        for w = 0 to ubound(datosFechaAtraso,2)
                                            fechaRespaldo = trim(datosFechaAtraso(0,w))%>
                                            <option value="<%=fechaRespaldo%>">
                                                <%=fechaRespaldo%>
                                            </option>
                                        <%next
                                    end if%>
                                </select>
                            </span>
                            <br/><br/>
                    </div>
                    <div class="span3"></div>
                </div>
                <div class="row-fluid">
                	<div class="span1"></div>
                    <div class="span10 alert alert-info pagination pagination-centered">
                        <h4>
                            Detalle Sucursal
                        </h4>
                    </div>
                </div>
                <div class="row-fluid">
                    <div class="span10 offset1 well">
                    	<table width="90%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="33%" align="left" class="TextoNegro">Seleccione una sucursal para ver listado de reemplazos</td>
                                <td align="left" class="TextoNegro">
                                <select name="sucursales" id="sucursales">
                                    <option value="0">Seleccione</option>
                                    <%for i=0 to ubound(datos,2)
                                        idSucursal = trim(datos(0,i))
                                        codBtt = "BT"&trim(datos(1,i))
                                        nombreSucursal = server.htmlencode(trim(datos(2,i)))%>
                                        <option data-codbt="<%=datos(1,i)%>" value="<%=idSucursal%>">
                                            <%=nombreSucursal&" "&codBtt%>
                                        </option>
                                    <%next%>
                                </select>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="row-fluid">
                	<div class="row-fluid oculto" id="butons_add">
                        <div class="span11 offset1">
                            <a class="btn btn-success addTitular">
                                <i class="icon-plus-sign icon-large"></i>
                                &nbsp;&nbsp;Titular
                            </a>
                            &nbsp;
                            <a class="btn btn-success addReemplazo">
                                <i class="icon-plus-sign icon-large"></i>
                                &nbsp;&nbsp;Reemplazo
                            </a>
                        </div>
                    </div>
                    <div class="row-fluid oculto" id="forms_add">
                    	<br/>
                        <div class="span10 offset1" id="forms_add2"></div>
                    </div>
                    <br/>
                    <div class="row-fluid">
                        <div class="span10 offset1 hide" id="lst_persuc_head"></div>
                    </div>
                </div>
                <div class="row-fluid">
                    <div class="span10 offset1 hide" id="lst_persuc_rem"></div>
                </div>
                <br/>
                
                <div class="row-fluid">
                	<div class="span1"></div>
                    <div class="span10 alert alert-info pagination pagination-centered">
                        <h4>
                            Reporte de Logs de Eventos
                        </h4>
                    </div>
                </div>
                <div class="row-fluid">
                    <div class="span10 offset1 well">
                    	<table width="100%" border="0" cellspacing="5" cellpadding="5">
                            <tr>
                                <td width="15%" align="right" class="TextoNegro"><strong>Fecha Desde:</strong></td>
                                <td width="18%">
                                    <input type="date" name="fecha_desde_log" id="fecha_desde_log" class="input-medium" />
                                </td>
                                <td width="15%" align="right" class="TextoNegro"><strong>Fecha Hasta:</strong></td>
                                <td width="18%">
                                    <input type="date" name="fecha_hasta_log" id="fecha_hasta_log" class="input-medium" />
                                </td>
                                <td width="34%" rowspan="4" align="center" valign="middle">
                                    <a class="btn btn-primary btn-large btnBuscarLogs" id="btnBuscarLogs">
                                        <i class="icon-search icon-large"></i>
                                        &nbsp;<span class="bajaLetra"><b>BUSCAR LOGS</b></span>
                                    </a>
                                    <br/><br/>
                                    <a class="btn btn-success btn-large btnLimpiarFiltrosLogs" id="btnLimpiarFiltrosLogs">
                                        <i class="icon-refresh icon-large"></i>
                                        &nbsp;<span class="bajaLetra"><b>LIMPIAR FILTROS</b></span>
                                    </a>
                                    <br/><br/>
                                    <a class="btn btn-warning btn-large btnExportarLogs" id="btnExportarLogs">
                                        <i class="icon-cloud-download icon-large"></i>
                                        &nbsp;<span class="bajaLetra"><b>EXPORTAR A EXCEL</b></span>
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" class="TextoNegro"><strong>Usuario:</strong></td>
                                <td>
                                    <input type="text" name="usuario_log" id="usuario_log" class="input-medium" placeholder="Nombre usuario" />
                                </td>
                                <td align="right" class="TextoNegro"><strong>Perfil:</strong></td>
                                <td>
                                    <select name="perfil_log" id="perfil_log" class="input-medium">
                                        <option value="">Todos</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" class="TextoNegro"><strong>Funcionalidad:</strong></td>
                                <td>
                                    <select name="funcionalidad_log" id="funcionalidad_log" class="input-medium">
                                        <option value="">Todas</option>
                                    </select>
                                </td>
                                <td align="right" class="TextoNegro"><strong>Tipo Accion:</strong></td>
                                <td>
                                    <select name="tipo_accion_log" id="tipo_accion_log" class="input-medium">
                                        <option value="">Todas</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" class="TextoNegro"><strong>Registros por Pagina:</strong></td>
                                <td>
                                    <select name="page_size_log" id="page_size_log" class="input-medium">
                                        <option value="25">25</option>
                                        <option value="50" selected>50</option>
                                        <option value="100">100</option>
                                        <option value="200">200</option>
                                    </select>
                                </td>
                                <td colspan="2">&nbsp;</td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="row-fluid">
                    <div class="span10 offset1" id="lst_logs_resultado"></div>
                </div>
                <div class="row-fluid">
                    <div class="span10 offset1" style="text-align: center; margin-top: 10px;">
                        <div id="paginacion_logs"></div>
                    </div>
                </div>
                <br/>
                
            </div>
        </div>
    </div>
</div>    <div class="row-fluid">
        <div class="span12 oculto" id="insertaGrafico"></div>
    </div>

    <div class="row-fluid">
        <div class="span10 oculto offset1" id="insertaTablaGestionCasos"></div>
    </div>

    <div id="excelImport" class="row-fluid oculto"></div>
    
    <!-- Modal 1-->
    <div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">?</button>
            <h3 id="myModalLabel">Paso 1: Subir Listado de Titulares</h3>
        </div>
        <div class="modal-body">
            <iframe id="ifrmUpload" src="pruebaupload.asp" width="99.6%" height="99.6%" frameborder="0"></iframe>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">Cerrar</button>
            <button class="btn btn-primary nextPaso2">Siguiente Paso</button>
        </div>
    </div>
    <br/>

    <!-- Modal 2-->
    <div id="myModal2" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">?</button>
            <h3 id="myModalLabel">Paso 1: Subir Listado de Reemplazos</h3>
        </div>
        <div class="modal-body">
            <iframe id="ifrmUpload2" src="pruebaupload.asp" width="99.6%" height="99.6%" frameborder="0"></iframe>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">Cerrar</button>
            <button class="btn btn-primary nextPaso2R">Siguiente Paso</button>
        </div>
    </div>

    <!-- Modal 3-->
    <div id="myModal3" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">?</button>
            <h3 id="myModalLabel">Personal</h3>
        </div>
        <div class="modal-body">
            <iframe id="ifrmPIng" src="" width="1200" height="550" frameborder="0"></iframe>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">Cerrar</button>
        </div>
    </div>
    </div>

<script type="text/javascript">

// Funcion para cargar filtros dinamicos de logs
function cargarFiltrosLogs() {
    $.ajax({
        url: 'obtener_filtros_logs.asp',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            var $funcionalidad = $('#funcionalidad_log');
            $funcionalidad.html('<option value="">Todas</option>');
            if (data.funcionalidades && data.funcionalidades.length > 0) {
                $.each(data.funcionalidades, function(i, func) {
                    $funcionalidad.append('<option value="' + func + '">' + func + '</option>');
                });
            }
            
            var $tipoAccion = $('#tipo_accion_log');
            $tipoAccion.html('<option value="">Todas</option>');
            if (data.tipos_accion && data.tipos_accion.length > 0) {
                $.each(data.tipos_accion, function(i, tipo) {
                    $tipoAccion.append('<option value="' + tipo + '">' + tipo + '</option>');
                });
            }
            
            var $perfil = $('#perfil_log');
            $perfil.html('<option value="">Todos</option>');
            if (data.perfiles && data.perfiles.length > 0) {
                $.each(data.perfiles, function(i, perfil) {
                    $perfil.append('<option value="' + perfil + '">' + perfil + '</option>');
                });
            }
        },
        error: function() {
            console.log('Error al cargar los filtros de logs');
        }
    });
}

// Funcion para buscar logs con paginacion
function buscarLogsConPaginacion(pagina) {
    var fechaDesde = $('#fecha_desde_log').val();
    var fechaHasta = $('#fecha_hasta_log').val();
    var usuario = $('#usuario_log').val();
    var perfil = $('#perfil_log').val();
    var funcionalidad = $('#funcionalidad_log').val();
    var tipoAccion = $('#tipo_accion_log').val();
    var pageSize = $('#page_size_log').val();
    
    var div = 'lst_logs_resultado';
    var datos = 'fecha_desde=' + fechaDesde + '&fecha_hasta=' + fechaHasta + '&usuario=' + usuario + 
                '&perfil=' + perfil + '&funcionalidad=' + funcionalidad + '&tipo_accion=' + tipoAccion + 
                '&page=' + pagina + '&page_size=' + pageSize;
    var paginaAsp = 'obtener_logs.asp';
    
    enviaDatos(paginaAsp, div, datos);
}

$(document).ready(function(){
    cargarFiltrosLogs();
});

$(function () {
	$('.tool').tooltip();
}).on('click','.nextPaso2',function(){
    var $currentIFrame = $('#ifrmUpload');
    var inputProcess = $currentIFrame.contents().find("body #statusProcess");
    if(inputProcess.val() == '1'){
        $('.titulares_paso1').removeClass('btn-primary').addClass('btn-success');
        $('#myModal').modal('hide');
        $('.titulares_paso2').removeClass('oculto');
    }
}).on('click','.titulares_paso2',function(){
    var div = '';
    var datos = '';
    var pagina = 'admin_personal_procesar_titulares.asp';
    $('.titulares_paso2').removeClass('btn-info').addClass('btn-danger');
    $('#contResultTit').addClass('oculto');

    var loadData = $.ajax({
        url: pagina,
        data: "",
        type: "POST",
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
        renderData(data);
    }

    var renderData = function(objectJson){
        var html = '';
        var objIndex = '';
        var result = objectJson['datos']['result'];
        $('#resultTitulares').html('');
        $('#contResultTit').removeClass('oculto');
        if(result=='error'){
            $('#resultTitulares').removeClass('oculto').addClass('alert-error');
            $('#resultTitulares').append('<h4>Error de Validacion</h4>');
        }else{
            $('#resultTitulares').removeClass('alert-error');
            $('#resultTitulares').removeClass('oculto').addClass('alert-success');
            $('#resultTitulares').append('<h4>Validacion Terminada con Exito</h4>');
        }
        var msg = '';
        msg += '<ol>';
        $.each(objectJson['datos']['msg'], function(index, value) {
            msg += '<li>' + value.m + '</li>';
        });
        msg += '</ol>';
        $('#resultTitulares').append(msg);

        if(result=='exito'){
            setTimeout(function(){
                $('#resultTitulares').html('');
                $('#resultTitulares').append('<h4><i class="icon-spinner icon-spin icon-large"></i> Procesando Carga</h4>');
                $('#resultTitulares').append('<ol><li>Ejecutando proceso de carga de asistencia.</li></ol>');
                var  executeCarga = $.ajax({
                    url: 'admin_personal_procesar_titulares_prc.asp',
                    data: "",
                    type: "GET",
                    dataType: "text",
                    cache:false,
                    timeout:120000,
                    success: function(source){
                        $('#resultTitulares').html('');
                        $('#resultTitulares').append('<h4>Ejecucion Ok</h4>');
                        $('.titulares_paso2').removeClass('btn-danger').addClass('btn-success');
                        setTimeout(function(){
                            $('#resultTitulares').fadeOut('slow');
                            $('.titulares_paso2').fadeOut('slow');
                            $('.titulares_paso1').removeClass('btn-success').addClass('btn-primary')
                            $('#ifrmUpload')[0].contentWindow.location.reload(true);
                        }, 1800);
                    },
                    error: function(source){
                        alert(source);
                    }
                });
            },1500);
        }
    }
}).on('click','.nextPaso2R',function(){
    var $currentIFrame = $('#ifrmUpload2');
    var inputProcess = $currentIFrame.contents().find("body #statusProcess");
    if(inputProcess.val() == '1'){
        $('.reemplasos_paso1').removeClass('btn-primary').addClass('btn-success');
        $('.reemplasos_paso2').removeClass('oculto');
        $('.reemplasos_paso2').show();
        $('#myModal2').modal('hide')
    }
}).on('click','.reemplasos_paso2',function(){
    var div = '';
    var datos = '';
    var pagina = 'admin_personal_procesar_reemplazos.asp';
    $('.reemplasos_paso2').removeClass('btn-info').addClass('btn-danger');
    var loadData = $.ajax({
        url: pagina,
        data: "",
        type: "POST",
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
        renderData(data);
    }
    var renderData = function(objectJson){
        var html = '';
        var objIndex = '';
        var result = objectJson['datos']['result'];
        $('#resultReemplazos').html('');
        $('#contResultReemp').removeClass('oculto')

        if(result=='error'){
            $('#resultReemplazos').removeClass('oculto').addClass('alert-error');
            $('#resultReemplazos').show();
            $('#resultReemplazos').append('<h4>Error de Validacion</h4>');
        }else{
            $('#resultReemplazos').removeClass('alert-error');
            $('#resultReemplazos').removeClass('oculto').addClass('alert-success');
            $('#resultReemplazos').show();
            $('#resultReemplazos').append('<h4>Validacion Terminada con Exito</h4>');
        }
        var msg = '';
        msg += '<ol>';
        $.each(objectJson['datos']['msg'], function(index, value) {
            msg += '<li>' + value.m + '</li>';
        });
        msg += '</ol>';
        $('#resultReemplazos').append(msg);
        if(result=='exito'){
            setTimeout(function(){
                $('#resultReemplazos').html('');
                $('#resultReemplazos').append('<h4><i class="icon-spinner icon-spin icon-large"></i> Procesando Carga</h4>');
                $('#resultReemplazos').append('<ol><li>Ejecutando proceso de carga de asistencia.</li></ol>');
                var  executeCarga = $.ajax({
                    url: 'admin_personal_procesar_reemplazos_prc.asp',
                    data: "",
                    type: "GET",
                    dataType: "text",
                    cache:false,
                    timeout:120000,
                    success: function(source){
                        $('#resultReemplazos').html('');
                        $('#resultReemplazos').append('<h4>Ejecucion Ok</h4>');
                        $('.reemplasos_paso2').removeClass('btn-danger').addClass('btn-success');
                        setTimeout(function(){
                            $('#resultReemplazos').fadeOut('slow');
                            $('.reemplasos_paso2').fadeOut('slow');
                            $('.reemplasos_paso2').removeClass('btn-success').addClass('btn-info');
                            $('.reemplasos_paso1').removeClass('btn-success').addClass('btn-primary');
                            $('#ifrmUpload2')[0].contentWindow.location.reload(true);
                        }, 1800);
                    },
                    error: function(source){
                        alert(source);
                    }
                });
            },1500);
        }
    }
}).on('click','.excelTitulares',function(){
    $(this).attr({
        'download': 'admin_personal_excel_titulares.xls',
        'href': 'adminPersonalInforme.asp?tipoInforme=6',
        'target': '_blank'
    });
}).on('click','.excelReemplazos',function(){
    $(this).attr({
        'download': 'admin_personal_excel_reemplazos.xls',
        'href': 'adminPersonalInforme.asp?tipoInforme=7',
        'target': '_blank'
    });
}).on('click','.excel6',function(){
    var descargaDatos = $(this).attr('data-descarga');
    if (descargaDatos ==='1')
    {
        var valorFecha = $(this).attr('data-fecha');
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth()+1;
        var yyyy = today.getFullYear();
        if(dd<10){
            dd='0'+dd
        }
        if(mm<10){
            mm='0'+mm
        }
        var hoy = dd+'-'+mm+'-'+yyyy;
        var url
        if (hoy === valorFecha)
        {
            url = 'adminPersonalInforme2.asp?tipoInforme=8';
        }
        else
        {
            url = 'adminPersonalInforme2.asp?tipoInforme=8&valorFecha='+valorFecha
        }
        $(this).attr({
           'download': 'admin_personal_excel_atrasos_'+valorFecha+'.xls',
           'href': url,
           'target': '_blank'
        });
    }
    else
    {
        $(this).html('<i class="icon-calendar icon-large"></i> Seleccione fecha');
        $('#seleccionaFechasExcel6').removeClass('oculto').slideDown('slow');
    }
}).on('change','#fechaExcel6',function(){
    var valorSeleccionado = $('#fechaExcel6 option:selected').val();
    if (valorSeleccionado !=='')
    {
        $('.excel6').html('<i class="icon-cloud-download icon-large"></i> Descargar').attr('data-descarga', '1');
        $('.excel6').attr('data-fecha', valorSeleccionado);
    }
    else
    {
         $('.excel6').attr('data-descarga', '0');
    }
}).on('click','.addTitular',function(){
	var codBtt = $('option:selected','#sucursales').attr('data-codbt');
	var idSucursal = $('#sucursales').val();
	var div = 'forms_add2';
	var pagina = 'personal_ingreso.asp?tipoPersonal=1&idSucursal='+idSucursal+'&codBtt='+codBtt;
	enviaDatos(pagina,div,'');
	$('#forms_add').removeClass('oculto').fadeIn('slow');
}).on('click','.addReemplazo',function(){
	var codBtt = $('option:selected','#sucursales').attr('data-codbt');
	var idSucursal = $('#sucursales').val();
	var div = 'forms_add2';
	var pagina = 'personal_ingreso.asp?tipoPersonal=2&idSucursal='+idSucursal+'&codBtt='+codBtt;
	enviaDatos(pagina,div,'');
	$('#forms_add').removeClass('oculto').fadeIn('slow');
}).on('change','#sucursales',function(){
    var div = 'lst_persuc_rem';
    var datos = '';
    var pagina = 'asistenciaSucursal.asp';
    datos = 'idSucursal=' + $(this).val();
    enviaDatos(pagina,div,datos);

	div = 'lst_persuc_head';
	pagina = '../sucursales/miSucursal_ver.asp';
    datos = 'idSucursal=' + $(this).val();
    enviaDatos(pagina,div,datos);

	$('#butons_add').show();
    $('#lst_persuc_head').show();
	$('#lst_persuc_rem').show();
}).on('click', '.btn-pagina-log', function(){
	var pagina = $(this).data('pagina');
	buscarLogsConPaginacion(pagina);
});

function enviaDatos(pagina,div,datos)
{
	var rand = '&v='+ Math.random() * 999
	var ajaxobject = $.ajax(
	{
		type:'GET',
		url:pagina,
		cache:false,
		global:false,
		dataType:"html",
		data:datos+rand,
		timeout:10000,
		success:function(contenido)
		{
			$('#'+div).html(contenido);
		}
	});
	if(ajaxobject == undefined)
	alert('Problemas en la generacion del objeto');
	return false;
}

$('.btnCuadroDeControl').click(function(){
    $('.btnGestionCasos').addClass('oculto');
    $('.btnCuadroDeControl').addClass('oculto');
    $('.btnCuadroDeControl2').addClass('oculto');
    $('.btnGestionProveedores').addClass('oculto');
    $('.btnSolicitudCajerosAdicionales').addClass('oculto');
    $('.btnControlOnline').removeClass('oculto');
    $('.btnCuadroDeControlMes').removeClass('oculto');
    $('.dvTbCuadroDeControl').removeClass('oculto');
    $('.btnVolverAdmini').removeClass('oculto');
    $('.btnControlOnline').removeClass('btn btn-primary').addClass('btn btn-danger');
    $('.btnCuadroDeControlMes').removeClass('btn btn-danger').addClass('btn btn-primary');
    
    $('#Central_Columna_mensual').addClass('oculto');
    $('#tbCuadroDeControl').html('');
    var div = 'tbCuadroDeControl';
    var datos = '';
    var pagina = 'cuadroControl.asp';
    var carga = 'carga';
    var cargaCuadrocontrol = '1'
    datos = 'carga='+carga+'&cargaCuadrocontrol='+cargaCuadrocontrol;
    enviaDatos(pagina, div, datos);
});

$('.btnControlOnline').click(function(){
    $('.btnControlOnline').removeClass('btn btn-primary').addClass('btn btn-danger');
    $('.btnCuadroDeControlMes').removeClass('btn btn-danger').addClass('btn btn-primary');
    $('#Central_Columna_mensual').addClass('oculto');
    $('.btnCuadroDeControl2').addClass('oculto');
    $('.btnGestionProveedores').addClass('oculto');
    $('.btnSolicitudCajerosAdicionales').addClass('oculto');
    $('#tbCuadroDeControl').html('');
    var div = 'tbCuadroDeControl';
    var datos = '';
    var pagina = 'cuadroControl.asp';
    var carga = 'carga';
    var cargaCuadrocontrol = '1'
    datos = 'carga='+carga+'&cargaCuadrocontrol='+cargaCuadrocontrol;
    enviaDatos(pagina, div, datos);
});

$('.btnCuadroDeControlMes').click(function(){
    $('.btnCuadroDeControlMes').removeClass('btn btn-primary').addClass('btn btn-danger');
    $('.btnControlOnline').removeClass('btn btn-danger').addClass('btn btn-primary');
    $('#Central_Columna_mensual').addClass('oculto');
    $('.btnCuadroDeControl2').addClass('oculto');
    $('.btnGestionProveedores').addClass('oculto');
    $('.btnSolicitudCajerosAdicionales').addClass('oculto');
    $('#tbCuadroDeControl').html('');
    var div = 'tbCuadroDeControl';
    var datos = '';
    var pagina = 'cuadroControl.asp';
    var carga = 'carga';
    var cargaCuadrocontrol = '2'
    datos = 'carga='+carga+'&cargaCuadrocontrol='+cargaCuadrocontrol;
    enviaDatos(pagina, div, datos);
});

$('.btnVolverAdmini').click(function(){
    location.reload();
});

$('.btnCuadroDeControl2').click(function(){
    $('.btnGestionCasos').addClass('oculto');
    $('.btnCuadroDeControl').addClass('oculto');
    $('.btnCuadroDeControl2').addClass('oculto');
    $('.btnGestionProveedores').addClass('oculto');
    $('.btnSolicitudCajerosAdicionales').addClass('oculto');
    $('.btnCuadroControlAdMes').removeClass('oculto');
    $('.dvTbCuadroDeControl').removeClass('oculto');
    $('.btnVolverAdmini2').removeClass('oculto');
    $('.btnCuadroDeControl2').removeClass('btn btn-primary').addClass('btn btn-danger');
    $('.btnCuadroControlAdMes').removeClass('btn btn-danger').addClass('btn btn-primary');
    
    $('#Central_Columna_mensual').addClass('oculto');
    $('#tbCuadroDeControl').html('');
    var div = 'tbCuadroDeControl';
    var datos = '';
    var pagina = 'cuadroControl2.asp';
    var carga = 'carga';
    datos = 'cargaCuadrocontrol=1&carga='+carga;
    enviaDatos(pagina, div, datos);
});

$('.btnCuadroControlAdMes').click(function(){
    $(this).removeClass('btn btn-primary').addClass('btn btn-danger');
    $('.btnControlOnline').removeClass('btn btn-danger').addClass('btn btn-primary');
    $('.btnCuadroDeControl2').removeClass('btn btn-danger').addClass('btn btn-primary');
    $('#Central_Columna_mensual').addClass('oculto');
    $('.btnGestionProveedores').addClass('oculto');
    $('.btnSolicitudCajerosAdicionales').addClass('oculto');
    $('#tbCuadroDeControl').html('');
    var div = 'tbCuadroDeControl';
    var datos = '';
    var pagina = 'cuadroControl2.asp';
    var carga = 'carga';
    datos = 'cargaCuadrocontrol=2&carga='+carga;
    enviaDatos(pagina, div, datos);
});

$('.btnVolverAdmini2').click(function(){
    location.reload();
});

$('.btnGestionCasos').click(function(){
    $('#Central_Columna_mensual').hide();
    $('#insertaGrafico').removeClass('oculto');
    var div = 'insertaGrafico';
    var datos = '';
    var pagina = 'creaGraficoGestionCasos_ii.asp';
    enviaDatos(pagina,div,datos);
    $('.btnVolverAdmini3').removeClass('oculto');
    $('.btnCuadroDeControl').addClass('oculto');
    $('.btnCuadroDeControl2').addClass('oculto');
    $('.btnGestionCasos').addClass('oculto');
    $('.btnGestionProveedores').addClass('oculto');
    $('.btnSolicitudCajerosAdicionales').addClass('oculto');
    $('.btnGestionCasosDetalle').removeClass('oculto');
    $('.btnGestionCasosDetalles').removeClass('btn btn-danger').addClass('btn btn-primary');
});

$('.btnGestionCasosDetalle').click(function(){
    $('#insertaGrafico').hide('slow');
    $('#insertaTablaGestionCasos').removeClass('oculto');
    var div = 'insertaTablaGestionCasos';
    var datos = '';
    var pagina = 'cuadroControlGC.asp';
    enviaDatos(pagina,div,datos);

    $('.btnGestionCasos').addClass('oculto');
    $('.btnGestionCasos2').removeClass('oculto');
    $('.btnGestionCasosDetalles').removeClass('btn btn-primary').addClass('btn btn-danger');
});

$('.btnGestionCasos2').click(function(){
    $('#insertaTablaGestionCasos').hide('slow');
    $('#insertaGrafico').show('slow');
    $('.btnGestionCasos2s').removeClass('btn btn-primary').addClass('btn btn-danger');
    $('.btnGestionCasosDetalle').addClass('oculto');
    $('.btnGestionCasosDetalle2').removeClass('oculto');
    $('.btnGestionCasosDetalle2s').removeClass('btn btn-danger').addClass('btn btn-primary');
});

$('.btnGestionCasosDetalle2').click(function(){
    $('.btnGestionCasosDetalle2s').removeClass('btn btn-primary').addClass('btn btn-danger');
    $('.btnGestionCasos2s').removeClass('btn btn-danger').addClass('btn btn-primary');
    $('#insertaGrafico').hide('slow');
    $('#insertaTablaGestionCasos').fadeIn('');
});

$('.btnVolverAdmini3').click(function(){
    location.reload();
});

$('.btnGestionProveedores').click(function(){
    $('.btnGestionCasos').addClass('oculto');
    $('.btnCuadroDeControl').addClass('oculto');
    $('.btnCuadroDeControl2').addClass('oculto');
    $('.btnGestionProveedores').addClass('oculto');
    $('.btnSolicitudCajerosAdicionales').addClass('oculto');
    $('.dvTbGestionProveedores').removeClass('oculto');
    $('.btnVolverAdmini4').removeClass('oculto');
    $('#Central_Columna_mensual').addClass('oculto');
    
    $('#tbGestionProveedores').html('');
    var div = 'tbGestionProveedores';
    var datos = '';
    var pagina = 'gestionProveedores.asp';
    var carga = 'carga';
    datos = 'carga=' + carga;
    enviaDatos(pagina, div, datos);
});

$('.btnVolverAdmini4').click(function(){
    location.reload();
});

$('.btnSolicitudCajerosAdicionales').click(function(){
    $('.btnGestionCasos').addClass('oculto');
    $('.btnCuadroDeControl').addClass('oculto');
    $('.btnCuadroDeControl2').addClass('oculto');
    $('.btnGestionProveedores').addClass('oculto');
    $('.btnSolicitudCajerosAdicionales').addClass('oculto');
    $('.dvTbSolicitudCajerosAdicionales').removeClass('oculto');
    $('.btnVolverAdmini5').removeClass('oculto');
    $('#Central_Columna_mensual').addClass('oculto');
    
    $('#tbSolicitudCajerosAdicionales').html('');
    var div = 'tbSolicitudCajerosAdicionales';
    var datos = '';
    var pagina = '../sucursales/solicitudCajerosAdicionales.asp';
    var perfilSimulado = '3';
    var idSucursalMain = '0';
    var idUsuarioMain = '<%=usuarioLog%>';
    
    datos = 'idSucursalMain=' + idSucursalMain + '&perfilMain=' + perfilSimulado + '&idUsuarioMain=' + idUsuarioMain;
    enviaDatos(pagina, div, datos);
});

$('.btnVolverAdmini5').click(function(){
    location.reload();
});

</script>
</body>
</html>
