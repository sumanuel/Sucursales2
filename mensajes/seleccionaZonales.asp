<!--#include file="../funciones.asp"-->
<%clickZonal = trim(request("clickZonal"))%>
<div class="row-fluid">
	<div class="span12">
		<span>
			<strong>
				Seleccione Zonal:
			</strong>
		</span>
<%sql = ""
sql = sql & "select id_zona, id_zonal, grupo, zonal from SUC_zonales where estado_zonal = 1 "
set rs = db.execute(sql)
if not rs.eof then
	do while not rs.eof
		nombreZonal = server.htmlencode(trim(rs("zonal")))
		idZonal = trim(rs("id_zonal"))%>
		<span class="seleccionaZonal badge badge-info mano" data-id="<%=idZonal%>" data-idZonal="<%=idZonal%>" id="zonal<%=idZonal%>">
			<i class="icon-ok"></i>
			<%=nombreZonal%>
		</span>&nbsp;
		<%rs.moveNext
	loop
end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
DB.Close
set DB=nothing%>
	</div>
</div>
<%if clickZonal = "1" then %>
	<div class="row-fluid">
		<div id="sucurzalesZonal" class="span12"></div>
	</div>
	<script type="text/javascript">
	$('.seleccionaZonal').click(function(){
		var idZonal = $(this).attr('data-id');
		var pagina = 'mensajes/seleccionaSucursales.asp';
		var div = 'sucurzalesZonal';
		var datos = 'idZonal='+idZonal;
		try{
			enviaDatos(pagina,div,datos);
			
		}
		catch(err){}
		return false;
	});
	</script>
<%else%>
	<div class="row-fluid">
		<div id="continuacionMensaje" class="span12"></div>
	</div>
	<script type="text/javascript">
		$(function(){
			var idUsuarioDestino = $('#idUsuarioDestino').val();
			return false;
		})

		$('.seleccionaZonal').click(function(){
			var zonal = '<span class="badge badge-success">'+$(this).text()+'</span>&nbsp;&nbsp;';
			var idZonal = $(this).attr('data-idZonal');
			if (idZonal != "todos")
			{
				$('#usuarioDestino').append(zonal);
				$('#zonal'+idZonal).remove();

				var totalUsuarios = $('#totalUsuarios').val();
				if (totalUsuarios == '')
				{
					totalUsuarios = 1;
				}
				else
				{
					totalUsuarios = parseInt(totalUsuarios);
					totalUsuarios += 1;
				}
				$('#totalUsuarios').val(totalUsuarios);
				$("#idUsuarioDestino").addToArray(idZonal);
			}
			var pagina = 'mensajes/cuerpoMensaje.asp';
			var div = 'continuacionMensaje';
			var datos = ''
			try{
				enviaDatos(pagina,div,datos);
			}
			catch(err){}
			return false;
		});
	</script>
<%end if%>