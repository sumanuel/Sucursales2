<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuario"))
idPerfil = trim(request("idPerfil"))
'//////////////// total de cajeros titulares'
horaActual = Time()
minutosHoraActual=hour(horaActual)*60
minutosHoraActual = minutosHoraActual + minute(horaActual)
if minutosHoraActual >= 480 then
 
  sql2 = ""  
  if idPerfil = "2" then
    sql2 = sql2 & " and id_sucursal in (select id_sucursal from SUC_usuario_sucursal where id_usuario = '"&idUsuario&"') "
  end if
  if idPerfil = "55" then
    sql2 = sql2 & " and id_sucursal in (select id_sucursal from SUC_zonales_comercial_sucursal where id_zonal = '"&idUsuario&"') "
  end if
  if idPerfil = "66" then
    sql2 = sql2 & " and id_sucursal in (select id_sucursal from SUC_zonales_comercial_mas_sucursal where id_zonal = '"&idUsuario&"') "
  end if
 
  sql = ""
  sql = sql & "select "
  sql = sql & "(select COUNT(*) from SUC_sucursal_asistencia_personal where tipo_personal = 'Cajero' and tipo = 'titular' "&sql2&") as cajerostitulares, "
  sql = sql & "(select COUNT(*) from SUC_sucursal_asistencia_personal where tipo_personal = 'Cajero' and tipo = 'reemplazo' "&sql2&") as cajerosreemplazos, "
  sql = sql & "(select COUNT(*) from SUC_sucursal_asistencia_personal where tipo_personal = 'CAJERO ADICIONAL' "&sql2&") as cajerosadicionales, "
  sql = sql & "(select COUNT(*) from SUC_sucursal_asistencia_personal where tipo_personal in ('Cajero','CAJERO ADICIONAL') and asistencia = 'si' "&sql2&") as cajerospresentes, "
  sql = sql & "(select COUNT(*) from SUC_sucursal_asistencia_personal where tipo_personal in ('Cajero','CAJERO ADICIONAL') and asistencia = 'no' "&sql2&") as cajerosausentes, "
  sql = sql & "(select COUNT(*) from SUC_sucursal_asistencia_personal where tipo_personal in ('Cajero','CAJERO ADICIONAL') and asistencia is null "&sql2&") as cajerossinregistro "
 
  set rs = db.execute(sql)
  if not rs.eof then
	  totalCajerosTitulares = rs("cajerostitulares")
	  totalCajerosReemplazos = rs("cajerosreemplazos")
	  totalCajerosAdicionales = rs("cajerosadicionales")
	  totalAusentes = rs("cajerosausentes")
	  totalPresentes = rs("cajerospresentes")
	  totalSinRegistro = rs("cajerossinregistro")
  end if 
  
%>
  <table class="table table-bordered table-hover table-condensed">
      <tr>
          <td colspan="3"> <span class="centrado"> <strong>Cajeros</strong>
              <span id="porcentajeIndicadorRegistrados" class="badge"> 
                  <%=totalPresentes+totalAusentes+totalSinRegistro%>
              </span>
          </td>
      </tr>
  <tr>
    <td>      
      <span id="textoIndicadorZonalTitulares">Titulares </span>
      <span id="porcentajeIndicadorZonalTitulares" class="badge pull-right"><%=totalCajerosTitulares%></span>
    </td>
    <td>
      <span id="textoIndicadorZonalReemplazo">Reemplazo </span>
      <span id="porcentajeIndicadorZonalReemplazo" class="badge pull-right"><%=totalCajerosReemplazos%></span>
    </td>
    <td>
      <span id="textoIndicadorZonalPresentes">Adicionales </span>
      <span id="porcentajeIndicadorPresentes" class="badge pull-right"><%=totalCajerosAdicionales%></span>
    </td>
  </tr>
  <tr>        
    <td>
      <span id="textoIndicadorZonalPresentes">Sin Registro </span>
      <span id="porcentajeIndicadorPresentes" class="badge badge-important pull-right"><%=totalSinRegistro%></span>
    </td>
    <td>
      <span id="textoIndicadorZonalAusentes">Ausentes </span>
      <span id="porcentajeIndicadorPresentes" class="badge badge-warning pull-right"><%=totalAusentes%></span></td>
    <td>
      <span id="textoIndicadorZonalAdicionales">Presentes </span>
      <span id="porcentajeIndicadorAdicionales" class="badge badge-info pull-right"><%=totalPresentes%></span>    
    </td> 
  </tr>  
  </table>
<%else%>
  <div class="alert alert-error">
    La información de cajeros estará disponible desde las 8:00
  </div>
<%end if%>