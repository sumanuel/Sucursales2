<!--#include file="../funciones.asp"-->
<%
idUsuario = trim(request("idUsuario"))
perfil = trim(request("perfil"))
idCalitem = trim(request("idCalitem"))

sqlSuc = ""
sqlSuc = sqlSuc & " select a.id_sucvis, "
sqlSuc = sqlSuc & " a.id_usuario, "
sqlSuc = sqlSuc & " a.id_sucursal, "
sqlSuc = sqlSuc & " a.visita_motivo, "
sqlSuc = sqlSuc & " c.suc_nombre, "
sqlSuc = sqlSuc & " c.suc_tipo, "
sqlSuc = sqlSuc & " c.suc_tipoid "
sqlSuc = sqlSuc & " from SUC_sucursal_visita a "
sqlSuc = sqlSuc & " inner join SUC_calendario_item b on a.id_sucvis = b.id_op "
sqlSuc = sqlSuc & " inner join SUC_sucursal c on a.id_sucursal = c.id_sucursal "
sqlSuc = sqlSuc & " where b.id_calitem = " & idCalitem
set rsSuc = db.execute(sqlSuc)
if not rsSuc.eof then
	tipoSuc = rsSuc("suc_tipoid")
	idSucursal = rsSuc("id_sucursal")
	idVisita = rsSuc("id_sucvis")
end if

sqlEval = ""
sqlEval = sqlEval & " select id_eval, "
sqlEval = sqlEval & " id_visita, "
sqlEval = sqlEval & " id_sucursal, "
sqlEval = sqlEval & " id_usuario, "
sqlEval = sqlEval & " eval_total, "
sqlEval = sqlEval & " fecha_ingreso, "
sqlEval = sqlEval & " hora_ingreso "
sqlEval = sqlEval & " from SUC_sucursal_visita_eval "
sqlEval = sqlEval & " where id_visita = '"&idVisita&"'" 
set rsEval = db.execute(sqlEval)
if not rsEval.eof then%>
<div class="row-fluid">
	<div class="span12 ">
		<span class="span12 alert alert-info">
			<strong>
				<h4>
    				<span id="loadIcon" style="display:none;">
    					<i class="icon-spinner icon-spin icon-large"></i>
    				</span> 
        			<span class="icon-stack icon-large">
        				<i class="icon-check-empty icon-stack-base"></i>
        				<i class="icon-pushpin"></i>
        			</span> 
        			Ya fue ingresada la Evaluaci&oacute;n
    			</h4>
			</strong>
		</span>
	</div>
</div>
<div class="row-fluid">
	<div class="span12">
		<table border="0" class="table table-bordered table-hover" align="center">
			<thead>
	    		<tr align="center">
	        		<th width="1%">
	        			<strong>
	        				Pond.
	        			</strong>
	        		</th>
	        		<th width="1%">
	        			<strong>
	        				Nota
	        			</strong>
	        		</th>
	        		<th width="1%">
	        			<strong>
	        				nro
	        			</strong>
	        		</th>
	        		<th width="15%">
	        			<strong>
	        				Apertura Sucursal
	        			</strong>
	        		</th>
	        		<th width="5%">
	        			<strong>
	        				Cumplimiento
	        			</strong>
	        		</th>
	        		<th width="1%"></td>                
	    		</tr>
    		</thead>
			<%sql = ""
			sql = sql & " select a.id_matrix_item, "
			sql = sql & " a.matrix_item, "
			sql = sql & " a.matrix_item_orden, "
			sql = sql & " c.item_pond, "
			sql = sql & " c.item_pond_tipo, "
			sql = sql & " d.eval_item "
			sql = sql & " from SUC_sucursal_visita_matrix_item a "
			sql = sql & " inner join SUC_sucursal_visita_matrix b on a.id_matrix = b.id_matrix "
			sql = sql & " inner join SUC_sucursal_visita_matrix_item_pond c on a.id_matrix_item = c.id_matrix_item "
			sql = sql & " inner join SUC_sucursal_visita_eval_item d on a.id_matrix_item = d.id_item "
			sql = sql & " where b.id_matrix = 1 "
			sql = sql & " and c.id_suctipo = '" & tipoSuc & "' "
			sql = sql & " and d.id_visita = '" & idVisita & "' "
			sql = sql & " order by a.matrix_item_orden "
			set rsItem = db.execute(sql)
			if not rsItem.eof then
				indexRow = 0
				arrItems = ""
				arrSubItems = ""
				do while not rsItem.eof 		
					indexRow = indexRow + 1
					id_matrix_item = server.htmlencode(trim(rsItem("id_matrix_item")))
					matrix_item = server.htmlencode(trim(rsItem("matrix_item")))
					matrix_item_orden = server.htmlencode(trim(rsItem("matrix_item_orden")))
					item_pond = server.htmlencode(trim(rsItem("item_pond")))
					item_pond_tipo = server.htmlencode(trim(rsItem("item_pond_tipo")))
					eval_item = server.htmlencode(trim(rsItem("eval_item")))
					arrItems = arrItems & id_matrix_item & ","%>   
					<tr align="center" class="colorCampoMatrix"> 	    
						<td align="center">
							<input type="hidden" id="item_<%=id_matrix_item%>" value="<%=item_pond%>"/>
							<input type="hidden" id="item_val_<%=id_matrix_item%>" value="0"/>
							<h6>
								<%=item_pond%>
								<%=item_pond_tipo%>
							</h6>
						</td>
						<td align="center"><h6><%=eval_item%>%</h6></td>
						<td></td>
						<td><h6><%=matrix_item%></h6></td>
						<td></td>
						<td></td>                
					</tr>
					<%sqlSubItem = ""
					sqlSubItem = sqlSubItem & " select a.id_matrix_subitem, "
					sqlSubItem = sqlSubItem & " a.matrix_subitem, "
					sqlSubItem = sqlSubItem & " a.matrix_subitem_orden, "
					sqlSubItem = sqlSubItem & " c.subitem_pond, "
					sqlSubItem = sqlSubItem & " c.subitem_pond_tipo, "
					sqlSubItem = sqlSubItem & " d.val_subitem, "
					sqlSubItem = sqlSubItem & " d.val_cumpl, "
					sqlSubItem = sqlSubItem & " d.val_obs "
					sqlSubItem = sqlSubItem & " from SUC_sucursal_visita_matrix_subitem a "
					sqlSubItem = sqlSubItem & " inner join SUC_sucursal_visita_matrix_item b "
					sqlSubItem = sqlSubItem & " on a.id_matrix_item = b.id_matrix_item "
					sqlSubItem = sqlSubItem & " inner join SUC_sucursal_visita_matrix_subitem_pond c "
					sqlSubItem = sqlSubItem & " on a.id_matrix_subitem = c.id_matrix_subitem "
					sqlSubItem = sqlSubItem & " inner join SUC_sucursal_visita_eval_subitem d on "
					sqlSubItem = sqlSubItem & " a.id_matrix_subitem = d.id_subitem "
					sqlSubItem = sqlSubItem & " where a.id_matrix_item = '" & id_matrix_item & "' "
					sqlSubItem = sqlSubItem & " and c.id_suctipo = '"& tipoSuc &"' "
					sqlSubItem = sqlSubItem & " and d.id_visita = '" & idVisita & "' "
					sqlSubItem = sqlSubItem & "order by matrix_item_orden "
					set rsSubItem = db.execute(sqlSubItem)
					if not rsSubItem.eof then
						indexSubRow = 0		
						do while not rsSubItem.eof 		
							indexSubRow = indexSubRow + 1
							id_matrix_subitem = server.htmlencode(trim(rsSubItem("id_matrix_subitem")))
							matrix_subitem = server.htmlencode(trim(rsSubItem("matrix_subitem")))
							matrix_subitem_orden = server.htmlencode(trim(rsSubItem("matrix_subitem_orden")))
							subitem_pond = server.htmlencode(trim(rsSubItem("subitem_pond")))
							subitem_pond_tipo = server.htmlencode(trim(rsSubItem("subitem_pond_tipo")))
							val_subitem = server.htmlencode(trim(rsSubItem("val_subitem")))
							val_cumpl = server.htmlencode(trim(rsSubItem("val_cumpl")))
							val_obs = server.htmlencode(trim(rsSubItem("val_obs")))
							arrSubItems = arrSubItems & id_matrix_subitem & ","%>
							<tr align="center"> 	    
								<td align="center"><%=subitem_pond%><%=subitem_pond_tipo%></td>
								<td align="center"><%=val_subitem%>%</td>        
								<td><%=indexSubRow%></td>
								<td><%=matrix_subitem%></td>        
								<td>
									<%if val_cumpl = "1" then%>
										<span class="alert alert-success">
											<strong>
												Cumple
											</strong>
										</span>
									<%else%>
										<span class="alert alert-error">
											<strong>
												No Cumple
											</strong>
										</span>
									<%end if%>
									<input type="hidden" id="cumpl_<%=id_matrix_subitem%>" name="cumpl_<%=id_matrix_subitem%>">
								</td>
								<td>
								<%if val_obs <> "" then%>

									<textarea id="subitem_obs<%=id_matrix_subitem%>" cols="3" rows="3">
										<%=val_obs%>
									</textarea>
								<%end if%>
								</td>
							</tr>
							<%rsSubItem.MoveNext
						loop
					end if
					rsItem.MoveNext
				loop
			end if%>
			<tr>
				<td align="center"></td>
				<td align="center" class="colorCampoMatrix">
					<%sqlTotalEval = ""
					sqlTotalEval = sqlTotalEval & " select id_eval, "
					sqlTotalEval = sqlTotalEval & " id_visita, "
					sqlTotalEval = sqlTotalEval & " id_sucursal, "
					sqlTotalEval = sqlTotalEval & " id_usuario, "
					sqlTotalEval = sqlTotalEval & " eval_total, "
					sqlTotalEval = sqlTotalEval & " fecha_ingreso, "
					sqlTotalEval = sqlTotalEval & " hora_ingreso "
					sqlTotalEval = sqlTotalEval & " from SUC_sucursal_visita_eval "
					sqlTotalEval = sqlTotalEval & " where id_visita = " & idVisita
					set rsTotalEval = db.execute(sqlTotalEval)
					if not rsTotalEval.eof then
						evalTotal = server.htmlencode(trim(rsTotalEval("eval_total")))
					end if%>
						<input type="hidden" id="hpond_total" value=""/>  	
						<h6>
							<span id="pond_total">
								<%=evalTotal%>
							</span>%
						</h6>
					<%rsTotalEval.Close
					set rsTotalEval.ActiveConnection = nothing
					set rsTotalEval=nothing%>
				</td>
				<td></td>
				<td></td>        
				<td></td>
				<td></td>  	
			</tr>             
		</table>
	</div>
</div>
<%else
	if perfil="2" then%>
		<div class="row-fluid">
			<div class="span12" id="ingresaMatriz"></div>
		</div>
		<script type="text/javascript">
		$(function(){
			var pagina,div,datos
			pagina='visitas/agregaRevision.asp';
			div = 'ingresaMatriz';
			datos='idCalitem=<%=idCalitem%>';
			enviaDatos(pagina,div,datos);
		});
		</script>
	<%else%>
	<div class="row-fluid">
		<div class="span12">
			<span class="alert alert-error">
				<strong>
					Aún no existe Matriz de evaluación
				</strong>
			</span>
		</div>
	</div>
	<%end if
end if %>
<%rsEval.Close
set rsEval.ActiveConnection = nothing
set rsEval=nothing

rsSuc.Close
set rsSuc.ActiveConnection = nothing
set rsSuc=nothing
	
DB.Close
set DB=nothing
%>