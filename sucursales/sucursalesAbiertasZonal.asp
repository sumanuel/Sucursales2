<!--#include file="../funciones.asp"-->
<%horaActual = time()%>
<div class="row-fluid">
  <div class="span12 ayuda" data-placement="top" data-original-title="<%=horaActual%>">
      <table class="table table-bordered table-hover table-condensed">
        <tr>
          <td rowspan="2" width="65%" id="abreInfoSucursales" class="mano">
              Sucursales Abiertas<br>
              <span class="pagination-centered">
                <h3>
                  <span id="totalSucursalesAbiertas"></span>
                  /
                  <span id="totalSucursales"></span>
                </h3>
              </span>
              <span class="badge">
                 Cerradas : <span id="totalSucursalesCerradas"></span>
              </span>
          </td>
          <td>
            <h5>
              <span>DP :</span>
              <span class="pull-right" id="totalSucAbiertasDP"></span>
            </h5>
          </td>
          </tr>
        <tr>
          <td>
            <h5>
                <span>FP :</span>
                <span class="pull-right" id="totalSucAbiertasFP">
                </span>
              </h5>
            </td>
          </tr>
      </table>
  </div>
</div>
<script type="text/javascript">
$(function(){
  $('.ayuda').tooltip();
  var perfil = $('#perfilMain').val();
  var idUsuario = $('#idUsuarioMain').val();
  url='sucursales/datosCajas.asp?perfil='+perfil+'&idUsuario='+idUsuario;
  $.when($.ajax(url)).then(function(data) {
    $.each( data.dataAperturaSucursales, function( key, valoresSucursales ) {
      var sucursalesAbiaertasFueraPlazo = valoresSucursales.sucursalesAbiaertasFueraPlazo;
      var sucursalesAbiaertasDentroPlazo = valoresSucursales.sucursalesAbiaertasDentroPlazo;
      var totalSucursales = valoresSucursales.totalSucursales;
      var sucursalesCerradas = valoresSucursales.sucursalesCerradas;
      var sucursalesAbiaertasActual = valoresSucursales.sucursalesAbiaertasActual;
      $('#totalSucAbiertasFP').html(sucursalesAbiaertasFueraPlazo);
      $('#totalSucAbiertasDP').html(sucursalesAbiaertasDentroPlazo);
      $('#totalSucursales').html(totalSucursales);
      $('#totalSucursalesCerradas').html(sucursalesCerradas);
      $('#totalSucursalesAbiertas').html(sucursalesAbiaertasActual);

    });
  });
});
$('#abreInfoSucursales').click(function(){
  //alert('llega');
  $('#divDetalleSucursales').removeClass('oculto');
  pagina='sucursales/muestraInfoSucursales.asp';
  div = 'detalleSucursales';
  datos='';
  try{
    enviaDatos(pagina,div,datos);
  }catch(err){}
  var perfil = $('#perfilMain').val();
  pagina = 'sucursales/sucursalesAbiertasZonal.asp';
  div = 'divSucursalesAbiertas';
  datos = 'idPerfil='+perfil;
  try{
    enviaDatos(pagina,div,datos);
  }catch(err){}
});

</script>