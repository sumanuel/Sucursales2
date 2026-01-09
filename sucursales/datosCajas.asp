<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuario"))
idPerfil = trim(request("perfil"))
sucursalesAbiaertasFueraPlazo = 0
sucursalesAbiaertasDentroPlazo = 0
sucursalesAbiaertas = 0
sql = ""
sql = sql & " select count(id_sucursal) as fp "
sql = sql & " from (SELECT SAP.*  "
sql = sql & "       FROM SUC_sucursal SUC  "
sql = sql & "       INNER JOIN SUC_sucursal_apertura SAP ON SAP.id_sucursal = SUC.id_sucursal  "
sql = sql & "       AND SUC.suc_estado = 1) APP "
sql = sql & " where tipo = 1 and fecha_ingreso = cast(GETDATE() as date)  "
sql = sql & " and hora_ingreso > '08:45' "
if idPerfil = "2" then
  sql = sql & " and id_sucursal in (select a.id_sucursal "
  sql = sql & " from SUC_usuario_sucursal a, suc_sucursal b"
  sql = sql & " where id_usuario = '"&idUsuario&"' and a.id_sucursal = b.id_sucursal and suc_estado = 1) "
end if
if idPerfil = "55" then
  sql = sql & " and id_sucursal in (select a.id_sucursal "
  sql = sql & " from SUC_zonales_comercial_sucursal a, suc_sucursal b"
  sql = sql & " where id_zonal = '"&idUsuario&"' and a.id_sucursal = b.id_sucursal and suc_estado = 1) "
end if
if idPerfil = "66" then
  sql = sql & " and id_sucursal in (select a.id_sucursal "
  sql = sql & " from SUC_zonales_comercial_mas_sucursal a, suc_sucursal b"
  sql = sql & " where id_zonal = '"&idUsuario&"' and a.id_sucursal = b.id_sucursal and suc_estado = 1) "
end if
set rs = db.execute(sql)
if not rs.eof then
  sucursalesAbiaertasFueraPlazo = clng(trim(rs("fp")))
end if
sql = ""
sql = sql & " select COUNT(id_sucursal) as dp "
sql = sql & " from (SELECT SAP.*  "
sql = sql & "       FROM SUC_sucursal SUC  "
sql = sql & "       INNER JOIN SUC_sucursal_apertura SAP ON SAP.id_sucursal = SUC.id_sucursal  "
sql = sql & "       AND SUC.suc_estado = 1) APP "
sql = sql & " where tipo = 1 and fecha_ingreso = cast(GETDATE() as date)  "
sql = sql & " and hora_ingreso <= '08:45' "
if idPerfil = "2" then
  sql = sql & " and id_sucursal in (select a.id_sucursal "
  sql = sql & " from SUC_usuario_sucursal a, suc_sucursal b"
  sql = sql & " where id_usuario = '"&idUsuario&"' and a.id_sucursal = b.id_sucursal and suc_estado = 1) "
end if
if idPerfil = "55" then
  sql = sql & " and id_sucursal in (select a.id_sucursal "
  sql = sql & " from SUC_zonales_comercial_sucursal a, suc_sucursal b"
  sql = sql & " where id_zonal = '"&idUsuario&"' and a.id_sucursal = b.id_sucursal and suc_estado = 1) "
end if
if idPerfil = "66" then
  sql = sql & " and id_sucursal in (select a.id_sucursal "
  sql = sql & " from SUC_zonales_comercial_mas_sucursal a, suc_sucursal b"
  sql = sql & " where id_zonal = '"&idUsuario&"' and a.id_sucursal = b.id_sucursal and suc_estado = 1) "
end if
set rs = db.execute(sql)
if not rs.eof then
  sucursalesAbiaertasDentroPlazo = clng(trim(rs("dp")))
end if
sql = ""
sql = sql & " select COUNT(id_sucursal) as total_sucursales "
sql = sql & " from SUC_sucursal "
sql = sql & " where suc_estado = 1 "

if idPerfil ="2" or idPerfil =  "1" then
  sql = sql & " and id_sucursal in (select a.id_sucursal "
  sql = sql & " from SUC_usuario_sucursal a, suc_sucursal b"
  sql = sql & " where id_usuario = '"&idUsuario&"' and a.id_sucursal = b.id_sucursal) "
end if
if idPerfil = "55" then
  sql = sql & " and id_sucursal in (select a.id_sucursal "
  sql = sql & " from SUC_zonales_comercial_sucursal a, suc_sucursal b"
  sql = sql & " where id_zonal = '"&idUsuario&"' and a.id_sucursal = b.id_sucursal and suc_estado = 1) "
end if
if idPerfil = "66" then
  sql = sql & " and id_sucursal in (select a.id_sucursal "
  sql = sql & " from SUC_zonales_comercial_mas_sucursal a, suc_sucursal b"
  sql = sql & " where id_zonal = '"&idUsuario&"' and a.id_sucursal = b.id_sucursal and suc_estado = 1) "
end if
set rs = db.execute(sql)
if not rs.eof then
  totalSucursales = trim(rs(0))
end if

sql = ""
sql = sql & " select COUNT(id_sucursal) as cerradas "
sql = sql & " from (SELECT SAP.*  "
sql = sql & "       FROM SUC_sucursal SUC  "
sql = sql & "       INNER JOIN SUC_sucursal_apertura SAP ON SAP.id_sucursal = SUC.id_sucursal  "
sql = sql & "       AND SUC.suc_estado = 1) APP "
sql = sql & " where tipo = 2 and fecha_ingreso = cast(GETDATE() as date) and CONVERT(time, hora_ingreso) > '12:00:00' "

if idPerfil = "2" then
  sql = sql & " and id_sucursal in (select a.id_sucursal "
  sql = sql & " from SUC_usuario_sucursal a, suc_sucursal b"
  sql = sql & " where id_usuario = '"&idUsuario&"' and a.id_sucursal = b.id_sucursal and suc_estado = 1) "
end if
if idPerfil = "55" then
  sql = sql & " and id_sucursal in (select a.id_sucursal "
  sql = sql & " from SUC_zonales_comercial_sucursal a, suc_sucursal b"
  sql = sql & " where id_zonal = '"&idUsuario&"' and a.id_sucursal = b.id_sucursal and suc_estado = 1) "
end if
if idPerfil = "66" then
  sql = sql & " and id_sucursal in (select a.id_sucursal "
  sql = sql & " from SUC_zonales_comercial_mas_sucursal a, suc_sucursal b"
  sql = sql & " where id_zonal = '"&idUsuario&"' and a.id_sucursal = b.id_sucursal and suc_estado = 1) "
end if

set rs = db.execute(sql)
if not rs.eof then
  sucursalesCerradas = clng(trim(rs("cerradas")))
end if
sucursalesAbiertas = sucursalesAbiaertasFueraPlazo + sucursalesAbiaertasDentroPlazo
sucursalesAbiaertasActual = (sucursalesAbiaertasFueraPlazo + sucursalesAbiaertasDentroPlazo) - sucursalesCerradas
totalSucursalesCerradas = totalSucursales-sucursalesAbiaertas
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""dataAperturaSucursales"": ["
response.write "{"
Response.Write "   ""sucursalesAbiaertasFueraPlazo"": """ & sucursalesAbiaertasFueraPlazo & """, "
Response.Write "   ""sucursalesAbiaertasDentroPlazo"": """ & sucursalesAbiaertasDentroPlazo & """, "
Response.Write "   ""totalSucursales"": """ & totalSucursales & """, "
Response.Write "   ""sucursalesCerradas"": """ & sucursalesCerradas & """, "
Response.Write "   ""sucursalesAbiertas"": """ & sucursalesAbiertas & """, "
Response.Write "   ""sucursalesAbiaertasActual"": """ & sucursalesAbiaertasActual & """ "
response.write "}"
response.write "]}"%>
