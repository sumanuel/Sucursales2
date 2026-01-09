<!--#include file="../funciones2.asp"-->
<%idRegional = trim(request("idRegional"))
sql = ""
sql = sql & " select * "
sql = sql & " from suc_regionales "
sql = sql & " where id_regional = '"&idRegional&"' "
'response.write(sql)
'response.end
set rs = db.execute(sql)
if not rs.eof then
	datosRegional = rs.GetRows()
end if
for x=0 to ubound(datosRegional,2)
	idRegional = trim(datosRegional(0,x))%>
	<div class="row-fluid muestraDatosRegional mano" data-idRegional="<%=idRegional%>">
		<div class="span2 well">
			<div class="row-fluid">
				<div class="span12"  id="nombreRegional<%=idRegional%>"></div>
			</div>
		</div>
		<div class="span10 regional">
			<div class="row-fluid">
				<div class="span3 well">
					<div class="row-fluid">
						<div class="span6">
							Abiertas
						</div>
						<div class="span6">
							<span id="abiertasRegional<%=idRegional%>"></span>
						</div>
					</div>
					<div class="row-fluid">
						<div class="span6">
							Cerradas
						</div>
						<div class="span6">
							<span id="cerradasRegional<%=idRegional%>"></span>
						</div>
					</div>
				</div>
				<div class="span3 well">
					<div class="row-fluid">
						<div class="span6">
							Abiertas DP
						</div>
						<div class="span6">
							<span id="abiertasDpRegional<%=idRegional%>"></span>
						</div>
					</div>
					<div class="row-fluid">
						<div class="span6">
							Abiertas FP
						</div>
						<div class="span6">
							<span id="abiertasFpRegional<%=idRegional%>"></span>
						</div>
					</div>
				</div>
				<div class="span6 well">
					<div class="row-fluid">
						<div class="span4">
							<div class="row-fluid">
								<div class="span6">
									Normal
								</div>
								<div class="span6">
									<span id="estadoNormalRegional<%=idRegional%>"></span>
								</div>
							</div>
						</div>
						<div class="span8">
							<div class="row-fluid">
								<div class="span4">
									Full IPS
								</div>
								<div class="span2">
									<span id="estadoFullIPSRegional<%=idRegional%>"></span>
								</div>
								<div class="span4">
									Desborde IPS
								</div>
								<div class="span2">
									<span id="estadoDesbordeIPSRegional<%=idRegional%>"></span>
								</div>
							</div>
							<div class="row-fluid">
								
								<div class="span4">
									Full AFP
								</div>
								<div class="span2">
									<span id="estadoFullAFPRegional<%=idRegional%>"></span>
								</div>
								<div class="span4">
									Desborde AFP
								</div>
								<div class="span2">
									<span id="estadoDesbordeAFPRegional<%=idRegional%>"></span>
								</div>
							</div>
						</div>
					</div>	
				</div>
			</div>
		</div>
	</div>
<%next%>
<%sql2 = ""
sql2 = sql2 & "select id_zonal, "
sql2 = sql2 & " id_usuario "
sql2 = sql2 & " from suc_zonales "
sql2 = sql2 & " where id_regional_p = '"&idRegional&"' "
sql2 = sql2 & " and estado_zonal = 1 "
set rs2 = db.execute(sql2)
if not rs2.eof then
	datosZonales = rs2.GetRows()
end if
for y = 0 to ubound(datosZonales,2)
	idZonal = trim(datosZonales(0,y))
	idUsuarioZonal = trim(datosZonales(1,y))%>
	<div class="row-fluid muestraZonal r<%=idRegional%>z<%=idUsuarioZonal%>" data-idRegional="<%=idRegional%>" data-idZonal="<%=idUsuarioZonal%>">
		<div class="span2 well">
			<div class="row-fluid">
				<div class="span12"  id="nombreRegional<%=idRegional%>Zonal<%=idUsuarioZonal%>"></div>
			</div>
			<div class="row-fluid">
				<div class="span3 btn btn-inverse btnSubeRegional" id="botonUpZona<%=idUsuarioZonal%>Reg<%=idRegional%>" onClick="subeRegional(<%=idUsuarioZonal%>,<%=idRegional%>)">
					<i class="icon-arrow-up"></i>
				</div>
			</div>
		</div>
		<div class="span10 mano muestraZonal seleccionaZonal r<%=idRegional%>z<%=idUsuarioZonal%>" data-idRegional="<%=idRegional%>" data-idZonal="<%=idUsuarioZonal%>">
			<div class="row-fluid">
				<div class="span3 well">
					<div class="row-fluid">
						<div class="span6">
							Abiertas
						</div>
						<div class="span6">
							<span id="abiertasRegional<%=idRegional%>Zonal<%=idUsuarioZonal%>"></span>
						</div>
					</div>
					<div class="row-fluid">
						<div class="span6">
							Cerradas
						</div>
						<div class="span6">
							<span id="cerradasRegional<%=idRegional%>Zonal<%=idUsuarioZonal%>"></span>
						</div>
					</div>
				</div>
				<div class="span3 well">
					<div class="row-fluid">
						<div class="span6">
							Abiertas DP
						</div>
						<div class="span6">
							<span id="abiertasDpRegional<%=idRegional%>Zonal<%=idUsuarioZonal%>"></span>
						</div>
					</div>
					<div class="row-fluid">
						<div class="span6">
							Abiertas FP
						</div>
						<div class="span6">
							<span id="abiertasFpRegional<%=idRegional%>Zonal<%=idUsuarioZonal%>"></span>
						</div>
					</div>
				</div>
				<div class="span6 well">
					<div class="row-fluid">
						<div class="span4">
							<div class="row-fluid">
								<div class="span6">
									Normal
								</div>
								<div class="span6">
									<span id="estadoNormalRegional<%=idRegional%>Zonal<%=idUsuarioZonal%>"></span>
								</div>
							</div>
						</div>
						<div class="span8">
							<div class="row-fluid">
								<div class="span4">
									Full IPS
								</div>
								<div class="span2">
									<span id="estadoFullIPSRegional<%=idRegional%>Zonal<%=idUsuarioZonal%>"></span>
								</div>
								<div class="span4">
									Desborde IPS
								</div>
								<div class="span2">
									<span id="estadoDesbordeIPSRegional<%=idRegional%>Zonal<%=idUsuarioZonal%>"></span>
								</div>
							</div>
							<div class="row-fluid">
								
								<div class="span4">
									Full AFP
								</div>
								<div class="span2">
									<span id="estadoFullAFPRegional<%=idRegional%>Zonal<%=idUsuarioZonal%>"></span>
								</div>
								<div class="span4">
									Desborde AFP
								</div>
								<div class="span2">
									<span id="estadoDesbordeAFPRegional<%=idRegional%>Zonal<%=idUsuarioZonal%>"></span>
								</div>
							</div>
						</div>
					</div>	
				</div>
			</div>
		</div>
	</div>
	<div class="row-fluid muestraSucursal <%=idUsuarioZonal%>">
		<div class="span12" id="muestraSucursal<%=idUsuarioZonal%>"></div>
	</div>
<%next%>
<link href="css/tablaSort.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="js/jquery.dataTables.js"></script>
<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>
<script type="text/javascript">
	$(function(){
		var idRegional, url,nombreRegional;
		idRegional = $('.muestraDatosRegional').attr('data-idRegional');

		$('.muestraZonal').slideUp('fast');
		$('.muestraSucursal').slideUp('fast');
		url = 'sucursales/detalleGestionSucursal.asp?idRegional='+idRegional;
		$.when($.ajax(url)).then(function(data) {
			$.each( data.datosRegional, function( key, valorRegional ) {
				idRegional = valorRegional.idRegional;
				var nombreRegional  = valorRegional.nombreRegional;
				$('#nombreRegional'+idRegional).html('<span class="label label-info">'+nombreRegional+'</span>');	
			});
			$.each( data.datosRegionales, function( key, valorRegionales ) {
				var idRegional = valorRegionales.idRegional;
				var totalAbiertas = valorRegionales.totalAbiertas;
				var totalCerradas = valorRegionales.totalCerradas;
				var totalFueraDePlazo = valorRegionales.totalFueraDePlazo;
				var totalDentroDePlazo = valorRegionales.totalDentroDePlazo;
				var totalSituacionNormal = valorRegionales.totalSituacionNormal;
				var totalSituacionFullIps = valorRegionales.totalSituacionFullIps;
				var totalSituacionFullAfp = valorRegionales.totalSituacionFullAfp;
				var totalSituacionDesIps = valorRegionales.totalSituacionDesIps;
				var totalSituacionDesAfp = valorRegionales.totalSituacionDesAfp;
				$('#abiertasRegional'+idRegional).html('<span class="label label-success">'+totalAbiertas+'</span>');
				$('#cerradasRegional'+idRegional).html('<span class="label label-important">'+totalCerradas+'</span>');
				$('#abiertasDpRegional'+idRegional).html('<span class="label label-success">'+totalDentroDePlazo+'</span>');
				$('#abiertasFpRegional'+idRegional).html('<span class="label label-warning">'+totalFueraDePlazo+'</span>');
				$('#estadoNormalRegional'+idRegional).html('<span class="label">'+totalSituacionNormal+'</span>');
				$('#estadoFullIPSRegional'+idRegional).html('<span class="label label-warning">'+totalSituacionFullIps+'</span>');
				$('#estadoFullAFPRegional'+idRegional).html('<span class="label label-warning">'+totalSituacionFullAfp+'</span>');
				$('#estadoDesbordeIPSRegional'+idRegional).html('<span class="label label-important">'+totalSituacionDesIps+'</span>');
				$('#estadoDesbordeAFPRegional'+idRegional).html('<span class="label label-important">'+totalSituacionDesAfp+'</span>');
			});
			$.each( data.datosZonales, function( key, valorZonales ) {
				var idRegional = valorZonales.idRegional;
				var idZonal = valorZonales.idZonal;
				var idZonal2 = valorZonales.idZonal2;
				var nombreZonal = valorZonales.nombreZonal;
				var zonaGeo = valorZonales.zonaGeo;
				var totalAbiertas = valorZonales.totalAbiertas;
				var totalCerradas = valorZonales.totalCerradas;
				var totalFueraDePlazo = valorZonales.totalFueraDePlazo;
				var totalDentroDePlazo = valorZonales.totalDentroDePlazo;
				var totalSituacionNormal = valorZonales.totalSituacionNormal;
				var totalSituacionFullIps = valorZonales.totalSituacionFullIps;
				var totalSituacionFullAfp = valorZonales.totalSituacionFullAfp;
				var totalSituacionDesIps = valorZonales.totalSituacionDesIps;
				var totalSituacionDesAfp = valorZonales.totalSituacionDesAfp;
				$('#nombreRegional'+idRegional+'Zonal'+idZonal).html('<span class="label label-info">'+nombreZonal+'</span>');
				$('#abiertasRegional'+idRegional+'Zonal'+idZonal).html('<span class="label label-success">'+totalAbiertas+'</span>');
				$('#cerradasRegional'+idRegional+'Zonal'+idZonal).html('<span class="label label-important">'+totalCerradas+'</span>');
				$('#abiertasDpRegional'+idRegional+'Zonal'+idZonal).html('<span class="label label-success">'+totalDentroDePlazo+'</span>');
				$('#abiertasFpRegional'+idRegional+'Zonal'+idZonal).html('<span class="label label-warning">'+totalFueraDePlazo+'</span>');
				$('#estadoNormalRegional'+idRegional+'Zonal'+idZonal).html('<span class="label">'+totalSituacionNormal+'</span>');
				$('#estadoFullIPSRegional'+idRegional+'Zonal'+idZonal).html('<span class="label label-warning">'+totalSituacionFullIps+'</span>');
				$('#estadoFullAFPRegional'+idRegional+'Zonal'+idZonal).html('<span class="label label-warning">'+totalSituacionFullAfp+'</span>');
				$('#estadoDesbordeIPSRegional'+idRegional+'Zonal'+idZonal).html('<span class="label label-important">'+totalSituacionDesIps+'</span>');
				$('#estadoDesbordeAFPRegional'+idRegional+'Zonal'+idZonal).html('<span class="label label-important">'+totalSituacionDesAfp+'</span>');
			});
		});
	});
	$('.muestraDatosRegional').click(function(event) {
		
		$('.muestraZonal').slideDown('fast');
		$('.muestraDatosRegional').slideUp('fast');
	});
	$('.seleccionaZonal').click(function(event) {
		var idRegional = $(this).attr('data-idRegional');
		var idZonal = $(this).attr('data-idZonal');
		$('.muestraZonal').each(function(){
			if (!$(this).hasClass('r'+idRegional+'z'+idZonal))
			{
				$(this).slideUp('fast');
			}
		});
		$('#botonUpZona'+idZonal+'Reg'+idRegional).attr('onClick', 'subeZonal('+idZonal+','+idRegional+')');
		$('.'+idZonal).slideDown('fast');
		
		var pagina, div, datos;
		pagina = 'sucursales/tablaCuadrosSucursales.asp';
		div = 'muestraSucursal'+idZonal;
		datos='idZonal='+idZonal+'&idRegional='+idRegional;
		enviaDatos(pagina,div,datos);
		return false;
	});
	function subeRegional(idZonal,idRegional)
	{
		$('.muestraDatosRegional').slideDown('fast');
		$('.muestraZonal').slideUp('fast');
	}
	function subeZonal(idZonal,idRegional)
	{
		$('.muestraZonal').slideDown('fast');
		$('#botonUpZona'+idZonal+'Reg'+idRegional).attr('onClick', 'subeRegional('+idZonal+','+idRegional+')');
		$('.muestraSucursal').slideUp('fast');
	}

</script>