<!--#include file="../funciones.asp"-->
<%sql = ""
sql = sql & "select id_gest_inc_tipo, gest_inc_tipo from SUC_gest_inc_tipo "
set rs = db.execute(sql)
if not rs.eof then
	do while not rs.eof
		idTipoGestion = trim(rs("id_gest_inc_tipo"))
		nombreTipoGestion = trim(rs("gest_inc_tipo"))%>
		<option value="<%=idTipoGestion%>">
			<%=nombreTipoGestion%>
		</option>
		<%rs.movenext
	loop
end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
DB.Close
set DB=nothing%>