<!--#include file="../conexion/conexion.asp"-->
<%
idSucursal = trim(request("idSucursal"))
'idSucursal=120

sql = ""
sql = sql & " select a.id_asistencia, a.cod_bantotal, a.sucursal, a.tipo, a.empresa, isnull(a.guardia_nombre,'') as guardia_nombre, isnull(a.guardia_rut, '') as guardia_rut, "
sql = sql & " a.tipo_suc, a.id_usuario, isnull(a.asistencia, '') as asistencia, a.guardia_p_entrada, a.guardia_p_salida, "
sql = sql & " isnull(a.entrada_hora, '') as entrada_hora, isnull(a.entrada_min, '') as entrada_min, a.hora_reg_entrada, "
sql = sql & " isnull(a.salida_hora, '') as salida_hora, isnull(a.salida_min, '') as salida_min, a.hora_reg_salida, a.fecha_ingreso, a.hora_ingreso "
sql = sql & " from SUC_sucursal_guardias_asistencia a "
sql = sql & " inner join SUC_sucursal b on a.cod_bantotal = b.cod_bantotal "
sql = sql & " where b.id_sucursal = " & idSucursal
sql = sql & " and a.guardia_rut not in ( "
sql = sql & " select guardia_rut from SUC_sucursal_guardias_r where cast(hasta as DATE) < cast(GETDATE() as DATE) ) "

'response.Write(sql & "<br/>")
'response.End()

set rs = db.execute(sql)
if not rs.eof then

%>
<span class="span12 alert alert-success">
<button type="button" class="close btnCerrar pull-right" data-dismiss="alert">&times;</button>
<strong><h4><span id="loadIcon" style="display:none;"><i class="icon-spinner icon-spin icon-large"></i></span> <span class="icon-stack icon-large"><i class="icon-check-empty icon-stack-base"></i><i class="icon-shield"></i></span> Asistencia Guardias</h4></strong>
</span>
<table border="0" class="table table-bordered table-hover" align="center">
    <tr bgcolor="" align="center">
        <td class="" width="9%"><strong>Rut Guardia</strong></td>
        <td class="" width="20%"><strong>Nombre Completo</strong></td>
        <td class="" width="1%"><strong>Cargo</strong></td>
        <td class="" width="14%"><strong>Asistencia</strong></td>
        <td class="" width="14%"><strong>Horario Entrada</strong></td>
        <td class="" width="14%"><strong>Horario Salida</strong></td>        
    </tr>
     <%
	  arr_idasist = ""
	  do while not rs.eof 
	  	id_asistencia = server.htmlencode(trim(rs("id_asistencia")))
		rut_guardia = server.htmlencode(trim(rs("guardia_rut")))
		nombre_guardia = trim(rs("guardia_nombre"))
		tipo_suc = server.htmlencode(trim(rs("tipo_suc")))
		asistencia = server.htmlencode(trim(rs("asistencia")))
		entrada_hora = server.htmlencode(trim(rs("entrada_hora")))
		entrada_min = server.htmlencode(trim(rs("entrada_min")))
		salida_hora = server.htmlencode(trim(rs("salida_hora")))
		salida_min = server.htmlencode(trim(rs("salida_min")))
		
		arr_idasist = arr_idasist & id_asistencia & ","
	%>
    <tr align="center"> 	    
        <td class="" align="center"><%=rut_guardia%></td>
        <td class=""><%=nombre_guardia%></td>
        <td class=""><%=tipo_suc%></td>        
        <td class="" align="center">
        <% if asistencia="si" then 
			Response.Write(asistencia) 
		 end if
		%>         
        </td>
        <td class="" align="center">
        <% if asistencia="si" then 
		   		Response.Write(entrada_hora & ":" & entrada_min) 
		end if %>            
        </td>        
        <td class="" align="center">
        	<% if not (salida_hora = "") then
				Response.Write(salida_hora & ":" & salida_min)				
			   end if
			%>
        </td>
    </tr>     
    <%rs.MoveNext
	loop%>         
  </table> 
<script type="text/javascript">
	$('.btnCerrar').click(function(){			
		$('#lst_persuc_rem').hide();
	});
</script>
<%
end if
	rs.Close
	set rs.ActiveConnection = nothing
	set rs=nothing
	
	DB.Close
	set DB=nothing
%>