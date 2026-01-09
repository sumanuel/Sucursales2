<!--#include file="../funciones.asp"-->
<%sql = ""
sql =  sql & " select "
sql =  sql & " (select COUNT(*) from SUC_sucursal_dotacion a where cargo = 1) as numjeps, " ' -- JEPS
sql =  sql & " (select COUNT(*) from SUC_sucursal_dotacion a where cargo = 2) as numjepsm, " '-- JEPS MULTI
sql =  sql & " (select COUNT(*) from SUC_sucursal_dotacion a where cargo = 3) as numao, " '-- ASISTENTE OPERACIONAL
sql =  sql & " (select COUNT(*) from SUC_sucursal_dotacion a where cargo = 4) as numvalid, " '-- VALIDADORES
sql =  sql & " (select COUNT(*) from SUC_sucursal_dotacion a where cargo = 5) as numtesor " '-- TESOREROS
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
end if
for i=0 to ubound(datos,2)
	jeps = clng(trim(datos(0,i)))
	jeps2 = clng(trim(datos(1,i)))
	jeps = jeps + jeps2
	asistenteOperacional = trim(datos(2,i))
	validadores = trim(datos(3,i))
	tesoreros = trim(datos(4,i))
next%>
<div class="row-fluid">
	<div class="span12">
		<table class="table table-bordered">
			<tbody>
				<tr>
					<td>
						<i class="icon-group icon-2x"></i>
						<span class="badge ayuda" data-placement="top" data-original-title="JEPS + JEPS M">
							<%=jeps%>
						</span>
						<span class="badge badge-success ayuda" data-placement="top" data-original-title="TESOREROS">
							<%=tesoreros%>
						</span>
						<span class="badge badge-warning ayuda" data-placement="top" data-original-title="AO">
							<%=asistenteOperacional%>
						</span>
						<span class="badge badge-info ayuda" data-placement="top" data-original-title="VALIDADORES">
							<%=validadores%>
						</span>
					</td>
				</tr>
			</tbody>			
		</table>
	</div>
</div>