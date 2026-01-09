<!--#include file="../funciones.asp"-->
<%
id_gest_inc_tipo = trim(request("tipoGestionIncidencia"))
idSucursal = trim(request("idSucursal"))
idUsuario = trim(request("idUsuario"))
gest_inc_obs = server.htmlencode(trim(request("observacionIncidencia")))
numTicket = trim(request("numTicket"))
valorSubTipo = trim(request("valorSubTipo"))
tipo_op = 1
horaActual = time()
hora = hour(horaActual)
minutos = minute(horaActual)
gest_inc_hora_efectiva = hora&":"&minutos
sql = ""
sql = sql & "execute SUC_prc_gest_inc_op '"&id_gest_inc_tipo&"', "
sql = sql & " '"&valorSubTipo&"', "
sql = sql & " '"&idSucursal&"', "
sql = sql & " '"&gest_inc_hora_efectiva&"', "
sql = sql & " '"&gest_inc_obs&"', "
sql = sql & " '"&numTicket&"', "
sql = sql & " '"&idUsuario&"', "
sql = sql & " '"&tipo_op&"' "
db.execute(sql)
DB.Close
set DB=nothing%>
