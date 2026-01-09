<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))

sql = "" 
	sql = sql &	" SELECT  B.periodo, CONVERT(VARCHAR,LEFT(B.periodo,4))+' - '+B.MES "
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
	sql = sql & " 			 SELECT PERIODO "
	sql = sql & " 			  FROM SUC_cajeros_dimen CC (nolock) "
	sql = sql & " 			 GROUP BY PERIODO)A  "
	sql = sql & " 	)B "
	sql = sql & "  ORDER BY B.periodo DESC "
	set rs = db.execute(sql)
	if not rs.eof then 
		datos = rs.getrows()
	end if


	
	sql2 = "" 
	sql2 = sql2 & " SELECT COUNT(0) AS Q FROM SUC_cajeros_dimen "
	sql2 = sql2 & " WHERE periodo = CONVERT(VARCHAR(6),DATEADD(MONTH,1,GETDATE()),112) "
	set rs = db.execute(sql2)
	if not rs.eof then 
		existe = trim(rs(0))
	end if

%>
<div class="span12">
	<div class="span12" id="divSubMenuDimPeriodo">
		<ul class="nav nav-tabs" id="subMenuDimPeriodo"  data-perfilMain="<%=perfilMain%>" data-idUsuario="<%=idUsuario%>">
			<li id="idHoy" data-perfilMain="<%=perfilMain%>" data-idUsuario="<%=idUsuario%>">
				<a href="#">
					Dim
				</a>
			</li>
			<li id="idPeriodo" data-perfilMain="<%=perfilMain%>" data-idUsuario="<%=idUsuario%>">
				<a href="#">
					Dim2
				</a>
			</li> 
		</ul>
	</div>
</div>

<div class="row-fluid text-center" id="divPeriodoDim">
	<div class="controls">
		<div class="input-append">
			<%if existe = 0 then%>
			    <span class="btn btn-success" id="replicaDimensi"  data-toggle="tooltip" title="Replica Dimensionamiento">
					<i class="icon-copy"></i>
				</span>

			<%else%>
				<span class="btn btn-danger" id="eliminaReplicaDime"  data-toggle="tooltip" title="Borrar Replica Dim">
					<i class="icon- icon-eraser"></i>
				</span>
			<%end if%>

		    <select id="selectPeriodoDim" name="selectPeriodoDim">
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
		    <span class="btn btn-info" id="btnDescargaDim" data-toggle="tooltip" title="Descargar Informe">
				<i class="icon-download-alt"></i>
			</span>
		</div>
	</div>	
</div>
<div>
	<div class="row-fluid span12" id="dimCuerpoTrabajo"></div>
</div>
<script type="text/javascript">
	$(function(){
		$('ul#subMenuDimPeriodo > li').each(function(){
			$(this).removeClass('active');
		});
		$('ul#subMenuDimPeriodo li').first().addClass('active');
		var pagina, div, datos, idUsuario, perfilMain;
		periodo = $('#selectPeriodoDim').val();
		idUsuario = $('#subMenuDimPeriodo').attr('data-idUsuario');
		perfilMain = $('#subMenuDimPeriodo').attr('data-perfilMain');
		pagina = 'ctrolCajeroDimTablaPrincipal.asp';
		div = 'dimCuerpoTrabajo';
		datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&periodo='+periodo;
		enviaDatos(pagina,div,datos);

	});

	$('#selectPeriodoDim').change(function(){
		var pagina, div, datos, periodo, idUsuario, perfilMain;
		idUsuario = $('#subMenuDimPeriodo').attr('data-idUsuario');
		perfilMain = $('#subMenuDimPeriodo').attr('data-perfilMain');
		periodo = $('#selectPeriodoDim').val();
		pagina = 'ctrolCajeroDimTablaPrincipal.asp';
		div = 'dimCuerpoTrabajo';
		datos='periodo='+periodo+'&idUsuario='+idUsuario+'&perfilMain='+perfilMain;
		enviaDatos(pagina,div,datos);
	});

	$('#replicaDimensi').click(function(){
		var pagina, div, datos, periodo, idUsuario, perfilMain;
		idUsuario = $('#subMenuDimPeriodo').attr('data-idUsuario');
		perfilMain = $('#subMenuDimPeriodo').attr('data-perfilMain');
		periodo = $('#selectPeriodoDim').val();
		pagina = 'ctrolCajeroDimReplicaDim.asp';
		div = 'dimCuerpoTrabajo';
		datos='action=1&periodo='+periodo+'&idUsuario='+idUsuario+'&perfilMain='+perfilMain;
		enviaDatos(pagina,div,datos);
		setTimeout(function() {
	        pagina = 'ctrolCajeroDimSubMenu.asp';
			div = 'cajaTrabajo';
		    datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&periodo='+periodo;
		    enviaDatos(pagina,div,datos);
	     }, 100);	
	});	

	$('#eliminaReplicaDime').click(function(){
		var pagina, div, datos, periodo, idUsuario, perfilMain;
		idUsuario = $('#subMenuDimPeriodo').attr('data-idUsuario');
		perfilMain = $('#subMenuDimPeriodo').attr('data-perfilMain');
		periodo = $('#selectPeriodoDim').val();
		pagina = 'ctrolCajeroDimReplicaDim.asp';
		div = 'dimCuerpoTrabajo';
		datos='action=2&periodo='+periodo+'&idUsuario='+idUsuario+'&perfilMain='+perfilMain;
		enviaDatos(pagina,div,datos);
		setTimeout(function() {
	        pagina = 'ctrolCajeroDimSubMenu.asp';
			div = 'cajaTrabajo';
		    datos='idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&periodo='+periodo;
		    enviaDatos(pagina,div,datos);
	     }, 100);

	});	