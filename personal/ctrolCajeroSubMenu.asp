<!--#include file="../funciones.asp"-->
<%
Session.LCID = 13322

perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))

sql = "" 
	sql = sql &	" SELECT B.periodo, CONVERT(VARCHAR,LEFT(B.periodo,4))+' - '+B.MES "
	sql = sql & " 	FROM( "
	sql = sql & " 		SELECT A.PERIODO, CASE CAST(RIGHT(A.PERIODO,2) AS INT) "
	sql = sql & " 				WHEN 1 THEN 'ENERO'  "
	sql = sql & " 				WHEN 2 THEN 'FEBRERO' "
	sql = sql & " 				WHEN 3 THEN 'MARZO'  "
	sql = sql & " 				WHEN 4 THEN 'ABRIL' "
	sql = sql & " 				WHEN 5 THEN 'MAYO' "
	sql = sql & " 				WHEN 6 THEN 'JUNIO' "
	sql = sql & " 				WHEN 7 THEN 'JULIO' "
	sql = sql & " 				WHEN 8 THEN 'AGOSTO' "
	sql = sql & " 				WHEN 9 THEN 'SEPTIEMBRE' "
	sql = sql & " 				WHEN 10 THEN 'OCTUBRE' "
	sql = sql & " 				WHEN 11 THEN 'NOVIEMBRE' "
	sql = sql & " 				WHEN 12 THEN 'DICIEMBRE' "
	sql = sql & " 			END MES "
	sql = sql & " 		FROM( "
	sql = sql & " 			 SELECT CONVERT(VARCHAR(6),fecha_respaldo,112) AS PERIODO "
	sql = sql & " 			  FROM SUC_sucursal_ASistencia_personal_respaldo CC (nolock) "
	sql = sql & "             WHERE YEAR(fecha_respaldo) >= '2016'                  "
	sql = sql & " 			 GROUP BY CONVERT(VARCHAR(6),fecha_respaldo,112))A  "		
	sql = sql & " 	)B "
	sql = sql & "  ORDER BY B.periodo DESC "
	set rs = db.execute(sql)
	if not rs.eof then 
		datos = rs.getrows()
	end if
%>
<div class="span12">
	<div class="span12" id="divSubMenuHoyPeriodo">
		<ul class="nav nav-tabs" id="subMenuHoyPeriodo"  data-perfilMain="<%=perfilMain%>" data-idUsuario="<%=idUsuario%>">
			<li id="idHoy" data-perfilMain="<%=perfilMain%>" data-idUsuario="<%=idUsuario%>">
				<a href="#">
					Hoy
				</a>
			</li>
			<li id="idPeriodo" data-perfilMain="<%=perfilMain%>" data-idUsuario="<%=idUsuario%>">
				<a href="#">
					Periodo
				</a>
			</li> 
		</ul>
	</div>
</div>
<div class="row-fluid text-center" id="divPeriodo">
	<div class="controls">
		<div class="input-append">
		    <select id="seleccionaPeriodo" name="seleccionaPeriodo">
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
<!--		    <span class="add-on btn btn-info" id="btnDescarga" data-toggle="tooltip" title="Descargar Informe">
				<i class="icon-download-alt"></i>
			</span>-->
		</div>
	</div>	
</div>

<script type="text/javascript">
	$(function(){
		$('#ctrolCajeroCargaTabla, #ctrolCajeroCargaTablaAdicion, #ctrolCajeroCargaTablaDetalle, #ctrolCajeroCargaGrafico').html('');
		$('#divPeriodo').hide();
		$('#ctrolCajeroCargaTabla').html('');
		$('ul#subMenuHoyPeriodo > li').each(function(){
			$(this).removeClass('active');
		});
		$('ul#subMenuHoyPeriodo li').first().addClass('active');
		var pagina, div, datos, idUsuario, perfilMain;
		periodo = $('#seleccionaPeriodo').val();
		idUsuario = $('#subMenuHoyPeriodo').attr('data-idUsuario');
		perfilMain = $('#subMenuHoyPeriodo').attr('data-perfilMain');
		pagina = 'ctrolCajeroTablaTotalAsistenciaProveedorHoy.asp';
		div = 'ctrolCajeroCargaTabla';
		datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&periodo='+periodo;
		enviaDatos(pagina,div,datos);
		
		pagina = 'ctrolCajeroTablaTotalAsitenciaAdicionProveeHoy.asp';
		div = 'ctrolCajeroCargaTablaAdicion';
		datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain;
		enviaDatos(pagina,div,datos)

		pagina = 'ctrolCajeroDescargaArchivoAtrasos.asp';
		div = 'subMenuCtrolCajeroHoyPeri';
		datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&tipoDescarga=1';
		enviaDatos(pagina,div,datos);




	});

	$('li#idHoy').click(function(){
		$('#divPeriodo').hide();
		$('#ctrolCajeroCargaTabla').html('');		
		$('#ctrolCajeroCargaTablaDetalleMod').hide();
		$('#ctrolCajeroTablaSucursal').hide();
		$('#ctrolCajeroTablaSucursalAsist').hide();

		$('ul#subMenuHoyPeriodo > li').each(function(){
			$(this).removeClass('active');
		});
		
		$('li#idHoy').addClass('active');
		var pagina, div, datos, periodo, idUsuario, perfilMain;
		idUsuario = $('#idHoy').attr('data-idUsuario');
		perfilMain = $('#idHoy').attr('data-perfilMain');
		pagina = 'ctrolCajeroTablaTotalAsistenciaProveedorHoy.asp';
		div = 'ctrolCajeroCargaTabla';
		datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain;
		enviaDatos(pagina,div,datos);
	
		pagina = 'ctrolCajeroTablaTotalAsitenciaAdicionProveeHoy.asp';
		div = 'ctrolCajeroCargaTablaAdicion';
		datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain;
		enviaDatos(pagina,div,datos);

		pagina = 'ctrolCajeroDescargaArchivoAtrasos.asp';
		div = 'subMenuCtrolCajeroHoyPeri';
		datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&tipoDescarga=1';
		enviaDatos(pagina,div,datos);

		$('#ctrolCajeroCargaTabla, #ctrolCajeroCargaTablaAdicion, #ctrolCajeroCargaTablaDetalle, #ctrolCajeroCargaGrafico').html('');
		$('#ctrolCajeroPeriodoDetalle').hide();
	});

	$('li#idPeriodo').click(function(){		
		$('#ctrolCajeroCargaTablaDetalleMod').hide();
		$('#ctrolCajeroTablaSucursal').hide();
		$('#ctrolCajeroTablaSucursalAsist').hide();

		$('ul#subMenuHoyPeriodo > li').each(function(){
			$(this).removeClass('active');
		});
		$('#ctrolCajeroCargaTabla, #ctrolCajeroCargaTablaAdicion, #ctrolCajeroCargaTablaDetalle, #ctrolCajeroCargaGrafico').html('');
		$('li#idPeriodo').addClass('active');
		$('#divPeriodo').show();
		var pagina, div, datos, periodo;
		periodo = $('#seleccionaPeriodo').val();
		idUsuario = $('#idPeriodo').attr('data-idUsuario');
		perfilMain = $('#idPeriodo').attr('data-perfilMain');
		pagina = 'ctrolCajeroTablaAsistProveePeriodo.asp';
		div = 'ctrolCajeroCargaTabla';
		datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&periodo='+periodo;
		enviaDatos(pagina,div,datos);

		pagina = 'ctrolCajeroDescargaArchivoAtrasos.asp';
		div = 'subMenuCtrolCajeroHoyPeri';
		datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&tipoDescarga=2&periodo='+periodo;
		enviaDatos(pagina,div,datos);

		setTimeout(function() {
			pagina = 'ctrolCajeroTablaAsistProveeAdicioPeriodo.asp';
			div = 'ctrolCajeroCargaTablaAdicion';
			datos='periodo='+periodo+'&idUsuario='+idUsuario;
			enviaDatos(pagina,div,datos);
		},10);
		
	});

	$('#seleccionaPeriodo').change(function(){		
		$('#ctrolCajeroCargaTablaDetalleMod').hide();
		$('#ctrolCajeroTablaSucursal').hide();
		$('#ctrolCajeroTablaSucursalAsist').hide();
		$('#ctrolCajeroPeriodoDetalle').hide();
		
		var pagina, div, datos, periodo, idUsuario, perfilMain;
		idUsuario = $('#divTablaPeriodo').attr('data-idUsuario');
		perfilMain = $('#divTablaPeriodo').attr('data-perfilMain');
		periodo = $('#seleccionaPeriodo').val();
		pagina = 'ctrolCajeroTablaAsistProveePeriodo.asp';
		div = 'ctrolCajeroCargaTabla';
		datos='periodo='+periodo+'&idUsuario='+idUsuario+'&perfilMain='+perfilMain;
		enviaDatos(pagina,div,datos); 

		pagina = 'ctrolCajeroDescargaArchivoAtrasos.asp';
		div = 'subMenuCtrolCajeroHoyPeri';
		datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&tipoDescarga=2&periodo='+periodo;
		enviaDatos(pagina,div,datos);


		$('#ctrolCajeroCargaTablaDetalle, #ctrolCajeroCargaGrafico').html('');
		setTimeout(function() {
			pagina = 'ctrolCajeroTablaAsistProveeAdicioPeriodo.asp';
			div = 'ctrolCajeroCargaTablaAdicion';
			datos='periodo='+periodo+'&idUsuario='+idUsuario;
			enviaDatos(pagina,div,datos);
		},5);
	});
</script>