<!--#include file="../funciones2.asp"-->
<%idSucursalMain = trim(request("idSucursalMain"))
idUsuarioMain = trim(request("idUsuarioMain"))
perfilMain = trim(request("idPerfilMain"))%>
<div class="row-fluid">
	<div class="span7">
		<%sql = ""
		sql = sql & " EXEC SCSS_prc_obtiene_periodo_carpeta_credito "
		set rs = db.execute(sql)
		if not rs.eof then
			datos = rs.getrows()
		end if%>
		<div class="row-fluid">
			<div class="span2">
				Periodo
			</div>
			<div class="span1">:</div>
			<div class="span9">
			<select id="seleccionaPeriodo" name="seleccionaPeriodo" class="span11">
				<option value="0">[ Seleccione periodo ]</option>
				<%for i = 0 to ubound(datos,2)
					idPeriodo = datos(0,i)
					nombrePeriodo= trim(datos(1,i))
				    'mesFecha = datos(1,i)
					'anioFecha = datos(0,i)
					seleccionado = ""
					if i = 0  then seleccionado = "selected"%>
					<option value="<%=idPeriodo%>" <%=seleccionado%>><%=nombrePeriodo%></option>
				<%next%>
			</select>
		</div>
	</div>
</div>

<div class="row-fluid">
	<div class="span4" id="bloqueBotonMuestraCajas" data-muestra="0">
	<%if perfilMain <> "3" then%>
		<div class="btn btn-primary" id="muestraCajas" data-toggle="tooltip" title="Módulo Caja">
			<i class="icon-archive icon-large"></i>
		</div>
	<%end if%>
		<div class="btn btn-warning" id="actualizaTabla" data-toggle="tooltip" title="Actualiza Indicadores">
			<i class="icon-refresh icon-large" id="iconActualizaIndicadores"></i>
		</div>
		<div class="span4 oculto" id="bloqueBotonMuestraNotario" data-muestraNotario="0" >
			<div class="btn btn-danger" id="botonMuestraNotario" data-toggle="tooltip" title="Módulo Notario">
				<i class="icon-briefcase icon-large" id="idBotonNotario" ></i>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	var pagina, div, datos, periodo;
	periodo = $('#seleccionaPeriodo').val();
	pagina = 'report/reporteTotalTablaAlerta.asp';
	div = 'reporteTotalTablaAlerta';
	datos='periodo='+periodo;
	enviaDatos(pagina,div,datos);

});

$('#seleccionaPeriodo').change(function(){
	var pagina, div, datos, periodo;
	periodo = $('#seleccionaPeriodo').val();
	pagina = 'report/reporteTotalTablaAlerta.asp';
	div = 'reporteTotalTablaAlerta';
	datos = 'periodo='+periodo;
	enviaDatos(pagina,div,datos);
	$('#divMenuTrabPens, #divMuestraCaja, #divReporteDetalleTabla, #listarContenido').slideUp('fast');
	$('#bloqueBotonMuestraCajas').attr('data-muestra','0');
		$('#muestraCajas').html('<i class="icon-archive icon-large"></i>').removeClass('btn btn-success').addClass('btn btn-primary');;
	pagina = 'report/menuColoTipoTrabPens2.asp';
	div = 'menuTipoTrabPens';
	datos='periodo='+periodo;
	enviaDatos(pagina,div,datos);

});

$('#muestraCajas').click(function(){
	$('#muestraCajas').tooltip('show');
	var verCaja = $('#bloqueBotonMuestraCajas').attr('data-muestra');
	if (verCaja === "0"){
		$('#bloqueBotonMuestraCajas').attr('data-muestra','1');
		$('#reporteTotalGraficoAlerta').slideUp('fast');
		$('#divMuestraCaja').slideDown('fast');
		$('#divMuestraCaja').slideUp('slow');
		//$('#muestraCajas').html('<div class="span4 btn btn-success"><i class="icon-bar-chart icon-large"></i></div>');
		$('#muestraCajas').html('<i class="icon-bar-chart icon-large"></i>').removeClass('btn btn-primary').addClass('btn btn-success');
		var pagina, div, datos;
		pagina = 'report/cajas.asp';
		div = 'divMuestraCaja';
		datos='';
		enviaDatos(pagina,div,datos);
	}else{
		cargaGrafico(); //Se agrega para actualizar los graficos una vez que la caja queda en estado enviado
		$('#bloqueBotonMuestraCajas').attr('data-muestra','0');
		$('#muestraCajas').html('<i class="icon-archive icon-large"></i>').removeClass('btn btn-success').addClass('btn btn-primary');
		$('#divMuestraCaja, #listarContenido, #divMuestraCaja').slideUp('fast');
		$('#reporteTotalGraficoAlerta').slideDown('fast');
	}
});

$('#botonMuestraNotario').click(function(){
	$('#botonMuestraNotario').tooltip('show');
	var verNotario = $('#bloqueBotonMuestraNotario').attr('data-muestraNotario');
	if(verNotario === '0'){
		$('#reporteTotalGraficoAlerta').slideUp('fast');
		$('#divMuestraCaja').slideDown('fast');
		$('#bloqueBotonMuestraNotario').attr('data-muestraNotario','1');
		var pagina, div, datos;
		pagina = 'report/menuNotario.asp';
		div = 'divMuestraCaja';
		datos='';
		enviaDatos(pagina,div,datos);
	}else{
		$('#divMuestraCaja').slideUp('fast');
		$('#bloqueBotonMuestraNotario').attr('data-muestraNotario','0');
		$('#reporteTotalGraficoAlerta').slideDown('slow');
		$('#divMuestraCaja, #listarContenido, #divMuestraCaja').slideUp('fast');
	}
});


$('#actualizaTabla').click(function(){
	$('#actualizaTabla').tooltip('show');
	cargaIndicadores();
	$('#reporteDetalleTabla').slideUp('fast');
	$('#menuTrabPens').slideUp('fast');
	$('#bloqueBotonMuestraCajas').attr('data-muestra','0');
		$('#muestraCajas').html('<i class="icon-archive icon-large"></i>').removeClass('btn btn-success').addClass('btn btn-primary');;
	$('#divMuestraCaja, #listarContenido').slideUp('fast');
	$('#iconActualizaIndicadores').addClass('icon-spin');
	setTimeout(function() {
		$('#iconActualizaIndicadores').removeClass('icon-spin');
	}, 2500);
});
</script>
