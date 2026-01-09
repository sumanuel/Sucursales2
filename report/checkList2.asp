<!--#include file="../funciones2.asp"-->
<%
idCarpeta = trim(request("idCarpeta"))
idUsuarioMain = trim(request("idUsuarioMain"))
'response.write(idUsuarioMain)
'response.end

sql = ""
sql = sql & " SELECT ES.id_estado, ES.descrip_estado "
sql = sql & " FROM suc_vcc_caja CJA "
sql = sql & " INNER JOIN SUC_vcc_carpeta_credito CC ON CJA.id_codigo_barra = CC.id_codigo_barra "
sql = sql & " INNER JOIN SUC_vcc_estados ES ON ES.id_estado = CJA.id_estado "
'sql = sql & " INNER JOIN SUC_sucursal SUC ON SUC.id_sucursal = CJA.id_sucursal "
sql = sql & " WHERE ES.id_estado NOT IN (299) AND CC.id_carpeta = '"&idCarpeta&"'  "
set rs = db.execute(sql)
if not rs.eof then
	idEstado = trim(rs(0))
'response.write(idEstado)
'response.end
end if

sql = ""
sql = sql & " SELECT CC.num_credito "
sql = sql & "  ,CONVERT(VARCHAR,CC.rut_cliente)+'- '+CC.dv_cliente AS rut_cliente"
sql = sql & "  ,CC.nom_cliente "
sql = sql & "  ,CASE WHEN CC.tipo_pens_trab = 30 THEN 'Trabajador' "
sql = sql & "   WHEN CC.tipo_pens_trab = 32 THEN 'Pensionado' END AS tipo_pens_trab "
sql = sql & "  ,CC.id_codigo_barra "
sql = sql & "  ,CC.fecha_colocacion "
sql = sql & " FROM SUC_vcc_carpeta_credito CC "
sql = sql & " WHERE id_carpeta = '"&idCarpeta&"' "
set rs = db.execute(sql)
if not rs.eof then
	numCredito = trim(rs(0))
	rutCliente = trim(rs(1))
	nombreCliente = trim(rs(2))
	tipoPensTrab  = trim(rs(3))
	idCaja = trim(rs(4))
	fechaColocacion = trim(rs(5))
end if%>
<div class="row-fluid">
	<div class="span12">
		<table id="tablaDatosCheck" class="table table-bordered table-hover table-condensed">
			<tbody>
				<tr>
					<th>Número credito :</th>
					<td><%=numCredito%></td>
					<td>Rut Cliente :</td>
					<td><%=rutCliente%></td>
				</tr>
				<tr>
					<td>Nombre : </td>
					<td><%=nombreCliente%></td>
					<td>Tipo :</td>
					<td><%=tipoPensTrab%></td>
				</tr>
				<tr>
					<td>Caja :</td>
					<td><%=idCaja%></td>
					<td>Fecha colocación :</td>
					<td><%=fechaColocacion%></td>
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
									<%if idEstado <> "203" and idEstado <> "204" then%>
										<tr>
											<th class="span11">
												Item
											</th>
											<th class="span1" style="text-align:center;">
												<span class="badge badge-info mano seleccionaTodoListar" 
												data-idAgrupacion="<%=txtIdAgrupacion%>">Seleccionar Todo</span>
											</th>
										<%else%>
											<th class="span11">
												Item
											</th>
											<th class="span1" style="text-align:center;">
												--
											</th>
										</tr>
										<%end if%>
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
												<td style="text-align:center;">
												 <%if idEstado <> "203" and idEstado <> "204" then%>	
													<%if check = "0" then
														clase = "badge-success"
														texto = "Si"
													else
														clase = "badge-important"
														texto = "No"
													end if%>
													<span class="badge <%=clase%> mano agrupacion<%=txtIdAgrupacion%>" 
														onClick="marcaValorListar('<%=idChecklist%>');" 
														data-check="<%=check%>" 
														id="check<%=idChecklist%>" 
														data-idUsuario="<%=idUsuario%>" 
														data-idCarpeta="<%=idCarpeta%>" 
														data-tipoDoc="<%=tipoDoc%>" 
														data-idChecklist="<%=idChecklist%>">
														<%=texto%>
													</span>
													<%else%>
													<%if check = "0" then
														clase = "badge-success"
														texto = "Si"
													else
														clase = "badge-important"
														texto = "No"
													end if%>
													<span class="badge <%=clase%>">
														<%=texto%>
													</span>	
													<%end if%>
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
	$('.seleccionaTodoListar').click(function() {
		var valIdAgrupacion = $(this).attr('data-idAgrupacion');
		$('.agrupacion'+valIdAgrupacion).each(function() {
			if ($(this).hasClass('badge-important')){
				var idChecklist = $(this).attr('data-idChecklist');
				 marcaValorListar(idChecklist);
				 console.log(idChecklist)
			}
		});
	});
	function marcaValorListar(idChecklist)
	{
		//console.log(idChecklist);
		var checkOk, valor, idUsuarioMain, idCarpeta, tipoDoc;
		valor = $('#check'+idChecklist).attr('data-check');
		console.log(valor);
		if (valor =='0')
		{
			checkOk = '1';
			$('#check'+idChecklist).removeClass('badge-success').addClass('badge-important').text('No').attr('data-check',checkOk);
			console.log(checkOk)
		}else{
			checkOk = '0';
			$('#check'+idChecklist).removeClass('badge-important').addClass('badge-success').text('Si').attr('data-check', checkOk);
			console.log(checkOk)
		}
		idUsuarioMain = $.trim($('#idUsuarioMain1').val());
		idCarpeta = $('#check'+idChecklist).attr('data-idCarpeta');
		tipoDoc = $('#check'+idChecklist).attr('data-tipoDoc');
		var pagina, div, datos;
		pagina = 'report/sqlCheckListColocacion.asp';
		div = 'enviaDatos';
		datos='idChecklist='+idChecklist+'&checkOk='+checkOk+'&idUsuarioMain1='+idUsuarioMain+'&idCarpeta='+idCarpeta+'&tipoDoc='+tipoDoc;
		enviaDatos(pagina,div,datos);
	}
	$(function(){
		$('#enviaDatos').hide('fast');
	});

	</script>
<%end if%>