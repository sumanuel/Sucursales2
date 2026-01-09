<!--#include file="../funciones2.asp"-->
<%idCampo = trim(request("idCampo"))
idSucursal = trim(request("idSucursal"))
nombreSeleccionado = trim(request("nombreSeleccionado"))
idUsuario = trim(request("idUsuario"))
selectJeps = trim(request("selectJeps"))
campo = trim(request("modificaCampo"))
sql = ""
sql = sql & " execute SUC_prc_usuario_sucursal "
sql = sql & " '"&idCampo&"', "
sql = sql & " '"&campo&"', "
sql = sql & " '"&nombreSeleccionado&"', "
sql = sql & " '"&idUsuario&"', "
sql = sql & " '"&idSucursal&"'" 
db.execute(sql)%>
<script type="text/javascript">
	var pagina, div, datos;
	var idSucursal = $('#divMisucursal').attr('data-idSucursal');
	pagina = 'sucursales/misucursal.asp';
	div = 'miSucursal';
	datos='idSucursal='+idSucursal;
	enviaDatos(pagina,div,datos);
</script>