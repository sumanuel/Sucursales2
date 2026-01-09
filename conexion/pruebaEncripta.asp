<form id="form1" name="form1">
	<table id="nombreTabla" border="1">
		<tbody>
			<tr>
				<td>
					Texto a encriptar
				</td>
				<td>
					<input type="text" name="texto" id="texto" placeholder="Ingrese texto">
				</td>
			</tr>
			<tr>
				<td>
					Frase llave
				</td>
				<td>
					<input type="text" name="llave" id="llave" placeholder="Ingrese llave">
					<span id="encripta"><button type="button">pincha aca para encriptar</button></span>
				</td>
			</tr>
			<tr>
				<td>
					Texto encriptado
				</td>
				<td>
					<span id="textoEncriptado"></span>
				</td>
			</tr>
		</tbody>
	</table>
</form>
<script type="text/javascript" src="../js/jquery-1.10.2.min.js"></script>
<script type="text/javascript">

$('#encripta').click(function(){
	if ($('#texto').val() === '' || $('#llave').val() === '')
	{
		alert('Debe ingresar texto y llave')
	}
	else
	{
		var pagina, div, datos;
		pagina = 'encriptaTexto.asp';
		div = 'textoEncriptado';
		datos= $('#form1').serialize();
		enviaDatos(pagina,div,datos);
	}
});
function enviaDatos(pagina,div,datos)
{
	try{
		var rand = '&v='+ Math.random() * 999;
		var ajaxobject = $.ajax(
		{
			type:'GET', 
			url:pagina,
			cache:false,
			async:true,
			global:false,
			dataType:"html",
			data:datos+rand,
			timeout:10000,
			success:function(contenido){
				$('#'+div).hide().empty().html('');
        		$('#'+div).html(contenido).fadeIn('fast');
        		
			}
		});
		if(ajaxobject === undefined)
		alert('Problemas en la generacion del objeto');
	}
	catch(er){}
}
</script>