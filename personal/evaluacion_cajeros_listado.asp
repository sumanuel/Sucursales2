<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "text/html"
Response.Charset = "utf-8"
On Error Resume Next

Function FormatearFechaDMY(valorFecha)
  If IsNull(valorFecha) Or Trim(CStr(valorFecha)) = "" Then
    FormatearFechaDMY = ""
  Else
    FormatearFechaDMY = Right("0" & Day(CDate(valorFecha)), 2) & "-" & Right("0" & Month(CDate(valorFecha)), 2) & "-" & Year(CDate(valorFecha))
  End If
End Function

Function FormatearFechaRegistro(valorFecha)
  If IsNull(valorFecha) Or Trim(CStr(valorFecha)) = "" Then
    FormatearFechaRegistro = ""
  Else
    FormatearFechaRegistro = Right("0" & Day(CDate(valorFecha)), 2) & "-" & Right("0" & Month(CDate(valorFecha)), 2) & "-" & Year(CDate(valorFecha)) & " " & Right("0" & Hour(CDate(valorFecha)), 2) & ":" & Right("0" & Minute(CDate(valorFecha)), 2)
  End If
End Function

Function TextoSeguro(valor)
  If IsNull(valor) Then
    TextoSeguro = ""
  Else
    TextoSeguro = Server.HTMLEncode(CStr(valor))
  End If
End Function

Function ObtenerIndiceCampo(rs, nombreCampo)
  Dim j
  ObtenerIndiceCampo = -1
  For j = 0 To rs.Fields.Count - 1
    If UCase(Trim(rs.Fields(j).Name & "")) = UCase(Trim(nombreCampo & "")) Then
      ObtenerIndiceCampo = j
      Exit Function
    End If
  Next
End Function

Function EstadoClase(valorEstado)
  Dim estado
  estado = UCase(Trim(valorEstado & ""))
  EstadoClase = "estado-evaluacion-default"
  If estado = "EN CAPACITACION" Then
    EstadoClase = "estado-evaluacion-capacitacion"
  ElseIf estado = "APROBADA" Then
    EstadoClase = "estado-evaluacion-aprobada"
  ElseIf estado = "RECHAZADA" Then
    EstadoClase = "estado-evaluacion-rechazada"
  End If
End Function

Function PermiteAccion(valorEstado)
  PermiteAccion = (UCase(Trim(valorEstado & "")) = "EN CAPACITACION")
End Function

Dim rsEva, sqlEva, datosEva
Dim paginaActual, tamanoPagina, totalRegistros, totalPaginas
Dim inicioIndice, finIndice, i
Dim idxIdEva, idxRut, idxNombre, idxSuc, idxEmp, idxFchDes, idxFchHas, idxEstado, idxUsr, idxFch
Dim idEva, estadoTexto, htmlPag, inicioRango, finRango

paginaActual = 1
If Trim(Request("page") & "") <> "" And IsNumeric(Request("page")) Then
  paginaActual = CLng(Request("page"))
End If
If paginaActual <= 0 Then paginaActual = 1

tamanoPagina = 10
sqlEva = "EXEC dbo.SP_SUC_listar_ges_eva_cajero @TOP_REGISTROS = 5000"
Set rsEva = db.Execute(sqlEva)

If Err.Number <> 0 Then
  Response.Write "<div class=""alert alert-error"">Error SQL: " & TextoSeguro(Err.Description) & "</div>"
  Response.End
End If

If rsEva.EOF Then
  Response.Write "<table class=""table table-bordered table-hover""><thead><tr style=""background-color: #f5f5f5""><th>Rut</th><th>Nombre</th><th>Sucursal</th><th>Empresa</th><th>Desde</th><th>Hasta</th><th>Estado</th><th>Usuario</th><th>Fecha Registro</th><th style=""width: 70px; text-align: center"">Acciones</th></tr></thead><tbody><tr><td colspan=""10"" style=""text-align: center"">No hay evaluaciones registradas</td></tr></tbody></table>"
  Response.End
End If

If UCase(Trim(rsEva.Fields(0).Name & "")) = "RESULTADO" Then
  Response.Write "<div class=""alert alert-error"">Error SP: " & TextoSeguro(rsEva("mensaje")) & "</div>"
  Response.End
End If

idxIdEva = ObtenerIndiceCampo(rsEva, "ID_EVA")
idxRut = ObtenerIndiceCampo(rsEva, "EVA_RUT")
idxNombre = ObtenerIndiceCampo(rsEva, "EVA_NOMBRE")
idxSuc = ObtenerIndiceCampo(rsEva, "EVA_SUC")
idxEmp = ObtenerIndiceCampo(rsEva, "EVA_EMP")
idxFchDes = ObtenerIndiceCampo(rsEva, "EVA_FCH_DES")
idxFchHas = ObtenerIndiceCampo(rsEva, "EVA_FCH_HAS")
idxEstado = ObtenerIndiceCampo(rsEva, "EVA_EST")
idxUsr = ObtenerIndiceCampo(rsEva, "EVA_USR")
idxFch = ObtenerIndiceCampo(rsEva, "EVA_FCH")

If idxIdEva < 0 Or idxRut < 0 Or idxNombre < 0 Or idxSuc < 0 Or idxEmp < 0 Or idxFchDes < 0 Or idxFchHas < 0 Or idxEstado < 0 Or idxUsr < 0 Or idxFch < 0 Then
  Response.Write "<div class=""alert alert-error"">Error: el procedimiento no devolvio las columnas esperadas para el listado.</div>"
  Response.End
End If

datosEva = rsEva.GetRows()
If Err.Number <> 0 Then
  Response.Write "<div class=""alert alert-error"">Error al leer datos del listado: " & TextoSeguro(Err.Description) & "</div>"
  Response.End
End If

If IsObject(rsEva) Then
  If rsEva.State = 1 Then rsEva.Close
  Set rsEva = Nothing
End If

totalRegistros = UBound(datosEva, 2) + 1
totalPaginas = Int(totalRegistros / tamanoPagina)
If (totalRegistros Mod tamanoPagina) > 0 Then totalPaginas = totalPaginas + 1
If totalPaginas <= 0 Then totalPaginas = 1
If paginaActual > totalPaginas Then paginaActual = totalPaginas

inicioIndice = (paginaActual - 1) * tamanoPagina
finIndice = inicioIndice + tamanoPagina - 1
If finIndice > totalRegistros - 1 Then finIndice = totalRegistros - 1

Response.Write "<style type=""text/css"">"
Response.Write ".estado-evaluacion{display:inline-block;padding:3px 8px;border-radius:4px;color:#fff;font-weight:bold;line-height:1.1;}"
Response.Write ".estado-evaluacion-capacitacion{background-color:#f0ad4e;}"
Response.Write ".estado-evaluacion-aprobada{background-color:#5cb85c;}"
Response.Write ".estado-evaluacion-rechazada{background-color:#d9534f;}"
Response.Write ".estado-evaluacion-default{background-color:#999;}"
Response.Write ".paginacion-evaluacion{text-align:center;margin-top:15px;}"
Response.Write "</style>"
Response.Write "<table class=""table table-bordered table-hover""><thead><tr style=""background-color: #f5f5f5""><th>Rut</th><th>Nombre</th><th>Sucursal</th><th>Empresa</th><th>Desde</th><th>Hasta</th><th>Estado</th><th>Usuario</th><th>Fecha Registro</th><th style=""width: 70px; text-align: center"">Acciones</th></tr></thead><tbody>"

For i = inicioIndice To finIndice
  idEva = Trim(datosEva(idxIdEva, i) & "")
  estadoTexto = Trim(datosEva(idxEstado, i) & "")

  Response.Write "<tr>"
  Response.Write "<td>" & TextoSeguro(datosEva(idxRut, i)) & "</td>"
  Response.Write "<td>" & TextoSeguro(datosEva(idxNombre, i)) & "</td>"
  Response.Write "<td>" & TextoSeguro(datosEva(idxSuc, i)) & "</td>"
  Response.Write "<td>" & TextoSeguro(datosEva(idxEmp, i)) & "</td>"
  Response.Write "<td>" & TextoSeguro(FormatearFechaDMY(datosEva(idxFchDes, i))) & "</td>"
  Response.Write "<td>" & TextoSeguro(FormatearFechaDMY(datosEva(idxFchHas, i))) & "</td>"
  Response.Write "<td><span class=""estado-evaluacion " & EstadoClase(estadoTexto) & """>" & TextoSeguro(estadoTexto) & "</span></td>"
  Response.Write "<td>" & TextoSeguro(datosEva(idxUsr, i)) & "</td>"
  Response.Write "<td>" & TextoSeguro(FormatearFechaRegistro(datosEva(idxFch, i))) & "</td>"
  Response.Write "<td style=""text-align: center; white-space: nowrap"">"
  If PermiteAccion(estadoTexto) Then
    Response.Write "<a href=""#"" class=""btnEditarEvaluacion"" data-id=""" & TextoSeguro(idEva) & """ title=""Editar fechas"" style=""margin-right: 8px""><i class=""icon-edit icon-large""></i></a>"
    Response.Write "<a href=""#"" class=""btnEliminarEvaluacion"" data-id=""" & TextoSeguro(idEva) & """ title=""Eliminar""><i class=""icon-trash icon-large""></i></a>"
  Else
    Response.Write "<span style=""color: #999"">-</span>"
  End If
  Response.Write "</td>"
  Response.Write "</tr>"
Next

Response.Write "</tbody></table>"

If totalPaginas > 1 Then
  inicioRango = paginaActual - 2
  finRango = paginaActual + 2
  If inicioRango < 1 Then inicioRango = 1
  If finRango > totalPaginas Then finRango = totalPaginas

  htmlPag = "<div class=""pagination paginacion-evaluacion""><ul>"
  If paginaActual > 1 Then
    htmlPag = htmlPag & "<li><a href=""#"" class=""btn-pagina-evaluacion"" data-pagina=""" & (paginaActual - 1) & """>« Anterior</a></li>"
  Else
    htmlPag = htmlPag & "<li class=""disabled""><a href=""#"">« Anterior</a></li>"
  End If

  If inicioRango > 1 Then
    htmlPag = htmlPag & "<li><a href=""#"" class=""btn-pagina-evaluacion"" data-pagina=""1"">1</a></li>"
    If inicioRango > 2 Then
      htmlPag = htmlPag & "<li class=""disabled""><a href=""#"">...</a></li>"
    End If
  End If

  For i = inicioRango To finRango
    If i = paginaActual Then
      htmlPag = htmlPag & "<li class=""active""><a href=""#"">" & i & "</a></li>"
    Else
      htmlPag = htmlPag & "<li><a href=""#"" class=""btn-pagina-evaluacion"" data-pagina=""" & i & """>" & i & "</a></li>"
    End If
  Next

  If finRango < totalPaginas Then
    If finRango < totalPaginas - 1 Then
      htmlPag = htmlPag & "<li class=""disabled""><a href=""#"">...</a></li>"
    End If
    htmlPag = htmlPag & "<li><a href=""#"" class=""btn-pagina-evaluacion"" data-pagina=""" & totalPaginas & """>" & totalPaginas & "</a></li>"
  End If

  If paginaActual < totalPaginas Then
    htmlPag = htmlPag & "<li><a href=""#"" class=""btn-pagina-evaluacion"" data-pagina=""" & (paginaActual + 1) & """>Siguiente »</a></li>"
  Else
    htmlPag = htmlPag & "<li class=""disabled""><a href=""#"">Siguiente »</a></li>"
  End If

  htmlPag = htmlPag & "</ul></div>"
  Response.Write htmlPag
End If
%>