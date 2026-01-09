<!--#include file="../funciones.asp"-->
<%idRegional = trim(request("idRegional"))
sql = ""
sql = sql & " select * "
sql = sql & " from suc_regionales "
sql = sql & " where id_regional = '"&idRegional&"'"
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
		<div class="span10" id="datosRegional">
			<input type="hidden" name="idRegional" id="idRegional" value="<%=idRegional%>">
			<div class="row-fluid">
				<div class="span4 gestion well mano" data-idTipoGestion="1" data-idRegional="<%=idRegional%>">
					<div class="row-fluid">
						<div class="span4 text-center" id="iconoRegional">
							<i class="icon-archive icon-6x ayuda" data-placement="top" data-original-title="Gestión documental"></i>
						</div>
						<div class="span7 offset1">
							<div class="row-fluid">
								<div class="span8 text-left">
									Total terminadas
								</div>
								<div class="span1 text-center">
									:
								</div>
								<div class="span3 text-right" id="numTermReg<%=idRegional%>Doc"></div>
							</div>
							<div class="row-fluid">
								<div class="span8 text-left">
									Total activas
								</div>
								<div class="span1 text-center">
									:
								</div>
								<div class="span3 text-right" id="numActreg<%=idRegional%>Doc"></div>
							</div>
							<div class="row-fluid">
								<div class="span8 text-left">
									Cumplimiento
								</div>
								<div class="span1 text-center">
									:
								</div>
								<div class="span3 text-right" id="porctRegional<%=idRegional%>Doc"></div>
							</div>
						</div>
					</div>
					<div class="row-fluid">
						<div class="span12">
							<div class="progress progress-striped active" id="progresoRegional<%=idRegional%>Doc">
								<div class="bar" id="barraRegional<%=idRegional%>Doc"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="span4 gestion well mano"  data-idTipoGestion="2"  data-idRegional="<%=idRegional%>">
					<div class="row-fluid">
						<div class="span4 text-center">
							<i class="icon-money icon-6x ayuda" data-placement="top" data-original-title="Gestión contable"></i>
						</div>
						<div class="span7 offset1">
							<div class="row-fluid">
								<div class="span8 text-left">
									Total terminadas
								</div>
								<div class="span1 text-center">
									:
								</div>
								<div class="span3 text-right" id="numTermReg<%=idRegional%>Cont"></div>
							</div>
							<div class="row-fluid">
								<div class="span8 text-left">
									Total activas
								</div>
								<div class="span1 text-center">
									:
								</div>
								<div class="span3 text-right" id="numActreg<%=idRegional%>Cont"></div>
							</div>
							<div class="row-fluid">
								<div class="span8 text-left">
									Cumplimiento
								</div>
								<div class="span1 text-center">
									:
								</div>
								<div class="span3 text-right" id="porctRegional<%=idRegional%>Cont"></div>
							</div>
						</div>
					</div>
					<div class="row-fluid">
						<div class="span12">
							<div class="progress progress-striped active" id="progresoRegional<%=idRegional%>Cont">
								<div class="bar" id="barraRegional<%=idRegional%>Cont"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="span4 gestion well mano"  data-idTipoGestion="3"  data-idRegional="<%=idRegional%>">
					<div class="row-fluid">
						<div class="span4 text-center">
							<i class="icon-group icon-6x ayuda" data-placement="top" data-original-title="Gestión administrativa"></i>
						</div>
						<div class="span7 offset1">
							<div class="row-fluid">
								<div class="span8 text-left">
									Total terminadas
								</div>
								<div class="span1 text-center">
									:
								</div>
								<div class="span3 text-right" id="numTermReg<%=idRegional%>Adm"></div>
							</div>
							<div class="row-fluid">
								<div class="span8 text-left">
									Total activas
								</div>
								<div class="span1 text-center">
									:
								</div>
								<div class="span3 text-right" id="numActreg<%=idRegional%>Adm"></div>
							</div>
							<div class="row-fluid">
								<div class="span8 text-left">
									Cumplimiento
								</div>
								<div class="span1 text-center">
									:
								</div>
								<div class="span3 text-right" id="porctRegional<%=idRegional%>Adm"></div>
							</div>
						</div>
					</div>
					<div class="row-fluid">
						<div class="span12">
							<div class="progress progress-striped active" id="progresoRegional<%=idRegional%>Adm">
								<div class="bar" id="barraRegional<%=idRegional%>Adm"></div>
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
			sql2 = sql2 & "select id_zonal "
			sql2 = sql2 & " from suc_zonales "
			sql2 = sql2 & " where id_regional_p = '"&idRegional&"' "
			sql2 = sql2 & " and estado_zonal = 1 "
			set rs2 = db.execute(sql2)
			if not rs2.eof then
				datosZonales = rs2.GetRows()
			end if
			for y = 0 to ubound(datosZonales,2)
				idZonal = trim(datosZonales(0,y))%>
				<div class="row-fluid zonal" id="zonal<%=idZonal%>Reg<%=idRegional%>">
					<div class="span12">
						<div class="row-fluid">
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
							<div class="span10 mano seleccionaZonal" data-idZonal="<%=idZonal%>" data-idRegional="<%=idRegional%>">
								<div class="row-fluid">
									<div class="span4 well">
										<div class="row-fluid">
											<div class="span4 text-center">
												<i class="icon-archive icon-6x ayuda" data-placement="top" data-original-title="Gestión documental"></i>
											</div>
											<div class="span7 offset1">
												<div class="row-fluid">
													<div class="span8 text-left">
														Total terminadas
													</div>
													<div class="span1 text-center">
														:
													</div>
													<div class="span3 text-right" id="numTermReg<%=idRegional%>DocZonal<%=idZonal%>"></div>
												</div>
												<div class="row-fluid">
													<div class="span8 text-left">
														Total activas
													</div>
													<div class="span1 text-center">
														:
													</div>
													<div class="span3 text-right" id="numActreg<%=idRegional%>DocZonal<%=idZonal%>"></div>
												</div>
												<div class="row-fluid">
													<div class="span8 text-left">
														Cumplimiento
													</div>
													<div class="span1 text-center">
														:
													</div>
													<div class="span3 text-right" id="porctRegional<%=idRegional%>DocZonal<%=idZonal%>"></div>
												</div>
											</div>
											<div class="row-fluid">
												<div class="span12">
													<div class="progress progress-striped active" id="progresoRegional<%=idRegional%>DocZonal<%=idZonal%>">
														<div class="bar" id="barraRegional<%=idRegional%>DocZonal<%=idZonal%>"></div>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="span4 well">
										<div class="row-fluid">
											<div class="span4 text-center">
												<i class="icon-money icon-6x ayuda" data-placement="top" data-original-title="Gestión contable"></i>
											</div>
											<div class="span7 offset1">
												<div class="row-fluid">
													<div class="span8 text-left">
														Total terminadas
													</div>
													<div class="span1 text-center">
														:
													</div>
													<div class="span3 text-right" id="numTermReg<%=idRegional%>ContZonal<%=idZonal%>"></div>
												</div>
												<div class="row-fluid">
													<div class="span8 text-left">
														Total activas
													</div>
													<div class="span1 text-center">
														:
													</div>
													<div class="span3 text-right" id="numActreg<%=idRegional%>ContZonal<%=idZonal%>"></div>
												</div>
												<div class="row-fluid">
													<div class="span8 text-left">
														Cumplimiento
													</div>
													<div class="span1 text-center">
														:
													</div>
													<div class="span3 text-right" id="porctRegional<%=idRegional%>ContZonal<%=idZonal%>"></div>
												</div>
											</div>
											<div class="row-fluid">
												<div class="span12">
													<div class="progress progress-striped active" id="progresoRegional<%=idRegional%>ContZonal<%=idZonal%>">
														<div class="bar" id="barraRegional<%=idRegional%>ContZonal<%=idZonal%>"></div>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="span4 well">
										<div class="row-fluid">
											<div class="span4 text-center">
												<i class="icon-group icon-6x ayuda" data-placement="top" data-original-title="Gestión administrativa"></i>
											</div>
											<div class="span7 offset1">
												<div class="row-fluid">
													<div class="span8 text-left">
														Total terminadas
													</div>
													<div class="span1 text-center">
														:
													</div>
													<div class="span3 text-right" id="numTermReg<%=idRegional%>AdmZonal<%=idZonal%>"></div>
												</div>
												<div class="row-fluid">
													<div class="span8 text-left">
														Total activas
													</div>
													<div class="span1 text-center">
														:
													</div>
													<div class="span3 text-right" id="numActreg<%=idRegional%>AdmZonal<%=idZonal%>"></div>
												</div>
												<div class="row-fluid">
													<div class="span8 text-left">
														Cumplimiento
													</div>
													<div class="span1 text-center">
														:
													</div>
													<div class="span3 text-right" id="porctRegional<%=idRegional%>AdmZonal<%=idZonal%>"></div>
												</div>
											</div>
											<div class="row-fluid">
												<div class="span12">
													<div class="progress progress-striped active" id="progresoRegional<%=idRegional%>AdmZonal<%=idZonal%>">
														<div class="bar" id="barraRegional<%=idRegional%>AdmZonal<%=idZonal%>"></div>
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
	var url, clasePorcentaje, idZonal, idRegionalGestion,idGestAdmOk, idGestAdmNoOk,poctAdmin,idRegional,nombreZonal,nombreRegional,idGestContOk,idGestContNoOk,porctCont,idGestDocOk,idGestDocNoOk,porctDoc,enteroPorcentajeAdm,enteroPorcentajeCont,clasePorcentajeCont,enteroPorcentajeDoc,clasePorcentajeDoc,gestAdminOk,zonaGeo,porctAdmin,gestAdminNok,gestContOk,gestContNok,gestContNok,gestDocOk,gestDocNok,idRegional,nombreSucursal;
	idRegional = $('#idRegional').val();
	url = 'sucursales/detalleGestionSucursalGer.asp?idRegional='+idRegional;
	$.when($.ajax(url)).then(function(data) {
		$.each( data.datosZonales, function( key, valoresZonales ) {
			idZonal = valoresZonales.idZonal;
			idRegional = valoresZonales.idRegional;
			nombreZonal = valoresZonales.nombreZonal;
			//zonaGeo = valoresZonales.zonaGeo;
			gestAdminOk = valoresZonales.gestAdminOk;
			gestAdminNok = valoresZonales.gestAdminNok;
			porctAdmin = valoresZonales.porctAdmin;
			gestContOk = valoresZonales.gestContOk;
			gestContNok = valoresZonales.gestContNok;
			porctCont = valoresZonales.porctCont;
			gestDocOk = valoresZonales.gestDocOk;
			gestDocNok = valoresZonales.gestDocNok;
			porctDoc = valoresZonales.porctDoc;
			
			$('#nombreZonal'+idZonal+'Regional'+idRegional).html('<span class="label label-info">'+nombreZonal+'</span>');
			//$('#zona'+idZonal+'Regional'+idRegional).html('<span class="label label-info">'+zonaGeo+'</span>');
			$('#numTermReg'+idRegional+'AdmZonal'+idZonal).html(gestAdminOk);
			$('#numActreg'+idRegional+'AdmZonal'+idZonal).html(gestAdminNok);
			$('#porctRegional'+idRegional+'AdmZonal'+idZonal).html(porctAdmin+'%');
			enteroPorcentajeAdm = parseInt(porctAdmin);
			$('#barraRegional'+idRegional+'AdmZonal'+idZonal).css('width', enteroPorcentajeAdm+'%');
			if (enteroPorcentajeAdm < 100)
			{
				if (enteroPorcentajeAdm <= 30) 
				{
					clasePorcentaje = 'progress-danger';
				}
				else
				{
					clasePorcentaje = 'progress-warning';
				}
			}
			else
			{
				clasePorcentaje = 'progress-success';
			}
			$('#progresoRegional'+idRegional+'AdmZonal'+idZonal).removeClass('progress-success progress-warning progress-danger').addClass(clasePorcentaje);
			$('#numTermReg'+idRegional+'ContZonal'+idZonal).html(gestContOk);
			$('#numActreg'+idRegional+'ContZonal'+idZonal).html(gestContNok);
			$('#porctRegional'+idRegional+'ContZonal'+idZonal).html(porctCont+'%');
			enteroPorcentajeCont = parseInt(porctCont);
			$('#barraRegional'+idRegional+'ContZonal'+idZonal).css('width', enteroPorcentajeCont+'%');
			if (enteroPorcentajeCont < 100)
			{
				if (enteroPorcentajeCont <= 30) 
				{
					clasePorcentaje = 'progress-danger';
				}
				else
				{
					clasePorcentaje = 'progress-warning';
				}
			}
			else
			{
				clasePorcentaje = 'progress-success';
			}
			$('#progresoRegional'+idRegional+'ContZonal'+idZonal).removeClass('progress-success progress-warning progress-danger').addClass(clasePorcentaje);
			$('#numTermReg'+idRegional+'DocZonal'+idZonal).html(gestDocOk);
			$('#numActreg'+idRegional+'DocZonal'+idZonal).html(gestDocNok);
			$('#porctRegional'+idRegional+'DocZonal'+idZonal).html(porctDoc+'%');
			enteroPorcentajeDoc = parseInt(porctDoc);
			$('#barraRegional'+idRegional+'DocZonal'+idZonal).css('width', enteroPorcentajeDoc+'%');
			if (enteroPorcentajeDoc < 100)
			{
				if (enteroPorcentajeDoc <= 30) 
				{
					clasePorcentaje = 'progress-danger';
				}
				else
				{
					clasePorcentaje = 'progress-warning';
				}
			}
			else
			{
				clasePorcentaje = 'progress-success';
			}
			$('#progresoRegional'+idRegional+'DocZonal'+idZonal).removeClass('progress-success progress-warning progress-danger').addClass(clasePorcentaje);			
		});
		$.each( data.datosRegional, function( key, valorRegional ) {
			idRegional = valorRegional.idRegional;
			nombreRegional  = valorRegional.nombreRegional;
			$('#nombreRegional'+idRegional).html('<span class="label label-info">'+nombreRegional+'</span>');
			$.each(data.datosGestion,function(key,valorDatosGestion)
			{
				idRegionalGestion = valorDatosGestion.idRegional;
				idGestAdmOk = valorDatosGestion.idGestAdmOk;
				idGestAdmNoOk = valorDatosGestion.idGestAdmNoOk;
				poctAdmin = valorDatosGestion.poctAdmin;
				idGestContOk = valorDatosGestion.idGestContOk;
				idGestContNoOk = valorDatosGestion.idGestContNoOk;
				porctCont = valorDatosGestion.poctCont;
				idGestDocOk = valorDatosGestion.idGestDocOk;
				idGestDocNoOk = valorDatosGestion.idGestDocNoOk;
				porctDoc = valorDatosGestion.poctDoc;
				$('#numTermReg'+idRegionalGestion+'Adm').html(idGestAdmOk);
				$('#numActreg'+idRegionalGestion+'Adm').html(idGestAdmNoOk);
				$('#porctRegional'+idRegionalGestion+'Adm').html(poctAdmin+'%');
				enteroPorcentajeAdm = parseInt(poctAdmin);
				$('#barraRegional'+idRegionalGestion+'Adm').css('width', enteroPorcentajeAdm+'%');
				if (enteroPorcentajeAdm < 100)
				{
					if (enteroPorcentajeAdm <= 30) 
					{
						clasePorcentaje = 'progress-danger';
					}
					else
					{
						clasePorcentaje = 'progress-warning';
					}
				}
				else
				{
					clasePorcentaje = 'progress-success';
				}
				$('#progresoRegional'+idRegionalGestion+'Adm').removeClass('progress-success progress-warning progress-danger').addClass(clasePorcentaje);

				$('#numTermReg'+idRegionalGestion+'Cont').html(idGestContOk);
				$('#numActreg'+idRegionalGestion+'Cont').html(idGestContNoOk);
				$('#porctRegional'+idRegionalGestion+'Cont').html(porctCont+'%');
				enteroPorcentajeCont = parseInt(porctCont);
				$('#barraRegional'+idRegionalGestion+'Cont').css('width', enteroPorcentajeCont+'%');
				if (enteroPorcentajeCont < 100)
				{
					if (enteroPorcentajeCont <= 30) 
					{
						clasePorcentajeCont = 'progress-danger';
					}
					else
					{
						clasePorcentajeCont = 'progress-warning';
					}
				}
				else
				{
					clasePorcentajeCont = 'progress-success';
				}
				$('#progresoRegional'+idRegionalGestion+'Cont').removeClass('progress-success progress-warning progress-danger').addClass(clasePorcentajeCont);

				$('#numTermReg'+idRegionalGestion+'Doc').html(idGestDocOk);
				$('#numActreg'+idRegionalGestion+'Doc').html(idGestDocNoOk);
				$('#porctRegional'+idRegionalGestion+'Doc').html(porctDoc+'%');
				enteroPorcentajeDoc = parseInt(porctDoc);
				$('#barraRegional'+idRegionalGestion+'Doc').css('width', enteroPorcentajeDoc+'%');
				if (enteroPorcentajeDoc < 100)
				{
					if (enteroPorcentajeDoc <= 30) 
					{
						clasePorcentajeDoc = 'progress-danger';
					}
					else
					{
						clasePorcentajeDoc = 'progress-warning';
					}
				}
				else
				{
					clasePorcentajeDoc = 'progress-success';
				}
				$('#progresoRegional'+idRegionalGestion+'Doc').removeClass('progress-success progress-warning progress-danger').addClass(clasePorcentajeDoc);
			});
			
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
	idZonal = $(this).attr('data-idZonal');
	idRegional = $(this).attr('data-idRegional');
	$('#botonVuelveZona'+idZonal+'Reg'+idRegional).attr('onClick', 'vuelveZonal('+idZonal+','+idRegional+');');
	$('#zonal'+idZonal+'Reg'+idRegional).addClass('seleccionado');
	$('.zonal').each(function() {
		if(!$(this).hasClass('seleccionado'))
		{
			$(this).slideUp('fast');
		}
	});
	var pagina, div, datos;
	pagina = 'sucursales/tablaCuadrosSucursalesGer.asp';
	div = 'cuadrosSucursales'+idZonal;
	datos='idZonal='+idZonal+'&idRegional='+idRegional;
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