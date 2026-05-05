<!--#include file="../conexion/conexion.asp"-->

<%
Function FormatearFechaDMY(valorFecha)
  If IsNull(valorFecha) Or Trim(CStr(valorFecha)) = "" Then
    FormatearFechaDMY = ""
  Else
    FormatearFechaDMY = Right("0" & Day(CDate(valorFecha)), 2) & "/" & Right("0" & Month(CDate(valorFecha)), 2) & "/" & Year(CDate(valorFecha))
  End If
End Function

Function TextoSeguro(valor)
  If IsNull(valor) Then
    TextoSeguro = ""
  Else
    TextoSeguro = Server.HTMLEncode(CStr(valor))
  End If
End Function
%>

<div class="container-fluid" style="margin-top: 20px;">
  <div class="row-fluid">
    <div class="span12">
      <div class="well">
        <div class="row-fluid">
          <div class="span12">
            <h3 style="color: #2f6f4f; margin-top: 0;">Evaluacion de Cajeros</h3>
            <hr />
            <div class="alert alert-info" style="margin-bottom: 20px;">
              <strong>Formato esperado del CSV:</strong>
              RUT;NOMBRE;SUCURSAL;EMPRESA;FECHA_DESDE;FECHA_HASTA<br />
              <strong>Ejemplo:</strong> 27341891-1;Nombre cajero 1;172;ECR;06-05-2026;18-05-2026
            </div>
            <form id="frmCargaEvaluacionCajeros" method="post" enctype="multipart/form-data" action="evaluacion_cajeros_carga.asp" target="ifrCargaEvaluacionCajeros" style="margin-bottom: 20px;">
              <div class="row-fluid">
                <div class="span4">
                  <label style="font-weight: bold; margin-bottom: 3px;">Archivo CSV</label>
                  <input type="file" name="archivo_evaluacion" id="archivo_evaluacion" class="span12" accept=".csv" />
                </div>
                <div class="span5">
                  <label style="font-weight: bold; margin-bottom: 3px;">Comentario</label>
                  <input type="text" name="eva_com" id="eva_com" class="span12" maxlength="250" placeholder="Comentario opcional para todas las filas" />
                </div>
                <div class="span3" style="padding-top: 23px; text-align: right;">
                  <button type="submit" class="btn btn-success" id="btnSubirEvaluacionCajeros">
                    <i class="icon-upload-alt icon-white"></i> Cargar CSV
                  </button>
                </div>
              </div>
            </form>
            <iframe name="ifrCargaEvaluacionCajeros" id="ifrCargaEvaluacionCajeros" style="display: none;"></iframe>
            <div id="resultadoCargaEvaluacionCajeros"></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="row-fluid">
    <div class="span12">
      <div class="well">
        <h4 style="margin-top: 0;">Ultimas evaluaciones cargadas</h4>
        <table class="table table-bordered table-hover">
          <thead>
            <tr style="background-color: #f5f5f5;">
              <th>Rut</th>
              <th>Nombre</th>
              <th>Sucursal</th>
              <th>Empresa</th>
              <th>Desde</th>
              <th>Hasta</th>
              <th>Comentario</th>
              <th>Estado</th>
              <th>Usuario</th>
              <th>Fecha Registro</th>
            </tr>
          </thead>
          <tbody id="tbodyEvaluacionCajeros">
<%
On Error Resume Next
Dim rsEva
Dim sqlEva
Dim estadoTexto

sqlEva = "EXEC dbo.SP_SUC_listar_eva_cajero @TOP_REGISTROS = 100"
Set rsEva = db.Execute(sqlEva)

If Err.Number <> 0 Then
%>
            <tr>
              <td colspan="10" style="color: red; text-align: center;">Error SQL: <%=TextoSeguro(Err.Description)%></td>
            </tr>
<%
  Response.End
End If

If Not rsEva.EOF Then
  Do Until rsEva.EOF
    estadoTexto = "Inactivo"
    If Trim(rsEva("EVA_EST") & "") = "1" Then
      estadoTexto = "Activo"
    End If
%>
            <tr>
              <td><%=TextoSeguro(rsEva("EVA_RUT"))%></td>
              <td><%=TextoSeguro(rsEva("EVA_NOMBRE"))%></td>
              <td><%=TextoSeguro(rsEva("EVA_SUC"))%></td>
              <td><%=TextoSeguro(rsEva("EVA_EMP"))%></td>
              <td><%=FormatearFechaDMY(rsEva("EVA_FCH_DES"))%></td>
              <td><%=FormatearFechaDMY(rsEva("EVA_FCH_HAS"))%></td>
              <td><%=TextoSeguro(rsEva("EVA_COM"))%></td>
              <td><%=estadoTexto%></td>
              <td><%=TextoSeguro(rsEva("EVA_USR"))%></td>
              <td><%=TextoSeguro(rsEva("EVA_FCH"))%></td>
            </tr>
<%
    rsEva.MoveNext
  Loop
Else
%>
            <tr>
              <td colspan="10" style="text-align: center;">No hay evaluaciones registradas</td>
            </tr>
<%
End If

If IsObject(rsEva) Then
  If rsEva.State = 1 Then
    rsEva.Close
  End If
  Set rsEva = Nothing
End If

On Error GoTo 0
%>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
function recargarPantallaEvaluacionCajeros() {
  $("#tbEvaluacionCajeros").html('<div class="alert alert-info">Consultando evaluaciones...</div>');
  $("#tbEvaluacionCajeros").load("evaluacion_cajeros.asp");
}

function escaparHtmlEvaluacion(texto) {
  return $("<div/>").text(texto || "").html();
}

function onEvaluacionCajerosCargaCompleta(resultado) {
  var html = "";
  var clase = resultado.resultado === "OK" ? "alert-success" : "alert-error";
  var i = 0;

  html += '<div class="alert ' + clase + '">';
  html += '<h4 style="margin-top:0;">Resultado de la carga</h4>';
  html += '<p><strong>Insertados:</strong> ' + resultado.insertados + ' | <strong>Errores:</strong> ' + resultado.errores + '</p>';

  if (resultado.mensajes && resultado.mensajes.length > 0) {
    html += '<ol style="margin-bottom:0;">';
    for (i = 0; i < resultado.mensajes.length; i++) {
      html += '<li>' + escaparHtmlEvaluacion(resultado.mensajes[i].texto) + '</li>';
    }
    html += '</ol>';
  }

  html += '</div>';
  $("#resultadoCargaEvaluacionCajeros").html(html);
  $("#frmCargaEvaluacionCajeros")[0].reset();
  recargarPantallaEvaluacionCajeros();
}

$(document).ready(function() {
  $("#frmCargaEvaluacionCajeros").on("submit", function() {
    if ($("#archivo_evaluacion").val() === "") {
      alert("Seleccione un archivo CSV para continuar.");
      return false;
    }

    $("#resultadoCargaEvaluacionCajeros").html('<div class="alert alert-info"><i class="icon-spinner icon-spin"></i> Procesando archivo...</div>');
    return true;
  });
});
</script>
