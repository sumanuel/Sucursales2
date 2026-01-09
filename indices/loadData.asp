<!--#include file="../funciones.asp"-->
<%

idSucursal = trim(request("idSucursal"))
perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
'idSucursal = "2"
'if idSucursal = "0" then idSucursal = trim(request("idSucursal"))
'=============================================================
' TEST NUEVA IMPLEMENTACION
'=============================================================
sql_cr =""
sql_cr = sql_cr &" select a.fecha, sum(a.valor) valor, a.area,  a.tipo, a.fecha_ingreso, a.hora_ingreso "
sql_cr = sql_cr &" from SUC_index_cr a "
sql_cr = sql_cr &" inner join SUC_sucursal b "
sql_cr = sql_cr &" on a.cod_bantotal = b.cod_bantotal "
sql_cr = sql_cr &" where a.fecha = (select MAX(c.fecha) "
sql_cr = sql_cr &" from SUC_index_cr c "
sql_cr = sql_cr &" where a.tipo = c.tipo) "
if perfil = "1" then
   sql_cr = sql_cr &" and b.id_sucursal = " & idSucursal &" "
end if
if perfil = "2" then
   sql_cr = sql_cr & " and b.id_sucursal in ( "
   sql_cr = sql_cr & " select id_sucursal from SUC_zonales_sucursal "
   sql_cr = sql_cr & " where id_zonal =  '"&idUsuario&"' ) "
end if
sql_cr = sql_cr &" group by fecha,area,tipo,fecha_ingreso,hora_ingreso "
sql_lm = ""
sql_lm = sql_lm &  " union  "
sql_lm = sql_lm &  " select a.fecha, sum(a.valor) valor, a.area,  a.tipo, a.fecha_ingreso, a.hora_ingreso "
sql_lm = sql_lm &  " from SUC_index_lm a "
sql_lm = sql_lm &  " inner join SUC_sucursal b "
sql_lm = sql_lm &  " on a.cod_bantotal = b.cod_bantotal "
sql_lm = sql_lm &  " where a.fecha = (select MAX(c.fecha) "
sql_lm = sql_lm &  " from SUC_index_lm c "
sql_lm = sql_lm &  " where a.tipo = c.tipo) "
if perfil = "1" then
   sql_lm = sql_lm &" and b.id_sucursal = " & idSucursal &" "
end if
if perfil = "2" then
   sql_lm = sql_lm & " and b.id_sucursal in ( "
   sql_lm = sql_lm & " select id_sucursal from SUC_zonales_sucursal "
   sql_lm = sql_lm & " where id_zonal =  '"&idUsuario&"' ) "
end if
sql_lm = sql_lm &  " group by fecha,area,tipo,fecha_ingreso,hora_ingreso "
sql_ips = ""
sql_ips = sql_ips & " union select a.fecha, sum(a.valor) valor, a.area,  a.tipo, a.fecha_ingreso, a.hora_ingreso "
sql_ips = sql_ips & " from SUC_index_ips a "
sql_ips = sql_ips & " inner join SUC_sucursal b "
sql_ips = sql_ips & " on a.cod_bantotal = b.cod_bantotal "
sql_ips = sql_ips & " where a.fecha = (select MAX(c.fecha) "
sql_ips = sql_ips & " from SUC_index_ips c "
sql_ips = sql_ips & " where a.tipo = c.tipo) "
if perfil = "1" then
   sql_ips = sql_ips &" and b.id_sucursal = " & idSucursal &" "
end if
if perfil = "2" then
   sql_ips = sql_ips & " and b.id_sucursal in ( "
   sql_ips = sql_ips & " select id_sucursal from SUC_zonales_sucursal "
   sql_ips = sql_ips & " where id_zonal =  '"&idUsuario&"' ) "
end if
sql_ips = sql_ips & " group by fecha,area,tipo,fecha_ingreso,hora_ingreso "
sql_epp = ""
sql_epp = sql_epp & " union select a.fecha, sum(a.valor) valor, a.area,  a.tipo, a.fecha_ingreso, a.hora_ingreso "
sql_epp = sql_epp & " from SUC_index_afp a "
sql_epp = sql_epp & " inner join SUC_sucursal b "
sql_epp = sql_epp & " on a.cod_bantotal = b.cod_bantotal "
sql_epp = sql_epp & " where a.fecha = (select MAX(c.fecha) "
sql_epp = sql_epp & " from SUC_index_afp c "
sql_epp = sql_epp & " where a.tipo = c.tipo) "
if perfil = "1" then
   sql_epp = sql_epp &" and b.id_sucursal = " & idSucursal &" "
end if
if perfil = "2" then
   sql_epp = sql_epp & " and b.id_sucursal in ( "
   sql_epp = sql_epp & " select id_sucursal from SUC_zonales_sucursal "
   sql_epp = sql_epp & " where id_zonal =  '"&idUsuario&"' ) "
end if
sql_epp = sql_epp & " group by fecha,area,tipo,fecha_ingreso,hora_ingreso "
sql_bonos = ""
sql_bonos = sql_bonos & " union select a.fecha, sum(a.valor) valor, a.area,  a.tipo, a.fecha_ingreso, a.hora_ingreso "
sql_bonos = sql_bonos & " from SUC_index_bonos a "
sql_bonos = sql_bonos & " inner join SUC_sucursal b "
sql_bonos = sql_bonos & " on a.cod_bantotal = b.cod_bantotal "
sql_bonos = sql_bonos & " where a.fecha = (select MAX(c.fecha) "
sql_bonos = sql_bonos & " from SUC_index_bonos c "
sql_bonos = sql_bonos & " where a.tipo = c.tipo) "
if perfil = "1" then
   sql_bonos = sql_bonos &" and b.id_sucursal = " & idSucursal &" "
end if
if perfil = "2" then
   sql_bonos = sql_bonos & " and b.id_sucursal in ( "
   sql_bonos = sql_bonos & " select id_sucursal from SUC_zonales_sucursal "
   sql_bonos = sql_bonos & " where id_zonal =  '"&idUsuario&"' ) "
end if
sql_bonos = sql_bonos & " group by fecha,area,tipo,fecha_ingreso,hora_ingreso "

sql_contr = ""
sql_contr = sql_contr & " union select a.fecha, sum(a.valor) valor, a.area,  a.tipo, a.fecha_ingreso, a.hora_ingreso "
sql_contr = sql_contr & " from SUC_index_controller a "
sql_contr = sql_contr & " inner join SUC_sucursal b "
sql_contr = sql_contr & " on a.cod_bantotal = b.cod_bantotal "
sql_contr = sql_contr & " where a.fecha = (select MAX(c.fecha) "
sql_contr = sql_contr & " from SUC_index_controller c "
sql_contr = sql_contr & " where a.tipo = c.tipo) "
if perfil = "1" then
   sql_contr = sql_contr &" and b.id_sucursal = " & idSucursal &" "
end if
if perfil = "2" then
   sql_contr = sql_contr & " and b.id_sucursal in ( "
   sql_contr = sql_contr & " select id_sucursal from SUC_zonales_sucursal "
   sql_contr = sql_contr & " where id_zonal =  '"&idUsuario&"' ) "
end if
sql_contr = sql_contr & " group by fecha,area,tipo,fecha_ingreso,hora_ingreso "

sql_reca = ""
sql_reca = sql_reca & " union select a.fecha, sum(a.valor) valor, a.area,  a.tipo, a.fecha_ingreso, a.hora_ingreso "
sql_reca = sql_reca & " from SUC_index_reca a "
sql_reca = sql_reca & " inner join SUC_sucursal b "
sql_reca = sql_reca & " on a.cod_bantotal = b.cod_bantotal "
sql_reca = sql_reca & " where a.fecha = (select MAX(c.fecha) "
sql_reca = sql_reca & " from SUC_index_reca c "
sql_reca = sql_reca & " where a.tipo = c.tipo) "
if perfil = "1" then
   sql_reca = sql_reca &" and b.id_sucursal = " & idSucursal &" "
end if
if perfil = "2" then
   sql_reca = sql_reca & " and b.id_sucursal in ( "
   sql_reca = sql_reca & " select id_sucursal from SUC_zonales_sucursal "
   sql_reca = sql_reca & " where id_zonal =  '"&idUsuario&"' ) "
end if
sql_reca = sql_reca & " group by fecha,area,tipo,fecha_ingreso,hora_ingreso "
sql_afi = ""
sql_afi = sql_afi & " union select a.fecha, sum(a.valor) valor, a.area,  a.tipo, a.fecha_ingreso, a.hora_ingreso "
sql_afi = sql_afi & " from SUC_index_afi a "
sql_afi = sql_afi & " inner join SUC_sucursal b "
sql_afi = sql_afi & " on a.cod_bantotal = b.cod_bantotal "
sql_afi = sql_afi & " where a.fecha = (select MAX(c.fecha)"
sql_afi = sql_afi & " from SUC_index_afi c "
sql_afi = sql_afi & " where a.tipo = c.tipo) "
if perfil = "1" then
   sql_afi = sql_afi &" and b.id_sucursal = " & idSucursal &" "
end if
if perfil = "2" then
   sql_afi = sql_afi & " and b.id_sucursal in ( "
   sql_afi = sql_afi & " select id_sucursal from SUC_zonales_sucursal "
   sql_afi = sql_afi & " where id_zonal =  '"&idUsuario&"' ) "
end if
sql_afi = sql_afi & " group by fecha,area,tipo,fecha_ingreso,hora_ingreso "
sql_rec = ""
sql_rec = sql_rec & " union select a.fecha, sum(a.valor) valor, a.area,  a.tipo, a.fecha_ingreso, a.hora_ingreso "
sql_rec = sql_rec & " from SUC_index_rec a "
sql_rec = sql_rec & " inner join SUC_sucursal b "
sql_rec = sql_rec & " on a.cod_bantotal = b.cod_bantotal "
sql_rec = sql_rec & " where a.fecha = (select MAX(c.fecha) "
sql_rec = sql_rec & " from SUC_index_rec c "
sql_rec = sql_rec & " where a.tipo = c.tipo) "
if perfil = "1" then
   sql_rec = sql_rec &" and b.id_sucursal = " & idSucursal &" "
end if
if perfil = "2" then
   sql_rec = sql_rec & " and b.id_sucursal in ( "
   sql_rec = sql_rec & " select id_sucursal from SUC_zonales_sucursal "
   sql_rec = sql_rec & " where id_zonal =  '"&idUsuario&"' ) "
end if
sql_rec = sql_rec & " group by fecha,area,tipo,fecha_ingreso,hora_ingreso"
sql_final = sql_cr + sql_lm + sql_ips + sql_contr + sql_epp + sql_bonos + sql_reca + sql_afi + sql_rec 
'response.write(sql_final)
'response.End()

set rs = db.execute(sql_final)
'########## mando datos a array
datos = rs.GetRows()
	
   Response.ContentType = "application/json"
   Response.Write "{"
   Response.Write "  ""datos"": ["
   count = 0 	

   For i = 0 to ubound(datos, 2)
      Dim correlativo, fecha, cantidad, fecha_ingreso, area, tipo
	        
	  fecha = trim(datos(0,i))
	  valor = trim(datos(1,i))
	  area = trim(datos(2,i))
      tipo = trim(datos(3,i))
	  
	  
	  fecha_ingreso = trim(datos(4,i))
      count = count + 1
      If count > 1 Then
         Response.Write ", "
      End If
      if area= "pg" and tipo = "5" then
         sql2 = ""
         sql2 = sql2 & "select sum(valor) from SUC_index_ips where fecha_ingreso = cast(GETDATE() as date)  and tipo = '3' "
		 if perfil = "1" then
			sql2 = sql2 &" and cod_sucursal = " & idSucursal &" "
		 end if
       if perfil = "2" then
         sql2 = sql2 & " and cod_sucursal in ( "
         sql2 = sql2 & " select id_sucursal from SUC_zonales_sucursal "
         sql2 = sql2 & " where id_zonal =  '"&idUsuario&"' ) "
      end if
         set rs2 = db.execute(sql2)
         if not rs2.eof then
            valor1 = trim(rs2(0))
         end if
         sql2 = ""
         sql2 = sql2 & "select sum(valor)  from SUC_index_ips where fecha_ingreso = cast(GETDATE() as date)  and tipo = '1' "
		 if perfil = "1" then
			sql2 = sql2 &" and cod_sucursal = " & idSucursal &" "
		 end if
       if perfil = "2" then
         sql2 = sql2 & " and cod_sucursal in ( "
         sql2 = sql2 & " select id_sucursal from SUC_zonales_sucursal "
         sql2 = sql2 & " where id_zonal =  '"&idUsuario&"' ) "
      end if
		 'Response.Write(sql2)
         if not rs2.eof then
            valor2 = trim(rs2(0))
         end if
         if valor2 <> "0" then
            valor = clng(valor1) * 100
            valor = valor / clng(valor2)
            valor = FormatNumber((valor),3)
         else
            valor = 100
         end if
         fecha = Date()
          'sql2 = ""
         'sql2 = sql2 & " select isnull((((select sum(valor) "
         'sql2 = sql2 & " from SUC_index_ips "
         'sql2 = sql2 & " where fecha_ingreso = cast(GETDATE() as date) "
         'sql2 = sql2 & " and tipo = '3')*100)/(select sum(valor) "
         'sql2 = sql2 & " from SUC_index_ips where fecha_ingreso = cast(GETDATE() as date) "
         'sql2 = sql2 & " and tipo = '1')),0) as valor, fecha = cast(GETDATE() as date)"
         'set rs2 = db.execute(sql2)
         'if not rs2.eof then
         ''   valor = FormatNumber(trim(rs2("valor")),3)
         ''   fecha = trim(rs2("fecha"))
         'end if
      end if
      if area= "pg" and tipo = "6" then
         sql2 = ""
         sql2 = sql2 & "select sum(valor) from SUC_index_ips where fecha_ingreso = cast(GETDATE() as date)  and tipo = '4' "
		 if perfil = "1" then
			sql2 = sql2 &" and cod_sucursal = " & idSucursal &" "
		 end if
       if perfil = "2" then
         sql2 = sql2 & " and cod_sucursal in ( "
         sql2 = sql2 & " select id_sucursal from SUC_zonales_sucursal "
         sql2 = sql2 & " where id_zonal =  '"&idUsuario&"' ) "
      end if
         set rs2 = db.execute(sql2)
         if not rs2.eof then
            valor1 = trim(rs2(0))
         end if
         sql2 = ""
         sql2 = sql2 & "select sum(valor)  from SUC_index_ips where fecha_ingreso = cast(GETDATE() as date)  and tipo = '2' "
		 if perfil = "1" then
			sql2 = sql2 &" and cod_sucursal = " & idSucursal &" "
		 end if
       if perfil = "2" then
         sql2 = sql2 & " and cod_sucursal in ( "
         sql2 = sql2 & " select id_sucursal from SUC_zonales_sucursal "
         sql2 = sql2 & " where id_zonal =  '"&idUsuario&"' ) "
      end if
         if not rs2.eof then
            valor2 = trim(rs2(0))
         end if
         if valor2 <> "0" then
            'valor = clng(valor1) * 100
			valor = valor1 * 100
            'valor = valor / clng(valor2)
			valor = valor / valor2
            valor = FormatNumber((valor),3)
         else
            valor = 100
         end if
         fecha = Date()
         'sql2 = ""
         'sql2 = sql2 & " select isnull((((select sum(valor) "
         'sql2 = sql2 & " from SUC_index_ips "
         'sql2 = sql2 & " where fecha_ingreso = cast(GETDATE() as date) "
         'sql2 = sql2 & " and tipo = '4')*100)/(select sum(valor) "
         'sql2 = sql2 & " from SUC_index_ips where fecha_ingreso = cast(GETDATE() as date) "
         'sql2 = sql2 & " and tipo = '2')),0) as valor, fecha = cast(GETDATE() as date)"
         'set rs2 = db.execute(sql2)
         'if not rs2.eof then
         ''   valor = FormatNumber(trim(rs2("valor")),3)
         ''   fecha = trim(rs2("fecha"))
         'end if
      end if
      Response.Write "{ "      
      Response.Write "   ""fecha"": """ & fecha & """, "
      Response.Write "   ""valor"": """ & valor & """, "
      Response.Write "   ""fecha_ingreso"": """ & fecha_ingreso & """, "
      Response.Write "   ""area"": """ & area & """, "
      Response.Write "   ""tipo"": """ & tipo & """ "
      Response.Write "}"

   next
   Response.Write "         ]"
   Response.Write "}"
%>