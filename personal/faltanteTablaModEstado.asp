<!--#include file="../funciones.asp"-->
<%
	perfil = trim(request("idPerfil"))
	idUsuario = trim(request("idUsuario"))
	periodo = trim(request("periodo"))
	nomCajero = trim(request("nomCajero"))
	idFaltanteModEstado = trim(request("idFaltanteModEstado"))
	valija = trim(request("valija"))

	sql = ""
	sql = sql & " EXEC SUC_prc_sucursal_faltante_drop_estado '2' "
	set rs = db.execute(sql)
	if not rs.eof then
		datosEstado = rs.getrows()
	end if
%>

<form class="form-inline" role="form" id="formTablaFaltantModEstado" data-idUsuario="<%=idUsuario%>" data-perfil="<%=perfil%>" data-idSucursal="<%=idSucursal%>" data-periodo="<%=periodo%>" data-idFaltanteModEstado="<%=idFaltanteModEstado%>" data-nomCajero="<%=nomCajero%>" data-valija="<%=valija%>">
	<div>
		<table id="tableModFaltan" class="table table-bordered table-conde" style="background: #f2f2f2; border: 1px solid #cccccc">
			<tr>
				<td style="width: 150px;"><b>Nombre Persona</b></td>
				<td colspan="3">
					<input type="text" id="txtNombreCajeroFalt" value="<%=nomCajero%>" maxlength="250" minlength="10" style="width: 95%;" disabled> 
				</td>
				<td style="text-align: right; border-left: 0px;">
					<img id="gifCargando" class="oculto" src="../img/loading.gif"> <button type="button" class="btn btn-warning" id="btnVolverMenu" data-toggle="popover" data-placement="bottom" title="Volver" data-trigger="hover">Volver</button>
				</td>
			</tr>
			<tr>
				<td style="width: 130px;"><b>Estado</b></td>
				<td>
					<select name="estadoFaltantante" id="estadoFaltantante" style="width: 90%">
						<option value="0">Seleccione Estado</option>
						<%for i = 0 to ubound(datosEstado,2)
							idEstadoFalant = trim(datosEstado(0,i))
							estado = server.htmlencode(trim(datosEstado(1,i)))%>
							<option value="<%=idEstadoFalant%>"><%=estado%></option>
						<%next%> 		
					</select>
				</td>	
			</tr>
			<tr>
				<td colspan="3" style="text-align: left;">
					<div id="msgModifcaEstadoFaltante"></div>
				</td>
				<td style="text-align: right; border-left: 0px;">
					<img id="gifCargandoModEstadoFalt" class="oculto" src="../img/loading.gif"> <button type="button" class="btn btn-primary" id="btnModEstadoFaltante" data-toggle="popover" data-placement="bottom" title="Modifica Estado Faltante" data-trigger="hover" data-content="<%=GlosaAC1%>">Modificar</button>
				</td>
			</tr>
		</table>	
	</div>	
</form>
<script type="text/javascript">

	$('.input-number').on('input', function () { 
	    this.value = this.value.replace(/[^0-9]/g,'');
	});
	$('#estadoFaltantante').change(function(){
		$('#textValija').val('');
		var pagina, div, datos, periodo, idSucursal, idUsuario, perfil, textValija;
		idSucursal = $('#formTablaFaltantModEstado').attr('data-idSucursal');
		idUsuario = $('#formTablaFaltantModEstado').attr('data-idUsuario');
		idPerfil = $('#formTablaFaltantModEstado').attr('data-perfil');
		periodo = $('#formTablaFaltantModEstado').attr('data-periodo');
		valija = $('#formTablaFaltantModEstado').attr('data-valija');
		estadoFaltante = $('#estadoFaltantante').val();
		textValija = $('#textValija').val();
		if (parseInt(estadoFaltante) === 2){
			$('#trValija').slideDown('fast');
			pagina = 'faltanteTabla';
			div = '';
			datos='periodo='+periodo+'&idUsuario='+idUsuario+'&idPerfil='+idPerfil+'&idSucursal='+idSucursal+'&estadoFaltante='+estadoFaltante+'&valija='+valija;
			enviaDatos(pagina,div,datos);
		}else{
			$('#trValija').hide();
		}

	});

	$('#btnModEstadoFaltante').click(function(){
		var msj = "";
		var pagina, div, datos, periodo, idSucursal, idUsuario, perfil, textValija;
		idSucursal = $('#formTablaFaltantModEstado').attr('data-idSucursal');
		idUsuario = $('#formTablaFaltantModEstado').attr('data-idUsuario');
		idPerfil = $('#formTablaFaltantModEstado').attr('data-perfil');
		periodo = $('#formTablaFaltantModEstado').attr('data-periodo');
		idFaltanteModEstado = $('#formTablaFaltantModEstado').attr('data-idFaltanteModEstado');
		estadoFaltante = $('#estadoFaltantante').val();
		textValija = $('#textValija').val();

		if (estadoFaltante !== "0"){
	    		$('#gifCargandoModEstadoFalt').slideDown('fast');
	    		pagina = 'faltanteModificaEstadoSql.asp';
				div = '';
				datos='periodo='+periodo+'&idUsuario='+idUsuario+'&estadoFaltante='+estadoFaltante+'&idFaltanteModEstado='+idFaltanteModEstado+'&valija='+valija;
				console.log(datos);
				enviaDatos(pagina,div,datos);
				setTimeout(function() {
            		$('#gifCargandoModEstadoFalt').slideUp('fast');
            		$('#subMenuFaltante').slideDown('fast');
					$('#faltanteCargaTabla, #detalleEstadoFaltanteTabla').slideUp('fast');
					pagina = 'faltanteTabla.asp';
					div = 'subMenuFaltante';
					datos='periodo='+periodo+'&idUsuario='+idUsuario+'&idSucursal='+idSucursal+'&valija='+valija;
					enviaDatos(pagina,div,datos);
		        	}, 2000);
	    }else{
	    	$('#msgModifcaEstadoFaltante').html('<p style="color:red;"><b>SELECCIONE UN ESTADO</b></p>');
	    	setTimeout(function() {
	           	$('#msgModifcaEstadoFaltante').html('');
		    }, 2000);
	    }
	});
	$('#btnVolverMenu').click(function(){
		$('#subMenuFaltante').slideDown('fast');
		$('#faltanteCargaTabla, #detalleEstadoFaltanteTabla').slideUp('fast');
	});
</script>