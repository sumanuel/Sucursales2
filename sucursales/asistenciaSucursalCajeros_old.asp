<!--#include file="../funciones.asp"-->
<%
perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
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
sql = sql & " isnull(a.min_salida, '') as min_salida, a.tipo "
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
<input type="hidden" name="idUsuario" id="idUsuario" value="<%=idUsuario%>"/>
<table border="0" class="table table-bordered table-hover" align="center">
    <tr bgcolor="" align="center">
        <td class="" width="9%"><strong>Rut Personal</strong></td>
        <td class="" width="15%"><strong>Nombre Completo</strong></td>        
        <td class="" width="5%"><strong>Cargo</strong></td>
        <td class="" width="7%"><strong>Tipo</strong></td>        
        <td class="" width="2%"><strong>Asistencia</strong></td>
        <td class="" width="12%"><strong>Horario Entrada</strong></td>
        <td class="" width="12%"><strong>Horario Salida</strong></td>
        <td class="" width="14%"><strong>---</strong></td>
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
		nombre_personal = server.htmlencode(trim(rs("nombre_personal")))
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
		   else %>
			<select name="asistencia" class="input-mini" id="asist<%=id_asist_personal%>">
                <option value="si" >Si</option>
                <option value="no" selected="selected">No</option>
            </select>        
		<% end if %>            
        </td>
        <td class="" align="center">
           <% if asistencia="si" then 
		   		Response.Write(llegada_hora & ":" & llegada_min) 
		   	  else %>
                <select name="hora_entrada" class="input-mini" id="eh<%=id_asist_personal%>">
                <% For h=0 to 23 
                    if h=8 then %>
                        <option value=<%response.Write(h)%> selected="selected" ><%response.Write(h)%></option>
                    <% else %>
                        <option value=<%response.Write(h)%>><%response.Write(h)%></option>
                    <% end if
                Next %>
                </select>
                <select name="minuto_entrada" class="input-mini" id="em<%=id_asist_personal%>">
                <% For m=0 to 59 
                    if m=45 then %>
                        <option value=<%response.Write(m)%> selected="selected" ><%response.Write(m)%></option>
                    <% else %>
                        <option value=<%response.Write(m)%>><%response.Write(m)%></option>
                    <% end if
                Next %>
                </select>
           <% end if %> 
        </td>        
        <td class="" align="center">        	
        	<select name="hora_salida" class="input-mini" id="sh<%=id_asist_personal%>">
            <% For h=0 to 23 
				if not salida_hora = "" then
					if h=cint(salida_hora) then %>
                    	<option value=<%response.Write(h)%> selected="selected" ><%response.Write(h)%></option>
                	<% else %>
                    	<option value=<%response.Write(h)%>><%response.Write(h)%></option>
                	<% end if
				else
					if h=8 then %>
                    	<option value=<%response.Write(h)%> selected="selected" ><%response.Write(h)%></option>
                	<% else %>
                    	<option value=<%response.Write(h)%>><%response.Write(h)%></option>
                	<% end if
				end if                
            Next %>
            </select>            
            <select name="minuto_salida" class="input-mini" id="sm<%=id_asist_personal%>">
            <% For m=0 to 59 
				if not salida_hora = "" then
					if m=cint(salida_min) then %>
                        <option value=<%response.Write(m)%> selected="selected" ><%response.Write(m)%></option>
                    <% else %>
                        <option value=<%response.Write(m)%>><%response.Write(m)%></option>
                    <% end if
				else
					if m=45 then %>
                    	<option value=<%response.Write(m)%> selected="selected" ><%response.Write(m)%></option>
					<% else %>
                        <option value=<%response.Write(m)%>><%response.Write(m)%></option>
                    <% end if
				end if                 
            Next %>
            </select>
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
  <table width="70%" border="0" cellspacing="0" cellpadding="1" class="" align="center">
     <tr>
         <td align="center">
         	<div class="btn btn-success botonEnviaEntrada"><i class="icon-signin icon-large"/><strong> Enviar Entrada</strong></div>         	
         </td>
         <td align="center">
         	<div class="btn btn-danger botonEnviaSalida"><i class="icon-signout icon-large"/><strong> Enviar Salida</strong></div>
         </td>
     </tr>
  </table>
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
<% end if %>
 <script type="text/javascript">
 $('.botonEnviaEntrada').click(function(){		
  var arr_id = $('#arr_idasist').val();
  if (arr_id !== ''){
		arr_id = arr_id.substring(0, (arr_id.length)-1);	
		var v_arrid = 	arr_id.split(',');
    var xml = '<root>';
    $.each(v_arrid, function (index, elem) { 		  
      //console.log(elem);
      xml += '<p>';
      xml += '<id>' + elem + '</id>';
      xml += '<tipo>entrada</tipo>';			  
      
      if($('#'+'asist'+elem).val())
        xml += '<asist>' + $('#'+'asist'+elem).val() + '</asist>';
      else 
        xml += '<asist></asist>';
      //console.log($('#'+'asist'+elem).val());
      
      if($('#'+'eh'+elem).val())
        xml += '<eh>' + $('#'+'eh'+elem).val() + '</eh>';
      else 
        xml += '<eh></eh>';
      //console.log($('#'+'eh'+elem).val());
      if($('#'+'em'+elem).val())
        xml += '<em>' + $('#'+'em'+elem).val() + '</em>';
      else 
        xml += '<em></em>';
      //console.log($('#'+'em'+elem).val());
      if($('#'+'sh'+elem).val())
        xml += '<sh>' + $('#'+'sh'+elem).val() + '</sh>';
      else 
        xml += '<sh></sh>';
      //console.log($('#'+'sh'+elem).val());
      if($('#'+'sm'+elem).val())
        xml += '<sm>' + $('#'+'sm'+elem).val() + '</sm>';
      else
        xml += '<sm></sm>';
      //console.log($('#'+'sm'+elem).val());
      xml += '</p>';
    });
    xml += '</root>';
    //console.log(xml);
    var pagina, div, datos, idUsuario;
    idUsuario = $('#idUsuario').val();
    pagina = 'sucursales/sqlControlAsistencia.asp';
    div = '';
    datos = 'idUsuario='+idUsuario+'&xml='+xml;
    try{
      //enviaDatos(pagina,div,datos);
	  
	  var  executeDetalle = $.ajax({
	  	 url: pagina,
	   	 data: datos,
	     type: "POST",
		 dataType: "html",
		 cache:false,
		 //async:true,
		 timeout:120000,
		 success: function(source){						
			//alert('success');
		 },
		 error: function(source){
			alert('error');
		 }
	  });
	  
    }catch(err){}
    $('#loadIcon').show();
    setTimeout(function() {
      pagina = 'sucursales/asistenciaSucursalCajeros.asp';
      div = 'area';
      datos = '';
      try{
        enviaDatos(pagina,div,datos);
      }catch(err){}
    }, 2000);
  }
});
$('.botonEnviaSalida').click(function(){		
  var arr_id = $('#arr_idasist').val();
  if (arr_id !== ''){
    arr_id = arr_id.substring(0, (arr_id.length)-1);	
    var v_arrid = 	arr_id.split(',');
    
    //console.log(arr_id);		
    var xml = '<root>';
    $.each(v_arrid, function (index, elem) { 		  
      //console.log(elem);
      xml += '<p>';
      xml += '<id>' + elem + '</id>';
      xml += '<tipo>salida</tipo>';			  
      
      if($('#'+'asist'+elem).val())
        xml += '<asist>' + $('#'+'asist'+elem).val() + '</asist>';
      else 
        xml += '<asist></asist>';
      //console.log($('#'+'asist'+elem).val());
      
      if($('#'+'eh'+elem).val())
        xml += '<eh>' + $('#'+'eh'+elem).val() + '</eh>';
      else 
        xml += '<eh></eh>';
      //console.log($('#'+'eh'+elem).val());
      if($('#'+'em'+elem).val())
        xml += '<em>' + $('#'+'em'+elem).val() + '</em>';
      else 
        xml += '<em></em>';
      //console.log($('#'+'em'+elem).val());
      if($('#'+'sh'+elem).val())
        xml += '<sh>' + $('#'+'sh'+elem).val() + '</sh>';
      else 
        xml += '<sh></sh>';
      //console.log($('#'+'sh'+elem).val());
      if($('#'+'sm'+elem).val())
        xml += '<sm>' + $('#'+'sm'+elem).val() + '</sm>';
      else
        xml += '<sm></sm>';
      //console.log($('#'+'sm'+elem).val());
      xml += '</p>';
    });
    xml += '</root>';
    //console.log(xml);
    
	var idUsuario = $('#idUsuario').val();
    var pagina = 'sucursales/sqlControlAsistencia.asp';
    var div = '';
    var datos = 'idUsuario='+idUsuario+'&xml='+xml;
	
    try{
      //enviaDatos(pagina,div,datos);
	  
	  var  executeDetalle = $.ajax({
	  	 url: pagina,
	   	 data: datos,
	     type: "POST",
		 dataType: "html",
		 cache:false,
		 //async:true,
		 timeout:120000,
		 success: function(source){						
			//alert('success');
		 },
		 error: function(source){
			alert('error');
		 }
	  });
	  
    }catch(err){}
    $('#loadIcon').show();
    setTimeout(function() {
      pagina = 'sucursales/asistenciaSucursalCajeros.asp';
      div = 'area';
      datos = '';
      try{
        enviaDatos(pagina,div,datos);
      }catch(err){}
    }, 2000);			
  }
});
 </script>
  <br/>
  
<%
 
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
		'r_hora_reg = server.htmlencode(trim(rs2("hora_reg")))
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