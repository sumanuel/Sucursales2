<!--#include file="../funciones.asp"-->
<%idRegional = trim(request("idRegional"))
idZonal = trim(request("idZonal"))
mes = trim(request("mes"))
tipo = trim(request("tipo"))
idSucursal = trim(request("idSucursal"))
if tipo = "1" then
	pago = "IPS"
else
	pago = "AFP"
end if
response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datos"": ["

sql = ""
sql = sql & " select  "
sql = sql & " isnull(e.Cantidad,0) as cantidad, "
sql = sql & " isnull(f.Cantidad,0) as pagado, "
sql = sql & " d.suc_nombre, "
sql = sql & " d.suc_jeps, "
sql = sql & " e.Fecha "
sql = sql & " from vw_Total_Distrib_Pagos_Dia e "
sql = sql & " inner join ( select z.Pago, "
sql = sql & " z.Mes, "
sql = sql & " z.Fecha, "
sql = sql & " z.SucBT, "
sql = sql & " z.usuario_zonal, "
sql = sql & " sum(z.Cantidad) as Cantidad, "
sql = sql & " sum(z.Monto) as Monto "
sql = sql & " from vw_Total_Pagados_Sucursal_Dia z "
sql = sql & " group by z.Pago,"
sql = sql & " z.Mes, "
sql = sql & " z.Fecha, "
sql = sql & " z.SucBT, "
sql = sql & " z.usuario_zonal "
sql = sql & " ) f "
sql = sql & " on e.SucBT = f.SucBT "
sql = sql & " and e.Pago = f.Pago "
sql = sql & " and convert(int,e.Mes) = convert(int,f.Mes) "
sql = sql & " and e.usuario_zonal = f.usuario_zonal "
sql = sql & " and e.Fecha = f.Fecha "
sql = sql & " inner join SUC_sucursal d "
sql = sql & " on e.SucBT = d.cod_bantotal " 
sql = sql & " where d.cod_bantotal = '"&idSucursal&"' "
sql = sql & " and e.Pago = '"&pago&"' "
sql = sql & " and e.mes = '"&mes&"'  "
'response.write(sql)
'response.end
set rs = db.execute(sql)
varDatos = ""
i = 0
if not rs.eof then
	Do Until rs.EOF
		i = i+1
		emitidoCantidad = trim(rs("cantidad"))
		pagadoCantidad = trim(rs("pagado"))
		fecha = replace(trim(rs("fecha")),"-","\/")
		sucNombre = trim(rs("suc_nombre"))
		sucJeps = trim(rs("suc_jeps"))
		if emitidoCantidad > 0 then
			porcPag = formatpercent(pagadoCantidad/emitidoCantidad,1)
		else 
			porcPag = "0%"
		end if
		if right(porcPag,3) = ",0%" then
			valor = cint(replace(porcPag,"%",""))
			porcPag = valor&"%"
		end if
		emitidoCantidadValor = emitidoCantidad
		pagadoCantidadValor = pagadoCantidad
		emitidoCantidad = formatnumber(emitidoCantidad,0)
		pagadoCantidad = formatnumber(pagadoCantidad,0)
		varDatos =  varDatos & "{"
		varDatos = varDatos &  "   ""idCampo"": """ & i & """, "
		varDatos = varDatos &  "   ""fecha"": """ & fecha & """, "
		varDatos = varDatos &  "   ""sucNombre"": """ & sucNombre & """, "
		varDatos = varDatos &  "   ""sucJeps"": """ & sucJeps & """, "
		varDatos = varDatos &  "   ""emitidoCantidad"": """ & emitidoCantidad & """, "
		varDatos = varDatos &  "   ""pagadoCantidad"": """ & pagadoCantidad & """, "
		varDatos = varDatos &  "   ""emitidoCantidadValor"": """ & emitidoCantidadValor & """, "
		varDatos = varDatos &  "   ""pagadoCantidadValor"": """ & pagadoCantidadValor & """, "
		varDatos = varDatos &  "   ""porcPag"": """ & porcPag & """ "
		varDatos = varDatos &  "}"
		varDatos = varDatos & ","
		rs.Movenext
	loop
	varDatos = left(varDatos,len(varDatos)-1)
end if
varDatos =  varDatos & "]"
varDatos =  varDatos &  "}"
response.write(varDatos)%>