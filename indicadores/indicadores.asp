<!--#include file="../funciones.asp"-->
<%perfil    = trim(request("perfilMain"))
idUsuario   = trim(request("idUsuarioMain"))
idSucursal  = trim(request("idSucursalMain"))
puedeCerrar = 0
if perfil = "1" then
	totalSucursales = 0
	sql = ""
	sql = sql & " select COUNT(id_sucursal) as totalSucursales"
	sql = sql & " from SUC_usuario_sucursal "
	sql = sql & " where id_usuario = '"&idUsuario&"' and estado = 0 "
	set rs = db.execute(sql)
	if not rs.eof then
		totalSucursales = cint(trim(rs("totalSucursales")))
	end if
	if totalSucursales > 1 then
		sql2 = ""
		sql2 = sql2 & " select id_sucursal, "
		sql2 = sql2 & " suc_nombre "
		sql2 = sql2 & " from SUC_sucursal "
		sql2 = sql2 & " where id_sucursal in ( "
		sql2 = sql2 & " select id_sucursal "
		sql2 = sql2 & " from SUC_usuario_sucursal "
		sql2 = sql2 & " where id_usuario = '"&idUsuario&"') "
		set rs = db.execute(sql2)
		if not rs.eof then
			arreglo = rs.GetRows()
		end if%>
		<div class="row-fluid">
			<div id="seleccionaSucursal" class="well span12" data-sucursalSelect="<%=idSucursal%>">
				<ul class="unstyled">
					<%For i = 0 to ubound(arreglo, 2)
						idSucursales     = trim(arreglo(0,i))
						nombreSucursales = trim(arreglo(1,i))
						if idSucursal = idSucursales then 
							clase = " badge-success"
						else
							clase = ""
						end if%>
						<li>
							<span class="badge <%=clase%> cambiaSucursal mano" id="<%=idSucursales%>" data-idSucursal=<%=idSucursales%> data-idUsuario="<%=idUsuario%>" data-perfil="<%=perfil%>">
								<%=nombreSucursales%>
							</span>
						</li>
					<%next%>
				</ul>
			</div>
		</div>
	<%end if%>
	<div class="row-fluid" id="divBotonCierraSucursal">
		<div class="span12 well" title="Cerrar Sucursal" data-placement="left" id="btnCierraSucursal">         
			<span class="btn btn-danger botonCierraSucursal">
				<i class="icon-signout"></i>
				<strong>
					Cerrar Sucursal
				</strong>
			</span>            
		</div>
	</div>
	<div class="row-fluid">
		<div id="auditoria" class="well tareas span12" title="Auditoría" data-placement="left"></div>
	</div>
<%end if%>
<div class="row-fluid">
	<div id="gDocumental" class="well tareas span12" title="Gestión Documental" data-placement="left"></div>
</div>
<div class="row-fluid">
	<div id="gContable" class="well  tareas span12" title="Gestión Contable" data-placement="left"></div>
</div>
<div class="row-fluid">
	<div id="gAdministrativa" class="well tareas span12" title="Gestión Administrativa" data-placement="left"></div>
</div>
<script type="text/javascript" src="js/bootstrap-tooltip.js"></script>
<script type="text/javascript">
var pagina,div,datos,idPinchado
$(function () {
	$('.tareas').tooltip();
	pagina = 'indicadores/indicadorGestiones.asp';
	div    = 'gDocumental';
	datos  = 'tipo=2';
	try{
		detiene(pagina,div,datos,60);
	}
	catch(err){}
	pagina = 'indicadores/indicadorGestiones.asp';
	div    = 'gContable';
	datos  = 'tipo=3';
	try{
		detiene(pagina,div,datos,60);
	}
	catch(err){}
	pagina = 'indicadores/indicadorGestiones.asp';
	div    = 'gAdministrativa';
	datos  = 'tipo=4';
	try{
		detiene(pagina,div,datos,60);
	}
	catch(err){}
	pagina = 'auditoria/auditoriaSucursal.asp';
	div    = 'auditoria';
	datos  = '';
	try{
		enviaDatos(pagina,div,datos);
	}
	catch(err){}
}).on('click','.botonCierraSucursal',function(){
	pagina = 'sucursales/cierraSucursal.asp';
	div    = 'divBotonCierraSucursal';
	datos  = '';
	enviaDatos(pagina,div,datos);
});
$('.tareas').click(function(){
	var idPinchado = $(this).attr('id');
	var idSucursal = $('#divMisucursal').attr('data-idSucursal');
	var pagina, div,datos;
	if(idPinchado === 'gDocumental')
	{
		pagina = 'indices/gestionAdm.asp';
		div    = 'area';
		datos  = 'tipo=2&idSucursal='+idSucursal;
	}
	if(idPinchado === 'gContable')
	{
		pagina = 'indices/gestionAdm.asp';
		div    = 'area';
		datos  = 'tipo=3&idSucursal='+idSucursal;
	}
	if(idPinchado === 'gAdministrativa')
	{
		pagina = 'indices/gestionAdm.asp';
		div    = 'area';
		datos  = 'tipo=4&idSucursal='+idSucursal;
	}
	enviaDatos(pagina,div,datos);
});
$('.cambiaSucursal').on('click',function(){
	var idSucursal = $(this).attr('data-idSucursal');
	var perfil     = $(this).attr('data-perfil');
	var idUsuario  = $(this).attr('data-idUsuario');
	var url  = 'sucursales/cambiaSession.asp?idSucursal='+idSucursal+'&perfil='+perfil+'&idUsuario='+idUsuario;
	//alert(url)
	location.href= url;
});
</script>
