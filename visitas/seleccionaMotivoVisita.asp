<!--#include file="../funciones.asp"-->
<%perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
sql =""
sql = sql & " select id_sucvmot, visita_motivo "
sql = sql & " from SUC_sucursal_visita_motivo"
set rs = db.execute(sql)
'########## mando datos a array
datos = rs.GetRows()%>
<select name="motivoVisita" id="motivoVisita" title="Debe seleccionar motivo de visita">
	<option value="">[Seleccione Motivo]</option>
<%For i = 0 to ubound(datos, 2)
	idMotivo = trim(datos(0,i))
	descMotivo = server.htmlencode(trim(datos(1,i)))%>
	<option value="<%=idMotivo%>"><%=descMotivo%></option>
<%next%>
</select>