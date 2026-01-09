<!--#include file="../funciones.asp"-->
<%
perfil = trim(request("perfilMain"))
idSucursal = trim(request("idSucursalMain"))
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

'response.Write(sql & "<br/>")
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
        <td class="" width="7%"><strong>Rut Guardia</strong></td>
        <td class="" width="17%"><strong>Nombre Completo</strong></td>
        <td class="" width="12%"><strong>Empresa</strong></td>
        <td class="" width="11%"><strong>Cargo</strong></td>
        <td class="" width="10%"><strong>Asistencia</strong></td>
        <td class="" width="12%"><strong>Horario Entrada</strong></td>
        <td class="" width="12%"><strong>Horario Salida</strong></td>
        <td class="" width="6%"><strong>---</strong></td>
    </tr>
     <%
	  arr_idasist = ""
	  do while not rs.eof 
	  	id_asistencia = server.htmlencode(trim(rs("id_asistencia")))
		rut_guardia = server.htmlencode(trim(rs("guardia_rut")))
		nombre_guardia = trim(rs("guardia_nombre"))
		empresa = server.htmlencode(trim(rs("empresa")))
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
        <td class=""><%=empresa%></td>
        <td class=""><%=tipo_suc%></td>        
        <td class="" align="center">
        <% if asistencia="si" then 
			Response.Write(asistencia) 
		   else %>
            <select name="asistencia" class="input-mini" id="asist<%=id_asistencia%>">
                <option value="si" >Si</option>
                <option value="no" selected="selected">No</option>
            </select>
        <% end if %>
        </td>
        <td class="" align="center">
        <% if asistencia="si" then 
		   		Response.Write(entrada_hora & ":" & entrada_min) 
		   	  else %>
            <select name="hora_entrada" class="input-mini" id="eh<%=id_asistencia%>">
                <% For h=0 to 23 
                    if h=8 then %>
                        <option value=<%response.Write(h)%> selected="selected" ><%response.Write(h)%></option>
                    <% else %>
                        <option value=<%response.Write(h)%>><%response.Write(h)%></option>
                    <% end if
                Next %>
                </select>
                <select name="minuto_entrada" class="input-mini" id="em<%=id_asistencia%>">
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
        	<select name="hora_salida" class="input-mini" id="sh<%=id_asistencia%>">
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
            <select name="minuto_salida" class="input-mini" id="sm<%=id_asistencia%>">
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
  <script type="text/javascript">
 	$('.botonEnviaEntrada').on('click',function(){	
		var arr_id = $('#arr_idasist').val();
		if (arr_id != ''){
			arr_id = arr_id.substring(0, (arr_id.length)-1);	
			//console.log(arr_id);
			v_arrid = 	arr_id.split(',');
						
			//console.log(arr_id);		
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
			
			pagina = 'sucursales/sqlControlAsistenciaGuardias.asp';
			div = '';
		    datos = 'xml='+xml;
			enviaDatos(pagina,div,datos);
			$('#loadIcon').show();
			setTimeout(function() {				
				enviaDatos('sucursales/asistenciaSucursalGuardias.asp','area','');
			}, 2000);
		}
	});
	$('.botonEnviaSalida').on('click',function(){
		var arr_id = $('#arr_idasist').val();
		if (arr_id != ''){
			arr_id = arr_id.substring(0, (arr_id.length)-1);	
			v_arrid = 	arr_id.split(',');
						
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
			
			pagina = 'sucursales/sqlControlAsistenciaGuardias.asp';
			div = '';
		    datos = 'xml='+xml;
			enviaDatos(pagina,div,datos);
			$('#loadIcon').show();
			setTimeout(function() {
				enviaDatos('sucursales/asistenciaSucursalGuardias.asp','area','');
			}, 2000);
			
		}
	});
 </script>
<% else %>
<div class="row-fluid span12 well">
<div class="row-fluid">
	<span class="span12 alert alert-success">
		<strong><h4><span id="loadIcon" style="display:none;"><i class="icon-spinner icon-spin icon-large"></i></span> <span class="icon-stack icon-large"><i class="icon-check-empty icon-stack-base"></i><i class="icon-shield"></i></span> Asistencia Guardias</h4></strong>
	</span>
</div>
<div class="row-fluid">
	<span class="span12 alert alert-danger">
		<strong>
        	<h5>Tips:</h5>
            <h6>
            	<ol>
                	<li>No se han cargado los registros de asistencia.</li>
                    <li>Comunicate con tu Zonal para verificar la carga de asistencia Guardias.</li>
                </ol>
            </h6>
        </strong>
	</span>
</div>
</div>
<% end if %>
  <br/>
 <%

sql = ""
sql = sql & " select a.cod_bantotal, a.sucursal, a.tipo, a.empresa, a.guardia_nombre, a.guardia_rut, a.mes, isnull(cast(a.desde as DATE), '') as reemplazo_desde, isnull(cast(a.hasta as date), '') as reemplazo_hasta, a.motivo "
sql = sql & " from SUC_sucursal_guardias_r a "
sql = sql & " inner join SUC_sucursal b on a.cod_bantotal = b.cod_bantotal "
sql = sql & " where b.id_sucursal = " & idSucursal
sql = sql & " and cast(hasta as DATE) >= cast(GETDATE() as DATE) "

'response.Write(sql & "<br/>")
'response.End()

set rs2 = db.execute(sql)
  if not rs2.eof then 
 %>
  <table class="table table-bordered table-hover" align="center">
    <tr bgcolor="" align="center">
        <td class="" width="10%"><strong>Rut Reempl.</strong></td>
        <td class="" width="20%"><strong>Nombre</strong></td>        
        <td class="" width="14%"><strong>Fecha Desde</strong></td>
        <td class="" width="14%"><strong>Fecha Hasta</strong></td>
        <td class="" width="8%"><strong>Empresa</strong></td>
        <td class="" width="14%"><strong>Motivo</strong></td>
    </tr>
   	<%
		do while not rs2.eof 		
			r_cod_bantotal = server.htmlencode(trim(rs2("cod_bantotal")))
			r_sucursal = server.htmlencode(trim(rs2("sucursal")))
			r_tipo = server.htmlencode(trim(rs2("tipo")))
			r_empresa = server.htmlencode(trim(rs2("empresa")))
			r_guardia_nombre = trim(rs2("guardia_nombre"))
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