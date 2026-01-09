<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<% 
idSucursal=request("idSucursalMain")
idUsuario = trim(request("idUsuarioMain"))
perfil = trim(request("perfilMain"))
'response.Write("idSucursal: " & idSucursal)
'response.End()

if idSucursal="" then
%>
	<div class="row-fluid">
        <span class="span12 alert alert-danger">
        <strong><h4><span id="loadIcon" style="display:none;"><i class="icon-spinner icon-spin icon-large"></i></span> <span class="icon-stack icon-large"><i class="icon-check-empty icon-stack-base"></i><i class="icon-group"></i></span> Seleccione una Sucursal</h4></strong>
        </span>
    </div>
<%else

' Consulta para obtener lista de sucursales según perfil
If perfil = "1" Then
    sqlSucursales = ""
    sqlSucursales = sqlSucursales & " select id_sucursal, "
    sqlSucursales = sqlSucursales & " suc_nombre "
    sqlSucursales = sqlSucursales & " from suc_sucursal "
    sqlSucursales = sqlSucursales & " where id_sucursal in "
    sqlSucursales = sqlSucursales & " (select id_sucursal "
    sqlSucursales = sqlSucursales & " from SUC_usuario_sucursal "
    sqlSucursales = sqlSucursales & " where id_usuario = '" & idUsuario & "') "
    sqlSucursales = sqlSucursales & " order by suc_nombre "
    Set rsSucursales = DB.execute(sqlSucursales)
    If Not rsSucursales.EOF Then
        datosSucursales = rsSucursales.GetRows()
    End If
ElseIf perfil = "2" Then
    sqlSucursales = ""
    sqlSucursales = sqlSucursales & " select id_sucursal, "
    sqlSucursales = sqlSucursales & " suc_nombre "
    sqlSucursales = sqlSucursales & " from suc_sucursal "
    sqlSucursales = sqlSucursales & " where id_sucursal in "
    sqlSucursales = sqlSucursales & " (select id_sucursal "
    sqlSucursales = sqlSucursales & " from SUC_usuario_sucursal "
    sqlSucursales = sqlSucursales & " where id_usuario = '" & idUsuario & "') "
    sqlSucursales = sqlSucursales & " order by suc_nombre "
    Set rsSucursales = DB.execute(sqlSucursales)
    If Not rsSucursales.EOF Then
        datosSucursales = rsSucursales.GetRows()
    End If
ElseIf perfil = "3" Then
    sqlSucursales = ""
    sqlSucursales = sqlSucursales & " select id_sucursal, "
    sqlSucursales = sqlSucursales & " suc_nombre "
    sqlSucursales = sqlSucursales & " from suc_sucursal "
    sqlSucursales = sqlSucursales & " order by suc_nombre "
    Set rsSucursales = DB.execute(sqlSucursales)
    If Not rsSucursales.EOF Then
        datosSucursales = rsSucursales.GetRows()
    End If
End If

' Consulta para obtener periodos
sqlPeriodos = "EXEC SCSS_prc_obtiene_periodo_carpeta_credito"
Set rsPeriodos = DB.execute(sqlPeriodos)
If Not rsPeriodos.EOF Then
    datosPeriodos = rsPeriodos.getrows()
End If

' Consulta de solicitudes de cajeros adicionales
If perfil = "2" Then
    ' Para ZONAL, obtener todas las solicitudes de sus sucursales
    sqlSolicitudes = "SELECT " & _
                    "s.id_solicitud, s.id_sucursal, suc.suc_nombre, s.motivo_solicitud, " & _
                    "CASE s.motivo_solicitud " & _
                    "  WHEN 'licencia_medica' THEN 'Licencia Médica' " & _
                    "  WHEN 'vacaciones' THEN 'Vacaciones' " & _
                    "  WHEN 'reemplazo' THEN 'Reemplazo' " & _
                    "  WHEN 'flujo' THEN 'Flujo' " & _
                    "  ELSE s.motivo_solicitud " & _
                    "END AS motivo_solicitud_texto, " & _
                    "s.fecha_desde, s.fecha_hasta, s.periodo, s.observaciones, " & _
                    "s.id_estado, e.nombre_estado, e.color_badge, " & _
                    "s.usuario_registro, s.fecha_registro " & _
                    "FROM SUC_solicitud_cajeros_adicionales s " & _
                    "LEFT JOIN SUC_sucursal suc ON s.id_sucursal = suc.id_sucursal " & _
                    "LEFT JOIN SUC_cat_estados_solicitud e ON s.id_estado = e.id_estado " & _
                    "WHERE s.activo = 1 " & _
                    "AND s.id_sucursal IN (SELECT id_sucursal FROM SUC_usuario_sucursal WHERE id_usuario = " & idUsuario & ") " & _
                    "ORDER BY s.fecha_registro DESC"
ElseIf perfil = "3" And (idSucursal = "0" Or idSucursal = "") Then
    ' Para ADMIN con todas las sucursales, mostrar todas las solicitudes
    sqlSolicitudes = "SELECT " & _
                    "s.id_solicitud, s.id_sucursal, suc.suc_nombre, s.motivo_solicitud, " & _
                    "CASE s.motivo_solicitud " & _
                    "  WHEN 'licencia_medica' THEN 'Licencia Médica' " & _
                    "  WHEN 'vacaciones' THEN 'Vacaciones' " & _
                    "  WHEN 'reemplazo' THEN 'Reemplazo' " & _
                    "  WHEN 'flujo' THEN 'Flujo' " & _
                    "  ELSE s.motivo_solicitud " & _
                    "END AS motivo_solicitud_texto, " & _
                    "s.fecha_desde, s.fecha_hasta, s.periodo, s.observaciones, " & _
                    "s.id_estado, e.nombre_estado, e.color_badge, " & _
                    "s.usuario_registro, s.fecha_registro " & _
                    "FROM SUC_solicitud_cajeros_adicionales s " & _
                    "LEFT JOIN SUC_sucursal suc ON s.id_sucursal = suc.id_sucursal " & _
                    "LEFT JOIN SUC_cat_estados_solicitud e ON s.id_estado = e.id_estado " & _
                    "WHERE s.activo = 1 " & _
                    "ORDER BY s.fecha_registro DESC"
Else
    ' Para otros perfiles, solo su sucursal
    sqlSolicitudes = "EXEC SP_SUC_listar_solicitudes_cajeros @id_sucursal=" & idSucursal
End If
Set rsSolicitudes = DB.execute(sqlSolicitudes)

' Obtener fecha actual para campos desde/hasta
Dim fechaHoy
fechaHoy = Year(Date) & "-"
If Month(Date) < 10 Then fechaHoy = fechaHoy & "0"
fechaHoy = fechaHoy & Month(Date) & "-"
If Day(Date) < 10 Then fechaHoy = fechaHoy & "0"
fechaHoy = fechaHoy & Day(Date)

%>
<div class="row-fluid span12">
<input type="hidden" name="idSucursal" id="idSucursal" value="<%=idSucursal%>" />
    <div class="row-fluid">    	
        <span class="span12 alert alert-success">
        <strong><h4><span id="loadIcon" style="display:none;"><i class="icon-spinner icon-spin icon-large"></i></span> <span class="icon-stack icon-large"><i class="icon-check-empty icon-stack-base"></i><i class="icon-group"></i></span> Solicitud Cajeros Adicionales</h4></strong>
        </span>        
    </div>
    <div class="row-fluid">
    	<div class="span12">
            <button class="btn btn-success" id="btnCrearSolicitud">
                <i class="icon-plus icon-white"></i> Crear Solicitud
            </button>
        </div>
    </div>   

    <script type="text/javascript">
    	$('#btnCrearSolicitud').click(function(){
			$('#formsIng').fadeIn('slow');
		});
    </script>
    <br/>

    <div class="row-fluid">
    	<div class="span12 well" id="formsIng" style="display:none;">
            <h5>Nueva Solicitud de Cajero Adicional</h5>
            <form id="formSolicitudCajero">
                <input type="hidden" id="id_solicitud" name="id_solicitud" value="0" />
                <input type="hidden" id="id_sucursal_hidden" name="id_sucursal_hidden" value="<%=idSucursal%>" />
                
                <div class="row-fluid">
                    <div class="span6">
                        <label><strong>Sucursal: <span style="color:red;">*</span></strong></label>
                        <select id="slc_sucursal" name="slc_sucursal" class="span12" required <% If perfil <> "2" Then %>disabled style="background-color:#f5f5f5;"<% End If %>>
                            <option value="">Seleccione sucursal...</option>
                            <%
                            If IsArray(datosSucursales) Then
                                For i = 0 To UBound(datosSucursales, 2)
                                    idSuc = Trim(datosSucursales(0, i))
                                    nombreSuc = Server.HTMLEncode(Trim(datosSucursales(1, i)))
                                    seleccionado = ""
                                    If CStr(idSuc) = CStr(idSucursal) Then seleccionado = "selected"
                            %>
                                    <option value="<%=idSuc%>" <%=seleccionado%>><%=nombreSuc%></option>
                            <%
                                Next
                            End If
                            %>
                        </select>
                    </div>
                    <div class="span6">
                        <label><strong>Motivo Solicitud: <span style="color:red;">*</span></strong></label>
                        <select id="slc_motivo" name="slc_motivo" class="span12" required>
                            <option value="">Seleccione...</option>
                            <option value="licencia_medica">Licencia Médica</option>
                            <option value="vacaciones">Vacaciones</option>
                            <option value="reemplazo">Reemplazo</option>
                            <option value="flujo">Flujo</option>
                        </select>
                    </div>
                </div>
                
                <div class="row-fluid">
                    <div class="span6">
                        <label><strong>Desde: <span style="color:red;">*</span></strong></label>
                        <input type="date" id="fecha_desde" name="fecha_desde" class="span12" value="<%=fechaHoy%>" required />
                    </div>
                    <div class="span6">
                        <label><strong>Hasta: <span style="color:red;">*</span></strong></label>
                        <input type="date" id="fecha_hasta" name="fecha_hasta" class="span12" value="<%=fechaHoy%>" required />
                    </div>
                </div>
                
                <div class="row-fluid">
                    <div class="span6">
                        <label><strong>Periodo: <span style="color:red;">*</span></strong></label>
                        <select id="slc_periodo" name="slc_periodo" class="span12" required>
                            <option value="">Seleccione periodo...</option>
                            <%
                            If IsArray(datosPeriodos) Then
                                For i = 0 To UBound(datosPeriodos, 2)
                                    idPeriodo = datosPeriodos(0, i)
                                    nombrePeriodo = datosPeriodos(1, i)
                                    If Not IsNull(nombrePeriodo) Then
                                        nombrePeriodo = CStr(nombrePeriodo)
                            %>
                                    <option value="<%=Server.HTMLEncode(nombrePeriodo)%>"><%=Server.HTMLEncode(nombrePeriodo)%></option>
                            <%
                                    End If
                                Next
                            End If
                            %>
                        </select>
                    </div>
                    <div class="span6">
                        <label><strong>Observaciones:</strong> <small>(Máximo 50 caracteres)</small></label>
                        <textarea id="txt_observaciones" name="txt_observaciones" class="span12" rows="3" maxlength="50"></textarea>
                    </div>
                </div>
                
                <div class="row-fluid">
                    <div class="span12" style="text-align:right; margin-top:10px;">
                        <button type="button" class="btn" id="btnCancelarSolicitud">
                            <i class="icon-remove"></i> Cancelar
                        </button>
                        <button type="submit" class="btn btn-primary" id="btnGuardarSolicitud">
                            <i class="icon-save icon-white"></i> Guardar Solicitud
                        </button>
                    </div>
                </div>
            </form>
            
            <script type="text/javascript">
                // Cancelar formulario
                $('#btnCancelarSolicitud').click(function(){
                    $('#formSolicitudCajero')[0].reset();
                    $('#id_solicitud').val(''); // Limpiar el ID para que sea nueva solicitud
                    // Restaurar la sucursal seleccionada originalmente
                    $('#slc_sucursal').val($('#idSucursal').val());
                    $('#formsIng').fadeOut('fast');
                });
                
                // Guardar solicitud
                $('#formSolicitudCajero').submit(function(e){
                    e.preventDefault();
                    
                    // Validar que la sucursal esté seleccionada
                    if($('#slc_sucursal').val() === ''){
                        alert('Por favor seleccione una sucursal');
                        return false;
                    }
                    
                    // Validar que el periodo esté seleccionado
                    if($('#slc_periodo').val() === '' || $('#slc_periodo').val() === null){
                        alert('Por favor seleccione un periodo');
                        $('#slc_periodo').focus();
                        return false;
                    }
                    
                    var datos = {
                        id_solicitud: $('#id_solicitud').val(),
                        id_sucursal: $('#slc_sucursal').val(),
                        motivo: $('#slc_motivo').val(),
                        fecha_desde: $('#fecha_desde').val(),
                        fecha_hasta: $('#fecha_hasta').val(),
                        periodo: $('#slc_periodo').val(),
                        observaciones: $('#txt_observaciones').val(),
                        perfil: '<%=perfil%>'
                    };
                    
                    console.log('Periodo seleccionado:', $('#slc_periodo').val());
                    console.log('Longitud periodo:', $('#slc_periodo').val().length);
                    console.log('Enviando datos:', datos);
                    
                    $.ajax({
                        type: 'POST',
                        url: '/sucursales2/sucursales/guardar_solicitud_cajero.asp',
                        data: datos,
                        dataType: 'text',  // Cambiado a text para ver la respuesta cruda
                        success: function(responseText){
                            console.log('Respuesta cruda:', responseText);
                            try {
                                var response = JSON.parse(responseText);
                                console.log('JSON parseado:', response);
                                if(response.resultado === 'OK'){
                                    alert('Solicitud guardada correctamente');
                                    $('#formSolicitudCajero')[0].reset();
                                    $('#id_solicitud').val(''); // Limpiar el ID
                                    $('#slc_sucursal').val($('#idSucursal').val()); // Restaurar sucursal
                                    $('#formsIng').fadeOut('fast');
                                    // Recargar solo la tabla sin refresh completo
                                    cargarTablaSolicitudes();
                                } else {
                                    alert('Error: ' + response.mensaje);
                                }
                            } catch(e) {
                                console.error('Error al parsear JSON:', e);
                                console.log('Texto recibido:', responseText);
                                alert('Error en la respuesta del servidor. Revise la consola.');
                            }
                        },
                        error: function(xhr, status, error){
                            console.log('Status:', status);
                            console.log('Error:', error);
                            console.log('Response:', xhr.responseText);
                            console.log('Status Code:', xhr.status);
                            alert('Error al guardar (Status ' + xhr.status + '): ' + error + '\n\nRevise la consola para más detalles.');
                        }
                    });
                });
            </script>
        </div>        
    </div>
    
    <!-- Tabla de Solicitudes de Cajeros Adicionales -->
    <div class="row-fluid" id="idTablaSolicitudes">
        <div class="span12">
            <span><h6>Solicitudes de Cajeros Adicionales</h6></span>
            <table class="table table-bordered table-hover" id="tablaSolicitudes">
                <thead>
                    <tr style="background-color: #f5f5f5;">
                        <th width="50">ID</th>
                        <% If perfil = "2" Or perfil = "3" Then %><th>Sucursal</th><% End If %>
                        <th>Estado</th>
                        <th>Motivo</th>
                        <th>Desde</th>
                        <th>Hasta</th>
                        <th>Periodo</th>
                        <th>Observaciones</th>
                        <th>Fecha Registro</th>
                        <th width="120" style="text-align:center">Acciones</th>
                    </tr>
                </thead>
                <tbody id="tbodySolicitudes">
                    <% 
                    If Not rsSolicitudes.EOF Then
                        Do While Not rsSolicitudes.EOF
                    %>
                        <tr id="solicitudRow<%=rsSolicitudes("id_solicitud")%>">
                            <td align="center"><%=rsSolicitudes("id_solicitud")%></td>
                            <% If perfil = "2" Or perfil = "3" Then %><td><%=Server.HTMLEncode(rsSolicitudes("suc_nombre"))%></td><% End If %>
                            <td align="center">
                                <span class="label label-<%=rsSolicitudes("color_badge")%>">
                                    <%=rsSolicitudes("nombre_estado")%>
                                </span>
                            </td>
                            <td><%=rsSolicitudes("motivo_solicitud_texto")%></td>
                            <td align="center"><%=FormatDateTime(rsSolicitudes("fecha_desde"), 2)%></td>
                            <td align="center"><%=FormatDateTime(rsSolicitudes("fecha_hasta"), 2)%></td>
                            <td align="center"><%=rsSolicitudes("periodo")%></td>
                            <td><%=Server.HTMLEncode(rsSolicitudes("observaciones"))%></td>
                            <td align="center"><%=FormatDateTime(rsSolicitudes("fecha_registro"), 2)%></td>
                            <td align="center">
                                <i class="icon-exchange icon-large mano btnCambiarEstado" 
                                   data-id="<%=rsSolicitudes("id_solicitud")%>" 
                                   data-estado="<%=rsSolicitudes("id_estado")%>"
                                   title="Cambiar Estado"></i>
                                <% If (perfil = "1" And rsSolicitudes("id_estado") = 1) Or (perfil <> "1" And perfil <> "2") Then %>
                                <i class="icon-pencil icon-large mano btnEditarSolicitud" 
                                   data-id="<%=rsSolicitudes("id_solicitud")%>" 
                                   title="Editar"></i>
                                <% End If %>
                                <i class="icon-list-alt icon-large mano btnVerHistorial" 
                                   data-id="<%=rsSolicitudes("id_solicitud")%>" 
                                   title="Ver Historial"></i>
                            </td>
                        </tr>
                    <%
                        rsSolicitudes.MoveNext
                        Loop
                    Else
                    %>
                        <tr>
                            <td colspan="<% If perfil = "2" Or perfil = "3" Then %>10<% Else %>9<% End If %>" align="center">No hay solicitudes registradas</td>
                        </tr>
                    <%
                    End If
                    %>
                </tbody>
            </table>
            
            <script type="text/javascript">
                // Editar solicitud
                $('.btnEditarSolicitud').click(function(){
                    var id = $(this).data('id');
                    
                    $.ajax({
                        type: 'GET',
                        url: '/sucursales2/sucursales/obtener_solicitud_cajero.asp?id_solicitud=' + id,
                        dataType: 'json',
                        success: function(data){
                            $('#id_solicitud').val(data.id_solicitud);
                            $('#slc_sucursal').val(data.id_sucursal);
                            $('#slc_motivo').val(data.motivo_solicitud);
                            $('#fecha_desde').val(data.fecha_desde);
                            $('#fecha_hasta').val(data.fecha_hasta);
                            $('#slc_periodo').val(data.periodo);
                            $('#txt_observaciones').val(data.observaciones);
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
                    
                    if(confirm('¿Está seguro que desea eliminar la solicitud de ' + motivo + '?')){
                        $.ajax({
                            type: 'POST',
                            url: '/sucursales2/sucursales/eliminar_solicitud_cajero.asp',
                            data: { id: id },
                            dataType: 'json',
                            success: function(response){
                                if(response.resultado === 'OK'){
                                    $('#solicitudRow' + id).fadeOut('fast', function(){
                                        $(this).remove();
                                    });
                                } else {
                                    alert('Error: ' + response.mensaje);
                                }
                            },
                            error: function(xhr, status, error){
                                alert('Error al eliminar: ' + error);
                                console.log(xhr.responseText);
                            }
                        });
                    }
                });
            </script>
        </div>
    </div>
</div>

<script type="text/javascript">
$(function(){
    $('#formsIng').slideUp('fast');
    // Activar eventos de los botones al cargar la página
    activarEventosBotones();
});

// Función para recargar solo la tabla de solicitudes
function cargarTablaSolicitudes() {
    $.ajax({
        url: '/sucursales2/sucursales/listar_solicitudes_cajero.asp',
        type: 'GET',
        data: {
            idUsuario: '<%=idUsuario%>',
            perfil: '<%=perfil%>',
            idSucursal: '<%=idSucursal%>'
        },
        dataType: 'json',
        success: function(solicitudes) {
            var tbody = $('#tbodySolicitudes');
            tbody.empty();
            
            if(solicitudes.length === 0) {
                tbody.append('<tr><td colspan="<% If perfil = "2" Then %>9<% Else %>8<% End If %>" style="text-align:center">No hay solicitudes registradas</td></tr>');
            } else {
                $.each(solicitudes, function(i, sol){
                    var tr = '<tr id="solicitudRow' + sol.id_solicitud + '">';
                    tr += '<td align="center">' + sol.id_solicitud + '</td>';
                    <% If perfil = "2" Then %>
                    tr += '<td>' + (sol.suc_nombre || '') + '</td>';
                    <% End If %>
                    tr += '<td align="center"><span class="label label-' + sol.color_badge + '">' + sol.nombre_estado + '</span></td>';
                    tr += '<td>' + sol.motivo_solicitud_texto + '</td>';
                    tr += '<td align="center">' + sol.fecha_desde + '</td>';
                    tr += '<td align="center">' + sol.fecha_hasta + '</td>';
                    tr += '<td align="center">' + sol.periodo + '</td>';
                    tr += '<td>' + (sol.observaciones || '') + '</td>';
                    tr += '<td align="center">' + sol.fecha_registro + '</td>';
                    tr += '<td align="center">';
                    tr += '<i class="icon-exchange icon-large mano btnCambiarEstado" data-id="' + sol.id_solicitud + '" data-estado="' + sol.id_estado + '" title="Cambiar Estado"></i> ';
                    <% If perfil = "1" Then %>
                    // Perfil 1 (JEPS) solo puede editar si está en PENDIENTE REVISION (id_estado=1)
                    if(sol.id_estado == 1) {
                        tr += '<i class="icon-pencil icon-large mano btnEditarSolicitud" data-id="' + sol.id_solicitud + '" title="Editar"></i> ';
                    }
                    <% ElseIf perfil = "3" Then %>
                    // Perfil 3 (GERENCIA) puede editar siempre
                    tr += '<i class="icon-pencil icon-large mano btnEditarSolicitud" data-id="' + sol.id_solicitud + '" title="Editar"></i> ';
                    <% End If %>
                    // Perfil 2 (ZONAL) no tiene botón de editar
                    tr += '<i class="icon-list-alt icon-large mano btnVerHistorial" data-id="' + sol.id_solicitud + '" title="Ver Historial"></i>';
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
            alert('Error al recargar la tabla de solicitudes');
        }
    });
}

// Función para reactivar eventos después de recargar la tabla
function activarEventosBotones() {
    $('.btnEditarSolicitud').off('click').on('click', function(){
        var id = $(this).data('id');
        console.log('Editando solicitud ID:', id);
        
        $.ajax({
            type: 'GET',
            url: '/sucursales2/sucursales/obtener_solicitud_cajero.asp',
            data: {id_solicitud: id},
            dataType: 'json',
            success: function(data){
                console.log('Datos recibidos:', data);
                
                if(data.error) {
                    alert('Error: ' + data.error);
                    return;
                }
                
                // Llenar los campos del formulario
                $('#id_solicitud').val(data.id_solicitud);
                $('#slc_sucursal').val(data.id_sucursal);
                $('#slc_motivo').val(data.motivo_solicitud);
                $('#fecha_desde').val(data.fecha_desde);
                $('#fecha_hasta').val(data.fecha_hasta);
                
                // Precargar periodo con trim y verificación
                var periodo = $.trim(data.periodo);
                console.log('Periodo a seleccionar:', periodo);
                $('#slc_periodo').val(periodo);
                console.log('Periodo seleccionado en SELECT:', $('#slc_periodo').val());
                
                // Si no se seleccionó, intentar buscar el valor exacto
                if($('#slc_periodo').val() === null || $('#slc_periodo').val() === ''){
                    $('#slc_periodo option').each(function(){
                        if($.trim($(this).val()) === periodo){
                            $(this).prop('selected', true);
                            console.log('Periodo encontrado y seleccionado manualmente');
                        }
                    });
                }
                
                $('#txt_observaciones').val(data.observaciones);
                
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
        if(confirm('¿Está seguro de eliminar esta solicitud?')){
            $.ajax({
                type: 'POST',
                url: '/sucursales2/sucursales/eliminar_solicitud_cajero.asp',
                data: {id: id},
                dataType: 'json',
                success: function(response){
                    if(response.resultado === 'OK'){
                        $('#solicitudRow' + id).fadeOut('fast', function(){
                            $(this).remove();
                        });
                        alert('Solicitud eliminada correctamente');
                    } else {
                        alert('Error: ' + response.mensaje);
                    }
                },
                error: function(xhr, status, error){
                    alert('Error al eliminar la solicitud');
                }
            });
        }
    });
    
    // Cambiar estado de solicitud
    $('.btnCambiarEstado').off('click').on('click', function(){
        var id = $(this).data('id');
        var estadoActual = $(this).data('estado');
        
        console.log('ID:', id, 'Estado actual:', estadoActual);
        
        $('#modalCambiarEstado #id_solicitud_estado').val(id);
        $('#modalCambiarEstado #estado_actual_id').val(estadoActual);
        
        // Cargar estados con AJAX
        $.ajax({
            url: '/sucursales2/sucursales/obtener_estados_solicitud.asp',
            type: 'GET',
            data: {
                perfil: '<%=perfil%>',
                estado_actual: estadoActual
            },
            dataType: 'text',
            success: function(data){
                console.log('Respuesta recibida:', data);
                
                var select = $('#modalCambiarEstado #slc_nuevo_estado');
                select.empty().append('<option value="">Seleccione nuevo estado...</option>');
                
                // Extraer solo el JSON del texto
                var jsonStart = data.indexOf('[');
                var jsonEnd = data.lastIndexOf(']') + 1;
                
                console.log('JSON inicio:', jsonStart, 'JSON fin:', jsonEnd);
                
                if(jsonStart >= 0 && jsonEnd > 0){
                    var jsonStr = data.substring(jsonStart, jsonEnd);
                    // Limpiar caracteres especiales que rompen el JSON
                    jsonStr = jsonStr.replace(/●/g, '');
                    // Eliminar comas antes de ] o }
                    jsonStr = jsonStr.replace(/,(\s*[\]\}])/g, '$1');
                    console.log('JSON extraído y limpio:', jsonStr);
                    
                    try {
                        var estados = JSON.parse(jsonStr);
                        console.log('Estados parseados:', estados);
                        
                        $.each(estados, function(i, estado){
                            if(estado.id_estado != estadoActual){
                                select.append('<option value="' + estado.id_estado + '" data-requiere="' + estado.requiere_comentario + '">' + estado.nombre_estado + '</option>');
                            }
                        });
                        
                        console.log('Opciones agregadas, abriendo modal...');
                        $('#modalCambiarEstado').modal('show');
                        
                    } catch(e) {
                        console.error('Error al parsear JSON:', e);
                        alert('Error al procesar estados');
                    }
                } else {
                    console.error('No se encontró JSON válido en la respuesta');
                    alert('Respuesta inválida del servidor');
                }
            },
            error: function(xhr, status, error){
                console.error('Error AJAX:', status, error);
                alert('Error al cargar estados');
            }
        });
    });
    
    // Ver historial de estados
    $('.btnVerHistorial').off('click').on('click', function(){
        var id = $(this).data('id');
        
        $.ajax({
            url: '/sucursales2/sucursales/obtener_historial_estados.asp?id_solicitud=' + id,
            type: 'GET',
            dataType: 'json',
            success: function(historial){
                var tbody = $('#modalHistorialEstados #tbodyHistorial');
                tbody.empty();
                
                if(historial.length === 0){
                    tbody.append('<tr><td colspan="5" align="center">No hay historial de cambios</td></tr>');
                } else {
                    $.each(historial, function(i, item){
                        var tr = '<tr>';
                        tr += '<td align="center">' + (item.estado_anterior || 'N/A') + '</td>';
                        tr += '<td align="center"><i class="icon-arrow-right"></i></td>';
                        tr += '<td align="center"><span class="label label-' + item.color_badge + '">' + item.estado_nuevo + '</span></td>';
                        tr += '<td>' + (item.comentario || '') + '</td>';
                        tr += '<td align="center">' + item.usuario_cambio + '<br/><small>' + item.fecha_cambio + '</small></td>';
                        tr += '</tr>';
                        tbody.append(tr);
                    });
                }
                
                $('#modalHistorialEstados').modal('show');
            },
            error: function(){
                alert('Error al cargar el historial');
            }
        });
    });
}
</script>

<!-- Modal: Cambiar Estado -->
<div id="modalCambiarEstado" class="modal hide fade" tabindex="-1" role="dialog">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3>Cambiar Estado de Solicitud</h3>
    </div>
    <div class="modal-body">
        <form id="formCambiarEstado">
            <input type="hidden" id="id_solicitud_estado" name="id_solicitud_estado" />
            <input type="hidden" id="estado_actual_id" name="estado_actual_id" />
            
            <div class="control-group">
                <label class="control-label"><strong>Nuevo Estado: <span style="color:red;">*</span></strong></label>
                <div class="controls">
                    <select id="slc_nuevo_estado" name="slc_nuevo_estado" class="span10" required>
                        <option value="">Seleccione nuevo estado...</option>
                    </select>
                </div>
            </div>
            
            <div class="control-group" id="divComentarioEstado">
                <label class="control-label"><strong>Comentario:</strong></label>
                <div class="controls">
                    <textarea id="txt_comentario_estado" name="txt_comentario_estado" class="span10" rows="3" placeholder="Comentario opcional sobre el cambio de estado"></textarea>
                </div>
            </div>
        </form>
    </div>
    <div class="modal-footer">
        <button class="btn" data-dismiss="modal">Cancelar</button>
        <button class="btn btn-primary" id="btnGuardarEstado">Guardar Cambio</button>
    </div>
</div>

<!-- Modal: Historial de Estados -->
<div id="modalHistorialEstados" class="modal hide fade" tabindex="-1" role="dialog" style="width: 800px; margin-left: -400px;">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3>Historial de Estados</h3>
    </div>
    <div class="modal-body">
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th width="150">Estado Anterior</th>
                    <th width="30"></th>
                    <th width="150">Estado Nuevo</th>
                    <th>Comentario</th>
                    <th width="150">Usuario / Fecha</th>
                </tr>
            </thead>
            <tbody id="tbodyHistorial">
            </tbody>
        </table>
    </div>
    <div class="modal-footer">
        <button class="btn" data-dismiss="modal">Cerrar</button>
    </div>
</div>

<script type="text/javascript">
// Detectar cuando cambia el estado seleccionado para mostrar/ocultar comentario
// Campo de comentario siempre visible y opcional
// (código de evento change removido)

// Guardar cambio de estado
$('#btnGuardarEstado').on('click', function(){
    var idSolicitud = $('#id_solicitud_estado').val();
    var nuevoEstado = $('#slc_nuevo_estado').val();
    var comentario = $('#txt_comentario_estado').val();
    
    if(nuevoEstado === ''){
        alert('Debe seleccionar un nuevo estado');
        return;
    }
    
    $.ajax({
        url: '/sucursales2/sucursales/cambiar_estado_solicitud.asp',
        type: 'POST',
        data: {
            id_solicitud: idSolicitud,
            id_estado_nuevo: nuevoEstado,
            comentario: comentario
        },
        dataType: 'json',
        success: function(response){
            if(response.resultado === 'OK'){
                alert('Estado actualizado correctamente');
                $('#modalCambiarEstado').modal('hide');
                $('#formCambiarEstado')[0].reset();
                $('#divComentarioEstado').hide();
                cargarTablaSolicitudes();
            } else {
                alert('Error: ' + response.mensaje);
            }
        },
        error: function(xhr, status, error){
            alert('Error al cambiar el estado: ' + error);
            console.log(xhr.responseText);
        }
    });
});

// Limpiar formulario al cerrar modal
$('#modalCambiarEstado').on('hidden', function(){
    $('#formCambiarEstado')[0].reset();
    $('#divComentarioEstado').hide();
});
</script>
  
<% 	
	
	end if 
%>