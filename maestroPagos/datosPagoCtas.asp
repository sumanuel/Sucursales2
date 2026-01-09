<!--#include file="../funciones.asp"-->
<%mes = trim(request("mes"))
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datos"": ["
sql = ""
sql = sql & " SELECT Fecha "
sql = sql & " ,Cantidad "
sql = sql & " ,Monto "
sql = sql & " FROM SCSS.dbo.vw_Total_Pago_Cuentas_Dia "
sql = sql & " where Mes = '"&mes&"' "
sql = sql & " order by Fecha " 
set rs = db.execute(sql)
varDatos = ""
sumaCantidad = 0
sumaMonto = 0
if not rs.eof then
	Do Until rs.EOF
		fecha = trim(rs("fecha"))
		cantidad = trim(rs("cantidad"))
		cantidadF = cantidad
		monto = trim(rs("monto"))
		montoF = monto
		sumaCantidad = cint(cantidad) + sumaCantidad
		sumaCantidadF = sumaCantidad
		sumaMonto = clng(monto) + sumaMonto
		sumaMontoF = sumaMonto
		varDatos =  varDatos & "{"
		varDatos = varDatos &  "   ""fecha"": """ & fecha & """, "
		varDatos = varDatos &  "   ""cantidad"": """ & cantidad & """, "
		varDatos = varDatos &  "   ""cantidadF"": """ & cantidadF & """, "
		varDatos = varDatos &  "   ""monto"": """ & monto & """, "
		varDatos = varDatos &  "   ""montoF"": """ & montoF & """, "
		varDatos = varDatos &  "   ""sumaCantidad"": """ & sumaCantidad & """, "
		varDatos = varDatos &  "   ""sumaCantidadF"": """ & sumaCantidadF & """, "
		varDatos = varDatos &  "   ""sumaMonto"": """ & sumaMonto & """, "
		varDatos = varDatos &  "   ""sumaMontoF"": """ & sumaMontoF & """ "
		varDatos = varDatos &  "}"
		varDatos = varDatos & ","
		rs.Movenext
	loop
	varDatos = left(varDatos,len(varDatos)-1)
end if
varDatos =  varDatos & "]"
varDatos =  varDatos &  "}"
response.write(varDatos)
%>