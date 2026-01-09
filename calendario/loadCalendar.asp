<!--#include file="../funciones.asp"-->
<%
idSucursal = trim(request("idSucursal"))
perfil = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
mes = trim(request("mes"))
if IsEmpty(mes) or mes = "" then mes = month(date())
anio = trim(request("anio"))
if IsEmpty(anio) or anio = "" then anio = year(date())
sql = ""
sql = sql & " select a.fecha_f1, b.id_calitipo, "
sql = sql & " c.item_tipo, COUNT(*) num "
sql = sql & " from SUC_calendario a "
sql = sql & " inner join SUC_calendario_item b "
sql = sql & " on a.id_cal = b.id_cal inner "
sql = sql & " join SUC_calendario_item_tipo c "
sql = sql & " on b.id_calitipo = c.id_calitipo "
sql = sql & " inner join SUC_sucursal_visita f "
sql = sql & " on b.id_op = f.id_sucvis "
if perfil <> "3" then 
   sql = sql & " where b.id_suc in "
   sql = sql & " (select id_sucursal "
   sql = sql & " from SUC_usuario_sucursal "
   sql = sql & " where id_usuario = "&idUsuario&" ) "
end if
if idSucursal <> "" and idSucursal <> "0" Then
   sql = sql & "and b.id_suc = '"&idSucursal&"'"
end if
if perfil = "1" then
   sql = sql & " and f.visita_motivo <> '3' "
end if
sql = sql & " and year(a.fecha) = '"&anio&"' "
sql = sql & " and month(a.fecha) = '"&mes&"' "
sql = sql & " group by fecha_f1, b.id_calitipo, item_tipo "
'response.write(sql)
'response.end
set rs = db.execute(sql)
if not rs.eof then
   datos = rs.GetRows()
   Response.ContentType = "application/json"
   Response.Write "{"
   Response.Write "  ""datos"": ["
   count = 0 	
   For i = 0 to ubound(datos, 2)
      Dim fecha_f1, id_caltipo, item_tipo, num
      fecha_f1 = trim(datos(0,i))
      id_calitipo =trim(datos(1,i))
      item_tipo = trim(datos(2,i))
      num = trim(datos(3,i))

      count = count + 1
      If count > 1 Then
      Response.Write ", "
      End If

      Response.Write "{ "      
      Response.Write "   ""fecha_f1"": """ & fecha_f1 & """, "
      Response.Write "   ""id_calitipo"": """ & id_calitipo & """, "
      Response.Write "   ""item_tipo"": """ & item_tipo & """, "	  
      Response.Write "   ""num"": """ & num & """ "
      Response.Write "}"
   next
   Response.Write "         ]"
   Response.Write "}"
end if

%>