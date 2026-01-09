<!--#include file="../funciones2.asp"-->
<%
tipoPersonal = "0"
tipoPersonal = request("tipoPersonal")
idSucursal = request("idSucursal")
codBtt = request("codBtt")

sql = ""
sql = sql & "select "
sql = sql & "id_cargo, "
sql = sql & "nombre_cargo "
sql = sql & "from SUC_personal_cargos "
sql = sql & "where id_cargo not in (4,5)"

set rs2 = db.execute(sql)

%>
<div id="inputForm" class="">
<form class="form-horizontal">
<input type="hidden" name="codbtt" id="codbtt" value="<%=codBtt%>"/>
<input type="hidden" name="tipoPersonal" id="tipoPersonal" value="<%=tipoPersonal%>"/>
   <h4>
   	<i class="icon-user"></i> 
   	<%
		if tipoPersonal = "1" then
			Response.Write("Titular")
		end if
		if tipoPersonal = "2" then
			Response.Write("Reemplazo")
			sql = ""
			sql = sql & "select rut_personal "
			sql = sql & "from SUC_sucursal_personal " 
			sql = sql & "where bt_sucursal = " & codBtt			
			set rs = db.execute(sql)			
		end if
		if tipoPersonal = "3" then
			Response.Write("Modificar Titular")
		end if
		if tipoPersonal = "4" then
			Response.Write("Modificar Reemplazo")
			sql = ""
			sql = sql & "select rut_personal "
			sql = sql & "from SUC_sucursal_personal " 
			sql = sql & "where bt_sucursal = " & codBtt			
			set rs = db.execute(sql)
		end if
	%>
   </h4>
   <% if tipoPersonal = "1" then 'INGRESAR NUEVO TITULAR %>
          <div class="control-group">
            <label class="control-label" for="rutPersonal">Rut Personal</label>
            <div class="controls">
              <input type="text" id="rutPersonal" placeholder="rut personal">&nbsp;&nbsp;<strong>(11111111-1)</strong>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="nombrePersonal">Nombres</label>
            <div class="controls">
              <input type="text" id="nombrePersonal" placeholder="nombres">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="apepPaterno">Apellido Paterno</label>
            <div class="controls">
              <input type="text" id="apepPaterno" placeholder="apellido paterno">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="apepMaterno">Apellido Materno</label>
            <div class="controls">
              <input type="text" id="apepMaterno" placeholder="apellido materno">
            </div>
          </div>          
          <div class="control-group">
            <label class="control-label" for="cargo">Cargo</label>
            <div class="controls">
              <select id="cargo">
                  <option id-value="1" value="cajero">Cajero</option>    
                  <option id-value="6" value="cajeroadicional">Cajero Adicional</option>          
                  <option id-value="2" value="paramedico">Paramedico</option>         
                  <option id-value="3" value="asesordeclientes">Anfitrion</option>
                </select>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="empresa">Empresa</label>
            <div class="controls">
              <input type="text" id="empresa" placeholder="empresa">
            </div>
          </div>
          <div class="row-fluid">
              <button type="button" id="guardarPersonal" class="btn btn-primary">Guardar</button>
              <button type="button" id="cierraPersonal" class="btn btn-danger">Cerrar</button>    
          </div>
          <br/>
          <div class="row-fluid span10 alert alert-error" id="validCampos">
          		<b>RUT YA EXISTENTE EN SISTEMA</b><br/><br/>
          </div>		
      	  <script type="text/javascript">
          $(document).ready(function(){          		
          		$('#validCampos').fadeOut();

				$('#cierraPersonal').on('click', function(){
					$('#forms_add').addClass('oculto').fadeOut('slow');	
				});
				$('#guardarPersonal').click(function(){
					if(validaForm()){	
						var tipoPersonal = $('#tipoPersonal').val();			
						$(this).hide().addClass('oculto');
						$('#guardando').removeClass('oculto');
						var codbtt = $('#codbtt').val();						
						
						var rutPersonal = $.trim($('#rutPersonal').val());
						var nombrePersonal = $.trim($('#nombrePersonal').val());
						var apepPaterno = $.trim($('#apepPaterno').val());
						var apepMaterno = $.trim($('#apepMaterno').val());
						//var cargo = $('#cargo').val();
						var cargo = $('option:selected','#cargo').attr('id-value'); 
						var empresa = $.trim($('#empresa').val());
						
						var datos = '';
						datos = datos + 'tipoprc=3&';
						datos = datos + 'codBtt='+codbtt+'&';
						datos = datos + 'rutPersonal='+rutPersonal+'&';
						datos = datos + 'nombrePersonal='+nombrePersonal+'&';
						datos = datos + 'apepPaterno='+apepPaterno+'&';
						datos = datos + 'apepMaterno='+apepMaterno+'&';
						datos = datos + 'cargo='+cargo+'&';
						datos = datos + 'empresa='+empresa;
						
						var  executeCarga = $.ajax({
							url: 'personal_ingreso_data.asp',
							data: datos,
							type: "GET",
							dataType: "html",
							cache:false,
							//async:true,
							timeout:120000,
							success: function(source){                        							
								$('#guardando').addClass('oculto');
								$('#inputForm').fadeOut('slow').addClass('oculto');
								$('#resultFrame').fadeIn('slow');
								
								var div = 'lst_persuc_rem';
								var datos = '';
								var pagina = 'asistenciaSucursal.asp';
								datos = 'idSucursal=' + $("#sucursales").val();
								enviaDatos(pagina,div,datos);							
							},
							error: function(source){
								alert('Error');
							}
						});
					}
				}); 
				
				function validaForm() {					
					var flag = true;					
					var rutPersonal = $.trim($('#rutPersonal').val());
					var nombrePersonal = $.trim($('#nombrePersonal').val());
					var apepPaterno = $.trim($('#apepPaterno').val());
					var apepMaterno = $.trim($('#apepMaterno').val());					
					var cargo = $('option:selected','#cargo').attr('id-value'); 
					var empresa = $.trim($('#empresa').val());
					
					if(rutPersonal == ''){
						alert('Favor ingresar, rut personal');
						$('#rutPersonal').focus();
						flag = false;
						return flag;	
					}
					if(!Fn.validaRut(rutPersonal)){
						alert('el rut personal debe valido o tener el formato correcto');
						$('#rutPersonal').focus();
						flag = false;
						return flag;
					}
					if(!Fn.existeRut(rutPersonal)){
						$('#rutPersonal').focus();
						flag = false;
						return flag;
					}
					if(nombrePersonal == ''){
						alert('Favor ingresar, nombre personal');
						$('#nombrePersonal').focus();
						flag = false;
						return flag;	
					}
					if(apepPaterno == ''){
						alert('Favor ingresar, apellido paterno');
						$('#apepPaterno').focus();
						flag = false;
						return flag;	
					}
					if(apepMaterno == ''){
						alert('Favor ingresar, apellido materno');
						$('#apepMaterno').focus();
						flag = false;
						return flag;	
					}
					if(empresa == ''){
						alert('Favor ingresar, empresa');
						$('#empresa').focus();
						flag = false;
						return flag;	
					}						
					
					return flag;
				}
				
				var Fn = {
				   validaRut : function (rutCompleto) {
				   if (!/^[0-9]+-[0-9kK]{1}$/.test( rutCompleto )) {
						   return false;
					   }
					   var tmp     = rutCompleto.split('-');
					   var digv    = tmp[1];
					   var rut     = tmp[0];
					   if ( digv == 'K' ) {
						   digv = 'k' ;
					   }
					   var digesto = Fn.dv(rut);
					   if (digesto == digv ){
						   return true;
					   } else {
						   return false;
					   }
				   },					 
				   dv : function(T){
					  var M=0,S=1;
					  for(;T;T=Math.floor(T/10)) {
					     S=(S+T%10*(9-M++%6))%11;
					  }
					  return S?S-1:'k';
				   },
				   existeRut : function(rutCompleto){
				   		var validFlag = true;
				   		var fnxValida = "2";
				   		var rutIngreso = rutCompleto;

				   		var div = '';
				   		var datos = 'fnxValida='+fnxValida+'&rutIngreso='+rutIngreso;
				   		var pagina = 'validaCampos.asp';

				   		$.ajax({
							url: pagina,
							data: datos,
							type: "GET",
							dataType: "html",
							cache:false,
							//async:true,
							timeout:120000,
							success: function(source){
								validFlag = Fn.existeRutResult(source, validFlag);							
							},
							error: function(source){
								alert('Error');
							}
						});
						return validFlag;
				   },
				   existeRutResult : function(source){
				   		var validFlag = true;
				   		var objectJson = $.parseJSON(source);							
						var html = '';
				        var objIndex = '';
				        var result = objectJson['datos']['result'];
				        if(result=='error'){					            
				            var msg = '';
					        $.each(objectJson['datos']['msg'], function(index, value) {
					        	msg += '<ul>';
					            msg += '<li> <b>Cod BTT</b>: ' + value.bt_sucursal + '</li>';
					            msg += '<li> <b>Sucursal</b>: <b>' + value.suc_nombre + '</b></li>';
					            msg += '<li> <b>Rut Personal</b>: ' + value.rut_personal + '</li>';
					            msg += '<li> <b>Nombre</b>: ' + value.nombre_personal + '</li>';
					            msg += '<li> <b>Tipo</b>: <b>' + value.tipo_personal + '</b></li>';
					            msg += '<li> <b>Cargo</b>: <b>' + value.tipo + '</b></li>';
					            msg += '<li> <b>Empresa</b>: ' + value.empresa + '</li>';
					            msg += '</ul>';
					        });						        
					        var html = '<b>RUT YA EXISTENTE EN SISTEMA</b><br/><br/>';
					        $('#validCampos').html(html + msg);
					        $('#validCampos').fadeIn();

					        setTimeout(function(){
					        	$('#validCampos').fadeOut('slow');	
					        },3500)							        
							validFlag = false;
				        }else{						        
				            var msg = '';
				            $.each(objectJson['datos']['msg'], function(index, value) {
				            	msg += '<ol>';	
				            	msg += '<li>' + value.m + '</li>';
					            msg += '</ol>';
				           	});
				           	validFlag = true;
				        }	
				        //alert("validFlag:"+validFlag);
				        return validFlag;
				   }
				}
		  });
          </script>	
            
<% 
	end if
	if tipoPersonal = "2" then 'INGRESAR NUEVO REEMPLAZO
%>
<div class="row-fluid">
<div class="span5 ">
      	  <div class="control-group">
            <label class="control-label" for="ruttitular">Rut Titular</label>
            <div class="controls">
              <select id="ruttitular">
              	<option value="">-----</option>
                <option value="1-9">1-9</option>              	
                <%  if not rs.eof then
					 do while not rs.eof %>
					<option value="<%=rs("rut_personal")%>"><%=rs("rut_personal")%></option>
				<%  rs.MoveNext
					loop
				  	end if
					rs.Close
					set rs.ActiveConnection = nothing
					set rs=nothing 
				%>
              </select>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="nombretitular">Nombres Titular</label>
            <div class="controls">
              <input type="text" id="nombretitular" placeholder="nombre titular" disabled="disabled">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="rutreemplazo">Rut Reemplazo</label>
            <div class="controls">
              <input type="text" id="rutreemplazo" placeholder="rut reemplazo">&nbsp;&nbsp;<strong>(11111111-1)</strong>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="nombrereemplazo">Nombre Reemplazo</label>
            <div class="controls">
              <input type="text" id="nombrereemplazo" placeholder="nombre reemplazo">
            </div>
          </div>  
          <div class="control-group">
            <label class="control-label" for="cargo">Cargo</label>
            <div class="controls">
              <select id="cargo">
                  <option id-value="0" value="">---</option>                                
                  <%if not rs2.eof then
						do while not rs2.eof %>
                  		<option id-value="<%=rs2("id_cargo")%>" value="<%=rs2("nombre_cargo")%>"><%=rs2("nombre_cargo")%></option>
                  <%	rs2.MoveNext
						loop
					end if 	
					rs2.Close
					set rs2.ActiveConnection = nothing
					set rs2=nothing				
				  %>
                </select>
            </div>
          </div>                   
 </div>     
 <div class="span5 ">           		  	
          <div class="control-group">
            <label class="control-label" for="empresa">Empresa</label>
            <div class="controls">
              <input type="text" id="empresa" placeholder="empresa">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="motivo">Motivo</label>
            <div class="controls">
              <input type="text" id="motivo" placeholder="motivo">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="inputPassword">Fecha/Hora Desde</label>
            <div class="controls">
              <!--<input type="text" id="fechadesde" class="input-small" placeholder="fecha desde">-->
              <div id="tomaFechaDesde" class="input-append">
                  <input data-format="dd-MM-yyyy" class="input-small" type="text" name="fechadesde" id="fechadesde" placeholder="Fecha Desde" title="Debe seleccionar fecha.">
                  <span class="add-on">
                      <i data-time-icon="icon-time" data-date-icon="icon-calendar"></i>
                  </span>
              </div>
              <!--<input type="text" id="horadesde" class="input-small" placeholder="hora desde">-->
              <select id="horadesde" class="input-mini">
              	<% i = 8
				   do while i<=22 %>
                <% if i < 10 then %>
                	<option value="0<%=i%>">0<%=i%></option>
                <% else %>
                	<option value="<%=i%>"><%=i%></option>
                <% end if
				   i = i + 1
				   loop%>
              </select>
              <select id="mindesde" class="input-mini">
              	<% x = 0
				   do while x<60 %>
                <% if x < 10 then %>
                	<option value="0<%=x%>">0<%=x%></option>
                <% else %>
                	<option value="<%=x%>"><%=x%></option>
                <% end if
				   x = x + 1	
				   loop%>                
              </select>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="fechahasta">Fecha/Hora Hasta</label>
            <div class="controls">
              <!--<input type="text" id="fechahasta" class="input-small" placeholder="fecha hasta">-->
              <div id="tomaFechaHasta" class="input-append">
                  <input data-format="dd-MM-yyyy" class="input-small" type="text" name="fechahasta" id="fechahasta" placeholder="Fecha Hasta" title="Debe seleccionar fecha.">
                  <span class="add-on">
                      <i data-time-icon="icon-time" data-date-icon="icon-calendar"></i>
                  </span>
              </div>
              <!--<input type="text" id="horahasta" class="input-small" placeholder="hora hasta">-->
              <select id="horahasta" class="input-mini">
              	<% i = 8
				   do while i<=22 %>
                <% if i < 10 then %>
                	<option value="0<%=i%>">0<%=i%></option>
                <% else %>
                	<option value="<%=i%>"><%=i%></option>
                <% end if
				   i = i + 1
				   loop%>
              </select>
              <select id="minhasta" class="input-mini">
              	<% x = 0
				   do while x<60 %>
                <% if x < 10 then %>
                	<option value="0<%=x%>">0<%=x%></option>
                <% else %>
                	<option value="<%=x%>"><%=x%></option>
                <% end if
				   x = x + 1	
				   loop%>                
              </select>
            </div>
          </div>  
  </div>   
  </div> 
  <div class="row-fluid">    
      <button type="button" id="guardarPersonal" class="btn btn-primary">Guardar</button>
      <button type="button" id="cierraPersonal" class="btn btn-danger">Cerrar</button>    
  </div>
  <br/>
  <div class="row-fluid span10 alert alert-error" id="validCampos">
  		<b>RUT YA EXISTENTE EN SISTEMA</b><br/><br/>
  </div>		 
  <script type="text/javascript">
		$(document).ready(function(){
			$('#validCampos').fadeOut();

			$('#cierraPersonal').on('click', function(){
				$('#forms_add').addClass('oculto').fadeOut('slow');	
			});
			$('#tomaFechaHasta').datetimepicker({
				pickTime: false
			});
			$('#tomaFechaDesde').datetimepicker({
				pickTime: false
			});
			$('#ruttitular').on('change',function(){
				var valor = $(this).val();
				if(valor != '' && valor != '1-9'){
					 var datos = 'tipoprc=1&rutpersonal='+valor;
					 var  executeCarga = $.ajax({
						url: 'personal_ingreso_data.asp',
						data: datos,
						type: "GET",
						dataType: "json",
						cache:false,
						//async:true,
						timeout:120000,
						success: function(source){                        
							var data = source;
							var nombrecompleto = data['nombrePersonal'] + ' ' + data['apepPersonal'] + ' ' + data['apemPersonal']
							$('#nombretitular').val(nombrecompleto);
						},
						error: function(source){
							alert(source);
						}
					});	
				}
				else
				{
						$('#nombretitular').val('');
				}
			});
			
			$('#guardarPersonal').on('click', function(){
				if(validaForm()){	
					var tipoPersonal = $('#tipoPersonal').val();			
					$(this).hide().addClass('oculto');
					$('#guardando').removeClass('oculto');
					var codbtt = $('#codbtt').val();
															
					var rutTitular = $.trim($('#ruttitular').val());
					var rutReemplazo = $.trim($('#rutreemplazo').val());
					var nombrereemplazo = $.trim($('#nombrereemplazo').val());
					//var cargo = $('#cargo').val();
					var cargo = $('option:selected','#cargo').attr('id-value'); 
					var empresa = $.trim($('#empresa').val());
					var motivo = $.trim($('#motivo').val());
					var fechaDesde = $.trim($('#fechadesde').val());
					var horaDesde = $.trim($('#horadesde').val());
					var minDesde = $.trim($('#mindesde').val());
					var fechaHasta = $.trim($('#fechahasta').val());
					var horaHasta = $.trim($('#horahasta').val());
					var minHasta = $.trim($('#minhasta').val());
					
					var datos = '';
					datos = datos + 'tipoprc=2&';
					datos = datos + 'codBtt='+codbtt+'&';
					datos = datos + 'rutTitular='+rutTitular+'&';
					datos = datos + 'nombreReemplazo='+nombrereemplazo+'&';
					datos = datos + 'rutReemplazo='+rutReemplazo+'&';
					datos = datos + 'cargo='+cargo+'&';
					datos = datos + 'empresa='+empresa+'&';
					datos = datos + 'motivo='+motivo+'&';
					datos = datos + 'fechaDesde='+fechaDesde+'&';
					datos = datos + 'horaDesde='+horaDesde+'&';
					datos = datos + 'minDesde='+minDesde+'&';
					datos = datos + 'fechaHasta='+fechaHasta+'&';
					datos = datos + 'horaHasta='+horaHasta+'&';
					datos = datos + 'minHasta='+minHasta;	
					
					var  executeCarga = $.ajax({
						url: 'personal_ingreso_data.asp',
						data: datos,
						type: "GET",
						dataType: "html",
						cache:false,
						//async:true,
						timeout:120000,
						success: function(source){                        							
							$('#guardando').addClass('oculto');
							$('#inputForm').fadeOut('slow').addClass('oculto');
							$('#resultFrame').fadeIn('slow');
							
							var div = 'lst_persuc_rem';
							var datos = '';
							var pagina = 'asistenciaSucursal.asp';
							datos = 'idSucursal=' + $("#sucursales").val();
							enviaDatos(pagina,div,datos);							
						},
						error: function(source){
							alert('Error');
						}
					});
				}
			});	
			
			function validaForm() {
				var flag = true;				
				var rutTitular = $.trim($('#ruttitular').val());
				var rutReemplazo = $.trim($('#rutreemplazo').val());
				var nombrereemplazo = $.trim($('#nombrereemplazo').val());
				var cargo = $.trim($('#cargo').val()); 
				var empresa = $.trim($('#empresa').val());
				var motivo = $.trim($('#motivo').val());
				var fechaDesde = $.trim($('#fechadesde').val());
				var fechaHasta = $.trim($('#fechahasta').val());
				
				if(rutTitular == ''){
					alert('Favor seleccionar, rut titular');
					$('#ruttitular').focus();
					flag = false;
					return flag;
				}
				if(rutReemplazo == ''){
					alert('Favor seleccionar, rut reemplazo');
					$('#rutreemplazo').focus();
					flag = false;
					return flag;
				}
				if(!Fn.validaRut(rutReemplazo)){
					alert('Favor ingresar rut reemplazo valido o en formato correcto');
					$('#rutreemplazo').focus();
					flag = false;
					return flag;
				}
				if(!Fn.existeRut(rutReemplazo)){
					$('#rutPersonal').focus();
					flag = false;
					return flag;
				}
				if(nombrereemplazo == ''){
					alert('Favor seleccionar, nombre reemplazo');
					$('#nombrereemplazo').focus();
					flag = false;
					return flag;
				}
				if(cargo == ''){
					alert('Favor seleccionar, cargo');
					$('#cargo').focus();
					flag = false;
					return flag;
				}
				if(empresa == ''){
					alert('Favor seleccionar, empresa');
					$('#empresa').focus();
					flag = false;
					return flag;
				}
				if(motivo == ''){
					alert('Favor seleccionar, motivo');
					$('#motivo').focus();
					flag = false;
					return flag;
				}
				if(fechaDesde == ''){
					alert('Favor seleccionar, fecha desde');
					$('#fechadesde').focus();
					flag = false;
					return flag;
				}
				if(fechaHasta == ''){
					alert('Favor seleccionar, fecha hasta');
					$('#fechahasta').focus();
					flag = false;
					return flag;
				}
				
				return flag;
			}
			
			var Fn = {
			   validaRut : function (rutCompleto) {
			   if (!/^[0-9]+-[0-9kK]{1}$/.test( rutCompleto )) {
					   return false;
				   }
				   var tmp     = rutCompleto.split('-');
				   var digv    = tmp[1];
				   var rut     = tmp[0];
				   if ( digv == 'K' ) {
					   digv = 'k' ;
				   }
				   var digesto = Fn.dv(rut);
				   if (digesto == digv ){
					   return true;
				   } else {
					   return false;
				   }
			   },				 
			   dv : function(T){
				   var M=0,S=1;
					for(;T;T=Math.floor(T/10)) {
					   S=(S+T%10*(9-M++%6))%11;
					}
					return S?S-1:'k';
				},
				   existeRut : function(rutCompleto){
				   		var validFlag = true;
				   		var fnxValida = "2";
				   		var rutIngreso = rutCompleto;

				   		var div = '';
				   		var datos = 'fnxValida='+fnxValida+'&rutIngreso='+rutIngreso;
				   		var pagina = 'validaCampos.asp';

				   		$.ajax({
							url: pagina,
							data: datos,
							type: "GET",
							dataType: "html",
							cache:true,
							//async:false,
							timeout:120000,
							success: function(source){
								validFlag = Fn.existeRutResult(source, validFlag);							
							},
							error: function(source){
								alert('Error');
							}
						});
						return validFlag;
				   },
				   existeRutResult : function(source){
				   		var validFlag = true;
				   		var objectJson = $.parseJSON(source);							
						var html = '';
				        var objIndex = '';
				        var result = objectJson['datos']['result'];
				        if(result=='error'){					            
				            var msg = '';
					        $.each(objectJson['datos']['msg'], function(index, value) {
					        	msg += '<ul>';
					            msg += '<li> <b>Cod BTT</b>: ' + value.bt_sucursal + '</li>';
					            msg += '<li> <b>Sucursal</b>: <b>' + value.suc_nombre + '</b></li>';
					            msg += '<li> <b>Rut Personal</b>: ' + value.rut_personal + '</li>';
					            msg += '<li> <b>Nombre</b>: ' + value.nombre_personal + '</li>';
					            msg += '<li> <b>Tipo</b>: <b>' + value.tipo_personal + '</b></li>';
					            msg += '<li> <b>Cargo</b>: <b>' + value.tipo + '</b></li>';
					            msg += '<li> <b>Empresa</b>: ' + value.empresa + '</li>';
					            msg += '</ul>';
					        });						        
					        var html = '<b>RUT YA EXISTENTE EN SISTEMA</b><br/><br/>';
					        $('#validCampos').html(html + msg);
					        $('#validCampos').fadeIn();

					        setTimeout(function(){
					        	$('#validCampos').fadeOut('slow');	
					        },3500)							        
							validFlag = false;
				        }else{						        
				            var msg = '';
				            $.each(objectJson['datos']['msg'], function(index, value) {
				            	msg += '<ol>';	
				            	msg += '<li>' + value.m + '</li>';
					            msg += '</ol>';
				           	});
				           	validFlag = true;
				        }	
				        //alert("validFlag:"+validFlag);
				        return validFlag;
				   }
			}
		});
	  </script>	    
                  
<% end if %>    
<% if tipoPersonal = "3" then 'MODIFICAR TITULAR 

idAistPersonal = request("idPersonal")

sql = ""
sql = sql & "select "
sql = sql & "id_personal, "
sql = sql & "rut_personal, "
sql = sql & "nombre_personal, "
sql = sql & "apep_personal, "
sql = sql & "apem_personal, "
sql = sql & "id_cargo, "
sql = sql & "nombre_cargo, "
sql = sql & "fecha_ingreso, "
sql = sql & "tipo, "
sql = sql & "bt_sucursal, "
sql = sql & "empresa "
sql = sql & "from SUC_sucursal_personal "
sql = sql & "where rut_personal = "
sql = sql & "(select top 1 rut_personal "
sql = sql & "from SUC_sucursal_asistencia_personal "
sql = sql & "where id_asist_personal = "&idAistPersonal&") "

'Response.Write(sql)
set rs = db.execute(sql)

if not rs.eof then
	id_personal = trim(rs("id_personal"))
	rut_personal = trim(rs("rut_personal"))
	nombre_personal = trim(rs("nombre_personal"))
	apep_personal = trim(rs("apep_personal"))
	apem_personal = trim(rs("apem_personal"))
	id_cargo = trim(rs("id_cargo"))
	nombre_cargo = trim(rs("nombre_cargo"))
	fecha_ingreso = trim(rs("fecha_ingreso"))
	tipo = trim(rs("tipo"))
	bt_sucursal = trim(rs("bt_sucursal"))
	empresa = trim(rs("empresa"))	
end if

%>
	  <input type="hidden" name="idAsistPersonal" id="idAsistPersonal" value="<%=idAistPersonal%>"/>
      <div class="control-group">
        <label class="control-label" for="rutPersonal">Rut Personal</label>
        <div class="controls">
          <input type="text" id="rutPersonal" placeholder="rut personal" value="<%=rut_personal%>">&nbsp;&nbsp;<strong>(11111111-1)</strong>
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="nombrePersonal">Nombres</label>
        <div class="controls">
          <input type="text" id="nombrePersonal" placeholder="nombres" value="<%=nombre_personal%>">
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="apepPaterno">Apellido Paterno</label>
        <div class="controls">
          <input type="text" id="apepPaterno" placeholder="apellido paterno" value="<%=apep_personal%>">
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="apepMaterno">Apellido Materno</label>
        <div class="controls">
          <input type="text" id="apepMaterno" placeholder="apellido materno" value="<%=apem_personal%>">
        </div>
      </div>          
      <div class="control-group">
        <label class="control-label" for="cargo">Cargo</label>
        <div class="controls">
          <select id="cargo">
              <option id-value="1" value="cajero" <% if id_cargo = "1" then response.Write("selected") end if %>>Cajero</option>    
              <option id-value="6" value="cajeroadicional" <% if id_cargo = "6" then response.Write("selected") end if %>>Cajero Adicional</option>          
              <option id-value="2" value="paramedico" <% if id_cargo = "2" then response.Write("selected") end if %>>Paramedico</option>         
              <option id-value="3" value="asesordeclientes" <% if id_cargo = "3" then response.Write("selected") end if %>>Anfitrion</option>
            </select>
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="empresa">Empresa</label>
        <div class="controls">
          <input type="text" id="empresa" placeholder="empresa" value="<%=empresa%>">
        </div>
      </div> 
      <div class="row-fluid">    
        <button type="button" id="guardarPersonal2" class="btn btn-primary">Guardar</button>
        <button type="button" id="cierraPersonal2" class="btn btn-danger">Cerrar</button>    
    </div> 
  <script type="text/javascript">
  $(document).ready(function(){
        $('#cierraPersonal2').on('click', function(){
            //alert('Cerrar modPersonal');
            $('#frameModPersonal').addClass('oculto').fadeOut('slow');	
        });				    				
        $('#guardarPersonal2').on('click', function(){   
			if(validaForm()){
				$(this).hide().addClass('oculto');
				$('#guardando').removeClass('oculto');
				//var codbtt = $('#codbtt').val();	
				var codbtt = $('option:selected','#sucursales').attr('data-codbt');					
				
				var idAsistPersonal = $.trim($('#idAsistPersonal').val());
				var rutPersonal = $.trim($('#rutPersonal').val());
				var nombrePersonal = $.trim($('#nombrePersonal').val());
				var apepPaterno = $.trim($('#apepPaterno').val());
				var apepMaterno = $.trim($('#apepMaterno').val());
				//var cargo = $('#cargo').val();
				var cargo = $('option:selected','#cargo').attr('id-value'); 
				var empresa = $.trim($('#empresa').val());
				
				var datos = '';
				datos = datos + 'tipoprc=5&';
				datos = datos + 'idAsistPersonal='+idAsistPersonal+'&';
				datos = datos + 'codBtt='+codbtt+'&';
				datos = datos + 'rutPersonal='+rutPersonal+'&';
				datos = datos + 'nombrePersonal='+nombrePersonal+'&';
				datos = datos + 'apepPaterno='+apepPaterno+'&';
				datos = datos + 'apepMaterno='+apepMaterno+'&';
				datos = datos + 'cargo='+cargo+'&';
				datos = datos + 'empresa='+empresa;
				
				var  executeCarga = $.ajax({
					url: 'personal_ingreso_data.asp',
					data: datos,
					type: "GET",
					dataType: "html",
					cache:false,
					//async:true,
					timeout:120000,
					success: function(source){                        							
						$('#guardando').addClass('oculto');
						$('#inputForm').fadeOut('slow').addClass('oculto');
						$('#resultFrame').fadeIn('slow');
						
						var div = 'lst_persuc_rem';
						var datos = '';
						var pagina = 'asistenciaSucursal.asp';
						datos = 'idSucursal=' + $("#sucursales").val();
						enviaDatos(pagina,div,datos);							
					},
					error: function(source){
						alert('Error');
					}
				});
			}
        }); 
		
		function validaForm() {					
			var flag = true;					
			var rutPersonal = $.trim($('#rutPersonal').val());
			var nombrePersonal = $.trim($('#nombrePersonal').val());
			var apepPaterno = $.trim($('#apepPaterno').val());
			var apepMaterno = $.trim($('#apepMaterno').val());					
			var cargo = $('option:selected','#cargo').attr('id-value'); 
			var empresa = $.trim($('#empresa').val());
			
			if(rutPersonal == ''){
				alert('Favor ingresar, rut personal');
				$('#rutPersonal').focus();
				flag = false;
				return flag;	
			}
			if(!Fn.validaRut(rutPersonal)){
				alert('el rut personal debe valido o tener el formato correcto');
				$('#rutPersonal').focus();
				flag = false;
				return flag;	
			}
			if(nombrePersonal == ''){
				alert('Favor ingresar, nombre personal');
				$('#nombrePersonal').focus();
				flag = false;
				return flag;	
			}
			if(apepPaterno == ''){
				alert('Favor ingresar, apellido paterno');
				$('#apepPaterno').focus();
				flag = false;
				return flag;	
			}
			if(apepMaterno == ''){
				alert('Favor ingresar, apellido materno');
				$('#apepMaterno').focus();
				flag = false;
				return flag;	
			}
			if(empresa == ''){
				alert('Favor ingresar, empresa');
				$('#empresa').focus();
				flag = false;
				return flag;	
			}						
			
			return flag;
		}
		
		var Fn = {
		   validaRut : function (rutCompleto) {
		   if (!/^[0-9]+-[0-9kK]{1}$/.test( rutCompleto )) {
				   return false;
			   }
			   var tmp     = rutCompleto.split('-');
			   var digv    = tmp[1];
			   var rut     = tmp[0];
			   if ( digv == 'K' ) {
				   digv = 'k' ;
			   }
			   var digesto = Fn.dv(rut);
			   if (digesto == digv ){
				   return true;
			   } else {
				   return false;
			   }
		   },
			 
			dv : function(T){
			   var M=0,S=1;
				for(;T;T=Math.floor(T/10)) {
				   S=(S+T%10*(9-M++%6))%11;
				}
				return S?S-1:'k';
				}
		} 
  });
</script>	
            
<% 
end if
if tipoPersonal = "4" then 'MODIFICAR REEMPLAZO

idAistPersonal = request("idPersonal")

sql = ""
sql = sql & "select "
sql = sql & "bt_sucursal, "
sql = sql & "id_cargo, "
sql = sql & "nombre_sucursal, "
sql = sql & "nombre_cargo, "
sql = sql & "rut_titular, "
sql = sql & "isnull(nombre_titular, '') as nombre_titular, "
sql = sql & "rut_reemp, "
sql = sql & "nombre_reemp, "
sql = sql & "desde, "
sql = sql & "hasta, "
sql = sql & "convert(varchar(5),hora_ingreso) as hora_ingreso, "
sql = sql & "convert(varchar(5),hora_salida) as hora_salida, "
sql = sql & "empresa, "
sql = sql & "motivo "
sql = sql & "from SUC_sucursal_reemplazos "
sql = sql & "where rut_reemp = "
sql = sql & "(select top 1 rut_personal "
sql = sql & "from SUC_sucursal_asistencia_personal "
sql = sql & "where id_asist_personal = "&idAistPersonal&") "

'Response.Write(sql)
'Response.End
set rs = db.execute(sql)

if not rs.eof then
	bt_sucursal = trim(rs("bt_sucursal"))
	id_cargo = trim(rs("id_cargo"))
	nombre_sucursal = trim(rs("nombre_sucursal"))
	nombre_cargo = trim(rs("nombre_cargo"))
	rut_titular = trim(rs("rut_titular"))
	nombre_titular = trim(rs("nombre_titular"))
	rut_reemp = trim(rs("rut_reemp"))
	nombre_reemp = trim(rs("nombre_reemp"))
	desde = trim(rs("desde"))
	hasta = trim(rs("hasta"))
	hora_ingreso = trim(rs("hora_ingreso"))
	hora_salida = trim(rs("hora_salida"))
	empresa = trim(rs("empresa"))
	motivo = trim(rs("motivo"))
	
	min_ingreso = Mid(hora_ingreso, 4, 2)
	hora_ingreso = Mid(hora_ingreso, 1, 2)	
	
	min_salida = Mid(hora_salida, 4, 2)
	hora_salida = Mid(hora_salida, 1, 2)
end if

'CARGA TITULARES
sql2 = ""
sql2 = sql2 & " SELECT BT_SUCURSAL, ID_CARGO, "
sql2 = sql2 & " NOMBRE_CARGO, RUT_PERSONAL, "
sql2 = sql2 & " NOMBRE_PERSONAL "
sql2 = sql2 & " FROM SUC_SUCURSAL_PERSONAL "
sql2 = sql2 & " WHERE BT_SUCURSAL = "&codbtt&" "


'Response.Write(sql2)
'Response.End

set rs5 = db.execute(sql2)

%>
<div class="row-fluid">
	<input type="hidden" name="idAsistPersonal" id="idAsistPersonal" value="<%=idAistPersonal%>"/>
<div class="span5 ">
      	  <div class="control-group">
            <label class="control-label" for="ruttitular">Rut Titular</label>
            <div class="controls">
            <% if trim(rs("rut_titular")) = "1-9" then %>
              <!--<input id="ruttitular" disabled="disabled" value="hola"/>-->
              <select id="ruttitular">
              	<option value="">1-9</option>               	               
                <%  if not rs5.eof then
					 do while not rs5.eof %>
					<option value="<%=trim(rs5("RUT_PERSONAL"))%>"><%=trim(rs5("RUT_PERSONAL"))%></option>
				<%  rs5.MoveNext
					loop
				  	end if
					rs5.Close
					set rs5.ActiveConnection = nothing
					set rs5=nothing 
				%>
              </select>
            <% else %>
              <input id="ruttitular" disabled="disabled" value="<%=rut_titular%>"/>
            <% end if %>          	
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="nombretitular">Nombres Titular</label>
            <div class="controls">
              <input type="text" id="nombretitular" placeholder="nombre titular" disabled="disabled" value="<%=nombre_titular%>">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="rutreemplazo">Rut Reemplazo</label>
            <div class="controls">
              <input type="text" id="rutreemplazo" placeholder="rut reemplazo" value="<%=rut_reemp%>">&nbsp;&nbsp;<strong>(11111111-1)</strong>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="nombrereemplazo">Nombre Reemplazo</label>
            <div class="controls">
              <input type="text" id="nombrereemplazo" placeholder="nombre reemplazo" value="<%=nombre_reemp%>">
            </div>
          </div>  
          <div class="control-group">          
            <label class="control-label" for="cargo">Cargo</label>
            <div class="controls">
              <select id="cargo" disabled="disabled">
                  <option id-value="0" value="">---</option>                                
                  <%if not rs2.eof then
						do while not rs2.eof 
                        	if cint(id_cargo) = cint(rs2("id_cargo")) then %>
                  				<option selected="selected" id-value="<%=rs2("id_cargo")%>" value="<%=rs2("nombre_cargo")%>"><%=rs2("nombre_cargo")%></option>
                         <% else %>
                         		<option id-value="<%=rs2("id_cargo")%>" value="<%=rs2("nombre_cargo")%>"><%=rs2("nombre_cargo")%></option>
                         <% end if %>
                  <%	rs2.MoveNext
						loop
					end if 	
					rs2.Close
					set rs2.ActiveConnection = nothing
					set rs2=nothing				
				  %>
                </select>            
            </div>
          </div>                   
 </div>     
 <div class="span5 ">           		  	
          <div class="control-group">
            <label class="control-label" for="empresa">Empresa</label>
            <div class="controls">
              <input type="text" id="empresa" placeholder="empresa" value="<%=empresa%>">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="motivo">Motivo</label>
            <div class="controls">
              <input type="text" id="motivo" placeholder="motivo" value="<%=motivo%>">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="inputPassword">Fecha/Hora Desde</label>
            <div class="controls">
              <!--<input type="text" id="fechadesde" class="input-small" placeholder="fecha desde">-->
              <div id="tomaFechaDesde" class="input-append">
                  <input data-format="dd-MM-yyyy" class="input-small" type="text" name="fechadesde" id="fechadesde" placeholder="Fecha Desde" title="Debe seleccionar fecha." value="<%=desde%>">
                  <span class="add-on">
                      <i data-time-icon="icon-time" data-date-icon="icon-calendar"></i>
                  </span>
              </div>
              <!--<input type="text" id="horadesde" class="input-small" placeholder="hora desde">-->
              <select id="horadesde" class="input-mini">
              	<% i = 8
				   do while i<=22 %>
                <% if i < 10 then 
					if cint(hora_ingreso) = cint(i) then %>
                		<option selected="selected" value="0<%=i%>">0<%=i%></option>
                 <% else %>
                 		<option value="0<%=i%>">0<%=i%></option>
                    
                <% end if 
					else 
					if cint(hora_ingreso) = cint(i) then %>
                		<option selected="selected" value="<%=i%>"><%=i%></option>
				 <% else %>                       
                 		<option value="<%=i%>"><%=i%></option> 
                <% end if
				   end if
				   i = i + 1
				   loop%>
              </select>
              <select id="mindesde" class="input-mini">
              	<% x = 0
				   do while x<60 %>
                <% if x < 10 then 
					if cint(min_ingreso) = cint(x) then %>
                		<option selected="selected" value="0<%=x%>">0<%=x%></option>
                    <% else %>
                    	<option value="0<%=x%>">0<%=x%></option>
                <%  end if 
					else 
					if cint(min_ingreso) = cint(x) then %>
                		<option selected="selected" value="<%=x%>"><%=x%></option>
                    <% else %>
                    	<option value="<%=x%>"><%=x%></option>
                <%  end if				
					end if
				   x = x + 1	
				   loop%>                
              </select>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="fechahasta">Fecha/Hora Hasta</label>
            <div class="controls">
              <!--<input type="text" id="fechahasta" class="input-small" placeholder="fecha hasta">-->
              <div id="tomaFechaHasta" class="input-append">
                  <input data-format="dd-MM-yyyy" class="input-small" type="text" name="fechahasta" id="fechahasta" placeholder="Fecha Hasta" title="Debe seleccionar fecha." value="<%=hasta%>">
                  <span class="add-on">
                      <i data-time-icon="icon-time" data-date-icon="icon-calendar"></i>
                  </span>
              </div>
              <!--<input type="text" id="horahasta" class="input-small" placeholder="hora hasta">-->
              <select id="horahasta" class="input-mini">
              	<% i = 8
				   do while i<=22 %>
                <% if i < 10 then 
					if cint(hora_salida) = cint(i) then %>
                	   <option selected="selected" value="0<%=i%>">0<%=i%></option>
                 <% else %>
                       <option value="0<%=i%>">0<%=i%></option>                        
				<%  end if
				  else 
				    if cint(hora_salida) = cint(i) then %>
                	   <option selected="selected" value="<%=i%>"><%=i%></option>
                 <% else %>
                 	   <option value="<%=i%>"><%=i%></option>	
                <%  end if 
					end if
				   i = i + 1
				   loop%>
              </select>
              <select id="minhasta" class="input-mini">
              	<% x = 0
				   do while x<60 %>
                <% if x < 10 then 
					if cint(min_salida) = cint(x) then %>                	
                	   <option selected="selected" value="0<%=x%>">0<%=x%></option>
                 <% else %>
                 	   <option value="0<%=x%>">0<%=x%></option>
                <%  end if 
					else 
					if cint(min_salida) = cint(x) then %>
                	   <option selected="selected" value="<%=x%>"><%=x%></option>
                 <% else %>
                 	   <option value="<%=x%>"><%=x%></option>
                <%  end if
					end if
				   x = x + 1	
				   loop%>                
              </select>
            </div>
          </div>  
  </div>   
  </div> 
  <div class="row-fluid">    
      <button type="button" id="guardarPersonal2" class="btn btn-primary">Guardar</button>
      <button type="button" id="cierraPersonal2" class="btn btn-danger">Cerrar</button>    
  </div>
      <script type="text/javascript">
		$(document).ready(function(){
			$('#cierraPersonal2').on('click', function(){
					//alert('Cerrar modPersonal');
					$('#frameModPersonal').addClass('oculto').fadeOut('slow');	
			});
			$('#tomaFechaHasta').datetimepicker({
				pickTime: false
			});
			$('#tomaFechaDesde').datetimepicker({
				pickTime: false
			});

			$('#ruttitular').on('change',function(){
				var valor = $(this).val();
				if(valor != '' && valor != '1-9'){
					 var datos = 'tipoprc=1&rutpersonal='+valor;
					 var  executeCarga = $.ajax({
						url: 'personal_ingreso_data.asp',
						data: datos,
						type: "GET",
						dataType: "json",
						cache:false,
						//async:true,
						timeout:120000,
						success: function(source){                        
							var data = source;
							var nombrecompleto = data['nombrePersonal'] + ' ' + data['apepPersonal'] + ' ' + data['apemPersonal']
							$('#nombretitular').val(nombrecompleto);
							$('#cargo').val('Cajero');							
							
							//$('#cargo').attr("disabled", "disabled");
						},
						error: function(source){
							alert(source);
						}
					});	
				}
				else
				{
					$('#nombretitular').val('');
					$('#cargo').val('Cajero Adicional');
				}
			});

			
			$('#guardarPersonal2').on('click', function(){	
				if(validaForm()){
					$(this).hide().addClass('oculto');
					$('#guardando').removeClass('oculto');
					var codbtt = $('option:selected','#sucursales').attr('data-codbt');
					
					var idAsistPersonal = $('#idAsistPersonal').val();										
					var rutTitular = $.trim($('#ruttitular').val());
					var nombreTitular = $.trim($('#nombretitular').val());
					var rutReemplazo = $.trim($('#rutreemplazo').val());
					var nombrereemplazo = $.trim($('#nombrereemplazo').val());
					//var cargo = $('#cargo').val();
					var cargo = $('option:selected','#cargo').attr('id-value'); 
					var empresa = $.trim($('#empresa').val());
					var motivo = $.trim($('#motivo').val());
					var fechaDesde = $.trim($('#fechadesde').val());
					var horaDesde = $.trim($('#horadesde').val());
					var minDesde = $.trim($('#mindesde').val());
					var fechaHasta = $.trim($('#fechahasta').val());
					var horaHasta = $.trim($('#horahasta').val());
					var minHasta = $.trim($('#minhasta').val());
					
					var datos = '';
					datos = datos + 'tipoprc=6&';
					datos = datos + 'idAsistPersonal='+idAsistPersonal+'&';
					datos = datos + 'codBtt='+codbtt+'&';
					datos = datos + 'rutTitular='+rutTitular+'&';
					datos = datos + 'nombreTitular='+nombreTitular+'&';
					datos = datos + 'nombreReemplazo='+nombrereemplazo+'&';
					datos = datos + 'rutReemplazo='+rutReemplazo+'&';
					datos = datos + 'cargo='+cargo+'&';
					datos = datos + 'empresa='+empresa+'&';
					datos = datos + 'motivo='+motivo+'&';
					datos = datos + 'fechaDesde='+fechaDesde+'&';
					datos = datos + 'horaDesde='+horaDesde+'&';
					datos = datos + 'minDesde='+minDesde+'&';
					datos = datos + 'fechaHasta='+fechaHasta+'&';
					datos = datos + 'horaHasta='+horaHasta+'&';
					datos = datos + 'minHasta='+minHasta;	
					
					var  executeCarga = $.ajax({
						url: 'personal_ingreso_data.asp',
						data: datos,
						type: "GET",
						dataType: "html",
						cache:false,
						//async:true,
						timeout:120000,
						success: function(source){                        							
							$('#guardando').addClass('oculto');
							$('#inputForm').fadeOut('slow').addClass('oculto');
							$('#resultFrame').fadeIn('slow');
							
							var div = 'lst_persuc_rem';
							var datos = '';
							var pagina = 'asistenciaSucursal.asp';
							datos = 'idSucursal=' + $("#sucursales").val();
							enviaDatos(pagina,div,datos);							
						},
						error: function(source){
							alert('Error');
						}
					});
				}
			});	
			
			function validaForm() {
				var flag = true;				
				var rutTitular = $.trim($('#ruttitular').val());
				var rutReemplazo = $.trim($('#rutreemplazo').val());
				var nombrereemplazo = $.trim($('#nombrereemplazo').val());
				var cargo = $.trim($('#cargo').val()); 
				var empresa = $.trim($('#empresa').val());
				var motivo = $.trim($('#motivo').val());
				var fechaDesde = $.trim($('#fechadesde').val());
				var fechaHasta = $.trim($('#fechahasta').val());
				
				if(rutTitular == ''){
					alert('Favor seleccionar, rut titular');
					$('#ruttitular').focus();
					flag = false;
					return flag;
				}
				if(rutReemplazo == ''){
					alert('Favor seleccionar, rut reemplazo');
					$('#rutreemplazo').focus();
					flag = false;
					return flag;
				}
				if(!Fn.validaRut(rutReemplazo)){
					alert('Favor ingresar rut reemplazo valido o en formato correcto');
					$('#rutreemplazo').focus();
					flag = false;
					return flag;
				}
				if(nombrereemplazo == ''){
					alert('Favor seleccionar, nombre reemplazo');
					$('#nombrereemplazo').focus();
					flag = false;
					return flag;
				}
				if(cargo == ''){
					alert('Favor seleccionar, cargo');
					$('#cargo').focus();
					flag = false;
					return flag;
				}
				if(empresa == ''){
					alert('Favor seleccionar, empresa');
					$('#empresa').focus();
					flag = false;
					return flag;
				}
				if(motivo == ''){
					alert('Favor seleccionar, motivo');
					$('#motivo').focus();
					flag = false;
					return flag;
				}
				if(fechaDesde == ''){
					alert('Favor seleccionar, fecha desde');
					$('#fechadesde').focus();
					flag = false;
					return flag;
				}
				if(fechaHasta == ''){
					alert('Favor seleccionar, fecha hasta');
					$('#fechahasta').focus();
					flag = false;
					return flag;
				}
				
				return flag;
			}
			
			var Fn = {
			   validaRut : function (rutCompleto) {
			   if (!/^[0-9]+-[0-9kK]{1}$/.test( rutCompleto )) {
					   return false;
				   }
				   var tmp     = rutCompleto.split('-');
				   var digv    = tmp[1];
				   var rut     = tmp[0];
				   if ( digv == 'K' ) {
					   digv = 'k' ;
				   }
				   var digesto = Fn.dv(rut);
				   if (digesto == digv ){
					   return true;
				   } else {
					   return false;
				   }
			   },
				 
				dv : function(T){
				   var M=0,S=1;
					for(;T;T=Math.floor(T/10)) {
					   S=(S+T%10*(9-M++%6))%11;
					}
					return S?S-1:'k';
					}
			}
		});
	  </script>	    
                  
<% end if %>
      <div id="guardando" class="oculto"><strong>Guardando</strong> <img src="../img/loader.gif"/></div>
</form>
</div>
<div id="resultFrame" class="row-fluid oculto">
	<div class="span2"></div>
    <div class="span7 well alert alert-success"><strong>Ingreso Correcto.</strong></div>
    <div class="span2"></div>
</div>

<script type="text/javascript">
$(document).ready(function(){	
});
</script>
