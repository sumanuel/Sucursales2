<!--#include file="../funciones.asp"-->
<%
Session.LCID = 13322

perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
positionColumn = trim(request("positionColumn"))
idEmpresa = trim(request("idEmpresa"))
tipoVista = trim(request("tipoVista"))
fechaFormateada = ""

sql = ""
sql = sql & " EXEC SCSS_prc_cajeros_asistencia_hoy '4','"&idEmpresa&"','"&positionColumn&"' "

if tipoVista = 2 then

	fechaFormateada = trim(request("fechaFormateada"))

	sql = ""
	sql = sql & " EXEC SCSS_prc_cajeros_asistencia_hoy '4','"&idEmpresa&"','"&positionColumn&"','2','"&fechaFormateada&"' "

	'response.write(sql)
end if

'response.write(sql)
'response.end
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
  datos = rs.getrows()
  tieneDatos = 1
end if%>
<style>
    .cuerpoTabla{
        background: #f2f2f2;
    }              
    .table-hover1>tbody>tr:hover>td, 

    .table-hover1>tbody>tr:hover>th {
       background-color: #FFE49A;
       color:#0d0d0d;
    }
.table thead {
  color: #0A090A; 
  background-color: #D9E8FF; /* Color de fondo de cabecera */
}
</style>

<table id="tablaTotalAsistProveeDetalleAdicDia" class="table table-bordered table-hover1 table-condensed table-striped cuerpoTabla" data-perfilMain="<%=perfilMain%>" data-idUsuario="<%=idUsuario%>"  data-tpVista="<%=tipoVista%>" data-fecha="<%=fechaFormateada%>">
	<thead>
		<tr>
			<th>Proveedor</th>
			<th>Sucursal</th>
			<th>Rut Titular</th>
			<th>Titular</th>
			<th>Asistencia Titul</th>
			<th>Rut Reemp</th>
			<th>Nom Reemp</th>
			<th>Asistencia Reemp</th>  	   
		</tr>
	</thead>
	<tbody>
	<%if tieneDatos = 1 then
		for i = 0 to ubound(datos,2)
			proveedor = trim(datos(0,i))
			sucNombre = server.htmlencode(trim(datos(1,i)))
		   	rutTitular = trim(datos(2,i))
		   	nomTitular = server.htmlencode(trim(datos(3,i)))
		    asisTitular = trim(datos(4,i))
		    rutReemp = trim(datos(5,i))
		    nomReemp = server.htmlencode(trim(datos(6,i)))
		    asistReemp = trim(datos(7,i))
		    idSucursal = trim(datos(8,i))
			%>
			<tr class="mano" onclick="muestraDetalleAdicioMod('<%=idSucursal%>')">
				<td><%=proveedor%></td>
				<td><%=sucNombre%></td>
				<td><%=rutTitular%></td>
				<td><%=nomTitular%></td>
				<td><%=asisTitular%></td>
				<td><%=rutReemp%></td>
				<td><%=nomReemp%></td>
				<td><%=asistReemp%></td>
			</tr>
		<%next%><%else%>
	<tr>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
	</tr>
<%end if%>
	</tbody>
</table>

<script type="text/javascript">
	$('#tablaTotalAsistProveeDetalleAdicDia').dataTable( {
		"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
		"sPaginationType": "bootstrap",
		"sLoadingRecords": "Cargando...",
	});

	function muestraDetalleAdicioMod(idSucursal){ 
		var pagina, div, datos, idSucursal, periodo, tpVista, fecha;
		periodo = $(this).attr('data-periodo');
		idUsuario = $('#tablaTotalAsistProveeDetalleAdicDia').attr('data-idUsuario');
		perfilMain = $('#tablaTotalAsistProveeDetalleAdicDia').attr('data-perfilMain');
		tpVista = $('#tablaTotalAsistProveeDetalleAdicDia').attr('data-tpVista');	
		pagina = 'ctrolCajeroTablaSucursal.asp';
		div = 'ctrolCajeroTablaSucursal';
		datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&idSucursal='+idSucursal+'&tipoVista='+tpVista;
		//console.log(datos);
		enviaDatos(pagina,div,datos);
		$('#ctrolCajeroCargaTablaDetalleMod').show();
		$('#ctrolCajeroTablaSucursal').show();
		$('#ctrolCajeroTablaSucursalAsist').show();
	}
</script>

