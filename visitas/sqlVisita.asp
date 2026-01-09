<!--#include file="../funciones.asp"-->
<%perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
sucursal = replace(trim(request("sucursal")),",","")
fecha = cdate(trim(request("campoFechaVisita")))
diaFecha = formateaParaFecha(day(fecha))
mesFecha = formateaParaFecha(month(fecha))
anioFecha = year(fecha)
horaFecha = formateaParaFecha(hour(fecha))
minutosFecha = formateaParaFecha(minute(fecha))
fecha = anioFecha&"-"&mesFecha&"-"&diaFecha&" "&horaFecha&":"&minutosFecha
motivoVisita = trim(request("motivoVisita"))
observacionVisita = trim(request("observacionVisita"))
sql = ""
sql = sql & " exec SUC_prc_suc_visita_ing "
sql = sql & " '"&idUsuario&"', "
sql = sql & " '"&sucursal&"', "
sql = sql & " '"&motivoVisita&"', "
sql = sql & " '"&fecha&"', "
sql = sql & " '"&observacionVisita&"' "
'response.write(sql)
'response.end
db.execute(sql)
response.write("1")%>