<!--#include file="../funciones.asp"-->
<%respuesta = trim(request("respuesta"))
if respuesta = "" then respuesta = 0
mensaje = trim(request("mensaje"))
idUsuario = trim(request("idUsuario"))
idSucursal = trim(request("idSucursal"))
idInicia = trim(request("respuesta"))
if idInicia = "" then idInicia = "0"
sql = ""
sql = sql & " insert into SUC_timeline values ("
sql = sql & " '"&idUsuario&"', "
sql = sql & " '"&idSucursal&"', "
sql = sql & " '"&mensaje&"', "
sql = sql & " '"&respuesta&"', "
sql = sql & " getdate(),getdate(),getdate(),'"&idInicia&"') "
DB.execute(sql)%>
<div class="row-fluid ">
	<div class="span4"></div>
	<div class="span4 label label-success">
		<i class="icon-ok"></i> Mensaje Enviado
	</div>
	<div class="span4"></div>
</div>