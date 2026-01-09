<!--#include file="../funciones.asp"-->
<%sql = ""
sql = sql & " select id_zonal,zonal from SUC_zonales where estado_zonal = 1 "
set rs = db.execute(sql)%>
<select name="zonal" id="zonal" title="Debe seleccionar zonal">
	<option value="">[Seleccione Zonal]</option>
<%if not rs.eof then
	datos = rs.GetRows()
	For i = 0 to ubound(datos, 2)
		idZonal = trim(datos(0,i))
		nombreZonal = server.htmlencode(trim(datos(1,i)))%>
		<option value="<%=idZonal%>">
			<%=nombreZonal%>
		</option>
	<%next
end if%>
</select>
