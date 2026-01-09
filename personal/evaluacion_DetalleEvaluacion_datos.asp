<!--#include file="../funciones.asp"-->
<%Response.ContentType = "application/json"
perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
periodo = trim(request("periodo"))
sucursal = trim(request("sucursal"))


Response.Write "{"
Response.Write "  ""datosTablaDC1"": ["

sql = ""
sql = sql + "exec SUC_prc_eva_get_datos " &periodo& ", "&sucursal&" "


'response.write(sql)
'response.end

tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
	datosEvaluaciones = rs.getrows()
  	tieneDatos = 1
end if
if tieneDatos = 1 then
	for i = 0 to ubound(datosEvaluaciones,2)
	    rut = trim(datosEvaluaciones(0,i))
	    nombre = trim(datosEvaluaciones(1,i))
	    sucursal = trim(datosEvaluaciones(2,i))
	    tipo = trim(datosEvaluaciones(3,i))
	    cantpagos = trim(datosEvaluaciones(4,i))
	    prompagos = trim(datosEvaluaciones(5,i))
	    evatrx = trim(datosEvaluaciones(6,i))
	    cantatrasos = trim(datosEvaluaciones(7,i))
	    evaatrasos = trim(datosEvaluaciones(8,i))
	    cantfaltantes = trim(datosEvaluaciones(9,i))
	    evafaltantes = trim(datosEvaluaciones(10,i))
	    cantrec = trim(datosEvaluaciones(11,i))
	    evarec = trim(datosEvaluaciones(12,i))
	    evafinal = trim(datosEvaluaciones(13,i))
	    Response.Write "{"
	    Response.Write "   ""rut"": """&server.htmlencode(rut)&""", "
	    Response.Write "   ""nombre"": """&server.htmlencode(nombre)&""", "
	    Response.Write "   ""sucursal"": """&server.htmlencode(sucursal)&""", "
	    Response.Write "   ""tipo"": """&server.htmlencode(tipo)&""", "
	    Response.Write "   ""cantpagos"": """&server.htmlencode(cantpagos)&""", "
	    Response.Write "   ""prompagos"": """&server.htmlencode(prompagos)&""", "
	    Response.Write "   ""evatrx"": """&server.htmlencode(evatrx)&""", "
	    Response.Write "   ""cantatrasos"": """&server.htmlencode(cantatrasos)&""", "
	    Response.Write "   ""evaatrasos"": """&server.htmlencode(evaatrasos)&""", "
	    Response.Write "   ""cantfaltantes"": """&server.htmlencode(cantfaltantes)&""", "
	    Response.Write "   ""evafaltantes"": """&server.htmlencode(evafaltantes)&""", "
	    Response.Write "   ""cantrec"": """&server.htmlencode(cantrec)&""", "
	    Response.Write "   ""evarec"": """&server.htmlencode(evarec)&""", "
	    Response.Write "   ""evafinal"": """&server.htmlencode(evafinal)&""" "
	    Response.Write "}"
	  	if i <> ubound(datosEvaluaciones,2) then response.write(",")
	next
else				
    rut = "---"
    nombre = "---"
    sucursal = "---"
    tipo = "---"
    cantpagos = "---"
    prompagos = "---"
    evatrx = "---"
    cantatrasos = "---"
    evaatrasos = "---"
    cantfaltantes = "---"
    evafaltantes = "---"
    cantrec = "---"
    evarec = "---"
    evafinal = "---"	    		    
	Response.Write "{"
    Response.Write "   ""rut"": """&server.htmlencode(rut)&""", "
    Response.Write "   ""nombre"": """&server.htmlencode(nombre)&""", "
    Response.Write "   ""sucursal"": """&server.htmlencode(sucursal)&""", "
    Response.Write "   ""periodo"": """&server.htmlencode(tipo)&""", "
    Response.Write "   ""cantpagos"": """&server.htmlencode(cantpagos)&""", "
    Response.Write "   ""prompagos"": """&server.htmlencode(prompagos)&""", "
    Response.Write "   ""evatrx"": """&server.htmlencode(evatrx)&""", "
    Response.Write "   ""cantatrasos"": """&server.htmlencode(cantatrasos)&""", "
    Response.Write "   ""evaatrasos"": """&server.htmlencode(evaatrasos)&""", "
    Response.Write "   ""cantfaltantes"": """&server.htmlencode(cantfaltantes)&""", "
    Response.Write "   ""evafaltantes"": """&server.htmlencode(evafaltantes)&""", "
    Response.Write "   ""cantrec"": """&server.htmlencode(cantrec)&""", "
    Response.Write "   ""evafinal"": """&server.htmlencode(evafinal)&""" "
    Response.Write "}"
 
end if
Response.Write "] "
Response.Write "}"


%>