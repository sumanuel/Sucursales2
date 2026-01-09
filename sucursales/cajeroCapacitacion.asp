
<!--#include file="../funciones.asp"-->
<%perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
idSucursal = trim(request("idSucursal"))


sql = ""
sql = sql + " select acceso_cajero from SUC_usuario where id_usuario = " +idUsuario+ " "  

tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
	datosUsuario = rs.getrows()
	tieneDatos = 1
end if
if tieneDatos = 1 then
	for i = 0 to ubound(datosUsuario,2)
		perfilMain = server.htmlencode(trim(datosUsuario(0,i)))
	next
end if
%>



<div class="row-fluid" id="divCajeroCapacitacionJepps" data-idSucursal="<%=idSucursal%>" data-idUsuario="<%=idUsuario%>" data-perfil="<%=perfil%>" data-perfilMain="<%=perfilMain%>">
	<div class="row-fluid" id="capacitacionCuerpoTrabajo">
	
	</div>
</div>
<script type="text/javascript">

	$(function(){
		var idUsuario= $('#divCajeroCapacitacionJepps').attr('data-idUsuario');
		var perfilUsuario= $('#divCajeroCapacitacionJepps').attr('data-perfil');
		var perfilMain= $('#divCajeroCapacitacionJepps').attr('data-perfilMain');
		var idSucursal = $('#divCajeroCapacitacionJepps').attr('data-idSucursal');



		var div = 'capacitacionCuerpoTrabajo';
	    var datos = 'idUsuario='+idUsuario+'&perfilMain='+perfilMain+'&perfilUsuario='+perfilUsuario+'&idSucursal='+idSucursal+'&vista=2'
	    var pagina = './personal/capacitacion_DetalleCapacitacion.asp';  
	    //console.log(datos);  
	    enviaDatos(pagina,div,datos);
	});
</script>