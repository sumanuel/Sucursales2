<!--#include file="../funciones.asp"-->
<%anioTendencia = trim(request("anioTendencia"))
mesTendencia = trim(request("mesTendencia"))
tipo = trim(request("tipo"))
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datos"": ["
sql = ""
sql = sql & " select Pago, "
sql = sql & " Mes, "
sql = sql & " Fecha, " 
sql = sql & " Qty_disp, "
sql = sql & " Qty_pagado "
sql = sql & " from vw_Total_PagadosDisp_Dia "
sql = sql & " where year(fecha)= '"&anioTendencia&"' "
sql = sql & " and month(fecha) = '"&mesTendencia&"' "
if tipo = "1" then
	sql = sql & " and pago = 'IPS' "
end if
if tipo = "2" then
	sql = sql & " and pago = 'AFP' "
end if
sql = sql & " order by Fecha "
'response.write(sql) 

set rs = db.execute(sql)
varDatos = ""
if not rs.eof then
	Do Until rs.EOF
		pago = trim(rs("pago"))
		mes = trim(rs("mes"))
		fecha = replace(trim(rs("fecha")),"-","/")
		cantDisp = trim(rs("Qty_disp"))
		cantDispF = trim(rs("Qty_disp"))
		cantPag = trim(rs("Qty_pagado"))
		cantPagF = trim(rs("Qty_pagado"))
		varDatos =  varDatos & "{"
		varDatos = varDatos &  "   ""pago"": """ & pago & """, "
		varDatos = varDatos &  "   ""mes"": """ & mes & """, "
		varDatos = varDatos &  "   ""fecha"": """ & fecha & """, "
		varDatos = varDatos &  "   ""cantDisp"": """ & cantDisp & """, "
		varDatos = varDatos &  "   ""cantPag"": """ & cantPag & """, "
		varDatos = varDatos &  "   ""cantDispF"": """ & cantDispF & """, "
		varDatos = varDatos &  "   ""cantPagF"": """ & cantPagF & """ "
		varDatos = varDatos &  "}"
		varDatos = varDatos & ","
		rs.Movenext
	loop
	varDatos = left(varDatos,len(varDatos)-1)
end if
varDatos =  varDatos & "]"
varDatos =  varDatos &  "}"
response.write(varDatos)%>