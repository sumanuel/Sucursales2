<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json; charset=utf-8"
Response.CharSet = "utf-8"

on error resume next

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

dim rsFiltros
set rsFiltros = DB.execute("EXEC dbo.SCSS_obtener_filtros_log")

dim funcionalidades, tiposAccion, perfiles
funcionalidades = "["
tiposAccion = "["
perfiles = "["

if not rsFiltros.EOF then
dim primerFuncionalidad
primerFuncionalidad = true

do while not rsFiltros.EOF
if not primerFuncionalidad then
funcionalidades = funcionalidades & ","
end if
funcionalidades = funcionalidades & """" & corregirTexto(Replace(Replace(rsFiltros("funcionalidad"), """", "\"""), "\", "\\")) & """"
primerFuncionalidad = false
rsFiltros.MoveNext
loop
end if
funcionalidades = funcionalidades & "]"

set rsFiltros = rsFiltros.NextRecordset
if not rsFiltros.EOF then
dim primerTipo
primerTipo = true

do while not rsFiltros.EOF
if not primerTipo then
tiposAccion = tiposAccion & ","
end if
tiposAccion = tiposAccion & """" & corregirTexto(Replace(Replace(rsFiltros("tipo_accion"), """", "\"""), "\", "\\")) & """"
primerTipo = false
rsFiltros.MoveNext
loop
end if
tiposAccion = tiposAccion & "]"

set rsFiltros = rsFiltros.NextRecordset
if not rsFiltros.EOF then
dim primerPerfil
primerPerfil = true

do while not rsFiltros.EOF
if not primerPerfil then
perfiles = perfiles & ","
end if
perfiles = perfiles & """" & corregirTexto(Replace(Replace(rsFiltros("perfil"), """", "\"""), "\", "\\")) & """"
primerPerfil = false
rsFiltros.MoveNext
loop
end if
perfiles = perfiles & "]"

rsFiltros.Close
set rsFiltros = nothing

dim jsonResponse
jsonResponse = "{"
jsonResponse = jsonResponse & """funcionalidades"":" & funcionalidades & ","
jsonResponse = jsonResponse & """tipos_accion"":" & tiposAccion & ","
jsonResponse = jsonResponse & """perfiles"":" & perfiles
jsonResponse = jsonResponse & "}"

Response.Write(jsonResponse)

on error goto 0
%>