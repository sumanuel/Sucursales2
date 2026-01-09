<!--#include file="../funciones.asp"-->
<%perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
idCalitem = trim(request("idCalItem"))
fecha = trim(request("fecha"))
fechaAnio = left(fecha,4)
fechaMes = right(left(fecha,6),2)
idTarea = trim(request("idTarea"))%>
<input type="hidden" name="idTarea" id="idTarea" value="<%=idTarea%>">
<input type="hidden" name="idCalitem" id="idCalitem" value="<%=idCalitem%>">
<div class="row-fluid">
	<div class="span12" id="divVisita">
		<%
		sql = ""
		sql = sql & " select 1 "
		sql = sql & " from SUC_sucursal_visita a "
		sql = sql & " inner join SUC_calendario_item b on a.id_sucvis = b.id_op " 
		sql = sql & " where b.id_calitem = '"&idCalitem&"' "
		set rs = db.execute(sql)
		if not rs.eof then
			tieneVisita = "1"
		else
			tieneVisita = "0"
		end if%>
		<div class="row-fluid" id="tabVisitaTareas">
			<div class="span12">
				<ul class="nav nav-tabs" id="tabVisita">    
				    <li class="active" id="visita">
				    	<a href="#">
				    		<i class="icon-fixed-width icon-home"></i>
				    		Visita
				    	</a>
				    </li>
				    <%if tieneVisita = "0" then%>
				    	<li id="informesVisitaGuarda" class="">
				    		<a href="#">
				    			<i class="icon-fixed-width icon-list-alt"></i>
				    			Registrar informe visita
				    		</a>
				    	</li>
				    <%else%>
				    	<li id="informesVisitaMuestra" class="">
				    		<a href="#">
				    			<i class="icon-fixed-width icon-list-alt"></i>
				    			Ver informe visita</a>
				    		</li>
				    <%end if%>
					<li id="volverMuestraVista" class="pull-right" data-fecha="<%=fecha%>">
						<a href="#">
							<i class="icon-reply icon-fixed-width"></i>
							Volver
						</a>
					</li>
				</ul>
			</div>
		</div>
		<div id="divVistaTarea" class="row-fluid">
			<div class="span12" id="visitaTarea"></div>
		</div>
		<div class="row-fluid oculto" id="divMuestraInforme">
			<div id="muestraInforme" class="span12"></div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	var idCalitem,pagina,div,datos;
	if ($('#visita').hasClass('active'))
	{
		idCalitem = $('#idCalitem').val();
		pagina = 'visitas/listaVisitas.asp';
		div='visitaTarea';
		datos = 'idCalitem='+idCalitem;
		try{
		       enviaDatos(pagina,div,datos);
		}catch(err){}
	}
});
$('#visita').click(function(){
	$('ul#tabVisita >li').removeClass('active');
	$('#divMuestraInforme').slideUp('fast');
	$('#divVistaTarea').slideDown('slow');
	$(this).addClass('active');

	var idCalitem = $('#idCalitem').val();
	var pagina = 'visitas/listaVisitas.asp';
	var div='visitaTarea';
	var datos = 'idCalitem='+idCalitem;
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#volverMuestraVista').click(function(){
	$('#divMuestraInforme, #tabVisitaTareas, #divVistaTarea, #tabVisita, #volverMuestraVista, #divVisita').slideUp('fast');
	$('#tablaTareas').slideDown('fast');
	$('#volverListaTarea').slideDown('fast');
	return false;
});
$('#informesVisitaGuarda').click(function(){
	$('ul#tabVisita >li').removeClass('active');
	$(this).addClass('active');
	$('#divVistaTarea').slideUp('fast');
	$('#divMuestraInforme').removeClass('oculto').slideDown('slow');
	var idCalitem = $('#idCalitem').val();
	var pagina = 'visitas/agregaRevision.asp';
	var div = 'muestraInforme';
	var datos = 'idCalitem='+idCalitem;
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('#informesVisitaMuestra').click(function(){
	$('ul#tabVisita >li').removeClass('active');
	$(this).addClass('active');
	$('#divVistaTarea').slideUp('fast');
	$('#divMuestraInforme').removeClass('oculto').slideDown('slow');
	var idCalitem = $('#idCalitem').val();
	var pagina = 'visitas/matrizRevisionVisita.asp';
	var div = 'muestraInforme';
	var datos = 'idCalitem='+idCalitem;
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
});
</script>