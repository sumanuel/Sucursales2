<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "text/html; charset=utf-8"
Response.CharSet = "utf-8"

' Función para corregir caracteres mal codificados
function corregirTexto(texto)
    if IsNull(texto) or texto = "" then
        corregirTexto = texto
        exit function
    end if
    
    dim resultado
    resultado = texto
    
    ' Corregir caracteres comunes mal codificados
    resultado = Replace(resultado, "pÃ¡gina", "página")
    resultado = Replace(resultado, "p?gina", "página")
    resultado = Replace(resultado, "pí¿½gina", "página")
    resultado = Replace(resultado, "pï¿½gina", "página")
    resultado = Replace(resultado, "Ã³", "ó")
    resultado = Replace(resultado, "Ã­", "í")
    resultado = Replace(resultado, "Ã±", "ñ")
    resultado = Replace(resultado, "Ã¡", "á")
    resultado = Replace(resultado, "Ã©", "é")
    resultado = Replace(resultado, "Ãº", "ú")
    resultado = Replace(resultado, "Ã", "Ó")
    resultado = Replace(resultado, "í", "Í")
    resultado = Replace(resultado, "Ã'", "Ñ")
    resultado = Replace(resultado, "Ã", "Á")
    resultado = Replace(resultado, "Ã‰", "É")
    resultado = Replace(resultado, "Ãš", "Ú")
    resultado = Replace(resultado, "gestiÃ³n", "gestión")
    resultado = Replace(resultado, "gesti?n", "gestión")
    resultado = Replace(resultado, "Gesti?n", "Gestión")
    resultado = Replace(resultado, "AcciÃ³n", "Acción")
    resultado = Replace(resultado, "Acci?n", "Acción")
    resultado = Replace(resultado, "grÃ¡fico", "gráfico")
    resultado = Replace(resultado, "gr?fico", "gráfico")
    resultado = Replace(resultado, "pÃ­", "pí")
    resultado = Replace(resultado, "pÃ", "pá")
    
    corregirTexto = resultado
end function

' Formatear fecha de manera explícita como dd/mm/yyyy
function formatearFechaDMY(valorFecha)
    if IsNull(valorFecha) or Trim(CStr(valorFecha)) = "" then
        formatearFechaDMY = ""
        exit function
    end if

    if IsDate(valorFecha) then
        formatearFechaDMY = Right("0" & Day(CDate(valorFecha)), 2) & "/" & Right("0" & Month(CDate(valorFecha)), 2) & "/" & Year(CDate(valorFecha))
    else
        formatearFechaDMY = CStr(valorFecha)
    end if
end function

dim fechaDesde, fechaHasta, usuario, perfil, funcionalidad, tipoAccion, page, pageSize
fechaDesde = trim(request("fecha_desde"))
fechaHasta = trim(request("fecha_hasta"))
usuario = trim(request("usuario"))
perfil = trim(request("perfil"))
funcionalidad = trim(request("funcionalidad"))
tipoAccion = trim(request("tipo_accion"))
page = trim(request("page"))
pageSize = trim(request("page_size"))

if page = "" then page = "1"
if pageSize = "" then pageSize = "50"

dim sql, rsLogs
sql = "EXEC dbo.SCSS_obtener_reporte_log "

if fechaDesde <> "" then
    sql = sql & "@fecha_desde = '" & fechaDesde & "', "
else
    sql = sql & "@fecha_desde = NULL, "
end if

if fechaHasta <> "" then
    sql = sql & "@fecha_hasta = '" & fechaHasta & "', "
else
    sql = sql & "@fecha_hasta = NULL, "
end if

if usuario <> "" then
    sql = sql & "@usuario = '" & Replace(usuario, "'", "''") & "', "
else
    sql = sql & "@usuario = NULL, "
end if

if perfil <> "" then
    sql = sql & "@perfil = '" & Replace(perfil, "'", "''") & "', "
else
    sql = sql & "@perfil = NULL, "
end if

if funcionalidad <> "" then
    sql = sql & "@funcionalidad = '" & Replace(funcionalidad, "'", "''") & "', "
else
    sql = sql & "@funcionalidad = NULL, "
end if

if tipoAccion <> "" then
    sql = sql & "@tipo_accion = '" & Replace(tipoAccion, "'", "''") & "', "
else
    sql = sql & "@tipo_accion = NULL, "
end if

sql = sql & "@page = " & page & ", "
sql = sql & "@page_size = " & pageSize

on error resume next
set rsLogs = DB.execute(sql)

if err.number <> 0 then
    Response.Write("<div class='alert alert-error'>")
    Response.Write("<strong>Error:</strong> No se pudieron obtener los logs. " & err.description)
    Response.Write("</div>")
    err.clear
else
    dim totalRegistros
    if not rsLogs.EOF then
        totalRegistros = rsLogs("total_registros")
    else
        totalRegistros = 0
    end if

    set rsLogs = rsLogs.NextRecordset

    if not rsLogs.EOF then
        dim contador
        contador = (CInt(page) - 1) * CInt(pageSize)
%>
<table class="table table-bordered table-hover">
<tbody>
<tr>
    <td width="5%"><strong>#</strong></td>
    <td width="12%"><strong>Usuario</strong></td>
    <td width="10%"><strong>Perfil</strong></td>
    <td width="25%"><strong>Funcionalidad</strong></td>
    <td width="28%"><strong>Tipo Acción</strong></td>
    <td width="10%"><strong>Fecha</strong></td>
    <td width="10%"><strong>Hora</strong></td>
</tr>
<%
        do while not rsLogs.EOF
            contador = contador + 1
            dim usuarioReg, perfilReg, funcionalidadReg, tipoAccionReg, fechaReg, horaReg
            usuarioReg = corregirTexto(rsLogs("usuario"))
            perfilReg = corregirTexto(rsLogs("perfil"))
            funcionalidadReg = corregirTexto(rsLogs("funcionalidad"))
            tipoAccionReg = corregirTexto(rsLogs("tipo_accion"))
            fechaReg = rsLogs("fecha")
            
            ' Debug: verificar qué trae el campo hora
            horaReg = rsLogs.Fields("hora").Value
%>
<tr>
    <td><%=contador%></td>
    <td><%=Server.HTMLEncode(usuarioReg)%></td>
    <td>
<%
            select case perfilReg
                case "admin"
                    Response.Write("<span class='label label-important'>Admin</span>")
                case "Automatico"
                    Response.Write("<span class='label label-info'>Automático</span>")
                case "General"
                    Response.Write("<span class='label label-warning'>General</span>")
                case else
                    Response.Write(Server.HTMLEncode(perfilReg))
            end select
%>
    </td>
    <td><%=Server.HTMLEncode(funcionalidadReg)%></td>
    <td><%=Server.HTMLEncode(tipoAccionReg)%></td>
    <td><%=formatearFechaDMY(fechaReg)%></td>
    <td><%=horaReg%></td>
</tr>
<%
            rsLogs.MoveNext
        loop
%>
<tr>
    <td colspan="7" style="text-align: right; background-color: #f5f5f5;">
        <strong>Total de registros: <%=totalRegistros%> | Mostrando página <%=page%></strong>
    </td>
</tr>
</tbody>
</table>
<%
        dim totalPaginas, paginaActual
        paginaActual = CInt(page)
        totalPaginas = Int(totalRegistros / CInt(pageSize))
        if (totalRegistros Mod CInt(pageSize)) > 0 then
            totalPaginas = totalPaginas + 1
        end if

        if totalPaginas > 1 then
            dim inicioRango, finRango, i, htmlPag
            inicioRango = paginaActual - 2
            finRango = paginaActual + 2
            if inicioRango < 1 then inicioRango = 1
            if finRango > totalPaginas then finRango = totalPaginas
            
            ' Construir HTML en VBScript
            htmlPag = "<div class=""pagination""><ul>"
            
            ' Botón anterior
            if paginaActual > 1 then
                htmlPag = htmlPag & "<li><a href=""#"" class=""btn-pagina-log"" data-pagina=""" & (paginaActual - 1) & """>« Anterior</a></li>"
            else
                htmlPag = htmlPag & "<li class=""disabled""><a href=""#"">« Anterior</a></li>"
            end if
            
            ' Primera página y elipsis
            if inicioRango > 1 then
                htmlPag = htmlPag & "<li><a href=""#"" class=""btn-pagina-log"" data-pagina=""1"">1</a></li>"
                if inicioRango > 2 then
                    htmlPag = htmlPag & "<li class=""disabled""><a href=""#"">...</a></li>"
                end if
            end if
            
            ' Rango de páginas
            for i = inicioRango to finRango
                if i = paginaActual then
                    htmlPag = htmlPag & "<li class=""active""><a href=""#"">" & i & "</a></li>"
                else
                    htmlPag = htmlPag & "<li><a href=""#"" class=""btn-pagina-log"" data-pagina=""" & i & """>" & i & "</a></li>"
                end if
            next
            
            ' Última página y elipsis
            if finRango < totalPaginas then
                if finRango < totalPaginas - 1 then
                    htmlPag = htmlPag & "<li class=""disabled""><a href=""#"">...</a></li>"
                end if
                htmlPag = htmlPag & "<li><a href=""#"" class=""btn-pagina-log"" data-pagina=""" & totalPaginas & """>" & totalPaginas & "</a></li>"
            end if
            
            ' Botón siguiente
            if paginaActual < totalPaginas then
                htmlPag = htmlPag & "<li><a href=""#"" class=""btn-pagina-log"" data-pagina=""" & (paginaActual + 1) & """>Siguiente »</a></li>"
            else
                htmlPag = htmlPag & "<li class=""disabled""><a href=""#"">Siguiente »</a></li>"
            end if
            
            htmlPag = htmlPag & "</ul></div>"
            
            ' Escapar comillas para JavaScript
            htmlPag = Replace(htmlPag, "'", "\'")
%>
<script>
$(function(){
    $('#paginacion_logs').html('<%=htmlPag%>');
});
</script>
<%
        else
            ' Si no hay más de 1 página, limpiar la paginación
%>
<script>
$(function(){
    $('#paginacion_logs').html('');
});
</script>
<%
        end if
%>
<%
    else
        ' Si no hay resultados, limpiar la paginación
%>
<script>
$(function(){
    $('#paginacion_logs').html('');
});
</script>

<div class="alert alert-warning">
    <strong>No se encontraron resultados</strong> con los filtros seleccionados.
</div>
<%
    end if

    rsLogs.Close
    set rsLogs = nothing
end if

on error goto 0
%>