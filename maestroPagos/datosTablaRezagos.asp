<!--#include file="../funciones.asp"-->
<% fechaActual = date()
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datos"": ["
sql = ""
sql = sql & " select Pago, "
sql = sql & " Disp_IQty, "
sql = sql & " Disp_ITot, "
sql = sql & " Disp_AQty, "
sql = sql & " Disp_ATot, "
sql = sql & " Paga_IQty, "
sql = sql & " Paga_ITot, "
sql = sql & " Paga_AQty, "
sql = sql & " Paga_ATot "
sql = sql & " from dbo.vw_Total_Rezagos_Maestro_Pagos "
set rs = db.execute(sql)
varDatos = ""
i = 0
if not rs.eof then
	Do Until rs.EOF
		claseTr = ""
		claseTd = ""
		pago = trim(rs("pago"))
		mes = DateAdd("m",-i,fechaActual)
		nombreMes = primeraMayuscula(monthName(month(mes)))
		if i = "3" then	nombreMes = "Total"
		Disp_IQty = formatnumber(trim(rs("Disp_IQty")),0)
		Disp_ITot = formatnumber(trim(rs("Disp_ITot")),0)
		Disp_AQty = formatnumber(trim(rs("Disp_AQty")),0)
		Disp_ATot = formatnumber(trim(rs("Disp_ATot")),0)
		Paga_IQty = formatnumber(trim(rs("Paga_IQty")),0)
		Paga_ITot = formatnumber(trim(rs("Paga_ITot")),0)
		Paga_AQty = formatnumber(trim(rs("Paga_AQty")),0)
		Paga_ATot = formatnumber(trim(rs("Paga_ATot")),0)
		Disp_IQtyNf = trim(rs("Disp_IQty"))
		Disp_ITotNf = trim(rs("Disp_ITot"))
		Disp_AQtyNf = trim(rs("Disp_AQty"))
		Disp_ATotNf = trim(rs("Disp_ATot"))
		Paga_IQtyNf = trim(rs("Paga_IQty"))
		Paga_ITotNf = trim(rs("Paga_ITot"))
		Paga_AQtyNf = trim(rs("Paga_AQty"))
		Paga_ATotNf = trim(rs("Paga_ATot"))
		varDatos =  varDatos & "{"
		varDatos = varDatos &  "   ""pago"": """ & pago & """, "
		varDatos = varDatos &  "   ""mes"": """ & i & """, "
		varDatos = varDatos &  "   ""nombreMes"": """ & nombreMes & """, "
		varDatos = varDatos &  "   ""Disp_IQty"": """ & Disp_IQty & """, "
		varDatos = varDatos &  "   ""Disp_ITot"": """ & Disp_ITot & """, "
		varDatos = varDatos &  "   ""Disp_AQty"": """ & Disp_AQty & """, "
		varDatos = varDatos &  "   ""Disp_ATot"": """ & Disp_ATot & """, "
		varDatos = varDatos &  "   ""Paga_IQty"": """ & Paga_IQty & """, "
		varDatos = varDatos &  "   ""Paga_ITot"": """ & Paga_ITot & """, "
		varDatos = varDatos &  "   ""Paga_AQty"": """ & Paga_AQty & """, "
		varDatos = varDatos &  "   ""Paga_ATot"": """ & Paga_ATot & """, "
		varDatos = varDatos &  "   ""Disp_IQtyNf"": """ & Disp_IQtyNf & """, "
		varDatos = varDatos &  "   ""Disp_ITotNf"": """ & Disp_ITotNf & """, "
		varDatos = varDatos &  "   ""Disp_AQtyNf"": """ & Disp_AQtyNf & """, "
		varDatos = varDatos &  "   ""Disp_ATotNf"": """ & Disp_ATotNf & """, "
		varDatos = varDatos &  "   ""Paga_IQtyNf"": """ & Paga_IQtyNf & """, "
		varDatos = varDatos &  "   ""Paga_ITotNf"": """ & Paga_ITotNf & """, "
		varDatos = varDatos &  "   ""Paga_AQtyNf"": """ & Paga_AQtyNf & """, "
		varDatos = varDatos &  "   ""Paga_ATotNf"": """ & Paga_ATotNf & """, "
		if i = "3" then	
			claseTr = "info"
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
response.write(varDatos)
%>