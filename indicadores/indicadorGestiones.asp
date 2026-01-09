<!--#include file="../funciones.asp"-->
<%tipo = trim(request("tipo"))
idSucursal = trim(request("idSucursalMain"))
perfil = trim(request("perfilMain"))
idUsuario = trim(request("idUsuarioMain"))%>
<div class="row-fluid <%=tipo%>" data-tipo="<%=tipo%>" data-idSucursal="<%=idSucursal%>" data-idUsuario="<%=idUsuario%>" data-perfil="<%=perfil%>" id="divDatos<%=tipo%>">
  <div class="span12">
    <table border="0" width="100%" id="tabla<%=tipo%>">
      <tr>
        <td rowspan="2" align="center">
            <span id="icono<%=tipo%>"></span>
        </td>
        <td>
          <div id="tareasTerminadas">
            <table border="0" width="100%">
            <tr>
              <td>
                <span id="totalTareasTerminadas<%=tipo%>"></span><i class="icon-ok"></i>
              </td>
              <td>
                <span id="totalTareasNoterminadas<%=tipo%>"></span><i class="icon-remove"></i>
              </td>
            </tr>
            </table>
          </div>
        </td>
      </tr>
      <tr>
        <td align="center">
          <h4>
            <div id="porcentajeTareas<%=tipo%>"></div>
          </h4>
        </td>
      </tr>
    </table>
  </div>
</div>
<script type="text/javascript">
$(function(){
  var tipo = $('#divDatos<%=tipo%>').attr('data-tipo');
  var idSucursal = $('.'+tipo).attr('data-idSucursal');
  var idUsuario = $('.'+tipo).attr('data-idUsuario');
  var perfil = $('.'+tipo).attr('data-perfil');
  var url = 'gestiones/datosGestiones.asp?tipo='+tipo+'&idSucursal='+idSucursal+'&idUsuario='+idUsuario+'&perfil='+perfil;
  $.when($.ajax(url)).then(function(data) {
    $.each( data.datosGestiones, function( key, valoresDatos ) {
      var tipo = valoresDatos.tipo;
      var tipoClase = valoresDatos.tipoClase;
      var clasePorcentaje = valoresDatos.clasePorcentaje;
      var icono = valoresDatos.icono;
      var totalTareasTerminadas = valoresDatos.totalTareasTerminadas;
      var totalTareasNoTerminadas = valoresDatos.totalTareasNoTerminadas;
      var porcentaje = valoresDatos.porcentaje;
      $('#'+tipoClase).removeClass("fondo100 fondo50 fondo0").addClass('fondo'+clasePorcentaje);
      $('#icono'+tipo).html('<i class="'+icono+' icon-4x"></i>');
      $('#totalTareasTerminadas'+tipo).html(totalTareasTerminadas);
      $('#totalTareasNoterminadas'+tipo).html(totalTareasNoTerminadas);
      $('#porcentajeTareas'+tipo).html(porcentaje);
    });
  });
});
</script>