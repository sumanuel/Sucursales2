<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuarioMain"))
sql = ""
sql = sql & "select u_nombres +' '+u_apellidos as nombre_usuario from suc_usuario where id_usuario = '"&idUsuario&"'"
set rs = db.execute(sql)
if not rs.eof then
	nombreUsuarioCompleto = trim(rs(0))
else
	nombreUsuarioCompleto = ""
end if
%>
<div class="row-fluid">
	<div class="span2">
		<i class="icon-user icon-2x"></i>
	</div>
	<div class="span10">
		<a href="#"><%=nombreUsuarioCompleto%></a>
	</div>
</div>
