<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones.asp"-->
<%
'Verificar sesión de administrador
'if Session("id_usuario")<>"" and Session("tipo")="admin" then

'Procesar actualización si viene del formulario
if Request.Form("accion") = "actualizar" then
    dim horaLimite, validarDiasHabiles, validarPlazo
    
    horaLimite = Request.Form("hora_limite")
    validarDiasHabiles = Request.Form("validar_dias_habiles")
    validarPlazo = Request.Form("validar_plazo")
    
    'Actualizar configuraciones
    sql = "UPDATE SUC_configuraciones SET conf_valor = '" & horaLimite & "', " & _
          "fecha_modificacion = GETDATE(), usuario_modificacion = '" & Session("id_usuario") & "' " & _
          "WHERE conf_grupo = 'PERSONAL' AND conf_clave = 'HORA_LIMITE_CARGA_REEMPLAZOS'"
    db.execute(sql)
    
    sql = "UPDATE SUC_configuraciones SET conf_valor = '" & validarDiasHabiles & "', " & _
          "fecha_modificacion = GETDATE(), usuario_modificacion = '" & Session("id_usuario") & "' " & _
          "WHERE conf_grupo = 'PERSONAL' AND conf_clave = 'VALIDAR_DIAS_HABILES'"
    db.execute(sql)
    
    sql = "UPDATE SUC_configuraciones SET conf_valor = '" & validarPlazo & "', " & _
          "fecha_modificacion = GETDATE(), usuario_modificacion = '" & Session("id_usuario") & "' " & _
          "WHERE conf_grupo = 'PERSONAL' AND conf_clave = 'VALIDAR_PLAZO_REEMPLAZOS'"
    db.execute(sql)
end if

'Obtener configuraciones actuales
sql = "SELECT conf_clave, conf_valor, conf_descripcion FROM SUC_configuraciones WHERE conf_grupo = 'PERSONAL' ORDER BY conf_clave"
set rs = db.execute(sql)

dim configuraciones
if not rs.eof then
    configuraciones = rs.getrows()
end if
rs.close
set rs = nothing
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <title>Configuraciones - Personal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="../css/bootstrap.css" rel="stylesheet" type="text/css">
    <link href="../css/bootstrap-responsive.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="../css/font-awesome.min.css" type="text/css">
    <script src="../js/jquery.js" type="text/javascript"></script>
    <style>
        body { padding: 20px; }
        .config-form { max-width: 800px; margin: 0 auto; }
        .help-block { color: #999; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row-fluid">
            <div class="span12">
                <h2><i class="icon-cog"></i> Configuraciones - Personal y Reemplazos</h2>
                <hr>
                
                <% if Request.Form("accion") = "actualizar" then %>
                <div class="alert alert-success">
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                    <strong>¡Éxito!</strong> Las configuraciones han sido actualizadas correctamente.
                </div>
                <% end if %>
                
                <div class="config-form">
                    <form method="post" action="admin_configuraciones.asp">
                        <input type="hidden" name="accion" value="actualizar">
                        
                        <div class="well">
                            <h4>Configuraciones de Carga de Reemplazos</h4>
                            
                            <div class="control-group">
                                <label class="control-label" for="hora_limite">
                                    <strong>Hora Límite para Carga de Reemplazos:</strong>
                                </label>
                                <div class="controls">
                                    <select name="hora_limite" id="hora_limite" class="input-small">
                                        <%
                                        dim horaActual
                                        if isArray(configuraciones) then
                                            for i = 0 to ubound(configuraciones, 2)
                                                if trim(configuraciones(0, i)) = "HORA_LIMITE_CARGA_REEMPLAZOS" then
                                                    horaActual = trim(configuraciones(1, i))
                                                end if
                                            next
                                        end if
                                        
                                        for h = 0 to 23
                                            dim selected
                                            selected = ""
                                            if CStr(h) = horaActual then selected = " selected"
                                        %>
                                        <option value="<%=h%>"<%=selected%>><%=Right("00" & h, 2)%>:00 hrs</option>
                                        <% next %>
                                    </select>
                                    <span class="help-block">
                                        Los cajeros adicionales deben cargarse antes de esta hora del día hábil anterior a la fecha de inicio.
                                    </span>
                                </div>
                            </div>
                            
                            <div class="control-group">
                                <label class="control-label">
                                    <strong>Validar Días Hábiles:</strong>
                                </label>
                                <div class="controls">
                                    <%
                                    dim validarDiasHabilesActual
                                    if isArray(configuraciones) then
                                        for i = 0 to ubound(configuraciones, 2)
                                            if trim(configuraciones(0, i)) = "VALIDAR_DIAS_HABILES" then
                                                validarDiasHabilesActual = trim(configuraciones(1, i))
                                            end if
                                        next
                                    end if
                                    %>
                                    <label class="radio">
                                        <input type="radio" name="validar_dias_habiles" value="1" <%= IIf(validarDiasHabilesActual = "1", "checked", "") %>>
                                        Sí - Solo permitir cargas en días hábiles (Lun-Vie)
                                    </label>
                                    <label class="radio">
                                        <input type="radio" name="validar_dias_habiles" value="0" <%= IIf(validarDiasHabilesActual = "0", "checked", "") %>>
                                        No - Permitir cargas cualquier día
                                    </label>
                                </div>
                            </div>
                            
                            <div class="control-group">
                                <label class="control-label">
                                    <strong>Validar Plazo de Carga:</strong>
                                </label>
                                <div class="controls">
                                    <%
                                    dim validarPlazoActual
                                    if isArray(configuraciones) then
                                        for i = 0 to ubound(configuraciones, 2)
                                            if trim(configuraciones(0, i)) = "VALIDAR_PLAZO_REEMPLAZOS" then
                                                validarPlazoActual = trim(configuraciones(1, i))
                                            end if
                                        next
                                    end if
                                    %>
                                    <label class="radio">
                                        <input type="radio" name="validar_plazo" value="1" <%= IIf(validarPlazoActual = "1", "checked", "") %>>
                                        Sí - Validar que se cargue antes de la hora límite del día hábil anterior
                                    </label>
                                    <label class="radio">
                                        <input type="radio" name="validar_plazo" value="0" <%= IIf(validarPlazoActual = "0", "checked", "") %>>
                                        No - No validar plazos (permitir cargas en cualquier momento)
                                    </label>
                                    <span class="help-block">
                                        <strong>Advertencia:</strong> Desactivar esta validación podría afectar la planificación operativa.
                                    </span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary btn-large">
                                <i class="icon-save"></i> Guardar Cambios
                            </button>
                            <a href="admin_personal.asp" class="btn btn-large">
                                <i class="icon-arrow-left"></i> Volver
                            </a>
                        </div>
                    </form>
                </div>
                
                <hr>
                
                <div class="well well-small">
                    <h5>Todas las Configuraciones del Grupo PERSONAL:</h5>
                    <table class="table table-striped table-bordered table-condensed">
                        <thead>
                            <tr>
                                <th>Clave</th>
                                <th>Valor</th>
                                <th>Descripción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            if isArray(configuraciones) then
                                for i = 0 to ubound(configuraciones, 2)
                            %>
                            <tr>
                                <td><code><%=configuraciones(0, i)%></code></td>
                                <td><strong><%=configuraciones(1, i)%></strong></td>
                                <td><%=configuraciones(2, i)%></td>
                            </tr>
                            <%
                                next
                            end if
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <script type="text/javascript">
    $(function(){
        $('.alert').delay(3000).fadeOut('slow');
    });
    </script>
</body>
</html>
<%
'else
'    response.Redirect("../login.asp")
'end if
%>
