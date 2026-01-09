<!--#include file="../funciones2.asp"-->
<%perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
idSucursal = trim(request("idSucursal"))
'if perfil = "1" then

  sql = ""
  sql = sql & " select suc_nombre, suc_direccion, suc_tipo, "
  sql = sql & " suc_jeps, suc_jeps_enexo, "
  sql = sql & " suc_jeps_celular, suc_zonal, suc_zonal_ext, "
  sql = sql & " cod_sap, cod_bantotal, suc_jeps_rut "
  sql = sql & " from SUC_sucursal "
  sql = sql & " where id_sucursal = '"&idSucursal&"'"
  'response.write(sql)
  set rs= db.execute(sql)
  if not rs.eof then
    nombreSucursal = server.HTMLEncode(trim(rs("suc_nombre")))
    direccionSucursal = server.HTMLEncode(trim(rs("suc_direccion")))
    nombreJeps = trim(rs("suc_jeps"))
    nombreOri = trim(rs("suc_jeps"))
    anexoSucursal = trim(rs("suc_jeps_enexo"))
    celujarJeps = trim(rs("suc_jeps_celular"))
    nombreEncargadoZonal = server.HTMLEncode(trim(rs("suc_zonal")))
    nombreEncargadoZonal_Ext = server.HTMLEncode(trim(rs("suc_zonal_ext")))
    suc_tipo = server.HTMLEncode(trim(rs("suc_tipo")))  
    codSAP = trim(rs("cod_sap"))
    codBTT = trim(rs("cod_bantotal"))
    rutJeps = trim(rs("suc_jeps_rut"))
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
  if perfil <> "1" then
    sql = ""
    sql = sql & " select archivo, "
    sql = sql & " cast(fecha_auditoria as datetime) as fecha_auditoria, "
    sql = sql & " evaluacion "
    sql = sql & " from SUC_sucursal_auditoria "
    sql = sql & " where id_sucursal = '"&idSucursal&"' "
    sql = sql & " and id_auditoria = "
    sql = sql & " (select max(id_auditoria) "
    sql = sql & " from SUC_sucursal_auditoria ) "
    'response.write(sql)
    'response.end
    set rs=db.execute(sql)
    if not rs.eof then
      tieneDatos = "1"
      evaluacion = trim(rs("evaluacion"))
      if evaluacion = "1" then
        claseEvaluacion = "alert alert-success"
      else
        claseEvaluacion = "alert alert-error"
      end if
      fechaAuditoria = trim(rs("fecha_auditoria"))
      diaFechaActual = formateaParaFecha(day(fechaAuditoria))
      mesFechaActual = formateaParaFecha(month(fechaAuditoria))
      anioFechaActual = year(fechaAuditoria)
      fechaAuditoria = diaFechaActual&"-"&mesFechaActual&"-"&anioFechaActual
      archivo = trim(rs("archivo"))
    else
      claseEvaluacion = ""
      tieneDatos = "0"
      archivo="No presenta Datos"
    end if
  end if
  sql = ""
  sql = sql & " select cast(hora_apertura as datetime) as hora_apertura, "
  sql = sql & " cast(hora_cierre as datetime) as hora_cierre "
  sql = sql & " from SUC_apertura_sucursal "
  'response.write(sql)
  'response.end
  set rs = db.execute(sql)
  if not rs.eof then
    horaApertura  = trim(rs("hora_apertura"))
    horaCierre = trim(rs("hora_cierre"))
  end if
  horaAperturaHora = hour(horaApertura)
  horaAperturamin = minute(horaApertura)
  horaCierreHora = hour(horaCierre)
  horaCierremin = minute(horaCierre)
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datosSucursal"": ["
Response.Write "{"
Response.Write "   ""idSucursal"": """ & idSucursal & """, "
Response.Write "   ""nombreSucursal"": """ & nombreSucursal & """, "
Response.Write "   ""direccionSucursal"": """ & direccionSucursal & """, "
Response.Write "   ""nombreJeps"": """ & nombreJeps & """, "
Response.Write "   ""nombreOri"": """ & nombreOri & """, "
Response.Write "   ""anexoSucursal"": """ & anexoSucursal & """, "
Response.Write "   ""celujarJeps"": """ & celujarJeps & """, "
Response.Write "   ""nombreEncargadoZonal"": """ & nombreEncargadoZonal & """, "
Response.Write "   ""nombreEncargadoZonal_Ext"": """ & nombreEncargadoZonal_Ext & """, "
Response.Write "   ""suc_tipo"": """ & suc_tipo & """, "
Response.Write "   ""codSAP"": """ & codSAP & """, "
Response.Write "   ""codBTT"": """ & codBTT & """, "
Response.Write "   ""rutJeps"": """ & rutJeps & """, "
Response.Write "   ""horaAperturaHora"": """ & horaAperturaHora & """, "
Response.Write "   ""horaAperturamin"": """ & horaAperturamin & """, "
Response.Write "   ""horaCierreHora"": """ & horaCierreHora & """, "
Response.Write "   ""horaCierremin"": """ & horaCierremin & """, "
Response.Write "   ""horaApertura"": """ & horaApertura & """, "
Response.Write "   ""horaCierre"": """ & horaCierre & """, "
if perfil = "2" then
  Response.Write "   ""claseEvaluacion"": """ & claseEvaluacion & """, "
  Response.Write "   ""evaluacion"": """ & evaluacion & """, "
  Response.Write "   ""fechaAuditoria"": """ & fechaAuditoria & """, "
  Response.Write "   ""archivo"": """ & archivo & """, "
  Response.Write "   ""tieneAuditoria"": """ & tieneDatos & """, "
end if
Response.Write "   ""sucursalAbierta"": """ & sucursalAbierta & """ "
Response.Write "}"
Response.Write "]} "%>