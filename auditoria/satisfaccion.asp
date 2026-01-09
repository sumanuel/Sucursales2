<!--#include file="../funciones.asp"-->
<%
sql = ""
sql = sql & " select ( "
sql = sql & " select COUNT(*) "
sql = sql & " from SUC_sucursal_auditoria a "
sql = sql & " where fecha_auditoria = "
sql = sql & " (select max(distinct fecha_auditoria ) "
sql = sql & " from SUC_sucursal_auditoria b "
sql = sql & " where a.id_sucursal = b.id_sucursal) "
sql = sql & " and evaluacion = 1) as satisfecho "
sql = sql & " , "
sql = sql & " (select COUNT(*) "
sql = sql & " from SUC_sucursal_auditoria a "
sql = sql & " where fecha_auditoria = "
sql = sql & " (select max(distinct fecha_auditoria ) "
sql = sql & " from SUC_sucursal_auditoria b "
sql = sql & " where a.id_sucursal = b.id_sucursal) "
sql = sql & " and evaluacion = 2 "
sql = sql & " ) as insatisfecho "
set rs = db.execute(sql)
if not rs.eof then
	satisfecho = trim(rs(0))
	insatisfecho = trim(rs(1))
end if%>
<div class="row-fluid">
	<div class="span12 alert alert-info">
		<div class="row-fluid">
			<div class="span12 centrado">
				<strong>Satisfaccion de sucursales</strong>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span6 centrado mano alert alert-success tieneEstadistica" data-satisfaccion="1">
				<strong>
					<%=satisfecho%>
					<i class="icon-check"></i>
				</strong>
			</div>
			<div class="span6 centrado mano alert alert-error tieneEstadistica" data-satisfaccion="0">
				<strong>
					<%=insatisfecho%>
					<i class="icon-check-empty"></i>
				</strong>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$('.tieneEstadistica').click(function(){
	var pagina,satisfaccion,div,datos
	pagina = 'auditoria/estadisticaSucursalesMuestra.asp';
	satisfaccion = $(this).attr('data-satisfaccion')
	div = 'muestraPaginasEstadisticas';
	datos = 'tipo=2&tiene='+satisfaccion;
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
	return false;
});
</script>