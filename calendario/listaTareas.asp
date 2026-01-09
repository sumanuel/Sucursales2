<!--#include file="../funciones.asp"-->
<%perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
fecha = trim(request("fecha"))
fechaAnio = left(fecha,4)
fechaMes = right(left(fecha,6),2)%>
<div id="volverListaTarea" class="pull-right alert alert-error mano" data-anio="<%=fechaAnio%>" data-mes="<%=fechaMes%>">
	<div class="close" data-dismiss="alert">
		<i class="icon-reply"></i>
	</div>
	Volver
</div>
<div id="cargaTarea" class="oculto"></div>
<div id="tablaTareas">
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th>Tipo</th>
				<th>Sucursal</th>
				<th>Hora</th>
				<!--<td>Usuario</td>-->
				<th>Acción</th>
			</tr>
		</thead>
		<tbody>
	<%sql = ""
	sql = sql& " select c.item_tipo, "
	sql = sql& " d.suc_nombre, "
	sql = sql& " cast(item_hora as datetime) as itemhora, "
	sql = sql& " e.usuario_nombre, "
	sql = sql& " a.id_cal,b.id_calitem,"
	sql = sql& "  f.visita_motivo "
	sql = sql& " from SUC_calendario a "
    sql = sql& " inner join SUC_calendario_item b on a.id_cal = b.id_cal "
	sql = sql& " inner join SUC_calendario_item_tipo c on b.id_calitipo = c.id_calitipo "
    sql = sql& " inner join SUC_sucursal d on b.id_suc = d.id_sucursal "
    sql = sql& " inner join SUC_usuario e on b.id_usuario = e.id_usuario " 
    sql = sql& " inner join SUC_sucursal_visita f on b.id_op = f.id_sucvis "
	sql = sql& " where a.fecha = cast('"&fecha&"' as DATE) "
	if perfil = "1" or perfil = "2" then
		sql = sql& " and b.id_suc in (select id_sucursal from SUC_usuario_sucursal where id_usuario='"&idUsuario&"')"
		if perfil = "1" then
			sql = sql & " and f.visita_motivo <> '3' "
		end if
	end if
	set rs = db.execute(sql)
	datos = rs.GetRows()
	For i = 0 to ubound(datos, 2)
		nombreTarea = trim(datos(0,i))
		nombreSucursal = server.htmlencode(trim(datos(1,i)))
		horaTarea = trim(datos(2,i))
		horaHoraTarea = hour(horaTarea)
		if len(horaHoraTarea) = 1 then
			horaHoraTarea = "0"&horaHoraTarea
		end if
		minutoHoraTarea = minute(horaTarea)
		if len(minutoHoraTarea) = 1 then
			minutoHoraTarea = "0"&minutoHoraTarea
		end if
		horaTarea2 = horaHoraTarea&":"&minutoHoraTarea
		usuarioTarea = trim(datos(3,i))
		idTarea = trim(datos(4,i))
		idCalitem = trim(datos(5,i))%>
		<tr>
			<td><%=nombreTarea%></td>
			<td><%=nombreSucursal%></td>
			<td><%=horaTarea2%></td>
			<td>
				<span class="btn btn-info masInfoAccion" data-id="<%=idTarea%>" data-tipo="1" data-fecha="<%=fecha%>" data-idCalItem="<%=idCalitem%>">
					Ver
				</span>
			</td>
		</tr>
	<%next%>

		</tbody>
	</table>
</div>
<script type="text/javascript">
var datos,pagina,div
$(function(){
	var perfil = $('#perfil').val();
});
$('.masInfoAccion').click(function(){
	var idTarea = $(this).attr('data-id');
	var idCalItem = $(this).attr('data-idCalItem')
	var idtipoTarea = $(this).attr('data-tipo');
	var fecha= $(this).attr('data-fecha');
	datos = 'idTarea='+idTarea+'&fecha='+fecha+'&idCalItem='+idCalItem;
	if (idtipoTarea = "1")
	{
		pagina = 'visitas/muestraVisita.asp';
	}
	div = 'cargaTarea';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
	$('#tablaTareas').slideUp('fast');
	$('#volverListaTarea').slideUp('fast');
});
$('#volverListaTarea').click(function(){
	var fecha = '';
	var datoFecha = 'fecha='+fecha;
	pagina = 'calendario/calendario.asp';
	if (perfil=='1')
	{
		div = 'area';
	}
	if(perfil=='2')
	{
		div = 'areaZonal';
	}
	if (perfil =='3')
	{
		div = 'areaTrabajoGerencia';
	}
	try{
		enviaDatos(pagina,div,datoFecha);
	}catch(err){}
	return false;
});
</script>