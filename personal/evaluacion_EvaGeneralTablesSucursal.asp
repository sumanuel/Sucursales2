
<!--#include file="../funciones.asp"-->
<%
periodo = trim(request("periodo"))
zonal = trim(request("zonal"))

sql = "exec SUC_prc_eva_get_sucursal "&periodo&",'"&zonal&"'"

'response.write(sql)
'response.end()

set rs = db.execute(sql)
%>
<style>		
	.table-hover1>tbody>tr:hover>td, .table-hover1>tbody>tr:hover>th {
  		background-color: #d9ffb3;
  		color:#0d0d0d;
	}

</style>
<table id="tablasucursales" class="table table-bordered table-hover1 table-condensed" data-periodo="<%=periodo%>" style="border-bottom: 2px solid">
	<thead style="background-color: #e6f2ff; ">
		<th style="border-bottom: 1px solid; border-top: 2px solid; border-left: 2px solid;">Nombre</th>
		<th style="border-bottom: 1px solid; border-top: 2px solid; border-left: 1px solid;">Buenos</th>
		<th style="border-bottom: 1px solid; border-top: 2px solid; border-left: 1px solid;">Normal</th>
		<th style="border-bottom: 1px solid; border-top: 2px solid; border-left: 1px solid;">Malos</th>
		<th style="border-bottom: 1px solid; border-top: 2px solid; border-left: 1px solid;border-right: 2px solid;">Prom</th>
	</thead>
	<tbody >
		<% if not rs.eof then		
			do while not rs.eof 	
				nombre = server.htmlencode(trim(rs("NOMBRE")))
				cod_btt = rs("COD_BTT") 
				buenos = rs("BUENO") 
				regular = rs("NORMAL") 
				malos = rs("MALO")
				prom = rs("PROM")
				%>
				<tr class="mano" onclick="cambiapantsucursal('<%=cod_btt%>')">												
					<td style="border-left: 2px solid;"><%=nombre%></td>
					<td style="border-left: 1px solid;" ><%=buenos%></td>
					<td style="border-left: 1px solid;" ><%=regular%></td>
					<td style="border-left: 1px solid;" ><%=malos%></td>
					<td style="border-right: 2px solid;border-left: 1px solid;" ><%=prom%></td>
				</tr>
				<%
				rs.MoveNext
				loop
		   end if
		%>
	</tbody>
</table>
<script type="text/javascript">

	function cambiapantsucursal(sucursal){

		var periodo= $('#tablasucursales').attr('data-periodo');
		var div = 'evaluacionCuerpoTrabajo';
	    var datos = 'periodo='+periodo+'&sucursal='+sucursal
	    var pagina = 'evaluacion_DetalleEvaluacion.asp';    
	    enviaDatos(pagina,div,datos);

		$('ul#menuevaluacion > li').each(function(){
			$(this).removeClass('active');
		});
		$('li#liEvaluacionDetalle').addClass('active');
	};


</script>
