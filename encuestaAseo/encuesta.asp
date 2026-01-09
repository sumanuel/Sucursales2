<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursalMain"))
fechaActual = date()
sql = ""
sql = sql & " select cast(hora_ingreso as datetime) horaApertura "
sql = sql & " from SUC_sucursal_apertura "
sql = sql & " where id_sucursal = '"&idSucursal&"' "
sql = sql & " and  fecha_ingreso = cast (GETDATE() as DATE) "
sql = sql & " and tipo = 1 "
'response.write(sql)
set rs = db.execute(sql)
if not rs.eof then
	sql = ""
	sql = sql & " set dateformat dmy "
	sql = sql & " select id "
	sql = sql & " from SUC_encuesta_aseo "
	sql = sql & " where id_sucursal = '"&idSucursal&"' "
	sql = sql & " and fecha_reg = '"&fechaActual&"'"
	set rs = db.execute(sql)
	if not rs.eof then
		tieneDatos = "1"
	else
		tieneDatos = "0"
	end if
	if tieneDatos = "0" then %>
		<div id="encuestaAseo" class="well">
			<form class="form-horizontal" id="formEncuestaAseo">
				<input type="hidden" name="idSucursal" id="idSucursal" value="<%=idSucursal%>">
				<div class="control-group">
					<label class="inline">1.- <strong>&#191;Llegó el servicio de aseo?</strong></label>
					<label class="radio inline">
						<input type="radio" name="pregunta1" id="pregunta1" value="si" title="Debe informar si llegó el servicio de aseo">Si
					</label>
					<label class="radio inline">
						<input type="radio" name="pregunta1" id="pregunta1" value="no">No
					</label>
					<label for="pregunta1" class="error"></label>
			  	</div>
			  	<div class="control-group">
					<label class="inline">2.- <strong>&#191;Llegó a la hora?</strong></label>
					<label class="radio inline">
						<input type="radio" name="pregunta2" id="pregunta2" value="si" title="Debe informar si el servicio de aseo llegó a la hora">Si
					</label>
					<label class="radio inline">
						<input type="radio" name="pregunta2" id="pregunta2" value="no">No
					</label>
					<label for="pregunta2" class="error"></label>
			  	</div>
			  	<div class="control-group">
					<label class="inline">3.- <strong>&#191;Tiene materiales de aseo?</strong></label>
					<label class="radio inline">
						<input type="radio" name="pregunta3" id="pregunta3" value="si" title="Debe informar si tiene materiales de aseo">Si
					</label>
					<label class="radio inline">
						<input type="radio" name="pregunta3" id="pregunta3" value="no">No
					</label>
					<label for="pregunta3" class="error"></label>
			  	</div>
			  	<div class="control-group">
					<label class="inline">4.- <strong>&#191;El trabajo realizado es satisfactorio?</strong></label>
					<label class="radio inline">
						<input type="radio" name="pregunta4" id="pregunta4" value="si" title="Debe informar si el trabajo realizado es satisfactorio">Si
					</label>
					<label class="radio inline">
						<input type="radio" name="pregunta4" id="pregunta4" value="no">No
					</label>
					<label for="pregunta4" class="error"></label>
			  	</div>
			  	<div class="control-group">
					<label class="inline">5.- <strong>El personal de aseo, &#191;tiene problemas de relacionamiento?</strong></label>
					<label class="radio inline">
						<input type="radio" name="pregunta5" id="pregunta5" value="si" title="Debe informar si el personal de aseo tiene problemas de relacionamiento">Si
					</label>
					<label class="radio inline">
						<input type="radio" name="pregunta5" id="pregunta5" value="no">No
					</label>
					<label for="pregunta5" class="error"></label>
			  	</div>
			  	<div class="control-group">
					<label class="inline">6.- <strong>Con respecto al horario en que se realiza el servicio de aseo, &#191;este responde a la necesidad de la sucursal?</strong></label>
					<label class="radio inline">
						<input type="radio" name="pregunta6" id="pregunta6" value="si" title="Debe informar si el servicio de aseo responde a la necesidad de la sucursal">Si
					</label>
					<label class="radio inline">
						<input type="radio" name="pregunta6" id="pregunta6" value="no">No
					</label>
					<label for="pregunta6" class="error"></label>
			  	</div>
			  	<div class="control-group">
					<label class="inline">7.- <strong>Evalue globalmente el servicio de aseo.</strong></label>
					<label class="radio inline">
						<input type="radio" name="pregunta7" id="pregunta7" value="excelente" title="Debe evaluar globalmente el servicio de aseo">Excelente
					</label>
					<label class="radio inline">
						<input type="radio" name="pregunta7" id="pregunta7" value="normal">Normal
					</label>
					<label class="radio inline">
						<input type="radio" name="pregunta7" id="pregunta7" value="deficiente">Deficiente
					</label>
					<label for="pregunta7" class="error"></label>
			  	</div>
				<div class="control-group">
					<label class="inline">8.- <strong>Observaciones</strong></label>
					<label class="inline">
						<textarea rows="6" id="pregunta8" name="pregunta8" class="field span6"></textarea>
						<span id="totalCaracteres" class="badge"></span>
					</label>
				</div>
				<div class="control-group">
					<div class="controls">
						<span id="guardaDatos">
							<input type="submit" name="enviar" id="enviar" value="Enviar" class="btn btn-success"/>
						</span>
					</div>
				</div>
			</form>
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
		var elem = $("#totalCaracteres");
		$("#pregunta8").limiter(400, elem);
		$("#formEncuestaAseo").validate({
			ignore:":not(:visible)", 
		    onsubmit: true,
		    rules: {
		    pregunta1:{
					required:true 
		    	},
		    pregunta2:{
		    		required:true
		    	},
		    pregunta3:{
		    		required:true
		    	},
		    pregunta4:{
		    		required:true
		    	},
		    pregunta5:{
		    		required:true
		    	},
		    pregunta6:{
		    		required:true
		    	},
		    pregunta7:{
		    		required:true
		    	}
			},
			submitHandler: function(form) {
			var numero = '&v='+ Math.random() * 999 
		    var valores = $('#formEncuestaAseo').serialize();
			valores += numero;
			$('#guardaDatos').html('<i class="icon-refresh icon-spin"></i>Un momento guardando datos');
			$.ajax( 
				{
					type:'GET',
					url:'encuestaAseo/sql.asp', //la pagina que se van los datos
					cache:false,
					//async:true,
					global:false,
					dataType:"html",
					data:valores,
					timeout:10000, //tiempo que espera
					success:function(contenido) //cargo la pagina correctamente
					{
				    	setTimeout('$("#guardaDatos").html("<i class=icon-check></i>Registrado con exito")',2000);
				    	var pagina = 'main.asp';
						var div = 'area';
						var datos='';
						setTimeout('enviaDatos(pagina,div,datos)',4000);
					},
					error:function() //si no carga la pagina
					{
						alert('Algo Salio Mal.');
					}
				});
			}
		});
		</script>
	<%else%>
	<div class="row-fluid">
		<div class="span4 offset4">
			<span class="badge badge-success">
				Usted ya respondio la encuesta hoy
			</span>
		</div>
	</div>
	<%end if
else%>
<div class="row-fluid">
	<div class="span4 offset4">
		<span class="badge badge-important">
			La sucursal debe estar abierta para ingresar la encuesta
		</span>
	</div>
</div>
<%end if%>
