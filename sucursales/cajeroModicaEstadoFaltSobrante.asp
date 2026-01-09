<!--#include file="../funciones.asp"-->
<%
	perfil = trim(request("idPerfil"))
	idUsuario = trim(request("idUsuario"))
	idSucursal = trim(request("idSucursal"))
	periodo = trim(request("periodo"))
	nomCajero = trim(request("nomCajero"))
	idFaltanteModEstado = trim(request("idFaltanteModEstado"))

	sql = ""
	sql = sql & " EXEC SUC_prc_sucursal_faltante_drop_estado '1' "
	set rs = db.execute(sql)
	if not rs.eof then
		datosEstado = rs.getrows()
	end if
%>

<form class="form-inline" role="form" id="formTablaModEstadoFaltant" data-idUsuario="<%=idUsuario%>" data-perfil="<%=perfil%>" data-idSucursal="<%=idSucursal%>" data-periodo="<%=periodo%>" data-idFaltanteModEstado="<%=idFaltanteModEstado%>" data-nomCajero="<%=nomCajero%>">
	<div>
		<table id="tableModFaltan" class="table table-bordered table-conde" style="background: #f2f2f2; border: 1px solid #cccccc">
			<tr>
				<td style="width: 150px;"><b>Nombre Persona</b></td>
				<td colspan="3">
					<input type="text" id="txtNombreCajero" value="<%=nomCajero%>" maxlength="250" minlength="10" style="width: 95%;" disabled> 
				</td>
				<td style="text-align: right; border-left: 0px;">
					<img id="gifCargando" class="oculto" src="img/loading.gif"> <button type="button" class="btn btn-warning" id="btnVolverMenu" data-toggle="popover" data-placement="bottom" title="Volver" data-trigger="hover">Volver</button>
				</td>
			</tr>
			<tr>
				<td style="width: 130px;"><b>Estado</b></td>
				<td>
					<select name="estadoFaltant" id="estadoFaltant" style="width: 90%">
						<option value="0">Seleccione Estado</option>
						<%for i = 0 to ubound(datosEstado,2)
							idEstadoFalant = trim(datosEstado(0,i))
							estado = server.htmlencode(trim(datosEstado(1,i)))%>
							<option value="<%=idEstadoFalant%>"><%=estado%></option>
						<%next%> 		
					</select>
					<span id="iconObligatorioTP" class="oculto" data-toggle="popover" data-placement="bottom" data-trigger="hover" data-content="<%=GlosaObligatorio%>"><i  class="icon-warning-sign" style="color:red;" ></i></span>
				</td>	
			</tr>
			<tr id="trValija" class="oculto">
			<td><b>Valija</b></td>
				<td>
					<input type="text" id="textValija" placeholder="Valija (Solo Numeros)" maxlength="250" minlength="10" style="width: 95%;" class="input-number"> 
				</td>	
			</tr>
			<tr >
				<td colspan="3" style="text-align: left;">
					<div id="msgModifcaEstadoFalt"></div>
				</td>
				<td style="text-align: right; border-left: 0px;">
					<img id="gifCargandoModEstadoFalt" class="oculto" src="img/loading.gif"> <button type="button" class="btn btn-primary" id="btnModEstado" data-toggle="popover" data-placement="bottom" title="Modifica Estado Faltante" data-trigger="hover" data-content="<%=GlosaAC1%>">Modificar</button>
				</td>
			</tr>
		</table>	
	</div>	
	<div id="AsignaCapacitacionCajero1Error"></div>
</form>

<script type="text/javascript">

	$('.input-number').on('input', function () { 
	    this.value = this.value.replace(/[^0-9]/g,'');
	});
	$('#estadoFaltant').change(function(){
		$('#textValija').val('');
		var pagina, div, datos, periodo, idSucursal, idUsuario, perfil;
		idSucursal = $('#formTablaModEstadoFaltant').attr('data-idSucursal');
		idUsuario = $('#formTablaModEstadoFaltant').attr('data-idUsuario');
		idPerfil = $('#formTablaModEstadoFaltant').attr('data-perfil');
		periodo = $('#formTablaModEstadoFaltant').attr('data-periodo');
		estadoFaltante = $('#estadoFaltant').val();
		textValija = $('#textValija').val();
		if (parseInt(estadoFaltante) === 2){
			$('#trValija').slideDown('fast');
			pagina = 'sucursales/cajeroTablaFaltantes.asp';
			div = '';
			datos='periodo='+periodo+'&idUsuario='+idUsuario+'&idPerfil='+idPerfil+'&idSucursal='+idSucursal+'&estadoFaltante='+estadoFaltante;
			enviaDatos(pagina,div,datos);
		}else{
			$('#trValija').hide();
		}

	});

	$('#btnModEstado').click(function(){
		var msj = "";
		var pagina, div, datos, periodo, idSucursal, idUsuario, perfil;
		idSucursal = $('#formTablaModEstadoFaltant').attr('data-idSucursal');
		idUsuario = $('#formTablaModEstadoFaltant').attr('data-idUsuario');
		idPerfil = $('#formTablaModEstadoFaltant').attr('data-perfil');
		periodo = $('#formTablaModEstadoFaltant').attr('data-periodo');
		idFaltanteModEstado = $('#formTablaModEstadoFaltant').attr('data-idFaltanteModEstado');
		estadoFaltante = $('#estadoFaltant').val();
		textValija = $('#textValija').val();

		if (estadoFaltante !== "0"){
			if (parseInt(estadoFaltante) === 2){
				if ($('#textValija').val() === "") {
		        	$('#msgModifcaEstadoFalt').html('<p style="color:red;"><b>INGRESE VALIJA</b></p>');
		        	setTimeout(function() {
	           			$('#msgModifcaEstadoFalt').html('');
		    		}, 2000);
		    	}else if($("#textValija").val().length < 4) {
		    		$('#msgModifcaEstadoFalt').html('<p style="color:red;"><b>VALIJA NO VÁLIDA</b></p>');
		    		setTimeout(function() {
	            		$('#msgModifcaEstadoFalt').html('');
		        	}, 2000);
		    	}else{
		    		$('#gifCargandoModEstadoFalt').slideDown('fast');
		    		pagina = 'sucursales/cajeroModEstadoFaltanteSql.asp';
					div = '';
					datos='periodo='+periodo+'&idUsuario='+idUsuario+'&idPerfil='+idPerfil+'&idSucursal='+idSucursal+'&estadoFaltante='+estadoFaltante+'&idFaltanteModEstado='+idFaltanteModEstado+'&textValija='+textValija;
					console.log(datos);
					enviaDatos(pagina,div,datos);
					setTimeout(function() {
	            		$('#gifCargandoModEstadoFalt').slideUp('fast');
	            		$('#cargaCajeroTablaSobrante').slideDown('fast');
						$('#cajeroTablaModEstadoFaltante').slideUp('fast');
					
						pagina = 'sucursales/cajeroFaltantes.asp';
						div = 'cargaCajeroTablaFaltante';
						datos='periodo='+periodo+'&idUsuario='+idUsuario+'&idPerfil='+idPerfil+'&idSucursal='+idSucursal;
						enviaDatos(pagina,div,datos);
			        	}, 2000);
		    	}
		    }else{
		    	$('#gifCargandoModEstadoFalt').slideDown('fast');
		    	pagina = 'sucursales/cajeroModEstadoFaltanteSql.asp';
				div = '';
				datos='periodo='+periodo+'&idUsuario='+idUsuario+'&idPerfil='+idPerfil+'&idSucursal='+idSucursal+'&estadoFaltante='+estadoFaltante+'&idFaltanteModEstado='+idFaltanteModEstado+'&textValija='+textValija;
				enviaDatos(pagina,div,datos);
				setTimeout(function() {
	            	$('#gifCargandoModEstadoFalt').slideUp('fast');
	            	$('#cargaCajeroTablaSobrante').slideDown('fast');
					$('#cajeroTablaModEstadoFaltante').slideUp('fast');

					pagina = 'sucursales/cajeroFaltantes.asp';
					div = 'cargaCajeroTablaFaltante';
					datos='periodo='+periodo+'&idUsuario='+idUsuario+'&idPerfil='+idPerfil+'&idSucursal='+idSucursal;
					enviaDatos(pagina,div,datos);
		        }, 2000);

		    }
	    }else{
	    	$('#msgModifcaEstadoFalt').html('<p style="color:red;"><b>SELECCIONE UN ESTADO</b></p>');
	    	setTimeout(function() {
	           	$('#msgModifcaEstadoFalt').html('');
		    }, 2000);
	    }
	});

	$('#btnVolverMenu').click(function(){
		$('#cargaCajeroTablaSobrante').slideDown('fast');
		$('#cajeroTablaModEstadoFaltante').slideUp('fast');
	});
</script>