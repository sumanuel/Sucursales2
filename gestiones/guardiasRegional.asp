<!--#include file="../funciones.asp"-->
<%idRegional = trim(request("idRegional"))
sql = ""
sql = sql & " select * "
sql = sql & " from suc_regionales "
sql = sql & " where id_regional = '"&idRegional&"'"
'response.write(sql)
'response.end
set rs = db.execute(sql)
if not rs.eof then
	datosRegional = rs.GetRows()
end if
for x=0 to ubound(datosRegional,2)
	idRegional = trim(datosRegional(0,x))%>
	<div class="row-fluid regional">
		<div class="span2 well">
			<div class="row-fluid">
				<div class="span12"  id="nombreRegional<%=idRegional%>"></div>
			</div>
		</div>
		<div class="span10 gestion mano" id="datosRegional" data-idRegional="<%=idRegional%>">
			<input type="hidden" name="idRegional" id="idRegional" value="<%=idRegional%>">
			<div class="row-fluid">
				<div class="span12">
					<div class="row-fluid">
						<div class="span3 well">
							<div class="row-fluid">
								<div class="span4">
									<i class="icon-shield icon-5x"></i>
								</div>
								<div class="span8">
									<span class="label label-info">Total guardias </span>
									<span id="total<%=idRegional%>" class="label label-info"></span>
								</div>
							</div>
						</div>
						<div class="span9">
							<div class="row-fluid">
								<div class="span4 well">
									<div class="row-fluid">
										<div class="span3">
											<div class="row-fluid">
												<div class="span12">
													<i class="icon-shield icon-5x"></i>
												</div>
											</div>
										</div>
										<div class="span9">
											<div class="row-fluid">
												<div class="span6">
													<span class="label label-info">
														Titulares
													</span>
												</div>
												<div class="span6">
													<span id="totalTitulares<%=idRegional%>" class="label label-info"></span>
												</div>
											</div>
											<div class="row-fluid">
												<div class="span6">
													<span class="label label-info">
														Reemplazo
													</span>
												</div>
												<div class="span6">
													<span class="label label-info" id="reemplazo<%=idRegional%>"></span>
												</div>
											</div>
										</div>
									</div>	
								</div>
								<div class="span4 well">
									<div class="row-fluid">
										<div class="span3">
											<div class="row-fluid">
												<div class="span12">
													<i class="icon-shield icon-5x"></i>
												</div>
											</div>
										</div>
										<div class="span9">
											<div class="row-fluid">
												<div class="span6">
													<span class="label label-important">
														Sin registro
													</span>
												</div>
												<div class="span6">
													<span class="label label-important" id="sinRegistro<%=idRegional%>">
												</div>
											</div>
											<div class="row-fluid">
												<div class="span6">
													<span class="label label-important">
														Ausentes
													</span>
												</div>
												<div class="span6">
													<span class="label label-important" id="ausentes<%=idRegional%>"></span>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="span4 well">
									<div class="row-fluid">
										<div class="span3">
											<div class="row-fluid">
												<div class="span12">
													<i class="icon-shield icon-5x"></i>
												</div>
											</div>
										</div>
										<div class="span9">
											<div class="row-fluid">
												<div class="span6">
													<span class="label label-info">
														Presentes
													</span>
												</div>
												<div class="span6">
													<span class="label label-info"  id="presentes<%=idRegional%>"></span>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row-fluid">
		<div class="span12 cuadrosZonales inactivo" id="cuadrosZonales<%=idRegional%>">
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
				<div class="row-fluid zonal" id="zonal<%=idZonal%>Reg<%=idRegional%>">
					<div class="span2 well mano " data-idZonal="<%=idZonal%>" data-idRegional="<%=idRegional%>">
						<div class="row-fluid">
							<div class="span12" id="nombreZonal<%=idZonal%>Regional<%=idRegional%>"></div>
						</div>
						<div class="row-fluid">
							<div class="span3 btn btn-inverse" id="botonVuelveZona<%=idZonal%>Reg<%=idRegional%>" onClick="vuelveRegional(<%=idZonal%>,<%=idRegional%>);">
								<i class="icon-arrow-up"></i>
							</div>
						</div>
					</div>
					<div class="span10 mano seleccionaZonal" data-idZonal="<%=idZonal%>" data-idRegional="<%=idRegional%>" data-idUsuarioZonal="<%=idUsuarioZonal%>">
						<input type="hidden" name="idRegional" id="idRegional" value="<%=idRegional%>">
						<div class="row-fluid">
							<div class="span3 well">
								<div class="row-fluid">
									<div class="span4">
										<div class="span4">
											<i class="icon-shield icon-5x"></i>
										</div>
									</div>
									<div class="span8">
										<span class="label label-info">
											Total guardias
										</span>
										<span id="totalZonal<%=idZonal%>Regional<%=idRegional%>" class="label label-info"></span>
									</div>
								</div>

							</div>
							<div class="span3 well">
								<div class="row-fluid">
									<div class="span3">
										<div class="row-fluid">
											<div class="span12">
												<i class="icon-shield icon-5x"></i>
											</div>
										</div>
									</div>
									<div class="span9">
										<div class="row-fluid">
											<div class="span6">
												<span class="label label-info">
													Titulares
												</span>
											</div>
											<div class="span6">
												<span class="label label-info" id="totalTitularesRegional<%=idRegional%>Zonal<%=idZonal%>"></span>
											</div>
										</div>
										<div class="row-fluid">
											<div class="span6">
												<span class="label label-info">
													Reemplazo
												</span>
											</div>
											<div class="span6">
												<span id="reemplazoRegional<%=idRegional%>Zonal<%=idZonal%>" class="label label-info"></span>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="span3 well">
								<div class="row-fluid">
									<div class="span3">
										<div class="row-fluid">
											<div class="span12">
												<i class="icon-shield icon-5x"></i>
											</div>
										</div>
									</div>
									<div class="span9">
										<div class="row-fluid">
											<div class="span6">
												<span class="label label-important">
													Sin registro
												</span>
											</div>
											<div class="span6">
												<span class="label label-important" id="sinRegistroRegional<%=idRegional%>Zonal<%=idZonal%>"></span>
											</div>
										</div>
										<div class="row-fluid">
											<div class="span6">
												<span class="label label-important">
													Ausentes
												</span>
											</div>
											<div class="span6">
												<span class="label label-important" id="ausentesRegional<%=idRegional%>Zonal<%=idZonal%>"></span>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="span3 well">
								<div class="row-fluid">
									<div class="span3">
										<div class="row-fluid">
											<div class="span12">
												<i class="icon-shield icon-5x"></i>
											</div>
										</div>
									</div>
									<div class="span9">
										<div class="row-fluid">
											<div class="span6">
												<span class="label label-info">
													Presentes
												</span>
											</div>
											<div class="span6">
												<span class="label label-info" id="presentesRegional<%=idRegional%>Zonal<%=idZonal%>">
												</span>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12  cuadrosSucursales inactivo" id="cuadrosSucursales<%=idZonal%>">
					</div>
				</div>
			<%next%>
		</div>
	</div>
<%next%>
<link href="css/tablaSort.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="js/jquery.dataTables.js"></script>
	<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>
<script type="text/javascript">
$(function(){

var url, clasePorcentaje, idZonal, idRegionalGestion,idGestAdmOk, poctAdmin,nombreZonal;
var nombreRegional,idGestContOk,idGestContNoOk,porctCont,idGestDocOk,idGestDocNoOk,porctDoc;
var enteroPorcentajeAdm,enteroPorcentajeCont,clasePorcentajeCont,enteroPorcentajeDoc;
var clasePorcentajeDoc,zonaGeo,porctAdmin,gestAdminNok,gestContOk,gestContNok,gestDocOk;
var gestDocNok,idRegional,nombreSucursal, totalGuardias,idZonal2, totalguardiastitulares;
var totalguardiasreemplazos, totalguardiaspresentes, totalguardiassinregistro, totalguardiasausentes;
var totalGuardiasTitulares;	idRegional = $('#idRegional').val();
	url = 'sucursales/detalleGestionSucursalGuardias.asp?idRegional='+idRegional;
	$.when($.ajax(url)).done(function(data) {
		$.each( data.datosZonales, function( key, valoresZonales ) {
			idRegional = valoresZonales.idRegional;
			idZonal = valoresZonales.idZonal;
			idZonal2 = valoresZonales.idZonal2;
			nombreZonal = valoresZonales.nombreZonal;
			totalguardiastitulares = valoresZonales.totalguardiastitulares;
			totalguardiasreemplazos = valoresZonales.totalguardiasreemplazos;
			totalguardiaspresentes = valoresZonales.totalguardiaspresentes;
			totalguardiassinregistro = valoresZonales.totalguardiassinregistro;
			totalguardiasausentes = valoresZonales.totalguardiasausentes;
			$('#nombreZonal'+idZonal2+'Regional'+idRegional).html('<span class="label label-info">'+nombreZonal+'</span>');
			$('#totalTitularesRegional'+idRegional+'Zonal'+idZonal2).html(totalguardiastitulares);
			$('#reemplazoRegional'+idRegional+'Zonal'+idZonal2).html(totalguardiasreemplazos);
			$('#sinRegistroRegional'+idRegional+'Zonal'+idZonal2).html(totalguardiassinregistro);
			$('#ausentesRegional'+idRegional+'Zonal'+idZonal2).html(totalguardiasausentes);
			$('#presentesRegional'+idRegional+'Zonal'+idZonal2).html(totalguardiaspresentes);
			totalGuardias = parseInt(totalguardiastitulares) + parseInt(totalguardiasreemplazos);
			$('#totalZonal'+idZonal2+'Regional'+idRegional).html(totalGuardias);
		});
		$.each( data.datosRegional, function( key, valorRegional ) {
			idRegional = valorRegional.idRegional;
			nombreRegional  = valorRegional.nombreRegional;
			$('#nombreRegional'+idRegional).html('<span class="label label-info">'+nombreRegional+'</span>');	
		});
		$.each(data.datosRegionales, function(key, valorDaTosRegionales){
			idRegional = valorDaTosRegionales.idRegional;
			totalGuardiasTitulares = valorDaTosRegionales.totalGuardiasTitulares;
			totalguardiasreemplazos = valorDaTosRegionales.totalguardiasreemplazos;
			totalguardiaspresentes = valorDaTosRegionales.totalguardiaspresentes;
			totalguardiassinregistro = valorDaTosRegionales.totalguardiassinregistro;
			totalguardiasausentes = valorDaTosRegionales.totalguardiasausentes;
			$('#totalTitulares'+idRegional).html(totalGuardiasTitulares);
			$('#reemplazo'+idRegional).html(totalguardiasreemplazos);
			$('#adicionales'+idRegional).html(totalguardiaspresentes);
			$('#sinRegistro'+idRegional).html(totalguardiassinregistro);
			$('#ausentes'+idRegional).html(totalguardiasausentes);
			$('#presentes'+idRegional).html(totalguardiaspresentes);
			totalGuardias = parseInt(totalGuardiasTitulares) + parseInt(totalguardiasreemplazos);
			$('#total'+idRegional).html(totalGuardias);
		});
	});	
	$('.cuadrosZonales').slideUp('fast');
	$('.cuadrosSucursales').slideUp('fast');
});
$('.gestion').click(function() {
	var idRegional = $(this).attr('data-idRegional');
	if ($('#cuadrosZonales'+idRegional).hasClass('inactivo'))
	{
		$('#cuadrosZonales'+idRegional).removeClass('inactivo').addClass('activo').slideDown('slow');
		$('.regional').slideUp('fast');
		$('#divVuelveRegional'+idRegional).removeClass('oculto');
	}
	else
	{
		$('#cuadrosZonales'+idRegional).addClass('inactivo').removeClass('activo').slideUp('fast');
	}
});
function vuelveRegional(idZonal,idRegional)
{
	$('.cuadrosSucursales').slideUp('fast');
	$('.regional').slideDown('slow');
	$('#cuadrosZonales'+idRegional).addClass('inactivo').removeClass('activo').slideUp('fast');
}

$('.seleccionaZonal').click(function() {
	var idZonal = $(this).attr('data-idZonal');
	var idRegional = $(this).attr('data-idRegional');
	var idUsuarioZonal = $(this).attr('data-idUsuarioZonal');
	$('#botonVuelveZona'+idZonal+'Reg'+idRegional).attr('onClick', 'vuelveZonal('+idZonal+','+idRegional+');');
	$('#zonal'+idZonal+'Reg'+idRegional).addClass('seleccionado');
	$('.zonal').each(function() {
		if(!$(this).hasClass('seleccionado'))
		{
			$(this).slideUp('fast');
		}
	});
	var pagina, div, datos;
	pagina = 'sucursales/tablaCuadrosSucursalesGuardias.asp';
	div = 'cuadrosSucursales'+idZonal;
	datos='idZonal='+idZonal+'&idRegional='+idRegional+'&idUsuarioZonal='+idUsuarioZonal;
	enviaDatos(pagina,div,datos);
});
function vuelveZonal(idZonal,idRegional)
{
	$('#divVuelveRegional'+idRegional).slideDown('fast');
	$('#cuadrosSucursales'+idZonal).slideUp('fast');
	$('.zonal').each(function() {
		$(this).removeClass('seleccionado');
	});
	$('.zonal').slideDown('slow');
	$('#botonVuelveZona'+idZonal+'Reg'+idRegional).attr('onClick', 'vuelveRegional('+idZonal+','+idRegional+');');

}
</script>