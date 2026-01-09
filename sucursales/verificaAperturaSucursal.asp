<!--#include file="../funciones.asp"-->

<%fechaActual = now()'dateadd("d",1,Now())
idSucursal = trim(request("idSucursalMain"))

'response.write(fechaActual)
'response.end()


perfil = trim(request("perfilMain"))
'verifico si la sucursal esta abierta'
sql = ""
sql = sql & " set dateformat dmy "
sql = sql & " select cast(hora_ingreso as DATETIME) as hora_ingreso "
sql = sql & " from SUC_sucursal_apertura "
sql = sql & " where id_sucursal = '"&idSucursal&"' "
sql = sql & " and fecha_ingreso = cast(getdate() as DATE) "
sql = sql & " and tipo = 1 "

set rs = db.execute(sql)
if not rs.eof then
	sucursalAbierta = 1 'abierta'
else
	sucursalAbierta = 0 'cerrada'
end if
horaActual = DatePart("h",fechaActual) * 60
minutoActual = DatePart("n",fechaActual)
horaActual = horaActual + minutoActual
if sucursalAbierta = 1 then
	' verifico que no este cerrada'
	sql = ""
	sql = sql & " set dateformat dmy "
	sql = sql & " select cast(hora_ingreso as DATETIME) as hora_ingreso "
	sql = sql & " from SUC_sucursal_apertura "
	sql = sql & " where id_sucursal = '"&idSucursal&"' "
	sql = sql & " and fecha_ingreso = cast(getdate() as DATE) "
	sql = sql & " and tipo = 2 "
	set rs = db.execute(sql)
	if not rs.eof then
		sucursalCerrada = 1
	else
		sucursalCerrada = 0
	end if
	if sucursalCerrada = 1 then
		' si esta cerrada quito el boton%>
		<script type="text/javascript">
			$('#divBotonCierraSucursal').addClass('oculto');
		</script>
	<%else
		sql = ""
		sql = sql & " SELECT cast(hora_cierre as datetime) as hora_cierre "
		sql = sql & " FROM SUC_apertura_sucursal "
		set rs = db.execute(sql)
		if not rs.eof then
			horaCierre = cint(hour(rs(0))) * 60
			minutoCierre = cint(minute(rs(0)))
		end if
		horaCierre = horaCierre + minutoCierre
		horaActual = Now()
		horaHoraActual = cint(hour(horaActual)) * 60
		minutoHoraActual = cint(minute(horaActual))
		horaActual = horaHoraActual + minutoHoraActual
		minutosFaltantes = horaCierre - horaActual
		'response.write(minutosFaltantes)
		'si no esta cerrada verifico la hora y pongo el boton%>
		<script type="text/javascript">
			<%if minutosFaltantes <= 0 then %>
			    $('#divBotonCierraSucursal').removeClass('oculto').slideDown('slow');
		    <%else%>
		    	$('#divBotonCierraSucursal').addClass('oculto');
		    <%end if%>
		</script>
	<%end if%>
<%else
	' si la sucursal aun no se abre y la hora actual es 5:30%>
	<script type="text/javascript">
		$('#muestraEstadoSucursal').attr('colspan', '2').html('<span class="btn btn-success botonAbreSucursal" data-idSucursal=<%=idSucursal%>><i class="icon-signin"></i>  <strong>Abrir sucursal</strong></span><div id="abreSucursal"></div>');
		$('#estadoSucursal').remove();
		$('#divBotonCierraSucursal').addClass('oculto');
		$('.botonAbreSucursal').click(function(){
			idSucursal = $(this).attr('data-idSucursal')
			pagina = 'sucursales/abreSucursal.asp';
			div = 'abreSucursal';
			datos = '';
			try{
				enviaDatos(pagina,div,datos);
			}catch(err){}
			$('#muestraEstadoSucursal').html('<span class="badge badge-success"><i class="icon-check"></i>La apertura de sucursal fue correcta</span>');
		<%if perfil = "1" then%>
			setTimeout(function() {
				pagina = 'sucursales/miSucursal.asp';
				div = 'miSucursal';
				datos='';
				enviaDatos(pagina,div,datos);
				pagina = 'sucursales/panelSucursal.asp';
				div = 'panelSucursal';
				datos='';
				enviaDatos(pagina,div,datos);
				}, 1500);
			<%end if%>
		});
	</script>
<%end if%>