<!--#include file="../funciones.asp"-->
<%
	perfil = trim(request("idPerfil"))
	idUsuario = trim(request("idUsuario"))
	idSucursal = trim(request("idSucursal"))
	periodo = trim(request("periodo"))

sql = ""
sql = sql & " EXEC SUC_prc_sucursal_faltant_sobrant '2','"&idSucursal&"','"&periodo&"' "
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
	.table-hover1>tbody>tr:hover>td, .table-hover1>tbody>tr:hover>th {
  		background-color: #d9ffb3;
  		color:#0d0d0d;
	}
	.text-wrap{
    white-space:normal;
	}
	.width-200{
	    width:150px;
	}	    
</style>
<br>
<div class="text-center">
	<span class="label label-info" id="idSpanTitu">Sobrantes</span>
</div>	
<table id="tablaSobrante" class="table table-bordered table-hover1 dataTable cuerpoTabla stripe row-border order-column">
	<thead style="background-color: #e6e6ff">
		<tr>
			<th>Fecha Faltante</th>
			<th>Nombre Cajero</th>
			<th>Cuenta</th>
			<th>Valor</th>
			<th>Tipo</th>
			<th>Estado</th>
			<th>Caja</th>
		</tr>
	</thead>
	<tbody>
	<%if tieneDatos = 1 then
		for i = 0 to ubound(datos,2)
			nomCajero = trim(datos(0,i))
			cuentaCajero = trim(datos(1,i))
		  	valor = trim(datos(2,i))
		  	tipo = trim(datos(3,i))
		  	fecha = trim(datos(4,i))
		  	estado = trim(datos(5,i))
		  	caja = trim(datos(6,i))
		  	rutCajero = trim(datos(10,i))
		  	fechaFaltante =  trim(datos(11,i))
			%>
			<tr class="mano" onclick="muestraTablaModSobrante('<%=cuenta%>')">
				<td><%=fecha%></td>
				<td><%=nomCajero%></td>
				<td><%=cuentaCajero%></td>
				<td><%=valor%></td>
				<td><%=tipo%></td>
				<td><%=estado%></td>
				<td><%=caja%></td>	
			</tr>
		<%next
		else%>
	<tr>
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

$('#tablaSobrante').dataTable( {
	"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
	"sPaginationType": "bootstrap",
	"sLoadingRecords": "Cargando...",
});

function muestraTablaModSobrante(cuenta){
	cuenta = cuenta;
	console.log(cuenta);
}
</script>