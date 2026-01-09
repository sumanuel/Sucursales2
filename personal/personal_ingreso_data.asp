<!--#include file="../conexion/conexion.asp"-->
<%
tipoPersonal = "0"
tipoPersonal = request("tipoPersonal")
idSucursal = request("idSucursal")
codBtt = request("codBtt")

rutPersonal = request("rutpersonal")
tipoPrc = request("tipoprc")

if tipoPrc = "1" then 'OBTIENE DATA DEL PERSONAL TITULAR

	'=====================================================================
	' JSON
	'=====================================================================
	Response.ContentType = "application/json"
	 
	Response.Write "{"
	'Response.Write "  ""datos"": " 
	'Response.Write "{ "
	
	sql = ""
	sql = sql & "select "
	sql = sql & "id_personal, "
	sql = sql & "nombre_personal, "
	sql = sql & "apep_personal, "
	sql = sql & "apem_personal, "
	sql = sql & "id_cargo, "
	sql = sql & "nombre_cargo, "
	sql = sql & "empresa "
	sql = sql & "from SUC_sucursal_personal "
	sql = sql & "where rut_personal = '"& rutPersonal &"'"
	
	set rs = db.execute(sql)
	if not rs.eof then 
		 
		 idPersonal = trim(rs("id_personal"))
		 nombrePersonal = trim(rs("nombre_personal"))
		 apepPersonal = trim(rs("apep_personal"))
		 apemPersonal = trim(rs("apem_personal"))
		 idCargo = trim(rs("id_cargo"))
		 nombreCargo = trim(rs("nombre_cargo"))
		 empresa = trim(rs("empresa"))
		 
		 Response.Write "   ""idPersonal"": """&idPersonal&""", "
		 Response.Write "   ""nombrePersonal"": """&nombrePersonal&""", "
		 Response.Write "   ""apepPersonal"": """&apepPersonal&""", "
		 Response.Write "   ""apemPersonal"": """&apemPersonal&""", "
		 Response.Write "   ""idCargo"": """&idCargo&""", "
		 Response.Write "   ""nombreCargo"": """&nombreCargo&""", "
		 Response.Write "   ""empresa"": """&empresa&""" "     	 
		 
	end if	 
		 
	'Response.Write "} }"
	Response.Write "}"

end if

if tipoPrc = "2" then 'INGRESO DE REEMPLAZO

rutTitular = request("rutTitular")
nombreReemplazo = request("nombreReemplazo")
rutReemplazo = request("rutReemplazo")
cargo = request("cargo")
empresa = request("empresa")
motivo = request("motivo")
fechaDesde = request("fechaDesde")
horaDesde = request("horaDesde")
minDesde = request("minDesde")
fechaHasta = request("fechaHasta")
horaHasta = request("horaHasta")
minHasta = request("minHasta")
codBtt = request("codBtt")

'fechaDesde = Replace(FormatDateTime(fechaDesde,2),"/","-")
'fechaHasta = Replace(FormatDateTime(fechaHasta,2),"/","-")
fdd = DatePart("d", fechaDesde)
if cint(fdd) < 10 then
	fdd = "0"&fdd
end if 
fdm = DatePart("m", fechaDesde)
if cint(fdm) < 10 then 
	fdm = "0"&fdm
end if 

fhd = DatePart("d", fechaHasta)
if cint(fhd) < 10 then
	fhd = "0"&fhd
end if 
fhm = DatePart("m", fechaHasta)
if cint(fhm) < 10 then 
	fhm = "0"&fhm
end if 

fechaDesde = DatePart("yyyy", fechaDesde) & "-" & fdm & "-" & fdd
fechaHasta = DatePart("yyyy", fechaHasta) & "-" & fhm & "-" & fhd

'Response.Write(fechaDesde)
'Response.Write("<br/>")

sql = ""	
sql = sql & "exec SUC_prc_sucursal_personal_ing_reemp "
sql = sql & "@bt_sucursal = "&codBtt&", "
sql = sql & "@id_cargo = "&cargo&", "
sql = sql & "@rut_titular = '"&rutTitular&"', "
sql = sql & "@rut_reemp = '"&rutReemplazo&"', "
sql = sql & "@nombre_reemp = '"&nombreReemplazo&"', "
sql = sql & "@desde = '"&fechaDesde&"', "
sql = sql & "@hasta = '"&fechaHasta&"', "
sql = sql & "@hora_ingreso = '"&horaDesde&"', "
sql = sql & "@min_ingreso = '"&minDesde&"', "
sql = sql & "@hora_salida = '"&horaHasta&"', "
sql = sql & "@min_salida = '"&minHasta&"', "
sql = sql & "@empresa = '"&empresa&"', "
sql = sql & "@motivo = '"&motivo&"'"

'Response.Write(sql)
set rs = db.execute(sql)
	
end if 

if tipoPrc = "3" then 'INGRESO DE TITULAR

rut_personal = request("rutPersonal")
nombre_personal = request("nombrePersonal")
apep_personal = request("apepPaterno")
apem_personal = request("apepMaterno")
id_cargo = request("cargo")
empresa = request("empresa")

sql = ""	
sql = sql & "exec SUC_prc_sucursal_personal_ing_titular "
sql = sql & "@bt_sucursal="&codBtt&", "
sql = sql & "@rut_personal='"&rut_personal&"', "
sql = sql & "@nombre_personal='"&nombre_personal&"', "
sql = sql & "@apep_personal='"&apep_personal&"', "
sql = sql & "@apem_personal="&apem_personal&", "
sql = sql & "@id_cargo="&id_cargo&", "
sql = sql & "@fecha_ingreso='2013-11-29', "	
sql = sql & "@empresa= '"&empresa&"'"

'Response.Write(sql)
set rs = db.execute(sql)

end if

if tipoPrc = "4" then 'ELIMINAR PERSONAL

idAsist = request("idAsist")

sql = ""
sql = sql & "exec SUC_prc_sucursal_personal_del @id_personal_asist=" & idAsist

'Response.Write(sql)
set rs = db.execute(sql)

end if

if tipoPrc = "5" then 'MODIFICAR TITULAR

idAsistPersonal = request("idAsistPersonal")
rut_personal = request("rutPersonal")
nombre_personal = request("nombrePersonal")
apep_personal = request("apepPaterno")
apem_personal = request("apepMaterno")
id_cargo = request("cargo")
empresa = request("empresa")

sql = ""
sql = sql & "exec SUC_prc_sucursal_personal_mod_titular "
sql = sql & "@id_asist_personal="&idAsistPersonal&", "
sql = sql & "@bt_sucursal="&codBtt&", "
sql = sql & "@rut_personal='"&rut_personal&"', "
sql = sql & "@nombre_personal='"&nombre_personal&"', "
sql = sql & "@apep_personal='"&apep_personal&"', "
sql = sql & "@apem_personal='"&apem_personal&"', "
sql = sql & "@id_cargo="&id_cargo&", "
sql = sql & "@fecha_ingreso='2013-12-02', "
sql = sql & "@empresa= '"&empresa&"'"

'Response.Write(sql)
set rs = db.execute(sql)

end if

if tipoPrc = "6" then 'MODIFICAR REEMPLAZO

idAsistPersonal = request("idAsistPersonal")
rutTitular = request("rutTitular")
nombreTitular = request("nombreTitular")
nombreReemplazo = request("nombreReemplazo")
rutReemplazo = request("rutReemplazo")
cargo = request("cargo")
empresa = request("empresa")
motivo = request("motivo")
fechaDesde = request("fechaDesde")
horaDesde = request("horaDesde")
minDesde = request("minDesde")
fechaHasta = request("fechaHasta")
horaHasta = request("horaHasta")
minHasta = request("minHasta")
codBtt = request("codBtt")

fdd = DatePart("d", fechaDesde)
if cint(fdd) < 10 then
	fdd = "0"&fdd
end if 
fdm = DatePart("m", fechaDesde)
if cint(fdm) < 10 then 
	fdm = "0"&fdm
end if 

fhd = DatePart("d", fechaHasta)
if cint(fhd) < 10 then
	fhd = "0"&fhd
end if 
fhm = DatePart("m", fechaHasta)
if cint(fhm) < 10 then 
	fhm = "0"&fhm
end if 

fechaDesde = DatePart("yyyy", fechaDesde) & "-" & fdm & "-" & fdd
fechaHasta = DatePart("yyyy", fechaHasta) & "-" & fhm & "-" & fhd

sql = ""
sql = sql & "exec SUC_prc_sucursal_personal_mod_reemp "
sql = sql & "@idAsistPersonal="&idAsistPersonal&", "
sql = sql & "@rutTitular='"&rutTitular&"', "
sql = sql & "@nombreTitular='"&nombreTitular&"', "
sql = sql & "@nombreReemplazo='"&nombreReemplazo&"', "
sql = sql & "@rutReemplazo='"&rutReemplazo&"', "
sql = sql & "@cargo="&cargo&", "
sql = sql & "@empresa='"&empresa&"', "
sql = sql & "@motivo='"&motivo&"', "
sql = sql & "@fechaDesde='"&fechaDesde&"', "
sql = sql & "@horaDesde='"&horaDesde&"', "
sql = sql & "@minDesde='"&minDesde&"', "
sql = sql & "@fechaHasta='"&fechaHasta&"', "
sql = sql & "@horaHasta='"&horaHasta&"', "
sql = sql & "@minHasta='"&minHasta&"', "
sql = sql & "@codBtt="&codBtt&""

'Response.Write(sql)
set rs = db.execute(sql)

end if

if tipoPrc = "7" then 'MODIFICAR REEMPLAZO

idAsist = request("idAsist")

sql = ""
sql = sql & "update SUC_sucursal_asistencia_personal set "
sql = sql & "asistencia = null, "
sql = sql & "hora_llegada = null, "
sql = sql & "min_llegada = null "
sql = sql & "where id_asist_personal = " & idAsist

'Response.Write(sql)
set rs = db.execute(sql)

end if

%>
