<!--#include file="../funciones2.asp"-->
<%
perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
'fecha = "2015-02-17"
fecha = date()
sqlPerfil = ""
if perfil = "55" then 	
	sqlPerfil = sqlPerfil & " (select id_sucursal "
	sqlPerfil = sqlPerfil & " from SUC_zonales_comercial_sucursal "
	sqlPerfil = sqlPerfil & " where id_zonal = '"&idUsuario&"')"
elseif perfil = "66" then 	
	sqlPerfil = sqlPerfil & " (select id_sucursal "
	sqlPerfil = sqlPerfil & " from SUC_zonales_comercial_mas_sucursal "
	sqlPerfil = sqlPerfil & " where id_zonal = '"&idUsuario&"')"
else 
	sqlPerfil = sqlPerfil & " (select id_sucursal "
	sqlPerfil = sqlPerfil & " from SUC_usuario_sucursal "
	sqlPerfil = sqlPerfil & " where id_usuario = '"&idUsuario&"')"
end if
sql = ""
sql = sql & " select count(id_sucursal) as totalSucursales"
sql = sql & " from suc_sucursal "
sql = sql & " where suc_estado = 1 and id_sucursal in "
sql = sql & sqlPerfil

'response.write(sql)
'response.end

set rs = db.execute(sql)

if not rs.eof then
  totalSucursales= clng(trim(rs("totalSucursales")))
end if
totalSucursales = round(totalSucursales / 2) 

sql = ""
sql = sql & " select "
sql = sql & " SUC.id_sucursal "
sql = sql & " ,SUC.suc_nombre "
sql = sql & " ,ISNULL(SAPER.horaApertura, '1900-01-01 00:00:00.000') as horaApertura "
sql = sql & " ,ISNULL(DESN.desnomal,'')	  as desnomal "
sql = sql & " ,ISNULL(DESN.horanormal,'') as horanormal "
sql = sql & " ,ISNULL(DESIPS.desips,'')	  as desips "
sql = sql & " ,ISNULL(DESIPS.horaips,'')  as horaips "
sql = sql & " ,ISNULL(DESAFP.desafp,'')	  as desafp "
sql = sql & " ,ISNULL(DESAFP.horaafp,'')  as horaafp "
sql = sql & " from suc_sucursal SUC "
sql = sql & " inner join SUC_usuario_sucursal USUC on SUC.id_sucursal = USUC.id_sucursal "
sql = sql & " left join ( "
sql = sql & " select id_sucursal, cast(hora_ingreso as datetime) horaApertura from SUC_sucursal_apertura where tipo = 1 and cast(fecha_ingreso as date) = cast(getdate() as date) "
sql = sql & " ) SAPER on SUC.id_sucursal = SAPER.id_sucursal "
sql = sql & " left join ( "
sql = sql & " select id_sucursal, situacion desnomal, convert(varchar(8), hora) as horanormal from SUC_desbordes DES1 "
sql = sql & " where id_des in (select MAX(DES2.id_des) from SUC_desbordes DES2 where DES2.fecha = cast(getdate() as date)  "
sql = sql & " and DES2.tipo = 0 and DES2.situacion not in ('Full','Desbordes') and DES2.id_sucursal = DES1.id_sucursal)  "
sql = sql & " ) DESN ON SUC.id_sucursal = DESN.id_sucursal "
sql = sql & " left join ( "
sql = sql & " select id_sucursal, 'IPS' tipo, situacion desips,  convert(varchar(8), hora) as horaips from SUC_desbordes DES1 "
sql = sql & " where DES1.id_des = ( select MAX(DES2.id_des) from SUC_desbordes DES2 where DES2.fecha = cast(getdate() as date)  "
sql = sql & " and DES2.tipo = 2 and DES2.id_sucursal = DES1.id_sucursal)  "
sql = sql & " ) DESIPS on SUC.id_sucursal = DESIPS.id_sucursal "
sql = sql & " left join ( "
sql = sql & " select id_sucursal, 'AFP' tipo, situacion desafp,  convert(varchar(8), hora) as horaafp from SUC_desbordes DES1 "
sql = sql & " where DES1.id_des = ( select MAX(DES2.id_des) from SUC_desbordes DES2 where DES2.fecha = cast(getdate() as date) " 
sql = sql & " and DES2.tipo = 1 and DES2.id_sucursal = DES1.id_sucursal) " 
sql = sql & " ) DESAFP on SUC.id_sucursal = DESAFP.id_sucursal "
sql = sql & " where SUC.suc_estado = 1 " 
sql = sql & " and USUC.id_usuario = '"&idUsuario&"' "
'response.write(sql)
'response.end
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getrows()
end if
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""dataAperturaSucursales"": ["
for i = 0 to ubound(datos,2)

	nombreSucursal = server.htmlencode(trim(datos(1,i)))
	nombreSucursalSinCaract = trim(datos(1,i))
	idSucursal = trim(datos(0,i))
	horaApertura = trim(datos(2,i))

	'response.write("horaApertura: " & horaApertura)
	'response.end

	situacionSucursalNormal = trim(datos(3,i))
	situacionSucursalHoraNormal = trim(datos(4,i))
	situacionSucursalIPS = trim(datos(5,i))
	situacionSucursalHoraIPS = trim(datos(6,i))
	situacionSucursalAFP = trim(datos(7,i))
	situacionSucursalHoraAFP = trim(datos(8,i))
	sucursalAbierta = 0

	if horaApertura <> "1900-01-01 00:00:00.000" then
		sucursalAbierta = 1	
		horaMuestraHora = formateaParaFecha(hour(horaApertura))
		minutoMuestraHora = formateaParaFecha(minute(horaApertura))
		muestraHora = horaMuestraHora&":"&minutoMuestraHora
		horaMinutosApertura = hour(horaApertura) * 60
		minutosApertura = horaMinutosApertura + minute(horaApertura)
		if minutosApertura >= 530 then 'minutos de las 8:50'
			sucursalAbierta = 2
		end if
	else
		sucursalAbierta = 0
		situacionSucursalNormal = "No abierta"
		claseSituacionNormal = "label label-important"
		clasePlazo = "label-important"
		textoPlazo = "No abierta"
		muestraHora = "--"
		situacionSucursalHoraNormal = "--"
		situacionSucursalAFP = ""
		situacionSucursalHoraAFP = ""
		claseSituacionAFP = ""
		ituacionSucursalIPS = ""
		situacionSucursalHoraIPS = ""
		claseSituacionIPS = ""

		claseSituacionNormal = "label label-important"
		situacionSucursalNormal = "Cerrada"
		situacionSucursalHoraNormal = ""
	end if
	
	select case situacionSucursalNormal
		case "":
			claseSituacionNormal = "label"
		case "1/4":
			claseSituacionNormal = "label label-success"
		case "1/2":
			claseSituacionNormal = "label label-success"
		case "3/4":
			claseSituacionNormal = "label label-success"
	end select
	
	select case situacionSucursalAFP
		case "":
			claseSituacionAFP = "label"
		case "Full":
			claseSituacionAFP = "label label-warning"
		case "Desborde":
			claseSituacionAFP = "label label-important"
	end select	
	
	select case situacionSucursalIPS
		case "":
			claseSituacionIPS = "label"
		case "Full":
			claseSituacionIPS = "label label-warning"
		case "Desborde":
			claseSituacionIPS = "label label-important"
	end select		

	if sucursalAbierta = 1 then
		clasePlazo = "label-success"
		textoPlazo = "DP"
	end if
	if sucursalAbierta = 2 then
		clasePlazo = "label label-warning"
		textoPlazo = "FP"
	end if
	if i = totalSucursales then
		divide = 1
	else
		divide = 0
	end if

	response.write "{"
	Response.Write "   ""nombreSucursal"": """ & nombreSucursal & """, "
	Response.Write "   ""nombreSucursalSinCaract"": """ & nombreSucursalSinCaract & """, "
	Response.Write "   ""idSucursal"": """ & idSucursal & """, "
	Response.Write "   ""sucursalAbierta"": """ & sucursalAbierta & """, "
	Response.Write "   ""muestraHora"": """ & muestraHora & """, "
	Response.Write "   ""situacionSucursalNormal"": """ & situacionSucursalNormal & """, "
	Response.Write "   ""situacionSucursalHoraNormal"": """ & situacionSucursalHoraNormal & """, "
	Response.Write "   ""claseSituacionNormal"": """ & claseSituacionNormal & """, "
	Response.Write "   ""situacionSucursalAFP"": """ & situacionSucursalAFP & """, "
	Response.Write "   ""situacionSucursalHoraAFP"": """ & situacionSucursalHoraAFP & """, "
	Response.Write "   ""claseSituacionAFP"": """ & claseSituacionAFP & """, "
	Response.Write "   ""situacionSucursalIPS"": """ & situacionSucursalIPS & """, "
	Response.Write "   ""situacionSucursalHoraIPS"": """ & situacionSucursalHoraIPS & """, "
	Response.Write "   ""claseSituacionIPS"": """ & claseSituacionIPS & """, "
	Response.Write "   ""divide"": """ & divide & """, "
	Response.Write "   ""clasePlazo"": """ & clasePlazo & """, "
	Response.Write "   ""textoPlazo"": """ & textoPlazo & """ "
	response.write "}"
	if i <> ubound(datos,2) then response.write(",")
next


'sql = ""
'sql = sql & " select id_sucursal,"
'sql = sql & " suc_nombre "
'sql = sql & " from suc_sucursal "
'sql = sql & " where suc_estado = 1 and id_sucursal in "
'sql = sql & sqlPerfil

'response.write(sql)
'response.end

'set rs = db.execute(sql)
'if not rs.eof then
'	datos = rs.getrows()
'end if
'Response.ContentType = "application/json"
'Response.Write "{"
'Response.Write "  ""dataAperturaSucursales"": ["
'for i = 0 to ubound(datos,2)
''	nombreSucursal = server.htmlencode(trim(datos(1,i)))
''	nombreSucursalSinCaract = trim(datos(1,i))
''	idSucursal = trim(datos(0,i))
''	sql = ""
''	sql = sql & " set dateformat dmy  "
''	sql = sql & " select cast(hora_ingreso as datetime) horaApertura "
''	sql = sql & " from SUC_sucursal_apertura "
''	sql = sql & " where id_sucursal = '"&idSucursal&"' "
''	sql = sql & " and cast (fecha_ingreso as date) = cast( '"&fecha&"' as date)"
''	'sql = sql & " and  fecha_ingreso = cast (GETDATE() as DATE) "
''	sql = sql & " and tipo = 1 "
	
	'response.write(sql)
	'response.end

''	set rs = db.execute(sql)
''	if not rs.eof then
''		sucursalAbierta = 1
''		horaApertura = trim(rs("horaApertura"))
''		horaMuestraHora = formateaParaFecha(hour(horaApertura))
''		minutoMuestraHora = formateaParaFecha(minute(horaApertura))
''		muestraHora = horaMuestraHora&":"&minutoMuestraHora
''		horaMinutosApertura = hour(horaApertura) * 60
''		minutosApertura = horaMinutosApertura + minute(horaApertura)
''		if minutosApertura >= 530 then 'minutos de las 8:50'
''			sucursalAbierta = 2
''		end if
''		if sucursalAbierta = 1 or sucursalAbierta = 2 then
''			'normales'
''			sql2 = ""
''			sql2 = sql2 & " select situacion, "
''			sql2 = sql2 & " convert(varchar(5), hora) as hora "
''			sql2 = sql2 & " from SUC_desbordes where id_des = ( "
''			sql2 = sql2 & " select MAX(id_des) "
''			sql2 = sql2 & " from SUC_desbordes "
''			sql2 = sql2 & " where "
''			sql2 = sql2 & " fecha = cast( '"&fecha&"' as date)"
''			sql2 = sql2 & " and tipo = 0 "
''			sql2 = sql2 & " and situacion not in ('Full','Desbordes') "
''			sql2 = sql2 & " and id_sucursal = '"&idSucursal&"') "
''			
''			'response.write(sql2)
''			'response.end
''
''			set rs2 = db.execute(sql2)
''			if not rs2.eof then
''				situacionSucursalNormal = trim(rs2("situacion"))
''				situacionSucursalHoraNormal = trim(rs2("hora"))
''			else
''				situacionSucursalNormal = ""
''				situacionSucursalHoraNormal = ""
''			end if
''			select case situacionSucursalNormal
''				case "":
''					claseSituacionNormal = "label"
''				case "1/4":
''					claseSituacionNormal = "label label-success"
''				case "1/2":
''					claseSituacionNormal = "label label-success"
''				case "3/4":
''					claseSituacionNormal = "label label-success"
''			end select
''			sql2 = ""
''			sql2 = sql2 & " select situacion, "
''			sql2 = sql2 & " convert(varchar(5), hora) as hora "
''			sql2 = sql2 & " from SUC_desbordes where id_des = ( "
''			sql2 = sql2 & " select MAX(id_des) "
''			sql2 = sql2 & " from SUC_desbordes "
''			sql2 = sql2 & " where "
''			'sql2 = sql2 & " a.fecha=cast(GETDATE() as date) "
''			sql2 = sql2 & " fecha = cast( '"&fecha&"' as date)"
''			sql2 = sql2 & " and tipo = 1 "
''			sql2 = sql2 & " and id_sucursal = '"&idSucursal&"') "
''			
''			'response.write(sql2)
			'response.end

''			set rs2 = db.execute(sql2)
''			if not rs2.eof then
''				situacionSucursalAFP = trim(rs2("situacion"))
''				situacionSucursalHoraAFP = trim(rs2("hora"))
''			else
''				situacionSucursalAFP = ""
''				situacionSucursalHoraAFP = ""
''			end if
''			select case situacionSucursalAFP
''				case "":
''					claseSituacionAFP = "label"
''				case "Full":
''					claseSituacionAFP = "label label-warning"
''				case "Desborde":
''					claseSituacionAFP = "label label-important"
''			end select
''			sql2 = ""
''			sql2 = sql2 & " select situacion, "
''			sql2 = sql2 & " convert(varchar(5), hora) as hora "
''			sql2 = sql2 & " from SUC_desbordes where id_des = ( "
''			sql2 = sql2 & " select MAX(id_des) "
''			sql2 = sql2 & " from SUC_desbordes "
''			sql2 = sql2 & " where "
''			'sql2 = sql2 & " a.fecha=cast(GETDATE() as date) "
''			sql2 = sql2 & " fecha = cast( '"&fecha&"' as date)"
''			sql2 = sql2 & " and tipo = 2 "
''			sql2 = sql2 & " and id_sucursal = '"&idSucursal&"') "
''
''			'response.write(sql2)
''			'response.end
''
''			set rs2 = db.execute(sql2)
''			if not rs2.eof then
''				situacionSucursalIPS = trim(rs2("situacion"))
''				situacionSucursalHoraIPS = trim(rs2("hora"))
''			else
''				situacionSucursalIPS = ""
''				situacionSucursalHoraIPS = ""
''			end if
''			select case situacionSucursalIPS
''				case "":
''					claseSituacionIPS = "label"
''				case "Full":
''					claseSituacionIPS = "label label-warning"
''				case "Desborde":
''					claseSituacionIPS = "label label-important"
''			end select
''		else
''			claseSituacionNormal = "label label-important"
''			situacionSucursalNormal = "Cerrada"
''			situacionSucursalHoraNormal = ""
''		end if
''	else
''		sucursalAbierta = 0
''		situacionSucursalNormal = "No abierta"
''		claseSituacionNormal = "label label-important"
''		clasePlazo = "label-important"
''		textoPlazo = "No abierta"
''		muestraHora = "--"
''		situacionSucursalHoraNormal = "--"
''		situacionSucursalAFP = ""
''		situacionSucursalHoraAFP = ""
''		claseSituacionAFP = ""
''		ituacionSucursalIPS = ""
''		situacionSucursalHoraIPS = ""
''		claseSituacionIPS = ""
''	end if
''
''	if sucursalAbierta = 1 then
''		clasePlazo = "label-success"
''		textoPlazo = "DP"
''	end if
''	if sucursalAbierta = 2 then
''		clasePlazo = "label label-warning"
''		textoPlazo = "FP"
''	end if
''	if i = totalSucursales then
''		divide = 1
''	else
''		divide = 0
''	end if

''	response.write "{"
''	Response.Write "   ""nombreSucursal"": """ & nombreSucursal & """, "
''	Response.Write "   ""nombreSucursalSinCaract"": """ & nombreSucursalSinCaract & """, "
''	Response.Write "   ""idSucursal"": """ & idSucursal & """, "
''	Response.Write "   ""sucursalAbierta"": """ & sucursalAbierta & """, "
''	Response.Write "   ""muestraHora"": """ & muestraHora & """, "
''	Response.Write "   ""situacionSucursalNormal"": """ & situacionSucursalNormal & """, "
''	Response.Write "   ""situacionSucursalHoraNormal"": """ & situacionSucursalHoraNormal & """, "
''	Response.Write "   ""claseSituacionNormal"": """ & claseSituacionNormal & """, "
''	Response.Write "   ""situacionSucursalAFP"": """ & situacionSucursalAFP & """, "
''	Response.Write "   ""situacionSucursalHoraAFP"": """ & situacionSucursalHoraAFP & """, "
''	Response.Write "   ""claseSituacionAFP"": """ & claseSituacionAFP & """, "
''	Response.Write "   ""situacionSucursalIPS"": """ & situacionSucursalIPS & """, "
''	Response.Write "   ""situacionSucursalHoraIPS"": """ & situacionSucursalHoraIPS & """, "
''	Response.Write "   ""claseSituacionIPS"": """ & claseSituacionIPS & """, "
''	Response.Write "   ""divide"": """ & divide & """, "
''	Response.Write "   ""clasePlazo"": """ & clasePlazo & """, "
''	Response.Write "   ""textoPlazo"": """ & textoPlazo & """ "
''	response.write "}"
''	if i <> ubound(datos,2) then response.write(",")
' next
response.write "]}"%>
