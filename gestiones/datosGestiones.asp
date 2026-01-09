<!--#include file="../funciones.asp"-->
<%tipo = trim(request("tipo"))
idSucursal = trim(request("idSucursal"))
perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
if tipo = "4" then
  icono = "icon-group"
  tipoClase = "gAdministrativa"
  campo = "admin"
end if
if tipo = "3" then
  icono = "icon-money"
  tipoClase = "gContable"
  campo = "cont"
end if
if tipo= "2" then
  icono = "icon-archive"
  tipoClase = "gDocumental"
  campo = "doc"
end if
tieneDatos = 0
if perfil = "1" then
  sql = ""
  sql = sql & "select count(a.id_gest_"&campo&") "
  sql = sql & " from SUC_gest_"&campo&" a (nolock) inner join SUC_gest_"&campo&"_tipo b (nolock) "
  sql = sql & " on a.id_gest_"&campo&"_tipo = b.id_gest_"&campo&"_tipo "
  sql = sql & " where a.fecha_operacion = CAST(getdate() as date) "
  sql = sql & " and a.id_sucursal = '"&idSucursal&"' "
end if
if perfil="2" then
  sql = ""
  sql = sql & " select COUNT(id_gest_"&campo&") "
  sql = sql & " from SUC_gest_"&campo&" (nolock) "
  sql = sql & " where fecha_operacion = cast(GETDATE() as date) "
  sql = sql & " and id_sucursal in ( "
  sql = sql & " select id_sucursal "
  sql = sql & " from SUC_usuario_sucursal (nolock) "
  sql = sql & " where id_usuario='"&idUsuario&"')"
end if
if perfil="55" then
  sql = ""
  sql = sql & " select COUNT(id_gest_"&campo&") "
  sql = sql & " from SUC_gest_"&campo&" (nolock) "
  sql = sql & " where fecha_operacion = cast(GETDATE() as date) "
  sql = sql & " and id_sucursal in ( "
  sql = sql & " select id_sucursal "
  sql = sql & " from SUC_zonales_comercial_sucursal (nolock) "
  sql = sql & " where id_zonal='"&idUsuario&"')"
end if
if perfil="66" then
  sql = ""
  sql = sql & " select COUNT(id_gest_"&campo&") "
  sql = sql & " from SUC_gest_"&campo&" (nolock) "
  sql = sql & " where fecha_operacion = cast(GETDATE() as date) "
  sql = sql & " and id_sucursal in ( "
  sql = sql & " select id_sucursal "
  sql = sql & " from SUC_zonales_comercial_mas_sucursal (nolock) "
  sql = sql & " where id_zonal='"&idUsuario&"')"
end if
if perfil="3" then
  sql = ""
  sql = sql & " select COUNT(id_gest_"&campo&") "
  sql = sql & " from SUC_gest_"&campo&" (nolock) "
  sql = sql & " where fecha_operacion = cast(GETDATE() as date) "
end if
set rs = db.execute(sql)
if not rs.eof then
  totalTareas = trim(clng(rs(0)))
  tieneDatos = 1
end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
if tieneDatos = 1 then
  sql = ""
  sql = sql & "select count(a.id_gest_"&campo&") "
  sql = sql & " from SUC_gest_"&campo&" a (nolock) inner join SUC_gest_"&campo&"_tipo b (nolock) "
  sql = sql & " on a.id_gest_"&campo&"_tipo = b.id_gest_"&campo&"_tipo "
  sql = sql & " where a.fecha_operacion = CAST(getdate() as date) "
  if perfil = "1" then
    sql = sql & " and a.id_sucursal = '"&idSucursal&"' "
  end if
  if perfil = "2" then
    sql = sql & " and a.id_sucursal in (select id_sucursal from SUC_usuario_sucursal (nolock) where id_usuario='"&idUsuario&"') "
  end if
  if perfil = "55" then
    sql = sql & " and a.id_sucursal in (select id_sucursal from SUC_zonales_comercial_sucursal (nolock) where id_zonal='"&idUsuario&"') "
  end if
  if perfil = "66" then
    sql = sql & " and a.id_sucursal in (select id_sucursal from SUC_zonales_comercial_mas_sucursal (nolock) where id_zonal='"&idUsuario&"') "
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
  if totalTareas <> "0" then
    porcentajeTarea = formatpercent(totalTareasTerminadas/totalTareas,1)
    porcentajeTarea = cint(replace(porcentajeTarea,"%",""))
  else
    porcentajeTarea = "0"
  end if
  if porcentajeTarea < 100 then
    if porcentajeTarea <= 30 then
      clasePorcentaje = "0"
    else
      clasePorcentaje = "50"
    end if
  else
    clasePorcentaje = "100"
  end if
  if totalTareas <> "0" then
    porcentaje = formatpercent(totalTareasTerminadas/totalTareas,1)
    porcentaje = replace(porcentaje,"%","")
    if right(porcentaje,2) = ",0" then
      porcentaje = cint(porcentaje)
    end if
    porcentaje = porcentaje&"%"
  else
    porcentaje = "0%"
  end if
  Response.ContentType = "application/json"
  Response.Write "{"
  Response.Write "  ""datosGestiones"": ["
  Response.Write "{"
  Response.Write "   ""tipo"": """ & tipo & """, "
  Response.Write "   ""icono"": """ & icono & """, "
  Response.Write "   ""tipoClase"": """ & tipoClase & """, "
  Response.Write "   ""campo"": """ & campo & """, "
  Response.Write "   ""totalTareas"": """ & totalTareas & """, "
  Response.Write "   ""totalTareasTerminadas"": """ & totalTareasTerminadas & """, "
  Response.Write "   ""totalTareasNoTerminadas"": """ & totalTareasNoTerminadas & """, "
  Response.Write "   ""porcentaje"": """ & porcentaje & """, "
  Response.Write "   ""clasePorcentaje"": """ & clasePorcentaje & """ "
  Response.Write "}"
  Response.Write "]} "
end if%>
