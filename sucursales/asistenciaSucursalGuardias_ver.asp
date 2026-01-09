<!--#include file="../funciones.asp"-->
<%
perfil = trim(request("perfil"))
idSucursal = trim(request("idSucursal"))
if idSucursal = "0" then
  idSucursal = trim(request("idSucursal"))
end if

'idSucursal=120

sql = ""
sql = sql & " select a.id_asistencia, a.cod_bantotal, a.sucursal, a.tipo, a.empresa, a.guardia_nombre, a.guardia_rut, "
sql = sql & " a.tipo_suc, a.id_usuario, isnull(a.asistencia, '') as asistencia, a.guardia_p_entrada, a.guardia_p_salida, "
sql = sql & " isnull(a.entrada_hora, '') as entrada_hora, isnull(a.entrada_min, '') as entrada_min, a.hora_reg_entrada, "
sql = sql & " isnull(a.salida_hora, '') as salida_hora, isnull(a.salida_min, '') as salida_min, a.hora_reg_salida, a.fecha_ingreso, a.hora_ingreso "
sql = sql & " from SUC_sucursal_guardias_asistencia a "
sql = sql & " inner join SUC_sucursal b on a.cod_bantotal = b.cod_bantotal "
sql = sql & " where b.id_sucursal = " & idSucursal
sql = sql & " and a.guardia_rut not in ( "
sql = sql & " select guardia_rut from SUC_sucursal_guardias_r where cast(hasta as DATE) < cast(GETDATE() as DATE) ) "

'response.Write(sql)
'response.End()

set rs = db.execute(sql)
if not rs.eof then

%>
<div class="span12 well">
<span class="span12 alert alert-success">
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
		   end if %>
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
  <input type="hidden" id="arr_idasist" value="<%=arr_idasist%>"/>  
 <% end if %>
 
<%
sql = ""
sql = sql & " select a.cod_bantotal, a.sucursal, a.tipo, a.empresa, a.guardia_nombre, a.guardia_rut, a.mes, isnull(a.desde, '') as reemplazo_desde, isnull(a.hasta, '') as reemplazo_hasta, a.motivo "
sql = sql & " from SUC_sucursal_guardias_r a "
sql = sql & " inner join SUC_sucursal b on a.cod_bantotal = b.cod_bantotal "
sql = sql & " where b.id_sucursal = " & idSucursal

'response.Write(sql)
'response.End()

set rs2 = db.execute(sql)
  if not rs2.eof then 
 %>
  <table class="table table-bordered table-hover" align="center">
    <tr bgcolor="" align="center">
        <td class="" width="10%"><strong>Rut Reempl.</strong></td>
        <td class="" width="20%"><strong>Nombre</strong></td>        
        <td class="" width="10%"><strong>Fecha Desde</strong></td>
        <td class="" width="8%"><strong>Fecha Hasta</strong></td>
        <td class="" width="18%"><strong>Empresa</strong></td>
        <td class="" width="14%"><strong>Motivo</strong></td>
    </tr>
   	<%
		do while not rs2.eof 		
			r_cod_bantotal = server.htmlencode(trim(rs2("cod_bantotal")))
			r_sucursal = server.htmlencode(trim(rs2("sucursal")))
			r_tipo = server.htmlencode(trim(rs2("tipo")))
			r_empresa = server.htmlencode(trim(rs2("empresa")))
			r_guardia_nombre = server.htmlencode(trim(rs2("guardia_nombre")))
			r_guardia_rut = server.htmlencode(trim(rs2("guardia_rut")))
			r_reemplazo_mes = server.htmlencode(trim(rs2("mes")))
			r_reemplazo_desde = server.htmlencode(trim(rs2("reemplazo_desde")))
			r_reemplazo_hasta = server.htmlencode(trim(rs2("reemplazo_hasta")))
			r_reemplazo_motivo = server.htmlencode(trim(rs2("motivo")))			
	%>      
    <tr align="center">
        <td class="" align="center"><%=r_guardia_rut%></td>
        <td class=""><%=r_guardia_nombre%></td>                
        <td class="" align="center"><%=r_reemplazo_desde%></td>
        <td class="" align="center"><%=r_reemplazo_hasta%></td>
        <td class="" align="center"><%=r_empresa%></td>
        <td class="" align="center"><%=r_reemplazo_motivo%></td>
    </tr>	
    <%rs2.MoveNext
	loop%>
   </table>  
 </div>
 
<%
end if
	rs.Close
	set rs.ActiveConnection = nothing
	set rs=nothing
	
	rs2.Close
	set rs2.ActiveConnection = nothing
	set rs2=nothing
	
	DB.Close
	set DB=nothing
%>