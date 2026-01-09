<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuarioMain"))
idPerfil = trim(request("idPerfilMain"))
'//////////////// total de cajeros titulares'
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
              Cajeros
            </strong>
            <span id="porcentajeIndicadorRegistrados" class="badge"> 
              
            </span>
        </span>
        </td>
      </tr>
      <tr>
        <td>      
          <span id="textoIndicadorZonalTitulares">
            Titulares 
          </span>
          <span id="porcentajeIndicadorZonalTitulares" class="badge pull-right"></span>
        </td>
        <td>
          <span id="textoIndicadorZonalReemplazo">
            Reemplazo 
          </span>
          <span id="porcentajeIndicadorZonalReemplazo" class="badge pull-right"></span>
        </td>
        <td>
          <span id="textoIndicadorZonalPresentes">
            Adicionales 
          </span>
          <span id="porcentajeIndicadorPresentesAdicionales" class="badge pull-right"></span>
        </td>
      </tr>

      <tr>        
        <td>
          <span id="textoIndicadorZonalPresentes">
            Sin Registro 
          </span>
          <span id="porcentajeIndicadorSinReg" class="badge badge-important pull-right"></span>
        </td>
        <td>
          <span id="textoIndicadorZonalAusentes">
            Ausentes 
          </span>
          <span id="porcentajeIndicadorAusentes" class="badge badge-warning pull-right"></span>
        </td>
        <td>
          <span id="textoIndicadorZonalAdicionales">
            Presentes 
          </span>
          <span id="porcentajeIndicadorPresentes" class="badge badge-info pull-right"></span>    
        </td>        
      </tr>

      <!--<tr>        
        <td>
          <span id="textoIndicadorAusentesAdi">
            Ausentes Titulares 
          </span>
          <span id="porcentajeIndicadorAusentesAdi" class="badge badge-warning pull-right"></span>
        </td>
        <td>
          <span id="textoIndicadorAusentesTitu">
            Ausentes Adicionales
          </span>
          <span id="porcentajeIndicadorAusentesTitu" class="badge badge-warning pull-right"></span>
        </td>
        <td>
          <span id="">            
          </span>
          <span id="" class="badge badge-info pull-right"></span>    
        </td>        
      </tr> -->

    </table>
  </div>
</div>
<script type="text/javascript">
  var perfil = $('#perfilMain').val();
  var idUsuario = $('#idUsuarioMain').val();
  url='indicadores/datosPersonal.asp?perfilMain='+perfil+'&idUsuarioMain='+idUsuario;
  $.when($.ajax(url)).then(function(data) {
    $.each( data.dataCajeros, function( key, valoresCajeros ) {
      var totalCajeros = valoresCajeros.totalCajeros;
      var totalCajerosTitulares = valoresCajeros.totalCajerosTitulares;
      var totalCajerosReemplazos = valoresCajeros.totalCajerosReemplazos;
      var totalCajerosAdicionales = valoresCajeros.totalCajerosAdicionales;
      var totalAusentes2 = valoresCajeros.totalAusentes2;
      var totalSinRegistro = valoresCajeros.totalSinRegistro;
      var totalPresentes = valoresCajeros.totalPresentes;
      var totalAusentesAdicionales = valoresCajeros.totalAusentesAdi;
      var totalAusentesTitulares = valoresCajeros.totalAusentesTitu;
      $('#porcentajeIndicadorRegistrados').html(totalCajeros);
      $('#porcentajeIndicadorZonalTitulares').html(totalCajerosTitulares);
      $('#porcentajeIndicadorZonalReemplazo').html(totalCajerosReemplazos);
      $('#porcentajeIndicadorPresentesAdicionales').html(totalCajerosAdicionales);
      $('#porcentajeIndicadorSinReg').html(totalSinRegistro);
      $('#porcentajeIndicadorAusentes').html(totalAusentes2);
      $('#porcentajeIndicadorPresentes').html(totalPresentes);
      $('#porcentajeIndicadorAusentesAdi').html(totalAusentesAdicionales);
      $('#porcentajeIndicadorAusentesTitu').html(totalAusentesTitulares);
    });
  });
</script>
<%else%>
  <div class="row-fluid">
    <div class="span12 alert alert-error">
       La información de cajeros estará disponible desde las 8:00
    </div>
  </div>
<%end if%>