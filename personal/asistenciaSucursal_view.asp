<!--#include file="../conexion/conexion.asp"-->
<%
	codBantotal = request("codBantotal")
	fechaRespaldo = request("fechaRespaldo")
	tipoQuery = request("tipo")
	tipoControl = request("tipoControl")
%>
<% if tipoControl = "1" then 'CONTROL TITULAR %>
<%
	if tipoQuery = "1" then 'CONTROL ONLINE
		Dim progCc2
		sql = ""	
		sql = sql & " select  cod_bantotal,suc_nombre,titulares, "
		sql = sql & " titulares_presentes,titulares_ausentes,titulares_sinreg, "
		sql = sql & " titulares_atrasos,reemplazos, reemplazos_presentes, reemplazos_ausentes,reemplazos_sinreg, "
		sql = sql & " reemplazos_atrasos, cajeros_layout, proveedor "
		sql = sql & " from vw_controlDetalleAsistenciaTitulares "
		sql = sql & " where cod_bantotal = " & codBantotal
		set progCc2 = db.execute(sql)

		if not progCc2.EOF then
			cod_bantotal = progCc2("cod_bantotal")
			suc_nombre = progCc2("suc_nombre")
			titulares = progCc2("titulares")
			titulares_presentes = progCc2("titulares_presentes")
			titulares_ausentes = progCc2("titulares_ausentes")
			titulares_sinreg = progCc2("titulares_sinreg")
			titulares_atrasos = progCc2("titulares_atrasos")
			reemplazos = progCc2("reemplazos")
			reemplazos_presentes = progCc2("reemplazos_presentes")
			reemplazos_ausentes = progCc2("reemplazos_ausentes")
			reemplazos_sinreg = progCc2("reemplazos_sinreg")
			reemplazos_atrasos = progCc2("reemplazos_atrasos")
			cajeros_layout = progCc2("cajeros_layout")
			proveedor = progCc2("proveedor")

			sumTituReem2 = (titulares - ( titulares_presentes + reemplazos_presentes))
%>
		<table class="table table-bordered table-condensed table-hover" id="tablaCuadroDetalleSucursal">
			<thead>
			<tr class="info">
				<th>Estado</th>
				<th>Presentes vs Dotación</th>
				<th>Cod BTT</th>								
				<th>Sucursal</th>
				<th>Titulares</th>
				<th>Titulares Presentes</th>
				<th>Titulares Ausentes</th>
				<th>Titulares Sin Reg.</th>
				<th>Titulares Atrasos</th>
				<th>Reemplazos</th>
				<th>Reemplazos Presentes</th>
				<th>Reemplazos Ausentes</th>
				<th>Reemplazos Sin Reg.</th>
				<th>Reemplazos Atrasos</th>
				<th>Cajeros Layout</th>
				<th>Proveedor</th>					
			</tr>
			</thead>
			<tbody>	
				<tr class="info">
					<style type="text/css">
						 img.imgAlert{width: 12px; height: 12px;}				
					</style>

					<%if sumTituReem2 <> 0 then %>
						<td><img src="../img/projo.png" class="imgAlert"></td>
					<%else%>
						<td><img src="../img/pverde.png" class="imgAlert"></td>
					<% end if %>
					<td><%=sumTituReem2%></td>
					<td><%=cod_bantotal%></td>								
					<td><%=suc_nombre%></td>
					<td><%=titulares%></td>
					<td><%=titulares_presentes%></td>
					<td><%=titulares_ausentes%></td>
					<td><%=titulares_sinreg%></td>
					<td><%=titulares_atrasos%></td>
					<td><%=reemplazos%></td>
					<td><%=reemplazos_presentes%></td>
					<td><%=reemplazos_ausentes%></td>
					<td><%=reemplazos_sinreg%></td>
					<td><%=reemplazos_atrasos%></td>
					<td><%=cajeros_layout%></td>
					<td><%=proveedor%></td>
				</tr>
			</tbody>
		</table>
<% 	  end if	
	end if
	if tipoQuery = "2" then 'CONTROL RESPALDO
		sql = ""
		sql = sql & " SET dateformat dmy "
		sql = sql & " SELECT "
		sql = sql & " FECHA_RESPALDO, PROVEEDOR, SUM(TITULARES) AS titulares, "
		sql = sql & " SUM(TITULARES_PRESENTES) AS titulares_presentes, "
		sql = sql & " SUM(TITULARES_AUSENTES) AS titulares_ausentes, "
		sql = sql & " SUM(TITULARES_SINREG) AS titulares_sinreg, "
		sql = sql & " SUM(TITULARES_ATRASOS) AS titulares_atrasos, "
		sql = sql & " SUM(REEMPLAZOS) AS reemplazos, "
		sql = sql & " SUM(REEMPLAZOS_PRESENTES) AS reemplazos_presentes, "
		sql = sql & " SUM(REEMPLAZOS_AUSENTES) AS reemplazos_ausentes, "
		sql = sql & " SUM(REEMPLAZOS_SINREG) AS reemplazos_sinreg, "
		sql = sql & " SUM(REEMPLAZOS_ATRASOS) AS reemplazos_atrasos "
		sql = sql & " FROM dbo.SUC_control_detalle_asistenciaTitulares "
		sql = sql & " WHERE cod_bantotal = " & codBantotal & " and FECHA_RESPALDO = '"&fechaRespaldo&"' "
		sql = sql & " GROUP BY FECHA_RESPALDO, PROVEEDOR "
		
		'response.write(sql)
		'response.end()
		set progCc3 = db.execute(sql)
		if not progCc3.EOF then
%>		
		<table class="table table-bordered table-hover">
			<tr class="info">
				<th>Estado</th>
				<th>Presentes vs Dotación</th>
				<th>Fecha de Respaldo</th>
				<th>Titulares</th>	
				<th>Titulares Presentes</th>				
				<th>Titulares Ausentes</th>
				<th>Titulares Sin Registros</th>
				<th>Titulares Atrasos</th>
				<th>Reemplazos</th>
				<th>Reemplazos Presentes</th>
				<th>Reemplazos Ausentes</th>
				<th>Reemplazos Sin Registros</th>
				<th>Reemplazos Atrasos</th>					
			</tr>
			<tr class="info">
				<% sumTituReem2 = (progCc3("titulares") - ( progCc3("titulares_presentes") + progCc3("reemplazos_presentes"))) %>

				<style type="text/css">
					 img.imgAlert{width: 12px; height: 12px;}				
				</style>

				<%if sumTituReem2 <> 0 then %>
					<td><img src="../img/projo.png" class="imgAlert"></td>
				<%else%>
					<td><img src="../img/pverde.png" class="imgAlert"></td>
				<% end if %>

				<td><%=sumTituReem2%></td>

				<td><%=progCc3("fecha_respaldo")%></td>				
				<td><%=progCc3("titulares")%></td>
				<td><%=progCc3("titulares_presentes")%></td>
				<td><%=progCc3("titulares_ausentes")%></td>
				<td><%=progCc3("titulares_sinreg")%></td>
				<td><%=progCc3("titulares_atrasos")%></td>
				<td><%=progCc3("reemplazos")%></td>
				<td><%=progCc3("reemplazos_presentes")%></td>
				<td><%=progCc3("reemplazos_ausentes")%></td>
				<td><%=progCc3("reemplazos_sinreg")%></td>
				<td><%=progCc3("reemplazos_atrasos")%></td>					
			</tr>			
		</table>		
<%	 end if 
    end if 
   end if
 %>

<% if tipoControl = "2" then 'CONTROL ADICIONAL %>
<%
	if tipoQuery = "1" then 'CONTROL ONLINE
		Dim prog3
		sql = ""	
		sql = sql & " SELECT B.COD_BANTOTAL, B.SUC_NOMBRE, TOTAL_ADICIONALES, "
		sql = sql & " ADICIONALES_PRESENTES, ADICIONALES_AUSENTES, "
		sql = sql & " ADICIONALES_SIN_REGISTROS, proveedor, "
		sql = sql & " (SELECT C.nro_adicional "
		sql = sql & " FROM SUC_sucursal_cajeros_dimen C "
		sql = sql & " WHERE C.fecha = CAST(GETDATE() AS DATE) "
		sql = sql & " and C.cod_bantotal = A.COD_BANTOTAL) AS DIMEN "
		sql = sql & " FROM vw_controlDetalleAsistenciaAdicional AS A "
	 	sql = sql & " INNER JOIN SUC_SUCURSAL AS B ON A.COD_BANTOTAL = B.COD_BANTOTAL "	
		sql = sql & " WHERE B.cod_bantotal = " & codBantotal

		'response.write(sql)
		'response.end()

		set prog3 = db.execute(sql)
		if not prog3.EOF then
%>
		<table class="table table-bordered table-condensed table-hover" id="tablaCuadroDetalleSucursal">
			<thead>
			<tr class="success">
				<th>Sucursal</th>
				<th>Estado</th>
				<th>Pesentes vs Dotacion</th>
				<th>Dimen. <%=FormatDateTime(Date, 0)%></th>
				<th>Total Adicionales</th>
				<th>Adicionales Presentes</th>
				<th>Adicionales Ausentes</th>
				<th>Adicionales Sin Registros</th>
				<th>Proveedor</th>					
			</tr>
			</thead>
			<tbody>	
				<tr class="info">
					<% sumTituReem = (cint(prog3("TOTAL_ADICIONALES"))-cint(prog3("ADICIONALES_AUSENTES"))) %>
					<style type="text/css">
						 img.imgAlert{width: 12px; height: 12px;}				
					</style>
					<td><%=prog3("SUC_NOMBRE")%></td>
					<%if sumTituReem <> 0 then %>
						<td><img src="../img/projo.png" class="imgAlert"></td>
					<%else%>
						<td><img src="../img/pverde.png" class="imgAlert"></td>
					<% end if %>
					<td><%=sumTituReem%></td>	
					<td><%=prog3("DIMEN")%></td>			
					<td><%=prog3("TOTAL_ADICIONALES")%></td>
					<td><%=prog3("ADICIONALES_PRESENTES")%></td>
					<td><%=prog3("ADICIONALES_AUSENTES")%></td>
					<td><%=prog3("ADICIONALES_SIN_REGISTROS")%></td>
					<td><%=prog3("proveedor")%></td>	
				<tr/>				
			</tbody>
		</table>
<%	end if
	end if
	if tipoQuery = "2" then 'CONTROL RESPALDO
		sql = ""
		sql = sql & "SET dateformat dmy "
		sql = sql & "SELECT FECHA_RESPALDO, "
		sql = sql & "COD_BANTOTAL, "
		sql = sql & "SUC_NOMBRE, "
		sql = sql & "TOTAL_ADICIONALES, "
		sql = sql & "ADICIONALES_PRESENTES, "
		sql = sql & "ADICIONALES_AUSENTES, "
		sql = sql & "ADICIONALES_SIN_REGISTROS, "
		sql = sql & "PROVEEDOR "
		sql = sql & "FROM dbo.vw_controlDetalleAsistenciaAdicionalMes "
		sql = sql & "WHERE cod_bantotal = "& codBantotal &" and fecha_respaldo = '"& fechaRespaldo &"' "	

		'response.write(sql)
		'response.end()
		set prog3 = db.execute(sql)
		if not prog3.EOF then
%>
		<table class="table table-bordered table-condensed table-hover" id="tablaCuadroDetalleSucursal">
		<thead>
		<tr class="success">
			<th>Fecha Respaldo</th>
			<th>Estado</th>
			<th>Pesentes vs Dotacion</th>
			<th>Total Adicionales</th>
			<th>Adicionales Presentes</th>
			<th>Adicionales Ausentes</th>
			<th>Adicionales Sin Registros</th>
			<th>Proveedor</th>					
		</tr>
		</thead>
		<tbody>	
			<tr class="info">
				<% sumTituReem = (cint(prog3("TOTAL_ADICIONALES"))-cint(prog3("ADICIONALES_AUSENTES"))) %>
				<style type="text/css">
					 img.imgAlert{width: 12px; height: 12px;}				
				</style>

				<td><%=prog3("FECHA_RESPALDO")%></td>
				<%if sumTituReem <> 0 then %>
					<td><img src="../img/projo.png" class="imgAlert"></td>
				<%else%>
					<td><img src="../img/pverde.png" class="imgAlert"></td>
				<% end if %>
				<td><%=sumTituReem%></td>
				<td><%=prog3("TOTAL_ADICIONALES")%></td>
				<td><%=prog3("ADICIONALES_PRESENTES")%></td>
				<td><%=prog3("ADICIONALES_AUSENTES")%></td>
				<td><%=prog3("ADICIONALES_SIN_REGISTROS")%></td>
				<td><%=prog3("proveedor")%></td>	
			<tr/>				
		</tbody>
		</table>
<%	 end if
	end if
%>
<% end if %>

<% if tipoQuery = "1" then 'ASISTENCIA ONLINE
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
	sql = sql & " a.empresa, "
	sql = sql & " a.tipo "
	sql = sql & " from SUC_sucursal_asistencia_personal a "
	sql = sql & " inner join SUC_sucursal b on a.bt_sucursal = b.cod_bantotal "
	sql = sql & " where b.cod_bantotal = " & codBantotal
	sql = sql & " order by a.tipo_personal"
end if

if tipoQuery = "2" then 'ASISTENCIA RESPALDO
	sql = ""
	sql = sql & " set dateformat dmy "
	sql = sql & " select "
	sql = sql & " a.id_asist_personal_respaldo as id_asist_personal, "
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
	sql = sql & " a.empresa, "
	sql = sql & " a.tipo "
	sql = sql & " from SUC_sucursal_asistencia_personal_respaldo a "
	sql = sql & " inner join SUC_sucursal b on a.bt_sucursal = b.cod_bantotal "	
	sql = sql & " where b.cod_bantotal = " & codBantotal & " and "
	sql = sql & " a.fecha_respaldo = '"& fechaRespaldo &"' "
	sql = sql & " order by a.tipo_personal"
end if

'response.Write(sql)
'response.end()

set rs = db.execute(sql)
if not rs.eof then
%>
<table border="0" class="table table-bordered table-hover table-condensed" align="center">
    <tr bgcolor="" align="center">
        <td class="" width="9%"><strong>Rut Personal</strong></td>
        <td class="" width="15%"><strong>Nombre Completo</strong></td>        
        <td class="" width="5%"><strong>Cargo</strong></td>
        <td class="" width="7%"><strong>Tipo</strong></td>
        <td class="" width="7%"><strong>Empresa</strong></td>
        <td class="" width="2%"><strong>Asistencia</strong></td>
        <td class="" width="12%"><strong>Horario Entrada</strong></td>
        <td class="" width="12%"><strong>Horario Salida</strong></td>        
    </tr>
    <%
	arr_idasist = ""
	do while not rs.eof 
		id_asist_personal =trim(rs("id_asist_personal"))
		asistencia = server.htmlencode(trim(rs("asistencia")))
		llegada_hora = server.htmlencode(trim(rs("hora_llegada")))
		llegada_min = server.htmlencode(trim(rs("min_llegada")))
		salida_hora = server.htmlencode(trim(rs("hora_salida")))
		salida_min = server.htmlencode(trim(rs("min_salida")))
		rut_personal = server.htmlencode(trim(rs("rut_personal")))
		nombre_personal = server.htmlencode(trim(rs("nombre_personal")))
		tipo = server.htmlencode(trim(rs("tipo")))
		tipo_personal = server.htmlencode(trim(rs("tipo_personal")))
		empresa = server.htmlencode(trim(rs("empresa")))
		
		arr_idasist = arr_idasist & id_asist_personal & ","
	%>
    <tr align="center" id="<%=id_asist_personal%>">
        <td align="center"><%=rut_personal%></td>
        <td><%=nombre_personal%></td>        
        <td align="center"><%=tipo%></td>
        <td align="center"><%=tipo_personal%></td>
        <td align="center"><%=empresa%></td>
        <td class="" align="center">
	        <% Response.Write(asistencia) %>			
        </td>
        <td class="" align="center">
           <% if asistencia="si" then 
		   		Response.Write(llegada_hora & ":" & llegada_min) 
		   	  end if 
		   %>              
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
<% end if %>

<%

if tipoQuery = "1" then 'ASISTENCIA REEMPLAZO ONLINE
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
	sql = sql & " where b.cod_bantotal = " & codBantotal
end if 

if tipoQuery = "2" then 'ASISTENCIA REEMPLAZO RESPALDO
	sql = ""
	sql = sql & " set dateformat dmy "
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
	sql = sql & " from SUC_sucursal_reemplazos_resp a "
	sql = sql & " inner join SUC_sucursal b on a.bt_sucursal = b.cod_bantotal "
	sql = sql & " where b.cod_bantotal = " & codBantotal & " and "
	sql = sql & " a.fecha_respaldo = '"& fechaRespaldo &"'"
end if

'response.Write(sql)
'response.End()

set rs2 = db.execute(sql)
if not rs2.eof then 
%>  
  <div id="tablaReemplazos">
  <table border="0" class="table table-bordered table-hover table-condensed" align="center">
    <tr bgcolor="" align="center">
        <td class="" width="9%"><strong>Rut Titular</strong></td>
        <td class="" width="17%"><strong>Nombre</strong></td>
        <td class="" width="10%"><strong>Rut Reempl.</strong></td>
        <td class="" width="20%"><strong>Nombre Reempl.</strong></td>
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
		r_nombre_reemp = server.htmlencode(trim(rs2("nombre_reemp")))
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