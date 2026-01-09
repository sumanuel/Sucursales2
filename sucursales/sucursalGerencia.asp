<!--#include file="../funciones.asp"-->
<%sql = ""
sql = sql & "select id_zona, zona from suc_zonas "
set rs = db.execute(sql)
if not rs.eof then
	datosZona = rs.GetRows()
end if
cuenta = ubound(datosZona, 2)+1
span = round(12/cuenta)
For i = 0 to ubound(datosZona, 2)%>			
	<%idZona = trim(datosZona(0,i))
	nombreZona = server.htmlencode(trim(datosZona(1,i)))%>
	<div class="span<%=span%>"><%=nombreZona%>
		<table class="table table-bordered">
			<tbody>
				<%sql2 = ""
				sql2 = sql2 & " select id_zonal,"
				sql2 = sql2 & " zonal "
				sql2 = sql2 & " from suc_zonales "
				sql2 = sql2 & " where id_zona = '"&idZona&"' "
				sql2 = sql2 & " and estado_zonal = 1 "
				set rs2 = db.execute(sql2)
				if not rs2.eof then
					datosZonal = rs2.GetRows()
				end if
				for x=0 to ubound(datosZonal,2)
					idZonal = trim(datosZonal(0,x))
					nombreZonal = server.htmlencode(trim(datosZonal(1,x)))%>
				<tr>
					<td class="seleccionaZonal mano" data-idZonal="<%=idZonal%>">
						<%=nombreZonal%>
						<span id="botonCierraZonal<%=idZonal%>" class="mano btn btn-mini pull-right oculto">
							Cerrar 
							<i class="icon-collapse-top"></i>
						</span>
						<div class="oculto" id="<%=idZonal%>">
							
								<%sql3 = ""
								sql3 = sql3 & " select id_sucursal, "
								sql3 = sql3 & " suc_nombre "
								sql3 = sql3 & " from suc_sucursal "
								sql3 = sql3 & " where id_sucursal in "
								sql3 = sql3 & " (select id_sucursal "
								sql3 = sql3 & " from SUC_zonales_sucursal "
								sql3 = sql3 & " where id_zonal = '"&idZonal&"' "
								sql3 = sql3 & " and estado_zonal = 1) "
								set rs3 = db.execute(sql3)
								if not rs3.eof then
									datosSucursal = rs3.GetRows()
								end if
								for y=0 to ubound(datosSucursal,2)
									idSucursal = trim(datosSucursal(0,y))
									nombreSucursal = server.htmlencode(trim(datosSucursal(1,y)))%>
									<div class="well">
										<%=nombreSucursal%>
										<span class="botnoeraSucursal pull-right">
											<span class="estadoSucursal">
												<i class="icon-archive text-error icon-2x"></i>
												<i class="icon-money text-success icon-2x"></i>
												<i class="icon-group text-warning icon-2x"></i>
												<span class="label label-warning">Full</span>
												<span class="label label-important">FP</span>
											</span>
										</span>
									</div>
								<%next%>
						</div>
					</td>
				</tr>
				<%next%>
			</tbody>
		</table>
	</div>
<%next%>
<script type="text/javascript">
alert('aca')
$('.seleccionaZonal').click(function(){
	idZonal = $(this).attr('data-idZonal');
	if(!$(this).hasClass('cierraZonal'))
	{
		$(this).addClass('cierraZonal');
		$('#botonCierraZonal'+idZonal).removeClass('oculto');
		$('#'+idZonal).slideDown('fast');
	}
	else
	{
		$(this).removeClass('cierraZonal');
		$('#'+idZonal).slideUp('fast');
		$('#botonCierraZonal'+idZonal).addClass('oculto');
	}
	
});
</script>
