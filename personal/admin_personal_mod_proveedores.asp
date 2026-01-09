<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones.asp"-->
<%
'Obtener datos de usuario para el log
dim usuarioLog, perfilLog, idUsrWin, usuarios, usuarioWin, dominio

'Obtener usuario de Windows (LOGON_USER)
idUsrWin = request.servervariables("LOGON_USER")
if idUsrWin <> "" then
	usuarios = split(idUsrWin, "\")
	if UBound(usuarios) >= 1 then
		usuarioWin = usuarios(1)
		dominio = usuarios(0)
	else
		usuarioWin = idUsrWin
		dominio = ""
	end if
	usuarioLog = usuarioWin
else
	usuarioLog = ""
end if

'Si no se obtuvo de LOGON_USER, intentar de la sesión
if usuarioLog = "" and Session("id_usuario")<>"" then
	usuarioLog = Session("id_usuario")
	if Session("nombre_usuario")<>"" then
		usuarioLog = Session("nombre_usuario")
	end if
end if

'Obtener perfil
if Session("tipo")<>"" then
	perfilLog = Session("tipo")
else
	perfilLog = "General"
end if

'Registrar acceso a la página
if usuarioLog <> "" then
	call registrarLog(usuarioLog, perfilLog, "Admin Personal", "Acceso a página")
end if

'if Session("id_usuario")<>"" and Session("tipo")="admin" then
%>
<!DOCTYPE html>
<html lang="es">
<head>
	<meta charset="utf-8">
    <title>Sucursales</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=9">
    <!-- Le styles -->
    <link href="../css/bootstrap.css" rel="stylesheet" type="text/css">
    <link href="../css/bootstrap-responsive.css" rel="stylesheet" type="text/css">
    <link href="../css/estilo.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="../css/font-awesome.min.css" type="text/css">
    <link href="../css/bootstrap-datetimepicker.min.css" rel="stylesheet" type="text/css">

    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="../ico/apple-touch-icon-57-precomposed.png">
    <script src="../js/jquery.js" type="text/javascript"></script>
    <script type="text/javascript" src="../js/bootstrap-tooltip.js"></script>
    <script type="text/javascript" src="../js/bootstrap-modal.js"></script>
    <script type="text/javascript" src="../js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript" src="../js/bootstrap-datetimepicker.es-cl.js"></script>
    <script type="text/javascript" src="../js/charts.js"></script>
    <script type="text/javascript" src="../js/charts.data.js"></script>
    <script type="text/javascript" src="../js/charts.more.js"></script>
    <script type="text/javascript" src="../js/exporta.js"></script>
    <script type="text/javascript" src="../js/jquery.flip.js"></script>
    <link rel="shortcut icon" href="../ico/favicon.png">
</head>
<body>
<%
sql = ""
sql = sql & " select id_sucursal, cod_bantotal, suc_nombre from SUC_sucursal order by suc_nombre "
set rs = db.execute(sql)
if not rs.eof then
    datos = rs.GetRows()%>
<body topmargin="0">
	<div id="MarcoGeneral">
        <div id="Limite"></div>
        <div id="Central">

            <div id="Central">
            <div id="Central_Columna_mensual2">
            </br>
                <div class="row-fluid ">
                <div class="span1 ">&nbsp;</div>
                    <span class="span10">
                        <span class="">
                            <a class="btn btn-danger btnCuadroDeControl" href="#">
                                <i class="icon-user icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>CONTROL CAJEROS TITULARES</b></span>
                            </a>
                        </span>

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
                                &nbsp;<span class="bajaLetra"><b>GESTIÓN DE CASOS (GRAFICO)</b></span>
                            </a>
                        </span>
                        <span class="btnGestionCasos2 oculto" id="btnGestionCasos2">
                            <a class="btn btn-primary btnGestionCasos2s" href="#">
                                <i class="icon-book icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>GESTIÓN DE CASOS (GRAFICO)</b></span>
                            </a>
                        </span>
                        &nbsp;&nbsp;
                         <span class="btnGestionCasosDetalle oculto" id="btnGestionCasosDetalle">
                            <a class="btn btn-danger btnGestionCasosDetalles" id="btnGestionCasosDetalles" href="#">
                                <i class="icon-book icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>GESTIÓN DE CASOS (DETALLE)</b></span>
                            </a>
                        </span>
                        &nbsp;&nbsp;
                         <span class="btnGestionCasosDetalle2 oculto" id="btnGestionCasosDetalle2">
                            <a class="btn btn-primary btnGestionCasosDetalle2s" id="btnGestionCasosDetalles" href="#">
                                <i class="icon-book icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>GESTIÓN DE CASOS (DETALLE)</b></span>
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
                                &nbsp;<span class="bajaLetra"><b>GESTIÓN DE PROVEEDORES</b></span>
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
                        <!--<span class="">
                            <a class="btn btn-danger btnAsistCajero" href="#">
                                <i class="icon-user icon-large"></i>
                                &nbsp;<span class="bajaLetra"><b>ASISTENCIA CAJERO</b></span>
                            </a>
                        </span>-->
                    </span>
                </div>
                <br/>
                <div class="row-fluid dvTbCuadroDeControl oculto" id= "dvTbCuadroDeControl">
                    <div class="span1">&nbsp;</div>
                    <div class="span10" id="tbCuadroDeControl"></div>
                </div>
                <br/>
                <div class="row-fluid dvTbAsistCajeros oculto" id= "dvTbAsistCajeros">
                    <div class="span1">&nbsp;</div>
                    <div class="span10" id="tbAsistCajeros"></div>
                </div>
                <br/>
                <div class="row-fluid dvTbGestionProveedores oculto" id= "dvTbGestionProveedores">
                    <div class="span1">&nbsp;</div>
                    <div class="span10" id="tbGestionProveedores"></div>
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
                            <h4>
                                Personal Reemplazo
                            </h4>
                        </div>
                    </div>
                    <div class="row-fluid">
                    	<div class="span1"></div>
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
                            <h4>
                                Descargas Asistencia de Personal
                            </h4>
                        </div>
                    </div>
                    <div class="row-fluid">
                    	<div class="span3"></div>
                        <div class="span6">
                        	<!--<span class="tool" rel="tooltip" title="(Listado con los registros de asistencia de todo el personal.)">
                                <a class="btn btn-warning excel1" href="#">
                                    <i class="icon-cloud-download icon-large"></i>
                                    &nbsp;&nbsp;Asistencia Personal
                                </a>
                            </span>
                            <br/><br/>
                            <span class="tool" rel="tooltip" title="(Listado con los registros sólo de los cajeros y cajeros adicionales ausente.)">
                                <a class="btn btn-warning excel2" href="#">
                                    <i class="icon-cloud-download icon-large"></i>
                                    &nbsp;&nbsp;Ausencia Personal
                                </a>
                            </span>
                            <br/><br/>-->
                            <span class="tool" rel="tooltip" title="(Listado con los registros del personal con atraso.)">
                                <a class="btn btn-danger excel6" href="#atrasos" data-fecha="" name="atrasos">
                                    <i class="icon-cloud-download icon-large"></i>
                                    &nbsp;&nbsp;Atrasos
                                </a>
                            </span>
                            <span>

                            </span>
                            <%sql = ""
                            'sql = sql & " select CONVERT(DATE,GETDATE()) AS fecha_respaldo "
														sql = sql & " set dateformat dmy "
                            sql = sql & " select fecha_respaldo "
                            sql = sql & " from SUC_sucursal_asistencia_personal_respaldo "
                            sql = sql & " where DATEADD(day,-60,GETDATE()) <= fecha_respaldo "
                            sql = sql & " group by fecha_respaldo "
                            sql = sql & " order by fecha_respaldo desc "
														'Response.Write(sql)
                            set rsAtraso = db.execute(sql)
                            if not rsAtraso.eof then
                                datosFechaAtraso = rsAtraso.getrows()
                            end if%>
                            <span id="seleccionaFechasExcel6" class="oculto">
                                <select id="fechaExcel6" name="fechaExcel6">
                                    <option value="">[Seleccione Fecha]</option>
                                    <option value="<%=date()%>">Hoy</option>
                                    <%for w = 0 to ubound(datosFechaAtraso,2)
                                        fechaRespaldo = trim(datosFechaAtraso(0,w))%>
                                        <option value="<%=fechaRespaldo%>">
                                            <%=fechaRespaldo%>
                                        </option>
                                    <%next%>
                                </select>
                            </span>
                            <br/><br/>
                        </div>
                        <!--<div class="span3">
                            <span class="tool" rel="tooltip" title="(Listado con los registros del personal de reemplazo.)">
                                <a class="btn btn-warning excel3" href="#">
                                    <i class="icon-cloud-download icon-large"></i>
                                    &nbsp;&nbsp;Asistencia Reemplazos
                                </a>
                            </span>
                            <br/><br/>
                            <span class="tool" rel="tooltip" title="(Listado con los registros de ausencia del personal de reemplazo.)">
                                <a class="btn btn-warning excel4" href="#">
                                    <i class="icon-cloud-download icon-large"></i>
                                    &nbsp;&nbsp;Ausencia Reemplazos
                                </a>
                            </span>
                            <br/><br/>
                            <span class="tool" rel="tooltip" title="(Listado con los registros del personal no informado.)">
                                <a class="btn btn-warning excel5" href="#">
                                    <i class="icon-cloud-download icon-large"></i>
                                    &nbsp;&nbsp;No Informados
                                </a>
                            </span>
                            <br/><br/>
                        </div>-->
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
                    
                    <!-- Nueva sección: Reporte de Logs -->
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
                                        <input type="date" name="fecha_desde_log" id="fecha_desde_log" class="input-medium" value="<%=Year(Date()) & "-" & Right("0" & Month(Date()), 2) & "-" & Right("0" & Day(Date()), 2)%>" />
                                    </td>
                                    <td width="15%" align="right" class="TextoNegro"><strong>Fecha Hasta:</strong></td>
                                    <td width="18%">
                                        <input type="date" name="fecha_hasta_log" id="fecha_hasta_log" class="input-medium" value="<%=Year(Date()) & "-" & Right("0" & Month(Date()), 2) & "-" & Right("0" & Day(Date()), 2)%>" />
                                    </td>
                                    <td width="34%" rowspan="3" align="center" valign="middle">
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
                                    <td align="right" class="TextoNegro"><strong>Tipo Acción:</strong></td>
                                    <td>
                                        <select name="tipo_accion_log" id="tipo_accion_log" class="input-medium">
                                            <option value="">Todas</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" class="TextoNegro"><strong>Registros por Página:</strong></td>
                                    <td>
                                        <select name="page_size_log" id="page_size_log" class="input-medium">
                                            <option value="25">25</option>
                                            <option value="50" selected>50</option>
                                            <option value="100">100</option>
                                            <option value="200">200</option>
                                        </select>
                                    </td>
                                    <td colspan="2"></td>
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
                    <!-- Fin sección Reporte de Logs -->
                    
                </div>
            </div>
        </div>
    </div>
    <div class="row-fluid">
        <div class="span12 oculto" id="insertaGrafico"></div>
    </div>

    <div class="row-fluid">
        <div class="span10 oculto offset1" id="insertaTablaGestionCasos"></div>
    </div>

    <div id="excelImport" class="row-fluid oculto"></div>
    <!-- Modal 1-->
    <div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                ×
            </button>
            <h3 id="myModalLabel">
                Paso 1: Subir Listado de Titulares
            </h3>
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
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                ×
            </button>
            <h3 id="myModalLabel">
                Paso 1: Subir Listado de Reemplazos
            </h3>
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
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                ×
            </button>
            <h3 id="myModalLabel">
                Personal
            </h3>
        </div>
        <div class="modal-body">
            <iframe id="ifrmPIng" src="" width="1200" height="550" frameborder="0"></iframe>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">
                Cerrar
            </button>
        </div>
    </div>
<script type="text/javascript">
// Función para cargar filtros dinámicos de logs
function cargarFiltrosLogs() {
    $.ajax({
        url: 'obtener_filtros_logs.asp',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            // Llenar select de Funcionalidad
            var $funcionalidad = $('#funcionalidad_log');
            $funcionalidad.html('<option value="">Todas</option>');
            if (data.funcionalidades && data.funcionalidades.length > 0) {
                $.each(data.funcionalidades, function(i, func) {
                    $funcionalidad.append('<option value="' + func + '">' + func + '</option>');
                });
            }
            
            // Llenar select de Tipo Acción
            var $tipoAccion = $('#tipo_accion_log');
            $tipoAccion.html('<option value="">Todas</option>');
            if (data.tipos_accion && data.tipos_accion.length > 0) {
                $.each(data.tipos_accion, function(i, tipo) {
                    $tipoAccion.append('<option value="' + tipo + '">' + tipo + '</option>');
                });
            }
            
            // Llenar select de Perfil
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

// Función para registrar logs de eventos del usuario
function registrarLog(funcionalidad, tipoAccion) {
    $.ajax({
        url: 'registrar_log.asp',
        data: {
            funcionalidad: funcionalidad,
            tipo_accion: tipoAccion
        },
        type: 'POST',
        dataType: 'json',
        async: true,
        cache: false
    });
}

// Función para buscar logs con paginación
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

// Cargar filtros al inicio
$(document).ready(function(){
    cargarFiltrosLogs();
});

$('.btnAsistCajero').click(function(){
    registrarLog('Admin Personal', 'Ver asistencia cajeros');
    $('#Central_Columna_mensual').addClass('oculto');

    var div = 'tbAsistCajeros';
    var datos = '';
    var pagina = 'asistenciaPersonalExterno.asp';
    enviaDatos(pagina,div,datos);
    $('#dvTbAsistCajeros').removeClass('oculto');
});

$('.btnGestionCasos').click(function(){
    registrarLog('Admin Personal - Gestión Casos', 'Ver gráfico gestión casos');
    $('#Central_Columna_mensual').hide();
    $('#insertaGrafico').removeClass('oculto');
    var div = 'insertaGrafico';
    var datos = '';
    var pagina = 'creaGraficoGestionCasos_ii.asp';
    enviaDatos(pagina,div,datos);
    $('.btnVolverAdmini3').removeClass('oculto');
    $('.btnCuadroDeControl').addClass('oculto');
    $('.btnCuadroDeControl2').addClass('oculto');
    $('.btnGestionCasosDetalle').removeClass('oculto');
    $('.btnGestionCasosDetalles').removeClass('btn btn-danger').addClass('btn btn-primary');
});

$('.btnGestionCasosDetalle').click(function(){
    registrarLog('Admin Personal - Gestión Casos', 'Ver detalle gestión casos');
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

$('.btnCuadroDeControlMes').click(function(){
    registrarLog('Admin Personal - Cuadro Control', 'Ver control cierre mes titulares');
    $('.btnCuadroDeControlMes').removeClass('btn btn-primary').addClass('btn btn-danger');
    $('.btnControlOnline').removeClass('btn btn-danger').addClass('btn btn-primary');
    $('#Central_Columna_mensual').addClass('oculto');
    $('.btnCuadroDeControl2').addClass('oculto');
    $('#tbCuadroDeControl').html('');
    var div = 'tbCuadroDeControl';
    var datos = '';
    var pagina = 'cuadroControl.asp';
    var carga = 'carga';
    //var detalle_mes = '1';
    var cargaCuadrocontrol = '2'

    datos = 'carga='+carga+'&cargaCuadrocontrol='+cargaCuadrocontrol;
    //datos = 'carga='+carga+'&cargaCuadrocontrol='+cargaCuadrocontrol+'&detalle_mes='+detalle_mes;

    enviaDatos(pagina,div,datos);
});

$('.btnCuadroControlAdMes').click(function(){
    registrarLog('Admin Personal - Cuadro Control', 'Ver control cierre mes adicionales');
    $(this).removeClass('btn btn-primary').addClass('btn btn-danger');
    $('.btnControlOnline').removeClass('btn btn-danger').addClass('btn btn-primary');
    $('.btnCuadroDeControl2').removeClass('btn btn-danger').addClass('btn btn-primary');
    $('#Central_Columna_mensual').addClass('oculto');
    $('#tbCuadroDeControl').html('');

    var div = 'tbCuadroDeControl';
    var datos = 'cargaCuadrocontrol=2&carga=carga';
    var pagina = 'cuadroControl2.asp';

    enviaDatos(pagina,div,datos);
})

$('.btnControlOnline').click(function(){
    registrarLog('Admin Personal - Cuadro Control', 'Ver control online titulares');
    $('.btnControlOnline').removeClass('btn btn-primary').addClass('btn btn-danger');
    $('.btnCuadroDeControlMes').removeClass('btn btn-danger').addClass('btn btn-primary');
    $('#Central_Columna_mensual').addClass('oculto');
    $('.btnCuadroDeControl2').addClass('oculto');
    $('#tbCuadroDeControl').html('');
    var div = 'tbCuadroDeControl';
    var datos = '';
    var pagina = 'cuadroControl.asp';
    var carga = 'carga';
    var cargaCuadrocontrol = '1'

    datos = 'carga='+carga+'&cargaCuadrocontrol='+cargaCuadrocontrol;

    enviaDatos(pagina,div,datos);
});

$('.btnCuadroDeControl').click(function(){
    registrarLog('Admin Personal - Cuadro Control', 'Ver cuadro control titulares');
    $('.btnGestionCasos').addClass('oculto');
    $('.btnCuadroDeControl').addClass('oculto');
    $('.btnControlOnline').removeClass('oculto');
    $('.dvTbCuadroDeControl').removeClass('oculto');
    $('.btnVolverAdmini').removeClass('oculto');
    $('.btnControlOnline').removeClass('btn btn-primary').addClass('btn btn-danger');
    $('.btnCuadroDeControlMes').removeClass('btn btn-danger').addClass('btn btn-primary');

    $('.btnCuadroDeControlMes').removeClass('oculto');
    $('#Central_Columna_mensual').addClass('oculto');
    $('.btnCuadroDeControl2').addClass('oculto');
    $('#tbCuadroDeControl').html('');
    var div = 'tbCuadroDeControl';
    var datos = '';
    var pagina = 'cuadroControl.asp';
    var carga = 'carga';
    var cargaCuadrocontrol = '1'

    datos = 'carga='+carga+'&cargaCuadrocontrol='+cargaCuadrocontrol;
    enviaDatos(pagina,div,datos);
});

$('.btnVolverAdmini').click(function(){
    location.reload();
});

$('.btnCuadroDeControl2').click(function(){
    registrarLog('Admin Personal - Cuadro Control', 'Ver cuadro control adicionales');
    $('.btnGestionCasos').addClass('oculto');
    $('.dvTbCuadroDeControl').removeClass('oculto');
    $('.btnVolverAdmini2').removeClass('oculto');
    $('.btnCuadroControlAdMes').removeClass('oculto');
    $('#Central_Columna_mensual').addClass('oculto');
    $('.btnCuadroDeControl').addClass('oculto');
    $('.btnCuadroDeControl2').removeClass('btn btn-primary').addClass('btn btn-danger');
    $('.btnCuadroControlAdMes').removeClass('btn btn-danger').addClass('btn btn-primary');


    $('#tbCuadroDeControl2').html('');
    var div = 'tbCuadroDeControl';
    var datos = '';
    var pagina = 'cuadroControl2.asp';
    var carga = 'carga';
    datos = 'cargaCuadrocontrol=1&carga='+carga;

    enviaDatos(pagina,div,datos);
});

$('.btnVolverAdmini2').click(function(){
    location.reload();
});

$('.btnGestionProveedores').click(function(){
    registrarLog('Admin Personal - Gestión Proveedores', 'Ver gestión de proveedores');
    $('.btnGestionCasos').addClass('oculto');
    $('.btnCuadroDeControl').addClass('oculto');
    $('.btnCuadroDeControl2').addClass('oculto');
    $('.btnGestionProveedores').addClass('oculto');
    $('.dvTbGestionProveedores').removeClass('oculto');
    $('.btnVolverAdmini4').removeClass('oculto');
    $('#Central_Columna_mensual').addClass('oculto');
    
    $('#tbGestionProveedores').html('');
    var div = 'tbGestionProveedores';
    var datos = '';
    var pagina = 'gestionProveedores.asp';
    var carga = 'carga';
    
    datos = 'carga='+carga;
    enviaDatos(pagina,div,datos);
});

$('.btnVolverAdmini4').click(function(){
    location.reload();
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
    registrarLog('Admin Personal - Titulares', 'Procesar carga de titulares');
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
                    //async:true,
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
    registrarLog('Admin Personal - Reemplazos', 'Procesar carga de reemplazos');
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
                    //async:true,
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
}).on('click','.excel1',function(){
     registrarLog('Admin Personal - Descargas', 'Descargar Excel asistencia personal');
     $(this).attr({
        'download': 'admin_personal_excel_asistencia.xls',
        'href': 'adminPersonalInforme.asp?tipoInforme=1',
        'target': '_blank'
    });
}).on('click','.excel2',function(){
    registrarLog('Admin Personal - Descargas', 'Descargar Excel titulares ausentes');
    $(this).attr({
        'download': 'admin_personal_excel_asistencia_titulares_ausentes.xls',
        'href': 'adminPersonalInforme.asp?tipoInforme=3',
        'target': '_blank'
    });
}).on('click','.excel3',function(){
    registrarLog('Admin Personal - Descargas', 'Descargar Excel asistencia reemplazos');
    $(this).attr({
        'download': 'admin_personal_excel_asistencia_reemplazos.xls',
        'href': 'adminPersonalInforme.asp?tipoInforme=2',
        'target': '_blank'
    });
}).on('click','.excel4',function(){
    registrarLog('Admin Personal - Descargas', 'Descargar Excel reemplazos ausentes');
    $(this).attr({
        'download': 'admin_personal_excel_asistencia_reemplazos_ausentes.xls',
        'href': 'adminPersonalInforme.asp?tipoInforme=4',
        'target': '_blank'
    });
}).on('click','.excel5',function(){
    registrarLog('Admin Personal - Descargas', 'Descargar Excel no informados');
    $(this).attr({
        'download': 'admin_personal_excel_sinregistrar.xls',
        'href': 'adminPersonalInforme.asp?tipoInforme=5',
        'target': '_blank'
    });
}).on('click','.excelTitulares',function(){
    registrarLog('Admin Personal - Descargas', 'Descargar Excel personal titular');
    $(this).attr({
        'download': 'admin_personal_excel_titulares.xls',
        'href': 'adminPersonalInforme.asp?tipoInforme=6',
        'target': '_blank'
    });
}).on('click','.excelReemplazos',function(){
    registrarLog('Admin Personal - Descargas', 'Descargar Excel personal reemplazo');
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
        var mm = today.getMonth()+1; //January is 0!

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
        registrarLog('Admin Personal - Descargas', 'Descargar Excel atrasos');
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
}).on('change','#seleccionaFechasExcel6',function(){
    var valorSeleccionado = $('#seleccionaFechasExcel6 option:selected').val();
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
	registrarLog('Admin Personal - Gestión Personal', 'Agregar titular');
	var codBtt = $('option:selected','#sucursales').attr('data-codbt');
	var idSucursal = $('#sucursales').val();
	var $currentIFrame = $('#ifrmPIng');

	var div = 'forms_add2';
	var pagina = 'personal_ingreso.asp?tipoPersonal=1&idSucursal='+idSucursal+'&codBtt='+codBtt;
	enviaDatos(pagina,div,'');
	$('#forms_add').removeClass('oculto').fadeIn('slow');

	//$currentIFrame.attr('src', pagina);
	//$('#myModal3').css('width', '1100px').css('margin-left','auto');
	//$('#myModal3').modal();

}).on('click','.addReemplazo',function(){
	registrarLog('Admin Personal - Gestión Personal', 'Agregar reemplazo');
	var codBtt = $('option:selected','#sucursales').attr('data-codbt');
	var idSucursal = $('#sucursales').val();
	var $currentIFrame = $('#ifrmPIng');

	var div = 'forms_add2';
	var pagina = 'personal_ingreso.asp?tipoPersonal=2&idSucursal='+idSucursal+'&codBtt='+codBtt;
	enviaDatos(pagina,div,'');
	$('#forms_add').removeClass('oculto').fadeIn('slow');

	//$currentIFrame.attr('src', pagina);
	//$('#myModal3').css('width', '1050px').css('margin-right','80%');
	//$('#myModal3').modal();

}).on('change','#sucursales',function(){
    var sucursalSeleccionada = $('#sucursales option:selected').text();
    registrarLog('Admin Personal - Detalle Sucursal', 'Ver detalle sucursal: ' + sucursalSeleccionada);
    
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
}).on('click', '.btnMostrarDetalle', function(){
	registrarLog('Admin Personal - Cuadro Control', 'Mostrar detalle control');
}).on('click', '.btnDescargarDetalle', function(){
	registrarLog('Admin Personal - Cuadro Control', 'Descargar detalle control');
}).on('click', '.btnOcultarDetalle', function(){
	registrarLog('Admin Personal - Cuadro Control', 'Ocultar detalle control');
}).on('click', '.btnBuscarLogs', function(){
	registrarLog('Admin Personal - Reporte Logs', 'Buscar logs');
	buscarLogsConPaginacion(1);
}).on('click', '.btnLimpiarFiltrosLogs', function(){
	registrarLog('Admin Personal - Reporte Logs', 'Limpiar filtros logs');
	
	var hoy = new Date();
	var fechaHoy = hoy.getFullYear() + '-' + ('0' + (hoy.getMonth() + 1)).slice(-2) + '-' + ('0' + hoy.getDate()).slice(-2);
	
	$('#fecha_desde_log').val(fechaHoy);
	$('#fecha_hasta_log').val(fechaHoy);
	$('#usuario_log').val('');
	$('#perfil_log').val('');
	$('#funcionalidad_log').val('');
	$('#tipo_accion_log').val('');
	$('#lst_logs_resultado').html('');
	$('#paginacion_logs').html('');
}).on('click', '.btn-pagina-log', function(){
	var pagina = $(this).data('pagina');
	buscarLogsConPaginacion(pagina);
}).on('click', '.btnExportarLogs', function(){
	registrarLog('Admin Personal - Reporte Logs', 'Exportar logs a Excel');
	
	var fechaDesde = $('#fecha_desde_log').val();
	var fechaHasta = $('#fecha_hasta_log').val();
	var usuario = $('#usuario_log').val();
	var perfil = $('#perfil_log').val();
	var funcionalidad = $('#funcionalidad_log').val();
	var tipoAccion = $('#tipo_accion_log').val();
	
	var url = 'exportar_logs_excel.asp?fecha_desde=' + fechaDesde + '&fecha_hasta=' + fechaHasta + '&usuario=' + encodeURIComponent(usuario) + '&perfil=' + encodeURIComponent(perfil) + '&funcionalidad=' + encodeURIComponent(funcionalidad) + '&tipo_accion=' + encodeURIComponent(tipoAccion);
	
	window.open(url, '_blank');
});

function enviaDatos(pagina,div,datos)
{
	var rand = '&v='+ Math.random() * 999
	var ajaxobject = $.ajax(
	{
		type:'GET',
		url:pagina,
		cache:false,
		//async:true,
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

</script>
</body>
<%end if%>
</html>
