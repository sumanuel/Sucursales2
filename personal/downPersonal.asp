<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones2.asp"-->
<%
Response.Buffer = TRUE
tipoPersonal = trim(request("tipoPersonal"))
tipoAsistencia = trim(request("tipoAsistencia"))
'response.write(tipoInforme)
'response.end

titleName = ""
'response.write(tipoInforme)
'response.end

if tipoPersonal = "1" then
	if tipoAsistencia = "1" then
		titleName = "cajeros_presentes"
	end if
	if tipoAsistencia = "2" then
		titleName = "cajeros_ausentes"
	end if
	if tipoAsistencia = "3" then
		titleName = "cajeros_sinregistro"
	end if
end if

if tipoPersonal = "2" then
	if tipoAsistencia = "1" then
		titleName = "anfitriones_presentes"
	end if
	if tipoAsistencia = "2" then
		titleName = "anfitriones_ausentes"
	end if
	if tipoAsistencia = "3" then
		titleName = "anfitriones_sinregistro"
	end if
end if

if tipoPersonal = "3" then
	if tipoAsistencia = "1" then
		titleName = "paramedicos_presentes"
	end if
	if tipoAsistencia = "2" then
		titleName = "paramedicos_ausentes"
	end if
	if tipoAsistencia = "3" then
		titleName = "paramedicos_sinregistro"
	end if
end if

if tipoPersonal = "4" then
	if tipoAsistencia = "1" then
		titleName = "guardias_presentes"
	end if
	if tipoAsistencia = "2" then
		titleName = "guardias_ausentes"
	end if
	if tipoAsistencia = "3" then
		titleName = "guardias_sinregistro"
	end if
end if

'tipoPersonal 1 : Cajeros
'tipoPersonal 2 : Asistente Operacional
'tipoPersonal 3 : Paramedicos
'tipoPersonal 3 : Guardias
	'tipoAsistencia 1 : Presentes
	'tipoAsistencia 2 : Ausentes
	'tipoAsistencia 3 : Sin Registro
%>
<HTML>
<BODY>
<table WIDTH=100% BORDER=1 CELLSPACING=1 CELLPADDING=1>
<thead>
<tr>
	<th><strong>cod bt</strong></th>
   	<th><strong>Sucursal</strong></th>
    <th><strong>R.U.N</strong></th>
    <th><strong>Nombre</strong></th>    
    <th><strong>Asistencia</strong></th>
    <th><strong>Entrada</strong></th>
    <th><strong>Salida</strong></th>    
    <th><strong>Cargo</strong></th>
    <th><strong>Tipo</strong></th>
    <th><strong>Empresa</strong></th>
    <% if (tipoPersonal = "1" or tipoPersonal = "2" or tipoPersonal = "3") then %>
    <th colspan="2"><strong>Titular a Reemplazar</strong></th>    
    <% end if %>
</tr>
</thead>
<tbody>
<%
if (tipoPersonal = "1" or tipoPersonal = "2" or tipoPersonal = "3") then 
  sql = ""
  sql = sql & " select z.*, "
  sql = sql & " isnull(c.rut_titular, '') as rut_titular_areemplazar, "
  sql = sql & " isnull(c.nombre_titular, '') as nombre_titular_areemplazar "
  sql = sql & " from ( "
  sql = sql & " select a.bt_sucursal, "
  sql = sql & " b.suc_nombre, "
  sql = sql & " a.rut_personal, "
  sql = sql & " a.nombre_personal, "
  sql = sql & " a.asistencia, "
  sql = sql & " isnull(a.hora_llegada, '') as hora_llegada, "
  sql = sql & " isnull(a.min_llegada, '') as min_llegada, "
  sql = sql & " isnull(a.hora_salida, '') as hora_salida, "
  sql = sql & " isnull(a.min_salida, '') as min_salida, "
  sql = sql & " a.tipo_personal, "
  sql = sql & " a.tipo, "
  sql = sql & " a.empresa, "
  sql = sql & " convert(datetime, a.fecha_reg) as fecha_reg, "
  sql = sql & " convert(datetime, a.hora_reg) as hora_reg, "
  sql = sql & " convert(datetime, a.hora_reg_llegada) as hora_reg_llegada, "
  sql = sql & " convert(datetime, a.hora_reg_salida) as hora_reg_salida "
  sql = sql & " from SUC_sucursal_asistencia_personal a "
  sql = sql & " inner join SUC_sucursal b on a.id_sucursal = b.id_sucursal "
  sql = sql & " where "
  if tipoPersonal = "1" then
  		sql = sql & " (a.tipo_personal = 'CAJERO ADICIONAL' or a.tipo_personal = 'Cajero') "
  end if
  if tipoPersonal = "2" then
  		sql = sql & " a.tipo_personal = 'Asesor de Clientes' "
  end if
  if tipoPersonal = "3" then
  		sql = sql & " a.tipo_personal = 'Paramedico' "
  end if
  
  if tipoAsistencia = "1" then
    sql = sql & " and a.asistencia = 'si' "
  end if
  if tipoAsistencia = "2" then
    sql = sql & " and a.asistencia = 'no' "
  end if
  if tipoAsistencia = "3" then
    sql = sql & " and a.asistencia IS NULL "
  end if
  sql = sql & " and a.id_sucursal = b.id_sucursal "  
  sql = sql & " ) as z"
  sql = sql & " left join SUC_sucursal_reemplazos c on z.rut_personal = c.rut_reemp "
  
  'Response.Write(sql)
  'Response.End()
  
  set rs = db.execute(sql)
  if not rs.eof then
    'datos = rs.GetRows()
    'for i=0 to ubound(datos,2)
	do while not rs.eof
	
      bt_sucursal = trim(rs("bt_sucursal"))
      nombre_sucursal = server.htmlencode(trim(rs("suc_nombre")))
      rut_personal = trim(rs("rut_personal"))
      nombre = server.htmlencode(trim(rs("nombre_personal")))
      asistencia = trim(rs("asistencia"))      
      nombre_cargo = server.htmlencode(trim(rs("tipo_personal")))
      tipo = server.htmlencode(trim(rs("tipo")))
      empresa = server.htmlencode(trim(rs("empresa")))
      fecha_reg = trim(rs("fecha_reg"))
      hora_reg = trim(rs("hora_reg"))
      hora_reg_llegada = trim(rs("hora_reg_llegada"))
      hora_reg_salida = trim(rs("hora_reg_salida"))
	  rut_titular_areemplazar = trim(rs("rut_titular_areemplazar"))
	  nombre_titular_areemplazar = trim(rs("nombre_titular_areemplazar"))
	  
	  hora_llegada = ""
	  hora_salida = ""
	  if not trim(rs("hora_llegada")) = "" then 
	  	hora_llegada = trim(rs("hora_llegada"))&":"&trim(rs("min_llegada"))
	  end if
	  
	  if not trim(rs("hora_salida")) = "" then
	  	hora_salida = trim(rs("hora_salida"))&":"&trim(rs("min_salida"))
	  end if 	  
%>
      
    <tr>
        <td><%=bt_sucursal%></td>
        <td><%=nombre_sucursal%></td>
        <td><%=rut_personal%></td>
        <td><%=nombre%></td>        
        <td><%=asistencia%></td>
        <td><%=hora_llegada%></td>
        <td><%=hora_salida%></td>        
        <td><%=nombre_cargo%></td>
        <td><%=tipo%></td>
        <td><%=empresa%></td>
        <td><%=rut_titular_areemplazar%></td>
        <td><%=nombre_titular_areemplazar%></td>
    </tr>
  <%
  
  rs.MoveNext
  Loop
    
  end if
else 

sql = ""
sql = sql & "select "
sql = sql & "a.id_sucursal, "
sql = sql & "a.cod_bantotal, "
sql = sql & "b.suc_nombre, "
sql = sql & "a.tipo, "
sql = sql & "a.empresa, "
sql = sql & "a.guardia_nombre, "
sql = sql & "a.guardia_rut, "
sql = sql & "a.tipo_suc, "
sql = sql & "isnull(a.asistencia, '') as asistencia, "
sql = sql & "isnull(a.entrada_hora, '') as entrada_hora, "
sql = sql & "isnull(a.entrada_min, '') as entrada_min, "
sql = sql & "isnull(a.salida_hora, '') as salida_hora, "
sql = sql & "isnull(a.salida_min, '') as salida_min "
sql = sql & "from SUC_sucursal_guardias_asistencia a, "
sql = sql & "SUC_sucursal b "
sql = sql & "where a.id_sucursal = b.id_sucursal "

if tipoAsistencia = "1" then
	sql = sql & " and a.asistencia = 'si' "
end if
if tipoAsistencia = "2" then
	sql = sql & " and a.asistencia = 'no' "
end if
if tipoAsistencia = "3" then
	sql = sql & " and a.asistencia IS NULL "
end if

if perfil = "2" then
	sql = sql & " and a.id_sucursal in (select id_sucursal from SUC_zonales_sucursal where id_zonal = " & idUsuario & ") "
end if

sql = sql & "order by a.cod_bantotal "

  'response.Write(sql)

  set rs = db.execute(sql)
  if not rs.eof then    
	do while not rs.eof
	
      bt_sucursal = trim(rs("cod_bantotal"))
      nombre_sucursal = server.htmlencode(trim(rs("suc_nombre")))
      rut_personal = trim(rs("guardia_rut"))
      nombre = trim(rs("guardia_nombre"))
      asistencia = trim(rs("asistencia"))      
      nombre_cargo = "guardia"
      tipo = server.htmlencode(trim(rs("tipo_suc")))
      empresa = server.htmlencode(trim(rs("empresa")))     
	  	  
	  hora_llegada = ""
	  hora_salida = ""
	  if not trim(rs("entrada_hora")) = "" then 
	  	hora_llegada = trim(rs("entrada_hora"))&":"&trim(rs("entrada_min"))
	  end if
	  
	  if not trim(rs("salida_hora")) = "" then
	  	hora_salida = trim(rs("salida_hora"))&":"&trim(rs("salida_min"))
	  end if 
%>    
    <tr>
        <td><%=bt_sucursal%></td>
        <td><small><b><%=nombre_sucursal%></b></small></td>
        <td><small><b><%=rut_personal%></b></small></td>
        <td><%=nombre%></td>        
        <td><%=asistencia%></td>
        <td><%=hora_llegada%></td>
        <td><%=hora_salida%></td>        
        <td><small><b><%=nombre_cargo%></b></small></td>
        <td><small><b><%=tipo%></b></small></td>
        <td><small><b><%=empresa%></b></small></td>
    </tr>
  <%
  
  rs.MoveNext
  Loop	  

  end if 
end if 
' Clean up
'set rs = Nothing
'rs.Close
%>
</tbody>
</table>
</BODY>
</HTML>
<%
archivo = titleName
diaFecha = day(Date)
mesFecha = month(Date)
anioFecha = year(Date)
fecha = anioFecha&mesFecha&diaFecha

archivo = fecha&"_"&archivo&".xls"

Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel" 
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo 

%>