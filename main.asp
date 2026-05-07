<!--#include file="funciones.asp"-->
<%idSucursalMain = trim(request("idSucursalMain"))
idUsuarioMain = trim(request("idUsuarioMain"))
perfilMain = trim(request("perfilMain"))
Session.Timeout=1
if (perfilMain = "" ) or (idUsuarioMain = "") or (idSucursalMain = "") then
	response.Redirect("default.asp")
else%>
<!DOCTYPE html>
<html lang="es">
<head>
  <!--<meta charset="utf-8">-->
  <title>Sucursales</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="">
  <meta name="author" content="Soporte Canales">
  <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
  <link href="../cdn/css/bootstrap.css" rel="stylesheet" type="text/css">
  <link href="../cdn/css/bootstrap-responsive.css" rel="stylesheet" type="text/css">
  <link href="css/estilo.css" rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="../cdn/css/font-awesome.min.css" type="text/css">
  <link href="../cdn/css/tablaSort.css" rel="stylesheet" type="text/css">
  <link href="../cdn/css/bootstrap-datetimepicker.min.css" rel="stylesheet" type="text/css">
  <!-- Fav and touch icons -->
  <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../cdn/ico/apple-touch-icon-144-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../cdn/ico/apple-touch-icon-114-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../cdn/ico/apple-touch-icon-72-precomposed.png">
  <link rel="apple-touch-icon-precomposed" href="../cdn/ico/apple-touch-icon-57-precomposed.png">
  <link rel="shortcut icon" href="../cdn/ico/favicon.png">
  <!--[if IE 7]>
  <link rel="stylesheet" href="css/font-awesome-ie7.min.css">
  <![endif]-->
  <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
  <!--[if lt IE 9]>
  <script src="js/html5shiv.js"></script>
  <![endif]-->
  <script src="../cdn/js/jquery-1.10.2.min.js" type="text/javascript"></script>
  <script src="../cdn/js/bootstrap.min.js" type="text/javascript"></script>
  <script src="../cdn/js/bootstrap-transition.js" type="text/javascript"></script>
  <script src="../cdn/js/bootstrap-typeahead.js" type="text/javascript"></script>
  <script src="../cdn/js/jquery.validate.js" type="text/javascript"></script>
  <script src="../cdn/js/additional-methods.js" type="text/javascript"></script>
  <script src="../cdn/js/jquery.Rut.min.js" type="text/javascript"></script>
  <script src="../cdn/js/jquery.validate.rut.js" type="text/javascript"></script>
  <script src="../cdn/js/funciones.js" type="text/javascript"></script>
  <script type="text/javascript" src="../cdn/js/charts2.js"></script>

  <script type="text/javascript" src="../cdn/js/charts3d.js"></script>
  <script type="text/javascript" src="../cdn/js/charts.data.js"></script>
  <script type="text/javascript" src="../cdn/js/charts.more.js"></script>
  <script type="text/javascript" src="../cdn/js/exporta.js"></script>
  <script type="text/javascript" src="../cdn/js/regresion.js"></script>
  
  <script type="text/javascript" src="../cdn/js/bootstrap-datetimepicker.min.js"></script>
  <script type="text/javascript" src="../cdn/js/bootstrap-datetimepicker.es-cl.js"></script>
  <script type="text/javascript" src="../cdn/js/jquery.momentos.js"></script>
  <script type="text/javascript" src="../cdn/js/jquery.dataTables10.min.js"></script>
  <script type="text/javascript" src="../cdn/js/jquery.dataTables.bootstrap.js"></script>
  <script type="text/javascript" src="../cdn/js/jquery.prettynumber.js"/></script>
  
  <style type="text/css">
  /* --- Contenedor Principal (Rebaja Cajeros) --- */
  .icon-solicitud-rebaja-cajeros {
    position: relative; 
    display: inline-block;
    width: 28px;
    height: 28px;
    vertical-align: text-top;
    top: -11px; /* <-- LÃƒÆ’Ã‚ÂNEA DESCOMENTADA: Esto lo sube a la misma altura que los demÃƒÆ’Ã‚Â¡s */
  }

  /* --- Icono del Usuario Principal --- */
  .icon-solicitud-rebaja-cajeros-usuario {
    font-size: 24px;
    line-height: 28px;
    color: inherit;
  }

  /* --- Contenedor del Badge --- */
  .icon-solicitud-rebaja-cajeros-badge {
    position: absolute;
    right: 1px;  
    top: -1px;    /* Mantiene el cÃƒÆ’Ã‚Â­rculo con la 'x' en la parte superior */
    width: 12px;
    height: 12px;
  }

  /* --- El CÃƒÆ’Ã‚Â­rculo Negro del Badge --- */
  .icon-solicitud-rebaja-cajeros-circulo {
    position: absolute;
    top: 0;
    left: 0;
    font-size: 12px;
    line-height: 12px;
    color: inherit; 
  }

  /* --- La 'X' Blanca del Badge --- */
  .icon-solicitud-rebaja-cajeros-flecha {
    position: absolute;
    top: 0;
    left: 0;
    width: 12px;
    font-size: 7px;
    line-height: 12px;
    text-align: center;
    color: #ffffff; 
    margin: 0;
  }
</style>

  <style type="text/css">
  .icon-solicitud-cajeros {
    position: relative;
    display: inline-block;
    width: 28px;
    height: 28px;
    vertical-align: text-top;
    top: -11px;
  }

  .icon-solicitud-cajeros-usuario {
    font-size: 24px;
    line-height: 28px;
    color: inherit;
  }

  .icon-solicitud-cajeros-badge {
    position: absolute;
    right: 1px;
    bottom: 1px;
    width: 12px;
    height: 12px;
  }

  .icon-solicitud-cajeros-circulo {
    position: absolute;
    top: 0;
    left: 0;
    font-size: 12px;
    line-height: 12px;
    color: inherit;
  }

  .icon-solicitud-cajeros-flecha {
    position: absolute;
    top: 0;
    left: 0;
    width: 12px;
    font-size: 7px;
    line-height: 12px;
    text-align: center;
    color: #ffffff;
    margin: 0;
  }
</style>

  <style type="text/css">
  .icon-evaluacion-cajeros {
    position: relative;
    display: inline-block;
    width: 28px;
    height: 28px;
    vertical-align: text-top;
    top: -11px;
  }

  .icon-evaluacion-cajeros-usuario {
    font-size: 24px;
    line-height: 28px;
    color: inherit;
  }

  .icon-evaluacion-cajeros-badge {
    position: absolute;
    right: 1px;
    bottom: 1px;
    width: 12px;
    height: 12px;
  }

  .icon-evaluacion-cajeros-circulo {
    position: absolute;
    top: 0;
    left: 0;
    font-size: 12px;
    line-height: 12px;
    color: #5cb85c;
  }

  .icon-evaluacion-cajeros-flecha {
    position: absolute;
    top: 0;
    left: 0;
    width: 12px;
    font-size: 7px;
    line-height: 12px;
    text-align: center;
    color: #ffffff;
    margin: 0;
  }
</style>

</head>
<body>
<form id="valores" name="valores" action="main.asp" method="post">
  <input type="hidden" name="perfilMain" id="perfilMain" value="<%=perfilMain%>">
  <input type="hidden" name="idSucursalMain" id="idSucursalMain" value="<%=idSucursalMain%>">
  <input type="hidden" name="idUsuarioMain" id="idUsuarioMain" value="<%=idUsuarioMain%>">
</form>
<div class="container-fluid page-header">
  <div class="row-fluid centrado">
    <div id="logo" class="span2">
      <img src="../cdn/img/LogoLH.gif" class="img-rounded" width="260" height="88">
    </div>
    <div id="espacio" class="span2"></div>
     <div class="span3" id="nombreUsuarioTitulo"></div>
    <div id="titulo" class="span4">
      <strong>
        <h2>
          Sucursales
        </h2>
      </strong>
    </div>
  </div>
  <%if perfilMain <> "0" then%>
  <div class="row-fluid">
    <div id="menu"></div>
  </div>
  <%end if%>
  <%if perfilMain ="1" then%>
    <div class="row-fluid" id="sucursalJeps">
      <div id="miSucursal" class="span10"></div>
      <div class="span2" id="panelSucursal"></div>
    </div>
    <div class="row-fluid" id="areaJeps">
      <div class="span10" id="area"></div>
      <div class="span2" id="indicadores"></div>
    </div>
    <div class="row-fluid oculto" id="checkListGer">
      <div class="span12" id="checkListGerEspacio"></div>    
    </div>
    <div class="row-fluid oculto" id="reporteGer">
      <div class="span12" id="reporteGerEspacio"></div>    
    </div>
  <%end if
  if perfilMain ="2" then%>
    <div class="row-fluid" id="sucursalesZonal">
      <div id="divSucursalesAbiertas" class="span2"></div>
      <div id="divIndicadoresZonal" class="span4"></div>      
      <div id="divSeguridadZonal" class="span4"></div>
      <div id="botoneraZonal" class="span2 well">
        <span id="muestraCalendarioZonal" class="mano">
          <i class="icon-calendar icon-2x"></i>
        </span>
        <!--<span id="divIncidencias" class="mano" data-placement="top" title="Incidencias">
          <i class="icon-flag-alt icon-2x mano"></i>
            <span id="numeroIncidencias" class="badge badge-info mano">
              0
            </span>
        </span>-->
    <!--<span id="divMensajesZonal" class="mano" data-placement="top" title="Mensajes">
    <i class="icon-comment-alt icon-2x mano"></i>
    <span id="numeroMensajes" class="badge badge-info mano">
    0
    </span>
    </span>-->
        <span id="muestraGraficoZonal" class="muestraGraficoZonal mano" data-placement="top" data-original-title="Tendencias">
          <i class="icon-bar-chart icon-2x mano ayuda" ></i>
        </span>
        <!--JesÃƒÂ¯Ã‚Â¿Ã‚Â½s-->
        <span id="tabMenu13CajerosA" class="mano" title="Solicitudes de Cajeros Adicionales">
          <!--span class="icon-stack icon-2x">
            <i class="icon-check-empty icon-stack-base"></i>
            <i class="icon-group"></i>
          </span-->
          <span class="icon-solicitud-cajeros">
            <i class="icon-user icon-solicitud-cajeros-usuario"></i>
            <span class="icon-solicitud-cajeros-badge">
              <i class="icon-circle icon-solicitud-cajeros-circulo"></i>
              <i class="icon-arrow-down icon-solicitud-cajeros-flecha"></i>
            </span>
          </span>
        </span>
        
        <span id="tabMenu13CajerosR" class="mano" title="Solicitudes de Rebaja Cajeros Adicionales">
          <!--span class="icon-stack icon-2x">
            <i class="icon-check-empty icon-stack-base"></i>
            <i class="icon-group"></i>
          </span-->
          <span class="icon-solicitud-rebaja-cajeros">
            <i class="icon-user icon-solicitud-rebaja-cajeros-usuario"></i>
            <span class="icon-solicitud-rebaja-cajeros-badge">
              <i class="icon-circle icon-solicitud-rebaja-cajeros-circulo"></i>
              <i class="icon-arrow-up icon-solicitud-rebaja-cajeros-flecha"></i>
            </span>
          </span>
        </span>        <span id="tabMenu13CajerosE" class="mano" title="Evaluación Cajeros">
          <span class="icon-evaluacion-cajeros">
            <i class="icon-user icon-evaluacion-cajeros-usuario"></i>
            <span class="icon-evaluacion-cajeros-badge">
              <i class="icon-circle icon-evaluacion-cajeros-circulo"></i>
              <i class="icon-ok icon-evaluacion-cajeros-flecha"></i>
            </span>
          </span>
        </span>
        <!--<span id="botonSalirZonal" class="mano">
          <i class="icon-signout icon-2x"></i>
        </span>-->
      </div>
    </div>
    <div class="row-fluid oculto" id="divDetalleSucursales">
      <div class="span12" id="detalleSucursales"></div>
    </div>
    <div class="row-fluid" id="areaTrabajoZonal">
      <div class="span5" id="estadoSucursalesZonal" data-cargaDatos="1"></div>
      <div class="span5" id="trabajoZonal"></div>
      <div class="span2" id="indicadoresZonal"></div>
      <!--<div class="span5" id="estadoSucursalesZonal" data-cargaDatos="1"></div>
      <div class="span5" id="trabajoZonal"></div>
      <div class="span2" id="indicadoresZonal"></div> -->
    </div>
    <div class="row-fluid">
      <div class="span12" id="indicesZOnal"></div>
    </div>
    <div class="row-fluid oculto" id="gastosIndices">
      <div class="span12" id="gastosZonal"></div>
    </div>
    <div class="row-fluid oculto" id="personalGer">
      <div class="span12" id="personalGerEspacio"></div>    
    </div>
    <div class="row-fluid oculto" id="checkListGer">
      <div class="span12" id="checkListGerEspacio"></div>    
    </div>
    <div class="row-fluid oculto" id="reporteGer">
      <div class="span12" id="reporteGerEspacio"></div>    
    </div>
    <div class="row-fluid oculto" id="areaTransacciones">
      <div class="span12" id="transaccionesGer"></div>
    </div>

  <%end if
  if perfilMain ="55" then%>
    <div class="row-fluid" id="sucursalesZonal">
      <div id="divSucursalesAbiertas" class="span2"></div>
      <div id="divIndicadoresZonal" class="span4"></div>
      <div id="divSeguridadZonal" class="span4"></div>
      <div id="botoneraZonal" class="span2 well">
        <span id="muestraCalendarioZonal" class="mano">
          <i class="icon-calendar icon-2x"></i>
        </span>
        <span id="divIncidencias" class="mano" data-placement="top" title="Incidencias">
          <i class="icon-flag-alt icon-2x mano"></i>
          <span id="numeroIncidencias" class="badge badge-info mano">
            0
          </span>
        </span>
        <!--<span id="divMensajesZonal" class="mano" data-placement="top" title="Mensajes">
          <i class="icon-comment-alt icon-2x mano"></i>
            <span id="numeroMensajes" class="badge badge-info mano">
              0
            </span>
        </span>-->
        <span id="muestraGraficoZonal" class="muestraGraficoZonal mano" data-placement="top" title="" data-original-title="Tendencias">
          <i class="icon-bar-chart icon-2x mano muestraGraficoZonal ayuda" ></i>
        </span>
        <span id="botonSalirZonal" class="mano">
          <i class="icon-signout icon-2x"></i>
        </span>
      </div>
    </div>
    <div class="row-fluid oculto" id="divDetalleSucursales">
      <div class="span12" id="detalleSucursales"></div>
    </div>
    <div class="row-fluid" id="areaTrabajoZonal">
      <div class="span12">
        <div class="row-fluid">
          <div class="span5" id="estadoSucursalesZonal" data-cargaDatos="1"></div>
          <div class="span5" id="trabajoZonal"></div>
          <div class="span2" id="indicadoresZonal"></div>
        </div>
      </div>
      <!--<div class="span5" id="estadoSucursalesZonal" data-cargaDatos="1"></div>
      <div class="span5" id="trabajoZonal"></div>
      <div class="span2" id="indicadoresZonal"></div> -->
    </div>
    <div class="row-fluid">
      <div class="span12" id="indicesZOnal"></div>
    </div>
    <div class="row-fluid oculto" id="gastosIndices">
      <div class="span12" id="gastosZonal"></div>
    </div>
    <div class="row-fluid oculto" id="personalGer">
      <div class="span12" id="personalGerEspacio"></div>    
    </div>
    <div class="row-fluid oculto" id="checkListGer">
      <div class="span12" id="checkListGerEspacio"></div>    
    </div>
    <div class="row-fluid oculto" id="reporteGer">
      <div class="span12" id="reporteGerEspacio"></div>    
    </div>
  <%end if
  if perfilMain ="66" then%>
    <div class="row-fluid" id="sucursalesZonal">
      <div id="divSucursalesAbiertas" class="span2"></div>
      <div id="divIndicadoresZonal" class="span4"></div>
      <div id="divSeguridadZonal" class="span4"></div>
      <div id="botoneraZonal" class="span2 well">
        <span id="muestraCalendarioZonal" class="mano">
          <i class="icon-calendar icon-2x"></i>
        </span>
        <span id="divIncidencias" class="mano" data-placement="top" title="Incidencias">
          <i class="icon-flag-alt icon-2x mano"></i>
          <span id="numeroIncidencias" class="badge badge-info mano">
            0
          </span>
        </span>
        <!--<span id="divMensajesZonal" class="mano" data-placement="top" title="Mensajes">
          <i class="icon-comment-alt icon-2x mano"></i>
            <span id="numeroMensajes" class="badge badge-info mano">
              0
            </span>
        </span>-->
        <span id="muestraGraficoZonal" class="muestraGraficoZonal mano" data-placement="top" title="" data-original-title="Tendencias">
          <i class="icon-bar-chart icon-2x mano muestraGraficoZonal ayuda" ></i>
        </span>
        <span id="botonSalirZonal" class="mano">
          <i class="icon-signout icon-2x"></i>
        </span>
      </div>
    </div>
    <div class="row-fluid oculto" id="divDetalleSucursales">
      <div class="span12" id="detalleSucursales"></div>
    </div>
    <div class="row-fluid" id="areaTrabajoZonal">
      <div class="span12">
        <div class="row-fluid">
          <div class="span5" id="estadoSucursalesZonal" data-cargaDatos="1"></div>
          <div class="span5" id="trabajoZonal"></div>
          <div class="span2" id="indicadoresZonal"></div>
        </div>
      </div>
      <!--<div class="span5" id="estadoSucursalesZonal" data-cargaDatos="1"></div>
      <div class="span5" id="trabajoZonal"></div>
      <div class="span2" id="indicadoresZonal"></div> -->
    </div>
    <div class="row-fluid">
      <div class="span12" id="indicesZOnal"></div>
    </div>
    <div class="row-fluid oculto" id="gastosIndices">
      <div class="span12" id="gastosZonal"></div>
    </div>
    <div class="row-fluid oculto" id="personalGer">
      <div class="span12" id="personalGerEspacio"></div>    
    </div>
  <%end if
  if perfilMain = "3" then%>
    <!--<div class="row-fluid">
    <div class="span2" id="indicadorGer"></div>
    </div>-->
    <div class="row-fluid" id="areaTrabajoGer">
    	<div class="span12" id="sucursalesGer"></div>
    </div>
    <div class="row-fluid oculto" id="areaDashGer">
    	<div class="span12" id="dashGer"></div>
    </div>
    <div class="row-fluid oculto" id="areaTransacciones">
    	<div class="span12" id="transaccionesGer"></div>
    </div>
    <div class="row-fluid oculto" id="areaGastosGer">
    	<div class="span12" id="gastosGerEspacio"></div>
    </div>
    <div class="row-fluid oculto" id="personalGer">
    	<div class="span12" id="personalGerEspacio"></div>    
    </div>
    <div class="row-fluid oculto" id="checkListGer">
      <div class="span12" id="checkListGerEspacio"></div>    
    </div>
    <div class="row-fluid oculto" id="reporteGer">
      <div class="span12" id="reporteGerEspacio"></div>    
    </div>
    <div class="row-fluid oculto" id="areaEspecial">
      <div class="span12" id="especial"></div>
    </div>
  <%end if
  if perfilMain = "0" then%>
    <!--<div class="row-fluid">
    <div class="span8" id="tabZonas"></div>
    <div class="span4 pull-right" id="busquedaSucursal"></div>
    </div> -->
    <div class="row-fluid">
      <div class="span12" id="menuAdmin"></div>
    </div>
    <div class="row-fluid">
      <div class="span12 well" id="trabajoAdmin"></div>
    </div>
  <%end if
  if perfilMain = "4" then%>
    <div class="row-fluid"  id="divAreaDivisional">
      <div class="span12" id="areaDivisional"></div>
    </div>
  <%end if
  if perfilMain = "5" then%>
  <div class="row-fluid">
    <div class="span12" id="areaCda"></div>
  </div>
  <%end if%>
  <div class="row-fluid oculto" id="areaInformes">
    <div class="span12" id="muestraInformes"></div>
  </div>
  <div id="verificaEstadoSucursal" class="oculto"></div>
  <!--<div class="row-fluid" id="areaTw">
    <div class="span5" id="tw"></div>
  </div>-->
</div>
<script src="js/main.js" type="text/javascript"></script>
<!-- <script src="js/tocsv.js" type="text/javascript"></script> -->
<script>
//Highcharts.setOptions({lang: {decimalPoint: ',',thousandsSep: '.'},tooltip: {yDecimals: 2}});
$(function() {
  var perfilMain = $('#perfilMain').val();
  cargaDatosInicio(perfilMain);
  Highcharts.setOptions({
      lang: {
        numericSymbols: null, //otherwise by default ['k', 'M', 'G', 'T', 'P', 'E']
        thousandsSep: '.',
        decimalPoint: ','
      }
    });
});

</script>

</body>
</html>
<%end if%>