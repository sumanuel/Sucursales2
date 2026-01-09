<!--#include file="../funciones.asp"-->
<%
	periodo = trim(request("periodo"))

sql = ""
sql = sql & " EXEC SUC_prc_sucursal_faltant_sobrant '3','0','"&periodo&"' "
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
<div class="text-center">
	<span class="label label-info" id="idSpanTitu">Faltantes</span>
</div>	
<table id="tablaFaltanteCajero" class="table table-bordered table-hover1 dataTable cuerpoTabla stripe" data-perfil="<%=perfil%>" data-idUsuario="<%=idUsuario%>" data-idSucursal="<%=idSucursal%>" data-periodo="<%=periodo%>">
	<thead style="background-color: #e6e6ff">
		<tr>
			<th>Fecha Faltante</th>
			<th>Nombre Cajero</th>
			<th>Cuenta</th>
			<th>Valor</th>
			<th>Tipo</th>
			<th>Estado</th>
			<th>Caja</th>
			<th>Valija</th>
			<th>Fecha Creacion</th>
			<th>Fecha Mod</th>
			<th>SLA</th>
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
		  	idFaltanteModEstado = trim(datos(13,i))
		  	valija = trim(datos(14,i))
		  	sla = trim(datos(15,i))
		  	fechaCreacacion = trim(datos(16,i))
		  	fechaMod = trim(datos(17,i))
		  	idEstadoFalt = trim(datos(18,i))
			%>
			<tr class="mano" onclick="muestraTablaModFaltanteEstado('<%=idFaltanteModEstado%>','<%=nomCajero%>','<%=estado%>','<%=valija%>')">
				<td><%=fecha%></td>
				<td><%=nomCajero%></td>
				<td><%=cuentaCajero%></td>
				<td><%=valor%></td>
				<td><%=tipo%></td>
				<%if idEstadoFalt = 1 then%>
					<td><%=estado%></td>
				<%else%>
					<td style="background: #A9EAFF;"><%=estado%></td>
				<%end if%>
				<td><%=caja%></td>
				<td><%=valija%></td>
				<td><%=fechaCreacacion%></td>
				<td><%=fechaMod%></td>
				<%if sla = "0" then%>
					<td><%=sla%></td>
				<%else%>
					<td style="background: #FF7B91;"><%=sla%></td>
				<%end if%>
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
		<td>---</td>
		<td>---</td>
		<td>---</td>
		<td>---</td>
	</tr>
<%end if%>
	</tbody>
</table>
<br>
<div class="row-fluid oculto" id="cajeroTablaModEstadoFaltanteEstado">
	<div class="span6" id="cargaCajeroTablaModEstadoFaltanteEstado"></div>
</div>
<script type="text/javascript">
$(function(){
	$('#tablaFaltanteCajero').dataTable( {
		"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
		"sPaginationType": "bootstrap",
		"sLoadingRecords": "Cargando...",
	});
});
function muestraTablaModFaltanteEstado(idFaltanteModEstado, nomCajero, estado, valija){
	$('#faltanteCargaTabla, #detalleEstadoFaltanteTabla').slideDown('fast');
	var pagina, div, datos, periodo, idSucursal, idUsuario, perfil;
	idSucursal = $('#tablaFaltanteCajero').attr('data-idSucursal');
	idUsuario = $('#tablaFaltanteCajero').attr('data-idUsuario');
	idPerfil = $('#tablaFaltanteCajero').attr('data-perfil');
	periodo = $('#tablaFaltanteCajero').attr('data-periodo');
	pagina = 'faltanteTablaModEstado.asp';
	div = 'faltanteCargaTabla';
	datos='periodo='+periodo+'&idUsuario='+idUsuario+'&idPerfil='+idPerfil+'&idFaltanteModEstado='+idFaltanteModEstado+'&nomCajero='+nomCajero+'&valija='+valija;
	enviaDatos(pagina,div,datos);

	pagina = 'faltanteTablaDetalleModEstado.asp';
	div = 'detalleEstadoFaltanteTabla';
	datos='idFaltanteModEstado='+idFaltanteModEstado;
	console.log(datos)
	enviaDatos(pagina,div,datos);
}
</script>