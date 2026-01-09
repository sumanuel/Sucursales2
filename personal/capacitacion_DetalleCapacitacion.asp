<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
perfilUsuario = trim(request("perfilUsuario"))
idSucursal =  trim(request("idSucursal"))
vista = trim(request("vista"))

sql = ""
sql = sql + "exec SCSS_prc_capa_get_box 6 "

tieneDatos=0
set rs = db.execute(sql)
if not rs.eof then
	datosPeriodo = rs.getrows()
	tieneDatos=1
end if

Glosa1 = "Este Filtro muestra todos los casos que <b>'NO'</b> se encuentra en estado <b>'CERRADO'</b>. "
Glosa2 = "Ver"

%>

<form class="form-inline" role="form" id="formDetalleCapacitacion" data-idUsuario="<%=idUsuario%>" data-perfilMain="<%=perfilMain%>" data-perfilUsuario="<%=perfilUsuario%>" data-idSucursal="<%=idSucursal%>" data-vista="<%=vista%>">
	<div style="width: 95%; margin: 0 auto;">
		<div style="font-size: 20px;text-align: center; padding-bottom: 8px; color: #99b3ff"><b>Detalle Capacitaciones</b></div>
		<div class="text-center" id="divcboPeriodoDetalleCapacitacion"><b style="font-size: 14px">Seleccione Periodo:</b>
			<select id="cboPeriodoDetalleCapacitacion">
				<option value="0">TODOS</option>
				<%if tieneDatos = 1 then					
					for i = 0 to ubound(datosPeriodo,2)
							id_periodoSel = trim(datosPeriodo(0,i))
							periodoNombreSel = trim(datosPeriodo(1,i))%>
							<option value="<%=id_periodoSel%>"><%=periodoNombreSel%></option>	
				<%	next
				end if%> 
			</select>
			<i style="font-size: 12px" class="icon-comment" data-toggle="popover" title="Filtro Todos" data-trigger="hover" data-content="<%=Glosa1%>">Filtro Todos</i>			
		</div>
		<div class="text-center oculto" id="divbtnVolverDetalleCapacitacion">
			<input id='btnVolverDetalleCapacitacion' class='btn btn-info' type='button' value='Volver'>
		</div>
		</br>
		<div id="cuerpoTrabajoDetalleCapacitacion1"></div>
		<div id="cuerpoTrabajoDetalleCapacitacion2"></div>
	</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){
	    $('[data-toggle="popover"]').popover({
	    	 html:true
	    });   

	    verTablaDetalleCapacitacionesAsignadas();
	});	

	$('#cboPeriodoDetalleCapacitacion').change(function() {	
		verTablaDetalleCapacitacionesAsignadas();
	});

	function verTablaDetalleCapacitacionesAsignadas(){		
		$('#cuerpoTrabajoDetalleCapacitacion1').html("");
		var idUsuario= $('#formDetalleCapacitacion').attr('data-idUsuario');
		var perfilMain= $('#formDetalleCapacitacion').attr('data-perfilMain');
		var perfilUsuario= $('#formDetalleCapacitacion').attr('data-perfilUsuario');
		var idSucursal= $('#formDetalleCapacitacion').attr('data-idSucursal');
		var vista= $('#formDetalleCapacitacion').attr('data-vista');
		var periodo = $('#cboPeriodoDetalleCapacitacion').val();
		//console.log(idSucursal);
     	var pagina, div, datos;
     	if (vista == 2){
     		pagina = './personal/capacitacion_DetalleCapacitacion1.asp';
     	}else{
     		pagina = 'capacitacion_DetalleCapacitacion1.asp';
     	}  
		div = 'cuerpoTrabajoDetalleCapacitacion1';
		datos=	'idUsuario='+idUsuario
				+'&perfilMain='+perfilMain
				+'&perfilUsuario='+perfilUsuario
				+'&periodo='+periodo
				+'&idSucursal='+idSucursal
				+'&vista='+vista;
		enviaDatos(pagina,div,datos);
	};



	$("#btnVolverDetalleCapacitacion").click(function (e) {
		$('#cuerpoTrabajoDetalleCapacitacion2').html('');
		verTablaDetalleCapacitacionesAsignadas();
		$('#cuerpoTrabajoDetalleCapacitacion1').removeClass('oculto');
		$('#divcboPeriodoDetalleCapacitacion').removeClass('oculto');
		$('#divbtnVolverDetalleCapacitacion').addClass('oculto');
	});



</script>