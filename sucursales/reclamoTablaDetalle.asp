<!--#include file="../funciones.asp"-->
<% 'LISTA DE CASOS INGRESADOS POR SUCURSAL' 
	idSucursal = request("idSucursal")
	'idSucursal = "1"
%>
	<link href="css/tablaSort.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="js/jquery.dataTables.js"></script>
	<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>
<%

	sql = ""
	sql = sql & "select A.id_caso, "
	sql = sql & "A.caso_titulo, "
	sql = sql & "A.caso_obs, "
	sql = sql & "B.caso_categoria, "
	sql = sql & "C.caso_motivo, "
	sql = sql & "isnull(A.caso_creado_por,0) as caso_creado_por, "	
	sql = sql & "convert(varchar(10), isnull(A.caso_fecha_cre, getdate()), 120) as caso_fecha_cre, "
	sql = sql & "convert(varchar(8), isnull(A.caso_hora_cre, getdate()), 108) as caso_hora_cre, "
	sql = sql & "convert(varchar(10), isnull(A.caso_fecha_mod, getdate()), 120) as caso_fecha_mod, "
	sql = sql & "convert(varchar(8), isnull(A.caso_hora_mod, getdate()), 108) as caso_hora_mod, "
	sql = sql & "D.caso_paso_macro "
	sql = sql & "from SUC_casos A "
	sql = sql & "inner join SUC_casos_config_categoria B "
	sql = sql & "on A.caso_categoria = B.id_caso_categoria "
	sql = sql & "inner join SUC_casos_config_motivo C "
	sql = sql & "on A.caso_motivo = C.id_caso_motivo "
	sql = sql & "inner join SUC_casos_pasos_macro D "
	sql = sql & "on A.id_caso_paso = D.id_caso_paso_macro "
	sql = sql & "where A.caso_id_sucursal = " & idSucursal & " "
	sql = sql & "order by A.id_caso desc "

	'response.write(sql)
	'response.end()

	set rs1 = db.execute(sql)
	if not rs1.eof then
%>
	<div class="row-fluid">
	<table class="table table-bordered table-condensed" id="tablacasos">
		<thead>
			<tr>
				<th id="filtroEstadoReclamo" colspan="8"></th>
			</tr>
			<tr>
				<th>N CASO</th>
				<th>TITULO</th>
				<th>CATEGORIA</th>
				<th>MOTIVO</th>
				<th>FECHA CREACION</th>
				<th>FECHA MODIFICACION</th>
				<th>ESTADO</th>
				<th>--</th>
			</tr>
		</thead>
		<tbody>
		<% do while not rs1.eof 
			caso_id = trim(rs1("id_caso"))
			caso_titulo = server.htmlencode(trim(rs1("caso_titulo")))
			caso_obs = server.htmlencode(trim(rs1("caso_obs")))
			caso_categoria = server.htmlencode(trim(rs1("caso_categoria")))
			caso_motivo = server.htmlencode(trim(rs1("caso_motivo")))
			caso_creado_por = server.htmlencode(trim(rs1("caso_creado_por")))
			caso_fecha_cre = server.htmlencode(trim(rs1("caso_fecha_cre")))
			caso_hora_cre = server.htmlencode(trim(rs1("caso_hora_cre")))
			caso_fecha_mod = server.htmlencode(trim(rs1("caso_fecha_mod")))
			caso_hora_mod = server.htmlencode(trim(rs1("caso_hora_mod")))
			caso_paso_macro = server.htmlencode(trim(rs1("caso_paso_macro")))
		%>
			<tr>
				<td><%=caso_id%></td>
				<td><%=caso_titulo%></td>
				<td><%=caso_categoria%></td>
				<td><%=caso_motivo%></td>
				<td><%=caso_fecha_cre%></td>
				<td><%=caso_fecha_mod%></td>
				<td><%=caso_paso_macro%></td>
				<td><i class="icon-folder-open icon-large mano casoTraking" data-idCaso="<%=caso_id%>"></i></td>				
			</tr>
		<%rs1.MoveNext
  		loop
  			rs1.Close
  			set rs1.ActiveConnection = nothing
  			set rs1=nothing
  		%>	
		</tbody>
	</table>
</div>
	<script type="text/javascript">
	$(document).ready(function(){
		$('.casoTraking').click(function(){	
			var idSucursal = $('#idSucursalMain').val();		    
		    var idCaso = $(this).attr('data-idCaso');
		    //alert('idCaso: '+ idCaso);
		    $('.verCasos').html('<i class="icon-remove-sign"></i> <span style="font-size: 10px"><strong>CERRAR DETALLE CASO</strong></span>');

		    var pagina = 'sucursales/reclamoDetalle.asp';
			div = 'divAreaTrabajoReclamo';
		    var datos = 'idSucursal='+idSucursal+'&idCaso='+idCaso;
			enviaDatos(pagina,div,datos); 
		 });
//,"searching": false,
		 $('#tablacasos').dataTable( {
				"iDisplayLength": 13,
				"pageLength": 10,//"lengthChange": false,
				"aaSorting": [[0, 'desc']],
				"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {
				"sLengthMenu": "_MENU_ registros por página",
				"sProcessing":     "Procesando...",
				"sZeroRecords":    "No se encontraron resultados",
				"sEmptyTable":     "Ningún dato disponible en esta tabla",
				"sInfo":           "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
				"sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
				"sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
				"sInfoPostFix":    "",
				"sUrl":            "",
				"sInfoThousands":  ",",
				"sLoadingRecords": "Cargando...",
				"oPaginate": {
				"sFirst":    "Primero",
				"sLast":     "Último",
				"sNext":     "Siguiente",
				"sPrevious": "Anterior"
				},
				"oAria": {
					"sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
					"sSortDescending": ": Activar para ordenar la columna de manera descendente"
					}
				},
				

				initComplete: function () {
                var div=$('#tablacasos_wrapper');
    			div.find("#filtroEstadoReclamo").prepend("Filtro Estado:<select id='idEstadoReclamo' name='idEstadoReclamo' class='form-control' required style= 'width : 250px;'><option value=''>Todos</option></select>");


    			this.api().column(6).each(function () {
	                var column = this;
	                var select = $('#idEstadoReclamo')
	                //console.log(column.data());

	                column.data().unique().sort().each(function (d, j) {
                    	select.append('<option value="' + d + '">' + d + '</option>')
                	});

	                $('#idEstadoReclamo').on('change',function(){
	                var val=$(this).val();
	                column.search( val ? '^'+val+'$' : '', true, false )
	                            .draw();
                	});
	               
            	});
        }
			});
		});
	</script>
<% 	end if%>