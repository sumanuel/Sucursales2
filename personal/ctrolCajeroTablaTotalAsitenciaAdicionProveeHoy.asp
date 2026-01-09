<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
%>


<%sql = ""
sql = sql & " EXEC SCSS_prc_cajeros_asistencia_hoy '3' "
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
    .table-hover2>tbody>tr:hover>td, 

    .table-hover2>tbody>tr:hover>th {
       background-color: #FFE49A;
       color:#0d0d0d;
    }
	.table thead {
	  color: #0A090A; 
	  background-color: #D9E8FF; /* Color de fondo de cabecera */
	}
	.table-hover2-cells > tbody > tr:hover > td:hover {
	    background-color: #FFA153;
	}
</style>
<div class="text-center"><span class="label label-info" id="idSpanTitu">Cajeros Adicionales</span></div>
<div>
<table id="tablaTotalAsistenciaAdicionalProveeHoy" class="table table-bordered table-hover2 table-condensed table-striped cuerpoTabla table-hover2-cells " data-perfilMain="<%=perfilMain%>" data-idUsuario="<%=idUsuario%>" data-periodo="<%=periodo%>">
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
		    idEmpresa = trim(datos(5,i))
			
			if idEmpresa = 0 then 
				%>
				<tr>
					<th style="background-color: #e6f0ff;"></th>
					<th style="background-color: #e6f0ff;"><%=solicitados%></th>
					<th style="background-color: #e6f0ff;"><%=llegaron%></th>
					<th style="background-color: #e6f0ff;"><%=revisar%></th>
					<th style="background-color: #e6f0ff;"><%=cobertura%>%</th>
				</tr>
			<%
			else%>
				<tr>
					<th><%=proveedor%></th>
					<td class="mano" onclick="muestraDetalleAdic1(this,'<%=idEmpresa%>')"><%=solicitados%></td>
					<td class="mano" onclick="muestraDetalleAdic1(this,'<%=idEmpresa%>')"><%=llegaron%></td>
					<td class="mano" onclick="muestraDetalleAdic1(this,'<%=idEmpresa%>')"><%=revisar%></td>
					<th><%=cobertura%></th>
				</tr>
			<%end if	
			next%><%else%>
	<tr>
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

</div>


<script type="text/javascript">
	function muestraDetalleAdic1(positionColumnAdic, idEmpresa) {
		var idEmpresa = idEmpresa;	
        var positionColumn =  positionColumnAdic.cellIndex;
        $('#ctrolCajeroCargaTablaDetalle').removeClass('span6').addClass('span12');
    	var pagina, div, datos, idEmpresa, idUsuario, perfilMain;
    	idUsuario = $('#tablaTotalAsistenciaAdicionalProveeHoy').attr('data-idUsuario');
		perfilMain = $('#tablaTotalAsistenciaAdicionalProveeHoy').attr('data-perfilMain');
    	pagina = 'ctrolCajeroTablaAsistProveeDetalleAdicHoy.asp';
    	div = 'ctrolCajeroCargaTablaDetalle';
    	datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&positionColumn='+positionColumn+'&idEmpresa='+idEmpresa+'&tipoVista=1';
    	//console.log(datos)
    	enviaDatos(pagina,div,datos);

    	
		$('#ctrolCajeroCargaTablaDetalleMod').hide();
		$('#ctrolCajeroTablaSucursal').hide();
		$('#ctrolCajeroTablaSucursalAsist').hide();
	}
</script>

