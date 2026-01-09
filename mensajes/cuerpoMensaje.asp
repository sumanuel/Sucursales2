<%perfil = trim(request("perfil"))
if perfil = "1" then
	divRecibe = "area"
end if
if perfil = "2" then
	divRecibe = "trabajoZonal"
end if
if perfil = "3" then
	divRecibe = "areaTrabajoGerencia"
end if%>
<br>
<div class="row-fluid">
	<div class="span12">
		<div class="control-group">
			<label class="control-label" for="asuntoMensaje">
				<strong>
					Asunto:
				</strong>
			</label>
			<div class="controls">
				<input type="text" name="asuntoMensaje" id="asuntoMensaje" placeholder="Ingrese asunto" title="Debe Ingresar Asunto">
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="mensaje">
				<strong>Mensaje:</strong>
			</label>
			<div class="controls">
				<textarea row="10" cols="40" id="mensaje" name="mensaje" placeholder="Ingrese mensaje" title="Debe ingresar mensaje"></textarea>
				<span id="totalCaracteres" class="badge"></span>
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
				<span id="guardaDatos">
					<input type="submit" name="enviar" id="enviar" value="Enviar" class="btn btn-success"/>
				</span>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
(function($) {
    $.fn.extend( {
        limiter: function(limit, elem) {
            $(this).on("keyup focus", function() {
                setCount(this, elem);
            });
            function setCount(src, elem) {
                var chars = src.value.length;
                if (chars > limit) {
                    src.value = src.value.substr(0, limit);
                    chars = limit;
                    elem.addClass("badge-important");
                }
                else
                {
                	elem.removeClass("badge-important");
                }
                elem.html( limit - chars );
            }
            setCount($(this)[0], elem);
        }
    });
})(jQuery);
$(function(){
	var elem = $("#totalCaracteres");
	$("#mensaje").limiter(200, elem);
	$("#ingresoNuevoMensaje").validate({
		ignore:":not(:visible)", 
	    onsubmit: true,
	    rules: {
	    asuntoMensaje:{
			required:true 
	    	},
	    mensaje:{
	    	required:true
	    	}
		},
		submitHandler: function(form) {
		var numero = '&v='+ Math.random() * 999 
	    var valores = $('#ingresoNuevoMensaje').serialize();
		valores += numero ;
		$('#guardaDatos').html('<i class="icon-refresh icon-spin"></i>Un momento guardando datos');
		$.ajax( 
			{
				type:'GET',
				url:'mensajes/sql.asp', //la pagina que se van los datos
				cache:false,
				//async:true,
				global:false,
				dataType:"html",
				data:valores,
				timeout:10000, //tiempo que espera
				success:function(contenido) //cargo la pagina correctamente
				{
					setTimeout(function() {
						$("#guardaDatos").html("<i class=icon-check></i>Registrado con exito");
					}, 2000);
					setTimeout(function() {
						$("#nuevoMensaje").addClass("oculto");
					}, 3500);
					pagina = 'mensajes/mensajes.asp';
					div = '<%=divRecibe%>';
					datos='';
					setTimeout(function() {
						try{
							enviaDatos(pagina,div,datos)
						}
						catch(err){}
					}, 4000);
				},
				error:function() //si no carga la pagina
				{
					alert('Algo Salio Mal.');
				}
			});
		}
	});
});
</script>