<!--#include file="../funciones2.asp"-->
<%idSucursal = trim(request("idSucursal"))
sql = ""
sql = sql & " select b.usuario_rut, "
sql = sql & " b.u_nombres +' '+b.u_apellidos, "
sql = sql & " a.id_usu_suc "
sql = sql & " from SUC_usuario_sucursal a, "
sql = sql & " SUC_usuario b "
sql = sql & " where id_sucursal = '"&idSucursal&"' "
sql = sql & " and a.id_usuario = b.id_usuario "
sql = sql & " and b.id_perfil = 1 "
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getrows()
	tieneDatos = 1
end if
if tieneDatos = 1 then%>
<table id="tablaUsuariosSucursal" class="table table-bordered table-hover table-condensed" data-eliminando="0">
	<thead>
		<tr>
			<th>Rut</th>
			<th>Nombre</th>
			<th>Accion</th>
		</tr>
	</thead>
	<tbody>
	<%for i = 0 to ubound(datos,2)
		usuarioRut = trim(datos(0,i))
		usuarioNombre = trim(datos(1,i))
		idUsuario = trim(datos(2,i))
		dvrutUsuario = right(usuarioRut,1)
		largoRut = len(usuarioRut)-2
		rutUsuario = left(usuarioRut,largoRut)
		sql = ""
		sql = sql & "select 1 "
		sql = sql & " from suc_sucursal "
		sql = sql & " where suc_jeps_rut = '"&rutUsuario&"' "
		sql = sql & " and id_sucursal = '"&idSucursal&"' "
		'response.write(sql)
		set rs = db.execute(sql)
		if not rs.eof then
			poneJeps = 1
		else
			poneJeps = 0
		end if%>
		<tr id="trUsuario<%=idUsuario%>" data-esJeps="<%=poneJeps%>" data-idSucursal="<%=idSucursal%>">
			<td><%=usuarioRut%></td>
			<td><%=usuarioNombre%></td>
			<td>
				<span id="botonElimina<%=idUsuario%>" onClick="presionaElimina('<%=idUsuario%>');" class="mano">
					<i class="icon-trash icon-2x"></i>
				</span>
				<span id="confirmaElimina<%=idUsuario%>" class="confirmaEliminaDatos label label-inverse">
					<span id="textoBotonElimina<%=idUsuario%>"></span> 
					<span onClick="cancelaElimina('<%=idUsuario%>');" class="btn btn-mini btn-danger">
						Cancelar
					</span>
					<span onClick="elimina('<%=idUsuario%>');" class="btn btn-mini btn-success">
						Eliminar
					</span>
				</span>
				<%if poneJeps = 0 then%>
					<span id="establecerJeps<%=idUsuario%>" class="tool mano" data-placement="top" data-original-title="Establecer como Jeps">
						<span class="estableceJeps" data-idUsuario="<%=idUsuario%>">
							<i class="icon-star icon-2x"></i>
						</span>
					</span>
				<%else%>
					<span class="label label-info">Jeps actual</span>
				<%end if%>
			</td>
		</tr>
	<%next%>
</tbody>
</table>
<script type="text/javascript">
	$('.tool').tooltip();
	$('.confirmaEliminaDatos').hide();
	function presionaElimina(idUsuario)
	{
		var esJeps = $('#trUsuario'+idUsuario).attr('data-esJeps');
		var textoJeps = '';
		if (esJeps ==='1')
		{
			textoJeps = 'El usuario seleccionado es Jeps. Esta seguro de eliminar?';
		}
		else
		{
			textoJeps = 'Desea Eliminar?';
		}
		$('#textoBotonElimina'+idUsuario).text(textoJeps);
		$('#botonElimina'+idUsuario).slideUp('fast');
		$('#confirmaElimina'+idUsuario).slideDown('slow');
	}
	function cancelaElimina(idUsuario)
	{
		$('#confirmaElimina'+idUsuario).slideUp('fast');
		$('#botonElimina'+idUsuario).slideDown('slow');
	}
	function elimina(idUsuario)
	{
		var pagina,div,datos;
		var esJeps = $('#trUsuario'+idUsuario).attr('data-esJeps');
		pagina = 'sucursales/sqlEliminaUsuarioSucursal.asp';
		div = 'confirmaElimina'+idUsuario;
		datos='idUsuario='+idUsuario+'&esJeps='+esJeps;
		enviaDatos(pagina,div,datos);
		$('#trUsuario'+idUsuario).hide('slow');
		if (esJeps ==='1')
		{
			var idSucursal = $('#trUsuario'+idUsuario).attr('data-idSucursal');
			pagina = 'sucursales/misucursal.asp';
			div = 'miSucursal';
			datos='idSucursal='+idSucursal;
			enviaDatos(pagina,div,datos);
		}

	}
	$('.estableceJeps').click(function() {
		var idUsuario = $(this).attr('data-idUsuario');
		var pagina, div, datos;
		pagina = 'sucursales/sqlEstableceJeps.asp';
		div = 'establecerJeps'+idUsuario;
		datos='idUsuario='+idUsuario;
		enviaDatos(pagina,div,datos);
		var idSucursal = $('#trUsuario'+idUsuario).attr('data-idSucursal');
		pagina = 'sucursales/misucursal.asp';
		div = 'miSucursal';
		datos='idSucursal='+idSucursal;
		enviaDatos(pagina,div,datos);
	});
</script>
<%else%>
<div class="row-fluid">
	<div class="span5 offset3 label label-important text-center">
		No existen usuarios asociados a la sucursal
	</div>
</div>
<%end if%>