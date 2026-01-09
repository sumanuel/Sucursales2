<!--#include file="../funciones.asp"-->
<%fechaActual = date()
diaActual = formateaParaFecha(day(fechaActual))
mesActual = formateaParaFecha(month(fechaActual))
anioActual = year(fechaActual)
fechaActual = anioActual&"-"&mesActual&"-"&diaActual
sql = ""
sql = sql & " select COUNT(*) as totalSucursales "
sql = sql & " from SUC_sucursal "
sql = sql & " where suc_estado = 1 "
set rs=db.execute(sql)
if not rs.eof then
	totalSucursales = clng(trim(rs(0)))
else
	totalSucursales = 0
end if
if totalSucursales <> 0 then
	sql = ""
	sql = sql & " select COUNT(*) nro from ( "
	sql = sql & " select a.id_sucursal, a.situacion "
	sql = sql & " from SUC_desbordes a "
	sql = sql & " where a.fecha = '"&fechaActual&"' and "
	sql = sql & " a.hora = (select MAX(b.hora) "
	sql = sql & " from SUC_desbordes b "
	sql = sql & " where b.fecha = '"&fechaActual&"' and "
	sql = sql & " a.id_sucursal = b.id_sucursal)) as z "
	set rs=db.execute(sql)
	if not rs.eof then
		sucursalesInformadas = clng(trim(rs(0)))
	end if
	sucursalesNoInformadas = totalSucursales - sucursalesInformadas
	if sucursalesNoInformadas > 0 then
		porcentajeNoInformada = sucursalesNoInformadas * 100
		porcentajeNoInformada = porcentajeNoInformada / totalSucursales
		porcentajeNoInformada = round(porcentajeNoInformada)
	else
		progresoNoInforma = "progress-success"
		badge = "badge-success"
	end if
	if porcentajeNoInformada > 70 then
		progresoNoInforma = "progress-danger"
		badge = "badge-important"
	else
		progresoNoInforma = "progress-warning"
		badge = "badge-warning"
	end if
	
	sql = ""
	sql = sql & " select z.situacion, COUNT(*) nro from ( "
	sql = sql & " select a.id_sucursal, a.situacion "
	sql = sql & " from SUC_desbordes a "
	sql = sql & " where a.fecha = '"&fechaActual&"' and "
	sql = sql & " a.hora = (select MAX(b.hora) "
	sql = sql & " from SUC_desbordes b "
	sql = sql & " where b.fecha = '"&fechaActual&"' and "
	sql = sql & " a.id_sucursal = b.id_sucursal)) as z "
	sql = sql & " where situacion = 'Nadie' "
	sql = sql & " group by z.situacion "
	' en relacion al total de sucursales
	set rs=db.execute(sql)
	if not rs.eof then
		sucursalesNadie = trim(rs(1))
	end if
	if sucursalesNadie > 0 then
		porcentajeNadie = sucursalesNadie * 100
		porcentajeNadie = porcentajeNadie / totalSucursales
		porcentajeNadie = round(porcentajeNadie)
	end if
	sql = ""
	sql = sql & " select z.situacion, COUNT(*) nro from ( "
	sql = sql & " select a.id_sucursal, a.situacion "
	sql = sql & " from SUC_desbordes a "
	sql = sql & " where a.fecha = '"&fechaActual&"' and "
	sql = sql & " a.hora = (select MAX(b.hora) "
	sql = sql & " from SUC_desbordes b "
	sql = sql & " where b.fecha = '"&fechaActual&"' and "
	sql = sql & " a.id_sucursal = b.id_sucursal)) as z "
	sql = sql & " where situacion = '1/4' "
	sql = sql & " group by z.situacion "
	' en relacion al total de sucursales
	set rs=db.execute(sql)
	if not rs.eof then
		sucursales14 = trim(rs(1))
	end if
	if sucursales14 > 0 then
		porcentaje14 = sucursales14 * 100
		porcentaje14 = porcentaje14 / totalSucursales
		porcentaje14 = round(porcentaje14)
	end if
	sql = ""
	sql = sql & " select z.situacion, COUNT(*) nro from ( "
	sql = sql & " select a.id_sucursal, a.situacion "
	sql = sql & " from SUC_desbordes a "
	sql = sql & " where a.fecha = '"&fechaActual&"' and "
	sql = sql & " a.hora = (select MAX(b.hora) "
	sql = sql & " from SUC_desbordes b "
	sql = sql & " where b.fecha = '"&fechaActual&"' and "
	sql = sql & " a.id_sucursal = b.id_sucursal)) as z "
	sql = sql & " where situacion = '1/4' "
	sql = sql & " group by z.situacion "
	' en relacion al total de sucursales
	set rs=db.execute(sql)
	if not rs.eof then
		sucursales14 = trim(rs(1))
	end if
	if sucursales14 > 0 then
		porcentaje14 = sucursales14 * 100
		porcentaje14 = porcentaje14 / totalSucursales
		porcentaje14 = round(porcentaje14)
	end if
	sql = ""
	sql = sql & " select z.situacion, COUNT(*) nro from ( "
	sql = sql & " select a.id_sucursal, a.situacion "
	sql = sql & " from SUC_desbordes a "
	sql = sql & " where a.fecha = '"&fechaActual&"' and "
	sql = sql & " a.hora = (select MAX(b.hora) "
	sql = sql & " from SUC_desbordes b "
	sql = sql & " where b.fecha = '"&fechaActual&"' and "
	sql = sql & " a.id_sucursal = b.id_sucursal)) as z "
	sql = sql & " where situacion = '1/2' "
	sql = sql & " group by z.situacion "
	' en relacion al total de sucursales
	set rs=db.execute(sql)
	if not rs.eof then
		sucursales12 = trim(rs(1))
	end if
	if sucursales12 > 0 then
		porcentaje12 = sucursales12 * 100
		porcentaje12 = porcentaje12 / totalSucursales
		porcentaje12 = round(porcentaje12)
	end if
	sql = ""
	sql = sql & " select z.situacion, COUNT(*) nro from ( "
	sql = sql & " select a.id_sucursal, a.situacion "
	sql = sql & " from SUC_desbordes a "
	sql = sql & " where a.fecha = '"&fechaActual&"' and "
	sql = sql & " a.hora = (select MAX(b.hora) "
	sql = sql & " from SUC_desbordes b "
	sql = sql & " where b.fecha = '"&fechaActual&"' and "
	sql = sql & " a.id_sucursal = b.id_sucursal)) as z "
	sql = sql & " where situacion = '3/4' "
	sql = sql & " group by z.situacion "
	' en relacion al total de sucursales
	set rs=db.execute(sql)
	if not rs.eof then
		sucursales34 = trim(rs(1))
	end if
	if sucursales34 > 0 then
		porcentaje34 = sucursales34 * 100
		porcentaje34 = porcentaje34 / totalSucursales
		porcentaje34 = round(porcentaje34)
	end if
	sql = ""
	sql = sql & " select z.situacion, COUNT(*) nro from ( "
	sql = sql & " select a.id_sucursal, a.situacion "
	sql = sql & " from SUC_desbordes a "
	sql = sql & " where a.fecha = '"&fechaActual&"' and "
	sql = sql & " a.hora = (select MAX(b.hora) "
	sql = sql & " from SUC_desbordes b "
	sql = sql & " where b.fecha = '"&fechaActual&"' and "
	sql = sql & " a.id_sucursal = b.id_sucursal)) as z "
	sql = sql & " where situacion = 'Full' "
	sql = sql & " group by z.situacion "
	' en relacion al total de sucursales
	set rs=db.execute(sql)
	if not rs.eof then
		sucursalesFull = trim(rs(1))
	end if
	if sucursalesFull > 0 then
		porcentajeFull = sucursalesFull * 100
		porcentajeFull = porcentajeFull / totalSucursales
		porcentajeFull = round(porcentajeFull)
	end if
	sql = ""
	sql = sql & " select z.situacion, COUNT(*) nro from ( "
	sql = sql & " select a.id_sucursal, a.situacion "
	sql = sql & " from SUC_desbordes a "
	sql = sql & " where a.fecha = '"&fechaActual&"' and "
	sql = sql & " a.hora = (select MAX(b.hora) "
	sql = sql & " from SUC_desbordes b "
	sql = sql & " where b.fecha = '"&fechaActual&"' and "
	sql = sql & " a.id_sucursal = b.id_sucursal)) as z "
	sql = sql & " where situacion = 'Desborde' "
	sql = sql & " group by z.situacion "
	' en relacion al total de sucursales
	set rs=db.execute(sql)
	if not rs.eof then
		sucursalesDesborde = trim(rs(1))
	end if
	if sucursalesDesborde > 0 then
		porcentajeDesborde = sucursalesDesborde * 100
		porcentajeDesborde = porcentajeDesborde / totalSucursales
		porcentajeDesborde = round(porcentajeDesborde)
	end if%>
	<div class="row-fluid">
		<div class="recargaSucursales span2 offset11">
			<span class="icon-stack icon-large mano" data-placement="right" data-original-title="Descargar archivo">
				<i class="icon-check-empty icon-stack-base"></i>
				<i class="icon-refresh"></i>
			</span>
		</div>
	</div>

	<div class="row-fluid" style="margin-top: 10px;">
		<span class="badge" style="padding: 3px; float: left; width: 22px; text-align: center;">
			<%=porcentajeNoInformada%>%
		</span>
		<div class="progress progress-danger">
			<div title="No Informa" class="bar" style="width: <%=porcentajeNoInformada%>%;">
				<strong>
					No Informa
				</strong>
			</div>
		</div>
	</div>

	<%if porcentajeNadie > 0 then%>
	<div class="row-fluid" style="margin-top: 10px;">
		<span class="badge" style="padding: 3px; float: left; width: 22px; text-align: center;">
			<%=porcentajeNadie%>%
		</span>
		<div class="progress progress-success">
			<div title="Nadie" class="bar" style="width: <%=porcentajeNadie%>%;">
				<strong>
					Nadie
				</strong>
			</div>
		</div>
	</div>
	<%end if
	if porcentaje14 > 0 then%>
	<div class="row-fluid" style="margin-top: 10px;">
		<span class="badge" style="padding: 3px; float: left; width: 22px; text-align: center;">
			<%=porcentaje14%>%
		</span>
		<div class="progress progress-success">
			<div title="1/4" class="bar" style="width: <%=porcentaje14%>%;">
				<strong>
					1/4
				</strong>
			</div>
		</div>
	</div>
	<%end if
	if porcentaje12 > 0 then%>
	<div class="row-fluid" style="margin-top: 10px;">
		<span class="badge" style="padding: 3px; float: left; width: 22px; text-align: center;">
			<%=porcentaje12%>%
		</span>
		<div class="progress progress-success">
			<div title="1/2" class="bar" style="width: <%=porcentaje12%>%;">
				<strong>
					1/2
				</strong>
			</div>
		</div>
	</div>
	<%end if
	if porcentaje34 > 0 then%>
	<div class="row-fluid" style="margin-top: 10px;">
		<span class="badge" style="padding: 3px; float: left; width: 22px; text-align: center;">
			<%=porcentaje34%>%
		</span>
		<div class="progress progress-success">
			<div title="3/4" class="bar" style="width: <%=porcentaje34%>%;">
				<strong>
					3/4
				</strong>
			</div>
		</div>
	</div>
	<%end if
	if porcentajeFull > 0 then%>
	<div class="row-fluid" style="margin-top: 10px;">
		<span class="badge" style="padding: 3px; float: left; width: 22px; text-align: center;">
			<%=porcentajeFull%>%
		</span>
		<div class="progress progress-success">
			<div title="Full" class="bar" style="width: <%=porcentajeFull%>%;">
				<strong>
					Full
				</strong>
			</div>
		</div>
	</div>
	<%end if
	if porcentajeDesborde > 0 then%>
	<div class="row-fluid" style="margin-top: 10px;">
		<span class="badge" style="padding: 3px; float: left; width: 22px; text-align: center;">
			<%=porcentajeDesborde%>%
		</span>
		<div class="progress progress-success">
			<div title="Desborde" class="bar" style="width: <%=porcentajeDesborde%>%;">
				<strong>
					Desborde
				</strong>				
			</div>
		</div>
	</div>
	<%end if
end if%>
<script type="text/javascript">
$(function(){
	//alert('xxxx')
});
$('.recargaSucursales').click(function(){
	//alert('pega')
	pagina = 'sucursales/estadoSucursalGer.asp';
	div = 'estadoSucursalesPorcentaje';
	datos='';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	return false;
})
</script>