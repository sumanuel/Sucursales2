<!--#include file="../conexion/conexion.asp"-->
<%
idSucursal = request("idSucursal")
tipoVista = request("tipoVista")


if tipoVista = 2 then
	fecha = request("fecha")
else
	codBtt = request("codbtt")
end if

sql = ""
sql = sql & " select "
if tipoVista = 1 then
	sql = sql & " a.id_asist_personal, "
else
	sql = sql & " a.id_asist_personal_respaldo as id_asist_personal, "
end if
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
sql = sql & " a.tipo, "
sql = sql & " case "
sql = sql & " when c.rut_personal is not null then '(S)' "
sql = sql & " else '' end as flag_supervisor "
if tipoVista = 1 then
	sql = sql & " from SUC_sucursal_asistencia_personal a "
	sql = sql & " inner join SUC_sucursal b on a.bt_sucursal = b.cod_bantotal "
	sql = sql & " left outer join SUC_sucursal_personal_supervisor c on a.bt_sucursal =  c.cod_bantotal and a.rut_personal = c.rut_personal "
	sql = sql & " where b.id_sucursal = " & idSucursal
else
	sql = sql & " from SUC_sucursal_asistencia_personal_respaldo a "
	sql = sql & " inner join SUC_sucursal b on a.bt_sucursal = b.cod_bantotal "
	sql = sql & " left outer join SUC_sucursal_personal_supervisor c on a.bt_sucursal =  c.cod_bantotal and a.rut_personal = c.rut_personal "
	sql = sql & " where b.id_sucursal = " & idSucursal & " and convert(nvarchar(8),a.fecha_reg,112) = " & fecha
end if
sql = sql & " order by a.tipo_personal"

'response.write(sql)
'response.end()

set rs = db.execute(sql)
if not rs.eof then
%>



<div class="span12 row-fluid">
	<span class="span12 alert alert-info">
		<strong><h4></span>Asistencia Sucursal</h4></strong>
	</span>
</div>
<input hidden id="codBtt2" value="<%=codBtt%>"/>
<div class="oculto" id="frameModPersonal">
Modificar Personal
<br/><br/>
</div>
<style type="text/css"> 
    .cuerpoTabla{
        background: #f2f2f2;
    }              
    .table-hover1>tbody>tr:hover>td, 

    .table-hover1>tbody>tr:hover>th {
       background-color: #FFE49A;
       color:#0d0d0d;
    }
.table thead {
  color: #0A090A; 
  background-color: #D9E8FF; /* Color de fondo de cabecera */
}
</style>

<table id="ctrolCajeroTablaSucursalAsistencia" border="0" class="table table-bordered table-hover1 table-condensed table-striped cuerpoTabla" align="center" data-idSucursal="<%=idSucursal%>">
	<thead>
	    <tr bgcolor="" align="center">
		        <th class="" width="9%">Rut Personal</th>
		        <th class="" width="15%">Nombre Completo</th>        
		        <th class="" width="5%">Cargo</th>
		        <th class="" width="7%">Tipo</th>
		        <th class="" width="7%">Empresa</th>
		        <th class="" width="2%">Asistencia</th>
		        <th class="" width="12%">Horario Entrada</th>
		        <th class="" width="12%">Horario Salida</th>
		        <%if tipoVista = 1 then%>
		        <th class="" width="3%">--</th>
		        <th class="" width="3%">--</th>    
		        <th class="" width="3%">--</th> 
		        <% end if%> 
	    </tr>
	</thead>
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
		flag_supervisor = server.htmlencode(trim(rs("flag_supervisor")))
		
		arr_idasist = arr_idasist & id_asist_personal & ","
	%>
    <tr align="center" id="<%=id_asist_personal%>">
        <td align="center"><%=rut_personal%></td>
        <td><%=nombre_personal%>&nbsp;<strong><%=flag_supervisor%></strong></td>        
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
	<%if tipoVista = 1 then%>

        <td>
        	<i class="icon-file icon-large mano modPersonal" data-tipoPersonal="<%=tipo%>" data-idAsistPersonal="<%=id_asist_personal%>"></i></td>
        <td>
        	<i class="icon-trash icon-large mano delPersonal" data-idAsistPersonal="<%=id_asist_personal%>"></i>
        </td> 
        <td>
        	<i class="icon-refresh icon-large mano refPersonal" data-idAsistPersonal="<%=id_asist_personal%>"></i>
        </td>   
	<%end if%>

    </tr>  
    <%rs.MoveNext
	loop%>      
  </table>
  <br/><br/>
  <script type="text/javascript">
  	var idSucursalMod =  $('#ctrolCajeroTablaSucursalAsistencia').attr("data-idSucursal"); 

  	$('.refPersonal').click(function(){
  		var idAsist = $(this).attr("data-idAsistPersonal"); 

  		if(confirm('Seguro que desea eliminar el registro de asistencia seleccionado ??')){
				var div = '';
				var pagina = 'personal_ingreso_data.asp';
				var datos = 'tipoprc=7&idAsist='+idAsist;
				try{
					enviaDatos(pagina,div,datos);
				}catch(err){}						

				div = 'lst_persuc_rem';
				datos = '';
				pagina = 'ctrolCajeroTablaSucursalAsitencia.asp';
				datos = 'idSucursal='+idSucursalMod+'&tipoVista=1';
				try{					
					enviaDatos(pagina,div,datos);
				}catch(err){}
					
				div = 'ctrolCajeroTablaSucursal';
				pagina = 'ctrolCajeroTablaSucursal.asp';
				datos = 'idSucursal='+idSucursalMod+'&tipoVista=1';
				try{					
					enviaDatos(pagina,div,datos);
				}catch(err){}
				div = 'tablaReemplazos';
				pagina = 'tablaReemplazos.asp';
				datos = 'idSucursal='+idSucursalMod;
				try{					
					enviaDatos(pagina,div,datos);
				}catch(err){}
				//$('tr#'+idAsist).hide('slow');
			}
  	});
    $('.modPersonal').click(function(){
			var codBtt = $('#codBtt2').val();
			var idSucursal = $('#ctrolCajeroTablaSucursalAsistencia').attr('data-idSucursal');
			//console.log(codBtt);
			var idPersonal = $(this).attr("data-idAsistPersonal");
			var tipoPersonal = $(this).attr("data-tipoPersonal");
			var idTipoPersonal = 0;
			
			if(tipoPersonal == 'titular')
				idTipoPersonal = 3;
			else
				idTipoPersonal = 4;
			
			//alert('modPersonal: '+idPersonal);	
			$('#frameModPersonal').removeClass('oculto');
			var div = 'frameModPersonal';
			var pagina = 'personal_ingreso.asp';
			var datos = 'idPersonal='+idPersonal+'&tipoPersonal='+idTipoPersonal+'&codBtt='+codBtt+'&tipoVista=0&idSucursal='+idSucursal;
			try{
				enviaDatos(pagina,div,datos);
			}catch(err){}		
		});
		
    $('.delPersonal').on('click', function(){	
			var idAsist = $(this).attr('data-idasistpersonal');			
			
			if(confirm('Seguro que desea eliminar el personal seleccionado ??')){
				var div = '';
				var pagina = 'personal_ingreso_data.asp';
				var datos = 'tipoprc=4&idAsist='+idAsist;
				try{
					enviaDatos(pagina,div,datos);
				}catch(err){}
					
				div = 'lst_persuc_rem';
				datos = '';
				pagina = 'ctrolCajeroTablaSucursalAsitencia.asp';
				datos = 'idSucursal='+idSucursalMod+'&tipoVista=1';
				try{
					enviaDatos(pagina,div,datos);
				}catch(err){}
					
				div = 'ctrolCajeroTablaSucursal';
				pagina = 'ctrolCajeroTablaSucursal.asp';
				datos = 'idSucursal='+idSucursalMod+'&tipoVista=1';
				try{
					enviaDatos(pagina,div,datos);
				}catch(err){}
				div = 'tablaReemplazos';
				pagina = 'tablaReemplazos.asp';
				datos = 'idSucursal='+idSucursalMod;
				try{
					enviaDatos(pagina,div,datos);
				}catch(err){}
				$('tr#'+idAsist).hide('slow');
			}
			
		});		
  </script>
  
  <%
end if%>
<div id="tablaReemplazos">
<%sql = ""
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
sql = sql & " a.empresa, "
sql = sql & " case when c.rut_personal is not null then '(S)' "
sql = sql & " else '' end as flag_supervisor "
sql = sql & " from SUC_sucursal_reemplazos a "
sql = sql & " inner join SUC_sucursal b on a.bt_sucursal = b.cod_bantotal "
sql = sql & " left outer join SUC_sucursal_personal_supervisor c on a.bt_sucursal =  c.cod_bantotal and a.rut_titular = c.rut_personal "
sql = sql & " where b.id_sucursal = " & idSucursal

'response.Write(sql)
'response.End()

set rs2 = db.execute(sql)

if not rs2.eof then 
%>  
  <table border="0" class="table table-bordered table-hover1 table-condensed table-striped cuerpoTabla" align="center">
 	<thead>
	    <tr bgcolor="" align="center">
	        <th class="" width="9%">Rut Titular</th>
	        <th class="" width="17%">Nombre</th>
	        <th class="" width="10%">Rut Reempl.</th>
	        <th class="" width="20%">Nombre Reempl.</th>
	        <th class="" width="5%">Cargo</th>
	        <th class="" width="14%" colspan="2">Fecha Desde - Hasta</th>
	        <th class="" width="14%" colspan="2">Hora Desde - Hasta</th>
	        <th class="" width="8%">Empresa</th>
	        <th class="">Motivo</th>
	    </tr>
    </thead> 
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
		flag_supervisor = server.htmlencode(trim(rs2("flag_supervisor")))
	%>     
    <tr align="center">
        <td class="" align="center"><%=r_rut_titular%></td>
        <td class=""><%=r_nombre_titular%>&nbsp;<strong><%=flag_supervisor%></strong></td>
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
</div>
<br/><br/>
<input type="hidden" name="idSucursal" id="idSucursal" value="<%=idSucursal%>"/> 
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

rs2.Close
set rs2.ActiveConnection = nothing
set rs2=nothing

DB.Close
set DB=nothing
%>