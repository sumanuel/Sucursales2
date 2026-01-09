<!--#include file="../funciones.asp"-->
<%sql = "select top 1 * from glosas a, cr_historico b "
sql = sql & " where a.area='crn' and a.codigo='100' and a.area = b.area and a.codigo = b.tipo"
set rs=db.execute(sql)
if not rs.eof then
	id = trim(rs("id"))
	sla_comportamiento = trim(rs("sla_comportamiento"))
	cantidadFunc = Cdbl(trim(rs("cantidad")))
	sla = trim(rs("sla"))
	if sla_comportamiento = "pone" then
		if sla <> "Sin SLA" then
			if cantidadFunc <= Cdbl(rs("sla")) then
				img = "icon-arrow-up"
				clase = "badge-success"
				claseTr="success"
			else
				img = "icon-arrow-down"
				clase = "badge-important"
				claseTr="error"
			end if
		else
			img = "icon-minus"
			clase = "badge-info"
			claseTr="info"
		end if
	end if
	if rs("sla_comportamiento") = "nepo" then
		if cantidadFunc < Cdbl(rs("sla")) then
			img = "icon-arrow-down"
			clase = "badge-important"
			claseTr="error"
		else
			img = "icon-arrow-up"
			clase = "badge-success"
			claseTr="success"
		end if
	else
		img = "icon-minus"
		clase = "badge-info"
		claseTr="info"
	end if
	imagen = "<span class='badge "&clase&"''><i class='"&img&"''></i></span>"
	cantidad = formatNumber(trim(rs("cantidad")),0)
	fecha = FormatDateTime(trim(rs("fecha")),2)
	glosa = trim(rs("glosa"))
end if%>
<td id="<%=id%>"><%=glosa%></td>
<td><%=imagen%></td>
<td><%=cantidad%></td>
<td></td>
<td><%=fecha%></td>
<script type="text/javascript">
$('#<%=id%>').click(function(){
	//	alert('aaaa');
	});
</script>