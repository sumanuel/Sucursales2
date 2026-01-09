<!--#include file="../funciones.asp"-->
<% fechaActual = date()
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datos"": ["
totales = trim(request("totales"))
sql = ""
sql = sql & " select pago, "
if totales = "0" then
	sql = sql & " Disp_Qty, "
	sql = sql & " Disp_Tot, "
	sql = sql & " Paga_Qty, "
	sql = sql & " Paga_Tot "
else
	sql = sql & " DispH_Qty, "
	sql = sql & " DispH_Tot, "
	sql = sql & " PagaH_Qty, "
	sql = sql & " PagaH_Tot "
end if
sql = sql & " from  dbo.vw_Total_Maestro_Pagos "
'response.write(sql)
'response.end
set rs = db.execute(sql)
varDatos = ""
i = 0
if not rs.eof then
	Do Until rs.EOF
		claseTr = ""
		claseTd = ""
		pago = trim(rs("pago"))
		disponibleCantidad = trim(rs(1))
		disponibleCantidadNf = trim(rs(1))
		disponibleMonto = trim(rs(2))
		disponibleMontoNf = trim(rs(2))
		pagadoCantidad = trim(rs(3))
		pagadoCantidadNf = trim(rs(3))
		pagadoMonto = trim(rs(4))
		pagadoMontoNf = trim(rs(4))
		varDatos =  varDatos & "{"
		varDatos = varDatos &  "   ""pago"": """ & pago & """, "
		varDatos = varDatos &  "   ""disponibleCantidad"": """ & disponibleCantidad & """, "
		varDatos = varDatos &  "   ""disponibleCantidadNf"": """ & disponibleCantidadNf & """, "
		varDatos = varDatos &  "   ""disponibleMonto"": """ & disponibleMonto & """, "
		varDatos = varDatos &  "   ""disponibleMontoNf"": """ & disponibleMontoNf & """, "
		varDatos = varDatos &  "   ""pagadoCantidad"": """ & pagadoCantidad & """, "
		varDatos = varDatos &  "   ""pagadoCantidadNf"": """ & pagadoCantidadNf & """, "
		varDatos = varDatos &  "   ""pagadoMonto"": """ & pagadoMonto & """, "
		varDatos = varDatos &  "   ""pagadoMontoNf"": """ & pagadoMontoNf & """, "
		if pago = "Total" then	
			claseTr = "success"
			claseTd = "negritas "
		end if
		varDatos = varDatos &  "   ""claseTr"": """ & claseTr & """, "
		varDatos = varDatos &  "   ""claseTd"": """ & claseTd & """ "

		varDatos = varDatos &  "}"
		varDatos = varDatos & ","
		rs.Movenext
		i = i+1
	loop
	varDatos = left(varDatos,len(varDatos)-1)
end if
varDatos =  varDatos & "]"
varDatos =  varDatos &  "}"
response.write(varDatos)%>