<!--#include file="../funciones2.asp"-->
<%
idColocacion = trim(request("idColocacion"))
mes = trim(request("mes"))
anio = trim(request("anio"))
periodo = anio&"/"&mes
perfilMain = trim(request("perfilMain"))
idUsuarioMain = trim(request("idUsuarioMain"))
idSucursalMain = trim(request("idSucursalMain"))%>

<input type="hidden" name="idComboRepro" id="idComboRepro" value="0">

<%if idColocacion = "2" and perfilMain = "3" then%>
<table id="tableP011" class="table table-bordered table-hover table-condensed table-striped mano">
<thead>
<tr>
	  <th><strong>Regional</strong></th>
   	<th><strong>Zonal</strong></th>    
    <th><strong>Total Repro</strong></th>
    <th><strong>Periodo</strong></th> 
</tr>
</thead>
<tbody>
<% 
  sql = ""
  sql = sql & "select "
  sql = sql & "z.regional, z.id_usuario, z.nombreZonal+' '+z.apellidoZonal as Zonal, sum(z.qReprogramaciones) as totalRepro "
  sql = sql & "from( "
  sql = sql & "select suc.suc_zonal_jefe as regional, us.id_usuario, us.u_nombres as nombreZonal, us.u_apellidos as apellidoZonal, "
  sql = sql & "(select count(0) as q from scvcc.dbo.opreprocr opcr where opcr.sucursalorigen = suc.cod_bantotal and "
  sql = sql & "year(opcr.fecreprogramacion) = "&anio&" and month(opcr.fecreprogramacion) = "&mes&" having count(0)>0) as qReprogramaciones "
  sql = sql & ",suc.cod_bantotal "
  sql = sql & "from SUC_usuario_zona zn inner join SUC_sucursal suc on "
  sql = sql & "zn.id_sucursal = suc.id_sucursal inner join SUC_usuario us on "
  sql = sql & "us.id_usuario = zn.id_usuario where suc.suc_estado = 1 "
  sql = sql & ") z "
  sql = sql & "where z.qReprogramaciones is not null "
  sql = sql & "group by z.regional, z.id_usuario, z.nombreZonal+' '+z.apellidoZonal order by z.regional "  
 
  'response.write(sql)
  'response.end

  set rs = db.execute(sql)
  if not rs.eof then    
  do while not rs.eof  	
    regional = trim(rs("regional"))
    id_zonal_v_p = trim(rs("id_usuario"))
    nombre_zonal = trim(rs("Zonal"))    
    total_reprogramaciones = trim(rs("totalRepro"))
  %>    
    <tr class="clickTablePais" data-clickPais11="<%=id_zonal_v_p%>">
      <td><%=regional%></td> 
      <td><%=nombre_zonal%></td>      
      <td><%=total_reprogramaciones%></td>
      <td><%=periodo%></td>
    </tr>
  <%    
  rs.MoveNext
  Loop
  end if %>
  </tbody>
  </table>
<%end if%>

<script type="text/javascript">
$(function(){
 /*  $('#tableP01').dataTable( {
    "sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap"
  });*/
});
$('.clickTablePais').click(function() {  
  var id_zonal = $(this).attr("data-clickPais11");  
  var mes = <%=mes%>;
  var anio = <%=anio%>;
  var idColocacion = <%=idColocacion%>;  
  var div = 'listaChecklistRepro2';
  var pagina = 'CheckListCredito/listaChecklistRepro02.asp';
  var datos = 'id_zonal='+id_zonal+'&mes='+mes+'&anio='+anio;
  enviaDatos(pagina,div,datos);
  $('#listaChecklistRepro').html('').hide(); 
});
</script>