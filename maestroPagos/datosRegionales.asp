<!--#include file="../funciones.asp"-->
<%mes = trim(request("mes"))
tipo = trim(request("tipo"))
if tipo = "1" then
	pago = "IPS"
else
	pago = "AFP"
end if
response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datos"": ["
sql = ""
sql = sql & " select "
sql = sql & " distinct(b.id_regional) as idRegional, "
sql = sql & " a.nombre_regional "
sql = sql & " from SUC_regionales a, "
sql = sql & " SUC_zonales b, "
sql = sql & " SUC_zonales_sucursal c, "
sql = sql & " SUC_sucursal d "
sql = sql & " where a.id_regional = b.id_regional_p "
sql = sql & " and b.id_usuario =  c.id_zonal "
sql = sql & " and c.id_sucursal = d.id_sucursal "
sql = sql & " and estado_zonal = 1 "
set rs = db.execute(sql)
varDatos = ""
i = 0
if not rs.eof then
	Do Until rs.EOF
		i = i+1
		idRegional = trim(rs("idRegional"))
		nombreRegional = server.htmlencode(trim(rs("nombre_regional")))
		sql2 = ""
		sql2 = sql2 & " SELECT sum(Cantidad) as cantidad "
		sql2 = sql2 & " ,sum(Monto) as monto "
		sql2 = sql2 & " FROM vw_Total_Distrib_Pagos_Dia "
		sql2 = sql2 & " where id_regional = '"&idRegional&"' "
		sql2 = sql2 & " and pago = '"&pago&"' "
		sql2 = sql2 & " and mes = '"&mes&"' "
		'response.write(sql2)
		'response.end
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
		sql2 = sql2 & " where id_regional = '"&idRegional&"' "
		sql2 = sql2 & " and pago = '"&pago&"' "
		sql2 = sql2 & " and mes = '"&mes&"' "
		'response.write(sql2)
		set rs2 = db.execute(sql2)
		if not rs2.eof then
			pagadoCantidad = formatnumber(trim(rs2(0)),0)
			pagadoMonto = trim(rs2(1))
			pagadoMontoMuestra = acortaNumero(pagadoMonto)
			pagadoMonto = formatnumber(pagadoMonto,0)
		end if
		varDatos =  varDatos & "{"
		varDatos = varDatos &  "   ""idCampo"": """ & i & """, "
		varDatos = varDatos &  "   ""idRegional"": """ & idRegional & """, "
		varDatos = varDatos &  "   ""nombreRegional"": """ & nombreRegional & """, "
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