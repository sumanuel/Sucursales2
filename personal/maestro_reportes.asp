<div class="container-fluid" style="margin-top: 4px">
  <div id="resultadoMaestroReportes"></div>

  <div class="row-fluid">
    <div class="span12">
      <div class="well">
        <div class="row-fluid" style="margin-bottom: 12px">
          <div class="span12">
            <h3 style="color: #355c7d; margin-top: 0">Maestro y Reportes</h3>
            <hr />
          </div>
        </div>
        <div class="row-fluid" style="margin-bottom: 15px">
          <div class="span3">
            <label style="font-weight: bold; margin-bottom: 3px"
              >Fecha desde</label
            >
            <input type="date" id="mr_fch_desde" class="span12" />
          </div>
          <div class="span3">
            <label style="font-weight: bold; margin-bottom: 3px"
              >Fecha hasta</label
            >
            <input type="date" id="mr_fch_hasta" class="span12" />
          </div>
          <div class="span6" style="padding-top: 23px; text-align: right">
            <button
              type="button"
              class="btn btn-primary"
              id="btnFiltrarMaestroReportes"
            >
              <i class="icon-search icon-white"></i> Filtrar
            </button>
            <button
              type="button"
              class="btn"
              id="btnUltimosTresMesesMaestroReportes"
            >
              Ultimos 3 meses
            </button>
            <button
              type="button"
              class="btn btn-success"
              id="btnExportarMaestroReportesCsv"
            >
              <i class="icon-download-alt icon-white"></i> Exportar CSV
            </button>
          </div>
        </div>
        <div id="contenedorMaestroReportesListado">
          <div class="alert alert-info">Consultando cajeros...</div>
        </div>
      </div>
    </div>
  </div>

  <div
    id="modalResultadoAreasCentrales"
    class="modal hide fade"
    tabindex="-1"
    role="dialog"
    aria-hidden="true"
    style="width: 760px; margin-left: -380px"
  >
    <div class="modal-header">
      <button
        type="button"
        class="close"
        data-dismiss="modal"
        aria-hidden="true"
      >
        &times;
      </button>
      <h3>Resultado areas centrales</h3>
    </div>
    <div class="modal-body">
      <form id="formResultadoAreasCentrales">
        <input type="hidden" id="mr_id_eva" value="0" />
        <div class="row-fluid">
          <div class="span4">
            <label style="font-weight: bold; margin-bottom: 3px"
              >Rut cajero</label
            >
            <input type="text" id="mr_eva_rut" class="span12" readonly />
          </div>
          <div class="span8">
            <label style="font-weight: bold; margin-bottom: 3px"
              >Nombre cajero</label
            >
            <input type="text" id="mr_eva_nombre" class="span12" readonly />
          </div>
        </div>
        <div class="row-fluid" style="margin-top: 10px">
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px"
              >Proveedor</label
            >
            <input type="text" id="mr_eva_emp" class="span12" readonly />
          </div>
          <div class="span3">
            <label style="font-weight: bold; margin-bottom: 3px">Estado</label>
            <input type="text" id="mr_eva_est" class="span12" readonly />
          </div>
          <div class="span3">
            <label style="font-weight: bold; margin-bottom: 3px">Puntaje</label>
            <input type="text" id="mr_puntaje" class="span12" readonly />
          </div>
        </div>
        <div class="row-fluid" style="margin-top: 10px">
          <div class="span12">
            <label style="font-weight: bold; margin-bottom: 3px"
              >Comentario JEPS</label
            >
            <textarea
              id="mr_eva_com"
              class="span12"
              rows="3"
              readonly
              style="resize: none"
            ></textarea>
          </div>
        </div>
        <div class="row-fluid" style="margin-top: 10px">
          <div class="span12">
            <label style="font-weight: bold; margin-bottom: 3px"
              >Resultado areas centrales</label
            >
            <textarea
              id="mr_eva_com_cen"
              class="span12"
              rows="4"
              maxlength="250"
              style="resize: none"
            ></textarea>
            <div class="help-block" style="text-align: right; margin-top: 5px">
              <span id="mr_contador_com_cen">250</span> caracteres disponibles
            </div>
          </div>
        </div>
      </form>
    </div>
    <div class="modal-footer">
      <button class="btn" data-dismiss="modal" aria-hidden="true">
        Cancelar
      </button>
      <button class="btn btn-primary" id="btnGuardarResultadoAreasCentrales">
        Guardar
      </button>
    </div>
  </div>
</div>

<div
  id="modalVerDetalleEvaluacion"
  class="modal hide fade"
  tabindex="-1"
  role="dialog"
  aria-hidden="true"
  style="width: 900px; margin-left: -450px"
>
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
      &times;
    </button>
    <h3>Preguntas y respuestas de la evaluacion</h3>
  </div>
  <div class="modal-body" id="mrContenedorDetalleEvaluacion">
    <div class="alert alert-info">Consultando detalle...</div>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Cerrar</button>
  </div>
</div>

<script type="text/javascript">
  function mrEscaparHtml(texto) {
    return $("<div/>")
      .text(texto || "")
      .html();
  }

  function mrFormatearFechaInput(fecha) {
    var anio = fecha.getFullYear();
    var mes = ("0" + (fecha.getMonth() + 1)).slice(-2);
    var dia = ("0" + fecha.getDate()).slice(-2);
    return anio + "-" + mes + "-" + dia;
  }

  function mrEstablecerUltimosTresMeses() {
    var hoy = new Date();
    var fechaDesde = new Date(
      hoy.getFullYear(),
      hoy.getMonth() - 3,
      hoy.getDate(),
    );
    $("#mr_fch_desde").val(mrFormatearFechaInput(fechaDesde));
    $("#mr_fch_hasta").val(mrFormatearFechaInput(hoy));
  }

  function mrObtenerFiltros() {
    return {
      fch_desde: $.trim($("#mr_fch_desde").val() || ""),
      fch_hasta: $.trim($("#mr_fch_hasta").val() || ""),
    };
  }

  function mrValidarFiltros() {
    var filtros = mrObtenerFiltros();
    if (
      filtros.fch_desde !== "" &&
      filtros.fch_hasta !== "" &&
      filtros.fch_desde > filtros.fch_hasta
    ) {
      alert("La fecha desde no puede ser mayor que la fecha hasta.");
      return false;
    }
    return true;
  }

  function mrMostrarResultado(tipo, titulo, cuerpoHtml) {
    var clase = tipo === "OK" ? "alert-success" : "alert-error";
    var html = "";
    html += '<div class="alert ' + clase + '">';
    html += '<h4 style="margin-top:0;">' + mrEscaparHtml(titulo) + "</h4>";
    html += cuerpoHtml;
    html += "</div>";
    $("#resultadoMaestroReportes").html(html);
  }

  function mrLimpiarResultado() {
    $("#resultadoMaestroReportes").html("");
  }

  function mrCargarListado(pagina) {
    var filtros = mrObtenerFiltros();
    var params = {
      page: pagina || 1,
      fch_desde: filtros.fch_desde,
      fch_hasta: filtros.fch_hasta,
    };

    $("#contenedorMaestroReportesListado").html(
      '<div class="alert alert-info">Consultando cajeros...</div>',
    );
    $("#contenedorMaestroReportesListado").load(
      "maestro_reportes_listado.asp?" + $.param(params),
      function (respuesta, estado) {
        if (estado !== "success") {
          $("#contenedorMaestroReportesListado").html(
            '<div class="alert alert-error">No fue posible cargar el listado.</div>',
          );
        }
      },
    );
  }

  function mrActualizarContador() {
    var maximo = 250;
    var actual = ($("#mr_eva_com_cen").val() || "").length;
    var restante = maximo - actual;
    if (restante < 0) {
      restante = 0;
    }
    $("#mr_contador_com_cen").text(restante);
  }

  function mrAbrirModal(idEva) {
    $.ajax({
      type: "GET",
      url: "maestro_reportes_obtener.asp",
      dataType: "json",
      cache: false,
      data: { id: idEva },
      success: function (respuesta) {
        if (respuesta.resultado !== "OK") {
          mrMostrarResultado(
            "ERROR",
            "No fue posible abrir el registro",
            "<p>" +
              mrEscaparHtml(
                respuesta.mensaje || "No se encontro el registro.",
              ) +
              "</p>",
          );
          return;
        }
        $("#mr_id_eva").val(respuesta.id_eva || 0);
        $("#mr_eva_rut").val(respuesta.eva_rut || "");
        $("#mr_eva_nombre").val(respuesta.eva_nombre || "");
        $("#mr_eva_emp").val(respuesta.eva_emp || "");
        $("#mr_eva_est").val(respuesta.eva_est || "");
        $("#mr_puntaje").val(respuesta.puntaje_evaluacion || "");
        $("#mr_eva_com").val(respuesta.eva_com || "");
        $("#mr_eva_com_cen").val(respuesta.eva_com_cen || "");
        mrActualizarContador();
        $("#modalResultadoAreasCentrales").modal("show");
      },
      error: function (xhr) {
        var mensaje =
          xhr && xhr.responseText
            ? xhr.responseText
            : "Ocurrio un error al consultar el registro.";
        mrMostrarResultado(
          "ERROR",
          "No fue posible abrir el registro",
          '<pre style="white-space:pre-wrap;">' +
            mrEscaparHtml(mensaje) +
            "</pre>",
        );
      },
    });
  }

  function mrAbrirDetalleEvaluacion(idEva) {
    $("#mrContenedorDetalleEvaluacion").html(
      '<div class="alert alert-info">Consultando detalle...</div>',
    );
    $("#modalVerDetalleEvaluacion").modal("show");
    $("#mrContenedorDetalleEvaluacion").load(
      "maestro_reportes_ver_detalle.asp?id=" + encodeURIComponent(idEva),
      function (respuesta, estado) {
        if (estado !== "success") {
          $("#mrContenedorDetalleEvaluacion").html(
            '<div class="alert alert-error">No fue posible cargar el detalle de la evaluacion.</div>',
          );
        }
      },
    );
  }

  $(document)
    .off("click", "#btnFiltrarMaestroReportes")
    .on("click", "#btnFiltrarMaestroReportes", function () {
      mrLimpiarResultado();
      if (!mrValidarFiltros()) {
        return;
      }
      mrCargarListado(1);
    });

  $(document)
    .off("click", "#btnUltimosTresMesesMaestroReportes")
    .on("click", "#btnUltimosTresMesesMaestroReportes", function () {
      mrLimpiarResultado();
      mrEstablecerUltimosTresMeses();
      mrCargarListado(1);
    });

  $(document)
    .off("click", ".btn-pagina-maestro-reportes")
    .on("click", ".btn-pagina-maestro-reportes", function (e) {
      e.preventDefault();
      mrCargarListado($(this).data("pagina"));
    });

  $(document)
    .off("click", ".btnEditarResultadoCentral")
    .on("click", ".btnEditarResultadoCentral", function (e) {
      e.preventDefault();
      mrLimpiarResultado();
      mrAbrirModal($(this).data("id"));
    });

  $(document)
    .off("click", ".btnVerDetalleEvaluacion")
    .on("click", ".btnVerDetalleEvaluacion", function (e) {
      e.preventDefault();
      mrAbrirDetalleEvaluacion($(this).data("id"));
    });

  $(document)
    .off("input", "#mr_eva_com_cen")
    .on("input", "#mr_eva_com_cen", function () {
      mrActualizarContador();
    });

  $(document)
    .off("click", "#btnGuardarResultadoAreasCentrales")
    .on("click", "#btnGuardarResultadoAreasCentrales", function () {
      $.ajax({
        type: "POST",
        url: "maestro_reportes_guardar.asp",
        dataType: "json",
        cache: false,
        data: {
          id_eva: $("#mr_id_eva").val(),
          eva_com_cen: $.trim($("#mr_eva_com_cen").val() || ""),
        },
        success: function (respuesta) {
          if (respuesta.resultado === "OK") {
            $("#modalResultadoAreasCentrales").modal("hide");
            mrMostrarResultado(
              "OK",
              "Registro actualizado",
              "<p>" +
                mrEscaparHtml(
                  respuesta.mensaje || "Resultado actualizado correctamente.",
                ) +
                "</p>",
            );
            mrCargarListado(1);
          } else {
            mrMostrarResultado(
              "ERROR",
              "No fue posible guardar",
              "<p>" +
                mrEscaparHtml(
                  respuesta.mensaje || "Ocurrio un error al guardar.",
                ) +
                "</p>",
            );
          }
        },
        error: function (xhr) {
          var mensaje =
            xhr && xhr.responseText
              ? xhr.responseText
              : "Ocurrio un error al guardar.";
          mrMostrarResultado(
            "ERROR",
            "No fue posible guardar",
            '<pre style="white-space:pre-wrap;">' +
              mrEscaparHtml(mensaje) +
              "</pre>",
          );
        },
      });
    });

  $(document)
    .off("click", "#btnExportarMaestroReportesCsv")
    .on("click", "#btnExportarMaestroReportesCsv", function () {
      if (!mrValidarFiltros()) {
        return;
      }
      var filtros = mrObtenerFiltros();
      window.open(
        "maestro_reportes_exportar_csv.asp?" + $.param(filtros),
        "_blank",
      );
    });

  mrEstablecerUltimosTresMeses();
  mrActualizarContador();
  mrCargarListado(1);
</script>
