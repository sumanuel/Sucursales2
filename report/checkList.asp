<!--#include file="../funciones2.asp"-->
<%idSucursalMain = trim(request("idSucursalMain1"))
idUsuarioMain = trim(request("idUsuarioMain1"))
'tipoMenuTrabPens = trim(request("tipoMenuTrabPens1"))
perfilMain = trim(request("perfilMain1"))
idCarpeta = trim(request("idCarpeta"))
modo = trim(request("modo"))
'response.write(idCarpeta)
'response.end

sql = ""
sql = sql & " SELECT COUNT(0) "
sql = sql & " FROM SUC_vcc_carpeta_credito CAR "
sql = sql & "  INNER JOIN SCVCC.dbo.vcc_carpeta_credito VCC_CAR on CAR.num_credito = VCC_CAR.num_credito "
sql = sql & "  INNER JOIN SCVCC.dbo.vcc_checklist CHK ON VCC_CAR.id_carpeta = CHK.id_carpeta "
sql = sql & " WHERE CAR.id_carpeta = '"&idCarpeta&"' "
set rs = db.execute(sql)
if not rs.eof then
	cuentaChkVcc = trim(rs(0))
end if

sql = ""
sql = sql & " SELECT ES.id_estado, ES.descrip_estado "
sql = sql & " FROM suc_vcc_caja CJA "
sql = sql & "  LEFT JOIN SUC_vcc_carpeta_credito CC ON CJA.id_codigo_barra = CC.id_codigo_barra "
sql = sql & "  INNER JOIN SUC_vcc_estados ES ON ES.id_estado = CJA.id_estado "
sql = sql & " WHERE ES.id_estado NOT IN (299) AND CC.id_carpeta = '"&idCarpeta&"' "
set rs = db.execute(sql)
if not rs.eof then
	idEstado = trim(rs(0))
end if

sql = ""
sql = sql & " SELECT I.alerta, I.id_log_alerta, USU.nom_usuario, LA.fecha_alerta, "
sql = sql & " LA.obs_alerta,SCC.num_credito, SCC.id_carpeta, LA.vigencia "
sql = sql & " FROM SCVCC.dbo.vcc_integracion_check_list I "
sql = sql & "  INNER JOIN SCVCC.dbo.vcc_carpeta_credito CC ON I.op_credito = CC.num_credito "
sql = sql & "  INNER JOIN SUC_vcc_carpeta_credito SCC ON I.op_credito = SCC.num_credito "
sql = sql & "  INNER JOIN SCVCC.dbo.vcc_log_alerta LA ON I.id_log_alerta = LA.id_log_alerta "
sql = sql & "  INNER JOIN SCVCC.dbo.VCC_USUARIOS USU ON CC.id_usuario = USU.id_usuario "
sql = sql & " WHERE SCC.id_carpeta = '"&idCarpeta&"' "
set rs = db.execute(sql)
if not rs.eof then
	valAlerta = rs("alerta")
	nom_usuario = rs("nom_usuario")
	fecha_alerta = rs("fecha_alerta")
	observacion_alerta = rs("obs_alerta")
end if
%>
<%if valAlerta = "1" then%>
	<div class="span12" id="divMsjAlertaCreada">
		<div class="alert">
			<i class="icon-warning-sign"></i><button type="button" class="close" data-dismiss="alert">&times;</button>
				 <strong>Documento con alerta.</strong> El usuario  <strong><%=nom_usuario%> </strong> con fecha:<strong><%=fecha_alerta%></strong> 
			<p><strong>Observación:</strong> <%=observacion_alerta%> </p>
		</div>
	</div>
<%end if
if valAlerta = "0" then%>
	<div class="span12" id="divCaducaAlerta">
		<div class="alert alert-success">
			<i class="icon-ok"></i><button type="button" class="close" data-dismiss="alert">&times;</button>
				<strong>Ha caducado la alerta.</strong> <strong>Crédito con todos sus documentos</strong> El usuario <strong><%=nom_usuario%> </strong> con fecha:<strong><%=fecha_alerta%></strong>
		</div>
	</div>
<%end if

sql = ""
sql = sql & " SELECT COUNT(0) FROM SUC_vcc_checklist WHERE id_carpeta = '"&idCarpeta&"' "
set rs = db.execute(sql)
if not rs.eof then
	cuenta = trim(rs(0))
end if
if cuenta = "0" then
	sql = ""
	sql = sql & " EXEC dbo.SCSS_prc_ingresa_checklist '"&idCarpeta&"','"&idUsuarioMain&"' "
	db.execute(sql)
end if
if modo = "" then modo = "0"
if modo = "0" then
	sql = ""
	sql = sql & " SELECT DISTINCT(ADOC.nombre_item), "
	sql = sql & "	 ADOC.id_agrupa_doc, "
	sql = sql & "	 ADOC.nro_item_agrupa, "
	sql = sql & "	 ADOC.nro_orden_agrupa "
	sql = sql & " FROM SUC_vcc_checklist CHK, "
	sql = sql & "	 SUC_vcc_tipo_doc TDOC, "
	sql = sql & "	 SUC_vcc_agrupa_doc ADOC "   
	sql = sql & " WHERE id_carpeta = '"&idCarpeta&"' "
	sql = sql & "  AND CHK.ID_Tipo_Doc = TDOC.ID_Tipo_Doc "  
	sql = sql & "  AND TDOC.id_agrupa_doc = ADOC .id_agrupa_doc "
	sql = sql & " ORDER BY ADOC.nro_orden_agrupa ASC "
	set rs = db.execute(sql)
		if not rs.eof then
			datos = rs.getrows()%>
			<div class="modal-body">
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
														<th class="span10"></th>
														<th class="span2" style="text-align:center;">
															Sucursal
														</th>
														<th class="span2" style="text-align:center;">
															Check(DMS)
														</th>
													</tr>
													<tr>
														<th class="span10">	
															item
														</th>
														<%if perfilMain <> "3" then%>
															<%if idEstado <> "203" and idEstado <> "204" then%>
																<th class="span2" style="text-align:center;">
																		<span class="badge badge-info mano" 
																		      data-idAgrupacion="<%=txtIdAgrupacion%>" onclick="selectAll(<%=txtIdAgrupacion%>)">Seleccionar Todo
																		</span>
																</th>
															<%else%>
																<th class="span2" style="text-align:center;">---</th>
															<%end if%>
														<%else%>
															<th class="span2" style="text-align:center;">---</th>
														<%end if%>
														<th class="span2" style="text-align:center;">---</th>
													</tr>
												</thead>
												<tbody>
												<%if cuentaChkVcc <> 0 then
												    sql = " "
													sql = sql & "select STDOC.nro_item_doc "
													sql = sql & " ,STDOC.nombre_tipo_doc "
													sql = sql & " ,SCC.check_OK "
													sql = sql & " ,CHKSUC.check_OK  "
													sql = sql & " ,SCC.id_checklist  "
													sql = sql & " ,SCC.ID_Tipo_Doc  "
													sql = sql & " FROM SUC_vcc_checklist SCC  "
													sql = sql & " INNER JOIN SUC_vcc_tipo_doc STDOC ON SCC.ID_Tipo_Doc = STDOC.ID_Tipo_Doc "
													sql = sql & " INNER JOIN SUC_vcc_carpeta_credito CRE ON SCC.ID_CARPETA = CRE.id_carpeta  "
													sql = sql & " INNER JOIN SCVCC.dbo.vcc_carpeta_credito VCC ON VCC.num_credito = CRE.num_credito "
													sql = sql & " INNER JOIN SCVCC.dbo.vcc_checklist CHKSUC on VCC.id_carpeta = CHKSUC.id_carpeta and CHKSUC.id_tipo_doc = SCC.id_tipo_doc "
													sql = sql & " WHERE SCC.id_carpeta = '"&idCarpeta&"'  "
													sql = sql & " AND STDOC.id_agrupa_doc = '"&txtIdAgrupacion&"'  "
												else
													sql = " "
													sql = sql & "select STDOC.nro_item_doc "
													sql = sql & " ,STDOC.nombre_tipo_doc "
													sql = sql & " ,SCC.check_OK "
													sql = sql & " ,2  "
													sql = sql & " ,SCC.id_checklist  "
													sql = sql & " ,SCC.ID_Tipo_Doc  "
													sql = sql & " FROM SUC_vcc_checklist SCC  "
													sql = sql & " INNER JOIN SUC_vcc_tipo_doc STDOC ON SCC.ID_Tipo_Doc = STDOC.ID_Tipo_Doc "
													sql = sql & " INNER JOIN SUC_vcc_carpeta_credito CRE ON SCC.ID_CARPETA = CRE.id_carpeta  "
													sql = sql & " WHERE SCC.id_carpeta = '"&idCarpeta&"'  "
													sql = sql & " AND STDOC.id_agrupa_doc = '"&txtIdAgrupacion&"'  "
													'response.write(sql)
													end if
													set rs = db.execute(sql)
													if not rs.eof then
														datos2 = rs.getrows()
													end if
													for x=0 to ubound(datos2,2)
														nroItem = trim(datos2(0,x))
														nombreTipo = server.htmlencode(trim(datos2(1,x)))
														checkSCS = trim(datos2(2,x))
														checkVCC = trim(datos2(3,x))
														idChecklist = trim(datos2(4,x))
														tipoDoc= trim(datos2(5,x))%>
													<tr>
														<td>
															<span class="badge badge-success" >
																<%=nroItem%>
															</span>
															<%=nombreTipo%>
														</td>
														<td style="text-align:center;">
														<%if idEstado <> "203" AND idEstado <> "204" then%>
															<%if checkSCS = "0" then
																	clase = "badge-success"
																	texto = "Si"
															    else
																	clase = "badge-important"
																	texto = "No"
																end if%>
															<%if perfilMain <> "3" then %>
																<span class="badge <%=clase%> mano agrupacion<%=txtIdAgrupacion%> " 
																	onClick="marcaValorCheck('<%=idChecklist%>');" 
																	data-check="<%=checkSCS%>" 
																	id="check<%=idChecklist%>" 
																	data-idUsuarioMain="<%=idUsuarioMain%>" 
																	data-idCarpeta="<%=idCarpeta%>"
																	data-tipoDoc="<%=tipoDoc%>"
																	data-idChecklist="<%=idChecklist%>"
																	>
																	<%=texto%>
																</span>
															<%else%>
																<span class="badge <%=clase%>"
																	data-check="<%=checkSCS%>" 
																	id="check<%=idChecklist%>" 
																	data-idUsuarioMain="<%=idUsuarioMain%>" 
																	data-idCarpeta="<%=idCarpeta%>"
																	data-tipoDoc="<%=tipoDoc%>">
																	<%=texto%>
																</span>
															<%end if%>
														<%else%>
															<%if checkSCS = "0" then
																	clase = "badge-success"
																	texto = "Si"
																else
																	clase = "badge-important"
																	texto = "No"
																end if%>
															<%if perfilMain = "1" then %>
																<span class="badge <%=clase%>">
																	<%=texto%>
																</span>
															<%else%>
																<span class="badge <%=clase%>">
																	<%=texto%>
																</span>
															<%end if%>
														<%end if%>
														</td>
														<td style="text-align:center;">
														<%if checkVCC = "0" then
															clase = "badge-success"
															texto = "Si"
														elseif checkVCC = "1" then
															clase = "badge-important"
															texto = "No"
														elseif checkVCC = "2" then
															clase = "badge-inverse"
															texto = "S/R"
														end if%>
														<%if perfilMain = "1" then %>
															<span class="badge <%=clase%>">
																<%=texto%>
															</span>
														<%else%>
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
		</div>
		<script type="text/javascript">

			function selectAll(valIdAgrupacion){
				$('.agrupacion'+valIdAgrupacion).each(function() {
					if ($(this).hasClass('badge-important')){
						var idChecklist = $(this).attr('data-idChecklist');
					 	marcaValorCheck(idChecklist);
					 	//console.log(idChecklist)
					}
				});
			}
			function marcaValorCheck(idChecklist)
			{
				var checkOk, valor, idUsuarioMain, idCarpeta, tipoDoc;
				valor = $('#check'+idChecklist).attr('data-check');
				//console.log(valor);
				if (valor == '0')
				{
					checkOk = '1';
					$('#check'+idChecklist).removeClass('badge-success').addClass('badge-important').text('No').attr('data-check',checkOk);
					//console.log(checkOk)
				}
				else
				{
					checkOk = '0';
					$('#check'+idChecklist).removeClass('badge-important').addClass('badge-success').text('Si').attr('data-check', checkOk);
					//console.log(checkOk)
				}

				idUsuarioMain = $.trim($('#idUsuarioMain').val());
				idCarpeta = $('#check'+idChecklist).attr('data-idCarpeta');
				tipoDoc = $('#check'+idChecklist).attr('data-tipoDoc');
				var pagina, div, datos;
				pagina = 'report/sqlCheckListColocacion.asp';
				div = 'enviaDatos';
				datos = 'idChecklist='+idChecklist+'&checkOk='+checkOk+'&idUsuarioMain1='+idUsuarioMain+'&idCarpeta='+idCarpeta+'&tipoDoc='+tipoDoc;
				enviaDatos(pagina,div,datos);
			}
			$(function(){
				$('#enviaDatos').hide('fast');
			});

			</script>
	<%end if%>
<%else
	sql = ""
	sql = sql & " SELECT DISTINCT(ADOC.nombre_item), "
	sql = sql & "	 ADOC.id_agrupa_doc, "
	sql = sql & "	 ADOC.nro_item_agrupa, "
	sql = sql & "	 ADOC.nro_orden_agrupa "
	sql = sql & " FROM SUC_vcc_checklist CHK, "
	sql = sql & "	 SUC_vcc_tipo_doc TDOC, "
	sql = sql & "	 SUC_vcc_agrupa_doc ADOC "   
	sql = sql & " WHERE id_carpeta = '"&idCarpeta&"' "
	sql = sql & "  AND CHK.ID_Tipo_Doc = TDOC.ID_Tipo_Doc "  
	sql = sql & "  AND TDOC.id_agrupa_doc = ADOC .id_agrupa_doc "
	sql = sql & " ORDER BY ADOC.nro_orden_agrupa ASC "
	set rs = db.execute(sql)
	if not rs.eof then
		datos = rs.getrows()%>
		<div class="row-fluid">
			<div class="span6">
				<span class="btn btn-mini btn-danger salirCheck" id="salirCheck">
					Salir
				</span>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12">
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
												Acción
											</th>
											<th class="span2">
												Check(DMS)
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
													<%if perfilMain = "1" then %>
													<span class="badge <%=clase%> mano agrupacion<%=txtIdAgrupacion%> " 
														onClick="marcaValorCheck('<%=idChecklist%>');" 
														data-check="<%=checkSCS%>" 
														id="check<%=idChecklist%>" 
														data-idUsuarioMain="<%=idUsuarioMain%>" 
														data-idCarpeta="<%=idCarpeta%>"
														data-tipoDoc="<%=tipoDoc%>"
														data-idChecklist="<%=idChecklist%>">
														<%=texto%>
													</span>
													<%else%>
													<span class="badge <%=clase%>" 
														data-check="<%=check%>" 
														id="check<%=idChecklist%>" 
														data-idUsuarioMain="<%=idUsuarioMain%>" 
														data-idCarpeta="<%=idCarpeta%>" 
														data-tipoDoc="<%=tipoDoc%>">
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
		<div class="row-fluid">
			<div class="span6">
				<span class="btn btn-mini btn-success siguientePaso" data-idCarpeta="<%=idCarpeta%>">
					Siguiente Paso
				</span>
				<span class="btn btn-mini btn-danger salirCheck" id="salirCheck2">
					Salir
				</span>
			</div>
		</div>

		<script type="text/javascript">
			function marcaValorCheck(idChecklist)
			{					
				var checkOk, valor, idUsuarioMain, idCarpeta, tipoDoc;
				valor = $('#check'+idChecklist).attr('data-check');
				//console.log(valor);
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
			
				idUsuarioMain = $.trim($('#idUsuarioMain').val());
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
			$('#salirCheck, #salirCheck2').click(function(){
				//var tipoMenuTrabPens = $(this).attr('data-tipoMenu');
				//alert(tipoMenuTrabPens);
				//$('#bloqueBotonAgregaCarpeta, #bloqueListadoCarpetas,#menuCarpetas').slideDown('slow');
				var pagina, div, datos;
				pagina = 'report/menuColoTipoTrabPens2.asp';
				div = 'menuTipoTrabPens';
				datos='';
				enviaDatos(pagina,div,datos);
			});
			/*$('.siguientePaso').click(function() {
				var idCarpeta = $(this).attr('data-idCarpeta');
				var txtTrabPens = $(this).attr('data-txtTrabPens');
				var pagina, div, datos;
				pagina = 'carpetas/carpetaCaja.asp';
				div = 'muestraAgregaCarpeta';
				datos='idCarpeta='+idCarpeta+'&txtTrabPens='+txtTrabPens;
				enviaDatos(pagina,div,datos);
			});*/
		</script>
	<%end if%>
<%end if%>
