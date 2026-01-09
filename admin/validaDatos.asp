<!--#include file="../funciones.asp"-->
<%rut = trim(request("rut"))
correo=trim(request("correo"))
noCarga = 0
if correo = "" then
	totalCaracteres = len(rut)
	if totalCaracteres = "10" then
		dv = right(rut,1)
		rut = left(rut,8)
	else
		dv = right(rut,1)
		rut = left(rut,7)
	end if
	sql = ""
	sql = sql & "select 1 from  SUC_m_usuarios where usuario_rut = '"&rut&"' "
	set rs = db.execute(sql)
else
	correo=trim(request("correo"))
	if right(correo,13) <> "@losheroes.cl" then
		response.write("false")
		noCarga = 1
	end if
	sql = ""
	sql = sql & "select 1 from  SUC_m_usuarios where correo = '"&correo&"' "
end if
'response.write(sql)
if noCarga = 0 then
	set rs = db.execute(sql)
	if not rs.eof then
		response.write "false"
	else
		response.write "true"
	end if
end if%>