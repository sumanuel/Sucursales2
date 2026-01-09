<%idSucursal = trim(request("idSucursal"))
idUsuario = trim(request("idUsuario"))
perfil = trim(request("perfil"))%>
<form name="form2" id="form2" action="../main.asp" method="post">
	<input type="hidden" name="idSucursalMain" id="idSucursalMain" value="<%=idSucursal%>">
	<input type="hidden" name="idUsuarioMain" id="idUsuarioMain" value="<%=idUsuario%>">
	<input type="hidden" name="perfilMain" id="perfilMain" value="<%=perfil%>">
</form>
<script src="../js/jquery-1.10.2.min.js" type="text/javascript"></script>
<script type="text/javascript">
//xx = $('#form2').serialize()
//alert(xx)
$('#form2').submit();
</script>