<!--#include file="../conexion/conexion.asp"-->

<div class="container-fluid" style="margin-top: 20px;">
  <div class="row-fluid">
    <div class="span12">
      <div class="well">
        <div class="row-fluid">
          <div class="span12">
            <h3 style="color: #8B4513; margin-top: 0;">Administracion de Proveedores</h3>
            <hr />
            <div class="row-fluid" style="margin-bottom: 15px;">
              <div class="span6">
                <input type="text" id="txtBuscarProveedor" placeholder="Buscar proveedor..." class="input-large" />
              </div>
              <div class="span6" style="text-align: right;">
                <button class="btn btn-success" id="btnCrearNuevoProveedor">
                  <i class="icon-plus icon-white"></i> Crear Nuevo Proveedor
                </button>
              </div>
            </div>
            <table class="table table-bordered table-hover">
              <thead>
                <tr style="background-color: #f5f5f5;">
                  <th>Nombre Empresa</th>
                  <th>Tipo Servicio</th>
                  <th>N Contrato</th>
                  <th>Fecha Inicio</th>
                  <th>Fecha Fin</th>
                  <th style="width: 60px; text-align: center">Activo</th>
                  <th style="width: 60px; text-align: center">Acciones</th>
                </tr>
              </thead>
              <tbody id="tbodyProveedores">
<%
On Error Resume Next
Dim rsProveedores, idProveedor, nombreEmpresa, tipoServicio, numeroContrato
Dim fechaInicio, fechaFin, activo, sql

sql = "EXEC SP_SUC_listar_proveedores"
set rsProveedores = db.execute(sql)

If Err.Number <> 0 Then
%>
<tr><td colspan="7" style="color: red;">Error SQL: <%= Err.Description %></td></tr>
<%
  Response.End
End If

if not rsProveedores.EOF then
  do until rsProveedores.EOF
    idProveedor = rsProveedores("id_proveedor")
    nombreEmpresa = trim(rsProveedores("nombre_empresa") & "")
    tipoServicio = trim(rsProveedores("tipo_servicio") & "")
    numeroContrato = trim(rsProveedores("n_contrato") & "")
    
    On Error Resume Next
    activo = rsProveedores("activo")
    If Err.Number <> 0 Then 
      activo = 1
    Else
      If IsNull(activo) Then 
        activo = 1
      Else
        activo = CLng(activo)
      End If
    End If
    On Error Goto 0
    
    fechaInicio = ""
    fechaFin = ""
    
    if not IsNull(rsProveedores("fecha_inicio")) then
      fechaInicio = Day(rsProveedores("fecha_inicio")) & "/" & Month(rsProveedores("fecha_inicio")) & "/" & Year(rsProveedores("fecha_inicio"))
    end if
    
    if not IsNull(rsProveedores("fecha_fin")) then
      fechaFin = Day(rsProveedores("fecha_fin")) & "/" & Month(rsProveedores("fecha_fin")) & "/" & Year(rsProveedores("fecha_fin"))
    end if
%>
                <tr>
                  <td><%=nombreEmpresa%></td>
                  <td><%=tipoServicio%></td>
                  <td><%=numeroContrato%></td>
                  <td><%=fechaInicio%></td>
                  <td><%=fechaFin%></td>
                  <td style="text-align: center">
                    <input type="checkbox" class="chkEstadoProveedor" data-id="<%=idProveedor%>" <%if activo = 1 OR activo = True OR activo = -1 then%>checked<%end if%> />
                  </td>
                  <td style="text-align: center">
                    <a class="btnEditarProveedor" data-id="<%=idProveedor%>" href="#" title="Editar">
                      <i class="icon-edit icon-large"></i>
                    </a>
                  </td>
                </tr>
<%
    rsProveedores.MoveNext
  loop
else
%>
                <tr><td colspan="7" style="text-align: center">No hay proveedores registrados</td></tr>
<%
end if
rsProveedores.Close
set rsProveedores = nothing
%>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div id="modalProveedor" class="modal hide fade" tabindex="-1" role="dialog" aria-hidden="true" style="width: 650px; margin-left: -325px;">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      <h3 id="tituloModalProveedor">Nuevo Proveedor</h3>
    </div>
    <div class="modal-body" style="max-height: 500px; overflow-y: auto;">
      <form id="formProveedor">
        <input type="hidden" id="id_proveedor" name="id_proveedor" value="0" />
        
        <div class="row-fluid">
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Nombre Empresa *</label>
            <input type="text" id="nombre_empresa" name="nombre_empresa" class="span12" required />
          </div>
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Tipo Servicio *</label>
            <input type="text" id="tipo_servicio" name="tipo_servicio" class="span12" required />
          </div>
        </div>
        
        <div class="row-fluid" style="margin-top: 10px;">
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">N Contrato</label>
            <input type="text" id="numero_contrato" name="numero_contrato" class="span12" />
          </div>
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">N OC</label>
            <input type="text" id="numero_oc" name="numero_oc" class="span12" />
          </div>
        </div>
        
        <div class="row-fluid" style="margin-top: 10px;">
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Fecha Inicio</label>
            <input type="date" id="fecha_inicio" name="fecha_inicio" class="span12" />
          </div>
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Fecha Fin</label>
            <input type="date" id="fecha_fin" name="fecha_fin" class="span12" />
          </div>
        </div>
        
        <div class="row-fluid" style="margin-top: 10px;">
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Contacto Administrativo</label>
            <input type="text" id="contacto_administrativo" name="contacto_administrativo" class="span12" />
          </div>
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Correo Administrativo</label>
            <input type="email" id="correo_administrativo" name="correo_administrativo" class="span12" />
          </div>
        </div>
        
        <div class="row-fluid" style="margin-top: 10px;">
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Contacto Operacional</label>
            <input type="text" id="contacto_operacional" name="contacto_operacional" class="span12" />
          </div>
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Correo Operacional</label>
            <input type="email" id="correo_operacional" name="correo_operacional" class="span12" />
          </div>
        </div>
        
        <div class="row-fluid" style="margin-top: 10px;">
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Cajeros Titulares</label>
            <input type="number" id="cajeros_titulares" name="cajeros_titulares" min="0" value="0" class="span12" />
          </div>
          <div class="span6">
            <label style="font-weight: bold; margin-bottom: 3px;">Cajeros Adicionales</label>
            <input type="number" id="cajeros_adicionales" name="cajeros_adicionales" min="0" value="0" class="span12" />
          </div>
        </div>
        
      </form>
    </div>
    <div class="modal-footer">
      <button class="btn" data-dismiss="modal" aria-hidden="true">Cancelar</button>
      <button class="btn btn-primary" id="btnGuardarProveedor">Guardar</button>
    </div>
  </div>
</div>

<script type="text/javascript">
function registrarLog(funcionalidad, tipoAccion) {
    $.ajax({
        url: 'registrar_log.asp',
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

$(document).ready(function() {
  $("#txtBuscarProveedor").on("keyup", function() {
    var valor = $(this).val().toLowerCase();
    $("#tbodyProveedores tr").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(valor) > -1);
    });
  });

  $("#btnCrearNuevoProveedor").on("click", function() {
    $("#tituloModalProveedor").text("Nuevo Proveedor");
    $("#formProveedor")[0].reset();
    $("#id_proveedor").val("0");
    // Solo para nuevos registros, establecer fecha actual
    var fechaActual = new Date().toISOString().split('T')[0];
    $("#fecha_inicio").val(fechaActual);
    $("#fecha_fin").val(fechaActual);
    $("#modalProveedor").modal("show");
  });

  $("#btnGuardarProveedor").on("click", function() {
    var nombreEmpresa = $("#nombre_empresa").val().trim();
    var tipoServicio = $("#tipo_servicio").val().trim();
    if (nombreEmpresa === "" || tipoServicio === "") {
      alert("Por favor complete los campos obligatorios (*)");
      return;
    }
    var datos = {
      id_proveedor: $("#id_proveedor").val(),
      nombre_empresa: nombreEmpresa,
      tipo_servicio: tipoServicio,
      numero_contrato: $("#numero_contrato").val(),
      numero_oc: $("#numero_oc").val(),
      fecha_inicio: $("#fecha_inicio").val(),
      fecha_fin: $("#fecha_fin").val(),
      contacto_administrativo: $("#contacto_administrativo").val(),
      correo_administrativo: $("#correo_administrativo").val(),
      contacto_operacional: $("#contacto_operacional").val(),
      correo_operacional: $("#correo_operacional").val(),
      cantidad_titulares: $("#cajeros_titulares").val(),
      cantidad_adicionales: $("#cajeros_adicionales").val()
    };
    $.ajax({
      type: "POST",
      url: "guardar_proveedor.asp",
      data: datos,
      dataType: "json",
      success: function(response) {
        if (response.resultado === "OK") {
          $("#modalProveedor").modal("hide");
          enviaDatos('gestionProveedores.asp', 'tbGestionProveedores', 'carga=carga');
          
          // Registrar log
          var accion = datos.id_proveedor == "0" ? "Crear proveedor" : "Editar proveedor";
          registrarLog('Gestion Proveedores', accion);
        } else {
          alert("Error: " + (response.mensaje || "No se pudo guardar el proveedor"));
        }
      },
      error: function(xhr, status, error) {
        alert("Error al comunicarse con el servidor: " + error);
        console.log(xhr.responseText);
      }
    });
  });

  $(document).on("click", ".btnEditarProveedor", function(e) {
    e.preventDefault();
    var id = $(this).data("id");
    $.ajax({
      type: "GET",
      url: "obtener_proveedor.asp?id=" + id,
      dataType: "json",
      success: function(data) {
        $("#tituloModalProveedor").text("Editar Proveedor");
        $("#id_proveedor").val(data.id_proveedor);
        $("#nombre_empresa").val(data.nombre_empresa);
        $("#tipo_servicio").val(data.tipo_servicio);
        $("#numero_contrato").val(data.numero_contrato || "");
        $("#numero_oc").val(data.numero_oc || "");
        $("#fecha_inicio").val(data.fecha_inicio || "");
        $("#fecha_fin").val(data.fecha_fin || "");
        $("#contacto_administrativo").val(data.contacto_administrativo || "");
        $("#correo_administrativo").val(data.correo_administrativo || "");
        $("#contacto_operacional").val(data.contacto_operacional || "");
        $("#correo_operacional").val(data.correo_operacional || "");
        $("#cajeros_titulares").val(data.cantidad_titulares || 0);
        $("#cajeros_adicionales").val(data.cantidad_adicionales || 0);
        $("#modalProveedor").modal("show");
      },
      error: function(xhr, status, error) {
        alert("Error al cargar los datos del proveedor: " + error);
        console.log(xhr.responseText);
      }
    });
  });

  $(document).on("change", ".chkEstadoProveedor", function() {
    var id = $(this).data("id");
    var checkbox = $(this);
    var nuevoEstado = checkbox.is(":checked") ? "Activo" : "Inactivo";
    
    if (confirm("¿Desea cambiar el estado del proveedor a " + nuevoEstado + "?")) {
      $.ajax({
        type: "POST",
        url: "eliminar_proveedor.asp",
        data: { id: id },
        dataType: "json",
        success: function(response) {
          if (response.resultado === "OK") {
            // Estado cambiado correctamente
            registrarLog('Gestion Proveedores', 'Cambiar estado proveedor a ' + nuevoEstado);
          } else {
            alert("Error: " + (response.mensaje || "No se pudo cambiar el estado"));
            checkbox.prop("checked", !checkbox.is(":checked"));
          }
        },
        error: function(xhr, status, error) {
          alert("Error: " + error);
          checkbox.prop("checked", !checkbox.is(":checked"));
        }
      });
    } else {
      checkbox.prop("checked", !checkbox.is(":checked"));
    }
  });
});
</script>