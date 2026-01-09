<!--#include file="../funciones.asp"-->
<div class="row-fluid">
	<div class="span12">
		<!-- mes Actual -->
		<%sql = ""
		sql = sql & " SELECT cast(year(DATEADD(month, 0, getdate())) as varchar(4))"
		sql = sql & " +right('00'+cast(month(DATEADD(month, 0, getdate())) as varchar(2)),2) "
		set rs = db.execute(sql)
		if not rs.eof then
			fecha=trim(rs(0))%>
			<span id="mes1" class="label label-success fechaGrafico <%=fecha%> mano" data-valor="<%=fecha%>">
				Mes Actual
			</span>
		<%end if%>
		<!-- 1 mes -->
		<%sql = ""
		sql = sql & " SELECT cast(year(DATEADD(month, -1, getdate())) as varchar(4))"
		sql = sql & " +right('00'+cast(month(DATEADD(month, -1, getdate())) as varchar(2)),2) "
		set rs = db.execute(sql)
		if not rs.eof then
			fecha=trim(rs(0))%>
			<span id="mes2" class="label label-important fechaGrafico <%=fecha%> mano" data-valor="<%=fecha%>">
				Mes Anterior
			</span>
		<%end if%>
		<!-- 3 meses -->
		<%sql = ""
		sql = sql & " SELECT cast(year(DATEADD(month, -3, getdate())) as varchar(4))"
		sql = sql & " +right('00'+cast(month(DATEADD(month, -3, getdate())) as varchar(2)),2) "
		set rs = db.execute(sql)
		if not rs.eof then
			fecha=trim(rs(0))%>
			<span id="mes3" class="label label-important fechaGrafico <%=fecha%> mano" data-valor="<%=fecha%>">
				3 Meses
			</span>
		<%end if%>
		<!-- 6 meses -->
		<%sql = ""
		sql = sql & " SELECT cast(year(DATEADD(month, -6, getdate())) as varchar(4))"
		sql = sql & " +right('00'+cast(month(DATEADD(month, -6, getdate())) as varchar(2)),2) "
		set rs = db.execute(sql)
		if not rs.eof then
			fecha=trim(rs(0))%>
			<span id="mes6" class="label label-important fechaGrafico <%=fecha%> mano" data-valor="<%=fecha%>">
				6 Meses
			</span>
		<%end if%>
		<!-- 12 meses -->
		<%sql = ""
		sql = sql & " SELECT cast(year(DATEADD(month, -12, getdate())) as varchar(4))"
		sql = sql & " +right('00'+cast(month(DATEADD(month, -12, getdate())) as varchar(2)),2) "
		set rs = db.execute(sql)
		if not rs.eof then
			fecha=trim(rs(0))%>
			<span id="mes12" class="label label-important fechaGrafico <%=fecha%> mano" data-valor="<%=fecha%>">
				12 Meses
			</span>
		<%end if%>
	</div>
</div>
<script type="text/javascript">
$('.fechaGrafico').click(function(){
	var fechaGrafico = $(this).attr('data-valor');
	$('.fechaGrafico').each(function(){
		$(this).removeClass('label-success').addClass('label-important');
	});
	$('.'+fechaGrafico).addClass('label-success');
	muestraGraficoComportamiento();
});
</script>