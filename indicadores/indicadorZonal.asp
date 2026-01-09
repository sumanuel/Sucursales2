<!--#include file="../funciones.asp"-->
<%tipo = trim(request("tipo"))
idSucursal = trim(request("idSucursal"))
perfil = trim(request("perfilMain"))
idUsuario = trim(request("idUsuarioMain"))
if tipo = "4" then
  icono = "icon-group"
  tipoClase = "gAdministrativaZonalSuc"
  campo = "admin"
end if
if tipo = "3" then
  icono = "icon-money"
  tipoClase = "gContableZonalSuc"
  campo = "cont"
end if
if tipo= "2" then
  icono = "icon-archive"
  tipoClase = "gDocumentalZonalSuc"
  campo = "doc"
end if
tieneDatos = 0
sql = ""
sql = sql & "select count(a.id_gest_"&campo&") "
sql = sql & " from SUC_gest_"&campo&" a inner join SUC_gest_"&campo&"_tipo b "
sql = sql & " on a.id_gest_"&campo&"_tipo = b.id_gest_"&campo&"_tipo "
sql = sql & " where a.fecha_operacion = CAST(getdate() as date) "
if idSucursal <> "" then
  sql = sql & " and a.id_sucursal = '"&idSucursal&"' "
end if
'response.write(sql)
'response.end
set rs = db.execute(sql)
if not rs.eof then
  totalTareas = trim(clng(rs(0)))
end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
if totalTareas <> "0" then tieneDatos = 1
if tieneDatos = 1 then
  sql = ""
  sql = sql & "select count(a.id_gest_"&campo&") "
  sql = sql & " from SUC_gest_"&campo&" a inner join SUC_gest_"&campo&"_tipo b "
  sql = sql & " on a.id_gest_"&campo&"_tipo = b.id_gest_"&campo&"_tipo "
  sql = sql & " where a.fecha_operacion = CAST(getdate() as date) "
  if idSucursal <> "" then
    sql = sql & " and a.id_sucursal = '"&idSucursal&"' "
  end if
  sql = sql & " and gest_"&campo&"_estado = 1 "
  set rs = db.execute(sql)
  if not rs.eof then
    totalTareasTerminadas = trim(clng(rs(0)))
  end if
  rs.Close
  set rs.ActiveConnection = nothing
  set rs=nothing
  DB.Close
  set DB=nothing
  totalTareasNoTerminadas = totalTareas - totalTareasTerminadas
  porcentajeTarea = formatpercent(totalTareasTerminadas/totalTareas,1)
  porcentaje = replace(formatpercent(totalTareasTerminadas/totalTareas,1),"%","")
  porcentajeTarea = cint(replace(porcentajeTarea,"%",""))
  if porcentajeTarea < 100 then
    if porcentajeTarea <= 30 then
      clasePorcentaje = "0"
    else
      clasePorcentaje = "50"
    end if
  else
    clasePorcentaje = "100"
  end if
  if right(porcentaje,2) = ",0" then
    porcentaje = cint(porcentaje)
  end if
  porcentaje = porcentaje&"%"
%>
<table border="0" width="100%">
  <tr>
    <td rowspan="2" align="center">
      <div id="porcentaje">
          <i class="<%=icono%> icon-3x"></i>
      </div>
    </td>
    <td>
      <div id="tareasTerminadas">
        <table border="0" width="100%">
        <tr>
          <td><%=totalTareasTerminadas%><i class="icon-ok"></i></td>
            <td><%=totalTareasNoTerminadas%> <i class="icon-remove"></i></td>
        </tr>
        </table>
      </div>
    </td>
  </tr>
  <tr>
    <td align="center">
      <div id="tareasNoTerminadas">
        <h4><%=porcentaje%></h4>
      </div>
    </td>
  </tr>
</table>
<script type="text/javascript">
$(function(){
  $('#<%=tipoClase%>').removeClass("fondo100 fondo50 fondo0").addClass("fondo<%=clasePorcentaje%>");
});
</script>
<%else%>
<table>
  <tr>
    <td>Los valores aun no se encuentran disponibles xx</td>
  </tr>
</table>
<%end if%>