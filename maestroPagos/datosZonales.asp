<!--#include file="../funciones.asp"-->
<%mes = trim(request("mes"))
tipo = trim(request("tipo"))
idRegional = trim(request("idRegional"))
if tipo = "1" then
	pago = "IPS"
else
	pago = "AFP"
end if
response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datos"": ["
sql = ""
sql = sql & " select  distinct(b.id_usuario) as idZonal, "
sql = sql & " b.zonal_nombre +' '+b.zonal_apep+' '+b.zonal_apem as nombreZonal "
sql = sql & " from SUC_regionales a, "
sql = sql & " SUC_zonales b, "
sql = sql & " SUC_zonales_sucursal c, "
sql = sql & " SUC_sucursal d "
sql = sql & " where a.id_regional = b.id_regional_p "
sql = sql & " and b.id_usuario =  c.id_zonal "
sql = sql & " and c.id_sucursal = d.id_sucursal "
sql = sql & " and estado_zonal = 1 "
sql = sql & " and b.id_regional = '"&idRegional&"' "
set rs = db.execute(sql)
varDatos = ""
i = 0
if not rs.eof then
	Do Until rs.EOF
		i = i+1
		idZonal = trim(rs("idZonal"))
		nombreZonal = server.htmlencode(trim(rs("nombreZonal")))
		sql2 = ""
		sql2 = sql2 & " SELECT sum(Cantidad) as cantidad "
		sql2 = sql2 & " ,sum(Monto) as monto "
		sql2 = sql2 & " FROM vw_Total_Distrib_Pagos_Dia "
		sql2 = sql2 & " where usuario_zonal = '"&idZonal&"' "
		sql2 = sql2 & " and pago = '"&pago&"' "
		sql2 = sql2 & " and mes = '"&mes&"' "
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			emitidoCantidad = formatnumber(trim(rs2(0)),0)
			emitidoMonto = trim(rs2(1))
			emitidoMontoMuestra = acortaNumero(emitidoMonto)
			emitidoMonto = formatnumber(emitidoMonto,0)
		end if
		sql2 = ""
		sql2 = sql2 & " SELECT sum(Cantidad) as cantidad "
		sql2 = sql2 & " ,sum(Monto) as monto "
		sql2 = sql2 & " FROM vw_Total_Pagados_Sucursal_Dia "
		sql2 = sql2 & " where usuario_zonal = '"&idZonal&"' "
		sql2 = sql2 & " and pago = '"&pago&"' "
		sql2 = sql2 & " and mes = '"&mes&"' "
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			pagadoCantidad = formatnumber(trim(rs2(0)),0)
			pagadoMonto = trim(rs2(1))
			pagadoMontoMuestra = acortaNumero(pagadoMonto)
			pagadoMonto = formatnumber(pagadoMonto,0)
		end if
		varDatos =  varDatos & "{"
		varDatos = varDatos &  "   ""idCampo"": """ & i & """, "
		varDatos = varDatos &  "   ""idZonal"": """ & idZonal & """, "
		varDatos = varDatos &  "   ""nombreZonal"": """ & nombreZonal & """, "
		varDatos = varDatos &  "   ""emitidoCantidad"": """ & emitidoCantidad & """, "
		varDatos = varDatos &  "   ""emitidoMonto"": """ & emitidoMonto & """, "
		varDatos = varDatos &  "   ""emitidoMontoMuestra"": """ & emitidoMontoMuestra & """, "
		varDatos = varDatos &  "   ""pagadoCantidad"": """ & pagadoCantidad & """, "
		varDatos = varDatos &  "   ""pagadoMonto"": """ & pagadoMonto & """, "
		varDatos = varDatos &  "   ""pagadoMontoMuestra"": """ & pagadoMontoMuestra & """ "
		varDatos = varDatos &  "}"
		varDatos = varDatos & ","
		rs.Movenext
	loop
	varDatos = left(varDatos,len(varDatos)-1)
end if
varDatos =  varDatos & "]"
varDatos =  varDatos &  "}"
response.write(varDatos)%>