<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
txtpregunta1 = trim(request("pregunta1"))
txtpregunta2 = trim(request("pregunta2"))
txtpregunta3 = trim(request("pregunta3"))
txtpregunta4 = trim(request("pregunta4"))
txtpregunta5 = trim(request("pregunta5"))
txtpregunta6 = trim(request("pregunta6"))
txtpregunta7 = trim(request("pregunta7"))
txtpregunta8 = server.htmlencode(trim(request("pregunta8")))
sql = ""
sql = sql & " exec SUC_prc_encuesta_aseo_ing '"&idSucursal&"',"
sql = sql & " '"&txtpregunta1&"', "
sql = sql & " '"&txtpregunta2&"', "
sql = sql & " '"&txtpregunta3&"', "
sql = sql & " '"&txtpregunta4&"', "
sql = sql & " '"&txtpregunta5&"', "
sql = sql & " '"&txtpregunta6&"', "
sql = sql & " '"&txtpregunta7&"', "
sql = sql & " '"&txtpregunta8&"' "
'response.write(sql)
'response.end
db.execute(sql)
DB.Close
set DB=nothing%>