<!--#include file="../funciones.asp"-->
<% mes = clng(request("mes"))
idSucursal = trim(request("idSucursal"))
if idSucursal = "" or idSucursal="0" then 
    idSucursal = trim(request("idSucursal"))
end if
perfil = trim(request("perfil"))
'response.write(mes&"<br>")
'mes = 1
if mes <> "0" then
    hoy = date()
    hoy = dateadd("m", mes, hoy)
else
    hoy = date()
end if

diaHoy = day(hoy)
mesHoy = month(hoy)
anioHoy = year(hoy)

primerDiaMes = weekday("01/"&mesHoy&"/"& anioHoy) -1

'next_month = dateadd("m", 1, date())
'Find out when this month starts and ends.
'primerDia = weekday(primerDiaMes) 
'response.write(primerDiaMes)
'response.end
totalDiasMes = ultimoDia(mesHoy,anioHoy )

calendar_html = "<div class='row-fluid'><div class='mesAnterior mano pull-left  span2'>"
calendar_html = calendar_html & "<i class='icon-chevron-left'></i><i class='icon-chevron-left'></i>   "
calendar_html = calendar_html & "Mes Anterior</div>" 
calendar_html = calendar_html & "<div class='centrado  span8'>"
calendar_html = calendar_html & primeraMayuscula(MonthName(mesHoy))&"   "
calendar_html = calendar_html & anioHoy 
calendar_html = calendar_html & "</div>"
calendar_html = calendar_html & "<div class='mesProximo mano pull-right  span2'>Próximo Mes   "
calendar_html = calendar_html & "<i class='icon-chevron-right'></i><i class='icon-chevron-right'></i>"
calendar_html = calendar_html & "</div></div>"
calendar_html = calendar_html & "<table class='table table-bordered '>"

'dias de la semana'
calendar_html = calendar_html & "<tr>"
for i = 1 to 7
   calendar_html = calendar_html & "<td>"&primeraMayuscula(server.htmlEncode(WeekdayName(i)))&"</td>" 
next
calendar_html = calendar_html & "</tr>"

'comienza calendario'
calendar_html = calendar_html & "<tr>"

'Fill the first week of the month with the appropriate number of blanks.
'first_week_day = first_week_day 
for i = 0 to primerDiaMes
 calendar_html = calendar_html & "<td width='14%' align='center'>&nbsp;</td>"   
next

for cuentaDias = 1 to totalDiasMes
    fechaActualTabla= cuentaDias&"/"&mesHoy&"/"&anioHoy
    diaActual = weekday(fechaActualTabla)
    'week_day = week_day mod 7
    if diaActual = 6 then
        calendar_html = calendar_html & "</tr><tr>"
    end if
    if diaActual = 6 or diaActual = 5  then
        claseTipoDia = "colorFeriado"
    else
        claseTipoDia = ""
    end if
    'Do something different for the current day.
    sql = ""
    sql = sql & " select feriado "
    sql = sql & " from SUC_calendario "
    sql = sql & " where YEAR(fecha) = '"&anioHoy&"' "
    sql = sql & " and MONTH(fecha) = '"&mesHoy&"' "
    sql = sql & " and DAY(fecha) = '"&cuentaDias&"'"
    idFechaDia = cuentaDias
    idFechaMes = mesHoy
    if len(idFechaDia) = 1 then
        idFechaDia = "0"&idFechaDia
    end if
    if len(idFechaMes) = 1 then
        idFechaMes = "0"&idFechaMes
    end if
    idFecha = anioHoy&idFechaMes&idFechaDia
    set rs = db.execute(sql)
    if not rs.eof then
        tipoDia = trim(rs("feriado"))
    end if

    calendar_html = calendar_html & "<td width='14%' align='center' class='"&claseTipoDia&" actividadesDia' id='"&idFecha&"' data-tipo='0'>"
    calendar_html = calendar_html & "<a href='#'>"
    if todays_day <> day_counter then
        calendar_html = calendar_html & cuentaDias
    else
        calendar_html = calendar_html & "<strong>"&cuentaDias&"</strong>"
    end if
    calendar_html = calendar_html &"</a>"
    calendar_html = calendar_html &"</ul></td>"
    week_day = week_day + 1
next
calendar_html = calendar_html & "</tr>"
calendar_html = calendar_html & "</table>"
calendar_html = calendar_html & "<input type='hidden' name='idSucursal' value='"&idSucursal&"' id='idSucursal'>"
calendar_html = calendar_html & "<input type='hidden' name='mes' value='"&mes&"' id='mes'>"
f_calendar = calendar_html

response.Write(f_calendar)%>
<script type="text/javascript">
$('.mesAnterior').click(function(){
    var valorMes= parseInt($('#mes').val());
    valorMes -= 1
    var idSucursal = $('#idSucursal').val();
    if (idSucursal == "")
    {
        //alert('aca!')
        var valor = 'mes='+valorMes;
        var div = 'agendaZonal'    
    }
    else
    {
        
        var valor = 'mes='+valorMes;
        var div = 'tareasZonal';
    }
    enviaDatos('calendario/calendario.asp',div,valor);
});
$('.mesProximo').click(function(){
    var valorMes= parseInt($('#mes').val());
    valorMes += 1
    var idSucursal = $('#idSucursal').val();
    if (idSucursal == "")
    {
        var valor = 'mes='+valorMes;
        var div = 'agendaZonal'    
    }
    else
    {
        var valor = 'mes='+valorMes+'&idSucursal='+idSucursal;
        var div = 'tareasZonal';
    }
    enviaDatos('calendario/calendario.asp',div,valor);
});
<%if idSucursal = "" then %>
var valores = $.getJSON('calendario/loadCalendar.asp', function(data) {
    renderData(data['datos']);
});
<%else%>
var valores = $.getJSON('calendario/loadCalendar.asp?sucursal=<%=idSucursal%>', function(data) {
    renderData(data['datos']);
});
<%end if%>
function renderData(objectTable){
    var html = '';
    var objIndex = '';
    $.each(objectTable, function(index, value) {                        
        var objIndex = "#" + value.fecha_f1;
        $(objIndex).addClass('mano');
        var cantidad = value.num;
        var tipo = value.id_calitipo;
        if($(objIndex))
        {
            if (tipo == "1")
            {
            $(objIndex).append('<i class="icon-pushpin"></i><span class="badge badge-info">'+cantidad+'</span>').attr('data-tipo','1');
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
        <%if perfil = "2" then%>
        enviaDatos('calendario/listaTareas.asp','areaZonal',datoFecha);
        <%else%>
        enviaDatos('calendario/listaTareas.asp','area',datoFecha);
        <%end if%>
    }
});
</script>