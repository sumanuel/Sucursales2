<!--#include file="../funciones2.asp"-->
<% tipoPersonal = trim(request("tipoPersonal"))
codBtt = trim(request("codBtt"))
sql = ""
sql = sql & " select id_sucursal, "
sql = sql & " suc_nombre, "
sql = sql & " case suc_tipoid when '3' then 'LH' else 'IPS' end "
sql = sql & " from SUC_sucursal "
sql = sql & " where cod_bantotal = '"&codBtt&"'"
set rs = db.execute(sql)
if not rs.eof then
	idSucursal = trim(rs(0))
	nombreSucursal = trim(rs(1))
	tipo = trim(rs(2))
end if
'response.write(tipo)
if tipoPersonal = "1" then
	rutPersonal = trim(request("rutPersonal"))
	nombrePersonal = trim(request("nombrePersonal"))'&" "&trim(request("apepPaterno"))&" "&trim(request("apepMaterno"))
	empresa = trim(request("empresa"))
	sql = ""
	sql = sql & "exec SUC_prc_ing_guardias '"&tipoPersonal&"',"
	sql = sql & " '"&codBtt&"',"
	sql = sql & " '"&idSucursal&"',"
	sql = sql & " '"&nombreSucursal&"',"
	sql = sql & " '"&tipo&"', "
	sql = sql & " '"&rutPersonal&"',"
	sql = sql & " '"&nombrePersonal&"',"
	sql = sql & " '"&empresa&"',"
	sql = sql & " '','','','','' "
	db.execute(sql)
end if
if tipoPersonal = "2" then
	codBtt = trim(request("codBtt"))
	rutTitular = trim(request("rutTitular"))
	nombreReemplazo = trim(request("nombreReemplazo"))
	rutReemplazo = trim(request("rutReemplazo"))
	empresa = trim(request("empresa"))
	motivo = trim(request("motivo"))
	fechaDesde = cdate(trim(request("fechaDesde")))
	mesFechaDesde = month(fechaDesde)
	mes = mesFechaDesde
	if len(mesFechaDesde) = "1" then mesFechaDesde = "0"&mesFechaDesde
	anioFechaDesde = year(fechaDesde)
	diaFechaDesde = day(fechaDesde)
	if len(diaFechaDesde) = "1" then diaFechaDesde = "0"&diaFechaDesde

	fechaDesde = anioFechaDesde&"-"&mesFechaDesde&"-"&diaFechaDesde

	fechaHasta = cdate(trim(request("fechaHasta")))
	mesFechaHasta = month(fechaHasta)
	if len(mesFechaHasta) = "1" then mesFechaHasta = "0"&mesFechaHasta
	diaFechaHasta = day(fechaHasta)
	if len(diaFechaHasta) = "1" then diaFechaHasta = "0"&diaFechaHasta
	anioFechaHasta = year(fechaHasta)
	fechaHasta = anioFechaHasta&"-"&mesFechaHasta&"-"&diaFechaHasta

	sql = ""
	sql = sql & " exec SUC_prc_ing_guardias '"&tipoPersonal&"',"
	sql = sql & " '"&codBtt&"',"
	sql = sql & " '"&idSucursal&"',"
	sql = sql & " '"&nombreSucursal&"',"
	sql = sql & " '"&tipo&"',"
	sql = sql & " '"&rutReemplazo&"',"
	sql = sql & " '"&nombreReemplazo&"',"
	sql = sql & " '"&empresa&"',"
	sql = sql & " '"&mes&"',"
	sql = sql & " '"&fechaDesde&"',"
	sql = sql & " '"&fechaHasta&"',"
	sql = sql & " '"&motivo&"',"
	sql = sql & " '"&rutTitular&"' "
	db.execute(sql)
end if
if tipoPersonal = "3" then
	rutGuardia = trim(request("rutGuardia"))
	sql = ""
	sql = sql & " exec SUC_prc_ing_guardias '"&tipoPersonal&"',"
	sql = sql & " '','','','','"&rutGuardia&"','','','','','','','' "
	db.execute(sql)
end if
if tipoPersonal = "4" then ' ocupa el 5 tambien'
	rutGuardia = trim(request("rutGuardia"))
	nombreGuardia = trim(request("nombreGuardia"))
	sql = ""
	sql = sql & "select tipo_suc from SUC_sucursal_guardias_asistencia where guardia_rut = '"&rutGuardia&"'"
	set rs = db.execute(sql)
	if not rs.eof then
		tipoPersonal = trim(rs(0))
	end if
	if tipoPersonal= "titular" then 
		tipoPersonal = "4"
	else
		tipoPersonal = "5"
	end if

	sql = ""
	sql = sql & " exec SUC_prc_ing_guardias '"&tipoPersonal&"','','','','','"&rutGuardia&"','"&nombreGuardia&"','','','','','','' "
	db.execute(sql)
end if
'

%>