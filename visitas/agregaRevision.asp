<!--#include file="../funciones.asp"-->
<%
idUsuario = trim(request("idUsuario"))
perfil = trim(request("perfil"))
idCalitem = trim(request("idCalitem"))

sql = ""
sql = sql & "select a.id_sucvis, a.id_usuario, a.id_sucursal, a.visita_motivo, c.suc_nombre, c.suc_tipo, c.suc_tipoid "
sql = sql & "from SUC_sucursal_visita a "
sql = sql & "inner join SUC_calendario_item b on a.id_sucvis = b.id_op "
sql = sql & "inner join SUC_sucursal c on a.id_sucursal = c.id_sucursal "
sql = sql & "where b.id_calitem = " & idCalitem
'response.write(sql&"<br>")
set rs = db.execute(sql)
if not rs.eof then
	tipoSuc = trim(rs("suc_tipoid"))
	idSucursal = trim(rs("id_sucursal"))
	idVisita = trim(rs("id_sucvis"))
end if%>
<div class="row-fluid">
	<div class="span12 well" id="contieneMatriz">
		<form id="matrizRevisionVisita" name="matrizRevisionVisita">
			<input type="hidden" id="vidCalitem" value="<%=idCalitem%>"/>
			<input type="hidden" id="idVisita" value="<%=idVisita%>"/>
			<input type="hidden" id="idSucursal" value="<%=idSucursal%>"/>
			<span class="span12 alert alert-success">
				<strong>
					<h4>
						<span id="loadIcon" style="display:none;">
							<i class="icon-spinner icon-spin icon-large"></i>
						</span> 
						<span class="icon-stack icon-large">
							<i class="icon-check-empty icon-stack-base"></i>
							<i class="icon-pushpin"></i>
						</span> 
						Matriz Revisi&oacute;n Visita
					</h4>
				</strong>
			</span>
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
						<th width="1%"></th>
					</tr>
				</thead>
				<%sql = ""
				sql = sql & " select a.id_matrix_item, "
				sql = sql & " a.matrix_item, "
				sql = sql & " a.matrix_item_orden, "
				sql = sql & " c.item_pond, "
				sql = sql & " c.item_pond_tipo "
				sql = sql & " from SUC_sucursal_visita_matrix_item a "
				sql = sql & " inner join SUC_sucursal_visita_matrix b on a.id_matrix = b.id_matrix "
				sql = sql & " inner join SUC_sucursal_visita_matrix_item_pond c on a.id_matrix_item = c.id_matrix_item "
				sql = sql & " where b.id_matrix = 1 and c.id_suctipo = '"&tipoSuc&"' "
				sql = sql & " order by a.matrix_item_orden "
				set rsItem = db.execute(sql)
				if not rsItem.eof then
					datos = rsItem.GetRows()
				end if
				indexRow = 0
				arrItems = ""
				arrSubItems = ""
				for i = 0 to ubound(datos,2)
					indexRow = indexRow + 1
					id_matrix_item = server.htmlencode(trim(datos(0,i)))
					matrix_item = server.htmlencode(trim(datos(1,i)))
					matrix_item_orden = server.htmlencode(trim(datos(2,i)))
					item_pond = server.htmlencode(trim(datos(3,i)))
					item_pond_tipo = server.htmlencode(trim(datos(4,i)))
					arrItems = arrItems & id_matrix_item & ","%>
					<tr align="center" style="background-color:#FC3">
						<td align="center">
							<input type="hidden" id="item_<%=id_matrix_item%>" value="<%=item_pond%>"/>
							<input type="hidden" id="item_val_<%=id_matrix_item%>" value="0"/>
							<h6>
								<%=item_pond%><%=item_pond_tipo%>
							</h6>
						</td>
						<td align="center">
							<span id="pond_<%=id_matrix_item%>"></span>
						</td>
						<td>
							<%=indexRow%>
						</td>
						<td>
							<h6>
								<%=matrix_item%>
							</h6>
						</td>
						<td></td>
						<td></td>
					</tr>
					<%sqlSubItem = ""
					sqlSubItem = sqlSubItem & " select a.id_matrix_subitem, "
					sqlSubItem = sqlSubItem & " a.matrix_subitem, "
					sqlSubItem = sqlSubItem & " a.matrix_subitem_orden, "
					sqlSubItem = sqlSubItem & " c.subitem_pond, "
					sqlSubItem = sqlSubItem & " c.subitem_pond_tipo "
					sqlSubItem = sqlSubItem & " from SUC_sucursal_visita_matrix_subitem a "
					sqlSubItem = sqlSubItem & " inner join SUC_sucursal_visita_matrix_item b "
					sqlSubItem = sqlSubItem & " on a.id_matrix_item = b.id_matrix_item "
					sqlSubItem = sqlSubItem & " inner join SUC_sucursal_visita_matrix_subitem_pond c "
					sqlSubItem = sqlSubItem & " on a.id_matrix_subitem = c.id_matrix_subitem "
					sqlSubItem = sqlSubItem & " where a.id_matrix_item = " & id_matrix_item & " "
					sqlSubItem = sqlSubItem & " and c.id_suctipo = "& tipoSuc &" "
					sqlSubItem = sqlSubItem & " order by matrix_item_orden "
					set rsSubItem = db.execute(sqlSubItem)
					indexSubRow = 0
					if not rsSubItem.eof then
						datos2 = rsSubItem.GetRows()
					end if
					for x = 0 to ubound(datos2,2)
						indexSubRow = indexSubRow + 1
						id_matrix_subitem = trim(datos2(0,x))
						matrix_subitem = server.htmlencode(trim(datos2(1,x)))
						matrix_subitem_orden = server.htmlencode(trim(datos2(2,x)))
						subitem_pond = server.htmlencode(trim(datos2(3,x)))
						subitem_pond_tipo = server.htmlencode(trim(datos2(4,x)))
						arrSubItems = arrSubItems & id_matrix_subitem & ","%>
						<tr align="center"> 	    
							<td align="center">
								<%=subitem_pond%>
								<%=subitem_pond_tipo%>
							</td>
							<td align="center">
								<select class="input-mini nota_<%=id_matrix_item%> sumaNota required" id="<%=id_matrix_subitem%>" data-item="<%=id_matrix_item%>" name="<%=id_matrix_subitem%>" title="Debe seleccionar nota">
									<option value="">[Nota]</option>
									<%nro_pond = 0
									do while nro_pond <= Cint(subitem_pond)%>
										<option value="<%=nro_pond%>"><%=nro_pond%>%</option>
										<%nro_pond = nro_pond + 1
									loop%>                
								</select>
							</td>       
							<td>
								<%=indexSubRow%>
							</td>
							<td>
								<%=matrix_subitem%>
							</td>
							<td>
								<select class="input-small" id="cumpl_<%=id_matrix_subitem%>">
									<option value="1">Cumple</option>
									<option value="2">No Cumple</option>
								</select>
							</td>
							<td>
								<span class="mano addObs" data-idMatrixSubItem="<%=id_matrix_subitem%>">
									<i class="icon-file-text-alt icon-large"></i>
								</span>
								<span id="subitem_spanobs<%=id_matrix_subitem%>" style="display:none"><br/>
									<textarea id="subitem_obs<%=id_matrix_subitem%>" rows="2"></textarea>
								</span>
							</td>
						</tr>
					<%next
				next%>
				<tr>
					<td></td>
					<td align="center" style="background-color:#FC3">
						<input type="hidden" id="hpond_total" value=""/>  	
						<h6>
							<span id="pond_total">0</span>%
						</h6>
					</td>
					<td></td>
					<td></td>        
					<td></td>
					<td></td>  	
				</tr>      
			</table>
			<input type="hidden" id="arr_items" value="<%=arrItems%>"/>
			<input type="hidden" id="arr_subitems" value="<%=arrSubItems%>"/>
			<span id="botonera">
			<span id="validador" class="hidden alert alert-error"></span>
			<span id="envia" class="hidden"><strong>Ingresando</strong> <img src="img/loader.gif"/></span> 
			</span>
			<input type="button" name="buttonIngreso" id="buttonIngreso" value="Ingresar" class="btn btn-success">
		</form>
	</div>
</div>
<script src="js/jquery.validate.js" type="text/javascript"></script>
<script src="js/additional-methods.js" type="text/javascript"></script>
<script type="text/javascript">
$(function() {
	var div, datos, pagina
	$('.addObs').click(function(){
		var subItem = $(this).attr('data-idMatrixSubItem');
		addObs(subItem);
	});
	$('.sumaNota').change(function(){
		item = $(this).attr('data-item');
		doSumNota(item);
	});
	$('#buttonIngreso').click(function(){
		totalErrores = 0;
	$('.required').each(function() {
		valor = $(this).val();
		if (valor=="")
		{
			$(this).addClass('error');
			totalErrores++ 
		}
		else
		{
			$(this).removeClass('error');
		}
	});
	if (totalErrores > 0)
	{
		$('#validador').text('Tiene '+totalErrores+' campos vacios').removeClass('hidden');
	}
	else
	{
		$('#envia').removeClass('hidden');
		$('#validador').addClass('hidden');
		var vidCalitem = $('#vidCalitem').val();
		var xml = saca();

		$('#buttonIngreso').hide();
		pagina = 'visitas/matrizRevisionVisita_prc.asp';
		var rand = '&v='+ Math.random() * 999;
		var ajaxobject = $.ajax({
			type:'GET',
			url:pagina,
			cache:false,
			//async:true,
			global:false,
			dataType:"html",
			data:xml,
			timeout:10000,
			success:function(contenido){
				var vidCalitem = $('#vidCalitem').val();
				$('#informesVisitaGuarda').html('<a href="#"><i class="icon-fixed-width icon-list-alt"></i>Ver informe visita</a>').attr('id','informesVisitaMuestra');
				try{
					pagina = 'visitas/matrizRevisionVisita.asp';
					div = 'muestraInforme';
					datos = 'idCalitem='+vidCalitem;
					enviaDatos(pagina,div,datos);
				}
				catch(err){}
			}
		});
		if(ajaxobject == undefined)
			alert('Problemas en la generacion del objeto');
	}
	});
});
function doSumNota(idItem){		
	var indexClass = 'nota_'+idItem;
	var pond = $('#item_'+idItem).val();
	var suma = 0;
	$('.'+indexClass).each(function(){
		valor = $(this).val();
		if (isNaN(valor) || valor =="")
		{
			valor = 0;
		}
		suma += parseInt(valor);       	
	});
	var pond_total = (pond*((suma/100)));
	var html = '<h6>'+Number(pond_total).toFixed(2)+'%</h6>';
	$('#pond_'+idItem).html(html);
	$('#item_val_'+idItem).val(Number(pond_total).toFixed(2));
	var arrItems = $('#arr_items').val();
	if(arrItems.length > 1){
		arrItems = arrItems.substring(0, (arrItems.length-1));			
		arrItems_v = arrItems.split(',');
		var total = 0
		$.each(arrItems_v, function(index, value){
			total += parseFloat($('#item_val_'+value).val());				
		})
		total = Number(total).toFixed(2);
		$('#pond_total').text(total);
		$('#hpond_total').val(total);
	}
}
function addObs(subitem){
	$('#subitem_spanobs'+subitem).show();
}
function saca()
{
	var xml = '';
	var arrItems_v = 0;
	xml = '<root>';
	var arrItems = $('#arr_items').val();
	if(arrItems.length > 1){
		arrItems = arrItems.substring(0, (arrItems.length-1));			
		arrItems_v = arrItems.split(',');
	}
	xml = xml + '<eval>';
	xml = xml + '<idvisita>'+ $('#idVisita').val() +'</idvisita>';
	xml = xml + '<idsucursal>'+ $('#idSucursal').val() +'</idsucursal>';
	xml = xml + '<total>'+ $('#hpond_total').val() +'</total>';
	xml = xml + '</eval>';
	xml = xml + '<items>';
	var sumaSubItems = 0;
	$.each(arrItems_v, function(index, value){
		xml = xml + '<item>';
		xml = xml + '<id>' + value + '</id>';			
		xml = xml + '<item_pond>' + $('#item_val_'+value).val() + '</item_pond>';
		xml = xml + '<subitems>';
		$('.nota_'+value).each(function(){
	 		valor = $(this).val();
			idSubItem = $(this).attr("id");
			xml = xml + '<subitem>';
			xml = xml + '<id>' + idSubItem + '</id>';
			xml = xml + '<val>' + valor + '</val>';
			xml = xml + '<obs>'+$('#subitem_obs'+idSubItem).val()+'</obs>';
			xml = xml + '<cumpl>'+$('#cumpl_'+idSubItem).val()+'</cumpl>';
			xml = xml + '</subitem>'  	
		})	
		xml = xml + '</subitems>';
		xml = xml + '</item>';
		sumaSubItems = 0;
	})
	xml = xml + '</items>';
	xml = xml + '</root>';
	var numero = '&v='+ Math.random() * 999
	var datos = 'xml='+xml+numero;
	return datos;
}
</script>