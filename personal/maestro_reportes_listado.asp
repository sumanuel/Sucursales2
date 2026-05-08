<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "text/html"
Response.Charset = "utf-8"
On Error Resume Next

Function MrTextoSeguro(valor)
  If IsNull(valor) Then
    MrTextoSeguro = ""
  Else
    MrTextoSeguro = Server.HTMLEncode(CStr(valor))
  End If
End Function

Function MrFechaDMY(valorFecha)
  If IsNull(valorFecha) Or Trim(CStr(valorFecha)) = "" Then
    MrFechaDMY = ""
  Else
    MrFechaDMY = Right("0" & Day(CDate(valorFecha)), 2) & "-" & Right("0" & Month(CDate(valorFecha)), 2) & "-" & Year(CDate(valorFecha))
  End If
End Function

Function MrEstadoClase(estadoTexto)
  estadoTexto = UCase(Trim(estadoTexto & ""))
  MrEstadoClase = "estado-maestro-default"
  If estadoTexto = "EN CAPACITACION" Then
    MrEstadoClase = "estado-maestro-capacitacion"
  ElseIf estadoTexto = "APROBADA" Then
    MrEstadoClase = "estado-maestro-aprobada"
  ElseIf estadoTexto = "RECHAZADA" Then
    MrEstadoClase = "estado-maestro-rechazada"
  End If
End Function

Function MrFechaSql(valor)
  If Trim(valor & "") = "" Or Not IsDate(valor) Then
    MrFechaSql = ""
  Else
    MrFechaSql = Year(CDate(valor)) & "-" & Right("0" & Month(CDate(valor)), 2) & "-" & Right("0" & Day(CDate(valor)), 2)
  End If
End Function

Dim rsDatos, sqlDatos, datos
Dim paginaActual, tamanoPagina, totalRegistros, totalPaginas
Dim inicioIndice, finIndice, i
Dim filtroDesde, filtroHasta, etiquetaFiltro

paginaActual = 1
If Trim(Request("page") & "") <> "" And IsNumeric(Request("page")) Then
  paginaActual = CLng(Request("page"))
End If
If paginaActual <= 0 Then paginaActual = 1

filtroDesde = MrFechaSql(Request("fch_desde"))
filtroHasta = MrFechaSql(Request("fch_hasta"))

If filtroDesde = "" Then filtroDesde = MrFechaSql(DateAdd("m", -3, Date()))
If filtroHasta = "" Then filtroHasta = MrFechaSql(Date())

tamanoPagina = 15
sqlDatos = "EXEC dbo.SP_SUC_listar_mae_rep_eva_cajero @TOP_REGISTROS = 5000, @FCH_DESDE = '" & filtroDesde & "', @FCH_HASTA = '" & filtroHasta & "'"
Set rsDatos = db.Execute(sqlDatos)

If Err.Number <> 0 Then
  Response.Write "<div class=""alert alert-error"">Error SQL: " & MrTextoSeguro(Err.Description) & "</div>"
  Response.End
End If

If rsDatos.EOF Then
  Response.Write "<div class=""alert alert-info""><strong>Filtro aplicado:</strong> Desde " & MrTextoSeguro(MrFechaDMY(filtroDesde)) & " | Hasta " & MrTextoSeguro(MrFechaDMY(filtroHasta)) & "</div>"
  Response.Write "<table class=""table table-bordered table-hover""><thead><tr style=""background-color:#f5f5f5""><th>Rut cajero</th><th>Nombre cajero</th><th>Proveedor</th><th>Fecha Envio Capacitacion</th><th>Fecha Evaluacion</th><th>Estado</th><th>Puntaje Evaluacion</th><th>Comentario</th><th style=""width:60px;text-align:center;"">Accion</th></tr></thead><tbody><tr><td colspan=""9"" style=""text-align:center;"">No hay cajeros cargados para el rango seleccionado.</td></tr></tbody></table>"
  Response.End
End If

If UCase(Trim(rsDatos.Fields(0).Name & "")) = "RESULTADO" Then
  Response.Write "<div class=""alert alert-error"">Error SP: " & MrTextoSeguro(rsDatos("mensaje")) & "</div>"
  Response.End
End If

datos = rsDatos.GetRows()
If rsDatos.State = 1 Then rsDatos.Close
Set rsDatos = Nothing

totalRegistros = UBound(datos, 2) + 1
totalPaginas = Int(totalRegistros / tamanoPagina)
If (totalRegistros Mod tamanoPagina) > 0 Then totalPaginas = totalPaginas + 1
If totalPaginas <= 0 Then totalPaginas = 1
If paginaActual > totalPaginas Then paginaActual = totalPaginas

inicioIndice = (paginaActual - 1) * tamanoPagina
finIndice = inicioIndice + tamanoPagina - 1
If finIndice > totalRegistros - 1 Then finIndice = totalRegistros - 1

Response.Write "<style type=""text/css"">"
Response.Write ".estado-maestro{display:inline-block;padding:3px 8px;border-radius:4px;color:#fff;font-weight:bold;line-height:1.1;}"
Response.Write ".estado-maestro-capacitacion{background-color:#f0ad4e;}"
Response.Write ".estado-maestro-aprobada{background-color:#5cb85c;}"
Response.Write ".estado-maestro-rechazada{background-color:#d9534f;}"
Response.Write ".estado-maestro-default{background-color:#999;}"
Response.Write ".paginacion-maestro-reportes{text-align:center;margin-top:15px;}"
Response.Write "</style>"
Response.Write "<div class=""alert alert-info"" style=""margin-bottom:12px""><strong>Filtro aplicado:</strong> Desde " & MrTextoSeguro(MrFechaDMY(filtroDesde)) & " | Hasta " & MrTextoSeguro(MrFechaDMY(filtroHasta)) & "</div>"
Response.Write "<table class=""table table-bordered table-hover table-striped""><thead><tr style=""background-color:#f5f5f5""><th>Rut cajero</th><th>Nombre cajero</th><th>Proveedor</th><th>Fecha Envio Capacitacion</th><th>Fecha Evaluacion</th><th>Estado</th><th>Puntaje Evaluacion</th><th>Comentario</th><th style=""width:60px;text-align:center;"">Accion</th></tr></thead><tbody>"

For i = inicioIndice To finIndice
  Response.Write "<tr>"
  Response.Write "<td>" & MrTextoSeguro(datos(1, i)) & "</td>"
  Response.Write "<td>" & MrTextoSeguro(datos(2, i)) & "</td>"
  Response.Write "<td>" & MrTextoSeguro(datos(3, i)) & "</td>"
  Response.Write "<td>" & MrTextoSeguro(MrFechaDMY(datos(5, i))) & "</td>"
  Response.Write "<td>" & MrTextoSeguro(MrFechaDMY(datos(6, i))) & "</td>"
  Response.Write "<td><span class=""estado-maestro " & MrEstadoClase(datos(10, i)) & """>" & MrTextoSeguro(datos(10, i)) & "</span></td>"
  Response.Write "<td>" & MrTextoSeguro(datos(11, i)) & "</td>"
  Response.Write "<td>" & MrTextoSeguro(datos(7, i)) & "</td>"
  Response.Write "<td style=""text-align:center;white-space:nowrap;"">"
  If CLng(datos(9, i)) > 1 Then
    Response.Write "<a href=""#"" class=""btnEditarResultadoCentral"" data-id=""" & MrTextoSeguro(datos(0, i)) & """ title=""Editar resultado areas centrales""><i class=""icon-edit icon-large""></i></a>"
  Else
    Response.Write "<span style=""color:#999;"">-</span>"
  End If
  Response.Write "</td>"
  Response.Write "</tr>"
Next

Response.Write "</tbody></table>"

If totalPaginas > 1 Then
  Dim inicioRango, finRango, htmlPag
  inicioRango = paginaActual - 2
  finRango = paginaActual + 2
  If inicioRango < 1 Then inicioRango = 1
  If finRango > totalPaginas Then finRango = totalPaginas

  htmlPag = "<div class=""pagination paginacion-maestro-reportes""><ul>"
  If paginaActual > 1 Then
    htmlPag = htmlPag & "<li><a href=""#"" class=""btn-pagina-maestro-reportes"" data-pagina=""" & (paginaActual - 1) & """>« Anterior</a></li>"
  Else
    htmlPag = htmlPag & "<li class=""disabled""><a href=""#"">« Anterior</a></li>"
  End If

  For i = inicioRango To finRango
    If i = paginaActual Then
      htmlPag = htmlPag & "<li class=""active""><a href=""#"">" & i & "</a></li>"
    Else
      htmlPag = htmlPag & "<li><a href=""#"" class=""btn-pagina-maestro-reportes"" data-pagina=""" & i & """>" & i & "</a></li>"
    End If
  Next

  If paginaActual < totalPaginas Then
    htmlPag = htmlPag & "<li><a href=""#"" class=""btn-pagina-maestro-reportes"" data-pagina=""" & (paginaActual + 1) & """>Siguiente »</a></li>"
  Else
    htmlPag = htmlPag & "<li class=""disabled""><a href=""#"">Siguiente »</a></li>"
  End If
  htmlPag = htmlPag & "</ul></div>"
  Response.Write htmlPag
End If
%>