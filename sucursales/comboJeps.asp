<!--#include file="../funciones2.asp"-->
<%rutJeps = trim(request("rutJeps"))
nombreJeps = trim(request("nombreJeps"))
idSucursal = trim(request("idSucursal"))
sql = ""
sql = sql & " select usuario_nombre, "
sql = sql & " u_nombres+' '+u_apellidos as nombre, id_usuario "
sql = sql & " from SUC_usuario "
sql = sql & " where estado = 0 "
sql = sql & " and id_perfil = 1 "
sql = sql & " and id_usuario not in ('1') "
sql = sql & " order by nombre "
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getrows()
	tieneDatos = 1
end if
if tieneDatos = 1 then%>
	<form id="formDatosModifica" name="formDatosModifica">
		<input type="hidden" name="idCampo" id="idCampo" value="4">
		<input type="hidden" name="nombreSeleccionado" id="nombreSeleccionado">
		<input type="hidden" name="idSucursal" id="idSucursal" value="<%=idSucursal%>">
		<input type="hidden" name="idUsuario" id="idUsuario">
		<select id="selectJeps" name="selectJeps" data-nombreAntiguo="<%=nombreJeps%>">
			<%for i = 0 to ubound(datos,2)
				rutUsuario = trim(datos(0,i))
				nombreUsuario = server.htmlencode(trim(datos(1,i)))
				idUsuario = trim(datos(2,i))
					if rutJeps = rutUsuario then
						selecciona = "selected"
					else
						selecciona = ""
					end if%>
				<option value="<%=rutUsuario%>" <%=selecciona%> data-idUsuario="<%=idUsuario%>">
					<%=nombreUsuario%>
				</option>
			<%next%>
		</select>
		<span class="btn btn-mini btn-danger" id="modificaJeps">Modificar</span>
		<span class="btn btn-mini btn-info" id="btnCancelaAccionJeps">Cancelar</span>
	</form>
	<script type="text/javascript">
	$('#btnCancelaAccionJeps').click(function(){
		var seleccionado = $('#selectJeps').attr('data-nombreAntiguo');
		$('#nombreJeps').html(seleccionado).addClass('label label-info');
		$('#divMisucursal').attr('data-modificandoCampo',0);
	});
	$('#modificaJeps').click(function() {
		var nombreSeleccionado = $.trim($('#selectJeps option:selected').text());
		var idUsuario = $('#selectJeps option:selected').attr('data-idUsuario');
		$('#nombreSeleccionado').val(nombreSeleccionado);
		$('#idUsuario').val(idUsuario);
		var datos = $('#formDatosModifica').serialize(); 
		$('#nombreJeps').html('<img src="img/loader.gif">');
		setTimeout(function(){ 
			var pagina, div
			pagina = 'sucursales/sqlDatosSucursal.asp';
			div = 'nombreJeps';
			var idSucursal = $('#divMisucursal').attr('data-idSucursal');
			enviaDatos(pagina,div,datos);
		}, 1000);
	});
	</script>
<%end if%>