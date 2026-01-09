<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
'if perfil = "1" then
  sql = ""
  sql = sql & " select suc_nombre, suc_direccion, suc_tipo, "
  sql = sql & " suc_jeps, suc_jeps_enexo, "
  sql = sql & " suc_jeps_celular, suc_zonal, suc_zonal_ext, "
  sql = sql & " cod_sap, cod_bantotal "
  sql = sql & " from SUC_sucursal "
  sql = sql & " where id_sucursal = '"&idSucursal&"'"
  'response.write(sql)
  set rs= db.execute(sql)
  if not rs.eof then
    nombreSucursal = server.HTMLEncode(trim(rs("suc_nombre")))
    direccionSucursal = server.HTMLEncode(trim(rs("suc_direccion")))
    nombreJeps = server.HTMLEncode(trim(rs("suc_jeps")))  
    anexoSucursal = trim(rs("suc_jeps_enexo"))
    celujarJeps = trim(rs("suc_jeps_celular"))
    nombreEncargadoZonal = server.HTMLEncode(trim(rs("suc_zonal")))
    nombreEncargadoZonal_Ext = server.HTMLEncode(trim(rs("suc_zonal_ext")))
    suc_tipo = server.HTMLEncode(trim(rs("suc_tipo")))  
    codSAP = trim(rs("cod_sap"))
    codBTT = trim(rs("cod_bantotal"))
    sql2 = ""
    sql2 = sql2 & " select 1 "
    sql2 = sql2 & " from SUC_sucursal_apertura "
    sql2 = sql2 & " where id_sucursal = '"&idSucursal&"' "
    sql2 = sql2 & " and fecha_ingreso = cast(getdate() as DATE) "
    sql2 = sql2 & " and tipo = 1 "
    set rs2 = db.execute(sql2)
    if rs2.eof then
      sucursalAbierta = 0
    else
      sucursalAbierta = 1
    end if
  end if
 
'end if
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datosSucursal"": ["
Response.Write "{"
Response.Write "   ""idSucursal"": """ & idSucursal & """, "
Response.Write "   ""nombreSucursal"": """ & nombreSucursal & """, "
Response.Write "   ""direccionSucursal"": """ & direccionSucursal & """, "
Response.Write "   ""nombreJeps"": """ & nombreJeps & """, "
Response.Write "   ""anexoSucursal"": """ & anexoSucursal & """, "
Response.Write "   ""celujarJeps"": """ & celujarJeps & """, "
Response.Write "   ""nombreEncargadoZonal"": """ & nombreEncargadoZonal & """, "
Response.Write "   ""nombreEncargadoZonal_Ext"": """ & nombreEncargadoZonal_Ext & """, "
Response.Write "   ""suc_tipo"": """ & suc_tipo & """, "
Response.Write "   ""codSAP"": """ & codSAP & """, "
Response.Write "   ""codBTT"": """ & codBTT & """, "
Response.Write "   ""sucursalAbierta"": """ & sucursalAbierta & """ "
Response.Write "}"
Response.Write "]} "%>