<!--#include file="../funciones.asp"-->
<%perfil = trim(request("perfilMain"))
idUsuario = trim(request("idUsuarioMain"))
sql = ""
sql = sql & " select id_sucursal,"
sql = sql & " suc_nombre "
sql = sql & " from suc_sucursal "
if perfil <> "3" then
	sql = sql & " where id_sucursal in "
	sql = sql & " (select id_sucursal "
	sql = sql & " from SUC_usuario_sucursal "
	sql = sql & " where id_usuario = '"&idUsuario&"') "
end if
sql = sql & " order by suc_nombre"
'response.write(sql)
'response.end
set rs = db.execute(sql)%>
<select name="sucursal" id="sucursal" title="Debe seleccionar sucursal">
	<option value="">[Seleccione Sucursal]</option>
<%
if not rs.eof then
	datos = rs.GetRows()
	For i = 0 to ubound(datos, 2)
		idSucursal = trim(datos(0,i))
		nombreSucursal = server.htmlencode(trim(datos(1,i)))%>
		<option value="<%=idSucursal%>">
			<%=nombreSucursal%>
		</option>
	<%next
end if%>
</select>
<script type="text/javascript">
$('#sucursal').on('change',function(){
	var valorCombo = $('#sucursal option:selected').val();
	$('#controlSucursales').removeClass('error');
	$('.help-inline').remove();
	if (valorCombo == '')
	{
		$('#controlSucursales').addClass('error').append('<span class="help-inline">Debe seleccionar sucursal</span>');
	};
	return false;
});
</script>