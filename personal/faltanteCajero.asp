<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
sql = ""
sql = sql & " EXEC SUC_prc_sucursal_faltante_obtiene_periodo "

set rs = db.execute(sql)
if not rs.eof then
	datos= rs.getrows()
end if
%>
<div class="row-fluid">
	<div class="row-fluid">		
		<ul class="nav nav-tabs" id="menueFaltante" data-idUsuario="<%=idUsuario%>" data-perfilMain="<%=perfilMain%>">
			<!--<li  id="liFaltante">
				<a href="#">
					<i class="icon-briefcase"></i> General
				</a>
			</li>-->
			<li  id="liFaltanteDetalle">
				<a href="#">
					<i class="icon-cogs"></i> Detalle
				</a>
			</li>		
		</ul>
	</div>
</div>
<div class="row-fluid text-center" id="divFaltantePeriodo">
	<div class="controls">
		<div class="input-append">
		    <select id="selectPeriodoFaltante" name="selectPeriodoFaltante">
				<option value="0">[ Seleccione periodo ]</option>
				<%for i = 0 to ubound(datos,2)
					idPeriodo = datos(0,i)
					nombrePeriodo= trim(datos(1,i))
				    'mesFecha = datos(1,i)
					'anioFecha = datos(0,i)
					seleccionado = ""
					if i = 0 then 
						seleccionado = "selected"
					end if%>
					<option value="<%=idPeriodo%>" <%=seleccionado%>><%=nombrePeriodo%></option>
					<%next%>
			</select>

		</div>
	</div>
</div>
<script type="text/javascript">
	$(function(){
		$('#faltanteCargaTabla').html('');
		$('li#liFaltanteDetalle').addClass('active');
		$('#divFaltantePeriodo, #subMenuFaltante').show();
		$('#subMenuFaltante').html('');
		var idUsuario= $('#menueFaltante').attr('data-idUsuario');
		var perfilMain= $('#menueFaltante').attr('data-perfilMain');
		var periodo = $('#selectPeriodoFaltante').val();
		var div = 'subMenuFaltante';
	    var datos = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&periodo='+periodo;
	    var pagina = 'faltanteTabla.asp';    
	    enviaDatos(pagina,div,datos);
		$('ul#menueFaltante > li').each(function(){
			$(this).removeClass('active');
		});
		$('li#liFaltanteDetalle').addClass('active');
		
	});
	$('#selectPeriodoFaltante').change(function(){
		var pagina, div, datos, periodo, idUsuario, perfilMain;
		idUsuario= $('#menueFaltante').attr('data-idUsuario');
		perfilMain= $('#menueFaltante').attr('data-perfilMain');
		periodo = $('#selectPeriodoFaltante').val();
		pagina = 'faltanteTabla.asp';
		div = 'subMenuFaltante';
		datos='periodo='+periodo+'&idUsuario='+idUsuario+'&perfilMain='+perfilMain;
		console.log(datos)
		enviaDatos(pagina,div,datos);
	});

	$('#liFaltanteDetalle').click(function(){
		$('#faltanteCargaTabla').html('');
		$('#divFaltantePeriodo, #subMenuFaltante').show();
		$('#subMenuFaltante').html('');
		var idUsuario= $('#menueFaltante').attr('data-idUsuario');
		var perfilMain= $('#menueFaltante').attr('data-perfilMain');
		var periodo = $('#selectPeriodoFaltante').val();
		var div = 'subMenuFaltante';
	    var datos = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&periodo='+periodo;
	    var pagina = 'faltanteTabla.asp';    
	    enviaDatos(pagina,div,datos);
		$('ul#menueFaltante > li').each(function(){
			$(this).removeClass('active');
		});
		$('li#liFaltanteDetalle').addClass('active');
	});

	/*$('#liFaltante').click(function(){
		$('#subMenuFaltante').html('');
		$('#divFaltantePeriodo, #subMenuFaltante').hide();
		var idUsuario= $('#menueFaltante').attr('data-idUsuario');
		var perfilMain= $('#menueFaltante').attr('data-perfilMain');

		var div = 'subMenuFaltante';
	    var datos = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain
	    //var pagina = '';    
	    enviaDatos(pagina,div,datos);

		$('ul#menueFaltante > li').each(function(){
			$(this).removeClass('active');
		});
		$('li#liFaltante').addClass('active');
	});*/
</script>
