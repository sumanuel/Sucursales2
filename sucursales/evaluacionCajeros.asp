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

Function FormatearFechaISO(valorFecha)
  If IsNull(valorFecha) Or Trim(CStr(valorFecha)) = "" Then
    FormatearFechaISO = ""
  Else
    FormatearFechaISO = Year(CDate(valorFecha)) & "-" & Right("0" & Month(CDate(valorFecha)), 2) & "-" & Right("0" & Day(CDate(valorFecha)), 2)
  End If
End Function

Function PrimerValorParametro(valor)
  Dim texto, partes
  If IsNull(valor) Then
    PrimerValorParametro = ""
    Exit Function
  End If

  texto = Trim(CStr(valor))
  If texto = "" Then
    PrimerValorParametro = ""
    Exit Function
  End If

  If InStr(texto, ",") > 0 Then
    partes = Split(texto, ",")
    texto = partes(0)
  End If

  PrimerValorParametro = Trim(texto)
End Function

Function NormalizarFechaFiltro(valor)
  Dim texto, partes
  texto = PrimerValorParametro(valor)

  If texto = "" Then
    NormalizarFechaFiltro = ""
  ElseIf Len(texto) = 10 And Mid(texto, 5, 1) = "-" And Mid(texto, 8, 1) = "-" Then
    NormalizarFechaFiltro = texto
  ElseIf Len(texto) = 10 And Mid(texto, 3, 1) = "/" And Mid(texto, 6, 1) = "/" Then
    partes = Split(texto, "/")
    If UBound(partes) = 2 Then
      NormalizarFechaFiltro = partes(2) & "-" & Right("0" & partes(1), 2) & "-" & Right("0" & partes(0), 2)
    Else
      NormalizarFechaFiltro = ""
    End If
  Else
    NormalizarFechaFiltro = ""
  End If
End Function

Function NormalizarEstadoFiltro(valor)
  Dim texto
  texto = PrimerValorParametro(valor)
  If texto = "1" Or texto = "2" Or texto = "3" Then
    NormalizarEstadoFiltro = texto
  Else
    NormalizarEstadoFiltro = ""
  End If
End Function

Function EtiquetaEstadoFiltro(valor)
  Select Case CStr(valor)
    Case "1"
      EtiquetaEstadoFiltro = "EN CAPACITACION"
    Case "2"
      EtiquetaEstadoFiltro = "APROBADA"
    Case "3"
      EtiquetaEstadoFiltro = "RECHAZADA"
    Case Else
      EtiquetaEstadoFiltro = ""
  End Select
End Function

Function PrimerDiaMesActualISO()
  PrimerDiaMesActualISO = Year(Date()) & "-" & Right("0" & Month(Date()), 2) & "-01"
End Function

Function UltimoDiaMesActualISO()
  UltimoDiaMesActualISO = FormatearFechaISO(DateSerial(Year(Date()), Month(Date()) + 1, 0))
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
Dim filtroDesde, filtroHasta, filtroEstado, paginaActual
Dim datosEva, totalRegistros, totalPaginas, inicioIndice, finIndice, indiceRegistro
Dim etiquetaFiltro, mensajeSinDatos, estadoFila, fechaFilaIso
Dim fechaPrimerDiaMesIso, fechaUltimoDiaMesIso

perfilMain = Trim(Request("perfilMain") & "")
idSucursal = Trim(Request("idSucursalMain") & "")
nombreSucursal = ""
totalPreguntas = 0
filtroDesde = NormalizarFechaFiltro(Request("fch_desde"))
filtroHasta = NormalizarFechaFiltro(Request("fch_hasta"))
filtroEstado = NormalizarEstadoFiltro(Request("eva_est"))
paginaActual = 1
fechaPrimerDiaMesIso = PrimerDiaMesActualISO()
fechaUltimoDiaMesIso = UltimoDiaMesActualISO()

If filtroDesde = "" Then filtroDesde = fechaPrimerDiaMesIso
If filtroHasta = "" Then filtroHasta = fechaUltimoDiaMesIso

If PrimerValorParametro(Request("page")) <> "" And IsNumeric(PrimerValorParametro(Request("page"))) Then
  paginaActual = CLng(PrimerValorParametro(Request("page")))
End If
If paginaActual <= 0 Then paginaActual = 1

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

sqlEva = "SELECT TOP 5000 " & _
         "eva.ID_EVA, eva.EVA_RUT, eva.EVA_NOMBRE, suc.suc_nombre AS EVA_SUC, eva.EVA_EMP, " & _
         "eva.EVA_FCH_DES, eva.EVA_FCH_HAS, eva.EVA_COM, " & _
         "CASE eva.EVA_EST WHEN 1 THEN 'EN CAPACITACION' WHEN 2 THEN 'APROBADA' WHEN 3 THEN 'RECHAZADA' ELSE CAST(eva.EVA_EST AS VARCHAR(10)) END AS EVA_EST, " & _
         "eva.EVA_USR, eva.EVA_FCH " & _
         "FROM dbo.SUC_CAP_EVA eva " & _
         "INNER JOIN dbo.SUC_sucursal suc ON eva.EVA_SUC = suc.id_sucursal " & _
         "WHERE eva.EVA_SUC = " & CLng(idSucursal) & " " & _
         "AND eva.EVA_FCH_DES <= CONVERT(DATE, GETDATE()) "
If filtroDesde <> "" Then
  sqlEva = sqlEva & "AND CONVERT(DATE, eva.EVA_FCH_DES) >= '" & filtroDesde & "' "
End If
If filtroHasta <> "" Then
  sqlEva = sqlEva & "AND CONVERT(DATE, eva.EVA_FCH_DES) <= '" & filtroHasta & "' "
End If
If filtroEstado <> "" Then
  sqlEva = sqlEva & "AND eva.EVA_EST = " & filtroEstado & " "
End If
sqlEva = sqlEva & "ORDER BY eva.ID_EVA DESC"
Set rsEva = DB.Execute(sqlEva)

tieneEvaluaciones = False
primeraColumnaEva = ""
If Not rsEva.EOF Then
  primeraColumnaEva = UCase(Trim(rsEva.Fields(0).Name & ""))
  If primeraColumnaEva <> "RESULTADO" Then
    datosEva = rsEva.GetRows()
    totalRegistros = UBound(datosEva, 2)
    tieneEvaluaciones = (totalRegistros >= 0)
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
        <form class="js-form-filtros-evaluacion-cajeros" onsubmit="return false;" style="margin: 0;">
        <div class="row-fluid" style="margin-bottom: 15px;">
          <div class="span3">
            <label style="font-weight: bold; margin-bottom: 3px;">Desde</label>
            <input type="date" id="filtro_eva_desde_suc" name="fch_desde" class="span12 js-filtro-eva-desde-suc" value="<%=TextoSeguro(filtroDesde)%>" />
          </div>
          <div class="span3">
            <label style="font-weight: bold; margin-bottom: 3px;">Hasta</label>
            <input type="date" id="filtro_eva_hasta_suc" name="fch_hasta" class="span12 js-filtro-eva-hasta-suc" value="<%=TextoSeguro(filtroHasta)%>" />
          </div>
          <div class="span3">
            <label style="font-weight: bold; margin-bottom: 3px;">Estado</label>
            <select id="filtro_eva_estado_suc" name="eva_est" class="span12 js-filtro-eva-estado-suc">
              <option value="">[TODOS]</option>
              <option value="1" <%If filtroEstado = "1" Then Response.Write("selected=""selected""") End If%>>EN CAPACITACION</option>
              <option value="2" <%If filtroEstado = "2" Then Response.Write("selected=""selected""") End If%>>APROBADA</option>
              <option value="3" <%If filtroEstado = "3" Then Response.Write("selected=""selected""") End If%>>RECHAZADA</option>
            </select>
          </div>
          <div class="span3" style="padding-top: 23px; text-align: right;">
            <button type="button" class="btn btn-primary" id="btnFiltrarEvaluacionCajerosSuc">
              <i class="icon-search icon-white"></i> Filtrar
            </button>
            <button type="button" class="btn" id="btnMesActualEvaluacionCajerosSuc">Mes actual</button>
          </div>
        </div>
        </form>
        <h4 style="margin-top:0;">Cajeros pendientes o disponibles para evaluacion</h4>
        <%
        If primeraColumnaEva = "RESULTADO" Then
        %>
          <div class="alert alert-error"><strong>Error:</strong> <%=TextoSeguro(rsEva("mensaje"))%></div>
        <%
        ElseIf Not tieneEvaluaciones Then
        %>
          <div class="alert alert-info">No hay cajeros disponibles para evaluacion con los filtros seleccionados.</div>
        <%
        Else
          totalPaginas = Int((UBound(datosEva, 2) + 1) / 12)
          If ((UBound(datosEva, 2) + 1) Mod 12) > 0 Then totalPaginas = totalPaginas + 1
          If totalPaginas <= 0 Then totalPaginas = 1
          If paginaActual > totalPaginas Then paginaActual = totalPaginas
          inicioIndice = (paginaActual - 1) * 12
          finIndice = inicioIndice + 11
          If finIndice > UBound(datosEva, 2) Then finIndice = UBound(datosEva, 2)
        %>
          <div class="alert alert-info" style="margin-bottom: 12px;">
            <strong>Filtro aplicado:</strong>
            <%If filtroDesde <> "" Then Response.Write("Desde " & TextoSeguro(FormatearFechaDMY(filtroDesde))) Else Response.Write("Desde inicio") End If%>
            |
            <%If filtroHasta <> "" Then Response.Write("Hasta " & TextoSeguro(FormatearFechaDMY(filtroHasta))) Else Response.Write("Hasta hoy") End If%>
            <%If filtroEstado <> "" Then%>
              |
              Estado
              <%=TextoSeguro(EtiquetaEstadoFiltro(filtroEstado))%>
            <%End If%>
          </div>
          <table class="table table-bordered table-striped table-hover">
            <thead>
              <tr>
                <th>ID</th>
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
              For indiceRegistro = inicioIndice To finIndice
              %>
              <tr>
                <td><%=TextoSeguro(datosEva(0, indiceRegistro))%></td>
                <td><%=TextoSeguro(datosEva(1, indiceRegistro))%></td>
                <td><%=TextoSeguro(datosEva(2, indiceRegistro))%></td>
                <td><%=TextoSeguro(datosEva(4, indiceRegistro))%></td>
                <td><%=TextoSeguro(FormatearFechaDMY(datosEva(5, indiceRegistro)))%></td>
                <td><%=TextoSeguro(FormatearFechaDMY(datosEva(6, indiceRegistro)))%></td>
                <td><span class="<%=EstadoClase(datosEva(8, indiceRegistro))%>"><%=TextoSeguro(datosEva(8, indiceRegistro))%></span></td>
                <td style="text-align:center;">
                  <%
                  If tienePreguntas And UCase(Trim(datosEva(8, indiceRegistro) & "")) = "EN CAPACITACION" Then
                  %>
                    <button
                      type="button"
                      class="btn btn-mini btn-primary btnAbrirFormularioEvaluacion"
                      data-id-eva="<%=TextoSeguro(datosEva(0, indiceRegistro))%>"
                      data-rut="<%=TextoSeguro(datosEva(1, indiceRegistro))%>"
                      data-nombre="<%=TextoSeguro(datosEva(2, indiceRegistro))%>"
                      data-empresa="<%=TextoSeguro(datosEva(4, indiceRegistro))%>"
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
              Next
              %>
            </tbody>
          </table>
          <%
          If totalPaginas > 1 Then
            Dim inicioRango, finRango
            inicioRango = paginaActual - 2
            finRango = paginaActual + 2
            If inicioRango < 1 Then inicioRango = 1
            If finRango > totalPaginas Then finRango = totalPaginas
          %>
          <div class="pagination" style="text-align:center; margin-top:15px;">
            <ul>
              <%If paginaActual > 1 Then%>
                <li><a href="#" class="btn-pagina-evaluacion-suc" data-pagina="<%=paginaActual - 1%>">« Anterior</a></li>
              <%Else%>
                <li class="disabled"><a href="#">« Anterior</a></li>
              <%End If%>

              <%For indiceRegistro = inicioRango To finRango%>
                <%If indiceRegistro = paginaActual Then%>
                  <li class="active"><a href="#"><%=indiceRegistro%></a></li>
                <%Else%>
                  <li><a href="#" class="btn-pagina-evaluacion-suc" data-pagina="<%=indiceRegistro%>"><%=indiceRegistro%></a></li>
                <%End If%>
              <%Next%>

              <%If paginaActual < totalPaginas Then%>
                <li><a href="#" class="btn-pagina-evaluacion-suc" data-pagina="<%=paginaActual + 1%>">Siguiente »</a></li>
              <%Else%>
                <li class="disabled"><a href="#">Siguiente »</a></li>
              <%End If%>
            </ul>
          </div>
          <%
          End If
          %>
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
  var evaluacionCajerosContexto = {
    perfilMain: "<%=TextoJS(perfilMain)%>",
    idSucursalMain: "<%=TextoJS(idSucursal)%>"
  };

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
    var modulo = obtenerModuloEvaluacionActivo();
    var pagina = $.trim(modulo.find(".pagination li.active a").first().text() || "1");
    if (pagina === "" || isNaN(pagina)) {
      pagina = "1";
    }
    cargarListadoEvaluacionCajerosSucursal(parseInt(pagina, 10), modulo);
  }

  function obtenerModuloEvaluacionActivo(origen) {
    var modulo = $();

    if (origen && !origen.jquery) {
      origen = $(origen);
    }

    if (origen && origen.length) {
      modulo = origen.closest("#moduloEvaluacionCajeros");
    }

    if (!modulo.length) {
      modulo = $("#area #moduloEvaluacionCajeros:visible").first();
    }

    if (!modulo.length) {
      modulo = $("#indicesZOnal #moduloEvaluacionCajeros:visible").first();
    }

    if (!modulo.length) {
      modulo = $("#moduloEvaluacionCajeros:visible").first();
    }

    if (!modulo.length) {
      modulo = $("#moduloEvaluacionCajeros").last();
    }

    return modulo;
  }

  function cargarListadoEvaluacionCajerosSucursal(pagina, origen) {
    var modulo = obtenerModuloEvaluacionActivo(origen);
    var formulario = modulo.find(".js-form-filtros-evaluacion-cajeros").first();
    var campoDesde = modulo.find(".js-filtro-eva-desde-suc").first();
    var campoHasta = modulo.find(".js-filtro-eva-hasta-suc").first();
    var campoEstado = modulo.find(".js-filtro-eva-estado-suc").first();
    var divDestino = "area";
    if (modulo.closest("#indicesZOnal").length > 0) {
      divDestino = "indicesZOnal";
    }
    if (campoDesde.length) {
      campoDesde.val($.trim(campoDesde.val() || ""));
    }
    if (campoHasta.length) {
      campoHasta.val($.trim(campoHasta.val() || ""));
    }
    if (campoEstado.length) {
      campoEstado.val($.trim(campoEstado.val() || ""));
    }
    var datos = "page=" + encodeURIComponent(pagina || 1);
    if (formulario.length) {
      datos += "&" + formulario.serialize();
    }
    try {
      enviaDatos("sucursales/evaluacionCajeros.asp", divDestino, datos);
    } catch (err) {
    }
  }

  $(document)
    .off("click", "#btnFiltrarEvaluacionCajerosSuc")
    .on("click", "#btnFiltrarEvaluacionCajerosSuc", function () {
      cargarListadoEvaluacionCajerosSucursal(1, $(this));
    });

  $(document)
    .off("click", "#btnMesActualEvaluacionCajerosSuc")
    .on("click", "#btnMesActualEvaluacionCajerosSuc", function () {
      var modulo = obtenerModuloEvaluacionActivo($(this));
      var campoDesde = modulo.find(".js-filtro-eva-desde-suc").first();
      var campoHasta = modulo.find(".js-filtro-eva-hasta-suc").first();
      var campoEstado = modulo.find(".js-filtro-eva-estado-suc").first();
      var hoy = new Date();
      var primerDia = new Date(hoy.getFullYear(), hoy.getMonth(), 1);
      var ultimoDia = new Date(hoy.getFullYear(), hoy.getMonth() + 1, 0);
      campoDesde.val(primerDia.getFullYear() + "-" + ("0" + (primerDia.getMonth() + 1)).slice(-2) + "-" + ("0" + primerDia.getDate()).slice(-2));
      campoHasta.val(ultimoDia.getFullYear() + "-" + ("0" + (ultimoDia.getMonth() + 1)).slice(-2) + "-" + ("0" + ultimoDia.getDate()).slice(-2));
      campoEstado.val("");
      cargarListadoEvaluacionCajerosSucursal(1, modulo);
    });

  $(document)
    .off("click", ".btn-pagina-evaluacion-suc")
    .on("click", ".btn-pagina-evaluacion-suc", function (e) {
      e.preventDefault();
      cargarListadoEvaluacionCajerosSucursal($(this).data("pagina"), $(this));
    });

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

      var textoEstado = $.trim($("#eval_estado option:selected").text() || "");
      if (!confirm("Confirma guardar la evaluacion con estado " + textoEstado + "?")) {
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