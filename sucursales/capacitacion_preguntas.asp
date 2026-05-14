<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<% idSucursal=request("idSucursalMain") idUsuario =
trim(request("idUsuarioMain")) perfil = trim(request("perfilMain")) ' Para
perfil 3 (CENTRAL), no es necesario tener sucursal seleccionada %>
<style>
  .switchActiva {
    position: relative;
    display: inline-block;
    width: 44px;
    height: 22px;
  }

  .switchActiva input {
    opacity: 0;
    width: 0;
    height: 0;
  }

  .switch {
    position: relative;
    display: inline-block;
    width: 44px;
    height: 22px;
  }

  .switch input {
    opacity: 0;
    width: 0;
    height: 0;
  }

  .slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #cbd5e1;
    transition: 0.3s;
    border-radius: 24px;
  }

  .slider:before {
    position: absolute;
    content: "";
    height: 16px;
    width: 16px;
    left: 3px;
    bottom: 3px;
    background-color: white;
    transition: 0.3s;
    border-radius: 50%;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
  }

  input:checked + .slider {
    background-color: #62a364;
  }

  input:checked + .slider:before {
    transform: translateX(22px);
  }

  /* Iconos de Orden */
  .order-cell {
    text-align: center;
  }

  .order-wrapper {
    display: flex;
    flex-direction: column;
    align-items: center;
    line-height: 1;
  }

  .order-icon {
    color: #333;
    font-size: 1.1rem;
    cursor: pointer;
    user-select: none;
  }

  .order-stack {
    margin-top: -5px;
  }
</style>

<script type="text/javascript">
  // Guardar cambio de estado
  $("#btnGuardarNuevaPreguntaModal").on("click", function () {
    alert(11);
    //var url = '../sucursales/solicitudRebajaCajerosAdicionales_csv.asp?fechaDesdeSol_rebaja=' + fechaDesde + '&fechaHastaSol_rebaja=' + fechaHasta;
    //window.open(url, '_blank');
    //$('#modalNuevaPregunta').modal('hide');
  });
</script>

<div class="row-fluid span12">
  <input
    type="hidden"
    name="idSucursal"
    id="idSucursal"
    value="<%=idSucursal%>"
  />
  <div class="row-fluid">
    <span class="span12 alert alert-success">
      <strong>
        <h4>
          <span id="loadIcon" style="display: none">
            <i class="icon-spinner icon-spin icon-large"></i>
          </span>
          <span class="icon-solicitud-rebaja-cajeros">
            <i class="icon-list icon-solicitud-rebaja-cajeros-usuario"></i>
          </span>
          Preguntas capacitación cajeros
        </h4>
      </strong>
    </span>
  </div>
  <div class="row-fluid">
    <div class="span12">
      <button class="btn btn-success" id="btnCrearPregunta">
        <i class="icon-plus icon-white"></i> Nueva pregunta
      </button>
    </div>
  </div>

  <br />

  <div class="row-fluid">
    <div class="span12 well" id="formsIng" style="display: none">
      <script type="text/javascript">
        // Cancelar formulario
        $('#btnCancelarSolicitud').click(function(){
            $('#formSolicitudRebajaCajero')[0].reset();
            $('#id_solicitud_rebaja').val(''); // Limpiar el ID para que sea nueva solicitud
            // Restaurar la sucursal seleccionada originalmente
            $('#slc_sucursal').val($('#idSucursal').val());
            <% If perfil <> "3" Then %>
                // Rehabilitar campos al cancelar
                //$('#slc_sucursal').prop('disabled', false).css('background-color', '');
                $('#slc_motivo').prop('disabled', false).css('background-color', '');
                $('#txt_observaciones').prop('readonly', false).css('background-color', '');
            <% End If %>
            $('#formsIng').fadeOut('fast');
        });
      </script>
    </div>
  </div>

  <!-- Tabla de Solicitudes de Cajeros Adicionales -->
  <div class="row-fluid" id="idTablaSolicitudes">
    <div class="span12">
      <div class="row-fluid">
        <div
          class="span12"
          style="
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 15px;
          "
        >
          <div style="display: flex; align-items: center">
            <label style="margin: 0 10px 0 0">Activos:</label>
            <label class="switchActiva" style="margin: 0">
              <input id="preguntas_activas" type="checkbox" data-id="0" />
              <span class="slider"></span>
            </label>
          </div>
          <div style="display: flex; align-items: center">
            <label style="margin: 0 10px 0 0; white-space: nowrap"
              >Registros por página:</label
            >
            <select
              id="page_size_preguntas"
              style="width: 70px; margin: 0; display: inline-block"
            >
              <option value="10">10</option>
              <option value="15" selected>15</option>
              <option value="25">25</option>
              <option value="50">50</option>
            </select>
          </div>
        </div>
      </div>
      <table class="table table-bordered table-hover" id="tablaSolicitudes">
        <thead>
          <tr style="background-color: #f5f5f5">
            <th>ID</th>
            <th>Estado</th>
            <th>Título</th>
            <th>Pregunta</th>
            <th>Creación</th>
            <!--th>Usuario</th-->
            <th>Orden</th>
          </tr>
        </thead>
        <tbody id="tbodyPreguntas">
          <tr>
            <td colspan="6" align="center">
              <i class="icon-spinner icon-spin"></i> Cargando solicitudes...
            </td>
          </tr>
        </tbody>
      </table>
      <!-- Paginación -->
      <div
        class="row-fluid"
        id="paginacion_solicitudes"
        style="text-align: center; margin-top: 10px"
      ></div>
      <script type="text/javascript">
        // Editar solicitud con delegación de eventos
        $(document).on('click', '.btnEditarSolicitud', function(){
            var id = $(this).data('id');
            var url_ajax='../sucursales/obtener_solicitud_cajero_rebaja.asp?id_solicitud_rebaja=' + id;
            <% If perfil <> "3" Then %>
                url_ajax='sucursales/obtener_solicitud_cajero_rebaja.asp?id_solicitud_rebaja=' + id;
            <% End If %>
            $.ajax({
                type: 'GET',
                url: url_ajax,
                dataType: 'json',
                success: function(data){
                    console.log("data:",data)
                    $('#id_solicitud_rebaja').val(data.id_solicitud_rebaja);
                    $('#slc_sucursal').val(data.id_sucursal);
                    $('#slc_motivo').val(data.id_motivo_rebaja);
                    $('#fecha_desde').val(data.fecha_desde);
                    $('#fecha_hasta').val(data.fecha_hasta);
                    $('#slc_periodo').val(data.periodo);
                    $('#txt_observaciones').val(data.observaciones);
                    $('#slc_sucursal').prop('disabled', true).css('background-color', '#f5f5f5');
                    <% If perfil = "3" Then %>
                        // Para perfil 3 (CENTRAL), solo permitir editar fechas y periodo
                        $('#slc_motivo').prop('disabled', true).css('background-color', '#f5f5f5');
                        //$('#txt_observaciones').prop('readonly', true).css('background-color', '#f5f5f5');
                    <% Else %>
                        // Para otros perfiles
                        $('#slc_motivo').prop('disabled', false).css('background-color', '');
                        $('#txt_observaciones').prop('readonly', false).css('background-color', '');
                    <% End If %>
                    $('#txt_obligatorio').css('color', 'red');
                    $('#txt_obligatorio').css('display', 'inline');
                    $('#hidden_modo').prop('value', 'EDIT');
                    $('#formsIng').fadeIn('slow');
                    $('html, body').animate({ scrollTop: $('#formsIng').offset().top - 100 }, 500);
                },
                error: function(xhr, status, error){
                    alert('Error al cargar solicitud: ' + error);
                    console.log(xhr.responseText);
                }
            });
        });
        // Eliminar solicitud
        $('.btnEliminarSolicitud').click(function(){
            var id = $(this).data('id');
            var motivo = $(this).data('motivo');
            var url_ajax='../sucursales/eliminar_solicitud_cajero.asp';
            <% If perfil <> "3" Then %>
                url_ajax='sucursales/eliminar_solicitud_cajero.asp';
            <% End If %>
            if(confirm('¡ seguro que desea eliminar la solicitud de ' + motivo + '?')){
                $.ajax({
                    type: 'POST',
                    url: url_ajax,
                    data: { id: id },
                    dataType: 'json',
                    success: function(response){
                        if(response.resultado === 'OK'){
                            $('#preguntaRow' + id).fadeOut('fast', function(){
                            $(this).remove();
                            });
                        } else {
                            alert('Alerta: ' + response.mensaje);
                        }
                    },
                    error: function(xhr, status, error){
                        alert('Error al eliminar: ' + error);
                        console.log(xhr.responseText);
                    }
                });
            }
        });
        // ***** PAGINACIÓN *****
        $(function(){
            $('#formsIng').slideUp('fast');
            // Cargar tabla con paginación al inicio
            cargarTablaPreguntasPaginada(1, $('#preguntas_activas').prop('checked'));
        });
        // Función para cargar solicitudes con paginación
        function cargarTablaPreguntasPaginada(pagina, preguntas_activas) {
            console.log('Cargando página:', pagina);
            var pageSize = $('#page_size_preguntas').val() || 15;
            var params = {
                page: pagina,
                page_size: pageSize,
                perfil: '<%=perfil%>'
            };
            var url_ajax='../sucursales/capacitacion_preguntas_paginadas.asp';
            <% If perfil <> "3" Then %>
                params.idUsuario = '<%=idUsuario%>';
                params.idSucursal = '<%=idSucursal%>';
                url_ajax='sucursales/capacitacion_preguntas_paginadas.asp';
            <% End If %>
            url_ajax=url_ajax+'?preguntas_activas='+preguntas_activas
            console.log('Parámetros:', params);
            console.log('url_ajax', url_ajax);
            params.fechaDesdeSol_rebaja = $('#fecha_desde_sol_rebaja').val();
            params.fechaHastaSol_rebaja = $('#fecha_hasta_sol_rebaja').val();
            $.ajax({
                url: url_ajax,
                type: 'GET',
                data: params,
                dataType: 'json',
                success: function(data) {
                    console.log('Datos recibidos AJAX:', data);
                    var tbody = $('#tbodyPreguntas');
                    tbody.empty();
                    if(data.preguntas.length === 0) {
                        tbody.append('<tr><td colspan=6 style="text-align:center">No hay preguntas registradas</td></tr>');
                    } else {
                        $.each(data.preguntas, function(i, sol){
                            var tr = '<tr id="preguntaRow' + sol.PRE_ID_PRE + '">';
                            tr += '<td align="center">' + sol.PRE_ID_PRE + '</td>';
                            tr += '<td>';
                            tr += '     <label class="switch" >';
                            if (sol.PRE_EST==1){
                                tr += '         <input type="checkbox" checked data-id="' + sol.PRE_ID_PRE + '">';
                                }else{
                                    tr += '         <input type="checkbox" data-id="' + sol.PRE_ID_PRE + '">';
                            }
                            tr += '         <span class="slider"></span>';
                            tr += '     </label>';
                            tr += '</td>';
                            tr += '<td>' + sol.PRE_TIT + '</td>';
                            tr += '<td align="center">' + sol.PRE_PRE + '</td>';
                            tr += '<td align="center">' + (sol.PRE_FCH || '') + '</td>';
                            //tr += '<td>' + (sol.PRE_USR || '') + '</td>';
                            tr += '<td align="center">' ;
                            if(!$('#preguntas_activas').prop('checked')){
                                if (data.MIN_ORD!=sol.PRE_ORD){
                                    tr += '<i class="icon-chevron-up icon-large mano btnOrden" data-orden="SUBIR" data-id="' + sol.PRE_ID_PRE + '" title="Subir"></i><br>';
                                }
                                if (data.MAX_ORD!=sol.PRE_ORD){
                                    tr += '<i class="icon-chevron-down icon-large mano btnOrden" data-orden="BAJAR"  data-id="' + sol.PRE_ID_PRE + '" title="Bajar"></i>';
                                }
                            }
                            tr += '</td>';
                            tr += '</tr>';
                            tbody.append(tr);
                        });
                    }
                    // Generar controles de paginación
                    generarPaginacion(data.page, data.totalPaginas);
                },
                error: function(xhr, status, error) {
                    console.error('Error al cargar preguntas:', error);
                    console.error('Response:', xhr.responseText);
                    alert('Error al cargar las preguntas');
                }
            });
        }
        // Función para generar controles de paginación
        function generarPaginacion(paginaActual, totalPaginas) {
            var html = '<div class="pagination pagination-centered">';
            html += '<ul>';
            // Botón anterior
            if(paginaActual > 1) {
                html += '<li><a href="#" class="btn-pagina-solicitud" data-pagina="' + (paginaActual - 1) + '">« Anterior</a></li>';
                } else {
                    html += '<li class="disabled"><span>« Anterior</span></li>';
            }
            // Números de página
            var inicio = Math.max(1, paginaActual - 2);
            var fin = Math.min(totalPaginas, paginaActual + 2);
            if(inicio > 1) {
            html += '<li><a href="#" class="btn-pagina-solicitud" data-pagina="1">1</a></li>';
                if(inicio > 2) html += '<li class="disabled"><span>...</span></li>';
            }
            for(var i = inicio; i <= fin; i++) {
                if(i === paginaActual) {
                    html += '<li class="active"><span>' + i + '</span></li>';
                    } else {
                        html += '<li><a href="#" class="btn-pagina-solicitud" data-pagina="' + i + '">' + i + '</a></li>';
                }
            }
            if(fin < totalPaginas) {
                if(fin < totalPaginas - 1) html += '<li class="disabled"><span>...</span></li>';
                    html += '<li><a href="#" class="btn-pagina-solicitud" data-pagina="' + totalPaginas + '">' + totalPaginas + '</a></li>';
            }
            // Botón siguiente
            if(paginaActual < totalPaginas) {
                html += '<li><a href="#" class="btn-pagina-solicitud" data-pagina="' + (paginaActual + 1) + '">Siguiente »</a></li>';
                } else {
                    html += '<li class="disabled"><span>Siguiente »</span></li>';
            }
            html += '</ul>';
            html += '</div>';
        $('#paginacion_solicitudes').html(html);
        }
        // Evento para cambiar de página
        $(document).on('click', '.btn-pagina-solicitud', function(e){
            e.preventDefault();
            var pagina = $(this).data('pagina');
            cargarTablaPreguntasPaginada(pagina, $('#preguntas_activas').prop('checked'));
        });
        // Evento para cambiar tamaño de página
        $('#page_size_preguntas').change(function(){
            cargarTablaPreguntasPaginada(1, $('#preguntas_activas').prop('checked'));
        });
      </script>
    </div>
  </div>
</div>

<script type="text/javascript">
  function registrarLog(funcionalidad, tipoAccion) {
      $.ajax({
          url: 'personal/registrar_log.asp',
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

  $(function(){
      $('#formsIng').slideUp('fast');
      // Activar eventos de los botones al cargar la pÃƒÆ'Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ'Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡gina
      activarEventosBotones();
  });

  function cargarTablaSolicitudes() {
      console.log('Llamando a cargarTablaSolicitudes...');
      var params = {
          perfil: '<%=perfil%>'
      };

      <% If perfil <> "3" Then %>
      // Solo enviar idUsuario e idSucursal si NO es perfil 3
      params.idUsuario = '<%=idUsuario%>';
      params.idSucursal = '<%=idSucursal%>';
      <% End If %>

      console.log('Parametros:', params);

          var url_ajax='../sucursales/listar_solicitudes_cajero.asp';
                  <% If perfil <> "3" Then %>
          url_ajax='sucursales/listar_solicitudes_cajero.asp';
                  <% End If %>

      $.ajax({
          url: url_ajax,
          type: 'GET',
          data: params,
          dataType: 'json',
          success: function(solicitudes) {
              console.log('Solicitudes recibidas:', solicitudes);
              var tbody = $('#tbodyPreguntas');
              tbody.empty();

              if(solicitudes.length === 0) {
                  tbody.append('<tr><td colspan="<% If perfil = "2" Or perfil = "3" Then %>10<% Else %>9<% End If %>" style="text-align:center">No hay solicitudes registradas</td></tr>');
              } else {
                  $.each(solicitudes, function(i, sol){
                      var tr = '<tr id="preguntaRow' + sol.id_solicitud_rebaja + '">';
                      tr += '<td align="center">' + sol.id_solicitud_rebaja + '</td>';
                      <% If perfil = "2" Or perfil = "3" Then %>
                      tr += '<td>' + (sol.suc_nombre || '') + '</td>';
                      <% End If %>
                      tr += '<td align="center"><span class="label label-' + sol.color_badge_rebaja + '">' + sol.nombre_estado_rebaja + '</span></td>';
                      tr += '<td>' + sol.nombre_motivo_rebaja + '</td>';
                      tr += '<td align="center">' + (sol.fecha_desde || '') + '</td>';
                      tr += '<td align="center">' + (sol.fecha_hasta || '') + '</td>';
                      tr += '<td align="center">' + sol.periodo + '</td>';
                      tr += '<td>' + (sol.observaciones || '') + '</td>';
                      tr += '<td align="center">' + (sol.fecha_registro || '') + '</td>';
                      tr += '<td align="center">';

                      <% If perfil = "3" Then %>
                          if(parseInt(sol.id_estado) === 3) {
                              tr += '<i class="icon-exchange icon-large mano btnCambiarEstadoRebaja" data-id="' + sol.id_solicitud_rebaja + '" data-id_motivoActual="' + sol.id_motivo_rebaja + '"  data-estado_rebaja="' + sol.id_estado + '" title="Cambiar Estado"></i> ';
                          }
                      <% Else %>
                          <% If perfil = "2" Then %>
                              if(parseInt(sol.id_estado) === 1 || parseInt(sol.id_estado) === 3 ) {
                                  tr += '<i class="icon-exchange icon-large mano btnCambiarEstadoRebaja" data-id="' + sol.id_solicitud_rebaja + '" data-id_motivoActual="' + sol.id_motivo_rebaja + '"  data-estado_rebaja="' + sol.id_estado + '" title="Cambiar Estado"></i> ';
                              }
                          <% End If %>
                          <% If perfil = "1" Then %>
                              if(parseInt(sol.id_estado) === 1 ) {
                                  tr += '<i class="icon-exchange icon-large mano btnCambiarEstadoRebaja" data-id="' + sol.id_solicitud_rebaja + '" data-id_motivoActual="' + sol.id_motivo_rebaja + '"  data-estado_rebaja="' + sol.id_estado + '" title="Cambiar Estado"></i> ';
                              }
                          <% End If %>
                      <% End If %>

                      <% If perfil = "1" Then %>
                          if(parseInt(sol.id_estado) === 1) {
                              tr += '<i class="icon-pencil icon-large mano btnEditarSolicitud" data-id="' + sol.id_solicitud_rebaja + '" data-id_motivoActual="' + sol.id_motivo_rebaja + '"  title="Editar"></i> ';
                          }
                          <% ElseIf perfil = "2" Then %>
                          if(parseInt(sol.id_estado) === 1 || parseInt(sol.id_estado) === 3) {
                              tr += '<i class="icon-pencil icon-large mano btnEditarSolicitud" data-id="' + sol.id_solicitud_rebaja + '" data-id_motivoActual="' + sol.id_motivo_rebaja + '"  title="Editar"></i> ';
                          }
                              <% ElseIf perfil = "3" Then %>
                              if(parseInt(sol.id_estado) === 3) {
                                  tr += '<i class="icon-pencil icon-large mano btnEditarSolicitud" data-id="' + sol.id_solicitud_rebaja + '" data-id_motivoActual="' + sol.id_motivo_rebaja + '"  title="Editar"></i> ';
                              }
                      <% End If %>
                      tr += '<i class="icon-list-alt icon-large mano btnVerHistorial" data-id="' + sol.id_solicitud_rebaja + '" title="Ver Historial"></i>';
                      tr += '</td>';
                      tr += '</tr>';
                      tbody.append(tr);
                  });
              }

              // Reactivar los eventos de editar/eliminar
              activarEventosBotones();
          },
          error: function(xhr, status, error) {
              console.error('Error al recargar la tabla:', error);
              console.error('Status:', status);
              console.error('Response:', xhr.responseText);
              alert('Error al recargar la tabla de solicitudes. Ver consola para detalles.');
          }
      });
  }

  function activarEventosBotones() {
      $('.btnEditarSolicitud').off('click').on('click', function(){
          var id = $(this).data('id');
          console.log('Editando solicitud ID:', id);

          var url_ajax='../sucursales/obtener_solicitud_cajero.asp';
          <% If perfil <> "3" Then %>
              url_ajax='sucursales/obtener_solicitud_cajero.asp';
          <% End If %>

          $.ajax({
              type: 'GET',
              url: url_ajax,
              data: {id_solicitud_rebaja: id},
              dataType: 'json',
              success: function(data){
                  console.log('Datos recibidos:', data);

                  if(data.error) {
                      alert('Alerta: ' + data.error);
                      return;
                  }

                  // Llenar los campos del formulario
                  $('#id_solicitud_rebaja').val(data.id_solicitud_rebaja);
                  $('#slc_sucursal').val(data.id_sucursal);
                  $('#slc_motivo').val(data.motivo_solicitud);
                  $('#fecha_desde').val(data.fecha_desde);
                  $('#fecha_hasta').val(data.fecha_hasta);

                  // Precargar periodo con trim y verificaciÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³n
                  var periodo = $.trim(data.periodo);
                  console.log('Periodo a seleccionar:', periodo);
                  $('#slc_periodo').val(periodo);
                  console.log('Periodo seleccionado en SELECT:', $('#slc_periodo').val());

                  // Si no se seleccionÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³, intentar buscar el valor exacto
                  if($('#slc_periodo').val() === null || $('#slc_periodo').val() === ''){
                      $('#slc_periodo option').each(function(){
                          if($.trim($(this).val()) === periodo){
                              $(this).prop('selected', true);
                              console.log('Periodo encontrado y seleccionado manualmente');
                          }
                      });
                  }

                  $('#txt_observaciones').val(data.observaciones);
                  $('#slc_sucursal').prop('disabled', true).css('background-color', '#f5f5f5');
                  <% If perfil = "3" Then %>
                      // Para perfil 3 (CENTRAL), solo permitir editar fechas
                      $('#slc_motivo').prop('disabled', true).css('background-color', '#f5f5f5');
                      //$('#txt_observaciones').prop('readonly', true).css('background-color', '#f5f5f5');
                      <% Else %>
                          // Para otros perfiles, permitir editar todo
                          //$('#slc_sucursal').prop('disabled', false).css('background-color', '');
                          $('#slc_motivo').prop('disabled', false).css('background-color', '');
                          $('#txt_observaciones').prop('readonly', false).css('background-color', '');
                  <% End If %>

                  // Mostrar el formulario
                  $('#formsIng').fadeIn('slow');
              },
              error: function(xhr, status, error){
                  console.error('Error AJAX:', status, error);
                  console.log('Response:', xhr.responseText);
                  alert('Error al cargar la solicitud');
              }
          });
      });

      $('.btnEliminarSolicitud').off('click').on('click', function(){
          var id = $(this).data('id');
          var url_ajax='../sucursales/eliminar_solicitud_cajero.asp';
          <% If perfil <> "3" Then %>
              url_ajax='sucursales/eliminar_solicitud_cajero.asp';
          <% End If %>

      if(confirm('¿seguro de eliminar esta solicitud?')){
          $.ajax({
              type: 'POST',
              url: url_ajax,
              data: {id: id},
              dataType: 'json',
              success: function(response){
                  if(response.resultado === 'OK'){
                      $('#preguntaRow' + id).fadeOut('fast', function(){
                          $(this).remove();
                      });
                      alert('Solicitud eliminada correctamente');
                  } else {
                      alert('Alerta: ' + response.mensaje);
                  }
              },
              error: function(xhr, status, error){
                  alert('Error al eliminar la solicitud');
              }
          });
      }
  });

  $(document).on('click', '#btnCrearPregunta', function(){
      try {
          // Mostramos el modal de Excel
          $('#txt_TituloNuevaPregunta').val('');
          $('#txt_TextoNuevaPregunta').val('');

          $('#modalNuevaPregunta').modal('show');
      } catch(e) {
          console.error('Error al mostrar nueva pregunta:', e);
          alert('Error al abrir la ventana de exportación');
      }
  });

  $(document).on('click', '.btnOrden', function(){
      var id = $(this).data('id');
      var orden = $(this).data('orden');

      var url_ajax='../sucursales/capacitacion_preguntas_orden.asp?id=' + id + '&orden=' + orden;
      <% If perfil <> "3" Then %>
          url_ajax='sucursales/capacitacion_preguntas_orden.asp?id=' + id + '&orden=' + orden;
      <% End If %>

      $.ajax({
          url: url_ajax,
          type: 'GET',
          dataType: 'json',
          success: function(data){
              if(data.status == "OK"){
                  console.log('Orden actualizado');
                  var pagina = $(this).data('pagina');
                  cargarTablaPreguntasPaginada(pagina, $('#preguntas_activas').prop('checked'));
              }else{
                  alert('Error al ordenar. No se actualizó el orden.');
              }
          },
          error: function(){
              alert('Error al ordenar');
          }
      });
  });

  $(document).on('click', '.switch input[type="checkbox"]', function(e) {
      var id = $(this).data('id');
      e.preventDefault();

      var $checkbox = $(this);
      var estadoActual = $checkbox.prop('checked'); // true si está activado, false si no
      var estadoDeseado = !estadoActual;
      var valorParaBD = estadoDeseado ? 1 : 0;

      var url_ajax='../sucursales/capacitacion_preguntas_swap.asp';
      <% If perfil <> "3" Then %>
          url_ajax='sucursales/capacitacion_preguntas_swap.asp';
      <% End If %>

          $.ajax({
              url: url_ajax,
              type: 'POST',
              data: {
                  id: id
              },
              dataType: 'json',
              success: function(response) {
                  if (response.status === 'OK') {
                      console.log('Cambio exitoso en BD y pantalla');
                      var pagina = $(this).data('pagina');
                      cargarTablaPreguntasPaginada(pagina, $('#preguntas_activas').prop('checked'));

                  } else {
                      alert('No se pudo cambiar el estado: ' + response.mensaje);
                  }
              },
              error: function(xhr, status, error) {
                  alert('Error de conexión al intentar actualizar el estado.');
                  console.log(error);
              }
          });
  });

  $(document).on('click', '#preguntas_activas', function(e) {
      var pagina = $(this).data('pagina');
      cargarTablaPreguntasPaginada(pagina, $('#preguntas_activas').prop('checked'));
  });

  }
</script>

<!-- Modal: Nueva pregunta -->
<div
  id="modalNuevaPregunta"
  class="modal hide fade"
  style="max-width: 900px"
  tabindex="-1"
  role="dialog"
>
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
      ×
    </button>
    <h3>Nueva Pregunta</h3>
  </div>
  <!-- Agregamos un style para eliminar el padding inferior extra del body si fuera necesario -->
  <form id="formNuevaPregunta" class="form-horizontal" style="margin-bottom: 0">
    <!-- margin-bottom: 0 elimina la barra blanca -->
    <div class="modal-body" style="padding-bottom: 0">
      <div class="control-group">
        <label class="control-label" for="txt_TituloNuevaPregunta"
          >Título:</label
        >
        <div class="controls">
          <input
            type="text"
            class="span12"
            name="txt_TituloNuevaPregunta"
            id="txt_TituloNuevaPregunta"
            maxlength="50"
            placeholder="Máx. 50 caracteres"
          />
        </div>
      </div>
      <div class="control-group" style="margin-bottom: 10px">
        <!-- Reducimos el margen del último grupo -->
        <label class="control-label" for="txt_TextoNuevaPregunta"
          >Pregunta:</label
        >
        <div class="controls">
          <textarea
            class="span12"
            name="txt_TextoNuevaPregunta"
            id="txt_TextoNuevaPregunta"
            rows="4"
            maxlength="500"
            style="resize: none"
            placeholder="Máx. 500 caracteres"
          ></textarea>
        </div>
      </div>
    </div>
    <div class="modal-footer">
      <div class="span12" style="text-align: right; margin-top: 10px">
        <button type="button" class="btn" id="btnCancelarPregunta">
          <i class="icon-remove"></i> Cancelar
        </button>
        <button type="submit" class="btn btn-primary" id="btnGuardarPregunta">
          <i class="icon-save icon-white"></i> Guardar Pregunta
        </button>
      </div>
    </div>
  </form>
</div>

<script type="text/javascript">
  $("#btnCancelarPregunta").click(function () {
    $("#modalNuevaPregunta").modal("hide");
  });

  // Guardar Pregunta
  $("#formNuevaPregunta").submit(function (e) {
    e.preventDefault();

    var datos = {
      txt_TituloNuevaPregunta: $("#txt_TituloNuevaPregunta").val(),
      txt_TextoNuevaPregunta: $("#txt_TextoNuevaPregunta").val(),
    };

    console.log("Enviando datos:", datos);

    var url_ajax = "../sucursales/capacitacion_preguntas_guardar.asp";

    $.ajax({
      type: "POST",
      url: url_ajax,
      data: datos,
      dataType: "text", // Cambiado a text para ver la respuesta cruda
      success: function (responseText) {
        console.log("Respuesta cruda:", responseText);
        try {
          var response = JSON.parse(responseText);
          console.log("JSON parseado:", response);
          if (response.resultado === "OK") {
            alert("Pregunta guardada correctamente");
            // Recargar solo la tabla sin refresh completo
            cargarTablaPreguntasPaginada(
              1,
              $("#preguntas_activas").prop("checked"),
            );
            $("#modalNuevaPregunta").modal("hide");
          } else {
            alert("Alerta: " + response.mensaje);
          }
        } catch (e) {
          console.error("Error al parsear JSON:", e);
          console.log("Texto recibido:", responseText);
          alert("Error en la respuesta del servidor. Revise la consola.");
        }
      },
      error: function (xhr, status, error) {
        console.log("Status:", status);
        console.log("Error:", error);
        console.log("Response:", xhr.responseText);
        console.log("Status Code:", xhr.status);
        alert(
          "Error al guardar (Status " +
            xhr.status +
            "): " +
            error +
            "\n\nRevise la consola para mÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡s detalles.",
        );
      },
    });
  });
</script>
