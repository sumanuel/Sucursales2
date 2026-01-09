<!--#include file="../funciones2.asp"-->
<%
tipoPersonal = "0"
tipoPersonal = request("tipoPersonal")
idSucursal = request("idSucursal")
codBtt = request("codBtt")

%>
<div id="inputForm" class="">
<form class="form-horizontal" id="datosGuardia">
<input type="hidden" name="codbtt" id="codbtt" value="<%=codBtt%>"/>
<input type="hidden" name="tipoPersonal" id="tipoPersonal" value="<%=tipoPersonal%>"/>
   <h4>
   	<i class="icon-user"></i> 
   	<%
		if tipoPersonal = "1" then
			Response.Write("Guardia Titular")
		end if
		if tipoPersonal = "2" then
			Response.Write("Guardia Reemplazo")
			sql = ""
			sql = sql & "select guardia_rut,guardia_nombre, empresa "
			sql = sql & "from SUC_sucursal_guardias_t " 
			sql = sql & "where cod_bantotal = " & codBtt	
			set rs = db.execute(sql)
			if not rs.eof then
				datos = rs.GetRows()
			end if
		end if
		if tipoPersonal = "3" then
			Response.Write("Modificar Titular")
		end if
		if tipoPersonal = "4" then
			Response.Write("Modificar Reemplazo")
			sql = ""
			sql = sql & "select guardia_rut "
			sql = sql & "from SUC_sucursal_guardias_t " 
			sql = sql & "where cod_bantotal = " & codBtt			
			
			'response.Write(sql)
			'response.End()
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
          <!--<div class="control-group">
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
          </div>-->
          <div class="control-group">
            <label class="control-label" for="empresa">Empresa</label>
            <div class="controls">
               	<select id="empresa">
               		<option value="">[Seleccione empresa]</option>  
                  	<option value="G4S Austral">G4S Austral</option>    
                  	<option value="G4S Limitada">G4S Limitada</option>          
                  	<option value="G4S Regiones">G4S Regiones</option>         
                  	<option value="Prosegur">Prosegur</option>
                  	<option value="Prosegur Regiones">Prosegur Regiones</option>
                  	<option value="Sispa">Sispa</option>
                  	<option value="P.P.I Chile">P.P.I Chile</option>
                </select>
            </div>
          </div>
          <div class="row-fluid">    
              <button type="button" id="guardarPersonal" class="btn btn-primary">Guardar</button>
              <button type="button" id="cierraPersonal" class="btn btn-danger">Cerrar</button>    
          </div>      
      	  <script type="text/javascript">
          $(document).ready(function(){
				$('#cierraPersonal').on('click', function(){
					$('#forms_add').addClass('oculto').fadeOut('slow');	
				});
				$('#guardarPersonal').on('click', function(){
					if(validaForm()){	
						var tipoPersonal = $('#tipoPersonal').val();			
						$(this).hide().addClass('oculto');
						$('#guardando').removeClass('oculto');
						var codbtt = $('#codbtt').val();						
						
						var rutPersonal = $.trim($('#rutPersonal').val());
						var nombrePersonal = $.trim($('#nombrePersonal').val());
						//var apepPaterno = $.trim($('#apepPaterno').val());
						//var apepMaterno = $.trim($('#apepMaterno').val());
						var empresa = $.trim($('#empresa').val());
						
						var datos = '';
						datos = datos + 'tipoPersonal='+tipoPersonal+'&';
						datos = datos + 'codBtt='+codbtt+'&';
						datos = datos + 'rutPersonal='+rutPersonal+'&';
						datos = datos + 'nombrePersonal='+nombrePersonal+'&';
						//datos = datos + 'apepPaterno='+apepPaterno+'&';
						//datos = datos + 'apepMaterno='+apepMaterno+'&';
						datos = datos + 'empresa='+empresa;
						
						var  executeCarga = $.ajax({
							url: 'sqlGuardias.asp',
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
								var pagina = 'asistenciaSucursalGuardias.asp';
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
					//var apepPaterno = $.trim($('#apepPaterno').val());
					//var apepMaterno = $.trim($('#apepMaterno').val());					
					var empresa = $('option:selected','#empresa').val();
					
					if(rutPersonal === ''){
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
					if(nombrePersonal === ''){
						alert('Favor ingresar, nombre personal');
						$('#nombrePersonal').focus();
						flag = false;
						return flag;	
					}
					/*if(apepPaterno === ''){
						alert('Favor ingresar, apellido paterno');
						$('#apepPaterno').focus();
						flag = false;
						return flag;	
					}
					if(apepMaterno === ''){
						alert('Favor ingresar, apellido materno');
						$('#apepMaterno').focus();
						flag = false;
						return flag;	
					}*/
					if(empresa === ''){
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
	if tipoPersonal = "2" then 'INGRESAR NUEVO REEMPLAZO
%>
<div class="row-fluid">
		<div class="span5 ">
      	  <div class="control-group">
            <label class="control-label" for="rutTitular">Guardia Titular</label>
            <div class="controls">
              <select id="rutTitular">
              	<option value="" data-empresaGuardia="">[Seleccione titular]</option>
                <%For i = 0 to ubound(datos, 2)
					rutGuardiaTitular = trim(datos(0,i))
					nombreGuardiaTitular = server.htmlencode(trim(datos(1,i)))
					empresaGuardia = server.htmlencode(trim(datos(2,i)))%>
					<option value="<%=rutGuardiaTitular%>" data-empresaGuardia="<%=empresaGuardia%>">
						<%=rutGuardiaTitular%> -- <%=nombreGuardiaTitular%>
					</option>
				<%next%>
              </select>
            </div>
          </div>
          <script type="text/javascript">
          $('#rutTitular').change(function(){
          	valorGuardia = $('option:selected',this).attr('data-empresaGuardia');
          	if (valorGuardia !== '')
          	{
          		$('.nombreEmpresaTitular').text(valorGuardia);
          		$('#empresa').val(valorGuardia);
          	}
          	else{
          		$('.nombreEmpresaTitular').text('Debe selecionar titular');
          		$('#empresa').val('');
          	}
          });
          </script>
          <!--<div class="control-group">
            <label class="control-label" for="nombretitular">Nombres Titular</label>
            <div class="controls">
              <input type="text" id="nombretitular" placeholder="nombre titular" disabled="disabled">
            </div>
          </div>-->
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
 </div>     
 <div class="span5 ">           		  	
          <div class="control-group">
            <label class="control-label" for="empresa">Empresa</label>
            <div class="controls">
              <input type="hidden" id="empresa" placeholder="empresa">
              <strong>
              	<span class="nombreEmpresaTitular">
              		Debe seleccionar titular
              	</span>
	          </strong>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="motivo">Motivo</label>
            <div class="controls">
            	<select id="motivo">
            		<option value="">[Seleccione Motivo]</option>
            		<option value="Licencia Medica">Licencia Medica</option>
            		<option value="Permiso">Permiso</option>
            		<option value="Vacaciones">Vacaciones</option>
            		<option value="Otro">Otro</option>
            	</select>
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
            </div>
          </div>  
  </div>   
  </div> 
  <div class="row-fluid">    
      <button type="button" id="guardarPersonal" class="btn btn-primary">Guardar</button>
      <button type="button" id="cierraPersonal" class="btn btn-danger">Cerrar</button>    
  </div>
      <script type="text/javascript">
		$(document).ready(function(){
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
						url: 'guardia_ingreso_data.asp',
						data: datos,
						type: "GET",
						dataType: "json",
						cache:false,
						//async:true,
						timeout:120000,
						success: function(source){                        
							var data = source;
							var nombrecompleto = data['guardia_nombre'];
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
															
					var rutTitular = $.trim($('#rutTitular').val());
					var rutReemplazo = $.trim($('#rutreemplazo').val());
					var nombrereemplazo = $.trim($('#nombrereemplazo').val());
					//var cargo = $('#cargo').val();
					//var cargo = $('option:selected','#cargo').attr('id-value'); 
					var empresa = $('#empresa').val();
					var motivo = $('option:selected','#motivo').val();
					var fechaDesde = $.trim($('#fechadesde').val());
					
					//var horaDesde = $.trim($('#horadesde').val());
					//var minDesde = $.trim($('#mindesde').val());
					var fechaHasta = $.trim($('#fechahasta').val());
					//var horaHasta = $.trim($('#horahasta').val());
					//var minHasta = $.trim($('#minhasta').val());

					
					var datos = '';
					datos = datos + 'tipoPersonal='+tipoPersonal+'&';
					datos = datos + 'codBtt='+codbtt+'&';
					datos = datos + 'rutTitular='+rutTitular+'&';
					datos = datos + 'nombreReemplazo='+nombrereemplazo+'&';
					datos = datos + 'rutReemplazo='+rutReemplazo+'&';
					//datos = datos + 'cargo='+cargo+'&';
					datos = datos + 'empresa='+empresa+'&';
					datos = datos + 'motivo='+motivo+'&';
					datos = datos + 'fechaDesde='+fechaDesde+'&';
					//datos = datos + 'horaDesde='+horaDesde+'&';
					//datos = datos + 'minDesde='+minDesde+'&';
					datos = datos + 'fechaHasta='+fechaHasta;
					//datos = datos + 'horaHasta='+horaHasta+'&';
					//datos = datos + 'minHasta='+minHasta;	
					var  executeCarga = $.ajax({
						url: 'sqlGuardias.asp',
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
							var pagina = 'asistenciaSucursalGuardias.asp';
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
				var rutTitular = $.trim($('#rutTitular').val());
				var rutReemplazo = $.trim($('#rutreemplazo').val());
				var nombrereemplazo = $.trim($('#nombrereemplazo').val());
				//var cargo = $.trim($('#cargo').val()); 
				var empresa = $.trim($('#empresa').val());
				var motivo = $('option:selected','#motivo').val();
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
				/*if(cargo == ''){
					alert('Favor seleccionar, cargo');
					$('#cargo').focus();
					flag = false;
					return flag;
				}*/
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
