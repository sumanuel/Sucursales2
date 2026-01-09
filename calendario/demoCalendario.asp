<!--#include file="../funciones.asp"-->
demo Calendario
<%fechaActual = date()
mes = month(date)
if len(mes) = 1 then mes = "0"&mes
anio = year(date)
primerDiaMes = Weekday("01"&"/"&mes&"/"&anio)
response.write(primerDiaMes)
diaFecha= 1%>
<table>
	<tbody>
		<tr>
			<%for diasSemana = 1 to 7%>
				<td>
					<%=primeraMayuscula(WeekDayName(diasSemana))%>
				</td>
			<%next%>
		</tr>
		<%for semanaMes = 1 to 5%>
			<tr>
				<%for diaMes = 1 to 7%>
					<td>
						<%if semanaMes = 1 then response.write("aca va")%>
						<%fechaMuestra = diaFecha&"/"&mes&"/"&anio
						response.write(fechaMuestra)%>
					</td>
				<%diaFecha = diaFecha+1
				next%>
			</tr>
			<%'diaFecha = diaFecha+7
		next%>
	</tbody>
</table>