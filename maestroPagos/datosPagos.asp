<!--#include file="../funciones.asp"-->
<%tipo = trim(request("tipo"))
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datos"": ["
sql = ""
sql = sql & " SELECT id_ips "
sql = sql & " ,fecha "
sql = sql & " ,valor "
sql = sql & " ,area "
sql = sql & " ,tipo "
sql = sql & " ,cast(fecha_ingreso as varchar(30)) as fecha_ingreso "
sql = sql & " ,cast(hora_ingreso as varchar(30)) as hora_ingreso "
sql = sql & " ,'0' as tipoano "
sql = sql & " FROM SCSS.dbo.SUC_index_new_ips_panel "
if tipo = "1" then sql = sql & " where area = 'rm' "
sql = sql & " union " 
sql = sql & " SELECT id_ips "
sql = sql & " ,fecha "
sql = sql & " ,valor "
sql = sql & " ,area "
sql = sql & " ,tipo "
sql = sql & " ,cast(fecha_ingreso as varchar(30)) as fecha_ingreso "
sql = sql & " ,cast(hora_ingreso as varchar(30)) as hora_ingreso "
sql = sql & " ,'1' as tipoano "
sql = sql & " FROM SCSS.dbo.SUC_index_new_ips_bonos_panel " 
if tipo = "1" then sql = sql & " where area = 'rm' "
sql = sql & " union " 
sql = sql & " SELECT id_ips "
sql = sql & " ,fecha "
sql = sql & " ,valor "
sql = sql & " ,area "
sql = sql & " ,tipo "
sql = sql & " ,cast(fecha_ingreso as varchar(30)) as fecha_ingreso "
sql = sql & " ,cast(hora_ingreso as varchar(30)) as hora_ingreso "
sql = sql & " ,'2' as tipoano "
sql = sql & " FROM SCSS.dbo.SUC_index_new_ips_bonos_panel_v2 " 
if tipo = "1" then sql = sql & " where area = 'rm' "

'response.write(sql)
'response.end

set rs = db.execute(sql)
varDatos = ""
if not rs.eof then
	Do Until rs.EOF
		idIps = trim(rs("id_ips"))
		fecha = trim(rs("fecha"))
		valor = trim(rs("valor"))
		area = trim(rs("area"))
		tipo = trim(rs("tipo"))
		fechaIngreso = trim(rs("fecha_ingreso"))
		horaIngreso = trim(rs("hora_ingreso"))
		tipoano = trim(rs("tipoano"))
		varDatos =  varDatos & "{"
		varDatos = varDatos &  "   ""idIps"": """ & idIps & """, "
		varDatos = varDatos &  "   ""fecha"": """ & fecha & """, "
		varDatos = varDatos &  "   ""valor"": """ & valor & """, "
		varDatos = varDatos &  "   ""area"": """ & area & """, "
		varDatos = varDatos &  "   ""tipo"": """ & tipo & """, "
		varDatos = varDatos &  "   ""fechaIngreso"": """ & fechaIngreso & """, "
		varDatos = varDatos &  "   ""horaIngreso"": """ & horaIngreso & """, "
		varDatos = varDatos &  "   ""tipoano"": """ & tipoano & """ "
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