<!--#include file="../funciones2.asp"-->
<%idSucursal = trim(request("idSucursalMain"))
idUsuarioMain = trim(request("idUsuarioMain"))
perfilMain = trim(request("perfilMain"))%>

<div id="idSucursalEnvio" data-idSucursalEnvio="<%=idSucursal%>"> </div>
<div id="idUsuarioMainEnvio" data-idUsuarioMainEnvio="<%=idUsuarioMain%>"> </div>
<div id="idPerfilMainEnvio" data-perfilMain="<%=perfilMain%>"> </div>

<div class="span12" id="divBsqNumCredNotario">
	<div class="row-fluid">
		<div class="span12">
			<%
			sql = ""
			sql = sql & " SELECT BB.*, (LEFT(BB.PERIODO, 4) + ' - ' + BB.MES) MM "
			sql = sql & " FROM ( "
			sql = sql & " 	SELECT AA.PERIODO, CASE CAST(RIGHT(AA.PERIODO,2) AS INT) "
			sql = sql & " 	WHEN 1 THEN 'ENERO' "
			sql = sql & " 	WHEN 2 THEN 'FEBRERO' "
			sql = sql & " 	WHEN 3 THEN 'MARZO' "
			sql = sql & " 	WHEN 4 THEN 'ABRIL' "
			sql = sql & " 	WHEN 5 THEN 'MAYO' "
			sql = sql & " 	WHEN 6 THEN 'JUNIO' "
			sql = sql & " 	WHEN 7 THEN 'JULIO' "
			sql = sql & " 	WHEN 8 THEN 'AGOSTO' "
			sql = sql & " 	WHEN 9 THEN 'SEPTIEMBRE' "
			sql = sql & " 	WHEN 10 THEN 'OCTUBRE' "
			sql = sql & " 	WHEN 11 THEN 'NOVIEMBRE' "
			sql = sql & " 	WHEN 12 THEN 'DICIEMBRE' "
			sql = sql & " 	END MES "
			sql = sql & " 	FROM( "
			sql = sql & " 		SELECT "
			sql = sql & " 		    CONVERT(VARCHAR(6), CC.fecha,112) AS PERIODO "
			sql = sql & " 		FROM SUC_notario_envio CC (nolock) "
			sql = sql & "		  GROUP BY CONVERT(VARCHAR(6), CC.fecha,112) ) AA) BB "
			sql = sql & " ORDER BY BB.PERIODO DESC "
			set rs = db.execute(sql)
			if not rs.eof then
				datosPeriodo = rs.getrows()
			end if
			%>
			<div class="span12">
				<div class="span4" id="divPeriodoEnvio">
					<select id="periodoEnvio" name="periodoEnvio">
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
				<div class="span1">
					<span class="btn btn-info" id="btnDescargaInformeQNotario" data-toggle="tooltip" title="Descargar Informe Notario">
						<i class="icon-download-alt"></i>
					</span>
				</div>
				<div class="span1">
					<div id="msgUpdAllRecepNoRecep"></div>
				</div>
			</div>
		</div>
	</div>
 </div>
<div class="row-fluid" id="bloqueListaEnvio">
	<div class="span12" id="listaEnvio">
		<span><img src="../cdn/img/loader.gif">Buscando Envio Notario</span>
	</div>
</div>
<script type="text/javascript">
	$(function(){
		var pagina, div, datos, idSucursalEnvio, periodoEnvio, idPerfilMainEnvio, idUsuarioMainEnvio;
		idSucursalEnvio = $('#idSucursalEnvio').attr('data-idSucursalEnvio');
		periodoEnvio = $('select#periodoEnvio option:selected').val();
		idPerfilMainEnvio = $('#idPerfilMainEnvio').attr('data-perfilMain');
		idUsuarioMainEnvio = $('#idUsuarioMainEnvio').attr('data-idUsuarioMainEnvio');
		pagina = 'report/listaEnvioNotario.asp';
		div = 'listaEnvio';
		datos='idSucursalEnvio='+idSucursalEnvio+'&periodoEnvio='+periodoEnvio+'&idPerfilMainEnvio='+idPerfilMainEnvio+'&idUsuarioMainEnvio='+idUsuarioMainEnvio;
		enviaDatos(pagina,div,datos);
	});

	$('#periodoEnvio').change(function(event) {
		$('#listarContenido').hide();
		var pagina, div, datos, idSucursalEnvio, periodoEnvio, idPerfilMainEnvio, idUsuarioMainEnvio;
		idSucursalEnvio = $('#idSucursalEnvio').attr('data-idSucursalEnvio');
		periodoEnvio = $('select#periodoEnvio option:selected').val();
		idPerfilMainEnvio = $('#idPerfilMainEnvio').attr('data-perfilMain');
		idUsuarioMainEnvio = $('#idUsuarioMainEnvio').attr('data-idUsuarioMainEnvio');
		pagina = 'report/listaEnvioNotario.asp';
		div = 'listaEnvio';
		datos='idSucursalEnvio='+idSucursalEnvio+'&periodoEnvio='+periodoEnvio+'&idPerfilMainEnvio='+idPerfilMainEnvio+'&idUsuarioMainEnvio='+idUsuarioMainEnvio;
		enviaDatos(pagina,div,datos);
	});
	$('#btnDescargaInformeQNotario').click(function() {
		var pagina, div, datos, idSucursalEnvio, periodoEnvio, idPerfilMainEnvio, idUsuarioMainEnvio;
		idSucursalEnvio = $('#idSucursalEnvio').attr('data-idSucursalEnvio');
		periodoEnvio = $('select#periodoEnvio option:selected').val();
		idPerfilMainEnvio = $('#idPerfilMainEnvio').attr('data-perfilMain');
		idUsuarioMainEnvio = $('#idUsuarioMainEnvio').attr('data-idUsuarioMainEnvio');
		$('#btnDescargaInformeQNotario').tooltip('show');
		location.href='report/informeListaQNotario.asp?idSucursalEnvio='+idSucursalEnvio+'&periodoEnvio='+periodoEnvio+'&idPerfilMainEnvio='+idPerfilMainEnvio+'&idUsuarioMainEnvio='+idUsuarioMainEnvio;
	});
</script>
