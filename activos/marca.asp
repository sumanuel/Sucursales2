<!--#include file="../funciones.asp"-->
<%tipoElemento = trim(request("tipoElemento"))
tipo = trim(request("tipo"))
sql = ""
sql = sql & " select id_activo_marca, "
sql = sql & " nombre_activo_marca "
sql = sql & " from SUC_activo_marca "
sql = sql & " where id_activo_marca in "
sql = sql & " (select id_activo_marca "
sql = sql & " from suc_activo_modelos "
sql = sql & " where tipo = '"&tipo&"') "
sql = sql & " and id_activo_tipo = '"&tipoElemento&"' "
sql = sql & " order by nombre_activo_marca asc "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
end if%>
<select id="campoMarca" name="campoMarca" data-rule-required="true" data-msg-required="Debe seleccionar una opción">
	<option value="">[Seleccione Marca]</option>
	<%For i = 0 to ubound(datos, 2)
		idMarca = trim(datos(0,i))
		nombreMarca = server.htmlencode(trim(datos(1,i)))%>
		<option value="<%=idMarca%>"><%=nombreMarca%></option>
	<%next%>
</select>
<script type="text/javascript">
$('#campoMarca').change(function(){
	var valorMarca = $(this).val();
	var pagina="activos/modeloPc.asp"
	var div = 'controlModelo';
	var datos = 'valorMarca='+valorMarca+'&tipo=<%=tipo%>';
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}
});
</script>