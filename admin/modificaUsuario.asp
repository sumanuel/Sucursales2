<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuario"))
sql = ""
sql = sql & " select usuario_rut, "
sql = sql & " usuario_dv, "
sql = sql & " id_perfil, "
sql = sql & " nombre, "
sql = sql & " apellido_paterno, "
sql = sql & " apellido_materno, "
sql = sql & " sexo, "
sql = sql & " usuario_estado, "
sql = sql & " correo, "
sql = sql & " celular, "
sql = sql & " anexo "
sql = sql & " from SUC_m_usuarios "
sql = sql & " where id_usuario = '"&idUsuario&"' "
set rs = db.execute(sql)
if not rs.eof then
	txtrut = trim(rs("usuario_rut"))&"-"&trim(rs("usuario_dv"))
	idPerfil = trim(rs("id_perfil"))
	nombres = server.htmlencode(trim(rs("nombre")))
	apellidoPat = server.htmlencode(trim(rs("apellido_paterno")))
	apellidoMat = server.htmlencode(trim(rs("apellido_materno")))
	sexo = trim(rs("sexo"))
	correo=trim(rs("correo"))
	celular = trim(rs("celular"))
	anexo = trim(rs("anexo"))%>
	<form class="form-horizontal" name="formModUsuario" id="formModUsuario">
		<input type="hidden" name="idUsuario" id="idUsuario" value="<%=idUsuario%>">
		<input type="hidden" name="accion" id="accion" value="2">
		<div class="control-group">
			<label class="control-label" for="rut">Rut</label>
			<div class="controls">
				<%=txtrut%>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="perfil">Perfil</label>
			<div class="controls">
				<select id="comboPerfil" name="comboPerfil">
					<option value="">[Seleccione perfil]</option>
					<%sql2 = ""
					sql2 = sql2 & "select id_perfil,perfil from suc_perfil "
					set rs2 = db.execute(sql2)
					if not rs2.eof then
						datos = rs2.GetRows()
						for i=0 to ubound(datos,2)
							idPerfilDatos = trim(datos(0,i))
							nombrePerfil = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idPerfil%>"
								<%if idPerfil = idPerfilDatos then response.write("selected")%> >
								<%=nombrePerfil%>
							</option>
						<%next
					end if%>
				</select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="nombre">Nombres</label>
			<div class="controls">
				<div class="input-prepend">
					<span class="add-on">
						<i class="icon-user"></i>
					</span>
					<input type="text" id="nombre" name="nombre" placeholder="Nombres" title="Debe ingresar nombre" value="<%=nombres%>">
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
					<input type="text" id="app_pat" name="app_pat" placeholder="Apellido paterno" title="Debe ingresar apellido paterno" value="<%=apellidoPat%>">
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
					<input type="text" id="app_mat" name="app_mat" placeholder="Apellido materno" title="Debe ingresar apellido materno" value="<%=apellidoMat%>">
				</div>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="sexo">Sexo</label>
			<div class="controls">
				<label class="radio inline" for="masculino">
					<input type="radio" name="sexo" id="masculino" value="1" title="Debe seleccionar sexo" <%if sexo = "1" then response.write("checked")%>>
					<i class="icon-male icon-2x"></i>
				</label>
				<label class="radio inline" for="femenino">
					<input type="radio" name="sexo" id="femenino" value="2" <%if sexo = "2" then response.write("checked")%>>
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
					<input type="text" id="correo" name="correo" placeholder="Correo" value ="<%=correo%>"> <small class="text-error">* Ej usuario@losheroes.cl</small>
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
					<input type="text" id="celular" name="celular" placeholder="Teléfono celular" title="Debe ingresar teléfono Celular" value=<%=celular%>> 
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
					<input type="text" id="anexo" name="anexo" placeholder="Anexo" title="Debe ingresar anexo" value="<%=anexo%>">
					<small class="text-error">
						* 1234
					</small>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
				<input type="submit" class="btn btn-success" value="Modificar usuario" id="botonRegistroUsuario">
				<span class="btn btn-inverse botonVuelveAdminModificaUsuario">Volver</span>
			</div>
			<div id="enviaDatos" class="oculto"></div>
		</div>
	</form>
	<script type="text/javascript">
	$(function(){

	});
	$("#formModUsuario").validate({
		ignore:':not(:visible)',
		onsubmit: true,
		//errorLabelContainer: '#errores',
		rules: {
			comboPerfil:{
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
				email: true
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
			comboPerfil: {
				required: "Debe seleccionar una opción"
			},
			correo: {
				required: 'El campo no puede estar vacio',
				email: 'Debe ser un correo válido'
			}
		},
		submitHandler: function(form) {
			var numero = '&v='+ Math.random() * 999
			var valores = $("#formModUsuario").serialize();
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
							location.href='main.asp'; //lo redirijo
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
$('.botonVuelveAdminModificaUsuario').click(function(){
	$('#botonCreaUsuario').removeClass('disabled');
	$('#registroUsuarios').slideUp('fast');
	$('#tablaUsuarios, #botonCreaUsuario').slideDown('slow');
});
	</script>
<%end if%>