<!--#include file="../funciones2.asp"-->
<%
idColocacion = trim(request("idColocacion"))
mes = trim(request("mes"))
anio = trim(request("anio"))
periodo = anio&"/"&mes
perfilMain = trim(request("perfilMain"))
idUsuarioMain = trim(request("idUsuarioMain"))
idSucursalMain = trim(request("idSucursalMain"))%>

<input type="hidden" name="idCombo" id="idCombo" value="0">

<%if idColocacion = "1" and perfilMain = "3" then%>
<table id="tableP01" class="table table-bordered table-hover table-condensed table-striped mano">
<thead>
<tr>
	  <th><strong>Regional</strong></th>
   	<th><strong>Zonal</strong></th>    
    <th><strong>Total Colo Crédito</strong></th>
    <th><strong>Periodo</strong></th> 
</tr>
</thead>
<tbody>
<% 
  sql = ""
  sql = sql & "select "
  sql = sql & "z.regional, z.id_usuario, z.Zonal, sum(qColocaciones) as totalColocaciones  "
  sql = sql & "from( "
  sql = sql & "select "
  sql = sql & "suc.suc_zonal_jefe as regional, us.id_usuario, us.u_nombres+' '+us.u_apellidos as Zonal, "
  sql = sql & "(select count(0) as q from scvcc.dbo.opcreditos opcr where opcr.numero_sucursal_orig =  suc.cod_bantotal "
  sql = sql & "and year(cast(opcr.fecha_colocacion as date)) = "&anio&" and month(cast(opcr.fecha_colocacion as date)) = "&mes&") as qColocaciones "
  sql = sql & ",suc.cod_bantotal "
  sql = sql & "from SUC_usuario_zona zn inner join SUC_sucursal suc on zn.id_sucursal = suc.id_sucursal "
  sql = sql & "inner join SUC_usuario us on us.id_usuario = zn.id_usuario "
  sql = sql & "where suc.suc_estado = 1 "
  sql = sql & ") z group by z.regional, z.id_usuario, z.Zonal "
  sql = sql & "order by z.regional "
  'response.write(sql)
  'response.end  
  set rs = db.execute(sql)
  if not rs.eof then    
  do while not rs.eof  	
    regional = trim(rs("regional"))
    id_zonal_v_p = trim(rs("id_usuario"))
    nombre_zonal = trim(rs("Zonal"))    
    total_colocaciones = trim(rs("totalColocaciones"))
  %>    
    <tr class="clickTablePais" data-clickPais1="<%=id_zonal_v_p%>">
      <td><%=regional%></td> 
      <td><%=nombre_zonal%></td>      
      <td><%=total_colocaciones%></td>
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
  var id_zonal = $(this).attr("data-clickPais1");  
  var mes = <%=mes%>;
  var anio = <%=anio%>;
  var idColocacion = <%=idColocacion%>;
  var idChCombo = 2
  var div = 'listaChecklistColo2';
  var pagina = 'CheckListCredito/listaChecklistColo02.asp';
  var datos = 'id_zonal='+id_zonal+'&mes='+mes+'&anio='+anio+'&idChCombo='+idChCombo;
  enviaDatos(pagina,div,datos);
  $('#listaChecklistColo').html('').hide(); 
});
</script>