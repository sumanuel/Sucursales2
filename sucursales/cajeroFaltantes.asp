<!--#include file="../funciones.asp"-->
<%
perfil = trim(request("idPerfil"))
idUsuario = trim(request("idUsuario"))
idSucursal = trim(request("idSucursal"))

sql = ""
sql = sql & " EXEC SUC_prc_sucursal_faltante_obtiene_periodo "

set rs = db.execute(sql)
if not rs.eof then
	datos= rs.getrows()
end if
%>
<input type="hidden" name="idSucursal" id="idSucursal" value="<%=idSucursal%>">
<input type="hidden" name="idUsuario" id="idUsuario" value="<%=idUsuario%>">
<input type="hidden" name="perfil" id="perfil" value="<%=perfil%>">
<div class="row-fluid text-center" id="divPeriodoFaltante">
	<div class="controls">
		<div class="input-append">
		    <select id="selectPeriodoFalt" name="selectPeriodoFalt">
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
<br>
<div class="row-fluid" id="cajeroTablaFaltante">
	<div class="span12" id="cargaCajeroTablaFaltante"></div>
</div>
<div class="row-fluid" id="cajeroFaltanteEstado">
	<div class="span12" id="cargaCajeroTablaSobrante"></div>
</div>

<script type="text/javascript">
$(function(){
	$('#cargaCajeroTablaFaltante').html('');
	$('#cargaCajeroTablaSobrante').html('');
	var pagina, div, datos, periodo, idSucursal, idUsuario, perfil;
	idSucursal = $('#idSucursal').val();
	idUsuario = $('#idUsuario').val();
	idPerfil = $('#perfil').val();
	periodo = $('#selectPeriodoFalt').val();
	pagina = 'sucursales/cajeroTablaFaltantes.asp';
	div = 'cargaCajeroTablaFaltante';
	datos='periodo='+periodo+'&idUsuario='+idUsuario+'&idPerfil='+idPerfil+'&idSucursal='+idSucursal;
	enviaDatos(pagina,div,datos);
	
	pagina = 'sucursales/cajeroTablaSobrante.asp';
	div = 'cargaCajeroTablaSobrante';
	datos='periodo='+periodo+'&idUsuario='+idUsuario+'&idPerfil='+idPerfil+'&idSucursal='+idSucursal;
	enviaDatos(pagina,div,datos);
	$('#cargaCajeroTablaFaltante').html('');
	$('#cargaCajeroTablaSobrante').html('');
});

$('#selectPeriodoFalt').change(function(){
	$('#cargaCajeroTablaFaltante').html('');
	$('#cargaCajeroTablaSobrante').html('');
	var pagina, div, datos, periodo, idSucursal, idUsuario, perfil;
	idSucursal = $('#idSucursal').val();
	idUsuario = $('#idUsuario').val();
	idPerfil = $('#perfil').val();
	periodo = $('#selectPeriodoFalt').val();
	pagina = 'sucursales/cajeroTablaFaltantes.asp';
	div = 'cargaCajeroTablaFaltante';
	datos='periodo='+periodo+'&idUsuario='+idUsuario+'&idPerfil='+idPerfil+'&idSucursal='+idSucursal;
	enviaDatos(pagina,div,datos);

	pagina = 'sucursales/cajeroTablaSobrante.asp';
	div = 'cargaCajeroTablaSobrante';
	datos='periodo='+periodo+'&idUsuario='+idUsuario+'&idPerfil='+idPerfil+'&idSucursal='+idSucursal;
	enviaDatos(pagina,div,datos);
	$('#cargaCajeroTablaFaltante').html('');
	$('#cargaCajeroTablaSobrante').html('');
});
</script>


