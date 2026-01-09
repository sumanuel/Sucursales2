<!--#include file="../funciones.asp"-->
<%valorMarca = trim(request("valorMarca"))
tipo = trim(request("tipo"))
sql = ""
sql = sql & " select id_activo_modelo, "
sql = sql & " nombre_activo_modelo, "
sql = sql & " serie_min, "
sql = sql & " serie_max, "
sql = sql & " ayuda "
sql = sql & " from suc_activo_modelos "
sql = sql & " where id_activo_marca = '"&valorMarca&"' "
sql = sql & " and tipo = '"&tipo&"' "
sql = sql & " order by nombre_activo_modelo asc "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
end if%>
<select id="campoModelo" name="campoModelo">
	<option value="">[Seleccione Modelo]</option>
	<%For i = 0 to ubound(datos, 2)
		idModelo = trim(datos(0,i))
		nombreModelo = server.htmlencode(trim(datos(1,i)))
		serieMin = trim(datos(2,i))
		serieMax = trim(datos(3,i))
		ayuda = trim(datos(4,i))%>
		<option value="<%=idModelo%>" data-serieMax="<%=serieMax%>" data-serieMin="<%=serieMin%>" data-serieAyuda="<%=ayuda%>"><%=nombreModelo%></option>
	<%next%>
</select>
<script type="text/javascript">
$('#campoModelo').change(function(){
	var pagina='activos/activosSerie.asp';
	var div = 'divSerie';
	var modelo = $('select#campoModelo option:selected').val();
	var serieMax = $('select#campoModelo option:selected').attr('data-serieMax');
	var serieMin = $('select#campoModelo option:selected').attr('data-serieMin');
	var ayuda = $('select#campoModelo option:selected').attr('data-serieAyuda');
	var datos='serieMax='+serieMax+'&serieMin='+serieMin+'&modelo='+modelo+'&ayuda='+ayuda;
	try{
		enviaDatos(pagina,div,datos);
	}catch(err){}	
});
</script>