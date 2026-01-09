
<!--#include file="../funciones.asp"-->
<%idGlosa = trim(request("idGlosa"))
sql= "select * from ViewCuenta where id1 ='"&idGlosa&"' "
set rs=db.execute(sql)
if not rs.eof then
Gerencia = server.HTMLENCODE(trim(rs("detalle6")))
Subgerencia = server.HTMLENCODE(trim(rs("detalle5")))
area = server.HTMLENCODE(trim(rs("NombreArea")))
descripcion = server.HTMLENCODE(trim(rs("detalle1")))
sla = server.HTMLENCODE(trim(rs("sla")))
medicion = server.HTMLENCODE(trim(rs("nombreTipoMedicion")))
acumulado = trim(rs("acumulado"))
if sla = "nosla" then
  sla = "Sin SLA"
  iconoSla = "icon-ban-circle"
end if
if acumulado = "0" then
  acumulado = "No"
  iconoAcumulado = "icon-remove"
else
  acumulado= "Si"
  iconoAcumulado = "icon-ok"
end if%>
<table border="0" class="table table-bordered table-hover table-nonfluid">
  <tr>
    <td>Pertenece a:</td>
    <td><%=Gerencia%> / <%=Subgerencia%> / <%=area%></td>
  </tr>
  <tr>
    <td>Descripción</td>
    <td><%=descripcion%></td>
  </tr>
  <tr>
    <td>Medido en</td>
    <td><%=medicion%></td>
  </tr>
  <tr>
    <td>SLA</td>
    <td><%=sla%></td>
  </tr>
  <tr>
    <td>Descripción SLA</td>
    <td>Sin Informacion</td>
  </tr>
  <tr>
    <td>Acumulado</td>
    <td><%=acumulado%></td>
  </tr>
</table>
<%end if%>