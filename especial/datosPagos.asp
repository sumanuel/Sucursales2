<!--#include file="../funciones.asp"-->
<%
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
sql = sql & " FROM SCSS.dbo.SUC_index_new_ips_panel union " 
sql = sql & " SELECT id_ips "
sql = sql & " ,fecha "
sql = sql & " ,valor "
sql = sql & " ,area "
sql = sql & " ,tipo "
sql = sql & " ,cast(fecha_ingreso as varchar(30)) as fecha_ingreso "
sql = sql & " ,cast(hora_ingreso as varchar(30)) as hora_ingreso "
sql = sql & " FROM SCSS.dbo.SUC_index_new_ips_bonos_panel " 
set rs = db.execute(sql)
varDatos = ""
if not rs.eof then
	Do Until rs.EOF
		idIps = trim(rs("id_ips"))
		fecha = trim(rs("fecha"))
		valor = formatnumber(trim(rs("valor")),0)
		area = trim(rs("area"))
		tipo = trim(rs("tipo"))
		fechaIngreso = trim(rs("fecha_ingreso"))
		horaIngreso = trim(rs("hora_ingreso"))
		varDatos =  varDatos & "{"
		varDatos = varDatos &  "   ""idIps"": """ & idIps & """, "
		varDatos = varDatos &  "   ""fecha"": """ & fecha & """, "
		varDatos = varDatos &  "   ""valor"": """ & valor & """, "
		varDatos = varDatos &  "   ""area"": """ & area & """, "
		varDatos = varDatos &  "   ""tipo"": """ & tipo & """, "
		varDatos = varDatos &  "   ""fechaIngreso"": """ & fechaIngreso & """, "
		varDatos = varDatos &  "   ""horaIngreso"": """ & horaIngreso & """ "
		varDatos = varDatos &  "}"
		varDatos = varDatos & ","
		rs.Movenext
	loop
	varDatos = left(varDatos,len(varDatos)-1)
end if
varDatos =  varDatos & "]"
varDatos =  varDatos &  "}"
response.write(varDatos)%>