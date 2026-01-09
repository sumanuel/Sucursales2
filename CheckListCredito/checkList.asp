<!--#include file="../funciones2.asp"-->
<%idCarpeta = trim(request("idCarpeta"))
idUsuario = trim(request("idUsuario"))
modo = trim(request("modo"))
txtTrabPens = trim(request("tipCliente"))
perfilMain = trim(request("perfilMain"))

sql = ""
sql = sql & "SELECT COUNT(0)  FROM SUC_vcc_checklist WHERE id_carpeta = '"&idCarpeta&"' "
'response.write(idCarpeta)
'response.end

set rs = db.execute(sql)
if not rs.eof then
	cuenta = trim(rs(0))
end if
if cuenta = "0" then
	sql = ""
	sql = sql & "exec dbo.SCSS_prc_ingresa_checklist '"&idCarpeta&"' , '"&txtTrabPens&"' , '"&idUsuario&"'  "
	db.execute(sql)
end if
if modo = "" then modo = "0"
if modo = "0" then
	sql = ""
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
	'response.write(sql)
	'response.end()
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
													<th class="span10">
														Item
													</th>
													<th class="span2">
														Acción
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
												'response.write("estoy aqui")
												'response.end
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
															<span class="badge <%=clase%> mano" onClick="marcaValor('<%=idChecklist%>');" data-check="<%=check%>" id="check<%=idChecklist%>" data-idUsuario="<%=idUsuario%>" data-idCarpeta="<%=idCarpeta%>" data-tipoDoc="<%=tipoDoc%>">
																<%=texto%>
															</span>
															<%else%>
															<span class="badge <%=clase%> mano" data-check="<%=check%>" id="check<%=idChecklist%>" data-idUsuario="<%=idUsuario%>" data-idCarpeta="<%=idCarpeta%>" data-tipoDoc="<%=tipoDoc%>">
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
		function marcaValor(idChecklist)
		{
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
				//alert('mande info por la primera parte del codigo');
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

<%
'VERIFICAR SI ESTA PARTE DEL CODIGO CORRESPONSE AL BOTON DE ACTUALIZACION DEL CHECKORIGINAL
else
	sql = ""
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
			<div class="span6">
				<span class="btn btn-mini btn-danger salirCheck" data-txtTrabPens="<%=txtTrabPens%>" id="salirCheck">
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
													<span class="badge <%=clase%> mano" onClick="marcaValor(<%=idChecklist%>);" data-check="<%=check%>" id="check<%=idChecklist%>" data-idUsuario="<%=idUsuario%>" data-idCarpeta="<%=idCarpeta%>" data-tipoDoc="<%=tipoDoc%>">
														<%=texto%>
													</span>
													<%else%>
													<span class="badge <%=clase%> mano" data-check="<%=check%>" id="check<%=idChecklist%>" data-idUsuario="<%=idUsuario%>" data-idCarpeta="<%=idCarpeta%>" data-tipoDoc="<%=tipoDoc%>">
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
				<span class="btn btn-mini btn-danger salirCheck" data-txtTrabPens="<%=txtTrabPens%>" id="salirCheck2">
					Salir
				</span>
			</div>
		</div>
		<script type="text/javascript">
			function marcaValor(idChecklist)
			{
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
				idUsuario = $('#check'+idChecklist).attr('data-idUsuario');
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
			$('#salirCheck, #salirCheck2').click(function(){
				var txtTrabPens = $(this).attr('data-txtTrabPens');
				//alert(txtTrabPens)
				$('#bloqueAgregaCarpeta, #bloqueBotonCierraAgregarCarpeta').slideUp('fast');
				$('#bloqueBotonAgregaCarpeta, #bloqueListadoCarpetas,#menuCarpetas').slideDown('slow');
				var pagina, div, datos;
				pagina = 'carpetas/menuCarpetas.asp';
				div = 'menuCarpetas';
				datos='txtTrabPens='+txtTrabPens;
				enviaDatos(pagina,div,datos);
			});
			$('.siguientePaso').click(function() {
				var idCarpeta = $(this).attr('data-idCarpeta');
				var txtTrabPens = $(this).attr('data-txtTrabPens');
				var pagina, div, datos;
				pagina = 'carpetas/carpetaCaja.asp';
				div = 'muestraAgregaCarpeta';
				datos='idCarpeta='+idCarpeta+'&txtTrabPens='+txtTrabPens;
				enviaDatos(pagina,div,datos);
			});
		</script>
	<%end if%>
<%end if%>