<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<% 
idSucursal=request("idSucursalMain")
idUsuario = trim(request("idUsuarioMain"))
perfil = trim(request("perfilMain"))


' Para perfil 3 (CENTRAL), no es necesario tener sucursal seleccionada
if idSucursal="" and perfil <> "3" then
%>
	<div class="row-fluid">
        <span class="span12 alert alert-danger">
        <strong><h4><span id="loadIcon" style="display:none;"><i class="icon-spinner icon-spin icon-large"></i></span> <span class="icon-stack icon-large"><i class="icon-check-empty icon-stack-base"></i><i class="icon-group"></i></span> Seleccione una Sucursal</h4></strong>
        </span>
    </div>
<%else

sqlMotivos = "SELECT id_motivo_rebaja, nombre_motivo_rebaja FROM SUC_cat_motivo_solicitud_rebaja"
Set rsMotivos = DB.execute(sqlMotivos)
If Not rsMotivos.EOF Then
    datosMotivos = rsMotivos.GetRows()
End If

' Consulta para obtener lista de sucursales segÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Âºn perfil
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

' Consulta de solicitudes de rebaja cajeros adicionales
If perfil = "2" Then
    ' Para ZONAL, obtener todas las solicitudes de sus sucursales
'    sqlSolicitudes = "SELECT " & _
'                    "s.id_solicitud, s.id_sucursal, suc.suc_nombre, s.motivo_solicitud, " & _
'                    "CASE s.motivo_solicitud " & _
'                    "  WHEN 'licencia_medica' THEN 'Licencia Médica' " & _
'                    "  WHEN 'vacaciones' THEN 'Vacaciones' " & _
'                    "  WHEN 'reemplazo' THEN 'Reemplazo' " & _
'                    "  WHEN 'flujo' THEN 'Flujo' " & _
'                    "  ELSE s.motivo_solicitud " & _
'                    "END AS motivo_solicitud_texto, " & _
'                    "FORMAT(s.fecha_desde, 'dd/MM/yyyy') AS fecha_desde, FORMAT(s.fecha_hasta, 'dd/MM/yyyy') AS fecha_hasta, s.periodo, s.observaciones, " & _
'                    "s.id_estado, e.nombre_estado, e.color_badge, " & _
'                    "s.usuario_registro, FORMAT(s.fecha_registro, 'dd/MM/yyyy') AS fecha_registro " & _
'                    "FROM SUC_solicitud_cajeros_adicionales s " & _
'                    "LEFT JOIN SUC_sucursal suc ON s.id_sucursal = suc.id_sucursal " & _
'                    "LEFT JOIN SUC_cat_estados_solicitud e ON s.id_estado = e.id_estado " & _
'                    "WHERE s.activo = 1 " & _
'                    "AND s.id_sucursal IN (SELECT id_sucursal FROM SUC_usuario_sucursal WHERE id_usuario = " & idUsuario & ") " & _
'                    "ORDER BY s.fecha_registro DESC"

    sqlSolicitudes = "SELECT  " & _
                    "s.id_solicitud_rebaja, s.id_sucursal, suc.suc_nombre, s.motivo_solicitud_rebaja,  " & _
                    "mr.nombre_motivo_rebaja AS motivo_solicitud_texto,  " & _
                    "s.observaciones,  " & _
                    "s.id_estado_rebaja, e.nombre_estado_rebaja, e.color_badge_rebaja,  " & _
                    "s.usuario_registro, FORMAT(s.fecha_registro, 'dd/MM/yyyy') AS fecha_registro  " & _
                    "FROM SUC_solicitud_cajeros_adicionales_rebaja s  " & _
                    "LEFT JOIN SUC_sucursal suc ON s.id_sucursal = suc.id_sucursal  " & _
                    "LEFT JOIN SUC_cat_estados_solicitud_rebaja e ON s.id_estado_rebaja = e.id_estado_rebaja  " & _
                    "JOIN SUC_cat_motivo_solicitud_rebaja mr on mr.id_motivo_rebaja = s.motivo_solicitud_rebaja " & _
                    "WHERE s.activo = 1  " & _
                    "AND s.id_sucursal IN (SELECT id_sucursal FROM SUC_usuario_sucursal WHERE id_usuario = " & idUsuario & ") " & _
                    "ORDER BY s.fecha_registro DESC  " 
ElseIf perfil = "3" Then
    ' Para ADMIN/CENTRAL, mostrar todas las solicitudes sin importar idSucursal
'    sqlSolicitudes = "SELECT " & _
'                    "s.id_solicitud, s.id_sucursal, suc.suc_nombre, s.motivo_solicitud, " & _
'                    "CASE s.motivo_solicitud " & _
'                    "  WHEN 'licencia_medica' THEN 'Licencia Médica' " & _
'                    "  WHEN 'vacaciones' THEN 'Vacaciones' " & _
'                    "  WHEN 'reemplazo' THEN 'Reemplazo' " & _
'                    "  WHEN 'flujo' THEN 'Flujo' " & _
'                    "  ELSE s.motivo_solicitud " & _
'                    "END AS motivo_solicitud_texto, " & _
'                    "FORMAT(s.fecha_desde, 'dd/MM/yyyy') AS fecha_desde, FORMAT(s.fecha_hasta, 'dd/MM/yyyy') AS fecha_hasta, s.periodo, s.observaciones, " & _
'                    "s.id_estado, e.nombre_estado, e.color_badge, " & _
'                    "s.usuario_registro, FORMAT(s.fecha_registro, 'dd/MM/yyyy') AS fecha_registro " & _
'                    "FROM SUC_solicitud_cajeros_adicionales s " & _
'                    "LEFT JOIN SUC_sucursal suc ON s.id_sucursal = suc.id_sucursal " & _
'                    "LEFT JOIN SUC_cat_estados_solicitud e ON s.id_estado = e.id_estado " & _
'                    "WHERE s.activo = 1 " & _
'                    "ORDER BY s.fecha_registro DESC"

    sqlSolicitudes = "SELECT  " & _
                    "s.id_solicitud_rebaja, s.id_sucursal, suc.suc_nombre, s.motivo_solicitud_rebaja,  " & _
                    "mr.nombre_motivo_rebaja AS motivo_solicitud_texto,  " & _
                    "s.observaciones,  " & _
                    "s.id_estado_rebaja, e.nombre_estado_rebaja, e.color_badge_rebaja,  " & _
                    "s.usuario_registro, FORMAT(s.fecha_registro, 'dd/MM/yyyy') AS fecha_registro  " & _
                    "FROM SUC_solicitud_cajeros_adicionales_rebaja s  " & _
                    "LEFT JOIN SUC_sucursal suc ON s.id_sucursal = suc.id_sucursal  " & _
                    "LEFT JOIN SUC_cat_estados_solicitud_rebaja e ON s.id_estado_rebaja = e.id_estado_rebaja  " & _
                    "JOIN SUC_cat_motivo_solicitud_rebaja mr on mr.id_motivo_rebaja = s.motivo_solicitud_rebaja " & _
                    "WHERE s.activo = 1  " & _
                    "ORDER BY s.fecha_registro DESC  " 
Else
    ' Para otros perfiles, solo su sucursal
    sqlSolicitudes = "EXEC SP_SUC_listar_solicitudes_cajeros_rebaja @id_sucursal=" & idSucursal
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
<script type="text/javascript">

// Guardar cambio de estado
$('#btnExportarExcelRebajaModal').on('click', function(){

        var fechaDesde = $('#fecha_desde_sol_rebaja').val();
        var fechaHasta = $('#fecha_hasta_sol_rebaja').val();

        var url = '../sucursales/solicitudRebajaCajerosAdicionales_csv.asp?fechaDesdeSol_rebaja=' + fechaDesde + '&fechaHastaSol_rebaja=' + fechaHasta;
        window.open(url, '_blank');
        $('#modalExportarExcel').modal('hide');

    });
</script>

<div class="row-fluid span12">
<input type="hidden" name="idSucursal" id="idSucursal" value="<%=idSucursal%>" />
    <div class="row-fluid">    	
        <span class="span12 alert alert-success">
            <strong>
                <h4>
                    <span id="loadIcon" style="display:none;">
                        <i class="icon-spinner icon-spin icon-large"></i>
                    </span>
                    <span class="icon-solicitud-rebaja-cajeros ">
                        <i class="icon-user icon-solicitud-rebaja-cajeros-usuario" ></i>
                        <span class="icon-solicitud-rebaja-cajeros-badge">
                            <i class="icon-circle icon-solicitud-rebaja-cajeros-circulo"></i>
                            <i class="icon-arrow-up icon-solicitud-rebaja-cajeros-flecha"></i>
                        </span>
                    </span>
                    
                    Solicitud Rebaja Cajeros Adicionales
                </h4>
            </strong>
        </span>        
    </div>
            <%
                If perfil = "3" Then
            %>
                <a class="btn btn-warning btn btnExportarExcelRebaja" id="btnExportarExcelRebaja">
                    <i class="icon-cloud-download icon"></i>
                    &nbsp;<span class="bajaLetra"><b>EXPORTAR A EXCEL</b></span>
                </a>
            <%
                End If
            %>
    <% If perfil <> "3" Then %>
    <div class="row-fluid">
    	<div class="span12">
            <button class="btn btn-success" id="btnCrearSolicitudRebaja">
                <i class="icon-plus icon-white"></i> Crear Solicitud
            </button>
        </div>
    </div>   

    <script type="text/javascript">
    	$('#btnCrearSolicitudRebaja').click(function(){
            $('#formsIng').fadeIn('slow');
            $('#txt_obligatorio').css('display', 'inline');
            $('#txt_obligatorio').css('color', 'red');
            $('#hidden_modo').prop('value', 'NEW');

            <% If perfil = "2" Then %>
                $('#slc_sucursal').prop('disabled', false).css('background-color', '');
                <% Else %>
                    $('#slc_sucursal').prop('disabled', true).css('background-color', '#f5f5f5');
            <% End If %>

    });
    </script>
    <% End If %>
    <br/>

    <div class="row-fluid">
    	<div class="span12 well" id="formsIng" style="display:none;">
            <h5>Solicitud Rebaja Cajeros Adicionales</h5>
            <form id="formSolicitudRebajaCajero">
                <input type="hidden" id="id_solicitud_rebaja" name="id_solicitud_rebaja" value="0" />
                <input type="hidden" id="id_sucursal_hidden" name="id_sucursal_hidden" value="<%=idSucursal%>" />
                <input type="hidden" id="hidden_modo" name="hidden_modo" value=""/>
                
                <div class="row-fluid">
                    <div class="span6">
                        <label><strong>Sucursal: <span style="color:red;">*</span></strong></label>
                        <select id="slc_sucursal" name="slc_sucursal" class="span12" required disabled style="background-color:#f5f5f5;">
                            <option value="">Seleccione sucursal...</option>
                            <%
                            If IsArray(datosSucursales) Then
                                For i = 0 To UBound(datosSucursales, 2)
                                    idSuc = Trim(datosSucursales(0, i))
                                    nombreSuc = Server.HTMLEncode(Trim(datosSucursales(1, i)))
                                    seleccionado = ""
                                    If CStr(idSuc) = CStr(idSucursal) Then seleccionado = "selected"
                            %>
                                    <option <%=seleccionado%> value="<%=idSuc%>"><%=nombreSuc%></option>
                            <%
                                Next
                            End If
                            %>
                        </select>
                    </div>
                    <div class="span6">
                        <label><strong>Motivo Solicitud: <span style="color:red;">*</span></strong></label>
                        <select id="slc_motivo" name="slc_motivo" class="span12" required <% If perfil = "3" Then %>disabled style="background-color:#f5f5f5;"<% End If %>>
                            <option value="">Seleccione motivo...</option>
                            <%
                            If IsArray(datosMotivos) Then
                                For i = 0 To UBound(datosMotivos, 2)
                                    id_motivo_rebaja = Trim(datosMotivos(0, i))
                                    nombre_motivo_rebaja = Server.HTMLEncode(Trim(datosMotivos(1, i)))
                                    seleccionado = ""
                            %>
                                    <option value="<%=id_motivo_rebaja%>" <%=seleccionado%>><%=nombre_motivo_rebaja%></option>
                            <%
                                Next
                            End If
                            %>
                        </select>
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
                <div class="row-fluid" style="display:none;">
                    <div class="span6">
                        <label><strong>Periodo: <span style="color:red;">*</span></strong></label>
                        <select id="slc_periodo" name="slc_periodo" class="span12">
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
                </div>
                <div class="row-fluid">
                    <div class="span12">
                        <label><strong>Observaciones:</strong><span id="txt_obligatorio">*</span> <small>(Máximo 50 caracteres)</small></label>
                        <textarea id="txt_observaciones" name="txt_observaciones" class="span12" rows="3" maxlength="50" ></textarea>
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
                
                // Guardar solicitud
                $('#formSolicitudRebajaCajero').submit(function(e){
                    e.preventDefault();
                    // Validar que la sucursal esté seleccionada
                    if($('#slc_sucursal').val() === ''){
                        alert('Por favor seleccione una sucursal');
                        return false;
                    }
                    // Modo edita observacion obligatoria 
                    if($('#hidden_modo').val() === 'EDIT' || $('#hidden_modo').val() === 'NEW'){
                        if($('#txt_observaciones').val() === ''){
                            alert('Por favor ingrese observaciones');
                            return false;
                        }
                    }
                    // Calcular periodo automáticamente desde la fecha_desde (formato YYYY - MES)
                    var fechaDesde = $('#fecha_desde').val(); // formato YYYY-MM-DD
                    var periodo = '';
                    if(fechaDesde) {
                        var partes = fechaDesde.split('-');
                        var year = partes[0];
                        var mes = partes[1];
                        var meses = ['ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO', 
                                     'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'];
                        var nombreMes = meses[parseInt(mes) - 1];
                        periodo = year + ' - ' + nombreMes; // Ejemplo: "2025 - NOVIEMBRE"
                    }
                    
                    var datos = {
                        id_solicitud_rebaja: $('#id_solicitud_rebaja').val(),
                        id_sucursal: $('#slc_sucursal').val(),
                        motivo: $('#slc_motivo').val(),
                        fecha_desde: $('#fecha_desde').val(),
                        fecha_hasta: $('#fecha_hasta').val(),
                        periodo: periodo,
                        observaciones: $('#txt_observaciones').val(),
                        perfil: '<%=perfil%>'
                    };
                    
                    console.log('Periodo calculado:', periodo);
                    console.log('Enviando datos:', datos);

		            var url_ajax='../sucursales/guardar_solicitud_rebaja_cajero.asp';
                    <% If perfil <> "3" Then %>
		                url_ajax='sucursales/guardar_solicitud_rebaja_cajero.asp';
                    <% End If %>

                    $.ajax({
                        type: 'POST',
                        url: url_ajax,
                        data: datos,
                        dataType: 'text',  // Cambiado a text para ver la respuesta cruda
                        success: function(responseText){
                            console.log('Respuesta cruda:', responseText);
                            try {
                                var response = JSON.parse(responseText);
                                console.log('JSON parseado:', response);
                                if(response.resultado === 'OK'){
                                    alert('Solicitud guardada correctamente');
                                    $('#formSolicitudRebajaCajero')[0].reset();
                                    $('#id_solicitud_rebaja').val(''); // Limpiar el ID
                                    $('#slc_sucursal').val($('#idSucursal').val()); // Restaurar sucursal
                                    $('#formsIng').fadeOut('fast');
                                    // Recargar solo la tabla sin refresh completo
                                    cargarTablaSolicitudesPaginada(1);
                                    
                                    // Registrar log
                                    // var accion = datos.id_solicitud_rebaja == '0' ? 'Crear solicitud rebaja cajero adicional' : 'Editar solicitud rebaja cajero adicional';
                                    // var idLog = response.id || datos.id_solicitud_rebaja || '';
                                    // registrarLog('Solicitud Rebaja Cajeros Adicionales', accion, idLog);
                                } else {
                                    alert('Alerta: ' + response.mensaje);
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
                            alert('Error al guardar (Status ' + xhr.status + '): ' + error + '\n\nRevise la consola para mÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡s detalles.');
                        }
                    });
                });
            </script>
        </div>        
    </div>
    
    <!-- Tabla de Solicitudes de Cajeros Adicionales -->
    <div class="row-fluid" id="idTablaSolicitudes">
        <div class="span12">
            <div class="row-fluid">
                <div class="span6">
                    <!--span><h6>Solicitudes de Cajeros Adicionales</h6></span-->
                </div>
                <div class="span6" style="text-align:right;">
                    <label style="display:inline-block; margin-right:10px;">Registros por página:</label>
                    <select id="page_size_solicitudes" style="width:80px; display:inline-block;">
                        <option value="10">10</option>
                        <option value="15" selected>15</option>
                        <option value="25">25</option>
                        <option value="50">50</option>
                    </select>
                </div>
            </div>
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
                    <tr>
                        <td colspan="<% If perfil = "2" Or perfil = "3" Then %>10<% Else %>9<% End If %>" align="center">
                            <i class="icon-spinner icon-spin"></i> Cargando solicitudes...
                        </td>
                    </tr>
                </tbody>
            </table>
            
            <!-- Paginación -->
            <div class="row-fluid" id="paginacion_solicitudes" style="text-align:center; margin-top:10px;"></div>
            
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
                                    $('#solicitudRow' + id).fadeOut('fast', function(){
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
            </script>
            
            <script type="text/javascript">
            // ***** PAGINACIÓN *****
            $(function(){
                $('#formsIng').slideUp('fast');
                // Cargar tabla con paginación al inicio
                cargarTablaSolicitudesPaginada(1);
            });

            // Función para cargar solicitudes con paginación
            function cargarTablaSolicitudesPaginada(pagina) {
                console.log('Cargando página:', pagina);
                
                var pageSize = $('#page_size_solicitudes').val() || 15;
                var params = {
                    page: pagina,
                    page_size: pageSize,
                    perfil: '<%=perfil%>'
                };

                var url_ajax='../sucursales/obtener_solicitudes_rebaja_paginadas.asp';
                <% If perfil <> "3" Then %>
                params.idUsuario = '<%=idUsuario%>';
                params.idSucursal = '<%=idSucursal%>';
		        url_ajax='sucursales/obtener_solicitudes_rebaja_paginadas.asp';
                <% End If %>
                
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
                        var tbody = $('#tbodySolicitudes');
                        tbody.empty();
                        
                        if(data.solicitudes.length === 0) {
                            tbody.append('<tr><td colspan="<% If perfil = "2" Or perfil = "3" Then %>10<% Else %>9<% End If %>" style="text-align:center">No hay solicitudes registradas</td></tr>');
                        } else {
                            $.each(data.solicitudes, function(i, sol){
                                var tr = '<tr id="solicitudRow' + sol.id_solicitud_rebaja + '">';
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
                                    if(parseInt(sol.id_estado_rebaja) === 3 ) {
                                        tr += '<i class="icon-exchange icon-large mano btnCambiarEstadoRebaja" data-id="' + sol.id_solicitud_rebaja + '" data-id_motivoActual="' + sol.id_motivo_rebaja + '" data-estado_rebaja="' + sol.id_estado_rebaja + '" title="Cambiar Estado"></i> ';
                                    }
                                <% Else %>
                                    <% If perfil = "2" Then %>
                                        if(parseInt(sol.id_estado_rebaja) === 1 || parseInt(sol.id_estado_rebaja) === 3 ) {
                                            tr += '<i class="icon-exchange icon-large mano btnCambiarEstadoRebaja" data-id="' + sol.id_solicitud_rebaja + '" data-id_motivoActual="' + sol.id_motivo_rebaja + '"  data-estado_rebaja="' + sol.id_estado_rebaja + '" title="Cambiar Estado"></i> ';
                                        }
                                    <% End If %>
                                    <% If perfil = "1" Then %>
                                        if(parseInt(sol.id_estado_rebaja) === 1 ) {
                                            tr += '<i class="icon-exchange icon-large mano btnCambiarEstadoRebaja" data-id="' + sol.id_solicitud_rebaja + '" data-id_motivoActual="' + sol.id_motivo_rebaja + '"  data-estado_rebaja="' + sol.id_estado_rebaja + '" title="Cambiar Estado"></i> ';
                                        }
                                    <% End If %>
                                <% End If %>

                                <% If perfil = "1" Then %>
                                    if(parseInt(sol.id_estado_rebaja) === 1) {
                                        tr += '<i class="icon-pencil icon-large mano btnEditarSolicitud" data-id="' + sol.id_solicitud_rebaja + '" data-id_motivoActual="' + sol.id_motivo_rebaja + '"  title="Editar"></i> ';
                                    }
                                    <% ElseIf perfil = "2" Then %>
                                    if(parseInt(sol.id_estado_rebaja) === 1 || parseInt(sol.id_estado_rebaja) === 3) {
                                        tr += '<i class="icon-pencil icon-large mano btnEditarSolicitud" data-id="' + sol.id_solicitud_rebaja + '" data-id_motivoActual="' + sol.id_motivo_rebaja + '"  title="Editar"></i> ';
                                    }
                                        <% ElseIf perfil = "3" Then %>
                                        if(parseInt(sol.id_estado_rebaja) === 3) {
                                            tr += '<i class="icon-pencil icon-large mano btnEditarSolicitud" data-id="' + sol.id_solicitud_rebaja + '" data-id_motivoActual="' + sol.id_motivo_rebaja + '"  title="Editar"></i> ';
                                        }
                                <% End If %>
                                tr += '<i class="icon-list-alt icon-large mano btnVerHistorial" data-id="' + sol.id_solicitud_rebaja + '" title="Ver Historial"></i>';
                                
                                tr += '</td>';
                                tr += '</tr>';
                                tbody.append(tr);
                            });
                        }
                        
                        // Generar controles de paginación
                        generarPaginacion(data.page, data.totalPaginas);
                    },
                    error: function(xhr, status, error) {
                        console.error('Error al cargar solicitudes:', error);
                        console.error('Response:', xhr.responseText);
                        alert('Error al cargar las solicitudes');
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
                cargarTablaSolicitudesPaginada(pagina);
            });

            // Evento para cambiar tamaño de página
            $('#page_size_solicitudes').change(function(){
                cargarTablaSolicitudesPaginada(1);
            });
            </script>
        </div>
    </div>
</div>

<script type="text/javascript">
function registrarLog(funcionalidad, tipoAccion, idRegistro) {
    var datosLog = {
        funcionalidad: funcionalidad,
        tipo_accion: tipoAccion
    };
    if (idRegistro !== undefined && idRegistro !== null && $.trim(idRegistro.toString()) !== '') {
        datosLog.id_registro = idRegistro;
    }
    $.ajax({
        url: 'personal/registrar_log.asp',
        data: datosLog,
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

// FunciÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³n para recargar solo la tabla de solicitudes
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
            var tbody = $('#tbodySolicitudes');
            tbody.empty();
            
            if(solicitudes.length === 0) {
                tbody.append('<tr><td colspan="<% If perfil = "2" Or perfil = "3" Then %>10<% Else %>9<% End If %>" style="text-align:center">No hay solicitudes registradas</td></tr>');
            } else {
                $.each(solicitudes, function(i, sol){
                    var tr = '<tr id="solicitudRow' + sol.id_solicitud_rebaja + '">';
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

// FunciÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³n para reactivar eventos despuÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©s de recargar la tabla
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
                        $('#solicitudRow' + id).fadeOut('fast', function(){
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

    // Exportar excel
    $(document).on('click', '.btnExportarExcelRebaja', function(){
        try {
            $('#modalExportarExcel').modal('show');
            
        } catch(e) {
            console.error('Error al mostrar exportar excel:', e);
            alert('Error al procesar estados');
        }
    });

    // Cambiar estado de solicitud - CON DELEGACIÓN DE EVENTOS
    $(document).on('click', '.btnCambiarEstadoRebaja', function(){
        var id = $(this).data('id');
        var estadoActual_rebaja = $(this).data('estado_rebaja');
        var motivoActual_rebaja = $(this).data('id_motivoactual');
        
        console.log('ID:', id, 'Estado actual:', estadoActual_rebaja);
        console.log('ID:', id, 'Motivo actual:', motivoActual_rebaja);
        
        $('#modalCambiarEstado_rebaja #id_solicitud_rebaja_estado').val(id);
        $('#modalCambiarEstado_rebaja #estado_actual_rebaja_id').val(estadoActual_rebaja);

		var url_ajax='../sucursales/obtener_estados_solicitud_rebaja.asp';
        <% If perfil <> "3" Then %>
		    url_ajax='sucursales/obtener_estados_solicitud_rebaja.asp';
        <% End If %>
        
        // Cargar estados con AJAX
        $.ajax({
            url: url_ajax,
            type: 'GET',
            data: {
                perfil: '<%=perfil%>',
                estado_actual: estadoActual_rebaja
            },
            dataType: 'text',
            success: function(data){
                console.log('Respuesta recibida:', data);
                
                var select = $('#modalCambiarEstado_rebaja #slc_nuevo_estado_rebaja');
                select.empty().append('<option value="">Seleccione nuevo estado...</option>');
                
                // Extraer solo el JSON del texto
                var jsonStart = data.indexOf('[');
                var jsonEnd = data.lastIndexOf(']') + 1;
                
                console.log('JSON inicio:', jsonStart, 'JSON fin:', jsonEnd);
                
                if(jsonStart >= 0 && jsonEnd > 0){
                    var jsonStr = data.substring(jsonStart, jsonEnd);
                    // Limpiar caracteres especiales que rompen el JSON
                    jsonStr = jsonStr.replace(/ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â/g, '');
                    // Eliminar comas antes de ] o }
                    jsonStr = jsonStr.replace(/,(\s*[\]\}])/g, '$1');
                    console.log('JSON extraido y limpio:', jsonStr);
                    
                    try {
                        var estados = JSON.parse(jsonStr);
                        console.log('Estados parseados:', estados);
                        
                        $.each(estados, function(i, estado){
                            if(estado.id_estado_rebaja != estadoActual_rebaja){
                                select.append('<option value="' + estado.id_estado_rebaja + '" data-requiere="' + estado.requiere_comentario_rebaja + '">' + estado.nombre_estado_rebaja + '</option>');
                            }
                        });
                        
                        console.log('Opciones agregadas, abriendo modal...');
                        $('#modalCambiarEstado_rebaja').modal('show');
                        
                    } catch(e) {
                        console.error('Error al parsear JSON:', e);
                        alert('Error al procesar estados');
                    }
                } else {
                    console.error('No se encontlido en la respuesta');
                    alert('Respuesta invalida del servidor');
                }
            },
            error: function(xhr, status, error){
                console.error('Error AJAX:', status, error);
                alert('Error al cargar estados rebaja');
            }
        });

		url_ajax='../sucursales/obtener_motivos_solicitud_rebaja.asp';
        <% If perfil <> "3" Then %>
    		url_ajax='sucursales/obtener_motivos_solicitud_rebaja.asp';
        <% End If %>

        // Cargar motivo rebaja con AJAX
        $.ajax({
            url: url_ajax,
            type: 'GET',
            data: {
                perfil: '<%=perfil%>',
                motivo_actual: motivoActual_rebaja
            },
            dataType: 'text',
            success: function(data){
                console.log('Respuesta recibida Motivos:', data);
                
                var select = $('#modalCambiarEstado_rebaja #slc_motivo_rebaja');
                select.empty().append('<option value="">Seleccione motivo rebaja...</option>');
                $('#slc_motivo_rebaja').prop('disabled', true).css('background-color', '');
                
                // Extraer solo el JSON del texto
                var jsonStart = data.indexOf('[');
                var jsonEnd = data.lastIndexOf(']') + 1;
                
                console.log('JSON inicio:', jsonStart, 'JSON fin:', jsonEnd);
                
                if(jsonStart >= 0 && jsonEnd > 0){
                    var jsonStr = data.substring(jsonStart, jsonEnd);
                    // Limpiar caracteres especiales que rompen el JSON
                    jsonStr = jsonStr.replace(/ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â/g, '');
                    // Eliminar comas antes de ] o }
                    jsonStr = jsonStr.replace(/,(\s*[\]\}])/g, '$1');
                    console.log('JSON extraido y limpio:', jsonStr);
                    
                    try {
                        var motivos = JSON.parse(jsonStr);
                        console.log('Motivos parseados:', motivos);
                        
                        $.each(motivos, function(i, motivo){
                            if(motivo.id_motivo_rebaja != motivoActual_rebaja){
                                select.append('<option value="' + motivo.id_motivo_rebaja + '" data-requiere="' + motivo.requiere_comentario + '">' + motivo.nombre_motivo_rebaja + '</option>');
                            }else{
                                select.append('<option selected value="' + motivo.id_motivo_rebaja + '" data-requiere="' + motivo.requiere_comentario + '">' + motivo.nombre_motivo_rebaja + '</option>');
                            }
                        });
                        
                        console.log('Opciones agregadas, abriendo modal...');
                        $('#modalCambiarEstado_rebaja').modal('show');
                        
                    } catch(e) {
                        console.error('Error al parsear JSON:', e);
                        alert('Error al procesar estados');
                    }
                } else {
                    console.error('No se encontlido en la respuesta');
                    alert('Respuesta invalida del servidor');
                }
            },
            error: function(xhr, status, error){
                console.error('Error AJAX:', status, error);
                alert('Error al cargar motivos');
            }
        });
    });
    
    // Ver historial de estados - CON DELEGACIÓN DE EVENTOS
    $(document).on('click', '.btnVerHistorial', function(){
        var id = $(this).data('id');

		var url_ajax='../sucursales/obtener_historial_estados_rebaja.asp?id_solicitud_rebaja=' + id;
        <% If perfil <> "3" Then %>
		    url_ajax='sucursales/obtener_historial_estados_rebaja.asp?id_solicitud_rebaja=' + id;
        <% End If %>
        
        $.ajax({
            url: url_ajax,
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
                        tr += '<td align="center"><span class="label label-' + item.color_badge_rebaja + '">' + item.estado_nuevo + '</span></td>';
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

<!-- Modal: Exportar excel -->
<div id="modalExportarExcel" class="modal hide fade" style="max-width: 500px;" tabindex="-1" role="dialog">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3>Exportar Excel</h3>
    </div>
    <div class="modal-body">
        <form id="formExportarExcel">
            <div class="control-group">
                <div class="row-fluid">
                    <div class="span1">
                    </div>
                    <div class="span5">
                        <label style="display:inline-block; margin-right:10px;">Registro desde:</label>
                        <%
                            ' Calculamos la fecha de hace 3 meses
                            Dim fechaMinima
                            fechaMinima = DateAdd("m", -3, Date())
                            
                            ' Formateamos a YYYY-MM-DD
                            Dim strMin
                            strMin = Year(fechaMinima) & "-" & _
                                    Right("0" & Month(fechaMinima), 2) & "-" & _
                                    Right("0" & Day(fechaMinima), 2)
                        %>                        
                        <div class="controls">
                            <input type="date" 
                                name="fecha_desde_sol_rebaja" 
                                id="fecha_desde_sol_rebaja" 
                                class="input-medium" 
                                min="<%= strMin %>" 
                                max="<%= Year(Date()) & "-" & Right("0" & Month(Date()), 2) & "-" & Right("0" & Day(Date()), 2) %>"
                                value="<%= Year(Date()) & "-" & Right("0" & Month(Date()), 2) & "-" & Right("0" & Day(Date()), 2) %>" />                            
                        </div>
                    <div class="span1">
                    </div>
                    </div>
                    <div class="span5" style="text-align:left;">
                        <label style="display:inline-block; margin-right:10px;">Registro hasta:</label>
                        <div class="controls">
                            <input type="date" name="fecha_hasta_sol_rebaja" id="fecha_hasta_sol_rebaja" class="input-medium" value="<%=Year(Date()) & "-" & Right("0" & Month(Date()), 2) & "-" & Right("0" & Day(Date()), 2)%>" />
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <div class="modal-footer">
        <button class="btn" data-dismiss="modal">Cancelar</button>
        <button class="btn btn-primary" id="btnExportarExcelRebajaModal">Exportar</button>
    </div>
</div>

<!-- Modal: Cambiar Estado -->
<div id="modalCambiarEstado_rebaja" class="modal hide fade" tabindex="-1" role="dialog">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3>Cambiar Estado de Solicitud</h3>
    </div>
    <div class="modal-body">
        <form id="formCambiarEstado_rebaja">
            <input type="hidden" id="id_solicitud_rebaja_estado" name="id_solicitud_rebaja_estado" />
            <input type="hidden" id="estado_actual_rebaja_id" name="estado_actual_rebaja_id" />
            
            <div class="control-group">
                <label class="control-label"><strong>Nuevo Estado: <span style="color:red;">*</span></strong></label>
                <div class="controls">
                    <select id="slc_nuevo_estado_rebaja" name="slc_nuevo_estado_rebaja" class="span10" required>
                        <option value="">Seleccione nuevo estado...</option>
                    </select>
                </div>
            </div>
            
            <div class="control-group">
                <label class="control-label"><strong>Motivo rebaja: <span style="color:red;">*</span></strong></label>
                <div class="controls">
                    <select id="slc_motivo_rebaja" name="slc_motivo_rebaja" class="span10" required>
                        <option value="">Seleccione motivo...</option>
                    </select>
                </div>
            </div>

            <div class="control-group" id="divComentarioEstado">
                <label class="control-label"><strong>Comentario: <span style="color:red;">*</span></strong></label>
                <div class="controls">
                    <textarea id="txt_comentario_estado" name="txt_comentario_estado" class="span10" rows="3" placeholder="Ingrese un comentario sobre el cambio de estado" maxlength="100" required></textarea>
                    <!--p id="char-count" style="font-size: 12px; color: gray;">0 / 100 caracteres</p-->
                    <script type="text/javascript">
//                        const textarea = document.getElementById('txt_comentario_estado');
//                        const count = document.getElementById('char-count');

//                        textarea.addEventListener('input', function() {
//                            const remaining = this.value.length;
//                            count.textContent = `${remaining} / 100 caracteres`;
                            
                            // Opcional: cambiar color si llega al límite
//                            if (remaining >= 100) {
//                                count.style.color = 'red';
//                            } else {
//                                count.style.color = 'gray';
//                            }
//                        });
                    </script>
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
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
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
// (cÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³digo de evento change removido)

// Guardar cambio de estado
$('#btnGuardarEstado').on('click', function(){
    var idSolicitudRebaja = $('#id_solicitud_rebaja_estado').val();
    var nuevoEstado = $('#slc_nuevo_estado_rebaja').val();
    var nombreEstado = $('#slc_nuevo_estado_rebaja option:selected').text();
    var nuevoMotivo = $('#slc_motivo_rebaja').val();
    var nombreMotivo = $('#slc_motivo_rebaja option:selected').text();
    var comentario = $('#txt_comentario_estado').val();
    
    
    if(nuevoEstado === ''){
        alert('Debe seleccionar un nuevo estado');
        return;
    }
    
    if(nuevoMotivo === ''){
        alert('Debe seleccionar un motivo');
        return;
    }

    if(comentario.trim() === ''){
        alert('El comentario es obligatorio');
        return;
    }

    var url_ajax='../sucursales/cambiar_estado_solicitud_rebaja.asp';
    <% If perfil <> "3" Then %>
        url_ajax='sucursales/cambiar_estado_solicitud_rebaja.asp';
    <% End If %>
    
    $.ajax({
        url: url_ajax,
        type: 'POST',
        data: {
            id_solicitud_rebaja: idSolicitudRebaja,
            id_estado_nuevo: nuevoEstado,
            comentario: comentario
        },
        dataType: 'json',
        success: function(response){
            if(response.resultado === 'OK'){
                alert('Estado actualizado correctamente');
                $('#modalCambiarEstado_rebaja').modal('hide');
                $('#formCambiarEstado_rebaja')[0].reset();
                cargarTablaSolicitudesPaginada(1);
                
                // Registrar log del cambio de estado
                // registrarLog('Solicitud Rebaja Cajeros Adicionales', 'Cambiar estado a ' + nombreEstado, idSolicitudRebaja);
            } else {
                alert('Alerta: ' + response.mensaje);
            }
        },
        error: function(xhr, status, error){
            alert('Error al cambiar el estado: ' + error);
            console.log(xhr.responseText);
        }
    });
});

// Limpiar formulario al cerrar modal
$('#modalCambiarEstado_rebaja').on('hidden', function(){
    $('#formCambiarEstado_rebaja')[0].reset();
});
</script>
  
<% 	
	
	end if 
%>