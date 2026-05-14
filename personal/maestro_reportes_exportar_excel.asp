<!--#include file="../conexion/conexion.asp"-->
<%
Response.Expires = -1
Response.CodePage = 65001
Response.ContentType = "application/vnd.ms-excel"
Response.Charset = "utf-8"
Response.AddHeader "Content-Disposition", "attachment; filename=maestro_reportes_evaluacion_" & Right("0" & Day(Date()), 2) & "-" & Right("0" & Month(Date()), 2) & "-" & Year(Date()) & ".xls"

Function XmlSafe(valor)
  If IsNull(valor) Then valor = ""
  valor = CStr(valor)
  valor = Replace(valor, "&", "&amp;")
  valor = Replace(valor, "<", "&lt;")
  valor = Replace(valor, ">", "&gt;")
  valor = Replace(valor, Chr(34), "&quot;")
  valor = Replace(valor, Chr(39), "&apos;")
  XmlSafe = valor
End Function

Function FechaSqlMr(valor)
  If Trim(valor & "") = "" Or Not IsDate(valor) Then
    FechaSqlMr = ""
  Else
    FechaSqlMr = Year(CDate(valor)) & "-" & Right("0" & Month(CDate(valor)), 2) & "-" & Right("0" & Day(CDate(valor)), 2)
  End If
End Function

Function FechaTextoMr(valorFecha)
  If IsNull(valorFecha) Or Trim(CStr(valorFecha)) = "" Then
    FechaTextoMr = ""
  Else
    FechaTextoMr = Right("0" & Day(CDate(valorFecha)), 2) & "-" & Right("0" & Month(CDate(valorFecha)), 2) & "-" & Year(CDate(valorFecha))
  End If
End Function

Function RespuestaTextoMr(valor)
  If IsNull(valor) Or Trim(CStr(valor)) = "" Then
    RespuestaTextoMr = ""
  ElseIf CLng(valor) = 1 Then
    RespuestaTextoMr = "Si"
  ElseIf CLng(valor) = 0 Then
    RespuestaTextoMr = "No"
  ElseIf CLng(valor) = 2 Then
    RespuestaTextoMr = "N/A"
  Else
    RespuestaTextoMr = CStr(valor)
  End If
End Function

Sub EscribirCelda(texto, estilo)
  If Trim(estilo & "") <> "" Then
    Response.Write "<Cell ss:StyleID=""" & estilo & """><Data ss:Type=""String"">" & XmlSafe(texto) & "</Data></Cell>"
  Else
    Response.Write "<Cell><Data ss:Type=""String"">" & XmlSafe(texto) & "</Data></Cell>"
  End If
End Sub

Dim filtroDesde, filtroHasta
Dim rsPreguntas, rsDatos, rsRespuestas
Dim sqlPreguntas, sqlDatos, sqlRespuestas
Dim preguntas, datos, respuestas
Dim totalDatos, totalPreguntas
Dim i, j, idsEva, llave
Dim dicRespuestas

filtroDesde = FechaSqlMr(Request("fch_desde"))
filtroHasta = FechaSqlMr(Request("fch_hasta"))

If filtroDesde = "" Then filtroDesde = FechaSqlMr(DateAdd("m", -3, Date()))
If filtroHasta = "" Then filtroHasta = FechaSqlMr(Date())

sqlPreguntas = "SELECT PRE_ID_PRE, PRE_TIT, PRE_PRE, PRE_ORD FROM dbo.SUC_CAP_PRE WHERE ISNULL(PRE_EST, 0) = 1 ORDER BY PRE_ORD, PRE_ID_PRE"
Set rsPreguntas = db.Execute(sqlPreguntas)

If Not rsPreguntas.EOF Then
  preguntas = rsPreguntas.GetRows()
End If
If rsPreguntas.State = 1 Then rsPreguntas.Close
Set rsPreguntas = Nothing

sqlDatos = "EXEC dbo.SP_SUC_listar_mae_rep_eva_cajero @TOP_REGISTROS = 1000000, @FCH_DESDE = '" & filtroDesde & "', @FCH_HASTA = '" & filtroHasta & "'"
Set rsDatos = db.Execute(sqlDatos)

If Not rsDatos.EOF Then
  If UCase(Trim(rsDatos.Fields(0).Name & "")) = "RESULTADO" Then
    Response.Write "Error al exportar: " & rsDatos("mensaje")
    Response.End
  End If
  datos = rsDatos.GetRows()
End If
If rsDatos.State = 1 Then rsDatos.Close
Set rsDatos = Nothing

Set dicRespuestas = Server.CreateObject("Scripting.Dictionary")

If IsArray(datos) Then
  totalDatos = UBound(datos, 2)
  idsEva = ""
  For i = 0 To totalDatos
    If idsEva <> "" Then idsEva = idsEva & ","
    idsEva = idsEva & CLng(datos(0, i))
  Next

  If idsEva <> "" Then
    sqlRespuestas = "SELECT ID_EVA, PRE_ID_PRE, RES_RES FROM dbo.SUC_CAP_RES WHERE ID_EVA IN (" & idsEva & ")"
    Set rsRespuestas = db.Execute(sqlRespuestas)
    If Not rsRespuestas.EOF Then
      respuestas = rsRespuestas.GetRows()
      For i = 0 To UBound(respuestas, 2)
        llave = CStr(respuestas(0, i)) & "_" & CStr(respuestas(1, i))
        dicRespuestas(llave) = RespuestaTextoMr(respuestas(2, i))
      Next
    End If
    If rsRespuestas.State = 1 Then rsRespuestas.Close
    Set rsRespuestas = Nothing
  End If
Else
  totalDatos = -1
End If

If IsArray(preguntas) Then
  totalPreguntas = UBound(preguntas, 2)
Else
  totalPreguntas = -1
End If
%><?xml version="1.0" encoding="UTF-8"?>
<?mso-application progid="Excel.Sheet"?>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
  <Styles>
    <Style ss:ID="Header">
      <Font ss:Bold="1" />
      <Interior ss:Color="#D9EAF7" ss:Pattern="Solid" />
    </Style>
  </Styles>
  <Worksheet ss:Name="Evaluaciones">
    <Table>
      <Row>
        <% Call EscribirCelda("Nombre cajero", "Header") %>
        <% Call EscribirCelda("Rut cajero", "Header") %>
        <% Call EscribirCelda("Proveedor", "Header") %>
        <% Call EscribirCelda("Sucursal", "Header") %>
        <%
        If totalPreguntas >= 0 Then
          For j = 0 To totalPreguntas
            Call EscribirCelda("item-" & (j + 1), "Header")
          Next
        End If
        Call EscribirCelda("Puntuacion Total", "Header")
        Call EscribirCelda("Estado", "Header")
        Call EscribirCelda("Comentario", "Header")
        Call EscribirCelda("Comentario Central", "Header")
        Call EscribirCelda("Fecha Evaluacion", "Header")
        Call EscribirCelda("Fecha Envio Capacitacion", "Header")
        %>
      </Row>
      <%
      If totalDatos >= 0 Then
        For i = 0 To totalDatos
      %>
      <Row>
        <% Call EscribirCelda(datos(2, i), "") %>
        <% Call EscribirCelda(datos(1, i), "") %>
        <% Call EscribirCelda(datos(3, i), "") %>
        <% Call EscribirCelda(datos(4, i), "") %>
        <%
        If totalPreguntas >= 0 Then
          For j = 0 To totalPreguntas
            llave = CStr(datos(0, i)) & "_" & CStr(preguntas(0, j))
            If dicRespuestas.Exists(llave) Then
              Call EscribirCelda(dicRespuestas(llave), "")
            Else
              Call EscribirCelda("", "")
            End If
          Next
        End If
        Call EscribirCelda(datos(11, i), "")
        Call EscribirCelda(datos(10, i), "")
        Call EscribirCelda(datos(7, i), "")
        Call EscribirCelda(datos(8, i), "")
        Call EscribirCelda(FechaTextoMr(datos(6, i)), "")
        Call EscribirCelda(FechaTextoMr(datos(5, i)), "")
        %>
      </Row>
      <%
        Next
      End If
      %>
    </Table>
  </Worksheet>
  <Worksheet ss:Name="Preguntas">
    <Table>
      <Row>
        <% Call EscribirCelda("Item", "Header") %>
        <% Call EscribirCelda("Orden", "Header") %>
        <% Call EscribirCelda("Titulo", "Header") %>
        <% Call EscribirCelda("Descripcion", "Header") %>
      </Row>
      <%
      If totalPreguntas >= 0 Then
        For j = 0 To totalPreguntas
      %>
      <Row>
        <% Call EscribirCelda("item-" & (j + 1), "") %>
        <% Call EscribirCelda(preguntas(3, j), "") %>
        <% Call EscribirCelda(preguntas(1, j), "") %>
        <% Call EscribirCelda(preguntas(2, j), "") %>
      </Row>
      <%
        Next
      End If
      %>
    </Table>
  </Worksheet>
</Workbook>