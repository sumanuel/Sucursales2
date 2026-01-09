<!--#include file="../funciones.asp"-->
<%
	perfil = trim(request("idPerfil"))
	idUsuario = trim(request("idUsuario"))
	idSucursal = trim(request("idSucursal"))
	periodo = trim(request("periodo"))

sql = ""
sql = sql & " EXEC SUC_prc_sucursal_faltant_sobrant '1','"&idSucursal&"','"&periodo&"' "
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
<table id="tablaFaltante" class="table table-bordered table-hover1 dataTable cuerpoTabla stripe" data-perfil="<%=perfil%>" data-idUsuario="<%=idUsuario%>" data-idSucursal="<%=idSucursal%>" data-periodo="<%=periodo%>">
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
		  	idFaltanteModEstado = trim(datos(13,i))
		  	idEstadoFaltante = trim(datos(14,i))
			%>
			<tr class="mano" onclick="muestraTablaModFaltante('<%=idFaltanteModEstado%>','<%=nomCajero%>','<%=idEstadoFaltante%>')" id="trFuncionTabla">
				<td><%=fecha%></td>
				<td><%=nomCajero%></td>
				<td><%=cuentaCajero%></td>
				<td><%=valor%></td>
				<td><%=tipo%></td>
				<%if idEstadoFaltante = 1 then%>
					<td><%=estado%></td>
				<%else%>
					<td style="background: #A9EAFF;"><%=estado%></td>
				<%end if%>
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
<br>

<div class="row-fluid oculto" id="cajeroTablaModEstadoFaltante">
	<div class="span6" id="cargaCajeroTablaModEstadoFaltante"></div>
</div>
<script type="text/javascript">
$(function(){
	$('#tablaFaltante').dataTable( {
		"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
		"sPaginationType": "bootstrap",
		"sLoadingRecords": "Cargando...",
	});
});
function muestraTablaModFaltante(idFaltanteModEstado, nomCajero, idEstadoFaltante){
	if (idEstadoFaltante === "1"){
		$('#trFuncionTabla').addClass('mano');
		$('#cargaCajeroTablaSobrante').slideUp('fast');
		$('#cajeroTablaModEstadoFaltante').slideDown('fast');
		var pagina, div, datos, periodo, idSucursal, idUsuario, perfil;
		idSucursal = $('#tablaFaltante').attr('data-idSucursal');
		idUsuario = $('#tablaFaltante').attr('data-idUsuario');
		idPerfil = $('#tablaFaltante').attr('data-perfil');
		periodo = $('#tablaFaltante').attr('data-periodo');
		pagina = 'sucursales/cajeroModicaEstadoFaltSobrante.asp';
		div = 'cargaCajeroTablaModEstadoFaltante';
		datos='periodo='+periodo+'&idUsuario='+idUsuario+'&idPerfil='+idPerfil+'&idSucursal='+idSucursal+'&idFaltanteModEstado='+idFaltanteModEstado+'&nomCajero='+nomCajero;
		enviaDatos(pagina,div,datos);
		console.log("entra")
	}else{
		$('#trFuncionTabla').removeClass('mano');
	}


}
</script>