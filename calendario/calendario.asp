<!--#include file="../funciones.asp"-->
<% idSucursal = trim(request("idSucursalMain"))
mesActual = Request("mes")
anioActual = Request("anio")
perfil = trim(request("perfilMain"))
idUsuario = trim(request("idUsuarioMain"))
if IsEmpty(idSucursal) or idSucursal="0" then 
    idSucursal = trim(request("idSucursal"))
end if
If IsEmpty(mesActual) or mesActual = "" then mesActual = Month(Date)
if IsEmpty(anioActual) or anioActual = "" then anioActual = Year(Date)
fechaInicio = cdate("01"&"/"&mesActual&"/"&anioActual)
diaTermino = LastDay(mesActual,anioActual)
fechaTermino = cdate(diaTermino&"/"&mesActual&"/"&anioActual)
inicio=DatePart("ww",fechaInicio)
termino = DatePart("ww",fechaTermino)
totalSemanas = termino-inicio%>
<div class="row-fluid">
	<div class="span12">
		<form id="formCalendarioLoad" name="formCalendarioLoad">
			<input type="hidden" name="idSucursal" value="<%=idSucursal%>" id="idSucursal">
			<input type="hidden" name="mes" value="<%=mesActual%>" id="mes">
			<input type="hidden" name="anio" value="<%=anioActual%>" id="anio">
			<input type="hidden" name="perfil" id="perfil" value="<%=perfil%>">
			<input type="hidden" name="idUsuario" id="idUsuario" value="<%=idUsuario%>">
		</form>
		<table class="table table-bordered">
		<tr> 
			<td colspan="7">
				<a href='#' class="cambiaMes label" 
				<%if mesActual-1 = 0 then%>
					data-mes="12" data-anio="<%=anioActual-1%>">
						<i class='icon-chevron-left'></i>
						<i class='icon-chevron-left'></i> Mes Anterior
					</a>
				<%else%>
					data-mes="<%=mesActual - 1%>" data-anio="<%=anioActual%>">
						<i class='icon-chevron-left'></i>
						<i class='icon-chevron-left'></i> Mes Anterior
					</a>
				<%end if%>
				<span class="label label-inverse" style="margin-left: 32%;">
					<%=primeraMayuscula(server.htmlencode(MonthName(mesActual)))&" "& anioActual%>
				</span>
				<a href = "#" class="cambiaMes label pull-right"
				<%if mesActual + 1 = 13 then%>
					data-mes="1" data-anio="<%=anioActual+1%>">
						Próximo Mes
						<i class='icon-chevron-right'></i>
						<i class='icon-chevron-right'></i>
				</a>
				<%else%>
					data-mes="<%=mesActual+1%>" data-anio="<%=anioActual%>">
					Próximo Mes
					<i class='icon-chevron-right'></i>
					<i class='icon-chevron-right'></i>
				</a>
				<%end if%>
			</td>
		</tr>
		<tr> 
		<%for i= 1 to 7%>
			<td>
				<%=primeraMayuscula(server.htmlencode(weekdayname(i)))%>
			</td>
		<%next%>
		</tr>
		<%primerDia = WeekDay(DateSerial(anioActual, mesActual, 1)) -1
		hoy = 1
		For Row = 0 to totalSemanas
			For Col = 0 to 6
				If Row = 0 and Col < primerDia then %>
					<td>&nbsp;</td>
				<%elseif hoy > LastDay(mesActual, anioActual) then%>
					<td>&nbsp;</td>
				<%else
					if len(diaId) = 1 then diaId = "0"&diaId
					if len(mesId) = 1 then mensId = "0"&mesId
					fechaActualTabla= anioActual&mesId&diaId			
					sql = ""
				    sql = sql & " select feriado "
				    sql = sql & " from SUC_calendario "
				    sql = sql & " where YEAR(fecha) = '"&anioActual&"' "
				    sql = sql & " and MONTH(fecha) = '"&mesActual&"' "
				    sql = sql & " and DAY(fecha) = '"&hoy&"'"
				    'response.write(sql)
				    idFechaDia = hoy
				    idFechaMes = mesActual
				    if len(idFechaDia) = 1 then
				        idFechaDia = "0"&idFechaDia
				    end if
				    if len(idFechaMes) = 1 then
				        idFechaMes = "0"&idFechaMes
				    end if
				    idFecha = anioActual&idFechaMes&idFechaDia
				    fechaActualConsulta = idFechaDia&"/"&idFechaMes&"/"&anioActual
				    set rs = db.execute(sql)
				    if not rs.eof then
				        tipoDia = trim(rs("feriado"))
				    end if
				    claseTipoDia = ""
					response.write "<td "
					if weekday(fechaDMY(fechaActualConsulta)) = 7 or weekday(fechaDMY(fechaActualConsulta)) = 1  then
						claseTipoDia = " class='colorFeriado' "
					else
						claseTipoDia=" class='actividadesDia' "
					end if
					muestraTabla = ""
					if mesActual = Month(Date) and hoy = Day(Date) then 
						muestraTabla =  " id='"&idFecha&"' "&claseTipoDia&" width='14%' align='center'>"
						muestraTabla = muestraTabla &  "<span class='label label-important'>"&hoy&"</span></td>"
					else 
						muestraTabla =  " id='"&idFecha&"' "&claseTipoDia&" width='14%' align='center'>"
						muestraTabla = muestraTabla & hoy & "</td>"
					end if
					response.write muestraTabla
					hoy = hoy + 1
				End If
			Next%>
			</tr>
		<%Next%>
		</table>
	</div>
</div>
<%Function LastDay(mesActual, anioActual)
	Select Case mesActual
		Case 1, 3, 5, 7, 8, 10, 12
			LastDay = 31
		Case 4, 6, 9, 11
			LastDay = 30
		Case 2
			If IsDate(anioActual & "-" & mesActual & "-" & "29") Then LastDay = 29 Else LastDay = 28
		Case Else
			LastDay = 0
	End Select
End Function%>

<script type="text/javascript">
var mes = $('#mes').val();
var anio = $('#anio').val();
var idSucursal = $('#idSucursal').val();  
var pagina,div,datos
<%if perfil="1" then%>
$('.cambiaMes').click(function(){
	var mesSeleccionado = $(this).attr('data-mes');
	var anioSeleccionado = $(this).attr('data-anio');
	datos = 'mes='+mesSeleccionado+'&anio='+anioSeleccionado;
	div = 'area';
	pagina= 'calendario/calendario.asp';
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
});
<%else%>
$('.cambiaMes').click(function(){
	var mesSeleccionado = $(this).attr('data-mes');
	var anioSeleccionado = $(this).attr('data-anio');
	if (idSucursal == "")
	{
		datos = 'mes='+mesSeleccionado+'&anio='+anioSeleccionado;
		div = 'agendaZonal'    
	}
	else
	{
		datos = 'mes='+mesSeleccionado+'&anio='+anioSeleccionado;
		div = 'tareasZonal';
	}
	pagina='calendario/calendario.asp'
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
});
<%end if%>
var direccion
var valores = $('#formCalendarioLoad').serialize();
direccion = 'calendario/loadCalendar.asp?'+valores
var valores = $.getJSON(direccion,function(data){

	renderData(data['datos']);
});
function renderData(objectTable){
	var html, objIndex;
	$.each(objectTable, function(index, value) {                        
		var objIndex = '';
		objIndex = "#" + value.fecha_f1;
		var cantidad = '';
		cantidad = value.num;
		var tipo = '';
		tipo = value.id_calitipo;
		$('.actividad'+value.fecha_f1).empty();
        if($(objIndex))
		{
			if (tipo == "1")
			{
            	
            	$(objIndex).append('<div class="actividad'+value.fecha_f1+'"><br><span class="actividadesDia mano"><i class="icon-pushpin"></i><span class="badge badge-info">'+cantidad+'</span></span></div>').attr('data-tipo','1');
			}
		}
	});
};
$('.actividadesDia').click(function(){
	var tieneDatos = $(this).attr('data-tipo');
	if (tieneDatos == "1")
	{
		var fecha = $(this).attr('id');
		var datoFecha = 'fecha='+fecha;
		pagina = 'calendario/listaTareas.asp';
        <%if perfil = "2" then%>
        	div = 'areaZonal';
			//enviaDatos('calendario/listaTareas.asp',,datoFecha);
        <%end if
        if perfil = "1" then%>
        	div = 'area';
        <%end if
        if perfil = "3" then%>
        	div = 'areaTrabajoGerencia';
        <%end if%>
        try{
        	$(div).empty();
        	enviaDatos(pagina,div,datoFecha);
        }catch(err){}
	}
});
</script>