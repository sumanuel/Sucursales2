<!--#include file="../conexion/conexion.asp"-->
<% Function FormatearFechaDMY(valorFecha) If IsNull(valorFecha) Or
Trim(CStr(valorFecha)) = "" Then FormatearFechaDMY = "" Else FormatearFechaDMY =
Right("0" & Day(CDate(valorFecha)), 2) & "/" & Right("0" &
Month(CDate(valorFecha)), 2) & "/" & Year(CDate(valorFecha)) End If End Function
Function TextoSeguro(valor) If IsNull(valor) Then TextoSeguro = "" Else
TextoSeguro = Server.HTMLEncode(CStr(valor)) End If End Function %>
<style type="text/css">
  .estado-evaluacion {
    display: inline-block;
    padding: 3px 8px;
    border-radius: 4px;
    color: #fff;
    font-weight: bold;
    line-height: 1.1;
  }

  .estado-evaluacion-capacitacion {
    background-color: #f0ad4e;
  }

  .estado-evaluacion-aprobada {
    background-color: #5cb85c;
  }

  .estado-evaluacion-rechazada {
    background-color: #d9534f;
  }

  .estado-evaluacion-default {
    background-color: #999;
  }
</style>
<table class="table table-bordered table-hover">
  <thead>
    <tr style="background-color: #f5f5f5">
      <th>Rut</th>
      <th>Nombre</th>
      <th>Sucursal</th>
      <th>Empresa</th>
      <th>Desde</th>
      <th>Hasta</th>
      <th>Comentario</th>
      <th>Estado</th>
      <th>Usuario</th>
      <th>Fecha Registro</th>
      <th style="width: 70px; text-align: center">Acciones</th>
    </tr>
  </thead>
  <tbody>
    <% On Error Resume Next Dim rsEva Dim sqlEva Dim estadoTexto Dim idEva Dim
    esActivo Dim estadoValor Dim estadoClase sqlEva = "EXEC
    dbo.SP_SUC_listar_eva_cajero @TOP_REGISTROS = 100" Set rsEva =
    db.Execute(sqlEva) If Err.Number <> 0 Then %>
    <tr>
      <td colspan="11" style="color: red; text-align: center">
        Error SQL: <%=TextoSeguro(Err.Description)%>
      </td>
    </tr>
    <% ElseIf Not rsEva.EOF Then Do Until rsEva.EOF estadoValor =
    UCase(Trim(rsEva("EVA_EST") & "")) estadoTexto = Trim(rsEva("EVA_EST") & "")
    esActivo = False idEva = Trim(rsEva("ID_EVA") & "") estadoClase =
    "estado-evaluacion-default" If estadoTexto = "" Then estadoTexto = "SIN
    ESTADO" End If If estadoValor = "EN CAPACITACION" Then esActivo = True
    estadoClase = "estado-evaluacion-capacitacion" ElseIf estadoValor =
    "APROBADA" Then estadoClase = "estado-evaluacion-aprobada" ElseIf
    estadoValor = "RECHAZADA" Then estadoClase = "estado-evaluacion-rechazada"
    End If %>
    <tr>
      <td><%=TextoSeguro(rsEva("EVA_RUT"))%></td>
      <td><%=TextoSeguro(rsEva("EVA_NOMBRE"))%></td>
      <td><%=TextoSeguro(rsEva("EVA_SUC"))%></td>
      <td><%=TextoSeguro(rsEva("EVA_EMP"))%></td>
      <td><%=FormatearFechaDMY(rsEva("EVA_FCH_DES"))%></td>
      <td><%=FormatearFechaDMY(rsEva("EVA_FCH_HAS"))%></td>
      <td><%=TextoSeguro(rsEva("EVA_COM"))%></td>
      <td>
        <span class="estado-evaluacion <%=estadoClase%>"
          ><%=TextoSeguro(estadoTexto)%></span
        >
      </td>
      <td><%=TextoSeguro(rsEva("EVA_USR"))%></td>
      <td><%=TextoSeguro(rsEva("EVA_FCH"))%></td>
      <td style="text-align: center; white-space: nowrap">
        <% If esActivo Then %>
        <a
          href="#"
          class="btnEditarEvaluacion"
          data-id="<%=idEva%>"
          title="Editar fechas"
          style="margin-right: 8px"
        >
          <i class="icon-edit icon-large"></i>
        </a>
        <a
          href="#"
          class="btnEliminarEvaluacion"
          data-id="<%=idEva%>"
          title="Eliminar"
        >
          <i class="icon-trash icon-large"></i>
        </a>
        <% Else %>
        <span style="color: #999">-</span>
        <% End If %>
      </td>
    </tr>
    <% rsEva.MoveNext Loop Else %>
    <tr>
      <td colspan="11" style="text-align: center">
        No hay evaluaciones registradas
      </td>
    </tr>
    <% End If If IsObject(rsEva) Then If rsEva.State = 1 Then rsEva.Close End If
    Set rsEva = Nothing End If On Error GoTo 0 %>
  </tbody>
</table>
