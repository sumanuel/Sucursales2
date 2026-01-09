<!--#include file="../funciones2.asp"-->
<%
'idSucursalCaja = trim(request("idSucursalCaja"))
'idUsuarioMainCaja = trim(request("idUsuarioMainCaja"))
idSucursalCaja = trim(request("idSucursalMain"))
idUsuarioMainCaja = trim(request("idUsuarioMain"))
perfilMain = trim(request("perfilMain"))

%>
<div id="idSucursalCaja" data-idSucursalCaja="<%=idSucursalCaja%>"> </div>
<div id="idUsuarioMainCaja" data-idUsuarioMainCaja="<%=idUsuarioMainCaja%>"> </div>
<div id="idPerfilMain" data-perfilMain="<%=perfilMain%>"> </div>

<div class="row-fluid">
	<div class="span12">
	<%
		sql = ""
		sql = sql & " SELECT BB.*, (LEFT(BB.PERIODO, 4) + ' - ' + BB.MES) MM "
		sql = sql & " FROM ( "
		sql = sql & " SELECT AA.PERIODO, CASE CAST(RIGHT(AA.PERIODO,2) AS INT) "
		sql = sql & "		WHEN 1 THEN 'ENERO' "
		sql = sql & "		WHEN 2 THEN 'FEBRERO' "
		sql = sql & "		WHEN 3 THEN 'MARZO' "
		sql = sql & "		WHEN 4 THEN 'ABRIL' "
		sql = sql & "		WHEN 5 THEN 'MAYO' "
		sql = sql & "		WHEN 6 THEN 'JUNIO' "
		sql = sql & "		WHEN 7 THEN 'JULIO' "
		sql = sql & "		WHEN 8 THEN 'AGOSTO' "
		sql = sql & "		WHEN 9 THEN 'SEPTIEMBRE' "
		sql = sql & "		WHEN 10 THEN 'OCTUBRE' "
		sql = sql & "		WHEN 11 THEN 'NOVIEMBRE' "
		sql = sql & "		WHEN 12 THEN 'DICIEMBRE' "
		sql = sql & "	END MES "
		sql = sql & " FROM( "
		sql = sql & "	SELECT 	"
		sql = sql & "		CONVERT(VARCHAR(6), CC.fecha,112) AS PERIODO  "
		sql = sql & "		FROM SUC_vcc_caja CC (nolock) "
		sql = sql & "		GROUP BY CONVERT(VARCHAR(6), CC.fecha,112) ) AA) BB "
		sql = sql & "	ORDER BY BB.PERIODO DESC "
		set rs = db.execute(sql)
		if not rs.eof then
			datosPeriodo = rs.getrows()
		end if
		%>
		<div class="span12">
			<div class="row-fluid" id="bloqueBotonAbreFormCaja">
				<%if perfilMain = "1" then%>
					<div class="span1">
						<div class="btn btn-primary" id="btnCreaCaja" data-toggle="tooltip" title="Módulo Crea Caja">
							<span class="icon-plus-sign-alt icon-large"></span>
						</div>
					</div>
				<%end if%>
				<!--<div class="span1">
					<span class="label label-info mano" id="btnBuscarCaja">
						<span class="icon-search icon-2x"></span>
					</span>
				</div>-->
				<div class="span4" id="divPeriodoCaja">
					<select id="periodoCajas" name="periodoCajas">
						<option value="0">[Seleccione Período]</option>
						<%for i=0 to ubound(datosPeriodo,2)
							idPeriodo = datosPeriodo(0,i)
							nombrePeriodo= trim(datosPeriodo(2,i))
							seleccionado = ""
							if i = 0  then seleccionado = "selected"%>
								<option value="<%=idPeriodo%>" <%=seleccionado%>><%=nombrePeriodo%></option>
							<%next%>
					</select>
				</div>
				<div class="span4">
					<span class="btn btn-info" id="btnDescargaInformeQCaja" data-toggle="tooltip" title="Descargar Informe Caja">
						<i class="icon-download-alt"></i>
					</span>
				</div>
				<!--<div class="span5" id="btnBsqCaja" data-visible="0">
					<div class="span3">
						<span class="btn btn-success " id="btnBuscaCaja">
							<span id="iconBtnBuscaCaja"></span> Buscar
						</span>
					</div>
					<div class="span1">
						<input type="text" id="txtCajaBsq" placeholder="Código de Barras">
					</div>
				</div>-->
				<div>
					<span id="msjBsq" class="label label-warning"></span>
					<span id="cargaValorCaja" ><img src="../cdn/img/loading.gif"></span>
					<div id="msjBsqCaja"></div>
					<div id="valorBsqCaja"></div>
				</div>
			</div>
				<p>
					<div class="row-fluid" id="bloqueBotonACierraFormCaja">
						<div class="btn btn-danger" id="btnCierraFormCaja" onClick="cierraForm()" data-toggle="tooltip" title="Volver a Módulo Caja">
							<i class="icon-remove-sign icon-large"></i>
						</div>
					</div>
				</p>
				<div class="row-fluid" id="bloqueFormCaja">
					<div class="span12" id="formularioCajas">
				</div>
			</div>
		</div>
	</div>
	<!--<div class="span6">
		<div class="row-fluid" id="bloqueBotonVolverGrafico">
			<div class="span2 btn btn-success" id="btnVolverGrafico" onclick="volverGrafico()">
					<i class="icon-bar-chart icon-2x"></i>
					<i class="icon-arrow-left icon-4x"></i>
			</div>
		</div>
	</div>-->
</div>

<div class="row-fluid" id="bloqueListaCajas">
	<div class="span12" id="listaCajas">
		<span><img src="../cdn/img/loader.gif"> Buscando cajas </span>
	</div>
</div>
<script type="text/javascript">
	$(function(){
		$('#btnBsqCaja').hide();
		$('#cargaValorCaja').slideUp('fast');
		var idSucursalCaja = $('#idSucursalCaja').attr('data-idSucursalCaja');
		var periodo = $('select#periodoCajas option:selected').val();
		var idPerfilMain = $('#idPerfilMain').attr('data-perfilMain');
		$('#bloqueFormCaja, #bloqueBotonACierraFormCaja').hide();
		var pagina, div, datos;
		pagina = 'report/listaCajas.asp';
		div = 'listaCajas';
		datos='idSucursalCaja='+idSucursalCaja+'&periodo='+periodo+'&idPerfilMain='+idPerfilMain;
		enviaDatos(pagina,div,datos);
	});
	$('#periodoCajas').change(function(){
		//var periodo = $('#periodoCajas').val();
		var idSucursalCaja = $('#idSucursalCaja').attr('data-idSucursalCaja');
		var periodo = $('select#periodoCajas option:selected').val();
		var idPerfilMain = $('#idPerfilMain').attr('data-perfilMain');

		$('#listaCajas').html('');
		var pagina, div, datos;
		pagina = 'report/listaCajas.asp';
		div = 'listaCajas';
		datos='idSucursalCaja='+idSucursalCaja+'&periodo='+periodo+'&idPerfilMain='+idPerfilMain;
		enviaDatos(pagina,div,datos);
	});

	$('#btnDescargaInformeQCaja').click(function(){
		var idSucursalCaja = $('#idSucursalCaja').attr('data-idSucursalCaja');
		var periodo = $('select#periodoCajas option:selected').val();
		var idPerfilMain = $('#idPerfilMain').attr('data-perfilMain');
		$('#btnDescargaInformeQCaja').tooltip('show');
		location.href='report/informeListaQCajas.asp?idSucursalCaja='+idSucursalCaja+'&periodo='+periodo+'&idPerfilMain='+idPerfilMain;
	});

	$('#btnCreaCaja').click(function() {
		var idUsuarioMainCaja = <%=idUsuarioMainCaja%>;
		var idSucursalCaja = $('#idSucursalCaja').attr('data-idSucursalCaja');
		var periodo = $('select#periodoCajas option:selected').val();
		var idPerfilMain = $('#idPerfilMain').attr('data-perfilMain');

		$('#listaCajas').html('');
		$('#bloqueListaCajas, #bloqueBotonAbreFormCaja, #listarContenido').slideUp('fast');
		$('#btnCreaCaja').tooltip('show');
		$('#bloqueBotonACierraFormCaja, #bloqueFormCaja').slideDown('fast');
		var pagina, div, datos;
		pagina = 'report/formularioCajas.asp';
		div = 'formularioCajas';
		datos = 'idUsuarioMainCaja='+idUsuarioMainCaja+'&idSucursalCaja='+idSucursalCaja+'&periodo='+periodo+'&idPerfilMain='+idPerfilMain;
		enviaDatos(pagina,div,datos);
	});

	function cierraForm(){
		var idSucursalCaja = $('#idSucursalCaja').attr('data-idSucursalCaja');
		var periodo = $('select#periodoCajas option:selected').val();
		var idPerfilMain = $('#idPerfilMain').attr('data-perfilMain');
		$('#bloqueBotonACierraFormCaja, #bloqueFormCaja').slideUp('fast');
		$('#bloqueListaCajas, #bloqueBotonAbreFormCaja').slideDown('slow');
		var pagina, div, datos;
		pagina = 'report/listaCajas.asp';
		div = 'listaCajas';
		datos='idSucursalCaja='+idSucursalCaja+'&periodo='+periodo+'&idPerfilMain='+idPerfilMain;
		enviaDatos(pagina,div,datos);
	}

	$('#btnBuscarCaja').click(function() {
		$('#txtCajaBsq').val('');
		var verBsqCaja = $('#btnBsqCaja').attr('data-visible');
		if (parseInt(verBsqCaja) === 0){
			$('#btnBsqCaja').slideDown('fast');
			$('#btnBsqCaja').attr('data-visible','1');
			$(this).html('<span class="icon-reply icon-2x"></span>').removeClass('label-info').addClass('label-important');
		}else{
			$('#btnBsqCaja').hide();
			$('#btnBsqCaja').attr('data-visible','0');
			$(this).html('<span class="icon-search icon-2x"></span>').removeClass('label-important').addClass('label-info');
		}
	});
	$('#btnBuscaCaja').click(function() {
		var valorCajaBsq = $('#txtCajaBsq').val();
		var idSucursalCaja = $('#idSucursalCaja').attr('data-idSucursalCaja');
		if (valorCajaBsq !== ""){
			var pagina, div, datos;
			pagina = 'report/buscaValorCaja.asp';
			div = 'valorBsqCaja';
			datos ='action=2&idSucursalCaja='+idSucursalCaja+'&valorCajaBsq='+valorCajaBsq;
			enviaDatos(pagina,div,datos);
		}else{
			$('#btnBsqCaja').hide();
			$('#msjBsq').slideDown('fast');
			$('#msjBsq').html('DEBE INGRESAR UNA CAJA VALIDA.');
			$('#txtCajaBsq').focus();
			setTimeout(function() {
				$('#msjBsq').hide();
				$('#btnBsqCaja').slideDown('fast');
			}, 1700);
		}

	});
</script>
