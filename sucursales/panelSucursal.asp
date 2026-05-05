<style type="text/css">
  /* --- Contenedor Principal (Rebaja Cajeros) --- */
  .icon-solicitud-rebaja-cajeros {
    position: relative; 
    display: inline-block;
    width: 28px;
    height: 28px;
    vertical-align: middle;
    top: -4px; /* <-- LÍNEA DESCOMENTADA: Esto lo sube a la misma altura que los demás */
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
    top: -1px;    /* Mantiene el círculo con la 'x' en la parte superior */
    width: 12px;
    height: 12px;
  }

  /* --- El Círculo Negro del Badge --- */
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
    vertical-align: middle;
    top: -4px; /* <-- LÍNEA DESCOMENTADA: Esto lo sube a la misma altura que los demás */
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
<div class="well">
  <!--<span id="tabMenu5" class="mano" data-placement="top" title="Mensajes">
		<i class="icon-comment-alt icon-2x mano"></i>
		<span id="numeroMensajes" class="badge badge-info mano">0</span>
	</span>-->
  <!--<span id="tabMenu6" class="mano" data-placement="top" title="Incidencias">
		<i class="icon-flag-alt icon-2x mano"></i>
		<span id="numeroIncidencias" class="badge badge-info mano">0</span>
	</span>
	<span id="tabMenu7" class="mano" data-placement="left" title="Calendario">
		<i class="icon-calendar icon-2x mano"></i>
	</span>-->
  <span
    id="tabMenu8"
    class="mano"
    data-placement="left"
    title="Encuesta de aseo"
  >
    <i class="icon-ticket icon-2x mano"></i>
  </span>
  <span
    id="tabMenu10"
    class="mano"
    data-placement="left"
    title="Asistencia Cajeros"
  >
    <i class="icon-user icon-2x mano"></i>
  </span>
  <span
    id="tabMenu11"
    class="mano"
    data-placement="left"
    title="Asistencia Guardias"
  >
    <i class="icon-shield icon-2x mano"></i>
  </span>
  <span
    id="tabMenu12"
    class="mano"
    data-placement="left"
    title="Ingreso Dotacion"
  >
    <i class="icon-group icon-2x mano"></i>
  </span>
  <span
    id="tabMenu13"
    class="mano"
    data-placement="left"
    title="Solicitudes de Cajeros Adicionales"
  >
    <span class="icon-solicitud-cajeros">
      <i class="icon-user icon-solicitud-cajeros-usuario"></i>
      <span class="icon-solicitud-cajeros-badge">
        <i class="icon-circle icon-solicitud-cajeros-circulo"></i>
        <i class="icon-arrow-down icon-solicitud-cajeros-flecha"></i>
      </span>
    </span>
  </span>
  
    <span
    id="tabMenu14"
    class="mano"
    data-placement="left"
    title="Solicitudes de Rebaja Cajeros Adicionales"
  >
    <span class="icon-solicitud-rebaja-cajeros">
      <i class="icon-user icon-solicitud-rebaja-cajeros-usuario"></i>
      <span class="icon-solicitud-rebaja-cajeros-badge">
        <i class="icon-circle icon-solicitud-rebaja-cajeros-circulo"></i>
        <i class="icon-arrow-up icon-solicitud-rebaja-cajeros-flecha"></i>
      </span>
    </span>
  </span>
  
  <!--
	<span id="tabMenu9" class="mano" data-placement="left" title="Salir">
		<i class="icon-signout icon-2x mano" ></i>
	</span>-->
</div>
<script type="text/javascript">
  $(function () {
    $(".mano").tooltip();
  });
  var pagina, div, datos;
  $("#tabMenu5").click(function () {
    pagina = "mensajes/mensajes.asp";
    div = "area";
    datos = "";
    try {
      enviaDatos(pagina, div, datos);
    } catch (err) {}
  });
  $("#tabMenu6").click(function () {
    pagina = "incidencias/muestraIncidencias.asp";
    div = "area";
    datos = "";
    try {
      enviaDatos(pagina, div, datos);
    } catch (err) {}
  });
  $("#tabMenu7").click(function () {
    pagina = "calendario/calendario.asp";
    div = "area";
    datos = "";
    try {
      enviaDatos(pagina, div, datos);
    } catch (err) {}
  });
  $("#tabMenu8").click(function () {
    pagina = "encuestaAseo/encuesta.asp";
    div = "area";
    datos = "";
    try {
      enviaDatos(pagina, div, datos);
    } catch (err) {}
  });
  $("#tabMenu9").click(function () {
    location.href = "verificaUsuario/salir.asp";
  });
  $("#tabMenu10").click(function () {
    pagina = "sucursales/asistenciaSucursalCajeros.asp";
    div = "area";
    datos = "";
    try {
      enviaDatos(pagina, div, datos);
    } catch (err) {}
  });
  $("#tabMenu11").click(function () {
    pagina = "sucursales/asistenciaSucursalGuardias.asp";
    div = "area";
    datos = "";
    try {
      enviaDatos(pagina, div, datos);
    } catch (err) {}
  });
  $("#tabMenu12").click(function () {
    pagina = "dotacion/dotacion.asp";
    div = "area";
    datos = "";
    try {
      enviaDatos(pagina, div, datos);
    } catch (err) {}
  });
  $("#tabMenu13").click(function () {
    pagina = "sucursales/solicitudCajerosAdicionales.asp";
    div = "area";
    datos = "";
    try {
      enviaDatos(pagina, div, datos);
    } catch (err) {}
  });
  $("#tabMenu14").click(function () {
    pagina = "sucursales/solicitudRebajaCajerosAdicionales.asp";
    div = "area";
    datos = "";
    try {
      enviaDatos(pagina, div, datos);
    } catch (err) {}
  });
</script>