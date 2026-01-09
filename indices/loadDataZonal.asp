<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
idIndice = trim(request("idIndice"))
if idSucursal = "0" then idSucursal = trim(request("idSucursal"))
sql = ""
sql = sql & " select tabla,nombreIndice,tituloIndice, "
sql = sql & " area, "
sql = sql & " tipo, "
sql = sql & " idIndice "
sql = sql & " from SUC_indices "
sql = sql & " where  padre = '"&idIndice&"' "
sql = sql & " and estado = 1 "
sql = sql & " group by tabla, "
sql = sql & " area, "
sql = sql & " tipo,"
sql = sql & " idIndice,nombreIndice,tituloIndice, "
sql = sql & " orden "
sql = sql & " order by orden "
set rs = db.execute(sql)

Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datos"": ["
count = 0
if not rs.eof then
  do while not rs.eof
    count = count + 1
    If count > 1 Then
      Response.Write ", "
    End If
    Response.Write "{ "
    tabla = trim(rs("tabla"))
    area = trim(rs("area"))
    tipo = trim(rs("tipo"))	
    idIndice = trim(rs("idIndice"))
    nombreIndice = server.htmlencode(trim(rs("nombreIndice")))
    tituloIndice = server.htmlencode(trim(rs("tituloIndice")))
    if tabla <> "0" then
      sql2 = ""
      sql2 = sql2 & " select  a.valor, a.fecha "
      sql2 = sql2 & " from "&tabla&" a "
      sql2 = sql2 & " where a.area = '"&area&"' "
      sql2 = sql2 & " and a.tipo = '"&tipo&"' "
      sql2 = sql2 & " and a.cod_sucursal = '"&idSucursal&"' "
      sql2 = sql2 & " and  a.Fecha = "
      sql2 = sql2 & " (SELECT MAX(b.fecha) "
      sql2 = sql2 & " FROM "&tabla&" b "
      sql2 = sql2 & " where b.area = '"&area&"' and "
      sql2 = sql2 & " b.tipo = '"&tipo&"' and "
      sql2 = sql2 & " b.cod_sucursal = '"&idSucursal&"') "
      set rs2 = db.execute(sql2)
      if not rs2.eof then
        valor = trim(rs2("valor"))
		fecha = trim(rs2("fecha"))
      else
        valor = 0
      end if
    else
      valor = 0
    end if
    Response.Write "   ""idIndice"": """ & idIndice & """, "
    Response.Write "   ""nombreIndice"": """ & nombreIndice & """, "
    Response.Write "   ""tituloIndice"": """ & tituloIndice & """, "
    Response.Write "   ""tipo"": """ & tipo & """, "
	Response.Write "   ""fecha"": """ & fecha & """, "
    Response.Write "   ""valor"": """ & valor & """ "
    Response.Write "}"
    rs.movenext
  loop
end if
Response.Write "]}"%>