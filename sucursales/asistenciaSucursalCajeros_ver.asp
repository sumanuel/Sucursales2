<!--#include file="../funciones.asp"-->
<%
perfil = trim(request("perfil"))
idSucursal = trim(request("idSucursal"))
if idSucursal = "0" then
  idSucursal = trim(request("idSucursal"))
end if

'idSucursal=17
'idSucursal=12

sql = ""
sql = sql & " select "
sql = sql & " a.id_asist_personal, "
sql = sql & " a.tipo_personal, "
sql = sql & " a.bt_sucursal, "
sql = sql & " b.id_sucursal, "
sql = sql & " a.rut_personal, "
sql = sql & " a.nombre_personal, "
sql = sql & " a.fecha_reg, "
sql = sql & " a.hora_reg, "
sql = sql & " a.id_usuario_reg, "
sql = sql & " isnull(a.asistencia, '') as asistencia, "
sql = sql & " a.hora_reg_llegada, "
sql = sql & " isnull(a.hora_llegada, '') as hora_llegada, "
sql = sql & " isnull(a.min_llegada, '') as min_llegada, "
sql = sql & " a.hora_reg_salida, "
sql = sql & " isnull(a.hora_salida, '') as hora_salida, "
sql = sql & " isnull(a.min_salida, '') as min_salida, "
sql = sql & " a.tipo "
sql = sql & " from SUC_sucursal_asistencia_personal a "
sql = sql & " inner join SUC_sucursal b on a.bt_sucursal = b.cod_bantotal "
sql = sql & " where b.id_sucursal = " & idSucursal
sql = sql & " order by a.tipo_personal"

set rs = db.execute(sql)
if not rs.eof then
%>
<div class="span12 well">
<span class="span12 alert alert-success">
<strong><h4><span id="loadIcon" style="display:none;"><i class="icon-spinner icon-spin icon-large"></i></span> <span class="icon-stack icon-large"><i class="icon-check-empty icon-stack-base"></i><i class="icon-user"></i></span> Asistencia Personal</h4></strong>
</span>
<table border="0" class="table table-bordered table-hover" align="center">
    <tr bgcolor="" align="center">
        <td class="" width="9%"><strong>Rut Personal</strong></td>
        <td class="" width="15%"><strong>Nombre Completo</strong></td>        
        <td class="" width="5%"><strong>Cargo</strong></td>
        <td class="" width="7%"><strong>Tipo</strong></td>
        <td class="" width="2%"><strong>Asistencia</strong></td>
        <td class="" width="12%"><strong>Horario Entrada</strong></td>
        <td class="" width="12%"><strong>Horario Salida</strong></td>        
    </tr>
    <%
	arr_idasist = ""
	do while not rs.eof 
		id_asist_personal = server.htmlencode(trim(rs("id_asist_personal")))
		asistencia = server.htmlencode(trim(rs("asistencia")))
		llegada_hora = server.htmlencode(trim(rs("hora_llegada")))
		llegada_min = server.htmlencode(trim(rs("min_llegada")))
		salida_hora = server.htmlencode(trim(rs("hora_salida")))
		salida_min = server.htmlencode(trim(rs("min_salida")))
		rut_personal = server.htmlencode(trim(rs("rut_personal")))
		nombre_personal = trim(rs("nombre_personal"))
		tipo = server.htmlencode(trim(rs("tipo")))
		tipo_personal = server.htmlencode(trim(rs("tipo_personal")))
		
		arr_idasist = arr_idasist & id_asist_personal & ","
	%>
    <tr align="center">
        <td align="center"><%=rut_personal%></td>
        <td><%=nombre_personal%></td>        
        <td align="center"><%=tipo_personal%></td>              
        <td align="center"><%=tipo%></td>              
        <td class="" align="center">
        <% if asistencia="si" then 
			Response.Write(asistencia) 
		   end if %>            
        </td>
        <td class="" align="center">
           <% if asistencia="si" then 
		   		Response.Write(llegada_hora & ":" & llegada_min) 
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
<% else %>
<div class="row-fluid span12 well">
<div class="row-fluid">
	<span class="span12 alert alert-success">
	<strong>
    	<h4>
        	<span id="loadIcon" style="display:none;"><i class="icon-spinner icon-spin icon-large"></i></span> 
	        <span class="icon-stack icon-large"><i class="icon-check-empty icon-stack-base"></i><i class="icon-user"></i></span> 
            Asistencia Cajeros
        </h4>       
    </strong>
</span>
</div>
<div class="row-fluid">
	<span class="span12 alert alert-danger">
		<strong>
        	<h5>Tips:</h5>
            <h6>
            	<ol>
                	<li>No se han cargado los registros de asistencia.</li>
                    <li>Comunicate con tu Zonal para verificar la carga de asistencia Cajeros.</li>
                </ol>
            </h6>
        </strong>
	</span>
</div>
</div>
<% 
end if

sql = ""
sql = sql & " select "
sql = sql & " b.id_sucursal, "
sql = sql & " a.bt_sucursal, "
sql = sql & " a.id_cargo, "
sql = sql & " a.nombre_sucursal, "
sql = sql & " a.nombre_cargo, "
sql = sql & " a.rut_titular, "
sql = sql & " isnull(a.nombre_titular, '') as nombre_titular, "
sql = sql & " a.rut_reemp, "
sql = sql & " a.nombre_reemp, "
sql = sql & " a.desde, "
sql = sql & " a.hasta, "
'sql = sql & " convert(varchar(5), a.hora_ingreso) as hora_ingreso, "
'sql = sql & " convert(varchar(5), a.hora_salida) as hora_salida, "
sql = sql & " convert(varchar(5),(case "
sql = sql & " when isnull(a.hora_ingreso, '00:00:00.0000000') = '00:00:00.0000000' then '08:45:00.0000000' "
sql = sql & " else a.hora_ingreso "
sql = sql & " end)) as hora_ingreso, "
sql = sql & " convert(varchar(5),(case "
sql = sql & " when isnull(a.hora_salida, '00:00:00.0000000') = '00:00:00.0000000' then '18:30:00.0000000' "
sql = sql & " else a.hora_salida "
sql = sql & " end)) as hora_salida, "
sql = sql & " a.motivo, "
sql = sql & " a.fecha_reg, "
sql = sql & " convert(varchar(5), a.hora_reg) as hora_reg, "
sql = sql & " a.empresa "
sql = sql & " from SUC_sucursal_reemplazos a "
sql = sql & " inner join SUC_sucursal b on a.bt_sucursal = b.cod_bantotal "
sql = sql & " where b.id_sucursal = " & idSucursal

'response.Write(sql)
'response.End()

set rs2 = db.execute(sql)
  if not rs2.eof then 
 %> 
 
  <table border="0" class="table table-bordered table-hover" align="center">
    <tr bgcolor="" align="center">
        <td class="" width="9%"><strong>Rut Titular</strong></td>
        <td class="" width="17%"><strong>Nombre</strong></td>
        <td class="" width="10%"><strong>Rut Reemp.</strong></td>        
        <td class="" width="20%"><strong>Nombre Reemp.</strong></td>
        <td class="" width="5%"><strong>Cargo</strong></td>
        <td class="" width="14%" colspan="2"><strong>Fecha Desde - Hasta</strong></td>
        <td class="" width="14%" colspan="2"><strong>Hora Desde - Hasta</strong></td>
        <td class="" width="8%"><strong>Empresa</strong></td>
        <td class=""><strong>Motivo</strong></td>
    </tr>   
    <%
	do while not rs2.eof 		
		r_id_sucursal = server.htmlencode(trim(rs2("id_sucursal")))
		r_bt_sucursal = server.htmlencode(trim(rs2("bt_sucursal")))
		r_id_cargo = server.htmlencode(trim(rs2("id_cargo")))
		r_nombre_sucursal = server.htmlencode(trim(rs2("nombre_sucursal")))
		r_nombre_cargo = server.htmlencode(trim(rs2("nombre_cargo")))
		r_rut_titular = server.htmlencode(trim(rs2("rut_titular")))
		r_nombre_titular = server.htmlencode(trim(rs2("nombre_titular")))
		r_rut_reemp = server.htmlencode(trim(rs2("rut_reemp")))
		r_nombre_reemp = trim(rs2("nombre_reemp"))
		r_desde = server.htmlencode(trim(rs2("desde")))
		r_hasta = server.htmlencode(trim(rs2("hasta")))
		r_hora_ingreso = server.htmlencode(trim(rs2("hora_ingreso")))
		r_hora_salida = server.htmlencode(trim(rs2("hora_salida")))
		r_motivo = server.htmlencode(trim(rs2("motivo")))
		r_fecha_reg = server.htmlencode(trim(rs2("fecha_reg")))
		r_hora_reg = server.htmlencode(trim(rs2("hora_reg")))
		empresa = server.htmlencode(trim(rs2("empresa")))
	%>     
    <tr align="center">
        <td class="" align="center"><%=r_rut_titular%></td>
        <td class=""><%=r_nombre_titular%></td>
        <td class=""><%=r_rut_reemp%></td>
        <td class=""><%=r_nombre_reemp%></td>
        <td class=""><%=r_nombre_cargo%></td>        
        <td class="" align="center"><%=r_desde%></td>
        <td class="" align="center"><%=r_hasta%></td>
        <td class="" align="center"><%=r_hora_ingreso%></td>
        <td class="" align="center"><%=r_hora_salida%></td>
        <td class="" align="center"><%=empresa%></td>
        <td class="" align="center"><%=r_motivo%></td>
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