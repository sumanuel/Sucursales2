<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
periodo = trim(request("periodo"))

%>


<%sql = ""
sql = sql & " EXEC SCSS_prc_cajeros_total_asistencia_por_proveedor '"&periodo&"','1' "
'response.write(sql)
'response.end
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
  datos = rs.getrows()
  tieneDatos = 1
end if%>
<style type="text/css"> 
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

<div class="text-center">
	<span class="label label-info" id="idSpanTitu">Cajeros Titulares</span>
</div>	
<div>
<table id="tablaTotalAsistenciaProveedoPeriodo" class="table table-bordered table-hover1 table-condensed table-striped cuerpoTabla" data-perfilMain="<%=perfilMain%>" data-idUsuario="<%=idUsuario%>" data-periodo="<%=periodo%>">
	<thead>
		<tr>
			<th>Proveedor</th>
			<th>Solicitados</th>
			<th>Llegaron</th>
			<th>Revisar</th>
			<th>Cobertura</th>   
		</tr>
	</thead>
	<tbody>
		<%if tieneDatos = 1 then
			for i = 0 to ubound(datos,2)
				proveedor = trim(datos(0,i))
			   	solicitados = trim(datos(1,i))
			   	llegaron = trim(datos(2,i))  
			    revisar = trim(datos(3,i))
			    cobertura = trim(datos(4,i))
			    periodo = trim(datos(5,i))
			    idProveedor = trim(datos(6,i))
				if idProveedor = 0 then 
				%>
				<tr>
					<th style="background-color: #e6f0ff;"></th>
					<th style="background-color: #e6f0ff;"><%=solicitados%></th>
					<th style="background-color: #e6f0ff;"><%=llegaron%></th>
					<th style="background-color: #e6f0ff;"><%=revisar%></th>
					<th style="background-color: #e6f0ff;"><%=cobertura%></th>
				</tr>
			<%
			else%>
				<tr class="muestraDetalleAsistenProveed mano" data-idProveedor="<%=idProveedor%>" data-periodo="<%=periodo%>">
					<td><%=proveedor%></td>
					<td><%=solicitados%></td>
					<td><%=llegaron%></td>
					<td><%=revisar%></td>
					<td><%=cobertura%></td>
				</tr>
			<%end if	
		next%>
		<%else%>
			<tr>>
				<td>---</td>
				<td>---</td>
				<td>---</td>
				<td>---</td>
				<td>---</td>
			</tr>
		<%end if%>
	</tbody>
</table>
</div>
<div class="row-fluid"><br></div>
<div class="row-fluid"></div>
<script type="text/javascript">
	$('.muestraDetalleAsistenProveed').click(function() {
		$('#ctrolCajeroCargaGrafico').html('');
		$('#ctrolCajeroCargaTablaDetalle').removeClass('span9').addClass('span6');
		var pagina, div, datos, idProveedor, periodo;
		idProveedor = $(this).attr('data-idProveedor');
		periodo = $(this).attr('data-periodo');
		idUsuario = $('#tablaTotalAsistenciaProveedoPeriodo').attr('data-idUsuario');
		perfilMain = $('#tablaTotalAsistenciaProveedoPeriodo').attr('data-perfilMain');
			
		pagina = 'ctrolCajeroTablaAsistProveeDetallePeriodo.asp';
		div = 'ctrolCajeroCargaTablaDetalle';
		datos='periodo='+periodo+'&idUsuario='+idUsuario+'&perfilMain='+perfilMain;
		//console.log(datos);
		enviaDatos(pagina,div,datos);
		

		$('#ctrolCajeroPeriodoDetalle').hide();		
		$('#ctrolCajeroCargaTablaDetalleMod').hide();
		$('#ctrolCajeroTablaSucursal').hide();
		$('#ctrolCajeroTablaSucursalAsist').hide();

	});
</script>

