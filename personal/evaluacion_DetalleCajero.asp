
<!--#include file="../funciones.asp"-->
<%
rut = trim(request("rut"))
periodo = trim(request("periodo"))
sucursal = trim(request("sucursal"))

sql = "exec SUC_prc_eva_get_detalle_cajero "&periodo&","&rut&","&sucursal

'response.write(sql)
'response.end()

set rs = db.execute(sql)
%>
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
 	.th, .td { white-space: nowrap; }
    dataTables_wrapper {
        margin: 0 auto;
    }
    
</style>
<table id="tabladetallecajero" class="table table-bordered table-hover1 no-footer dataTable cuerpoTabla stripe row-border order-column" >
	<thead style="background-color: #e6e6ff">
		<th >Rut</th>
		<th >Nombre Cajero</th>
		<th >Fecha</th>
		<th >Cantidad Trx</th>
		<th >Total Pagos Suc</th>
		<th >Cantidad Cajeros</th>
		<th >Promedio Pagos Suc</th>
		<th >Cantidad Reclamos</th>
		<th >Cantidad Atrasos</th>
		<th >Cantidad Faltantes</th>
	</thead>
	<tbody >
		<% if not rs.eof then	
			do while not rs.eof 	
				rut = rs("rut")
				nombre_cajero = rs("nombre_cajero") 
				fecha_registro = rs("fecha_registro") 
				cantidad_pagos = rs("cantidad_pagos") 
				totalpagosxdia = rs("totalpagosxdia")
				cantidadtrabajadores = rs("cantidadtrabajadores")
				promediosucursalxdia = rs("promediosucursalxdia")
				cantreclamos = rs("cantreclamos")
				cantatrasos = rs("cantatrasos")
				cantfaltantes = rs("cantfaltantes")				
				%>
				<tr>												
					<td ><%=rut%></td>
					<td ><%=nombre_cajero%></td>
					<td ><%=fecha_registro%></td>
					<td ><%=cantidad_pagos%></td>
					<td ><%=totalpagosxdia%></td>
					<td ><%=cantidadtrabajadores%></td>
					<td ><%=promediosucursalxdia%></td>
					<td ><%=cantreclamos%></td>
					<td ><%=cantatrasos%></td>
					<td ><%=cantfaltantes%></td>
				</tr>
				<%
				rs.MoveNext
				loop
		   else
				%>
				<tr>												
					<td >Sin Datos</td>
					<td >Sin Datos</td>
					<td >Sin Datos</td>
					<td >Sin Datos</td>
					<td >Sin Datos</td>
					<td >Sin Datos</td>
					<td >Sin Datos</td>
					<td >Sin Datos</td>
					<td >Sin Datos</td>
					<td >Sin Datos</td>
				</tr>
				<%
		   end if
		%>
	</tbody>
</table>
</br>
<input id='volver' class='btn btn-info' type='button' value='Volver'>
<script type="text/javascript">	


	$(document).ready(function(){
		$('#tabladetallecajero').DataTable( {
			"language": {
	            "lengthMenu": "Mostrando _MENU_ reg. por página",
	            "zeroRecords": "Sin datos encontrados",
	            "info": "Mostrando página _PAGE_ de _PAGES_",
	            "infoEmpty": "Sin registros disponibles",
	            "infoFiltered": "(filtrado desde _MAX_ total de registros)"
        	 	},
	 		PaginationType: "bootstrap",
	 		scrollX:        true,
	 		//scrollY:        "400px",
	        scrollCollapse: true,
	        paging:         true,	      
	        initComplete: function () {
	    			$('#tabladetallecajero_length').removeClass('tabladetallecajero_length');

	    			$('[data-toggle="popover"]').popover({
				    	 html:true
				    }); 
	    		}
	    } );
	});	

	$('#volver').click(function(){
		$('#DetalleCajero').hide();
		$('#tabladetalleEva').show();
	});

</script>