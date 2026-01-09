<!--#include file="../funciones.asp"-->
<%idRegional = trim(request("idRegional"))
idZonal = trim(request("idZonal"))
mes = trim(request("mes"))
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
sql = sql & " d.id_sucursal, "
sql = sql & " d.cod_bantotal, " 
sql = sql & " d.suc_nombre, "
sql = sql & " d.suc_jeps, "
sql = sql & " sum(isnull(e.Cantidad,0)) as cantidad, "
sql = sql & " sum(isnull(f.Cantidad,0)) as pagado "
sql = sql & " from vw_Total_Distrib_Pagos_Dia e "
sql = sql & " inner join vw_Total_Pagados_Sucursal_Dia f on e.SucBT = f.SucBT and e.Pago = f.Pago "
sql = sql & " and e.Mes  COLLATE Modern_Spanish_CI_AS = f.Mes  COLLATE Modern_Spanish_CI_AS "
sql = sql & " and e.usuario_zonal = f.usuario_zonal "
sql = sql & " and e.Fecha = f.Fecha "
sql = sql & " inner join SUC_sucursal d on e.SucBT = d.cod_bantotal "
sql = sql & " inner join SUC_zonales_sucursal c on d.id_sucursal = c.id_sucursal "
sql = sql & " where e.usuario_zonal = '"&idZonal&"' "
sql = sql & " and e.Pago = '"&pago&"' "
sql = sql & " and e.mes = '"&mes&"' " 
sql = sql & " group by d.id_sucursal, "
sql = sql & " d.cod_bantotal, "
sql = sql & " d.suc_nombre, "
sql = sql & " d.suc_jeps "
set rs = db.execute(sql)
varDatos = ""
i = 0
if not rs.eof then
	Do Until rs.EOF
		i = i+1
		idSucursal = trim(rs("id_sucursal"))
		codBtt = trim(rs("cod_bantotal"))
		sucNombre = server.htmlencode(trim(rs("suc_nombre")))
		sucJeps = server.htmlencode(trim(rs("suc_jeps")))
		emitidoCantidad = trim(rs("cantidad"))
		pagadoCantidad = trim(rs("pagado"))
		if emitidoCantidad > 0 then
			porcPag = formatpercent(pagadoCantidad/emitidoCantidad,1)
		else 
			porcPag = "0%"
		end if
		if right(porcPag,3) = ",0%" then
			valor = cint(replace(porcPag,"%",""))
			porcPag = valor&"%"
		end if
		varDatos =  varDatos & "{"
		varDatos = varDatos &  "   ""idCampo"": """ & i & """, "
		varDatos = varDatos &  "   ""idRegional"": """ & idRegional & """, "
		varDatos = varDatos &  "   ""idZonal"": """ & idZonal & """, "
		varDatos = varDatos &  "   ""idSucursal"": """ & idSucursal & """, "
		varDatos = varDatos &  "   ""codBtt"": """ & codBtt & """, "
		varDatos = varDatos &  "   ""sucNombre"": """ & sucNombre & """, "
		varDatos = varDatos &  "   ""sucJeps"": """ & sucJeps & """, "
		varDatos = varDatos &  "   ""emitidoCantidad"": """ & emitidoCantidad & """, "
		varDatos = varDatos &  "   ""pagadoCantidad"": """ & pagadoCantidad & """, "
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