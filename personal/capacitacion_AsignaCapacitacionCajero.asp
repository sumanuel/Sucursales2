<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
perfilUsuario = trim(request("perfilUsuario"))%>
<%
	GlosaTbV1 = "Buscara la informacion asociada al rut, si se encuentra traera los datos, caso contrario debera ingresar a la persona a capacitar."
	GlosaTbV2 = "Limpia el contenido para poder realizar una nueva busqueda."
%>
<form class="form-inline" role="form" id="formIngresoCapacitacion" data-idUsuario="<%=idUsuario%>" data-perfilMain="<%=perfilMain%>" data-perfilUsuario="<%=perfilUsuario%>">
<div style="width: 80%; margin: 0 auto;">
	<div style="font-size: 20px;text-align: center; padding-bottom: 8px;color: #99b3ff"><b>Ingreso Capacitaciones</b></div>
		<div class="table-bordered" style="padding: 5px; border: 1px solid #cccccc;background-color: #e6e6ff;">		
		 	<span style="font-size: 14px;">
		 		<b>Rut :</b>
		 	</span> 
		 	<input type="text" id="txtRutCajero" onkeypress="return soloNumeros(event);" placeholder="Rut sin DV" maxlength="8" minlength="7" style="width: 100px;"> 
		 	<span style="font-size: 14px;">
		 		<b>-</b>
		 	</span> 
		 	<input type="text" id="txtDvCajero" onkeypress="return soloDV(event);" placeholder="DV" maxlength="1" minlength="1" style="width: 20px;">
			<button type="button" id="btnBuscarCapacitado" class="btn btn-info" data-toggle="popover" data-placement="bottom" title="Buscar" data-trigger="hover" data-content="<%=GlosaTbV1%>"><i class="icon-search"></i></button>
			<button type="button" id="btnLimpiarCapacitado" class="btn btn-info oculto" data-toggle="popover" data-placement="bottom" title="Limpiar" data-trigger="hover" data-content="<%=GlosaTbV2%>">Limpiar</button>
			<img id="gifCargandoAsignaCapacitacionCajero" class="oculto" src="../img/loading2.gif">
	</div>
	</br>
	<div id="AsignaCapacitacionCajero1"></div>
	<div id="AsignaCapacitacionCajero2"></div>
	<div id="AsignaCapacitacionCajeroError"></div>
</div>
</form>
<script type="text/javascript" src="../js/personal/valida_campos.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
	    $('[data-toggle="popover"]').popover({
	    	 html:true
	    });   
	});

	$('#btnBuscarCapacitado').click(function(){
		var validaRut = true;
		var valida = true;
		var mensaje = 'Error </br>';

		var idUsuario= $('#formIngresoCapacitacion').attr('data-idUsuario');
		var perfilMain= $('#formIngresoCapacitacion').attr('data-perfilMain');
		var perfilUsuario= $('#formIngresoCapacitacion').attr('data-perfilUsuario');
		var rut = $("#txtRutCajero").val();
		var dv = $("#txtDvCajero").val();
		validaRut = validarRut(rut,dv);

		if (($('#txtRutCajero').val() == "")){			
			mensaje	= mensaje + '- Debe ingresar el numero de rut sin digito verificador.</br>';
			valida = false;	
		}
		if ($('#txtDvCajero').val() == ""){			
			mensaje	= mensaje + '- Debe ingresar digito verificador</br>';
			valida = false;	
		}

		if (validaRut == false){
			mensaje	= mensaje + '- Favor ingresar un Rut Valido, El digito verificador no corresponde.</br>';
			valida = false;	
		}

		if(valida == false){	
			$('#AsignaCapacitacionCajeroError').html('<div class="alert alert-error text-rigth" id="msg" data-msg="2"><strong>'+mensaje+'</strong></div>');
			$('#AsignaCapacitacionCajeroError').show();
			setTimeout(function() {
				$('#AsignaCapacitacionCajeroError').slideUp('fast');
				$('#AsignaCapacitacionCajeroError').html('');
			}, 3000);
		}else{

			$('#AsignaCapacitacionCajero1').html('');
			$('#btnBuscarCapacitado').addClass('oculto');
			$('#btnLimpiarCapacitado').removeClass('oculto');
			$("#txtRutCajero").attr("disabled", true);
			$("#txtDvCajero").attr("disabled", true);

			var pagina, div, datos;
			pagina = 'capacitacion_AsignaCapacitacionCajero1.asp';
			div = 'AsignaCapacitacionCajero1';
			datos= 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&perfilUsuario='+perfilUsuario+'&rut='+rut+'&dv='+dv;
			enviaDatos(pagina,div,datos);

			$('#gifCargandoAsignaCapacitacionCajero').removeClass('oculto');	
		}		
	});

	$('#btnLimpiarCapacitado').click(function(){	
		$('#AsignaCapacitacionCajero1').html('');
		$('#AsignaCapacitacionCajero2').html('');	
		$('#btnLimpiarCapacitado').addClass('oculto');
		$('#btnBuscarCapacitado').removeClass('oculto');
		$("#txtRutCajero").attr("disabled", false);
		$("#txtDvCajero").attr("disabled", false);
		$("#txtRutCajero").val('');
		$("#txtDvCajero").val('');
	});


	function validarRut(numero,dv) {
    	var resultado;    	
        if(numero.length > 8) {
            resultado = false;
        } else {
            if(getDV(numero) == dv) {
            	resultado = true;
            }else{
            	resultado = false;            	
            };
        }
        return resultado;
    }

    function getDV(numero) {
        nuevo_numero = numero.toString().split("").reverse().join("");
        for(i=0,j=2,suma=0; i < nuevo_numero.length; i++, ((j==7) ? j=2 : j++)) {
            suma += (parseInt(nuevo_numero.charAt(i)) * j); 
        }
        n_dv = 11 - (suma % 11);
        return ((n_dv == 11) ? 0 : ((n_dv == 10) ? "K" : n_dv));
    };
</script>