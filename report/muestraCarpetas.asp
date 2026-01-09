<!--#include file="../funciones2.asp"-->
<%idCodigoBarra = trim(request("idCodigoBarra"))
perfilMain = trim(request("perfilMain"))

sql = ""
sql = sql & " SELECT a.id_carpeta, a.num_credito, a.rut_cliente, a.dv_cliente, a.nom_cliente, "
sql = sql & " 	a.fecha_colocacion, a.tipo_pens_trab, "
sql = sql & " 	(select COUNT(*) from SUC_vcc_checklist b , SUC_vcc_tipo_doc c where b.id_carpeta = "
sql = sql & " 		a.id_carpeta and b.check_OK = 0 "
sql = sql & " 		and b.ID_Tipo_Doc = c.ID_Tipo_Doc ) as si, "
sql = sql & " 	(select COUNT(*) from SUC_vcc_checklist b , SUC_vcc_tipo_doc c where b.id_carpeta = "
sql = sql & " 		a.id_carpeta and b.ID_Tipo_Doc = c.ID_Tipo_Doc ) as total, id_codigo_barra "
sql = sql & " FROM SUC_vcc_carpeta_credito a "
sql = sql & " WHERE a.id_codigo_barra = '"&idCodigoBarra&"' order by a.id_carpeta desc "
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getrows()
	tieneDatos = 1
end if
if tieneDatos = 1 then%>
	<form id="formDatos" name="formDatos">
		<div class="span12" id="muestraSeleccion"></div>
		<div class="row-fluid oculto">
			<div class="span12">
				<input type="hidden" name="txtCarpetas" id="txtCarpetas">
				<!--<div id="divMsjAlertaCreada" class="oculto">
					<div class="alert">
						<i class="icon-warning-sign"></i><button type="button" class="close" data-dismiss="alert">&times;</button>
			 			<strong>Documento con alerta.</strong> El usuario  <strong><%=nom_usuario%> </strong> con fecha:<strong><%=fecha_alerta%></strong>
						<strong>Observación:</strong> <%=observacion_alerta%>
					</div>
				</div>-->
			</div>
		</div>
	</form>
	<div class="span4 offset4">
		<span class="btn btn-info" id="btnDescargaInformeDetalleCaja" data-toggle="tooltip" title="Descargar Informe Detalle Caja">
			<i class="icon-download-alt"></i>
		</span>
	</div>
	<div class="row-fluid" id="divCarpeta">
		<div class="span12">
			<table id="tablaCarpeta" class="table table-bordered table-hover table-condensed">
				<thead>
					<tr>
						<th>Carpeta</th>
						<th>Número de Crédito</th>
						<th>Caja</th>
						<th>Rut</th>
						<th>Nombre</th>
						<th>Fech Colocación</th>
						<th>Tipo</th>
						<th>%</th>
						<%if perfilMain = "1" then%>
							<th>Accion</th>
						<%end if%>
					</tr>
				</thead>
				<tbody>
					<%for i = 0 to ubound(datos,2)
						idCarpeta = trim(datos(0,i))
						numeroCredito = trim(datos(1,i))
						rutCliente = trim(datos(2,i))&"-"&trim(datos(3,i))
						nombreCliente = server.htmlencode(trim(datos(4,i)))
						fechaColocacion = trim(datos(5,i))
						tipo = trim(datos(6,i))
						if tipo = "30" then
							textoTipo = "Trabajador"
						else
							textoTipo = "Pensionado"
						end if
						completadoOk = cint(trim(datos(7,i)))
						total = cint(trim(datos(8,i)))
						if completadoOk = "0" and total = "0" then
							porcentajeCompletado = "0%"
						else
							porcentajeCompletado = formatpercent(completadoOk/total,1)
							if right(porcentajeCompletado,3) = ",0%" then
								porcentajeCompletado = replace(porcentajeCompletado,"%","")
								porcentajeCompletado = cint(porcentajeCompletado)
								porcentajeCompletado = porcentajeCompletado&"%"
							end if
						end if
						idCaja = trim(datos(9,i))%>
						<tr>
							<td><%=idCarpeta%></td>
							<td>
								<span id="<%=idCarpeta%>">
									<%=numeroCredito%>
								</span>
							</td>
							<td><%=idCaja%></td>
							<td><%=rutCliente%></td>
							<td><%=nombreCliente%></td>
							<td><%=fechaColocacion%></td>
							<td><%=textoTipo%></td>
							<td><%=porcentajeCompletado%></td>
							<%if perfilMain = "1" then%>
								<td>
									<span class="label label-success selecciona mano" id="selecciona<%=idCarpeta%>" data-carpeta="<%=idCarpeta%>" onClick="agregaSeleccion(<%=idCarpeta%>,<%=numeroCredito%>);">
										Seleccionar
									</span>
								</td>
							<%end if%>
						</tr>
					<%next%>
				</tbody>
			</table>
		</div>
	</div>
	<div class="row-fluid">
		<div class="span12" id="divCheck"></div>
	</div>
	<script type="text/javascript">
		$(function(){
			//alert('functionss');
			$('#tablaCarpeta').dataTable({
				"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"order": [[ 0, "desc" ]],
				"bPaginate": false
			});
		});
		var arreglo = [];
		var arreglo2 = [];
		function agregaSeleccion(idSelecciona,numCredito)
		{
			//alert('holassss');
			arreglo.push(idSelecciona);
			var valores = '';
			$('#selecciona'+idSelecciona).removeClass('label-success selecciona').addClass('label-important quitaSeleccion').attr('onClick', 'quitaSeleccion('+idSelecciona+','+numCredito+')').text('Quitar');
			$.each(arreglo,function(ind,elem){
				valores += elem;
				valores += ',';
			});
			valores = valores.slice(0,-1);
			$('#txtCarpetas').val(valores);
			muestraSeleccion('1',numCredito);
		}
		function quitaSeleccion(idSelecciona,numCredito)
		{
			var i = arreglo.indexOf(idSelecciona);
			if(i != -1) {
				arreglo.splice(i, 1);
			}
			var valores = '';
			$.each(arreglo,function(ind,elem){
				valores += elem;
				valores += ',';
			});
			valores = valores.slice(0,-1);
			$('#txtCarpetas').val(valores);
			$('#selecciona'+idSelecciona).removeClass('label-important quitaSeleccion').addClass('label-success selecciona').attr('onClick', 'agregaSeleccion('+idSelecciona+','+numCredito+')').text('Seleccionar');
			muestraSeleccion('2',numCredito);
		}
		function muestraSeleccion(tipo,numCredito)
		{
			if (tipo ==='1')
			{
				arreglo2.push(numCredito)
			}
			if (tipo ==='2')
			{
				var i = arreglo2.indexOf(numCredito);
				if(i != -1) {
					arreglo2.splice(i, 1);
				}
			}
			var pintaBadge = '<span class="label label-important">Seleccionados: </span>';
			var pinta = '';
			var numCredito = '';
			var idCredito = '';
			$.each(arreglo2,function(ind,numCredito){
				idCredito = arreglo[ind];
				//console.log(idCredito)
				pinta += '  <span class="label label-success mano" onClick="quitaSeleccion('+idCredito+','+numCredito+')" id="idLabel'+idCredito+'" data-idElemento="'+idCredito+'">'+numCredito+'</span>';
			});
			pinta += ' <span class="btn btn-primary btn-mini" onClick="levantaTabla();" id="btnLevantaTabla"> Check list</span>';
			pintaBadge += pinta
			if (arreglo2.length > 0)
			{
				{
					$('#muestraSeleccion').slideDown('slow');
				}
				$('#muestraSeleccion').html(pintaBadge);
			}
			else
			{
				$('#muestraSeleccion').slideUp('fast');
			}
			pintaBadge = '';
			pinta = '';
		}
		function levantaTabla(){
			$('#divCarpeta').slideUp('fast');
			var datosCheck = $('#formDatos').serialize();
			$('#muestraSeleccion > span.label').each(function(){
				$(this).removeAttr('onClick').addClass('seleccionaCheck');
			});
			$('#btnLevantaTabla').slideUp('fast');
			var pagina, div, datos;
			pagina = 'report/checkListMasivo.asp';
			div = 'divCheck';
			datos=datosCheck;
			enviaDatos(pagina,div,datos);
			$('#btnDescargaInformeDetalleCaja').hide();
		}
		$('#btnDescargaInformeDetalleCaja').click(function() {
			var idCodigoBarra;
			idCodigoBarra = <%=idCodigoBarra%>;
			$('#btnDescargaInformeDetalleCaja').tooltip('show');
			location.href='report/informeListaDetalleCaja.asp?idCodigoBarra='+idCodigoBarra;
		});
	</script>
<%end if%>
