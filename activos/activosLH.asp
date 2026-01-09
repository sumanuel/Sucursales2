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
sql = sql & " from suc_activo_modelos where tipo = '2')) "
sql = sql & " order by nombre_activo_tipo asc "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
end if%>
<div class="row-fluid">
	<div class="span12">
		<form class="form-horizontal" id="formActivosLh" name="formActivosLh">
			<input name="tipoFormulario" id="tipoFormulario" value="2" type="hidden">
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
		if (tipoElemento === '10' || tipoElemento === '11' || tipoElemento === '12')
		{
			$('#divModelo, #divMarca ,#divSerie, #divModelo').slideUp('fast');
			$('#otrosCampos').addClass('control-group').html('<label class="control-label" for="cantidadTotal">Cantidad</label><div class="controls" id="controlSerie"><input type="text" name="cantidadTotal" id="cantidadTotal" data-rule-required="true" data-msg-required="Debe ingresar cantidad" data-rule-number="true" data-msg-number="Debe ingresar solo números"></div><div class="control-group"><div class="controls"><input type="submit" class="btn btn-success" value="Guardar Registro" id="botonRegistroUsuario"></div></div>');
		}
		else
		{
			pagina='activos/marca.asp';
			div='marca';
			datos='tipoElemento='+tipoElemento+'&tipo=2';
			try{
				enviaDatos(pagina,div,datos);
			}catch(err){}
			$('#controlModelo').html('<input type="text" name="campoModelo" id="campoModelo">');
			var pagina='activos/camposComputadores.asp';
			var div = 'otrosCampos';
			$('#otrosCampos').html('');
			var tipoFormulario = $('#tipoFormulario').val();
			datos = 'tipoFormulario='+tipoFormulario+'&tipoElemento='+tipoElemento;
			try{
				enviaDatos(pagina,div,datos);
			}catch(err){}
			$('#divModelo, #divMarca ,#divSerie, #divModelo').slideDown('fast');
		}
		
		
	}
	else{
		$('#divMarca, #divModelo, #divSerie, #otrosCampos').slideUp('slow');
		$('#campoModelo').val('');
		$('#campoSerie').val('');
		$('#controlModelo').html('<input type="text" name="campoModelo" id="campoModelo">');
	}
});
$('#formActivosLh').validate({
	ignore:':not(:visible)',
	onsubmit: true,	
	submitHandler: function(form) {
		var numero = '&v='+ Math.random() * 999;
		var valores = $("#formActivosLh").serialize();
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
				{$('ul#menuActivos > li').removeClass('active');
					$('#lh').addClass('active');
					var pagina='activos/activosLH.asp';
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