<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones2.asp"-->
<%
perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
tipoPersonal = trim(request("tipoPersonal"))
tipoAsistencia = trim(request("tipoAsistencia"))
titleName = ""

if perfil = "" then 
  perfil = trim(request("perfilMain"))
end if 

if idUsuario = "" then 
  idUsuario = trim(request("idUsuarioMain"))
end if

'tipoPersonal 1 : JEPS
'tipoPersonal 2 : JEPS MULTIFUNCIONAL
'tipoPersonal 3 : ASISTENTE OPERACIONAL
'tipoPersonal 4 : VALIDADOR
'tipoPersonal 5 : TESORERO

%>
<table id="tableP" class="table table-bordered table-hover table-condensed table-striped">
<thead>
<tr>
	<th><strong>bt</strong></th>
   	<th><strong>Sucursal</strong></th>
    <th><strong>Tipo</strong></th>
    <th><strong>Rut</strong></th>    
    <th><strong>Nombres</strong></th>
    <th><strong>Apellido Paterno</strong></th>
    <th><strong>Apellido Materno</strong></th>    
    <th><strong>Anexo</strong></th>    
</tr>
</thead>
<tbody>
<%
  
sql = ""
sql = sql & "select "
sql = sql & "a.id_sucursal, "
sql = sql & "b.cod_bantotal, "
sql = sql & "b.suc_nombre, "
sql = sql & "c.tipo, "
sql = sql & "a.rut, "
sql = sql & "a.dv, "
sql = sql & "a.nombres, "
sql = sql & "a.apep, "
sql = sql & "a.apem, "
sql = sql & "a.cargo, "
sql = sql & "a.anexo, "
sql = sql & "a.fecha_ingreso "
sql = sql & "from SUC_sucursal_dotacion a "
sql = sql & "inner join SUC_sucursal b on a.id_sucursal = b.id_sucursal "
sql = sql & "inner join SUC_sucursal_dotacion_tipo c on a.tipo = c.id_tipo "
sql = sql & " where a.cargo = " & tipoPersonal

if perfil = "2" then
	sql = sql & " and a.id_sucursal in (select id_sucursal from SUC_zonales_sucursal where id_zonal = " & idUsuario & ") "
end if

sql = sql & " order by b.suc_nombre "

  'Response.Write(sql)
  set rs = db.execute(sql)
  if not rs.eof then    
	do while not rs.eof
	
      bt_sucursal = trim(rs("cod_bantotal"))
      nombre_sucursal = server.htmlencode(trim(rs("suc_nombre")))
      tipo = trim(rs("tipo"))
	  rut = trim(rs("rut"))
	  dv = trim(rs("dv"))
      nombres = trim(rs("nombres"))
	  apep = trim(rs("apep"))
	  apem = trim(rs("apem"))
      anexo = trim(rs("anexo"))            
%>    
    <tr>
        <td><%=bt_sucursal%></td>
        <td><small><b><%=nombre_sucursal%></b></small></td>
        <td><small><b><%=tipo%></b></small></td>
        <td><%=rut%>-<%=dv%></td>        
        <td><%=nombres%></td>
        <td><%=apep%></td>
        <td><%=apem%></td>        
        <td><small><b><%=anexo%></b></small></td>        
    </tr>
  <%
  
  rs.MoveNext
  Loop	  

  end if 
%>
</tbody>
</table>

<script>
$(document).ready(function (){
	$(".downData").click(function(){
		var tipoPersonal = $(this).attr('data-tipoPersonal');
		var tipoAsistencia = $(this).attr('data-tipoAsistencia');
		
		//console.log("tipoPersonal:"+tipoPersonal);
		//console.log("tipoAsistencia:"+tipoAsistencia);	
			
		var pagina = 'personal/downPersonal.asp';		
		var datos='tipoPersonal='+tipoPersonal+'&tipoAsistencia='+tipoAsistencia;
		location.href=pagina+'?'+datos;	  				
	});
	
	$('#tableP').dataTable( {
		"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
		"sPaginationType": "bootstrap"
	});	
});
</script>
