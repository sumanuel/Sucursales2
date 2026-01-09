<!--#include file="../funciones.asp"-->
<%
idZonal = trim(request("idZonal"))
anioPpto = trim(request("anioPpto"))
mesPpto = trim(request("mesPpto"))
zonalMontoTotal = 0
sumaTipo1 = 0
sumaTipo2 = 0
sumaTipo3 = 0
sumaTipo4 = 0
zonalMonto1 = 0
zonalMonto2 = 0
zonalMonto3 = 0
zonalMonto4 = 0
'monto total'
sql = ""
sql = sql & " select isnull(sum(zonal_ppto_monto),0) "
sql = sql & " from SUC_zonales_ppto "
sql = sql & " where id_zonal=(select top 1 id_zonal from SUC_zonales where id_usuario = '"&idZonal&"')"
sql = sql & " and zonal_ppto_activo = 1 "
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

'Response.Write(sql & "<br/>")

set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	for i = 0 to ubound(datos,2)
		zonalMontoTotal = zonalMontoTotal + clng(trim(datos(0,i)))
	next
end if


sql = ""
sql = sql & " select isnull(sum(zonal_ppto_monto),0) "
sql = sql & " from SUC_zonales_ppto "
sql = sql & " where id_zonal=(select top 1 id_zonal from SUC_zonales where id_usuario = '"&idZonal&"')"
sql = sql & " and zonal_ppto_activo = 1 "
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
sql = sql & "and id_zonal_ppto_tipo = 1 "

'Response.Write(sql & "<br/>")

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
sql = sql & " where id_zonal = '"&idZonal&"'"
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
sql = sql & " and id_zonal_ppto_tipo = 1 "

'Response.Write(sql & "<br/>")

set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	for i = 0 to ubound(datos,2)
		sumaTipo1 = sumaTipo1 + clng(trim(datos(0,i)))
	next
end if
sumaTipo1 = zonalMonto1 - sumaTipo1

sql = ""
sql = sql & " select isnull(sum(zonal_ppto_monto),0) "
sql = sql & " from SUC_zonales_ppto "
sql = sql & " where id_zonal = (select top 1 id_zonal from SUC_zonales where id_usuario = '"&idZonal&"')"
sql = sql & " and zonal_ppto_activo = 1 "
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
sql = sql & "and id_zonal_ppto_tipo = 2 "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	for i = 0 to ubound(datos,2)
		zonalMonto2 = zonalMonto2 + clng(trim(datos(0,i)))
	next
end if

sql = ""
sql = sql & " select isnull(SUM(zonal_ppto_gasto),0) as totalGastoPresupuesto "
sql = sql & " from SUC_zonales_ppto_gastos "
sql = sql & " where id_zonal = '"&idZonal&"'"
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
sql = sql & " and id_zonal_ppto_tipo = 2 "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	for i = 0 to ubound(datos,2)
		sumaTipo2 = sumaTipo2 + clng(trim(datos(0,i)))
	next
end if
sumaTipo2 = zonalMonto2 - sumaTipo2

sql = ""
sql = sql & " select isnull(sum(zonal_ppto_monto),0) "
sql = sql & " from SUC_zonales_ppto "
sql = sql & " where id_zonal = (select top 1 id_zonal from SUC_zonales where id_usuario = '"&idZonal&"')"
sql = sql & " and zonal_ppto_activo = 1 "
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
sql = sql & "and id_zonal_ppto_tipo = 3 "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	for i = 0 to ubound(datos,2)
		zonalMonto3 = zonalMonto3 + clng(trim(datos(0,i)))
	next
end if

sql = ""
sql = sql & " select isnull(SUM(zonal_ppto_gasto),0) as totalGastoPresupuesto "
sql = sql & " from SUC_zonales_ppto_gastos "
sql = sql & " where id_zonal = '"&idZonal&"'"
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
sql = sql & " and id_zonal_ppto_tipo = 3 "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	for i = 0 to ubound(datos,2)
		sumaTipo3 = sumaTipo3 + clng(trim(datos(0,i)))
	next
end if
sumaTipo3 = zonalMonto3 - sumaTipo3

sql = ""
sql = sql & " select isnull(sum(zonal_ppto_monto),0) "
sql = sql & " from SUC_zonales_ppto "
sql = sql & " where id_zonal = (select top 1 id_zonal from SUC_zonales where id_usuario = '"&idZonal&"')"
sql = sql & " and zonal_ppto_activo = 1 "
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
sql = sql & "and id_zonal_ppto_tipo = 4 "
set rs = db.execute(sql)
if not rs.eof then
	sql2 = ""
	sql2 = sql2 & ""
	datos = rs.GetRows()
	for i = 0 to ubound(datos,2)
		zonalMonto4 = zonalMonto4 + clng(trim(datos(0,i)))
	next
end if
sql = ""
sql = sql & " select isnull(SUM(zonal_ppto_gasto),0) as totalGastoPresupuesto "
sql = sql & " from SUC_zonales_ppto_gastos "
sql = sql & " where id_zonal = '"&idZonal&"'"
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
sql = sql & " and id_zonal_ppto_tipo = 4 "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	for i = 0 to ubound(datos,2)
		sumaTipo4 = sumaTipo4 + clng(trim(datos(0,i)))
	next
end if
sumaTipo4 = zonalMonto4 - sumaTipo4

zonalSaldoMontoTotal = sumaTipo1 + sumaTipo2 + sumaTipo3 + sumaTipo4 

%>
<div class="row-fluid">
	<div class="span12 principalPpto">
		<div class="row-fluid">
			<div class="span4 offset5 tituloPpto">Presupuesto Total</div>
		</div>
		<div class="row-fluid">
			<div class="span2 well">
				<div class="row-fluid">
					<div class="span6 pagination pagination-right">
						Total
					</div>
					<div class="span6 pagination pagination-right">
						$<%=formatnumber(zonalMontoTotal,0)%>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span6 pagination pagination-right textosaldoTotal">Saldo Total</div>
					<div class="span6 pagination pagination-right saldoTotal" data-valorSaldo="<%=zonalSaldoMontoTotal%>" id="saldoTotal">
						<strong>
							$<%=formatnumber(zonalSaldoMontoTotal,0)%>
						</strong>
						<span id="icono"></span>
					</div>
				</div>
			</div>
			<div class="span2 well">
				<div class="row-fluid">
					<div class="span6 pagination pagination-right">Movilización</div>
					<div class="span6 pagination pagination-right monto1" data-valorSaldo="<%=zonalMonto1%>" id="monto1">
						$<%=formatnumber(zonalMonto1,0)%>
						<span id="icono"></span>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span6 pagination pagination-right textosaldoTotal1">Saldo</div>
					<div class="span6 pagination pagination-right saldoTotal1" data-valorSaldo="<%=sumaTipo1%>" id="saldoTotal1">
						<strong>
							$<%=formatnumber(sumaTipo1,0)%>
						</strong>
						<span id="icono"></span>
					</div>
				</div>
			</div>
			<div class="span2 well">
				<div class="row-fluid">
					<div class="span6 pagination pagination-right">Alojamiento</div>
					<div class="span6 pagination pagination-right monto2" data-valorSaldo="<%=zonalMonto2%>" id="monto2">
						$<%=formatnumber(zonalMonto2,0)%>
						<span id="icono"></span>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span6 pagination pagination-right textosaldoTotal2">Saldo</div>
					<div class="span6 pagination pagination-right saldoTotal2" data-valorSaldo="<%=sumaTipo2%>" id="saldoTotal2">
						<strong>
							$<%=formatnumber(sumaTipo2,0)%>
						</strong>
						<span id="icono"></span>
					</div>
				</div>
			</div>
			<div class="span2 well">
				<div class="row-fluid">
					<div class="span6 pagination pagination-right">Alimentación</div>
					<div class="span6 pagination pagination-right monto" data-valorSaldo="<%=zonalMonto3%>" id="monto3">
						$<%=formatnumber(zonalMonto3,0)%>
						<span id="icono"></span>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span6 pagination pagination-right textosaldoTotal3">Saldo</div>
					<div class="span6 pagination pagination-right saldoTotal3" data-valorSaldo="<%=sumaTipo3%>" id="saldoTotal3">
						<strong>
							$<%=formatnumber(sumaTipo3,0)%>
						</strong>
						<span id="icono"></span>
					</div>
				</div>
			</div>
			<div class="span2 well">
				<div class="row-fluid">
					<div class="span6 pagination pagination-right">Viático</div>
					<div class="span6 pagination pagination-right monto" data-valorSaldo="<%=zonalMonto4%>" id="monto4">
						$<%=formatnumber(zonalMonto4,0)%>
						<span id="icono"></span>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span6 pagination pagination-right textosaldoTotal4">Saldo</div>
					<div class="span6 pagination pagination-right saldoTotal4" data-valorSaldo="<%=sumaTipo4%>" id="saldoTotal4">
						<strong>
							$<%=formatnumber(sumaTipo4,0)%>
						</strong>
						<span id="icono"></span>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
var atributo = 'data-valorSaldo';
poneColor($('.saldoTotal').attr(atributo),'saldoTotal');
poneColor($('.saldoTotal1').attr(atributo),'saldoTotal1');
poneColor($('.saldoTotal2').attr(atributo),'saldoTotal2');
poneColor($('.saldoTotal3').attr(atributo),'saldoTotal3');
poneColor($('.saldoTotal4').attr(atributo),'saldoTotal4');

</script>
