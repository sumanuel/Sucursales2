<!--#include file="../conexion/conexion.asp"-->
<%
idSucursal = trim(request("idSucursal"))
'idSucursal=120

sql = ""
sql = sql & " select a.id_asistencia, "
sql = sql & " a.guardia_nombre, "
sql = sql & " a.guardia_rut, "
sql = sql & " tipo_suc, "
sql = sql & " isnull(a.asistencia,''), "
sql = sql & " a.entrada_hora +':'+a.entrada_min, "
sql = sql & " a.salida_hora +':'+a.salida_min "
sql = sql & " from SUC_sucursal_guardias_asistencia a, "
sql = sql & " SUC_sucursal b "
sql = sql & " where a.cod_bantotal = b.cod_bantotal "
sql = sql & " and a.id_sucursal = '"&idSucursal&"' "
sql = sql & " order by tipo_suc desc "


'response.Write(sql & "<br/>")
'response.End()

set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()%>
<div class="row-fluid">
	<div class="span12 alert alert-success">
		<strong>
			<h4>
				<span id="loadIcon" style="display:none;">
					<i class="icon-spinner icon-spin icon-large"></i>
				</span>
				<span class="icon-stack icon-large">
					<i class="icon-check-empty icon-stack-base"></i>
					<i class="icon-shield"></i>
				</span> 
				Asistencia Guardias
			</h4>
		</strong>
	</div>
</div>
<div class="row-fluid">
	<div class="span12">
		<table class="table table-bordered table-hover">
			<thead>
				<tr>
					<th>Rut Guardia</th>
					<th>Nombre Completo</th>
					<th>Cargo</th>
					<th>Asistencia</th>
					<th>Horario Entrada</th>
					<th>Horario Salida</th>
					<th>Fecha Inicio</th>
					<th>Fecha Termino</th>
					<th>Titular a reemplazo</th>
					<th>Accion</th>
				</tr>
			</thead>
			<tbody>
				<%For i = 0 to ubound(datos, 2)
					idAsistencia = trim(datos(0,i))
					nombreGuardia = trim(datos(1,i))
					rutGuardia = trim(datos(2,i))
					cargoGuardia = server.htmlencode(trim(datos(3,i)))
					asistenciaGuardia = server.htmlencode(trim(datos(4,i)))
					horaEntradaGuardia = trim(datos(5,i))
					if horaEntradaGuardia <> "" then
						hora = hour(cdate(horaEntradaGuardia))
						if len(hora) = 1 then hora = "0"&hora
						minutos = minute(cdate(horaEntradaGuardia))
						if len(minutos) = 1 then minutos = "0"&minutos
						horaEntradaGuardia = hora&":"&minutos
					else
						horaEntradaGuardia = ""
					end if
					if cargoGuardia <> "titular" then
						sql = ""
						sql = sql & " select desde, "
						sql = sql & " hasta, "
						sql = sql & " b.guardia_nombre "
						sql = sql & " from SUC_sucursal_guardias_r a, "
						sql = sql & " SUC_sucursal_guardias_asistencia b "
						sql = sql & " where a.guardia_rut = '"&rutGuardia&"' "
						sql = sql & " and a.guardia_rut_titular = b.guardia_rut "
						set rs = db.execute(sql)
						if not rs.eof then
							fechaDesde = cdate(trim(rs(0)))
							anioDesde = year(fechaDesde)
							mesDesde = month(fechaDesde)
							if len(mesDesde) = "1" then mesDesde = "0"&mesDesde
							diaDesde = day(fechaDesde)
							if len(diaDesde) = "1" then diaDesde = "0"&diaDesde
							fechaDesde = diaDesde&"/"&mesDesde&"/"&anioDesde
							fechaHasta = trim(rs(1))

							anioHasta = year(fechaHasta)
							mesHasta = month(fechaHasta)
							if len(mesHasta) = "1" then mesHasta = "0"&mesHasta
							diaHasta = day(fechaHasta)
							if len(diaHasta) = "1" then diaHasta = "0"&diaHasta
							fechaHasta = diaHasta&"/"&mesHasta&"/"&anioHasta

							reemplaza = trim(rs(2))
						else

						end if
					else
						fechaDesde = ""
						fechaHasta = ""
						reemplaza = ""
					end if

					horaSalidaGuardia = trim(datos(6,i))
					if horaSalidaGuardia <> "" then
						hora = hour(cdate(horaSalidaGuardia))
						if len(hora) = 1 then hora = "0"&hora
						minutos = minute(cdate(horaSalidaGuardia))
						if len(minutos) = 1 then minutos = "0"&minutos
						horaSalidaGuardia = hora&":"&hora
					else
						horaSalidaGuardia = ""
					end if%>						
					<tr id="<%=idAsistencia%>">
						<td>
							<%=rutGuardia%>
						</td>
						<td id="nombreGuardia<%=idAsistencia%>" data-nombreGuardia="<%=nombreGuardia%>" data-rutGuardia="<%=rutGuardia%>">
							<%=nombreGuardia%>
						</td>
						<td>
							<%=cargoGuardia%>
						</td>
						<td>
							<%=asistenciaGuardia%>
						</td>
						<td>
							<%=horaEntradaGuardia%>
						</td>
						<td>
							<%=horaSalidaGuardia%>
						</td>
						<td>
							<%=fechaDesde%>
						</td>
						<td>
							<%=fechaHasta%>
						</td>
						<td>
							<%=reemplaza%>
						</td>
						<td>
							<i class="icon-file icon-large mano modPersonal" data-idAsistPersonal="<%=idAsistencia%>"></i>
						</td>
						<td id="eliminaGuardia<%=idAsistencia%>">
							<i class="icon-trash icon-large mano delPersonal" data-idAsistPersonal="<%=idAsistencia%>" id="delPersonal<%=idAsistencia%>"></i>
							<span class="oculto" id="btnConfirma<%=idAsistencia%>">
								<label class="btn btn-success botonConfirmaEliminar" data-idAsistPersonal="<%=idAsistencia%>" id="botonConfirmaEliminar<%=idAsistencia%>" data-rutGuardia="<%=rutGuardia%>" data-idSucursal="<%=idSucursal%>">
									Eliminar
								</label>
								<label class="btn btn-danger botonCancelaEliminar" data-idAsistPersonal="<%=idAsistencia%>" id="botonCancelaEliminar<%=idAsistencia%>">
									Cancelar
								</label>
							</span>
						</td>
					</tr>
				<%next%>
			</tbody>
		</table>
	</div>
</div>
<%else%>
<div class="row-fluid">
	<div class="span3 offset4 alert alert-danger">No existe guardia titular</div>
</div>
<%end if%>
<script type="text/javascript">
$('.btnCerrar').click(function(){			
	$('#lst_persuc_rem').hide();
});

$('.modPersonal').click(function(){		
	var idPersonal = $(this).attr("data-idAsistPersonal");
	var nombreGuardia = $('#nombreGuardia'+idPersonal).attr('data-nombreGuardia');
	$('#nombreGuardia'+idPersonal).html('<input type="text" name="nombreGuardiaCampo'+idPersonal+'" id="nombreGuardiaCampo'+idPersonal+'" value="'+nombreGuardia+'" placeholder="Ingrese Nombre Guardia"><span class="btn btn-success" id="modificaGuardia'+idPersonal+'" data-idAsistPersonal="'+idPersonal+'" onClick="modificaGuardia('+idPersonal+')">Modificar</span>');
});
	
$('.delPersonal').on('click', function(){				
	var idAsist = $(this).attr('data-idasistpersonal');
	//alert('DelPersonal:'+idAsist);
	$(this).fadeOut('fast');
	$('#btnConfirma'+idAsist).fadeIn('slow');
	$('#botonConfirmaEliminar'+idAsist).fadeIn('slow');
	$('#botonCancelaEliminar'+idAsist).fadeIn('slow');
});
$(function(){
	$('.botonCancelaEliminar').click(function() {
		var idPersonal = $(this).attr("data-idAsistPersonal");
		$('#btnConfirma'+idPersonal).slideUp('slow');
		$('#delPersonal'+idPersonal).fadeIn('slow');
	});
	$('.botonConfirmaEliminar').click(function(){
		var idAsist = $(this).attr('data-idasistpersonal');
		var idSucursal = $(this).attr('data-idSucursal')
		$('#eliminaGuardia'+idAsist).html('<div id="eliminaGuardias'+idAsist+'" class="oculto"></div><div id="imagenElimina'+idAsist+'"><img src="../img/loader.gif"></div>');
		var rutGuardia = $(this).attr('data-rutGuardia');
		var div = 'eliminaGuardias'+idAsist
		var pagina = 'sqlGuardias.asp'
		var datos= 'tipoPersonal=3&rutGuardia='+rutGuardia
		enviaDatos(pagina,div,datos);
		var div = 'lst_persuc_rem';
		var datos = '';
		var pagina = 'asistenciaSucursalGuardias.asp';
		datos = 'idSucursal=' + $("#sucursales").val();
		setTimeout(function() {
			enviaDatos(pagina,div,datos);
		}, 2000);
	});
	
});
function modificaGuardia(idAsist)
{
	var campo = $('#nombreGuardiaCampo'+idAsist).val();
	$('#nombreGuardia'+idAsist).html('<div id="modificaGuardias'+idAsist+'" class="oculto"></div><div id="imagenModifica'+idAsist+'"><img src="../img/loader.gif"></div>');
	var rutGuardia = $('#nombreGuardia'+idAsist).attr('data-rutGuardia');
	var div = 'eliminaGuardias'+idAsist
	var pagina = 'sqlGuardias.asp'
	var datos= 'tipoPersonal=4&rutGuardia='+rutGuardia+'&nombreGuardia='+campo
	enviaDatos(pagina,div,datos);
	var div = 'lst_persuc_rem';
	var datos = '';
	var pagina = 'asistenciaSucursalGuardias.asp';
	datos = 'idSucursal=' + $("#sucursales").val();
	setTimeout(function() {
		enviaDatos(pagina,div,datos);
	}, 2000);
}
</script>
