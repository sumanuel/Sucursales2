<!--#include file="../funciones2.asp"-->
<%
idSucursalCaja = trim(request("idSucursalCaja"))
idUsuarioMain = trim(request("idUsuarioMain"))
if idUsuarioMain = "" then
	idUsuarioMain = 0
end if
'response.write(idSucursalMain)
'response.end
%>

<%sql = ""
sql = sql & "select "
sql = sql & "a.id_codigo_barra, a.fecha_registro, b.descrip_estado, "
sql = sql & "p.suc_jeps_short as nom_usuario, "
sql = sql & "b.id_estado, "
sql = sql & "(select COUNT(*) from SUC_vcc_checklist z, SUC_vcc_carpeta_credito x, SUC_vcc_tipo_doc y where z.id_carpeta = x.id_carpeta and "
sql = sql & "z.ID_Tipo_Doc = y.ID_Tipo_Doc and x.id_codigo_barra = a.id_codigo_barra and z.check_OK = 0 and y.excluyente = 0) as totalSi, "
sql = sql & "(select COUNT(*) from SUC_vcc_checklist z, SUC_vcc_carpeta_credito x, SUC_vcc_tipo_doc y where z.id_carpeta = x.id_carpeta and "
sql = sql & "z.ID_Tipo_Doc = y.ID_Tipo_Doc and y.excluyente = 0 and x.id_codigo_barra = a.id_codigo_barra) as totalMarca, "
sql = sql & "(select COUNT(*) from SUC_vcc_carpeta_credito x where x.id_codigo_barra = a.id_codigo_barra) as totalDocumentos "
sql = sql & "from SUC_vcc_caja a inner join SUC_vcc_estados b on "
sql = sql & "a.id_estado = b.id_estado inner join SUC_sucursal p on "
sql = sql & "a.id_sucursal = p.id_sucursal and a.id_sucursal = "&idSucursalCaja&" "
sql = sql & "where b.id_estado in (201, 202, 203) "
sql = sql & "order by a.fecha_registro desc "

'response.write(sql)
'response.end

set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getrows()%>
	<div class="row-fluid">
		<div class="span12">

		
		<div class="modal hide fade" id="modalFecEnvio" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-header">
		      <span class="close" data-dismiss="modal" aria-hidden="true">×</span>
		        <h3 id="myModalLabel">
		         Envio de Caja
		        </h3>
		    </div>
		    <div class="modal-body"></div>
		    <div class="modal-footer">
		      <span class="btn btn-danger "  data-dismiss="modal" >Cerrar</span>      
		    </div>
	  	</div>
	  	
			<table  class="table table-bordered table-hover table-condensed" id="tablaCarpetas">
				<thead>
					<tr>
						<th>Cod de barras</th>
						<th>Fec Recepción</th>
						<th>JEPS</th>
						<th>Cant Carpetas</th>
						<th>% Caja</th>
						<th>Estado</th>
						<th>Acción</th>
					</tr>
				</thead>
				<tbody>
					<%for i = 0 to ubound(datos,2)
						codigoBarras = trim(datos(0,i))
						fechaRegistro = trim(datos(1,i))
						estado = server.htmlencode(trim(datos(2,i)))
						usuario = trim(datos(3,i))
						idEstado = trim(datos(4,i))
						totalMarcado = clng(trim(datos(5,i)))
						totalMarca = clng(trim(datos(6,i)))
						if totalMarca <> 0 then
							porcentajeMarca = formatpercent(totalMarcado/totalMarca,1)
							if right(porcentajeMarca,3) = ",0%" then
								enteroPorcentaje = cint(replace(porcentajeMarca,"%",""))
								porcentajeMarca = enteroPorcentaje&"%"
							end if
						else
							porcentajeMarca = "0%"
						end if
						totalDocumentos = clng(trim(datos(7,i)))
						if totalDocumentos = "" then totalDocumentos = 0
						enteroPorcentaje = cint(replace(porcentajeMarca,"%",""))%>
						<tr>
							<td>
								<%=codigoBarras%>
							</td>
							<td>
								<%=fechaRegistro%>
							</td>
							<td>
								<%=usuario%>
							</td>
							<td>
								<%=totalDocumentos%>
							</td>
							<td>
								<%=porcentajeMarca%>
							</td>
							<td id="estadoActual<%=i%>">
								<%=estado%>
							</td>
							<td id="botonera<%=i%>">
								<%if idEstado <> "299" and idEstado <> "204" then%>
									<span id="btnModifica<%=i%>" data-idEstado="<%=idEstado%>" class="modificaEstado btn btn-mini btn-danger" data-codigoBarras="<%=codigoBarras%>" data-modifica="0" data-porcentaje="<%=enteroPorcentaje%>" onClick="modificaEstado('<%=i%>');" data-botonera="<%=i%>" data-totalDocumentos="<%=totalDocumentos%>">
										Modificar Estado
									</span>
								<%end if%>
								<%if totalDocumentos > 0 then %>
									<span id="listaContenido" class="btn btn-success btn-mini" data-codigoBarras="<%=codigoBarras%>" onClick="listaContenido('<%=codigoBarras%>');">
										Listar contenido
									</span>
								<%end if%>
							</td>
						</tr>
					<%next%>	
				</tbody>
			</table>
		</div>
	</div>
	<script type="text/javascript">
	$(function(){
		$('#tablaCarpetas').dataTable({
			"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
			"sPaginationType": "bootstrap"
		});
	});
	function modificaEstado(idBoton){		
		$('#btnModifica'+idBoton).removeClass('modificaEstado btn btn-mini btn-danger').text();
		var modifica = $('#btnModifica'+idBoton).attr('data-modifica');		
		if (modifica == '0'){
			$('#btnModifica'+idBoton).attr('data-modifica', '1');
			var idEstado, codigoBarras, pagina, div, datos,porcentaje,botoneral,totalDocumentos;
			idEstado = $('#btnModifica'+idBoton).attr('data-idEstado');
			codigoBarras = $('#btnModifica'+idBoton).attr('data-codigoBarras');
			porcentaje = $('#btnModifica'+idBoton).attr('data-porcentaje');
			botonera = $('#btnModifica'+idBoton).attr('data-botonera');
			totalDocumentos = $('#btnModifica'+idBoton).attr('data-totalDocumentos');
			pagina = 'CheckListCredito/modificaEstado.asp';
			div = 'botonera'+idBoton;
			datos='codigoBarras='+codigoBarras+'&idEstado='+idEstado+'&porcentaje='+porcentaje+'&botonera='+botonera+'&totalDocumentos='+totalDocumentos;
			enviaDatos(pagina,div,datos);
		}
	}
	function listaContenido(idCodigoBarra){
		$('#listaCajasIng').html('').hide();
		var pagina, div, datos;
		pagina = 'CheckListCredito/muestraCarpetas.asp';
		div = 'cajaTrabajo';
		datos='idCodigoBarra='+idCodigoBarra;
		enviaDatos(pagina,div,datos);
	}
	/*$('#cerrarModal').click(function(){		
		var idSucursalCaja = <%=idSucursalCaja%>;
		var idUsuarioMainCaja = <%=idUsuarioMain%>;
		$('#listaCajasIng').html('').hide();
		$('#cajaTrabajo').html('').hide();
		$('#comboFechasColo').html('').hide();
		$('#listaChecklistColo').html('').hide();
		$('#listaChecklistColo2').html('').hide();
		$('#listaChecklistColo3').html('').hide();
		$('#comboFechasRepro').html('').hide();
		$('#listaChecklistRepro').html('').hide();
		$('#listaChecklistRepro2').html('').hide();
		$('#listaChecklistRepro3').html('').hide();
		$('#comboFechasColo').html('').hide();

		var pagina = 'CheckListCredito/cajas.asp';
		var div = 'listaCajasIng';
		var datos='idSucursalCaja='+idSucursalCaja+'&idUsuarioMainCaja='+idUsuarioMainCaja;
		enviaDatos(pagina,div,datos)
	});*/

	</script>
<%else%>
	<div class="row-fluid">
		<div class="span2 offset5 text-center label label-warning">
			No existen cajas
		</div>
	</div>
<%end if%>