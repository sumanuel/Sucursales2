<!--#include file="../funciones.asp"-->
<%Response.ContentType = "application/json"
perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
perfilUsuario = trim(request("perfilUsuario"))
rut = trim(request("rut"))
dv = trim(request("dv"))
tipoIngreso = trim(request("tipoIngreso"))

if tipoIngreso = 1 then
	nombrePersona = trim(request("nombrePersona"))
	tipoPersonal = trim(request("tipoPersonal"))
	empresa = trim(request("empresa"))

	Response.Write "{"
	Response.Write "  ""datosRespuestaAC1"": ["
	sql = ""
	sql = sql + "exec SCSS_prc_capa_mod_personal_capacitado " + rut + "," + dv + ",'" + nombrePersona + "'," + tipoPersonal + "," + empresa + " "
	'response.write(sql)
	'response.end
	tieneDatos = 0
	set rs = db.execute(sql)
	if not rs.eof then
	  	datos = rs.getrows()
	  	tieneDatos = 1
	end if
	if tieneDatos = 1 then
		for i = 0 to ubound(datos,2)
		    mensaje = trim(datos(0,i))
		    Response.Write "{"
		    Response.Write "   ""mensaje"": """&server.htmlencode(mensaje)&""" "
		    Response.Write "}"
		  	if i <> ubound(datos,2) then response.write(",")
		next
	else	
		mensaje = "---"
		Response.Write "{"
		Response.Write "   ""mensaje"": """&mensaje&""" "
		Response.Write "}" 
	 
	end if
		Response.Write "] "
		Response.Write "}"

end if
if tipoIngreso = 2 then
	idformulario = trim(request("idformulario"))
	idtipoCapacitacion = trim(request("idtipoCapacitacion"))
	idsucusal = trim(request("idsucusal"))
	fechaAgendamiento = trim(request("fechaAgendamiento"))
	cantDiasSLA = trim(request("cantDiasSLA"))
	tipoIngresoConsulta= trim(request("tipoIngresoConsulta"))

	Response.Write "{"
	Response.Write "  ""datosRespuestaAC2"": ["
	sql = ""
	sql = sql + "exec SCSS_prc_capa_Ing_Asignacion_Capacitacion " + tipoIngresoConsulta + "," + rut + "," + idformulario + "," + idsucusal + ",'" + fechaAgendamiento + "'," +idtipoCapacitacion + "," +cantDiasSLA + "," +idUsuario + " "
	'ejemplo exec SCSS_prc_capa_Ing_Asignacion_Capacitacion 17609918,1,104,'2018-04-11',2,3,1485'	
	'response.write(sql)
	'response.end
	tieneDatos = 0
	set rs = db.execute(sql)
	if not rs.eof then
	  	datos = rs.getrows()
	  	tieneDatos = 1
	end if
	if tieneDatos = 1 then
		for i = 0 to ubound(datos,2)
		    mensaje = trim(datos(0,i))
		    Response.Write "{"
		    Response.Write "   ""mensaje"": """&server.htmlencode(mensaje)&""" "
		    Response.Write "}"
		  	if i <> ubound(datos,2) then response.write(",")
		next
	else	
		mensaje = "Error al ser ingresado vuelva a intentarlo."
		Response.Write "{"
		Response.Write "   ""mensaje"": """&mensaje&""" "
		Response.Write "}" 
	 
	end if
		Response.Write "] "
		Response.Write "}"
end if%>