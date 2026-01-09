<!--#include file="../funciones.asp"-->
<%consulta= trim(request("consulta"))
tipoConsulta = trim(request("tipoConsulta"))%>
<div class="row-fluid">
	<div class="span10">
		<%sql = ""
		sql = sql & " select id_sucursal,"
		sql = sql & " suc_nombre "
		sql = sql & " from suc_sucursal "
		sql = sql & " where suc_estado = 1 "
		sql = sql & " order by suc_nombre"
		set rs = db.execute(sql)%>
		<select name="sucursal" id="sucursal" title="Debe seleccionar sucursal">
			<option value="">[Seleccione Sucursal]</option>
		<%if not rs.eof then
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
	</div>
	<div class="span2">
		<span class="icon-stack icon-large iconoEliminaSucursal mano ayuda" data-placement="right" data-original-title="Quitar sucursal">
			<i class="icon-check-empty icon-stack-base"></i>
			<i class="icon-remove"></i>
		</span>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('#sucursal').change(function(){
		try{
			var sucursal = $('select[name="sucursal"]').val();
			var consulta = '<%=consulta%>';
			var tipoConsulta = '<%=tipoConsulta%>';
			pagina = 'transacciones/grafico.asp';
			div = 'cargaGrafico';
			datos='consulta='+consulta+'&tipoConsulta='+tipoConsulta+'&sucursal='+sucursal;
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
	});
	$('.iconoEliminaSucursal').click(function(){
		try{
			var consulta='<%=consulta%>';
			var tipoConsulta = '<%=tipoConsulta%>';
			pagina = 'transacciones/grafico.asp';
			div = 'cargaGrafico';
			datos='consulta='+consulta+'&tipoConsulta='+tipoConsulta;
			enviaDatos(pagina,div,datos);
			$('#seleccionaSucursal').html('Seleccione sucursal').addClass('sinSucursal');
		}
		catch(err){}
	});
});
</script>
