<!--#include file="../funciones.asp"-->
<%Response.ContentType = "application/json"
per = trim(request("per"))


Response.Write "{"
Response.Write "  ""datosTablaSUC"": ["

sql = ""
sql = sql + "exec SUC_prc_eva_get_sucursales " &per& " "


'response.write(sql)
'response.end

tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
	datosSucursales = rs.getrows()
  	tieneDatos = 1
end if
if tieneDatos = 1 then
	for i = 0 to ubound(datosSucursales,2)
	    codbtt = trim(datosSucursales(0,i))
	    nombre = trim(datosSucursales(1,i))
	    Response.Write "{"
	    Response.Write "   ""codbtt"": """&server.htmlencode(codbtt)&""", "
	    Response.Write "   ""nombre"": """&server.htmlencode(nombre)&""" "
	    Response.Write "}"
	  	if i <> ubound(datosSucursales,2) then response.write(",")
	next
else				
    codbtt = "---"
    nombre = "---"	    		    
	Response.Write "{"
    Response.Write "   ""codbtt"": """&server.htmlencode(codbtt)&""", "
    Response.Write "   ""nombre"": """&server.htmlencode(nombre)&""", "
    Response.Write "}"
 
end if
Response.Write "] "
Response.Write "}"


%>