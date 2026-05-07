<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "text/html"
Response.CodePage = 65001
Response.CharSet = "utf-8"

Function TextoSeguro(valor)
  If IsNull(valor) Then
    TextoSeguro = ""
  Else
    TextoSeguro = Server.HTMLEncode(CStr(valor))
  End If
End Function

Function FormatearFechaDMY(valorFecha)
  If IsNull(valorFecha) Or Trim(CStr(valorFecha)) = "" Then
    FormatearFechaDMY = ""
  Else
    FormatearFechaDMY = Right("0" & Day(CDate(valorFecha)), 2) & "/" & Right("0" & Month(CDate(valorFecha)), 2) & "/" & Year(CDate(valorFecha))
  End If
End Function

Function EstadoClase(valorEstado)
  Dim estadoTexto
  estadoTexto = UCase(Trim(valorEstado & ""))
  EstadoClase = "label"
  If estadoTexto = "EN CAPACITACION" Then
    EstadoClase = "label label-warning"
  ElseIf estadoTexto = "APROBADA" Then
    EstadoClase = "label label-success"
  ElseIf estadoTexto = "RECHAZADA" Then
    EstadoClase = "label label-important"
  Else
    EstadoClase = "label"
  End If
End Function

Dim idSucursal, sqlSucursal, rsSucursal, nombreSucursal
Dim sqlEva, rsEva, sqlPreguntas, rsPreguntas
Dim tieneEvaluaciones, tienePreguntas, primeraColumnaEva, primeraColumnaPre

idSucursal = Trim(Request("idSucursalMain") & "")
nombreSucursal = ""

If idSucursal = "" Or Not IsNumeric(idSucursal) Or CLng(idSucursal) <= 0 Then
%>
<div class="row-fluid">
  <span class="span12 alert alert-danger">
    <strong><h4><i class="icon-warning-sign"></i> Seleccione una sucursal para consultar las evaluaciones.</h4></strong>
  </span>
</div>
<%
  Response.End
End If

sqlSucursal = "SELECT suc_nombre FROM dbo.SUC_sucursal WHERE id_sucursal = " & CLng(idSucursal)
Set rsSucursal = DB.Execute(sqlSucursal)
If Not rsSucursal.EOF Then
  nombreSucursal = rsSucursal("suc_nombre") & ""
End If
If rsSucursal.State = 1 Then rsSucursal.Close
Set rsSucursal = Nothing

sqlEva = "EXEC dbo.SP_SUC_listar_eva_cajero @ID_SUCURSAL = " & CLng(idSucursal) & ", @TOP_REGISTROS = 200, @VALIDAR_FECHA_DESDE = 1"
Set rsEva = DB.Execute(sqlEva)

tieneEvaluaciones = False
primeraColumnaEva = ""
If Not rsEva.EOF Then
  primeraColumnaEva = UCase(Trim(rsEva.Fields(0).Name & ""))
  If primeraColumnaEva <> "RESULTADO" Then
    tieneEvaluaciones = True
  End If
End If

sqlPreguntas = "EXEC dbo.SP_SUC_obtener_pre_eva_cajero"
Set rsPreguntas = DB.Execute(sqlPreguntas)

tienePreguntas = False
primeraColumnaPre = ""
If Not rsPreguntas.EOF Then
  primeraColumnaPre = UCase(Trim(rsPreguntas.Fields(0).Name & ""))
  If primeraColumnaPre <> "RESULTADO" Then
    tienePreguntas = True
  End If
End If
%>
<div class="row-fluid">
  <div class="row-fluid">
    <span class="span12 alert alert-success">
      <strong>
        <h4>
          <i class="icon-check-sign"></i>
          Evaluacion Cajeros
        </h4>
      </strong>
      <div>Sucursal actual: <strong><%=TextoSeguro(nombreSucursal)%></strong></div>
      <div>Se muestran solo los cajeros de esta sucursal cuya fecha desde ya se cumplio.</div>
    </span>
  </div>

  <div class="row-fluid">
    <div class="span8">
      <div class="well">
        <h4 style="margin-top:0;">Cajeros pendientes o disponibles para evaluacion</h4>
        <%
        If primeraColumnaEva = "RESULTADO" Then
        %>
          <div class="alert alert-error"><strong>Error:</strong> <%=TextoSeguro(rsEva("mensaje"))%></div>
        <%
        ElseIf Not tieneEvaluaciones Then
        %>
          <div class="alert alert-info">No hay cajeros disponibles para evaluacion en esta sucursal.</div>
        <%
        Else
        %>
          <table class="table table-bordered table-striped table-hover">
            <thead>
              <tr>
                <th>Rut</th>
                <th>Nombre</th>
                <th>Empresa</th>
                <th>Desde</th>
                <th>Hasta</th>
                <th>Estado</th>
              </tr>
            </thead>
            <tbody>
              <%
              Do While Not rsEva.EOF
              %>
              <tr>
                <td><%=TextoSeguro(rsEva("EVA_RUT"))%></td>
                <td><%=TextoSeguro(rsEva("EVA_NOMBRE"))%></td>
                <td><%=TextoSeguro(rsEva("EVA_EMP"))%></td>
                <td><%=TextoSeguro(FormatearFechaDMY(rsEva("EVA_FCH_DES")))%></td>
                <td><%=TextoSeguro(FormatearFechaDMY(rsEva("EVA_FCH_HAS")))%></td>
                <td><span class="<%=EstadoClase(rsEva("EVA_EST"))%>"><%=TextoSeguro(rsEva("EVA_EST"))%></span></td>
              </tr>
              <%
                rsEva.MoveNext
              Loop
              %>
            </tbody>
          </table>
        <%
        End If
        %>
      </div>
    </div>

    <div class="span4">
      <div class="well">
        <h4 style="margin-top:0;">Preguntas activas</h4>
        <%
        If primeraColumnaPre = "RESULTADO" Then
        %>
          <div class="alert alert-error"><strong>Error:</strong> <%=TextoSeguro(rsPreguntas("mensaje"))%></div>
        <%
        ElseIf Not tienePreguntas Then
        %>
          <div class="alert alert-info">No hay preguntas activas configuradas.</div>
        <%
        Else
        %>
          <ol style="margin: 0 0 0 18px;">
            <%
            Do While Not rsPreguntas.EOF
            %>
              <li style="margin-bottom: 10px;">
                <strong><%=TextoSeguro(rsPreguntas("PRE_TIT"))%></strong><br />
                <span><%=TextoSeguro(rsPreguntas("PRE_PRE"))%></span>
              </li>
            <%
              rsPreguntas.MoveNext
            Loop
            %>
          </ol>
        <%
        End If
        %>
      </div>
    </div>
  </div>
</div>
<%
If IsObject(rsEva) Then
  If rsEva.State = 1 Then rsEva.Close
  Set rsEva = Nothing
End If

If IsObject(rsPreguntas) Then
  If rsPreguntas.State = 1 Then rsPreguntas.Close
  Set rsPreguntas = Nothing
End If
%>