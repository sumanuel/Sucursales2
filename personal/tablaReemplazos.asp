<!--#include file="../conexion/conexion.asp"-->
<%
idSucursal = request("idSucursal")
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
<input type="hidden" name="idSucursal" id="idSucursal" value="<%=idSucursal%>"/> 
<script type="text/javascript">
	$('.btnCerrar').click(function(){			
		$('#lst_persuc_rem').hide();
	});
</script>

<%end if%>