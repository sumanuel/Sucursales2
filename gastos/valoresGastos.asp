<!--#include file="../funciones.asp"-->
<%idZonal = trim(request("idZonal"))
tipo = trim(request("tipo"))
anioPpto = trim(request("anioPpto"))
mesPpto = trim(request("mesPpto"))
sql = ""
sql = sql & " select isnull(sum(zonal_ppto_monto),0) "
sql = sql & " from SUC_zonales_ppto "
sql = sql & " where id_zonal = (select top 1 id_zonal from SUC_zonales where id_usuario = '"&idZonal&"') "
sql = sql & " and zonal_ppto_activo = '1' "
if mesPpto = "" then
	sql = sql & " and zonal_ppto_mes = month(GETDATE()) "
else
	if len(mesPpto) = 1 then mesPpto = "0"&mesPpto
	sql = sql & " and zonal_ppto_mes = '"&mesPpto&"' "
end if
if anioPpto = "" then
	sql = sql & " and zonal_ppto_ano = year(GETDATE()) "
else
	sql = sql & " and zonal_ppto_ano = '"&anioPpto&"' "
end if
sql = sql & "and id_zonal_ppto_tipo = '"&tipo&"' "

'response.Write(sql & "<br/>")

set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	for i = 0 to ubound(datos,2)
		zonalMonto1 = zonalMonto1 + clng(trim(datos(0,i)))
	next
end if
sql = ""
sql = sql & " select isnull(SUM(zonal_ppto_gasto),0) as totalGastoPresupuesto "
sql = sql & " from SUC_zonales_ppto_gastos "
sql = sql & " where id_zonal = '"&idZonal&"' "
if mesPpto = "" then
	sql = sql & " and zonal_ppto_gasto_mes = month(GETDATE()) "
else
	if len(mesPpto) = 1 then mesPpto = "0"&mesPpto
	sql = sql & " and zonal_ppto_gasto_mes = '"&mesPpto&"' "
end if
if anioPpto = "" then
	sql = sql & " and zonal_ppto_gasto_ano = year(GETDATE()) "
else
	sql = sql & " and zonal_ppto_gasto_ano = '"&anioPpto&"' "
end if
sql = sql & " and id_zonal_ppto_tipo = '"&tipo&"' "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	for i = 0 to ubound(datos,2)
		sumaTipo1 = sumaTipo1 + clng(trim(datos(0,i)))
	next
end if
diferencia = zonalMonto1 - sumaTipo1%>
<div class="row-fluid ">
	<div class="span12 valores">
		<div class="row-fluid">
			<div class="span2">
				Presupuesto total
			</div>
			<div class="span2 presupuestoTotal" data-montoTotal="<%=zonalMonto1%>">
				<strong>
					$<%=formatnumber(zonalMonto1,0)%>
				</strong>
			</div>
			<div class="span2">
				Monto gastado
			</div>
			<div class="span2 presupuestoTotal"  data-montoGastado="<%=sumaTipo1%>">
				<strong>
					$<%=formatnumber(sumaTipo1,0)%>
				</strong>
			</div>
			<div class="span2">Saldo</div>
			<div class="span2 diferenciaMonto"data-diferenciaMonto="<%=diferencia%>">
				<strong>
					$<%=formatnumber(diferencia,0)%>
				</strong>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
valorMonto = parseInt($('.diferenciaMonto').attr('data-diferenciaMonto'));
if ( valorMonto === 0)
{
	$('.valores').addClass('alert alert-info')
}
if ( valorMonto > 0)
{
	$('.valores').addClass('alert alert-success')
}
if ( valorMonto < 0)
{
	$('.valores').addClass('alert alert-error')
}
/*if (parseInt($('.diferenciaMonto').attr('data-diferenciaMonto') > 0)
{
	$('.valores').addClass('alert alert-success')
}
if (parseInt($('.diferenciaMonto').attr('data-diferenciaMonto') < 0)
{
	$('.valores').addClass('alert alert-error')
}*/
</script>