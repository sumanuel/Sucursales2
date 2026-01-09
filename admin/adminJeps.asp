<div class="row-fluid">
	<div id="botonCreaUsuario" class="offset10 span2 btn btn-success">
		Agregar usuario <i class="icon-user"></i>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="registroUsuarios">
	</div>
</div>
<div class="row-fluid">
	<div id="tablaUsuarios"></div>
</div>

<script type="text/javascript">
$(function(){
	var pagina = 'tablaUsuarios.asp';
	var div = 'tablaUsuarios';
	var datos='';
	try{
		enviaDatos(pagina,div,datos);
		return false;
	}
	catch(err){}
})
$('#botonCreaUsuario').click(function(){
	if (!$(this).hasClass('disabled'))
	{

		$('#tablaUsuarios').hide('fast');
		$(this).addClass('disabled');
		pagina = 'registraUsuarios.asp';
		div = 'registroUsuarios';
		datos='';
		try{
			enviaDatos(pagina,div,datos);
		}
		catch(err){}
		return false;
	}
});
</script>