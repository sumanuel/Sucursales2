<!--#include file="../funciones.asp"-->
<%sql = ""
sql = sql & " select id_activo_tipo, "
sql = sql & " nombre_activo_tipo "
sql = sql & " from SUC_activo_tipo "
sql = sql & " where id_activo_tipo in "
sql = sql & " (select id_activo_tipo "
sql = sql & " from SUC_activo_marca "
sql = sql & " where id_activo_marca in "
sql = sql & " (select id_activo_marca "
sql = sql & " from suc_activo_modelos where tipo = '1')) "
sql = sql & " order by nombre_activo_tipo asc "

set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
end if%>
<div class="row-fluid">
	<div class="span12">
		<form class="form-horizontal" name="formActivosEntel" id="formActivosEntel">
			<input name="tipoFormulario" id="tipoFormulario" value="1" type="hidden">
			<div class="control-group">
				<label class="control-label" for="tipoElemento">Seleccione Tipo</label>
				<div class="controls">
					<select name="tipoElemento" id="tipoElemento" data-rule-required="true" data-msg-required="Debe seleccionar una opción">
						<option value="">[Seleccione opción]</option>
						<%For i = 0 to ubound(datos, 2)
							idActivo = trim(datos(0,i))
							nombreActivo = server.htmlencode(trim(datos(1,i)))%>
							<option value="<%=idActivo%>"><%=nombreActivo%></option>
						<%next%>
					</select>
				</div>
			</div>
			<div class="control-group oculto" id="divMarca">
				<label class="control-label" for="campoMarca">Marca</label>
				<div class="controls" id="marca"></div>
			</div>
			<div class="control-group oculto" id="divModelo">
				<label class="control-label" for="campoModelo">Modelo</label>
				<div class="controls" id="controlModelo"></div>
			</div>
			<div class="control-group oculto" id="divSerie"></div>
			<div id="otrosCampos"></div>
			<div id="enviaDatos" class="oculto"></div>
		</form>
	</div>
</div>
<script type="text/javascript">
$('#tipoElemento').change(function() {
	var tipoElemento = $(this).val();
	
	if (tipoElemento!=='')
	{
		$('#divMarca, #divModelo, #divSerie').slideDown('slow');
		var pagina='activos/marca.asp';
		var div='marca';
		var datos='tipoElemento='+tipoElemento+'&tipo=1';
		try{
			enviaDatos(pagina,div,datos);
		}catch(err){}
		$('#controlModelo').html('<input type="text" name="campoModelo" id="campoModelo" data-rule-required="true" data-msg-required="El campo no puede estar vacio">');
			pagina='activos/camposComputadores.asp';
			div = 'otrosCampos';
			$('#otrosCampos').html('');
			var tipoFormulario = $('#tipoFormulario').val();
			datos = 'tipoFormulario='+tipoFormulario+'&tipoElemento='+tipoElemento;
			try{
				enviaDatos(pagina,div,datos);
			}catch(err){}
	}
	else{
		$('#divMarca, #divModelo, #divSerie, #otrosCampos').slideUp('slow');
		$('#campoModelo').val('');
		$('#campoSerie').val('');
		$('#controlModelo').html('<input type="text" name="campoModelo" id="campoModelo" data-rule-required="true" data-msg-required="El campo no puede estar vacio">');
	}
});
$('#formActivosEntel').validate({
	ignore:':not(:visible)',
	onsubmit: true,	
	submitHandler: function(form) {
		var numero = '&v='+ Math.random() * 999;
		var valores = $("#formActivosEntel").serialize();
		valores += numero;
		$('#botonRegistroUsuario').hide('fast');
		$('#enviaDatos').removeClass('oculto').html('<strong>Guardando</strong> <img src="img/loader.gif"/>');
		$('#enviaDatos').delay(2000).queue(function( nxt ) {
			$.ajax({
				type:'GET', //en desarrollo como GET en produccion POST
				url:'activos/sql.asp', //la pagina que se van los datos
				cache:false,
				//async:true,
				global:false,
				dataType:"html",
				data:valores,
				timeout:10000, //tiempo que espera
				success:function(contenido) //cargo la pagina correctamente
				{
					$('ul#menuActivos > li').removeClass('active');
					$('#entel').addClass('active');
					var pagina='activos/activosEntel.asp';
					var div='cargaActivos';
					var datos = '';
					try{
						enviaDatos(pagina,div,datos);
					}catch(err){}
					pagina='activos/informeActivos.asp';
					div='informeActivos';
					datos = 'tipoActivo=1';
					try{
						enviaDatos(pagina,div,datos);
					}catch(err){}
					$('#divAgregarActivos').addClass('oculto');
				},
				error:function() //si no carga la pagina
				{
					alert('Algo Salio Mal.');
				}
			});
			nxt();
			return false;
		});
	}
});
</script>