<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuarioMain"))
idPerfil = trim(request("idPerfilMain"))

horaActual = Time()
minutosHoraActual=hour(horaActual)*60
minutosHoraActual = minutosHoraActual + minute(horaActual)
if minutosHoraActual >= 480 then%>
  <div class="row-fluid">
    <div class="span12">
      <table class="table table-bordered table-hover table-condensed">
        <tr>
          <td colspan="3">
            <span class="centrado">
              <strong>
                Guardias
              </strong>
          </td>
        </tr>
        <tr>
          <td>
            <span id="textoIndicadorTitulares">
              Titulares 
            </span>
            <span id="seguridadTitulares" class="badge pull-right"></span>
          </td>          
          <td>
            <span id="textoIndicadorPresentes">
              Presentes 
            </span>
            <span id="seguridadPresentes" class="badge badge-info pull-right">
              <%=totalPres%>
            </span>
          </td> 
          <td rowspan="2">
            <span id="textoIndicadorSinRegistro">
              Sin Registro 
            </span>
            <span id="seguridadSinRegistro" class="badge badge-important pull-right">
              <%=totalSR%>
            </span>
          </td>         
        </tr>
        <tr> 
        <td>
            <span id="textoIndicadorReemplazo">
              Reemplazos 
            </span>
            <span id="seguridadReemplazo" class="badge pull-right">
              <%=totalRempl%>
            </span>
          </td>  
          <td>
            <span id="textoIndicadorAusentes">
              Ausentes 
            </span>
            <span id="seguridadAusentes" class="badge badge-warning pull-right">
              <%=totalAus%>
            </span>
          </td>                 
        </tr>
      </table>
    </div>
  </div>
  <script type="text/javascript">
  var perfil = $('#perfilMain').val();
  var idUsuario = $('#idUsuarioMain').val();
  url='sucursales/datosSeguridad.asp?perfil='+perfil+'&idUsuario='+idUsuario;
  $.when($.ajax(url)).then(function(data) {
    $.each( data.dataGuardias, function( key, valoresGuardias ) {
      var totalTitu = valoresGuardias.totalTitu;
      var totalPres = valoresGuardias.totalPres;
      var totalRempl = valoresGuardias.totalRempl;
      var totalAus = valoresGuardias.totalAus;
      var totalSR = valoresGuardias.totalSR;
      $('#seguridadTitulares').html(totalTitu);
      $('#seguridadPresentes').html(totalPres);
      $('#seguridadReemplazo').html(totalRempl);
      $('#seguridadAusentes').html(totalAus);
      $('#seguridadSinRegistro').html(totalSR);     
    });
  });
  </script>
<%else%>
  <div class="row-fluid">
    <div class="alert alert-error span4 offset3">
      La información de guardias de seguridad estará disponible desde las 8:00
    </div>
  </div>
<%end if%>