<!--#include file="../funciones.asp"-->
<form class="form-horizontal" name="formIngresoUsuario" id="formIngresoUsuario">
	<div class="control-group">
		<label class="control-label" for="rut">Rut</label>
		<div class="controls">
			<input type="text" id="rut" name="rut" placeholder="Rut">-
			<small class="text-error">* Ej el rut debe ser sin puntos</small>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" for="perfil">Perfil</label>
		<div class="controls">
			<select id="comboPerfil" name="comboPerfil">
				<option value="">[Seleccione perfil]</option>
				<%sql = ""
				sql = sql & "select id_perfil,perfil from suc_perfil "
				set rs = db.execute(sql)
				if not rs.eof then
					datos = rs.GetRows()
					for i=0 to ubound(datos,2)
						idPerfil = trim(datos(0,i))
						nombrePerfil = server.htmlencode(trim(datos(1,i)))%>
						<option value="<%=idPerfil%>">
							<%=nombrePerfil%>
						</option>
					<%next
				end if%>
			</select>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" for="pass">Contraseña</label>
		<div class="controls">
			<div class="input-prepend">
				<span class="add-on">
					<i class="icon-lock"></i>
				</span>
				<input type="password" id="pass" name="pass" placeholder="Contraseña" title="Debe ingresar contraseña">
			</div>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" for="nombre">Nombres</label>
		<div class="controls">
			<div class="input-prepend">
				<span class="add-on">
					<i class="icon-user"></i>
				</span>
				<input type="text" id="nombre" name="nombre" placeholder="Nombres" title="Debe ingresar nombre">
			</div>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" for="app_pat">Apellido paterno</label>
		<div class="controls">
			<div class="input-prepend">
				<span class="add-on">
					<i class="icon-user"></i>
				</span>
				<input type="text" id="app_pat" name="app_pat" placeholder="Apellido paterno" title="Debe ingresar apellido paterno">
			</div>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" for="app_mat">Apellido materno</label>
		<div class="controls">
			<div class="input-prepend">
				<span class="add-on">
					<i class="icon-user"></i>
				</span>
				<input type="text" id="app_mat" name="app_mat" placeholder="Apellido materno" title="Debe ingresar apellido materno">
			</div>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" for="sexo">Sexo</label>
		<div class="controls">
			<label class="radio inline" for="masculino">
				<input type="radio" name="sexo" id="masculino" value="1" title="Debe seleccionar sexo">
				<i class="icon-male icon-2x"></i>
			</label>
			<label class="radio inline" for="femenino">
				<input type="radio" name="sexo" id="femenino" value="2">
				<i class="icon-female icon-2x"></i>
			</label>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" for="correo">Correo</label>
		<div class="controls">
			<div class="input-prepend">
				<span class="add-on">
					<i class="icon-envelope"></i>
				</span>
				<input type="text" id="correo" name="correo" placeholder="Correo"> <small class="text-error">* Ej usuario@losheroes.cl</small>
			</div>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" for="celular">Celular</label>
		<div class="controls">
			<div class="input-prepend">
				<span class="add-on">
					<i class="icon-mobile-phone"></i>
				</span>
				<input type="text" id="celular" name="celular" placeholder="Teléfono celular" title="Debe ingresar teléfono Celular"> 
				<small class="text-error">
					* 0912345678
				</small>
			</div>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" for="anexo">Anexo</label>
		<div class="controls">
			<div class="input-prepend">
				<span class="add-on">
					<i class="icon-phone"></i>
				</span>
				<input type="text" id="anexo" name="anexo" placeholder="Anexo" title="Debe ingresar anexo">
				<small class="text-error">
					* 1234
				</small>
			</div>
		</div>
	</div>
	<div id="errores" class="oculto">El formulario tiene los siguientes errores:</div>
	<div class="control-group">
		<div class="controls">
			<input type="submit" class="btn btn-success" value="Agregar usuario" id="botonRegistroUsuario">
			<span class="btn btn-inverse botonVuelveAdminCreaUsuario">Volver</span>
		</div>
		<div id="enviaDatos" class="oculto"></div>
	</div>
</form>
<script type="text/javascript">
$("#formIngresoUsuario").validate({
		ignore:':not(:visible)',
		onsubmit: true,
		//errorLabelContainer: '#errores',
		rules: {
			rut:{
				required:true,
				rut: true,
				remote:  {
                    type: 'GET',
                    url:"admin/validaDatos.asp"
                }
			},
			comboPerfil:{
				required:true
			},
			pass:{
				required:true
			},
			nombre:{
				required:true
			},
			app_pat:{
				required:true
			},
			app_mat:{
				required:true
			},
			sexo:{
				required:true
			},
			correo:{
				required:true,
				email: true,
				remote:  {
                    type: 'GET',
                    url:"admin/validaDatos.asp"
                }
			},
			celular:{
				required:true,
				number: true
			},
			anexo:{
				required:true,
				number: true
			},
		},
		messages: {
			rut: {
				required: 'El campo no puede estar vacio',
				rut: 'Debe ser un rut válido',
				remote: 'El rut ya existe en la base de datos'
			},
			comboPerfil: {
				required: "Debe seleccionar una opción"
			},
			correo: {
				required: 'El campo no puede estar vacio',
				email: 'Debe ser un correo válido',
				remote: 'El correo ya existe en la base de datos o no es @losheroes.cl'
			}
		},
		submitHandler: function(form) {
			var numero = '&v='+ Math.random() * 999
			var valores = $("#formIngresoUsuario").serialize();
			valores += numero
			//alert(valores)
			//$(':input').addClass('uneditable-input');
			$('#botonRegistroUsuario').hide('fast');
			$('#enviaDatos').removeClass('oculto').html('<strong>Verificando</strong> <img src="img/loader.gif"/>');
			$('#enviaDatos').delay(2000).queue(function( nxt ) {
				$.ajax({
					type:'GET', //en desarrollo como GET en produccion POST
					url:'admin/sqlUsuario.asp', //la pagina que se van los datos
					cache:false,
					//async:true,
					global:false,
					dataType:"html",
					data:valores,
					timeout:10000, //tiempo que espera
					success:function(contenido) //cargo la pagina correctamente
					{
						if (contenido =="1") //si devuelve 1 quiere decir que autentifico
						{
							location.href='main.asp' //lo redirijo
						}
						else
						{
							$('#enviaDatos').html('Existe un error al registrar los datos intentelo en unos instantes');
							$('#buttonIngreso').show('fast');
							$(':input').removeClass('uneditable-input');
						}
					},
					error:function() //si no carga la pagina
					{
						alert('Algo Salio Mal.');
					}
				});
				nxt();
				return false;
			});
		}
	});
	$('.botonVuelveAdminCreaUsuario').click(function(){
		$('#botonCreaUsuario').removeClass('disabled');
		$('#registroUsuarios').slideUp('fast');
		$('#tablaUsuarios, #botonCreaUsuario').slideDown('slow');
	});
</script>