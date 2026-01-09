<!--#include file="../funciones2.asp"-->
<%
idCarpeta = trim(request("idCarpeta"))
idUsuario = trim(request("idUsuarioMain"))
'response.write(idUsuario)
'response.end

sql = ""
sql = sql & "select num_credito, "
sql = sql & " rut_cliente, "
sql = sql & " dv_cliente, "
sql = sql & " nom_cliente, "
sql = sql & " tipo_pens_trab, "
sql = sql & " id_codigo_barra, "
sql = sql & " fecha_colocacion "
sql = sql & " from SUC_vcc_carpeta_credito "
sql = sql & " where id_carpeta = '"&idCarpeta&"'"

set rs = db.execute(sql)
if not rs.eof then
	numCredito = trim(rs(0))
	rutCliente = trim(rs(1))&"-"&trim(rs(2))
	nombreCliente = trim(rs(3))
	tipo  = trim(rs(4))
	if tipo = "30" then
		nombreTipo = "Trabajador"
	else
		nombreTipo = "Pensionado"
	end if
	idCaja = trim(rs(5))
	fechaColocacion = trim(rs(6))
end if%>
<div class="row-fluid">
	<div class="span12">
		<table id="tablaDatosCheck" class="table table-bordered table-hover table-condensed">
			<tbody>
				<tr>
					<td>
						Número credito :
					</td>
					<td>
						<%=numCredito%>
					</td>
					<td>
						Rut Cliente :
					</td>
					<td>
						<%=rutCliente%>
					</td>
				</tr>
				<tr>
					<td>
						Nombre : 
					</td>
					<td>
						<%=nombreCliente%>
					</td>
					<td>
						Tipo : 
					</td>
					<td>
						<%=nombreTipo%>
					</td>
				</tr>
				<tr>
					<td>
						Caja : 
					</td>
					<td>
						<%=idCaja%>
					</td>
					<td>
						Fecha colocación : 
					</td>
					<td>
						<%=fechaColocacion%>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<%sql = ""
sql = sql & " select distinct(c.nombre_item), "
sql = sql & " c.id_agrupa_doc,"
sql = sql & " c.nro_item_agrupa, "
sql = sql & " c.nro_orden_agrupa "
sql = sql & " from SUC_vcc_checklist a, "
sql = sql & " SUC_vcc_tipo_doc b, "
sql = sql & " SUC_vcc_agrupa_doc c "
sql = sql & " where id_carpeta = '"&idCarpeta&"' "
sql = sql & " and a.ID_Tipo_Doc = b.ID_Tipo_Doc "
sql = sql & " and b.id_agrupa_doc = c .id_agrupa_doc "
sql = sql & " order by c.nro_orden_agrupa asc "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getrows()%>
	<div class="row-fluid">
		<div class="span12" id="datosModal<%=idCarpeta%>">
			<span id="enviaDatos"></span>
				<table class="table table-bordered table-hover">
					<%for i=0 to ubound(datos,2)
						nombreItem = server.htmlencode(trim(datos(0,i)))
						txtIdAgrupacion = trim(datos(1,i))
						numeroAgrupacion = trim(datos(2,i))%>
						<tr>
							<td>
								<span class="badge">
									<%=numeroAgrupacion%>
								</span>
								<%=nombreItem%>
							</td>
						</tr>
						<tr>
							<td>
								<table class="table table-bordered table-hover">
									<thead>
										<tr>
											<th class="span10">
												Item
											</th>
											<th class="span2">
												<span class="badge badge-info mano seleccionaTodo" data-idAgrupacion="<%=txtIdAgrupacion%>">Seleccionar Todo</span>
											</th>
										</tr>
									</thead>
									<tbody>
										<%sql = ""
										sql = sql & " select nro_item_doc, "
										sql = sql & " nombre_tipo_doc, "
										sql = sql & " check_OK, "
										sql = sql & " id_checklist, "
										sql = sql & " a.ID_Tipo_Doc "
										sql = sql & " from SUC_vcc_checklist a, "
										sql = sql & " SUC_vcc_tipo_doc b "
										sql = sql & " where id_carpeta = '"&idCarpeta&"' "
										sql = sql & " and a.ID_Tipo_Doc = b.ID_Tipo_Doc "
										sql = sql & " and b.id_agrupa_doc = '"&txtIdAgrupacion&"' "
										sql = sql & " order by nro_orden_doc asc "
										set rs = db.execute(sql)
										if not rs.eof then
											datos2 = rs.getrows()
										end if
										for x=0 to ubound(datos2,2)
											nroItem = trim(datos2(0,x))
											nombreTipo = server.htmlencode(trim(datos2(1,x)))
											check = trim(datos2(2,x))
											idChecklist = trim(datos2(3,x))
											tipoDoc= trim(datos2(4,x))%>
											<tr>
												<td>
													<span class="badge badge-success">
														<%=nroItem%>
													</span>
													<%=nombreTipo%>
												</td>
												<td>
													<%if check = "0" then
														clase = "badge-success"
														texto = "Si"
													else
														clase = "badge-important"
														texto = "No"
													end if%>
													<span class="badge <%=clase%> mano agrupacion<%=txtIdAgrupacion%>" onClick="marcaValor('<%=idChecklist%>');" data-check="<%=check%>" id="check<%=idChecklist%>" data-idUsuario="<%=idUsuario%>" data-idCarpeta="<%=idCarpeta%>" data-tipoDoc="<%=tipoDoc%>" data-idChecklist="<%=idChecklist%>">
														<%=texto%>
													</span>
												</td>
											</tr>
										<%next%>
									</tbody>
								</table>
							</td>
						</tr>
					<%next%>
				</table>
		</div>
	</div>
	<script type="text/javascript">
	$('.seleccionaTodo').click(function() {
		var valIdAgrupacion = $(this).attr('data-idAgrupacion');
		$('.agrupacion'+valIdAgrupacion).each(function() {
			if ($(this).hasClass('badge-important')){
				var idChecklist = $(this).attr('data-idChecklist');
				 marcaValor(idChecklist);
			}
		});
	});
	function marcaValor(idChecklist)
	{
		//console.log(idChecklist);
		var checkOk,valor,idUsuario,idCarpeta,tipoDoc;
		valor = $('#check'+idChecklist).attr('data-check');
		if (valor =='0')
		{
			checkOk = '1';
			$('#check'+idChecklist).removeClass('badge-success').addClass('badge-important').text('No').attr('data-check',checkOk);
		}
		else
		{
			checkOk = '0';
			$('#check'+idChecklist).removeClass('badge-important').addClass('badge-success').text('Si').attr('data-check', checkOk);
		}
		idUsuario = $.trim($('#idUsuario').val());
		idCarpeta = $('#check'+idChecklist).attr('data-idCarpeta');
		tipoDoc = $('#check'+idChecklist).attr('data-tipoDoc');
		var pagina, div, datos;
		pagina = 'CheckListCredito/sqlCheckColo.asp';
		div = 'enviaDatos';
		datos='idChecklist='+idChecklist+'&checkOk='+checkOk+'&idUsuario='+idUsuario+'&idCarpeta='+idCarpeta+'&tipoDoc='+tipoDoc;
		enviaDatos(pagina,div,datos);
	}
	$(function(){
		$('#enviaDatos').hide('fast');
	});
	</script>
<%end if%>