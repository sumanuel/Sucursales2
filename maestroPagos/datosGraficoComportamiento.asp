<!--#include file="../funciones.asp"-->
<%tipoGrafico = trim(request("tipoGrafico"))
fecha = trim(request("fecha"))
if tipoGrafico = "0" then tipoGrafico = "Total"
if tipoGrafico = "1" then tipoGrafico = "IPS"
if tipoGrafico = "2" then tipoGrafico = "AFP"
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datos"": ["
sql = ""
sql = sql & " select  Pago, "
sql = sql & " Mes, "
sql = sql & " Fecha, " 
sql = sql & " Qty_disp, "
sql = sql & " Qty_pagado "
sql = sql & " from dbo.vw_Total_Pagos_Dia "
sql = sql & " where Pago = '"&tipoGrafico&"' "
sql = sql & " and mes >= '"&fecha&"'"
sql = sql & " order by fecha "
'response.write(sql) 

set rs = db.execute(sql)
varDatos = ""
if not rs.eof then
	Do Until rs.EOF
		pago = trim(rs("pago"))
		mes = trim(rs("mes"))
		fecha = replace(trim(rs("fecha")),"-","/")
		cantDisp = trim(rs("Qty_disp"))
		cantPag = trim(rs("Qty_pagado"))
		varDatos =  varDatos & "{"
		varDatos = varDatos &  "   ""pago"": """ & pago & """, "
		varDatos = varDatos &  "   ""mes"": """ & mes & """, "
		varDatos = varDatos &  "   ""fecha"": """ & fecha & """, "
		varDatos = varDatos &  "   ""cantDisp"": """ & cantDisp & """, "
		varDatos = varDatos &  "   ""cantPag"": """ & cantPag & """ "
		varDatos = varDatos &  "}"
		varDatos = varDatos & ","
		rs.Movenext
	loop
	varDatos = left(varDatos,len(varDatos)-1)
end if
varDatos =  varDatos & "]"
varDatos =  varDatos &  "}"
response.write(varDatos)%>