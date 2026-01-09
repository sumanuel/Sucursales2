<!--#include file="../funciones.asp"-->
<%tipoActivo = trim(request("tipoActivo"))
idSucursalMain = trim(request("idSucursalMain"))

'response.write(idSucursalMain)
'response.end

if tipoActivo = "1" or tipoActivo = "2" then
	sql = ""
	sql = sql & " select c.nombre_activo_tipo, "
	sql = sql & " b.nombre_activo_marca, "
	sql = sql & " d.nombre_cargo, "
	sql = sql & " a.serie, "
	sql = sql & " a.rotulo, "
	sql = sql & " a.nombre_usuario, "
	sql = sql & " a.correo, "
	sql = sql & " a.id_tipo_activo_ingreso, "
	sql = sql & " a.cantidad, "
	sql = sql & " a.id_activo "
	sql = sql & " from SUC_activo a, "
	sql = sql & " SUC_activo_marca b, "
	sql = sql & " SUC_activo_tipo c, "
	sql = sql & " SUC_activo_cargo d "
	sql = sql & " where a.id_activo_marca = b.id_activo_marca "
	sql = sql & " and b.id_activo_tipo = c.id_activo_tipo "
	sql = sql & " and a.id_cargo = d.id_cargo "
	sql = sql & " and a.id_tipo_activo_ingreso in (1,2) "
	sql = sql & " and a.id_sucursal = '"&idSucursalMain&"' "
end if


if tipoActivo = "3" then
	sql = ""
	sql = sql & " select c.nombre_activo_tipo, "
	sql = sql & " b.nombre_activo_marca, "
	sql = sql & " d.nombre_cargo, "
	sql = sql & " a.serie, "
	sql = sql & " a.rotulo, "
	sql = sql & " a.nombre_usuario, "
	sql = sql & " a.correo, "
	sql = sql & " a.id_tipo_activo_ingreso, "
	sql = sql & " a.cantidad, "
	sql = sql & " a.id_activo_otros "
	sql = sql & " from SUC_activo_otros a, "
	sql = sql & " SUC_activo_marca b, "
	sql = sql & " SUC_activo_tipo c, "
	sql = sql & " SUC_activo_cargo d "
	sql = sql & " where a.id_activo_marca = b.id_activo_marca "
	sql = sql & " and b.id_activo_tipo = c.id_activo_tipo "
	sql = sql & " and a.id_cargo = d.id_cargo "
	sql = sql & " and a.id_sucursal = '"&idSucursalMain&"' "

'response.write(sql)	

end if
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()%>
	<div class="row-fluid">
		<div class="span12">
			<table class="table table-bordered table-hover" id="tablaActivos">
				<thead>
					<tr>
						<th>Activo</th>
						<th>Marca</th>
						<th>Cargo</th>
						<th>Serie</th>
						<th>Rotulo LH</th>
						<th>Usuario</th>
						<th>Correo</th>
						<%if tipoActivo <> "3" then%>
							<th>Tipo</th>
						<%end if%>
						<th>Cantidad</th>
						<th>Eliminar</th>
					</tr>
				</thead>
				<tbody>
					<%for i=0 to ubound(datos,2)%>
						<tr id="<%=trim(datos(9,i))&"-"&tipoActivo%>">
							<td>
								<%=server.htmlencode(trim(datos(0,i)))%>
							</td>
							<td>
								<%=server.htmlencode(trim(datos(1,i)))%>
							</td>
							<td>
								<%=server.htmlencode(trim(datos(2,i)))%>
							</td>
							<td>
								<%=server.htmlencode(trim(datos(3,i)))%>
							</td>
							<td>
								<%=server.htmlencode(trim(datos(4,i)))%>
							</td>
							<td>
								<%=server.htmlencode(trim(datos(5,i)))%>
							</td>
							<td>
								<%=server.htmlencode(trim(datos(6,i)))%>
							</td>
							<%if tipoActivo <> "3" then%>
								<td>
									<%if trim(datos(7,i)) = "1" then%>
										Entel
									<%end if
									if trim(datos(7,i)) = "2" then%>
										Los Heroes
									<%end if%>
								</td>
							<%end if%>
							<td>
								<%=trim(datos(8,i))%>
							</td>
							<td>
								<span class="btn btn-mini btn-danger btnEliminar" data-tipoActivo="<%=tipoActivo%>" data-idActivo="<%=trim(datos(9,i))%>" onclick="elimnaRegistro('<%=trim(datos(9,i))%>','<%=tipoActivo%>');" id="boton<%=trim(datos(9,i))%>">
									Eliminar
								</span>
								<div id="eliminaDato<%=trim(datos(9,i))%>"></div>
								<div id="elimina<%=trim(datos(9,i))%>"></div>
							</td>
						</tr>
					<%next%>
				</tbody>
			</table>
		</div>
	</div>
<%end if%>

<link href="css/tablaSort.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="js/jquery.dataTables.js"></script>
	<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>
	<script type="text/javascript">
	$(function(){
		$('#tablaActivos').dataTable( {
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
		    "sSearch":         "Buscar:",
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

		});
	});
	/*$('.btnEliminar').click(function(){
		var idActivo= $(this).attr('data-idActivo');
		var tipo = $(this).attr('data-tipoActivo');
		$(this).html('Eliminando <img src="img/loader.gif"/>').removeClass('btn btn-mini btn-danger');
		var pagina, div, datos
		pagina = 'activos/eliminaActivo.asp';
		div = 'elimina'+idActivo;
		datos = 'idActivo='+idActivo+'&tipo='+tipo
		try{
			enviaDatos(pagina,div,datos);
		}catch(err){}
		
		setTimeout(function() {
			$(this).html('Eliminado');
		}, 1000);
		setTimeout(function() {
			$('#'+idActivo).slideUp('fast');
		}, 2000);
		

	});*/
	function elimnaRegistro(idActivo,tipo)
	{
		$('#eliminaDato'+idActivo).html('Eliminando <img src="img/loader.gif"/>');
		$('#boton'+idActivo).slideUp('fast');
		var pagina, div, datos
		pagina = 'activos/eliminaActivo.asp';
		div = 'elimina'+idActivo;
		datos = 'idActivo='+idActivo+'&tipo='+tipo
		try{
			enviaDatos(pagina,div,datos);
		}catch(err){}
		
		setTimeout(function() {
			$('#eliminaDato'+idActivo).html('Eliminado');
		}, 1000);
		setTimeout(function() {
			$('tr#'+idActivo+'-'+tipo).remove();
		}, 2000);
	}
</script>