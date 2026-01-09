<!--#include file="../funciones2.asp"-->
<%
idSucursalCaja = trim(request("idSucursalCaja"))
idUsuarioMain = trim(request("idUsuarioMainCaja"))
periodo = trim(request("periodo"))
perfilMain = trim(request("idPerfilMain"))

if idUsuarioMain = "" then
	idUsuarioMain = 0
end if%>

<%
sql = ""
sql = sql & " EXEC SCSS_prc_lista_total_carpetas_x_caja '"&periodo&"','"&idSucursalCaja&"','"&perfilMain&"'"
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
		      <span class="btn btn-danger" data-dismiss="modal" >Cerrar</span>      
		    </div>
	  	</div>
			<table class="table table-bordered table-hover table-condensed" id="tablaCarpetas" data-perfilMain="<%=perfilMain%>">
				<thead>
					<tr>
						<th>Caja</th>
						<th>Carpetas</th>
						<th>% Caja</th>
						<th>Estado</th>
						<th>Fecha_Envio</th>
						<th>Acción</th>
					</tr>
				</thead>
				<tbody>
					<%for i = 0 to ubound(datos,2)
						codigoBarras = trim(datos(0,i))
						estado = server.htmlencode(trim(datos(5,i)))
						idEstado = trim(datos(4,i))
						fechaEnvio = trim(datos(6,i))
						totalMarcado = clng(trim(datos(2,i)))
						totalMarca = clng(trim(datos(3,i)))
						if totalMarca <> 0 then
							porcentajeMarca = formatpercent(totalMarcado/totalMarca,1)
							if right(porcentajeMarca,3) = ",0%" then
								enteroPorcentaje = cint(replace(porcentajeMarca,"%",""))
								porcentajeMarca = enteroPorcentaje&"%"
							end if
						else
							porcentajeMarca = "0%"
						end if
						totalDocumentos = clng(trim(datos(1,i)))
						if totalDocumentos = "" then totalDocumentos = 0
						enteroPorcentaje = cint(replace(porcentajeMarca,"%",""))%>
						<tr>
							<td><%=codigoBarras%></td>
							<td><%=totalDocumentos%></td>
							<td><%=porcentajeMarca%></td>
							<td id="estadoActual<%=i%>">
								<%=estado%>
							</td>
							<td><%=fechaEnvio%></td>
							<td id="botonera<%=i%>" class="span2">
								<%if perfilMain = "1" then %>
									<%if idEstado <> "299" and idEstado <> "204" then%>
										<span id="btnModifica<%=i%>" 
											data-idEstado="<%=idEstado%>" 
											class="modificaEstado btn btn-info btn-mini" 
											data-codigoBarras="<%=codigoBarras%>" 
											data-modifica="0" 
											data-porcentaje="<%=enteroPorcentaje%>" 
											onClick="modificaEstado('<%=i%>');" 
											data-botonera="<%=i%>" 
											data-totalDocumentos="<%=totalDocumentos%>">
											<i class="icon-edit icon-large" id="btnEstado" data-toggle="tooltip" 
											title="Modifica Estado Caja"></i></span>
									<%end if%>
								<%end if%>
								<%if totalDocumentos > 0 then %>
									<span id="listaContenido" 
										class="btn btn-success btn-mini" 
										data-codigoBarras="<%=codigoBarras%>" 
										onClick="listaContenido('<%=codigoBarras%>');">
										<i class="icon-eye-open icon-large"></i></span>
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
			"sDom": "<'row-flid'<'span5'l><'span5'f>r>t<'row-fluid'<'span5'i><'span5'p>>",
			"sPaginationType": "bootstrap"
		});
		$('#btnEstado').tooltip('show');
	});
	function modificaEstado(idBoton){		
		$('#btnModifica'+idBoton).removeClass('modificaEstado btn btn-info').text();;
		var modifica = $('#btnModifica'+idBoton).attr('data-modifica');		
		if (modifica == '0'){
			$('#btnModifica'+idBoton).attr('data-modifica', '1');
			var idEstado, codigoBarras, pagina, div, datos, porcentaje, botonera, totalDocumentos;
			idEstado = $('#btnModifica'+idBoton).attr('data-idEstado');
			codigoBarras = $('#btnModifica'+idBoton).attr('data-codigoBarras');
			porcentaje = $('#btnModifica'+idBoton).attr('data-porcentaje');
			botonera = $('#btnModifica'+idBoton).attr('data-botonera');
			totalDocumentos = $('#btnModifica'+idBoton).attr('data-totalDocumentos');
			pagina = 'report/modificaEstado.asp';
			div = 'botonera'+idBoton;
			datos='codigoBarras='+codigoBarras+'&idEstado='+idEstado+'&porcentaje='+porcentaje+'&botonera='+botonera+'&totalDocumentos='+totalDocumentos;
			enviaDatos(pagina,div,datos);
		}
	}
	function listaContenido(idCodigoBarra){
		$('#reporteDetalleTabla').slideUp('fast');
		$('#menuTrabPens').slideUp('fast');
		$('#listarContenido').slideDown('fast');

		var pagina, div, datos, idCarpeta, perfilMain;
		perfilMain = $('#tablaCarpetas').attr('data-perfilMain');
		idCarpeta = $('#idCarpeta').val();
		pagina = 'report/muestraCarpetas.asp';
		div = 'listarContenido';
		datos='idCodigoBarra='+idCodigoBarra+'&perfilMain='+perfilMain;
		enviaDatos(pagina,div,datos);
	}
	</script>
<%else%>
	<div class="row-fluid">
		<div class="span2 offset5 text-center label label-warning">
			No existen cajas
		</div>
	</div>
<%end if%>
