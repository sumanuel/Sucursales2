<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "text/html"
Response.CodePage = 65001
Response.CharSet = "utf-8"

Function TextoSeguro(valor)
  If IsNull(valor) Then
    TextoSeguro = ""
  Else
    TextoSeguro = Server.HTMLEncode(CStr(valor))
  End If
End Function

Function TextoJS(valor)
  If IsNull(valor) Then
    valor = ""
  End If
  valor = CStr(valor)
  valor = Replace(valor, "\", "\\")
  valor = Replace(valor, Chr(34), "\" & Chr(34))
  valor = Replace(valor, vbCrLf, " ")
  valor = Replace(valor, vbCr, " ")
  valor = Replace(valor, vbLf, " ")
  TextoJS = valor
End Function

Function FormatearFechaDMY(valorFecha)
  If IsNull(valorFecha) Or Trim(CStr(valorFecha)) = "" Then
    FormatearFechaDMY = ""
  Else
    FormatearFechaDMY = Right("0" & Day(CDate(valorFecha)), 2) & "/" & Right("0" & Month(CDate(valorFecha)), 2) & "/" & Year(CDate(valorFecha))
  End If
End Function

Function EstadoClase(valorEstado)
  Dim estadoTexto
  estadoTexto = UCase(Trim(valorEstado & ""))
  EstadoClase = "label"
  If estadoTexto = "EN CAPACITACION" Then
    EstadoClase = "label label-warning"
  ElseIf estadoTexto = "APROBADA" Then
    EstadoClase = "label label-success"
  ElseIf estadoTexto = "RECHAZADA" Then
    EstadoClase = "label label-important"
  Else
    EstadoClase = "label"
  End If
End Function

Dim perfilMain, idSucursal, sqlSucursal, rsSucursal, nombreSucursal
Dim sqlEva, rsEva, sqlPreguntas, rsPreguntas
Dim tieneEvaluaciones, tienePreguntas, primeraColumnaEva, primeraColumnaPre
Dim preguntasData, totalPreguntas, idxPregunta

perfilMain = Trim(Request("perfilMain") & "")
idSucursal = Trim(Request("idSucursalMain") & "")
nombreSucursal = ""
totalPreguntas = 0

If perfilMain <> "" And perfilMain <> "1" Then
%>
<div class="row-fluid">
  <span class="span12 alert alert-danger">
    <strong><h4><i class="icon-warning-sign"></i> Este modulo solo esta disponible para el perfil JEPS.</h4></strong>
  </span>
</div>
<%
  Response.End
End If

If idSucursal = "" Or Not IsNumeric(idSucursal) Or CLng(idSucursal) <= 0 Then
%>
<div class="row-fluid">
  <span class="span12 alert alert-danger">
    <strong><h4><i class="icon-warning-sign"></i> Seleccione una sucursal para consultar las evaluaciones.</h4></strong>
  </span>
</div>
<%
  Response.End
End If

sqlSucursal = "SELECT suc_nombre FROM dbo.SUC_sucursal WHERE id_sucursal = " & CLng(idSucursal)
Set rsSucursal = DB.Execute(sqlSucursal)
If Not rsSucursal.EOF Then
  nombreSucursal = rsSucursal("suc_nombre") & ""
End If
If rsSucursal.State = 1 Then rsSucursal.Close
Set rsSucursal = Nothing

sqlEva = "EXEC dbo.SP_SUC_listar_eva_cajero @ID_SUCURSAL = " & CLng(idSucursal) & ", @TOP_REGISTROS = 200, @VALIDAR_FECHA_DESDE = 1"
Set rsEva = DB.Execute(sqlEva)

tieneEvaluaciones = False
primeraColumnaEva = ""
If Not rsEva.EOF Then
  primeraColumnaEva = UCase(Trim(rsEva.Fields(0).Name & ""))
  If primeraColumnaEva <> "RESULTADO" Then
    tieneEvaluaciones = True
  End If
End If

sqlPreguntas = "EXEC dbo.SP_SUC_obtener_pre_eva_cajero"
Set rsPreguntas = DB.Execute(sqlPreguntas)

tienePreguntas = False
primeraColumnaPre = ""
If Not rsPreguntas.EOF Then
  primeraColumnaPre = UCase(Trim(rsPreguntas.Fields(0).Name & ""))
  If primeraColumnaPre <> "RESULTADO" Then
    preguntasData = rsPreguntas.GetRows()
    totalPreguntas = UBound(preguntasData, 2) + 1
    tienePreguntas = (totalPreguntas > 0)
  End If
End If
%>
<div class="row-fluid" id="moduloEvaluacionCajeros">
  <div class="row-fluid">
    <span class="span12 alert alert-success">
      <strong>
        <h4>
          <i class="icon-check-sign"></i>
          Evaluacion Cajeros
        </h4>
      </strong>
      <div>Sucursal actual: <strong><%=TextoSeguro(nombreSucursal)%></strong></div>
      <div>Seleccione un cajero y presione Evaluar para abrir el formulario.</div>
    </span>
  </div>

  <div id="resultadoEvaluacionCajeros"></div>

  <div class="row-fluid">
    <div class="span12">
      <div class="well">
        <h4 style="margin-top:0;">Cajeros pendientes o disponibles para evaluacion</h4>
        <%
        If primeraColumnaEva = "RESULTADO" Then
        %>
          <div class="alert alert-error"><strong>Error:</strong> <%=TextoSeguro(rsEva("mensaje"))%></div>
        <%
        ElseIf Not tieneEvaluaciones Then
        %>
          <div class="alert alert-info">No hay cajeros disponibles para evaluacion en esta sucursal.</div>
        <%
        Else
        %>
          <table class="table table-bordered table-striped table-hover">
            <thead>
              <tr>
                <th>Rut</th>
                <th>Nombre</th>
                <th>Empresa</th>
                <th>Desde</th>
                <th>Hasta</th>
                <th>Estado</th>
                <th style="width: 110px; text-align: center;">Accion</th>
              </tr>
            </thead>
            <tbody>
              <%
              Do While Not rsEva.EOF
              %>
              <tr>
                <td><%=TextoSeguro(rsEva("EVA_RUT"))%></td>
                <td><%=TextoSeguro(rsEva("EVA_NOMBRE"))%></td>
                <td><%=TextoSeguro(rsEva("EVA_EMP"))%></td>
                <td><%=TextoSeguro(FormatearFechaDMY(rsEva("EVA_FCH_DES")))%></td>
                <td><%=TextoSeguro(FormatearFechaDMY(rsEva("EVA_FCH_HAS")))%></td>
                <td><span class="<%=EstadoClase(rsEva("EVA_EST"))%>"><%=TextoSeguro(rsEva("EVA_EST"))%></span></td>
                <td style="text-align:center;">
                  <%
                  If tienePreguntas And UCase(Trim(rsEva("EVA_EST") & "")) = "EN CAPACITACION" Then
                  %>
                    <button
                      type="button"
                      class="btn btn-mini btn-primary btnAbrirFormularioEvaluacion"
                      data-id-eva="<%=TextoSeguro(rsEva("ID_EVA"))%>"
                      data-rut="<%=TextoSeguro(rsEva("EVA_RUT"))%>"
                      data-nombre="<%=TextoSeguro(rsEva("EVA_NOMBRE"))%>"
                      data-empresa="<%=TextoSeguro(rsEva("EVA_EMP"))%>"
                    >
                      <i class="icon-check icon-white"></i> Evaluar
                    </button>
                  <%
                  Else
                  %>
                    <span style="color:#999;">-</span>
                  <%
                  End If
                  %>
                </td>
              </tr>
              <%
                rsEva.MoveNext
              Loop
              %>
            </tbody>
          </table>
        <%
        End If
        %>

        <%
        If Not tienePreguntas Then
        %>
          <div class="alert alert-info" style="margin-top: 15px; margin-bottom: 0;">No hay items habilitados para evaluar.</div>
        <%
        End If
        %>
      </div>
    </div>
  </div>
</div>

<div id="modalFormularioEvaluacion" class="modal hide fade" tabindex="-1" role="dialog" style="width: 900px; margin-left: -450px;">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
    <h3>Formulario de Evaluacion:</h3>
  </div>
  <div class="modal-body">
    <input type="hidden" id="eval_id_eva" value="0" />
    <div class="row-fluid" style="margin-bottom: 12px;">
      <div class="span4"><strong>Rut:</strong> <span id="eval_rut"></span></div>
      <div class="span4"><strong>Nombre:</strong> <span id="eval_nombre"></span></div>
      <div class="span4"><strong>Empresa:</strong> <span id="eval_empresa"></span></div>
    </div>

    <table class="table table-bordered table-striped" id="tablaFormularioEvaluacion">
      <thead>
        <tr>
          <th style="width: 65px; text-align: center;">Item</th>
          <th>Descripcion</th>
          <th style="width: 140px; text-align: center;">Respuesta</th>
        </tr>
      </thead>
      <tbody>
        <%
        If tienePreguntas Then
          For idxPregunta = 0 To totalPreguntas - 1
        %>
        <tr data-pre-id="<%=TextoSeguro(preguntasData(0, idxPregunta))%>">
          <td style="text-align:center;"><%=idxPregunta + 1%></td>
          <td>
            <strong><%=TextoSeguro(preguntasData(1, idxPregunta))%></strong><br />
            <span><%=TextoSeguro(preguntasData(2, idxPregunta))%></span>
          </td>
          <td style="text-align:center;">
            <select class="span12 respuesta-evaluacion" data-pre-id="<%=TextoSeguro(preguntasData(0, idxPregunta))%>">
              <option value="">[Seleccione]</option>
              <option value="1">Si</option>
              <option value="0">No</option>
              <option value="2">N/A</option>
            </select>
          </td>
        </tr>
        <%
          Next
        End If
        %>
      </tbody>
    </table>

    <div class="row-fluid" style="margin-top: 10px;">
      <div class="span4">
        <label><strong>Puntuacion:</strong></label>
        <div class="well well-small" style="margin-bottom: 0; text-align: center; font-size: 18px; font-weight: bold;" id="puntajeEvaluacion">0/0</div>
        <div class="help-block" style="margin-top: 5px;">Solo se consideran respuestas distintas de N/A.</div>
      </div>
      <div class="span8">
        <label><strong>Observacion de Sucursal:</strong></label>
        <textarea id="eval_observacion" class="span12" rows="4" maxlength="250" style="resize:none;"></textarea>
        <div class="help-block" style="text-align: right; margin-top: 5px;"><span id="contadorObservacionEvaluacion">250</span> caracteres disponibles</div>
      </div>
    </div>

    <div class="row-fluid" style="margin-top: 10px;">
      <div class="span4">
        <label><strong>Estado:</strong></label>
        <select id="eval_estado" class="span12">
          <option value="">[Seleccione]</option>
          <option value="2">Aprobado</option>
          <option value="3">Reprobado</option>
        </select>
      </div>
    </div>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal">Cancelar</button>
    <button class="btn btn-primary" id="btnGuardarFormularioEvaluacion">Guardar evaluacion</button>
  </div>
</div>

<script type="text/javascript">
  function mostrarResultadoModuloEvaluacion(tipo, titulo, mensaje) {
    var clase = tipo === "OK" ? "alert-success" : "alert-error";
    var html = '';
    html += '<div class="alert ' + clase + '">';
    html += '<strong>' + titulo + '</strong><br />';
    html += mensaje;
    html += '</div>';
    $("#resultadoEvaluacionCajeros").html(html);
  }

  function actualizarPuntajeEvaluacion() {
    var totalConsiderados = 0;
    var totalSi = 0;

    $("#tablaFormularioEvaluacion .respuesta-evaluacion").each(function () {
      var valor = $.trim($(this).val() || "");
      if (valor === "1" || valor === "0") {
        totalConsiderados += 1;
      }
      if (valor === "1") {
        totalSi += 1;
      }
    });

    $("#puntajeEvaluacion").text(totalSi + "/" + totalConsiderados);
  }

  function actualizarContadorObservacionEvaluacion() {
    var maximo = 250;
    var actual = ($("#eval_observacion").val() || "").length;
    var restante = maximo - actual;
    if (restante < 0) {
      restante = 0;
    }
    $("#contadorObservacionEvaluacion").text(restante);
  }

  function limpiarFormularioEvaluacion() {
    $("#eval_id_eva").val("0");
    $("#eval_rut").text("");
    $("#eval_nombre").text("");
    $("#eval_empresa").text("");
    $("#eval_observacion").val("");
    $("#eval_estado").val("");
    $("#tablaFormularioEvaluacion .respuesta-evaluacion").val("");
    actualizarPuntajeEvaluacion();
    actualizarContadorObservacionEvaluacion();
  }

  function recargarModuloEvaluacionCajeros() {
    var divDestino = "area";
    if ($("#indicesZOnal").find("#moduloEvaluacionCajeros").length > 0) {
      divDestino = "indicesZOnal";
    }
    try {
      enviaDatos("sucursales/evaluacionCajeros.asp", divDestino, "");
    } catch (err) {
    }
  }

  $(document)
    .off("click", ".btnAbrirFormularioEvaluacion")
    .on("click", ".btnAbrirFormularioEvaluacion", function () {
      limpiarFormularioEvaluacion();
      $("#eval_id_eva").val($(this).attr("data-id-eva") || "0");
      $("#eval_rut").text($(this).attr("data-rut") || "");
      $("#eval_nombre").text($(this).attr("data-nombre") || "");
      $("#eval_empresa").text($(this).attr("data-empresa") || "");
      $("#modalFormularioEvaluacion").modal("show");
    });

  $(document)
    .off("change", "#tablaFormularioEvaluacion .respuesta-evaluacion")
    .on("change", "#tablaFormularioEvaluacion .respuesta-evaluacion", function () {
      actualizarPuntajeEvaluacion();
    });

  $(document)
    .off("input", "#eval_observacion")
    .on("input", "#eval_observacion", function () {
      actualizarContadorObservacionEvaluacion();
    });

  $(document)
    .off("click", "#btnGuardarFormularioEvaluacion")
    .on("click", "#btnGuardarFormularioEvaluacion", function () {
      var respuestas = [];
      var incompleto = false;
      var estado = $.trim($("#eval_estado").val() || "");
      var observacion = $.trim($("#eval_observacion").val() || "");

      $("#tablaFormularioEvaluacion .respuesta-evaluacion").each(function () {
        var valor = $.trim($(this).val() || "");
        var preId = $.trim($(this).attr("data-pre-id") || "");
        if (valor === "") {
          incompleto = true;
          return false;
        }
        respuestas.push(preId + ":" + valor);
      });

      if (incompleto) {
        alert("Debe responder todos los items del formulario.");
        return;
      }

      if (estado === "") {
        alert("Debe seleccionar el estado de la evaluacion.");
        return;
      }

      $.ajax({
        type: "POST",
        url: "sucursales/evaluacionCajeros_guardar.asp",
        dataType: "json",
        cache: false,
        data: {
          id_eva: $("#eval_id_eva").val(),
          eva_com: observacion,
          eva_est: estado,
          respuestas: respuestas.join("|")
        },
        success: function (respuesta) {
          if (respuesta.resultado === "OK") {
            $("#modalFormularioEvaluacion").modal("hide");
            mostrarResultadoModuloEvaluacion("OK", "Evaluacion guardada", respuesta.mensaje || "La evaluacion se guardo correctamente.");
            recargarModuloEvaluacionCajeros();
          } else {
            mostrarResultadoModuloEvaluacion("ERROR", "No fue posible guardar", respuesta.mensaje || "Ocurrio un error al guardar la evaluacion.");
          }
        },
        error: function (xhr) {
          var mensaje = "Ocurrio un error al guardar la evaluacion.";
          if (xhr && xhr.responseText) {
            mensaje = xhr.responseText;
          }
          mostrarResultadoModuloEvaluacion("ERROR", "No fue posible guardar", mensaje);
        }
      });
    });

  actualizarPuntajeEvaluacion();
  actualizarContadorObservacionEvaluacion();
</script>
<%
If IsObject(rsEva) Then
  If rsEva.State = 1 Then rsEva.Close
  Set rsEva = Nothing
End If

If IsObject(rsPreguntas) Then
  If rsPreguntas.State = 1 Then rsPreguntas.Close
  Set rsPreguntas = Nothing
End If
%>