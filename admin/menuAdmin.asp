<ul class="nav nav-pills" id="menuAdministracion">
	<li class="active" id="adminJeps">
		<a href="#">
			Administracion usuarios
		</a>
	</li>
	<li>
		<a href="#">
			Administración sucursales
		</a>
	</li>
	<li>
		<a href="#">
			Administracion zonas
		</a>
	</li>
</ul>
<script type="text/javascript">
$(function(){
	$('ul#menuAdministracion li').each(function(index, element) {
		if ($(this).hasClass('active'))
		{
			idTab = $(this).attr('id');
		}
	});
	if (idTab =='adminJeps')
	{
		pagina = 'adminJeps.asp';
		div = 'trabajoAdmin';
		datos='';
		try{
			enviaDatos(pagina,div,datos);
		return false;
		}
		catch(err){}
	};
});

</script>