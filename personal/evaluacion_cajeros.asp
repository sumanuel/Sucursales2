<div class="container-fluid" style="margin-top: 20px">
  <div class="row-fluid">
    <div class="span12">
      <div class="well">
        <div class="row-fluid">
          <div class="span12">
            <h3 style="color: #2f6f4f; margin-top: 0">Evaluacion de Cajeros</h3>
            <hr />
            <div class="alert alert-info" style="margin-bottom: 20px">
              <strong>Formato esperado del CSV:</strong>
              RUT;NOMBRE;SUCURSAL;EMPRESA;FECHA_DESDE;FECHA_HASTA<br />
              <strong>Ejemplo:</strong> 27341891-1;Nombre cajero
              1;172;ECR;06-05-2026;18-05-2026
            </div>
            <form
              id="frmCargaEvaluacionCajeros"
              method="post"
              enctype="multipart/form-data"
              action="evaluacion_cajeros_carga.asp"
              target="ifrCargaEvaluacionCajeros"
              style="margin-bottom: 20px"
            >
              <div class="row-fluid">
                <div class="span4">
                  <label style="font-weight: bold; margin-bottom: 3px"
                    >Archivo CSV</label
                  >
                  <input
                    type="file"
                    name="archivo_evaluacion"
                    id="archivo_evaluacion"
                    class="span12"
                    accept=".csv"
                  />
                  <div
                    id="infoArchivoEvaluacion"
                    class="help-block"
                    style="margin-top: 6px; color: #666"
                  ></div>
                </div>
                <div class="span5">
                  <label style="font-weight: bold; margin-bottom: 3px"
                    >Comentario</label
                  >
                  <input
                    type="text"
                    name="eva_com"
                    id="eva_com"
                    class="span12"
                    maxlength="250"
                    placeholder="Comentario opcional para todas las filas"
                  />
                </div>
                <div class="span3" style="padding-top: 23px; text-align: right">
                  <button
                    type="submit"
                    class="btn btn-success"
                    id="btnSubirEvaluacionCajeros"
                  >
                    <i class="icon-upload-alt icon-white"></i> Cargar CSV
                  </button>
                </div>
              </div>
            </form>
            <iframe
              name="ifrCargaEvaluacionCajeros"
              id="ifrCargaEvaluacionCajeros"
              style="display: none"
            ></iframe>
            <div id="resultadoCargaEvaluacionCajeros"></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="row-fluid">
    <div class="span12">
      <div class="well">
        <div class="row-fluid">
          <div class="span6">
            <h4 style="margin-top: 0">Ultimas evaluaciones cargadas</h4>
          </div>
          <div class="span6" style="text-align: right; padding-top: 6px">
            <button
              type="button"
              class="btn btn-info"
              id="btnRefrescarListadoEvaluacion"
            >
              <i class="icon-refresh icon-white"></i> Actualizar listado
            </button>
          </div>
        </div>
        <div id="contenedorListadoEvaluacionCajeros">
          <div class="alert alert-info">Consultando evaluaciones...</div>
        </div>
      </div>
    </div>
  </div>

  <div
    id="modalEditarEvaluacion"
    class="modal hide fade"
    tabindex="-1"
    role="dialog"
    aria-hidden="true"
    style="width: 700px; margin-left: -350px"
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
      <h3>Editar evaluacion</h3>
    </div>
    <div class="modal-body">
      <form id="formEditarEvaluacion">
        <input type="hidden" id="edit_id_eva" value="0" />
        <div class="row-fluid">
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px">Rut</label>
            <input type="text" id="edit_eva_rut" class="span12" readonly />
          </div>
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px">Nombre</label>
            <input type="text" id="edit_eva_nombre" class="span12" readonly />
          </div>
        </div>
        <div class="row-fluid" style="margin-top: 10px">
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px"
              >Sucursal</label
            >
            <input type="text" id="edit_eva_suc" class="span12" readonly />
          </div>
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px">Empresa</label>
            <input type="text" id="edit_eva_emp" class="span12" readonly />
          </div>
        </div>
        <div class="row-fluid" style="margin-top: 10px">
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px"
              >Fecha Desde *</label
            >
            <input type="date" id="edit_eva_fch_des" class="span12" />
          </div>
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px"
              >Fecha Hasta *</label
            >
            <input type="date" id="edit_eva_fch_has" class="span12" />
          </div>
        </div>
      </form>
    </div>
    <div class="modal-footer">
      <button class="btn" data-dismiss="modal" aria-hidden="true">
        Cancelar
      </button>
      <button class="btn btn-primary" id="btnGuardarEdicionEvaluacion">
        Guardar cambios
      </button>
    </div>
  </div>
</div>

<script type="text/javascript">
  function escaparHtmlEvaluacion(texto) {
    return $("<div/>")
      .text(texto || "")
      .html();
  }

  function formatearTamanoArchivo(bytes) {
    var kilo = 1024;
    var mega = kilo * 1024;
    if (bytes >= mega) {
      return (bytes / mega).toFixed(2) + " MB";
    }
    if (bytes >= kilo) {
      return (bytes / kilo).toFixed(2) + " KB";
    }
    return bytes + " B";
  }

  function cargarListadoEvaluacionCajeros() {
    $("#contenedorListadoEvaluacionCajeros").html(
      '<div class="alert alert-info">Consultando evaluaciones...</div>',
    );
    $("#contenedorListadoEvaluacionCajeros").load(
      "evaluacion_cajeros_listado.asp",
      function (respuesta, estado) {
        if (estado !== "success") {
          $("#contenedorListadoEvaluacionCajeros").html(
            '<div class="alert alert-error">No fue posible cargar el listado de evaluaciones.</div>',
          );
        }
      },
    );
  }

  function mostrarResultadoEvaluacion(clase, titulo, cuerpoHtml) {
    var html = "";
    html += '<div class="alert ' + clase + '">';
    html +=
      '<h4 style="margin-top:0;">' + escaparHtmlEvaluacion(titulo) + "</h4>";
    html += cuerpoHtml;
    html += "</div>";
    $("#resultadoCargaEvaluacionCajeros").html(html);
  }

  function onEvaluacionCajerosUploadCompleto(resultado) {
    var html = "";

    if (resultado.resultado !== "OK") {
      html +=
        "<p>" +
        escaparHtmlEvaluacion(
          resultado.mensaje || "No fue posible subir el archivo.",
        ) +
        "</p>";
      mostrarResultadoEvaluacion("alert-error", "Error al subir archivo", html);
      return;
    }

    html +=
      "<p><strong>Archivo:</strong> " +
      escaparHtmlEvaluacion(resultado.archivo) +
      " (" +
      escaparHtmlEvaluacion(resultado.peso) +
      ")</p>";
    html +=
      '<p><i class="icon-spinner icon-spin"></i> Procesando registros...</p>';
    mostrarResultadoEvaluacion(
      "alert-info",
      "Archivo subido correctamente",
      html,
    );

    $.ajax({
      url: "evaluacion_cajeros_procesar.asp",
      type: "POST",
      dataType: "json",
      cache: false,
      data: {
        eva_com: $("#eva_com").val(),
      },
      success: function (respuesta) {
        onEvaluacionCajerosCargaCompleta(respuesta);
      },
      error: function (xhr) {
        var mensaje = "Error al procesar el archivo cargado.";
        if (xhr && xhr.responseText) {
          mensaje = xhr.responseText;
        }
        mostrarResultadoEvaluacion(
          "alert-error",
          "Error al procesar",
          '<pre style="white-space:pre-wrap;">' +
            escaparHtmlEvaluacion(mensaje) +
            "</pre>",
        );
      },
    });
  }

  function onEvaluacionCajerosCargaCompleta(resultado) {
    var html = "";
    var clase = resultado.resultado === "OK" ? "alert-success" : "alert-error";
    var i = 0;

    html +=
      "<p><strong>Insertados:</strong> " +
      resultado.insertados +
      " | <strong>Errores:</strong> " +
      resultado.errores +
      "</p>";

    if (resultado.archivo && resultado.archivo !== "") {
      html +=
        "<p><strong>Archivo:</strong> " +
        escaparHtmlEvaluacion(resultado.archivo);
      if (resultado.peso && resultado.peso !== "") {
        html += " (" + escaparHtmlEvaluacion(resultado.peso) + ")";
      }
      html += "</p>";
    }

    if (resultado.mensajes && resultado.mensajes.length > 0) {
      html += '<ol style="margin-bottom:0;">';
      for (i = 0; i < resultado.mensajes.length; i++) {
        html +=
          "<li>" + escaparHtmlEvaluacion(resultado.mensajes[i].texto) + "</li>";
      }
      html += "</ol>";
    }

    mostrarResultadoEvaluacion(clase, "Resultado de la carga", html);
    $("#frmCargaEvaluacionCajeros")[0].reset();
    $("#infoArchivoEvaluacion").html("");
    cargarListadoEvaluacionCajeros();
  }

  $(document)
    .off("click", "#btnRefrescarListadoEvaluacion")
    .on("click", "#btnRefrescarListadoEvaluacion", function () {
      cargarListadoEvaluacionCajeros();
    });

  $(document)
    .off("click", ".btnEditarEvaluacion")
    .on("click", ".btnEditarEvaluacion", function (e) {
      e.preventDefault();
      var idEva = $(this).data("id");

      $.ajax({
        type: "GET",
        url: "evaluacion_cajeros_obtener.asp",
        data: { id: idEva },
        dataType: "json",
        success: function (data) {
          if (data.resultado && data.resultado !== "OK") {
            mostrarResultadoEvaluacion(
              "alert-error",
              "Error al cargar evaluacion",
              "<p>" +
                escaparHtmlEvaluacion(
                  data.mensaje || "No fue posible obtener el registro.",
                ) +
                "</p>",
            );
            return;
          }

          $("#edit_id_eva").val(data.id_eva || "0");
          $("#edit_eva_rut").val(data.eva_rut || "");
          $("#edit_eva_nombre").val(data.eva_nombre || "");
          $("#edit_eva_suc").val(data.eva_suc || "");
          $("#edit_eva_emp").val(data.eva_emp || "");
          $("#edit_eva_fch_des").val(data.eva_fch_des || "");
          $("#edit_eva_fch_has").val(data.eva_fch_has || "");
          $("#modalEditarEvaluacion").modal("show");
        },
        error: function (xhr) {
          var mensaje =
            xhr && xhr.responseText
              ? xhr.responseText
              : "No fue posible obtener el registro.";
          mostrarResultadoEvaluacion(
            "alert-error",
            "Error al cargar evaluacion",
            '<pre style="white-space:pre-wrap;">' +
              escaparHtmlEvaluacion(mensaje) +
              "</pre>",
          );
        },
      });
    });

  $(document)
    .off("click", "#btnGuardarEdicionEvaluacion")
    .on("click", "#btnGuardarEdicionEvaluacion", function () {
      var fechaDesde = $("#edit_eva_fch_des").val();
      var fechaHasta = $("#edit_eva_fch_has").val();

      if (fechaDesde === "" || fechaHasta === "") {
        alert("Debe indicar la fecha desde y la fecha hasta.");
        return;
      }

      $.ajax({
        type: "POST",
        url: "evaluacion_cajeros_guardar_edicion.asp",
        dataType: "json",
        data: {
          id: $("#edit_id_eva").val(),
          eva_fch_des: fechaDesde,
          eva_fch_has: fechaHasta,
        },
        success: function (respuesta) {
          if (respuesta.resultado === "OK") {
            $("#modalEditarEvaluacion").modal("hide");
            mostrarResultadoEvaluacion(
              "alert-success",
              "Evaluacion actualizada",
              "<p>" +
                escaparHtmlEvaluacion(
                  respuesta.mensaje || "Registro actualizado correctamente.",
                ) +
                "</p>",
            );
            cargarListadoEvaluacionCajeros();
          } else {
            mostrarResultadoEvaluacion(
              "alert-error",
              "Error al actualizar",
              "<p>" +
                escaparHtmlEvaluacion(
                  respuesta.mensaje || "No fue posible actualizar el registro.",
                ) +
                "</p>",
            );
          }
        },
        error: function (xhr) {
          var mensaje =
            xhr && xhr.responseText
              ? xhr.responseText
              : "No fue posible actualizar el registro.";
          mostrarResultadoEvaluacion(
            "alert-error",
            "Error al actualizar",
            '<pre style="white-space:pre-wrap;">' +
              escaparHtmlEvaluacion(mensaje) +
              "</pre>",
          );
        },
      });
    });

  $(document)
    .off("click", ".btnEliminarEvaluacion")
    .on("click", ".btnEliminarEvaluacion", function (e) {
      e.preventDefault();
      var idEva = $(this).data("id");

      if (!confirm("¿Seguro que desea eliminar la evaluacion seleccionada?")) {
        return;
      }

      $.ajax({
        type: "POST",
        url: "evaluacion_cajeros_eliminar.asp",
        dataType: "json",
        data: {
          id: idEva,
        },
        success: function (respuesta) {
          if (respuesta.resultado === "OK") {
            mostrarResultadoEvaluacion(
              "alert-success",
              "Evaluacion eliminada",
              "<p>" +
                escaparHtmlEvaluacion(
                  respuesta.mensaje || "Registro eliminado correctamente.",
                ) +
                "</p>",
            );
            cargarListadoEvaluacionCajeros();
          } else {
            mostrarResultadoEvaluacion(
              "alert-error",
              "Error al eliminar",
              "<p>" +
                escaparHtmlEvaluacion(
                  respuesta.mensaje || "No fue posible eliminar el registro.",
                ) +
                "</p>",
            );
          }
        },
        error: function (xhr) {
          var mensaje =
            xhr && xhr.responseText
              ? xhr.responseText
              : "No fue posible eliminar el registro.";
          mostrarResultadoEvaluacion(
            "alert-error",
            "Error al eliminar",
            '<pre style="white-space:pre-wrap;">' +
              escaparHtmlEvaluacion(mensaje) +
              "</pre>",
          );
        },
      });
    });

  $(document)
    .off("change", "#archivo_evaluacion")
    .on("change", "#archivo_evaluacion", function () {
      var info = "";
      var archivo = this.files && this.files.length > 0 ? this.files[0] : null;
      if (archivo) {
        info =
          "Seleccionado: " +
          archivo.name +
          " (" +
          formatearTamanoArchivo(archivo.size || 0) +
          ")";
      }
      $("#infoArchivoEvaluacion").html(info);
    });

  $(document)
    .off("submit", "#frmCargaEvaluacionCajeros")
    .on("submit", "#frmCargaEvaluacionCajeros", function () {
      if ($("#archivo_evaluacion").val() === "") {
        alert("Seleccione un archivo CSV para continuar.");
        return false;
      }

      mostrarResultadoEvaluacion(
        "alert-info",
        "Subiendo archivo",
        '<p><i class="icon-spinner icon-spin"></i> Subiendo archivo...</p>',
      );
      return true;
    });

  cargarListadoEvaluacionCajeros();
</script>
