$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$main = @'
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
                  <div id="infoArchivoEvaluacion" class="help-block" style="margin-top: 6px; color: #666;"></div>
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
        <div class="row-fluid">
          <div class="span6">
            <h4 style="margin-top: 0;">Ultimas evaluaciones cargadas</h4>
          </div>
          <div class="span6" style="text-align: right; padding-top: 6px;">
            <button type="button" class="btn btn-info" id="btnRefrescarListadoEvaluacion">
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

  <div id="modalEditarEvaluacion" class="modal hide fade" tabindex="-1" role="dialog" aria-hidden="true" style="width: 700px; margin-left: -350px;">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      <h3>Editar evaluacion</h3>
    </div>
    <div class="modal-body">
      <form id="formEditarEvaluacion">
        <input type="hidden" id="edit_id_eva" value="0" />
        <div class="row-fluid">
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Rut</label>
            <input type="text" id="edit_eva_rut" class="span12" readonly />
          </div>
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Nombre</label>
            <input type="text" id="edit_eva_nombre" class="span12" readonly />
          </div>
        </div>
        <div class="row-fluid" style="margin-top: 10px;">
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Sucursal</label>
            <input type="text" id="edit_eva_suc" class="span12" readonly />
          </div>
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Empresa</label>
            <input type="text" id="edit_eva_emp" class="span12" readonly />
          </div>
        </div>
        <div class="row-fluid" style="margin-top: 10px;">
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Fecha Desde *</label>
            <input type="date" id="edit_eva_fch_des" class="span12" />
          </div>
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Fecha Hasta *</label>
            <input type="date" id="edit_eva_fch_has" class="span12" />
          </div>
        </div>
      </form>
    </div>
    <div class="modal-footer">
      <button class="btn" data-dismiss="modal" aria-hidden="true">Cancelar</button>
      <button class="btn btn-primary" id="btnGuardarEdicionEvaluacion">Guardar cambios</button>
    </div>
  </div>
</div>

<script type="text/javascript">
function escaparHtmlEvaluacion(texto) {
  return $("<div/>").text(texto || "").html();
}

function formatearTamanoArchivo(bytes) {
  var kilo = 1024;
  var mega = kilo * 1024;
  if (bytes >= mega) {
    return (bytes / mega).toFixed(2) + ' MB';
  }
  if (bytes >= kilo) {
    return (bytes / kilo).toFixed(2) + ' KB';
  }
  return bytes + ' B';
}

function cargarListadoEvaluacionCajeros() {
  $("#contenedorListadoEvaluacionCajeros").html('<div class="alert alert-info">Consultando evaluaciones...</div>');
  $("#contenedorListadoEvaluacionCajeros").load('evaluacion_cajeros_listado.asp', function(respuesta, estado) {
    if (estado !== 'success') {
      $("#contenedorListadoEvaluacionCajeros").html('<div class="alert alert-error">No fue posible cargar el listado de evaluaciones.</div>');
    }
  });
}

function mostrarResultadoEvaluacion(clase, titulo, cuerpoHtml) {
  var html = '';
  html += '<div class="alert ' + clase + '">';
  html += '<h4 style="margin-top:0;">' + escaparHtmlEvaluacion(titulo) + '</h4>';
  html += cuerpoHtml;
  html += '</div>';
  $("#resultadoCargaEvaluacionCajeros").html(html);
}

function onEvaluacionCajerosUploadCompleto(resultado) {
  var html = '';

  if (resultado.resultado !== 'OK') {
    html += '<p>' + escaparHtmlEvaluacion(resultado.mensaje || 'No fue posible subir el archivo.') + '</p>';
    mostrarResultadoEvaluacion('alert-error', 'Error al subir archivo', html);
    return;
  }

  html += '<p><strong>Archivo:</strong> ' + escaparHtmlEvaluacion(resultado.archivo) + ' (' + escaparHtmlEvaluacion(resultado.peso) + ')</p>';
  html += '<p><i class="icon-spinner icon-spin"></i> Procesando registros...</p>';
  mostrarResultadoEvaluacion('alert-info', 'Archivo subido correctamente', html);

  $.ajax({
    url: 'evaluacion_cajeros_procesar.asp',
    type: 'POST',
    dataType: 'json',
    cache: false,
    data: {
      eva_com: $("#eva_com").val()
    },
    success: function(respuesta) {
      onEvaluacionCajerosCargaCompleta(respuesta);
    },
    error: function(xhr) {
      var mensaje = 'Error al procesar el archivo cargado.';
      if (xhr && xhr.responseText) {
        mensaje = xhr.responseText;
      }
      mostrarResultadoEvaluacion('alert-error', 'Error al procesar', '<pre style="white-space:pre-wrap;">' + escaparHtmlEvaluacion(mensaje) + '</pre>');
    }
  });
}

function onEvaluacionCajerosCargaCompleta(resultado) {
  var html = '';
  var clase = resultado.resultado === 'OK' ? 'alert-success' : 'alert-error';
  var i = 0;

  html += '<p><strong>Insertados:</strong> ' + resultado.insertados + ' | <strong>Errores:</strong> ' + resultado.errores + '</p>';

  if (resultado.archivo && resultado.archivo !== '') {
    html += '<p><strong>Archivo:</strong> ' + escaparHtmlEvaluacion(resultado.archivo);
    if (resultado.peso && resultado.peso !== '') {
      html += ' (' + escaparHtmlEvaluacion(resultado.peso) + ')';
    }
    html += '</p>';
  }

  if (resultado.mensajes && resultado.mensajes.length > 0) {
    html += '<ol style="margin-bottom:0;">';
    for (i = 0; i < resultado.mensajes.length; i++) {
      html += '<li>' + escaparHtmlEvaluacion(resultado.mensajes[i].texto) + '</li>';
    }
    html += '</ol>';
  }

  mostrarResultadoEvaluacion(clase, 'Resultado de la carga', html);
  $("#frmCargaEvaluacionCajeros")[0].reset();
  $("#infoArchivoEvaluacion").html('');
  cargarListadoEvaluacionCajeros();
}

$(document).off('click', '#btnRefrescarListadoEvaluacion').on('click', '#btnRefrescarListadoEvaluacion', function() {
  cargarListadoEvaluacionCajeros();
});

$(document).off('click', '.btnEditarEvaluacion').on('click', '.btnEditarEvaluacion', function(e) {
  e.preventDefault();
  var idEva = $(this).data('id');

  $.ajax({
    type: 'GET',
    url: 'evaluacion_cajeros_obtener.asp',
    data: { id: idEva },
    dataType: 'json',
    success: function(data) {
      if (data.resultado && data.resultado !== 'OK') {
        mostrarResultadoEvaluacion('alert-error', 'Error al cargar evaluacion', '<p>' + escaparHtmlEvaluacion(data.mensaje || 'No fue posible obtener el registro.') + '</p>');
        return;
      }

      $("#edit_id_eva").val(data.id_eva || '0');
      $("#edit_eva_rut").val(data.eva_rut || '');
      $("#edit_eva_nombre").val(data.eva_nombre || '');
      $("#edit_eva_suc").val(data.eva_suc || '');
      $("#edit_eva_emp").val(data.eva_emp || '');
      $("#edit_eva_fch_des").val(data.eva_fch_des || '');
      $("#edit_eva_fch_has").val(data.eva_fch_has || '');
      $("#modalEditarEvaluacion").modal('show');
    },
    error: function(xhr) {
      var mensaje = xhr && xhr.responseText ? xhr.responseText : 'No fue posible obtener el registro.';
      mostrarResultadoEvaluacion('alert-error', 'Error al cargar evaluacion', '<pre style="white-space:pre-wrap;">' + escaparHtmlEvaluacion(mensaje) + '</pre>');
    }
  });
});

$(document).off('click', '#btnGuardarEdicionEvaluacion').on('click', '#btnGuardarEdicionEvaluacion', function() {
  var fechaDesde = $("#edit_eva_fch_des").val();
  var fechaHasta = $("#edit_eva_fch_has").val();

  if (fechaDesde === '' || fechaHasta === '') {
    alert('Debe indicar la fecha desde y la fecha hasta.');
    return;
  }

  $.ajax({
    type: 'POST',
    url: 'evaluacion_cajeros_guardar_edicion.asp',
    dataType: 'json',
    data: {
      id_eva: $("#edit_id_eva").val(),
      eva_fch_des: fechaDesde,
      eva_fch_has: fechaHasta
    },
    success: function(respuesta) {
      if (respuesta.resultado === 'OK') {
        $("#modalEditarEvaluacion").modal('hide');
        mostrarResultadoEvaluacion('alert-success', 'Evaluacion actualizada', '<p>' + escaparHtmlEvaluacion(respuesta.mensaje || 'Registro actualizado correctamente.') + '</p>');
        cargarListadoEvaluacionCajeros();
      } else {
        mostrarResultadoEvaluacion('alert-error', 'Error al actualizar', '<p>' + escaparHtmlEvaluacion(respuesta.mensaje || 'No fue posible actualizar el registro.') + '</p>');
      }
    },
    error: function(xhr) {
      var mensaje = xhr && xhr.responseText ? xhr.responseText : 'No fue posible actualizar el registro.';
      mostrarResultadoEvaluacion('alert-error', 'Error al actualizar', '<pre style="white-space:pre-wrap;">' + escaparHtmlEvaluacion(mensaje) + '</pre>');
    }
  });
});

$(document).off('click', '.btnEliminarEvaluacion').on('click', '.btnEliminarEvaluacion', function(e) {
  e.preventDefault();
  var idEva = $(this).data('id');

  if (!confirm('¿Seguro que desea eliminar la evaluacion seleccionada?')) {
    return;
  }

  $.ajax({
    type: 'POST',
    url: 'evaluacion_cajeros_eliminar.asp',
    dataType: 'json',
    data: {
      id_eva: idEva
    },
    success: function(respuesta) {
      if (respuesta.resultado === 'OK') {
        mostrarResultadoEvaluacion('alert-success', 'Evaluacion eliminada', '<p>' + escaparHtmlEvaluacion(respuesta.mensaje || 'Registro eliminado correctamente.') + '</p>');
        cargarListadoEvaluacionCajeros();
      } else {
        mostrarResultadoEvaluacion('alert-error', 'Error al eliminar', '<p>' + escaparHtmlEvaluacion(respuesta.mensaje || 'No fue posible eliminar el registro.') + '</p>');
      }
    },
    error: function(xhr) {
      var mensaje = xhr && xhr.responseText ? xhr.responseText : 'No fue posible eliminar el registro.';
      mostrarResultadoEvaluacion('alert-error', 'Error al eliminar', '<pre style="white-space:pre-wrap;">' + escaparHtmlEvaluacion(mensaje) + '</pre>');
    }
  });
});

$(document).off('change', '#archivo_evaluacion').on('change', '#archivo_evaluacion', function() {
  var info = '';
  var archivo = this.files && this.files.length > 0 ? this.files[0] : null;
  if (archivo) {
    info = 'Seleccionado: ' + archivo.name + ' (' + formatearTamanoArchivo(archivo.size || 0) + ')';
  }
  $("#infoArchivoEvaluacion").html(info);
});

$(document).off('submit', '#frmCargaEvaluacionCajeros').on('submit', '#frmCargaEvaluacionCajeros', function() {
  if ($("#archivo_evaluacion").val() === '') {
    alert('Seleccione un archivo CSV para continuar.');
    return false;
  }

  mostrarResultadoEvaluacion('alert-info', 'Subiendo archivo', '<p><i class="icon-spinner icon-spin"></i> Subiendo archivo...</p>');
  return true;
});

cargarListadoEvaluacionCajeros();
</script>
'@

$listado = @'
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
      <th style="width: 70px; text-align: center;">Acciones</th>
    </tr>
  </thead>
  <tbody>
<%
On Error Resume Next
Dim rsEva
Dim sqlEva
Dim estadoTexto
Dim idEva
Dim esActivo

sqlEva = "EXEC dbo.SP_SUC_listar_eva_cajero @TOP_REGISTROS = 100"
Set rsEva = db.Execute(sqlEva)

If Err.Number <> 0 Then
%>
    <tr>
      <td colspan="11" style="color: red; text-align: center;">Error SQL: <%=TextoSeguro(Err.Description)%></td>
    </tr>
<%
ElseIf Not rsEva.EOF Then
  Do Until rsEva.EOF
    estadoTexto = "Inactivo"
    esActivo = False
    idEva = Trim(rsEva("ID_EVA") & "")
    If Trim(rsEva("EVA_EST") & "") = "1" Then
      estadoTexto = "Activo"
      esActivo = True
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
      <td style="text-align: center; white-space: nowrap;">
<%
    If esActivo Then
%>
        <a href="#" class="btnEditarEvaluacion" data-id="<%=idEva%>" title="Editar fechas" style="margin-right: 8px;">
          <i class="icon-edit icon-large"></i>
        </a>
        <a href="#" class="btnEliminarEvaluacion" data-id="<%=idEva%>" title="Eliminar">
          <i class="icon-trash icon-large"></i>
        </a>
<%
    Else
%>
        <span style="color: #999;">-</span>
<%
    End If
%>
      </td>
    </tr>
<%
    rsEva.MoveNext
  Loop
Else
%>
    <tr>
      <td colspan="11" style="text-align: center;">No hay evaluaciones registradas</td>
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
'@

$obtener = @'
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Expires = -1

Dim idEva
Dim rsEva
Dim sqlEva

Function JsonSafe(valor)
  If IsNull(valor) Then
    valor = ""
  End If
  valor = CStr(valor)
  valor = Replace(valor, "\", "\\")
  valor = Replace(valor, Chr(34), Chr(92) & Chr(34))
  valor = Replace(valor, vbCrLf, " ")
  valor = Replace(valor, vbCr, " ")
  valor = Replace(valor, vbLf, " ")
  JsonSafe = valor
End Function

Function FormatearFechaISO(valorFecha)
  If IsNull(valorFecha) Or Trim(CStr(valorFecha)) = "" Then
    FormatearFechaISO = ""
  Else
    FormatearFechaISO = Year(CDate(valorFecha)) & "-" & Right("0" & Month(CDate(valorFecha)), 2) & "-" & Right("0" & Day(CDate(valorFecha)), 2)
  End If
End Function

idEva = 0
If Trim(Request("id") & "") <> "" Then
  idEva = CLng(Request("id"))
End If

If idEva <= 0 Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""Identificador invalido.""}"
  Response.End
End If

sqlEva = "EXEC dbo.SP_SUC_listar_eva_cajero @ID_EVA = " & idEva & ", @TOP_REGISTROS = 1"
Set rsEva = db.Execute(sqlEva)

If rsEva.EOF Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""No se encontro la evaluacion indicada.""}"
  Response.End
End If

Response.Write "{""resultado"":""OK"",""id_eva"":" & idEva & ",""eva_rut"":""" & JsonSafe(rsEva("EVA_RUT")) & """,""eva_nombre"":""" & JsonSafe(rsEva("EVA_NOMBRE")) & """,""eva_suc"":""" & JsonSafe(rsEva("EVA_SUC")) & """,""eva_emp"":""" & JsonSafe(rsEva("EVA_EMP")) & """,""eva_fch_des"":""" & JsonSafe(FormatearFechaISO(rsEva("EVA_FCH_DES"))) & """,""eva_fch_has"":""" & JsonSafe(FormatearFechaISO(rsEva("EVA_FCH_HAS"))) & """}"

If rsEva.State = 1 Then
  rsEva.Close
End If
Set rsEva = Nothing
%>
'@

$guardarEdicion = @'
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Expires = -1

Dim idEva
Dim fechaDesdeTxt
Dim fechaHastaTxt
Dim fechaDesde
Dim fechaHasta
Dim usuarioLog
Dim cmd
Dim rsResultado
Dim resultadoSp
Dim mensajeSp
Dim idSp

Function ObtenerUsuarioLog()
  Dim idUsrWin
  Dim partesUsuario

  idUsrWin = Request.ServerVariables("LOGON_USER")
  If idUsrWin <> "" Then
    partesUsuario = Split(idUsrWin, "\")
    If UBound(partesUsuario) >= 1 Then
      ObtenerUsuarioLog = partesUsuario(1)
    Else
      ObtenerUsuarioLog = idUsrWin
    End If
  ElseIf Session("nombre_usuario") <> "" Then
    ObtenerUsuarioLog = Session("nombre_usuario")
  ElseIf Session("id_usuario") <> "" Then
    ObtenerUsuarioLog = Session("id_usuario")
  Else
    ObtenerUsuarioLog = ""
  End If
End Function

Function JsonSafe(valor)
  If IsNull(valor) Then
    valor = ""
  End If
  valor = CStr(valor)
  valor = Replace(valor, "\", "\\")
  valor = Replace(valor, Chr(34), Chr(92) & Chr(34))
  valor = Replace(valor, vbCrLf, " ")
  valor = Replace(valor, vbCr, " ")
  valor = Replace(valor, vbLf, " ")
  JsonSafe = valor
End Function

Function ParsearFechaISO(valorFecha)
  Dim partes
  valorFecha = Trim(CStr(valorFecha))
  If valorFecha = "" Then
    ParsearFechaISO = Null
    Exit Function
  End If
  partes = Split(valorFecha, "-")
  If UBound(partes) <> 2 Then
    Err.Raise vbObjectError + 2000, "ParsearFechaISO", "Fecha invalida: " & valorFecha
  End If
  ParsearFechaISO = DateSerial(CInt(partes(0)), CInt(partes(1)), CInt(partes(2)))
End Function

idEva = 0
If Trim(Request("id_eva") & "") <> "" Then
  idEva = CLng(Request("id_eva"))
End If
fechaDesdeTxt = Trim(Request("eva_fch_des") & "")
fechaHastaTxt = Trim(Request("eva_fch_has") & "")
usuarioLog = ObtenerUsuarioLog()

On Error Resume Next
fechaDesde = ParsearFechaISO(fechaDesdeTxt)
fechaHasta = ParsearFechaISO(fechaHastaTxt)
If Err.Number <> 0 Then
  Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & JsonSafe(Err.Description) & """}"
  Response.End
End If
On Error GoTo 0

Set cmd = Server.CreateObject("ADODB.Command")
Set cmd.ActiveConnection = db
cmd.NamedParameters = True
cmd.CommandType = 4
cmd.CommandText = "SP_SUC_actualizar_eva_cajero"
cmd.Parameters.Append cmd.CreateParameter("@ID_EVA", 3, 1, , idEva)
cmd.Parameters.Append cmd.CreateParameter("@EVA_FCH_DES", 7, 1, , fechaDesde)
cmd.Parameters.Append cmd.CreateParameter("@EVA_FCH_HAS", 7, 1, , fechaHasta)
cmd.Parameters.Append cmd.CreateParameter("@EVA_USR", 200, 1, 50, usuarioLog)

Set rsResultado = cmd.Execute
resultadoSp = "ERROR"
mensajeSp = "No fue posible actualizar el registro."
idSp = idEva

If Not rsResultado.EOF Then
  resultadoSp = Trim(CStr(rsResultado("resultado") & ""))
  mensajeSp = Trim(CStr(rsResultado("mensaje") & ""))
  idSp = Trim(CStr(rsResultado("id_eva") & ""))
End If

Response.Write "{""resultado"":""" & JsonSafe(resultadoSp) & """,""mensaje"":""" & JsonSafe(mensajeSp) & """,""id_eva"":" & idSp & "}"

If rsResultado.State = 1 Then
  rsResultado.Close
End If
Set rsResultado = Nothing
Set cmd = Nothing
%>
'@

$eliminar = @'
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json"
Response.Expires = -1

Dim idEva
Dim usuarioLog
Dim cmd
Dim rsResultado
Dim resultadoSp
Dim mensajeSp
Dim idSp

Function ObtenerUsuarioLog()
  Dim idUsrWin
  Dim partesUsuario

  idUsrWin = Request.ServerVariables("LOGON_USER")
  If idUsrWin <> "" Then
    partesUsuario = Split(idUsrWin, "\")
    If UBound(partesUsuario) >= 1 Then
      ObtenerUsuarioLog = partesUsuario(1)
    Else
      ObtenerUsuarioLog = idUsrWin
    End If
  ElseIf Session("nombre_usuario") <> "" Then
    ObtenerUsuarioLog = Session("nombre_usuario")
  ElseIf Session("id_usuario") <> "" Then
    ObtenerUsuarioLog = Session("id_usuario")
  Else
    ObtenerUsuarioLog = ""
  End If
End Function

Function JsonSafe(valor)
  If IsNull(valor) Then
    valor = ""
  End If
  valor = CStr(valor)
  valor = Replace(valor, "\", "\\")
  valor = Replace(valor, Chr(34), Chr(92) & Chr(34))
  valor = Replace(valor, vbCrLf, " ")
  valor = Replace(valor, vbCr, " ")
  valor = Replace(valor, vbLf, " ")
  JsonSafe = valor
End Function

idEva = 0
If Trim(Request("id_eva") & "") <> "" Then
  idEva = CLng(Request("id_eva"))
End If
usuarioLog = ObtenerUsuarioLog()

Set cmd = Server.CreateObject("ADODB.Command")
Set cmd.ActiveConnection = db
cmd.NamedParameters = True
cmd.CommandType = 4
cmd.CommandText = "SP_SUC_eliminar_eva_cajero"
cmd.Parameters.Append cmd.CreateParameter("@ID_EVA", 3, 1, , idEva)
cmd.Parameters.Append cmd.CreateParameter("@EVA_USR", 200, 1, 50, usuarioLog)

Set rsResultado = cmd.Execute
resultadoSp = "ERROR"
mensajeSp = "No fue posible eliminar el registro."
idSp = idEva

If Not rsResultado.EOF Then
  resultadoSp = Trim(CStr(rsResultado("resultado") & ""))
  mensajeSp = Trim(CStr(rsResultado("mensaje") & ""))
  idSp = Trim(CStr(rsResultado("id_eva") & ""))
End If

Response.Write "{""resultado"":""" & JsonSafe(resultadoSp) & """,""mensaje"":""" & JsonSafe(mensajeSp) & """,""id_eva"":" & idSp & "}"

If rsResultado.State = 1 Then
  rsResultado.Close
End If
Set rsResultado = Nothing
Set cmd = Nothing
%>
'@

$spUpdate = @'
IF OBJECT_ID(''dbo.SP_SUC_actualizar_eva_cajero'', ''P'') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_actualizar_eva_cajero;
GO

CREATE PROCEDURE dbo.SP_SUC_actualizar_eva_cajero
    @ID_EVA      INT,
    @EVA_FCH_DES DATE,
    @EVA_FCH_HAS DATE,
    @EVA_USR     VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @EVA_USR = LTRIM(RTRIM(ISNULL(@EVA_USR, '')));

        IF @ID_EVA IS NULL OR @ID_EVA <= 0
        BEGIN
            SELECT ''ERROR'' AS resultado, ''El identificador de la evaluacion es obligatorio.'' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM dbo.SUC_CAP_EVA WHERE ID_EVA = @ID_EVA)
        BEGIN
            SELECT ''ERROR'' AS resultado, ''No existe la evaluacion indicada.'' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_FCH_DES IS NULL OR @EVA_FCH_HAS IS NULL
        BEGIN
            SELECT ''ERROR'' AS resultado, ''Las fechas desde y hasta son obligatorias.'' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_FCH_DES > @EVA_FCH_HAS
        BEGIN
            SELECT ''ERROR'' AS resultado, ''La fecha desde no puede ser mayor que la fecha hasta.'' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_USR) > 50
        BEGIN
            SELECT ''ERROR'' AS resultado, ''El usuario excede el largo permitido de la columna EVA_USR (50).'' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.SUC_CAP_EVA A
            INNER JOIN dbo.SUC_CAP_EVA B
                ON B.ID_EVA = @ID_EVA
            WHERE A.ID_EVA <> @ID_EVA
              AND A.EVA_RUT = B.EVA_RUT
              AND A.EVA_SUC = B.EVA_SUC
              AND A.EVA_EMP = B.EVA_EMP
              AND A.EVA_FCH_DES = @EVA_FCH_DES
              AND A.EVA_FCH_HAS = @EVA_FCH_HAS
        )
        BEGIN
            SELECT ''ERROR'' AS resultado, ''Ya existe otra evaluacion con los mismos datos para el cajero.'' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        UPDATE dbo.SUC_CAP_EVA
        SET EVA_FCH_DES = @EVA_FCH_DES,
            EVA_FCH_HAS = @EVA_FCH_HAS,
            EVA_USR = CASE WHEN @EVA_USR = '' THEN EVA_USR ELSE @EVA_USR END,
            EVA_FCH = GETDATE()
        WHERE ID_EVA = @ID_EVA;

        SELECT ''OK'' AS resultado, ''Registro actualizado correctamente.'' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END TRY
    BEGIN CATCH
        SELECT ''ERROR'' AS resultado, ERROR_MESSAGE() AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END CATCH
END;
GO
'@

$spInsert = @'
IF OBJECT_ID(''dbo.SP_SUC_insertar_eva_cajero'', ''P'') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_insertar_eva_cajero;
GO

CREATE PROCEDURE dbo.SP_SUC_insertar_eva_cajero
    @EVA_RUT     VARCHAR(10),
    @EVA_NOMBRE  VARCHAR(150),
    @EVA_SUC     INT,
    @EVA_EMP     VARCHAR(150),
    @EVA_FCH_DES DATE,
    @EVA_FCH_HAS DATE,
    @EVA_COM     VARCHAR(250) = NULL,
    @EVA_EST     SMALLINT = 1,
    @EVA_USR     VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @EVA_RUT = LTRIM(RTRIM(ISNULL(@EVA_RUT, '')));
        SET @EVA_NOMBRE = LTRIM(RTRIM(ISNULL(@EVA_NOMBRE, '')));
        SET @EVA_EMP = LTRIM(RTRIM(ISNULL(@EVA_EMP, '')));
        SET @EVA_COM = LTRIM(RTRIM(ISNULL(@EVA_COM, '')));
        SET @EVA_USR = LTRIM(RTRIM(ISNULL(@EVA_USR, '')));

        IF @EVA_RUT = ''
        BEGIN
            SELECT ''ERROR'' AS resultado, ''El rut del cajero es obligatorio.'' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_NOMBRE = ''
        BEGIN
            SELECT ''ERROR'' AS resultado, ''El nombre del cajero es obligatorio.'' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_SUC IS NULL OR @EVA_SUC <= 0
        BEGIN
            SELECT ''ERROR'' AS resultado, ''La sucursal es obligatoria y debe ser mayor a cero.'' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_EMP = ''
        BEGIN
            SELECT ''ERROR'' AS resultado, ''La empresa es obligatoria.'' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_FCH_DES IS NULL OR @EVA_FCH_HAS IS NULL
        BEGIN
            SELECT ''ERROR'' AS resultado, ''Las fechas desde y hasta son obligatorias.'' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_FCH_DES > @EVA_FCH_HAS
        BEGIN
            SELECT ''ERROR'' AS resultado, ''La fecha desde no puede ser mayor que la fecha hasta.'' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_RUT) > 10
        BEGIN
            SELECT ''ERROR'' AS resultado, ''El rut excede el largo permitido de la columna EVA_RUT (10).'' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_NOMBRE) > 100
        BEGIN
            SELECT ''ERROR'' AS resultado, ''El nombre excede el largo permitido de la columna EVA_NOMBRE (100). Ajuste la tabla o reduzca el valor.'' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_EMP) > 150
        BEGIN
            SELECT ''ERROR'' AS resultado, ''La empresa excede el largo permitido de la columna EVA_EMP (150).'' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_COM) > 250
        BEGIN
            SELECT ''ERROR'' AS resultado, ''El comentario excede el largo permitido de la columna EVA_COM (250).'' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_USR) > 50
        BEGIN
            SELECT ''ERROR'' AS resultado, ''El usuario excede el largo permitido de la columna EVA_USR (50).'' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.SUC_CAP_EVA
            WHERE EVA_RUT = @EVA_RUT
              AND EVA_SUC = @EVA_SUC
              AND EVA_EMP = @EVA_EMP
              AND EVA_FCH_DES = @EVA_FCH_DES
              AND EVA_FCH_HAS = @EVA_FCH_HAS
        )
        BEGIN
            SELECT ''ERROR'' AS resultado, ''Ya existe una evaluacion con los mismos datos para el cajero.'' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        INSERT INTO dbo.SUC_CAP_EVA
        (
            EVA_RUT,
            EVA_NOMBRE,
            EVA_SUC,
            EVA_EMP,
            EVA_FCH_DES,
            EVA_FCH_HAS,
            EVA_COM,
            EVA_EST,
            EVA_USR,
            EVA_FCH
        )
        VALUES
        (
            @EVA_RUT,
            @EVA_NOMBRE,
            @EVA_SUC,
            @EVA_EMP,
            @EVA_FCH_DES,
            @EVA_FCH_HAS,
            NULLIF(@EVA_COM, ''),
            ISNULL(@EVA_EST, 1),
            NULLIF(@EVA_USR, ''),
            GETDATE()
        );

        SELECT ''OK'' AS resultado, ''Registro insertado correctamente.'' AS mensaje, CAST(SCOPE_IDENTITY() AS INT) AS id_eva;
    END TRY
    BEGIN CATCH
        SELECT ''ERROR'' AS resultado, ERROR_MESSAGE() AS mensaje, CAST(NULL AS INT) AS id_eva;
    END CATCH
END;
GO
'@

[System.IO.File]::WriteAllText('d:\Sucursales2\personal\evaluacion_cajeros.asp', $main, $utf8NoBom)
[System.IO.File]::WriteAllText('\\Vmpoperapp01\APP_SC\sucursales2\personal\evaluacion_cajeros.asp', $main, $utf8NoBom)
[System.IO.File]::WriteAllText('d:\Sucursales2\personal\evaluacion_cajeros_listado.asp', $listado, $utf8NoBom)
[System.IO.File]::WriteAllText('\\Vmpoperapp01\APP_SC\sucursales2\personal\evaluacion_cajeros_listado.asp', $listado, $utf8NoBom)
[System.IO.File]::WriteAllText('d:\Sucursales2\personal\evaluacion_cajeros_obtener.asp', $obtener, $utf8NoBom)
[System.IO.File]::WriteAllText('\\Vmpoperapp01\APP_SC\sucursales2\personal\evaluacion_cajeros_obtener.asp', $obtener, $utf8NoBom)
[System.IO.File]::WriteAllText('d:\Sucursales2\personal\evaluacion_cajeros_guardar_edicion.asp', $guardarEdicion, $utf8NoBom)
[System.IO.File]::WriteAllText('\\Vmpoperapp01\APP_SC\sucursales2\personal\evaluacion_cajeros_guardar_edicion.asp', $guardarEdicion, $utf8NoBom)
[System.IO.File]::WriteAllText('d:\Sucursales2\personal\evaluacion_cajeros_eliminar.asp', $eliminar, $utf8NoBom)
[System.IO.File]::WriteAllText('\\Vmpoperapp01\APP_SC\sucursales2\personal\evaluacion_cajeros_eliminar.asp', $eliminar, $utf8NoBom)
[System.IO.File]::WriteAllText('d:\Sucursales2\SP_SUC_insertar_eva_cajero.sql', $spInsert, $utf8NoBom)
[System.IO.File]::WriteAllText('d:\Sucursales2\SP_SUC_actualizar_eva_cajero.sql', $spUpdate, $utf8NoBom)
Write-Output 'OK'
