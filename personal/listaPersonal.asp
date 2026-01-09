<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones2.asp"-->
<%
perfil = trim(request("perfilMain"))
idUsuario = trim(request("idUsuarioMain"))
tipoPersonal = trim(request("tipoPersonal"))
tipoAsistencia = trim(request("tipoAsistencia"))
titleName = ""

sql = ""
sql = sql & " exec SUC_prc_personal_sin_reemplazo "
db.execute(sql)

if perfil = "" then  
  perfil = trim(request("perfilMain"))
end if 

if idUsuario = "" then
  idUsuario = trim(request("idUsuarioMain"))
end if 

if tipoPersonal = "1" then
	if tipoAsistencia = "1" then
		titleName = "Cajeros - Presentes"
	end if
	if tipoAsistencia = "2" then
		titleName = "Cajeros - Ausentes"
	end if
	if tipoAsistencia = "3" then
		titleName = "Cajeros - Sin Registro"
	end if
end if

if tipoPersonal = "2" then
	if tipoAsistencia = "1" then
		titleName = "Anfitriones - Presentes"
	end if
	if tipoAsistencia = "2" then
		titleName = "Anfitriones - Ausentes"
	end if
	if tipoAsistencia = "3" then
		titleName = "Anfitriones - Sin Registro"
	end if
end if

if tipoPersonal = "3" then
	if tipoAsistencia = "1" then
		titleName = "Paramedicos - Presentes"
	end if
	if tipoAsistencia = "2" then
		titleName = "Paramedicos - Ausentes"
	end if
	if tipoAsistencia = "3" then
		titleName = "Paramedicos - Sin Registro"
	end if
end if

if tipoPersonal = "4" then
	if tipoAsistencia = "1" then
		titleName = "Guardias - Presentes"
	end if
	if tipoAsistencia = "2" then
		titleName = "Guardias - Ausentes"
	end if
	if tipoAsistencia = "3" then
		titleName = "Guardias - Sin Registro"
	end if
end if

'tipoPersonal 1 : Cajeros
'tipoPersonal 2 : Asistente Operacional
'tipoPersonal 3 : Paramedicos
'tipoPersonal 3 : Guardias
'tipoAsistencia 1 : Presentes
'tipoAsistencia 2 : Ausentes
'tipoAsistencia 3 : Sin Registro%>
<button class="btn btn-primary downData" data-tipoPersonal="<%=tipoPersonal%>" data-tipoAsistencia="<%=tipoAsistencia%>"><i class="icon-cloud-download"></i> <strong><small>Descarga <%=titleName%></small></strong></button><br/><br/>
<table id="tableP" class="table table-bordered table-hover table-condensed table-striped">
<thead>
<tr>
	<th><strong>bt</strong></th>
   	<th><strong>Sucursal</strong></th>
    <th><strong>R.U.N</strong></th>
    <th><strong>Nombre</strong></th>    
    <th><strong>Asistencia</strong></th>
    <th><strong>Entrada</strong></th>
    <th><strong>Salida</strong></th>    
    <th><strong>Cargo</strong></th>
    <th><strong>Tipo</strong></th>
    <th><strong>Empresa</strong></th>
</tr>
</thead>
<tbody>
<%
if (tipoPersonal = "1" or tipoPersonal = "2" or tipoPersonal = "3" or tipoPersonal = "55" or tipoPersonal = "66") then 
  sql = ""
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
  sql = sql & " from SUC_sucursal_asistencia_personal a, "
  sql = sql & " SUC_sucursal b "  
  sql = sql & " where "
  if tipoPersonal = "1" and tipoAsistencia = "2" then
  		sql = sql & " (a.tipo_personal = 'CAJERO ADICIONAL' or a.tipo_personal = 'Cajero') and rut_personal in (select rut_ausente from SUC_personal_sin_reemplazo where tipo = 'cajero') "
  end if  
  if tipoPersonal = "1" and tipoAsistencia = "1" then
      sql = sql & " (a.tipo_personal = 'CAJERO ADICIONAL' or a.tipo_personal = 'Cajero') "
  end if
  if tipoPersonal = "1" and tipoAsistencia = "3" then
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
  'sql = sql & " and a.rut_personal = c.rut_personal "
  
  if perfil = "2" then
  	'sql = sql & " and a.id_sucursal in (select id_sucursal from SUC_zonales_sucursal where id_zonal = " & idUsuario & ") "
    sql = sql & " and a.id_sucursal in (select id_sucursal from SUC_usuario_sucursal where id_usuario = " & idUsuario & ") "
  end if
  if perfil = "55" then
  	sql = sql & " and a.id_sucursal in (select id_sucursal from SUC_zonales_comercial_sucursal where id_zonal = " & idUsuario & ") "
  end if
  if perfil = "66" then
  	sql = sql & " and a.id_sucursal in (select id_sucursal from SUC_zonales_comercial_mas_sucursal where id_zonal = " & idUsuario & ") "
  end if
  
  'response.write(sql)
  'response.end

  set rs = db.execute(sql)   
  
  if not rs.eof then    
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
	sql = sql & " and a.asistencia = 'no' and guardia_rut in (select rut_ausente from SUC_personal_sin_reemplazo where tipo = 'guardia') "
end if
if tipoAsistencia = "3" then
	sql = sql & " and a.asistencia IS NULL "
end if

if perfil = "2" then
	'sql = sql & " and a.id_sucursal in (select id_sucursal from SUC_zonales_sucursal where id_zonal = " & idUsuario & ") "
  sql = sql & " and a.id_sucursal in (select id_sucursal from SUC_usuario_sucursal where id_usuario = " & idUsuario & ") "
end if

sql = sql & "order by a.cod_bantotal "
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
%>
</tbody>
</table>

<!--<link href="css/tablaSort.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="js/jquery.dataTables.js"></script>
<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>-->
<script>
$(function(){
  $(".downData").click(function(){
    var tipoPersonal = $(this).attr('data-tipoPersonal');
    var tipoAsistencia = $(this).attr('data-tipoAsistencia');  
    var pagina = 'personal/downPersonal.asp';   
    var datos='tipoPersonal='+tipoPersonal+'&tipoAsistencia='+tipoAsistencia;
    location.href=pagina+'?'+datos;           
  });
  $('#tableP').dataTable( {});
});
</script>
