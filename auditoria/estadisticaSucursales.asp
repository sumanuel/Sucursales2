<!--#include file="../funciones.asp"-->
<%noTiene = 0
tiene = 0
sql = ""
sql = sql & " select ( "
sql = sql & " select COUNT(distinct id_sucursal ) totalSucursales "
sql = sql & " from SUC_sucursal "
sql = sql & " where id_sucursal not in "
sql = sql & " (select id_auditoria "
sql = sql & " from SUC_sucursal_auditoria a "
sql = sql & " where fecha_auditoria = ( " 
sql = sql & " select max(distinct fecha_auditoria ) "
sql = sql & " from SUC_sucursal_auditoria b "
sql = sql & " where a.id_sucursal = b.id_sucursal) "
sql = sql & " ) and suc_estado = 1) as noTiene "
sql = sql & " , "
sql = sql & " (select COUNT(distinct id_sucursal ) totalSucursales "
sql = sql & " from SUC_sucursal "
sql = sql & " where id_sucursal in "
sql = sql & " (select id_auditoria "
sql = sql & " from SUC_sucursal_auditoria a "
sql = sql & " where fecha_auditoria = (select max(distinct fecha_auditoria ) "
sql = sql & " from SUC_sucursal_auditoria b "
sql = sql & " where a.id_sucursal = b.id_sucursal) "
sql = sql & " ) and suc_estado = 1) as tiene "
set rs = db.execute(sql)
if not rs.eof then
	noTiene = trim(rs(0))
	tiene = trim(rs(1))
end if%>
<div class="row-fluid">
	<div class="span12 alert alert-info">
		<div class="row-fluid">
			<div class="span12 centrado">
				<strong>Sucursales con Auditoría</strong>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span6 centrado mano alert alert-success tieneEstadistica" data-tiene="1">
				<strong>
					<%=tiene%>
					<i class="icon-check"></i>
				</strong>
			</div>
			<div class="span6 centrado mano alert alert-error tieneEstadistica" data-tiene="0">
				<strong>
					<%=noTiene%>
					<i class="icon-check-empty"></i>
				</strong>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$('tieneEstadistica').click(function(){
		var pagina,tiene,donde,datos
		pagina = 'auditoria/estadisticaSucursalesMuestra.asp';
		tiene = $(this).attr('data-tiene')
		donde = 'muestraPaginasEstadisticas';
		datos = 'tipo=1&tiene='+tiene;
		try{
		       enviaDatos(pagina,div,datos);
		}catch(err){}
		return false;
	});
});
</script>
