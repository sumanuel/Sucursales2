<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
perfilUsuario = trim(request("perfilUsuario"))
rut = trim(request("rut"))
dv = trim(request("dv"))


sql = ""
sql = sql + "exec SCSS_prc_capa_get_box 1"
set rs = db.execute(sql)
if not rs.eof then
	datosProveedor = rs.getrows()
end if


sql2 = ""
sql2 = sql2 + "exec SCSS_prc_capa_get_box 2"
set rs1 = db.execute(sql2)
if not rs1.eof then
	datosTipoPersonal = rs1.getrows()
end if

sql3= ""
sql3 = sql3 + "exec SCSS_prc_capa_get_personal_capacitado " + rut + "," + dv + " "
set rs3 = db.execute(sql3)
if not rs3.eof then
	datosPersonal = rs3.getrows()
	for i = 0 to ubound(datosPersonal,2)
		datosPersonal1 = server.htmlencode(trim(datosPersonal(0,i)))
		datosPersonal2 = server.htmlencode(trim(datosPersonal(1,i)))
		datosPersonal3 = server.htmlencode(trim(datosPersonal(2,i)))
		datosPersonal4 = server.htmlencode(trim(datosPersonal(3,i)))
	next
end if

GlosaAC1 = "Al precionar capacitar, se guardaran los datos nuevo y editados de forma automatica, y estos seran utilizados en los nuevos formularios. </br></br> <b>Este botón despliega el formulario para asignar capacitación.</b>"
GlosaAC2 = "Al precionar editar, se activaran nuevamente los campos para poder realizar la asignacion con las correcciones."

GlosaObligatorio = "Campo Obligatorio."
%>
<form class="form-inline" role="form" id="formTablaIngresoCapacitacion" data-idUsuario="<%=idUsuario%>" data-perfilMain="<%=perfilMain%>" data-perfilUsuario="<%=perfilUsuario%>" data-rut="<%=rut%>" data-dv="<%=dv%>">
	<div>
		<table id="tableDatosPersonalCapacitado" class="table table-bordered table-conde" style="background: #f2f2f2; border: 1px solid #cccccc" data-datosPersonal1="<%=datosPersonal1%>" data-datosPersonal2="<%=datosPersonal2%>" data-datosPersonal3="<%=datosPersonal3%>" data-datosPersonal4="<%=datosPersonal4%>">
			<tr >
				<td style="width: 150px;"><b>Nombre Persona*</b></td>
				<td colspan="3">
					<input type="text" id="txtNombreAC" onkeypress="return soloLetras(event);" placeholder="Nombres" maxlength="250" minlength="10" style="width: 95%;"> 
					<span id="iconObligatorioNP" class="oculto" data-toggle="popover" data-placement="bottom" data-trigger="hover" data-content="<%=GlosaObligatorio%>"><i class="icon-warning-sign" style="color:red;"></i></span>
				</td>
			</tr>
			<tr >
				<td style="width: 130px;"><b>Tipo Capacitación*</b></td>
				<td>
					<select name="boxTipo" id="cboTipoAC" style="width: 90%">
						<option value="0">Seleccione Tipo</option>			
						<%for i = 0 to ubound(datosTipoPersonal,2)
							datosTipoPersonal1 = server.htmlencode(trim(datosTipoPersonal(0,i)))
							datosTipoPersonal2 = server.htmlencode(trim(datosTipoPersonal(1,i)))%>
							<option value="<%=datosTipoPersonal1%>"><%=datosTipoPersonal2%></option>	
						<%next%> 
					</select>
					<span id="iconObligatorioTP" class="oculto" data-toggle="popover" data-placement="bottom" data-trigger="hover" data-content="<%=GlosaObligatorio%>"><i  class="icon-warning-sign" style="color:red;" ></i></span>
				</td>
				<td><b>Empresa</b></td>
				<td>
					<select name="boxEmpresa" id="cboEmpresaAC" style="width: 90%">
						<option value="0">Sin Empresa</option>			
						<%for i = 0 to ubound(datosProveedor,2)
							datosProveedor1 = server.htmlencode(trim(datosProveedor(0,i)))
							datosProveedor2 = server.htmlencode(trim(datosProveedor(1,i)))%>
							<option value="<%=datosProveedor1%>"><%=datosProveedor2%></option>	
						<%next%> 	
					</select>
				</td>	
			</tr>
			<tr >
				<td colspan="3" style="text-align: left;">
					<div id="msgAsignaCapacitacionCajero1"></div>
				</td>
				<td style="text-align: right; border-left: 0px;">
					<img id="gifCargandoAsignaCapacitacionCajero1" class="oculto" src="../img/loading2.gif"> <button type="button" class="btn btn-warning oculto" id="btnEditarAC" data-toggle="popover" data-placement="bottom" title="Editar" data-trigger="hover" data-content="<%=GlosaAC2%>">Editar Campos</button> <button type="button" class="btn btn-primary" id="btnCapacitarAC" data-toggle="popover" data-placement="bottom" title="Capacitar" data-trigger="hover" data-content="<%=GlosaAC1%>">Capacitar</button>
				</td>
			</tr>
		</table>	
	</div>	
	<div id="AsignaCapacitacionCajero1Error"></div>
</form>
<script type="text/javascript" src="../js/personal/valida_campos.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
	    $('[data-toggle="popover"]').popover({
	    	 html:true
	    });   
	});

	$(function(){		
		var idUsuario= $('#formTablaIngresoCapacitacion').attr('data-idUsuario');
		var perfilMain= $('#formTablaIngresoCapacitacion').attr('data-perfilMain');
		var perfilUsuario= $('#formTablaIngresoCapacitacion').attr('data-perfilUsuario');
		var rut= $('#formTablaIngresoCapacitacion').attr('data-rut');
		var dv= $('#formTablaIngresoCapacitacion').attr('data-dv');
		var datosPersonal1= $('#tableDatosPersonalCapacitado').attr('data-datosPersonal1');
		
		if (datosPersonal1 == 'SI') {
			var datosPersonal2= $('#tableDatosPersonalCapacitado').attr('data-datosPersonal2');
			var datosPersonal3= $('#tableDatosPersonalCapacitado').attr('data-datosPersonal3');
			var datosPersonal4= $('#tableDatosPersonalCapacitado').attr('data-datosPersonal4');

			$('#txtNombreAC').val(datosPersonal2);
			$('#cboTipoAC').val(datosPersonal3);
			$('#cboEmpresaAC').val(datosPersonal4);

			$('#msgAsignaCapacitacionCajero1').html('<p style="color:green;"><b>Rut en sistema, puede modificar datos y asignar capacitación</b></p>');

			$('#gifCargandoAsignaCapacitacionCajero').addClass('oculto');

		}else if(datosPersonal1 == 'NO'){			

			$('#msgAsignaCapacitacionCajero1').html('<p style="color:red;"><b>Rut no Existe se encuentra en sistema, favor ingresar los datos y guardar con capacitar</b></p>');

			$('#gifCargandoAsignaCapacitacionCajero').addClass('oculto');
		}

		//alert(datosPersonal1);

	});

	$('#btnCapacitarAC').click(function(){
		$('#gifCargandoAsignaCapacitacionCajero1').removeClass('oculto');	
		var valida = true;
		var mensaje = 'Error </br>';

		var idUsuario= $('#formTablaIngresoCapacitacion').attr('data-idUsuario');
		var perfilMain= $('#formTablaIngresoCapacitacion').attr('data-perfilMain');
		var perfilUsuario= $('#formTablaIngresoCapacitacion').attr('data-perfilUsuario');
		var rut= $('#formTablaIngresoCapacitacion').attr('data-rut');
		var dv= $('#formTablaIngresoCapacitacion').attr('data-dv');

		$('#iconObligatorioNP').addClass('oculto');
		$('#iconObligatorioTP').addClass('oculto');



		if (($('#txtNombreAC').val() == "")){			
			mensaje	= mensaje + '- Debe ingresar un nombre para indentificar a la persona.</br>';
			valida = false;	
			$('#iconObligatorioNP').removeClass('oculto');
		}
		if($('select#cboTipoAC option:selected').val() == 0){
			valida = false;
			$('#iconObligatorioTP').removeClass('oculto');
			mensaje = mensaje + '</br> - Debe seleccionar un Tipo Personal para identificar al capacitado (Practicante/Cajero).';
		};	

		if(valida == false){	
			$('#gifCargandoAsignaCapacitacionCajero1').addClass('oculto');	

			$('#AsignaCapacitacionCajero1Error').html('<div class="alert alert-error text-rigth" id="msg" data-msg="2"><strong>'+mensaje+'</strong></div>');
			$('#AsignaCapacitacionCajero1Error').show();
			setTimeout(function() {
				$('#AsignaCapacitacionCajero1Error').slideUp('fast');
				$('#AsignaCapacitacionCajero1Error').html('');
			}, 3000);
		}else{
			$('#AsignaCapacitacionCajero2').html('');

			var nombrePersona= $('#txtNombreAC').val();
			var tipoPersonal= $('select#cboTipoAC option:selected').val();
			var empresa= $('select#cboEmpresaAC option:selected').val();
			var tipoIngreso = 1;

			var urlDatos ='capacitacion_AsignaCapacitacionCajero_datos.asp';
			var datosRespuesta = '';
			var mensaje = '';
			$.when($.ajax({url:urlDatos,data:{'idUsuario':idUsuario, 'perfilMain':perfilMain,'perfilUsuario':perfilUsuario,'rut':rut, 'dv':dv, 'nombrePersona':nombrePersona, 'tipoPersonal':tipoPersonal, 'empresa':empresa, 'tipoIngreso':tipoIngreso},method:'GET'})).then(function(datos) {
				$.each(datos.datosRespuestaAC1, function(key,valorRespuesta){
					mensaje = valorRespuesta.mensaje;
						datosRespuesta += '<p style="color:green;"><b>'+mensaje+'</b></p>';
				});

				$('#msgAsignaCapacitacionCajero1').html(datosRespuesta);

				var pagina, div, datos;
				pagina = 'capacitacion_AsignaCapacitacionCajero2.asp';
				div = 'AsignaCapacitacionCajero2';
				datos= 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&rut='+rut+'&dv='+dv;
				enviaDatos(pagina,div,datos);		
			
				$('#gifCargandoAsignaCapacitacionCajero1').addClass('oculto');	
				$('#txtNombreAC').attr("disabled", true);
				$('#cboTipoAC').attr("disabled", true);
				$('#cboEmpresaAC').attr("disabled", true);
				$('#btnCapacitarAC').addClass('oculto');	
				$('#btnEditarAC').removeClass('oculto');	
				$('#AsignaCapacitacionCajero2').get(0).scrollIntoView(true);
			});			
		}		
	});

	$('#btnEditarAC').click(function(){
		$('#AsignaCapacitacionCajero2').html('');
		$('#txtNombreAC').attr("disabled", false);
		$('#cboTipoAC').attr("disabled", false);
		$('#cboEmpresaAC').attr("disabled", false);
		$('#btnEditarAC').addClass('oculto');	
		$('#btnCapacitarAC').removeClass('oculto');
		$('#msgAsignaCapacitacionCajero1').html('<p style="color:red;"><b>Campos habilitados para realizar cambios.</b></p>');
	});

</script>

