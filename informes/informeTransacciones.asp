<!--#include file="../funciones.asp"-->
<%tipoConsulta = trim(request("tipoConsulta"))
if tipoConsulta = "1" then
	base = "SUC_transacciones_diarias"
	archivo = "Informe diario transacciones "
end if
if tipoConsulta = "2" then
	base = "SUC_transacciones_acumuladas"
	archivo = "Informe acumulado transacciones "
end if
sql = ""
sql = sql & " select cod_sucursal, "
sql = sql & " nombre_sucursal, "
sql = sql & " pagos2, "
sql = sql & " ppaa, "
sql = sql & " leasing, "
sql = sql & " nominas, "
sql = sql & " recCred, "
sql = sql & " trasCaja, "
sql = sql & " ingCaja, "
sql = sql & " creSocial, "
sql = sql & " reDistr, "
sql = sql & " pagosAFP, "
sql = sql & " pagosIPS, "
sql = sql & " licencias, "
sql = sql & " CONVERT(DATETIME, CONVERT(CHAR(8), fecha)) as fecha "
sql = sql & " from "
sql = sql & base
sql = sql & "  where CONVERT(DATETIME, CONVERT(CHAR(8), fecha)) = ( select "
sql = sql & " max(CONVERT(DATETIME, CONVERT(CHAR(8), fecha))) "
sql = sql & " from "&base&") "
sql = sql & " order by nombre_sucursal asc"
set rs = db.execute(sql)

'response.write(sql)
'response.end

if not rs.eof then
	datos = rs.GetRows()
	resultado = ""
	resultado = resultado & "<table>"
	resultado = resultado & "<thead>"
	resultado = resultado & "<tr class='borde'>"
	resultado = resultado & "<th>Codigo sucursal</th>"
	resultado = resultado & "<th>Nombre sucursal</th>"
	resultado = resultado & "<th>Pagos 2%</th>"
	resultado = resultado & "<th>Pagos PPAA</th>"
	resultado = resultado & "<th>Pagos Leasing</th>"
	resultado = resultado & "<th>Recaudación Nóminas</th>"
	resultado = resultado & "<th>Recaudación Créditos (Prepago Voluntario Cliente)</th>"
	resultado = resultado & "<th>Traspaso entre Cajas</th>"
	resultado = resultado & "<th>Ingreso a Caja</th>"
	resultado = resultado & "<th>Pago de Crédito Social</th>"
	resultado = resultado & "<th>Recaudación por Distribuir</th>"
	resultado = resultado & "<th>Pago Pensiones AFP</th>"
	resultado = resultado & "<th>Pago Pensiones IPS</th>"
	resultado = resultado & "<th>Pago Licencias</th>"
	resultado = resultado & "</tr>"
	resultado = resultado & "</thead>"
	resultado = resultado & "<tbody>"
	for i=0 to ubound(datos,2)
		codSucursal = trim(datos(0,i))
		nombreSucursal = server.htmlencode(trim(datos(1,i)))
		pagos2 = trim(datos(2,i))
		ppaa = trim(datos(3,i))
		leasing = trim(datos(4,i))
		nominas = trim(datos(5,i))
		recCred = trim(datos(6,i))
		trasCaja = trim(datos(7,i))
		ingCaja = trim(datos(8,i))
		creSocial = trim(datos(9,i))
		reDistr = trim(datos(10,i))
		pagosAFP = trim(datos(11,i))
		pagosIPS = trim(datos(12,i))
		licencias = trim(datos(13,i))
		fecha = cdate(trim(datos(14,i)))
		diaFecha = formateaParaFecha(day(fecha))
		mesFecha = formateaParaFecha(month(fecha))
		anioFecha = year(fecha)
		fecha = anioFecha&"-"&mesFecha&"-"&diaFecha
		resultado = resultado & "<tr>"
		resultado = resultado & "<td>"&codSucursal&"</td>"
		resultado = resultado & "<td>"&nombreSucursal&"</td>"
		resultado = resultado & "<td>"&pagos2&"</td>"
		resultado = resultado & "<td>"&ppaa&"</td>"
		resultado = resultado & "<td>"&leasing&"</td>"
		resultado = resultado & "<td>"&nominas&"</td>"
		resultado = resultado & "<td>"&recCred&"</td>"
		resultado = resultado & "<td>"&trasCaja&"</td>"
		resultado = resultado & "<td>"&ingCaja&"</td>"
		resultado = resultado & "<td>"&creSocial&"</td>"
		resultado = resultado & "<td>"&reDistr&"</td>"
		resultado = resultado & "<td>"&pagosAFP&"</td>"
		resultado = resultado & "<td>"&pagosIPS&"</td>"
		resultado = resultado & "<td>"&licencias&"</td>"
		resultado = resultado & "</tr>"
	next

	resultado = resultado & "</tbody>"
	resultado = resultado & "</table>"
	diaFecha = formateaParaFecha(day(fecha))
	mesFecha = formateaParaFecha(month(fecha))
	anioFecha = year(fecha)
	fecha = anioFecha&"-"&mesFecha&"-"&diaFecha

	archivo = archivo&fecha&".xls"
	'response.write(resultado)
end if

response.write(resultado)
Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo %>