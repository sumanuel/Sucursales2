<!--#include file="../funciones.asp"-->
<%Response.ContentType = "application/json"
perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
tipoVista = trim(request("tipoVista"))
perfilUsuario = trim(request("perfilUsuario"))


if tipoVista = 1 then
	periodo = trim(request("periodo"))

	Response.Write "{"
	Response.Write "  ""datosTablaDC1"": ["

	sql = ""
	sql = sql + "exec SCSS_prc_capa_get_asignacion_capacitacion 1," + periodo + " " 

	'response.write(sql)
	'response.end

	tieneDatos = 0
	set rs = db.execute(sql)
	if not rs.eof then
		datosDetalleCapacitaciones = rs.getrows()
	  	tieneDatos = 1
	end if
	if tieneDatos = 1 then
			for i = 0 to ubound(datosDetalleCapacitaciones,2)
			    id_asignacion = trim(datosDetalleCapacitaciones(0,i))
			    id_personal = trim(datosDetalleCapacitaciones(1,i))
			    nombrePersona = trim(datosDetalleCapacitaciones(2,i))
			    nombreFormulario = trim(datosDetalleCapacitaciones(3,i))
			    idestado = trim(datosDetalleCapacitaciones(4,i))
			    estado = trim(datosDetalleCapacitaciones(5,i))
			    suc_nombre = trim(datosDetalleCapacitaciones(6,i))
			    usuario_evaluacion = trim(datosDetalleCapacitaciones(7,i))
			    fecha_agendada = trim(datosDetalleCapacitaciones(8,i))
			    tipoCap = trim(datosDetalleCapacitaciones(9,i))
			    dias_diff = trim(datosDetalleCapacitaciones(10,i))
			    fecha_termino = trim(datosDetalleCapacitaciones(11,i))
			    ult_modificacion = trim(datosDetalleCapacitaciones(12,i))
			    fecha_ingreso = trim(datosDetalleCapacitaciones(13,i))
			    nota = trim(datosDetalleCapacitaciones(14,i))
			    resultado_nota = trim(datosDetalleCapacitaciones(15,i))
			    estado_sla = trim(datosDetalleCapacitaciones(16,i))
			    dias_cap = trim(datosDetalleCapacitaciones(17,i))
			    Response.Write "{"
			    Response.Write "   ""id_asignacion"": """&server.htmlencode(id_asignacion)&""", "
			    Response.Write "   ""id_personal"": """&server.htmlencode(id_personal)&""", "
			    Response.Write "   ""nombrePersona"": """&server.htmlencode(nombrePersona)&""", "
			    Response.Write "   ""nombreFormulario"": """&server.htmlencode(nombreFormulario)&""", "
			    Response.Write "   ""idestado"": """&server.htmlencode(idestado)&""", "
			    Response.Write "   ""estado"": """&server.htmlencode(estado)&""", "
			    Response.Write "   ""suc_nombre"": """&server.htmlencode(suc_nombre)&""", "
			    Response.Write "   ""usuario_evaluacion"": """&server.htmlencode(usuario_evaluacion)&""", "
			    Response.Write "   ""fecha_agendada"": """&server.htmlencode(fecha_agendada)&""", "
			    Response.Write "   ""tipoCap"": """&server.htmlencode(tipoCap)&""", "
			    Response.Write "   ""dias_diff"": """&server.htmlencode(dias_diff)&""", "
			    Response.Write "   ""fecha_termino"": """&server.htmlencode(fecha_termino)&""", "
			    Response.Write "   ""ult_modificacion"": """&server.htmlencode(ult_modificacion)&""", "
			    Response.Write "   ""fecha_ingreso"": """&server.htmlencode(fecha_ingreso)&""", "
			    Response.Write "   ""nota"": """&server.htmlencode(nota)&""", "
			    Response.Write "   ""resultado_nota"": """&server.htmlencode(resultado_nota)&""", "
			    Response.Write "   ""estado_sla"": """&server.htmlencode(estado_sla)&""", "
			    Response.Write "   ""dias_cap"": """&server.htmlencode(dias_cap)&""" "
			    Response.Write "}"
			  	if i <> ubound(datosDetalleCapacitaciones,2) then response.write(",")
			next
		else				
		    id_asignacion = "---"
		    id_personal = "---"
		    nombrePersona = "---"
		    nombreFormulario = "---"
		    idestado = "---"
		    estado = "---"
		    suc_nombre = "---"
		    usuario_evaluacion = "---"
		    fecha_agendada = "---"
		    tipoCap = "---"
		    dias_diff = "---"
		    fecha_termino = "---"
		    ult_modificacion = "---"
		    fecha_ingreso = "---"
		    nota = "---"
			resultado_nota = "---"	 
			estado_sla = "---"  	
			dias_cap = "---"  		    
			Response.Write "{"
		    Response.Write "   ""id_asignacion"": """&server.htmlencode(id_asignacion)&""", "
		    Response.Write "   ""id_personal"": """&server.htmlencode(id_personal)&""", "
		    Response.Write "   ""nombrePersona"": """&server.htmlencode(nombrePersona)&""", "
		    Response.Write "   ""nombreFormulario"": """&server.htmlencode(nombreFormulario)&""", "
			Response.Write "   ""idestado"": """&server.htmlencode(idestado)&""", "
		    Response.Write "   ""estado"": """&server.htmlencode(estado)&""", "
		    Response.Write "   ""suc_nombre"": """&server.htmlencode(suc_nombre)&""", "
		    Response.Write "   ""usuario_evaluacion"": """&server.htmlencode(usuario_evaluacion)&""", "
		    Response.Write "   ""fecha_agendada"": """&server.htmlencode(fecha_agendada)&""", "
		    Response.Write "   ""tipoCap"": """&server.htmlencode(tipoCap)&""", "
		    Response.Write "   ""dias_diff"": """&server.htmlencode(dias_diff)&""", "
		    Response.Write "   ""fecha_termino"": """&server.htmlencode(fecha_termino)&""", "
		    Response.Write "   ""ult_modificacion"": """&server.htmlencode(ult_modificacion)&""", "
		    Response.Write "   ""fecha_ingreso"": """&server.htmlencode(fecha_ingreso)&""", "
			Response.Write "   ""nota"": """&server.htmlencode(nota)&""", "
			Response.Write "   ""resultado_nota"": """&server.htmlencode(resultado_nota)&""", "
			Response.Write "   ""estado_sla"": """&server.htmlencode(estado_sla)&""", "
			Response.Write "   ""dias_cap"": """&server.htmlencode(dias_cap)&""" "
		    Response.Write "}"		 
		end if
			Response.Write "] "
			Response.Write "}"

end if

if tipoVista = 2 then
	idAsignacion = trim(request("idAsignacion"))

	Response.Write "{"
	Response.Write "  ""datosTablaDC2"": ["

	sql2 = ""
	sql2 = sql2 + "exec SCSS_prc_capa_get_respuestas " + idAsignacion + " " 

	'response.write(sql2)
	'response.end

	tieneDatos1 = 0
	set rs1 = db.execute(sql2)
	if not rs1.eof then
		datosPreguntasCapacitaciones = rs1.getrows()
	  	tieneDatos1 = 1

	end if	
	if tieneDatos1 = 1 then
		for i = 0 to ubound(datosPreguntasCapacitaciones,2)
		    id_respuesta = trim(datosPreguntasCapacitaciones(0,i))
		    orden_categoria = trim(datosPreguntasCapacitaciones(1,i))
		    categoria = trim(datosPreguntasCapacitaciones(2,i))
		    orden_pegunta = trim(datosPreguntasCapacitaciones(3,i))
		    pregunta = trim(datosPreguntasCapacitaciones(4,i))
		    respuesta = trim(datosPreguntasCapacitaciones(5,i))
		    Response.Write "{"
		    Response.Write "   ""id_respuesta"": """&server.htmlencode(id_respuesta)&""", "
		    Response.Write "   ""orden_categoria"": """&server.htmlencode(orden_categoria)&""", "
		    Response.Write "   ""categoria"": """&server.htmlencode(categoria)&""", "
		    Response.Write "   ""orden_pegunta"": """&server.htmlencode(orden_pegunta)&""", "
		    Response.Write "   ""pregunta"": """&server.htmlencode(pregunta)&""", "
		    Response.Write "   ""respuesta"": """&server.htmlencode(respuesta)&""" "
		    Response.Write "}"

		  	if i <> ubound(datosPreguntasCapacitaciones,2) then response.write(",")
		next
	else				
	    id_respuesta = "---"
		orden_categoria = "---"
		categoria = "---"
		orden_pegunta = "---"
		pregunta = "---"
		respuesta = "---"
		Response.Write "{"
	    Response.Write "   ""id_respuesta"": """&server.htmlencode(id_respuesta)&""", "
	    Response.Write "   ""orden_categoria"": """&server.htmlencode(orden_categoria)&""", "
	    Response.Write "   ""categoria"": """&server.htmlencode(categoria)&""", "
	    Response.Write "   ""orden_pegunta"": """&server.htmlencode(orden_pegunta)&""", "
	    Response.Write "   ""pregunta"": """&server.htmlencode(pregunta)&""", "
	    Response.Write "   ""respuesta"": """&server.htmlencode(respuesta)&""" "
	    Response.Write "}"
	 
	end if
	Response.Write "] "
	Response.Write "}"

end if

if tipoVista = 3 then
	idAsignacion = trim(request("idAsignacion"))
	id_estado = trim(request("id_estado"))
	tipoMod = trim(request("tipoMod"))
	adicional1 = trim(request("adicional1"))

	if tipoMod = 2 then
		adicional1 = idUsuario		
	end if

	Response.Write "{"
	Response.Write "  ""datosMensajeModEstado"": ["

	sql3 = ""
	sql3 = sql3 + "exec SCSS_prc_capa_mod_estado_capacitacion " + idAsignacion + "," + id_estado + "," + tipoMod + ",'" + adicional1 + "',0"

	'response.write(sql3)
	'response.end
	tieneDatos2 = 0
	set rs2 = db.execute(sql3)
	if not rs2.eof then
		datosMensajeModEstadoRespuesta = rs2.getrows()
	  	tieneDatos2 = 1
	end if	
	if tieneDatos2 = 1 then
		for i = 0 to ubound(datosMensajeModEstadoRespuesta,2)
		    mensaje = trim(datosMensajeModEstadoRespuesta(0,i))
		    
		    Response.Write "{"		   
		    Response.Write "   ""mensaje"": """&server.htmlencode(mensaje)&""" "
		    Response.Write "}"

		  	if i <> ubound(datosMensajeModEstadoRespuesta,2) then response.write(",")
		next
	else				
	    mensaje = 2
		Response.Write "{"
	    Response.Write "   ""mensaje"": """&server.htmlencode(mensaje)&""" "
	    Response.Write "}"
	 
	end if
	Response.Write "] "
	Response.Write "}"

end if


if tipoVista = 4 then
	idAsignacion = trim(request("idAsignacion"))
	idRespuesta = trim(request("idRespuesta"))
	respuesta = trim(request("respuesta"))

	Response.Write "{"
	Response.Write "  ""datosMensajeRespuesta"": ["

	sql4 = ""
	sql4 = sql4 + "exec SCSS_prc_capa_mod_respuestas " + idAsignacion + "," + idRespuesta + "," + respuesta + " " 
	
	'response.write(sql4)
	'response.end
	tieneDatos3 = 0
	set rs3 = db.execute(sql4)
	if not rs3.eof then
		datosMensajeRespuesta = rs3.getrows()
	  	tieneDatos3 = 1
	end if	
	if tieneDatos3 = 1 then
		for i = 0 to ubound(datosMensajeRespuesta,2)
		    mensaje = trim(datosMensajeRespuesta(0,i))
		    
		    Response.Write "{"		   
		    Response.Write "   ""mensaje"": """&server.htmlencode(mensaje)&""" "
		    Response.Write "}"

		  	if i <> ubound(datosMensajeRespuesta,2) then response.write(",")
		next
	else				
	    mensaje = 2
		Response.Write "{"
	    Response.Write "   ""mensaje"": """&server.htmlencode(mensaje)&""" "
	    Response.Write "}"
	 
	end if
	Response.Write "] "
	Response.Write "}"

end if

if tipoVista = 5 then
	idAsignacion = trim(request("idAsignacion"))
	id_estado = trim(request("id_estado"))
	tipoMod = trim(request("tipoMod"))
	adicional1 = trim(request("adicional1"))
	notaFinalCapacitacion = trim(request("notaFinalCapacitacion"))

	if tipoMod = 2 then
		adicional1 = idUsuario		
	end if

	Response.Write "{"
	Response.Write "  ""datosMensajeModEstado"": ["

	sql3 = ""
	sql3 = sql3 + "exec SCSS_prc_capa_mod_estado_capacitacion " + idAsignacion + "," + id_estado + "," + tipoMod + ",'" + adicional1 + "',"+notaFinalCapacitacion+ " "

	'response.write(sql3)
	'response.end
	tieneDatos2 = 0
	set rs2 = db.execute(sql3)
	if not rs2.eof then
		datosMensajeModEstadoRespuesta = rs2.getrows()
	  	tieneDatos2 = 1
	end if	
	if tieneDatos2 = 1 then
		for i = 0 to ubound(datosMensajeModEstadoRespuesta,2)
		    mensaje = trim(datosMensajeModEstadoRespuesta(0,i))
		    
		    Response.Write "{"		   
		    Response.Write "   ""mensaje"": """&server.htmlencode(mensaje)&""" "
		    Response.Write "}"

		  	if i <> ubound(datosMensajeModEstadoRespuesta,2) then response.write(",")
		next
	else				
	    mensaje = 2
		Response.Write "{"
	    Response.Write "   ""mensaje"": """&server.htmlencode(mensaje)&""" "
	    Response.Write "}"
	 
	end if
	Response.Write "] "
	Response.Write "}"

end if

if tipoVista = 6 then
	periodo = trim(request("periodo"))
	idSucursal = trim(request("idSucursal"))

	Response.Write "{"
	Response.Write "  ""datosTablaDC1"": ["

	sql = ""
	sql = sql + "exec SCSS_prc_capa_get_asignacion_capacitacion 2," + periodo + "," + idSucursal 

	'response.write(sql)
	'response.end

	tieneDatos = 0
	set rs = db.execute(sql)
	if not rs.eof then
		datosDetalleCapacitaciones = rs.getrows()
	  	tieneDatos = 1
	end if
	if tieneDatos = 1 then
			for i = 0 to ubound(datosDetalleCapacitaciones,2)
			    id_asignacion = trim(datosDetalleCapacitaciones(0,i))
			    id_personal = trim(datosDetalleCapacitaciones(1,i))
			    nombrePersona = trim(datosDetalleCapacitaciones(2,i))
			    nombreFormulario = trim(datosDetalleCapacitaciones(3,i))
			    idestado = trim(datosDetalleCapacitaciones(4,i))
			    estado = trim(datosDetalleCapacitaciones(5,i))
			    suc_nombre = trim(datosDetalleCapacitaciones(6,i))
			    usuario_evaluacion = trim(datosDetalleCapacitaciones(7,i))
			    fecha_agendada = trim(datosDetalleCapacitaciones(8,i))
			    tipoCap = trim(datosDetalleCapacitaciones(9,i))
			    dias_diff = trim(datosDetalleCapacitaciones(10,i))
			    fecha_termino = trim(datosDetalleCapacitaciones(11,i))
			    ult_modificacion = trim(datosDetalleCapacitaciones(12,i))
			    fecha_ingreso = trim(datosDetalleCapacitaciones(13,i))
			    nota = trim(datosDetalleCapacitaciones(14,i))
			    resultado_nota = trim(datosDetalleCapacitaciones(15,i))
			    estado_sla = trim(datosDetalleCapacitaciones(16,i))
			    dias_cap = trim(datosDetalleCapacitaciones(17,i))
			    Response.Write "{"
			    Response.Write "   ""id_asignacion"": """&server.htmlencode(id_asignacion)&""", "
			    Response.Write "   ""id_personal"": """&server.htmlencode(id_personal)&""", "
			    Response.Write "   ""nombrePersona"": """&server.htmlencode(nombrePersona)&""", "
			    Response.Write "   ""nombreFormulario"": """&server.htmlencode(nombreFormulario)&""", "
			    Response.Write "   ""idestado"": """&server.htmlencode(idestado)&""", "
			    Response.Write "   ""estado"": """&server.htmlencode(estado)&""", "
			    Response.Write "   ""suc_nombre"": """&server.htmlencode(suc_nombre)&""", "
			    Response.Write "   ""usuario_evaluacion"": """&server.htmlencode(usuario_evaluacion)&""", "
			    Response.Write "   ""fecha_agendada"": """&server.htmlencode(fecha_agendada)&""", "
			    Response.Write "   ""tipoCap"": """&server.htmlencode(tipoCap)&""", "
			    Response.Write "   ""dias_diff"": """&server.htmlencode(dias_diff)&""", "
			    Response.Write "   ""fecha_termino"": """&server.htmlencode(fecha_termino)&""", "
			    Response.Write "   ""ult_modificacion"": """&server.htmlencode(ult_modificacion)&""", "
			    Response.Write "   ""fecha_ingreso"": """&server.htmlencode(fecha_ingreso)&""", "
			    Response.Write "   ""nota"": """&server.htmlencode(nota)&""", "
			    Response.Write "   ""resultado_nota"": """&server.htmlencode(resultado_nota)&""", "
			    Response.Write "   ""estado_sla"": """&server.htmlencode(estado_sla)&""", "
			    Response.Write "   ""dias_cap"": """&server.htmlencode(dias_cap)&""" "
			    Response.Write "}"
			  	if i <> ubound(datosDetalleCapacitaciones,2) then response.write(",")
			next
		else				
		    id_asignacion = "---"
		    id_personal = "---"
		    nombrePersona = "---"
		    nombreFormulario = "---"
		    idestado = "---"
		    estado = "---"
		    suc_nombre = "---"
		    usuario_evaluacion = "---"
		    fecha_agendada = "---"
		    tipoCap = "---"
		    dias_diff = "---"
		    fecha_termino = "---"
		    ult_modificacion = "---"
		    fecha_ingreso = "---"
		    nota = "---"
			resultado_nota = "---"	 
			estado_sla = "---"  	
			dias_cap = "---"  		    
			Response.Write "{"
		    Response.Write "   ""id_asignacion"": """&server.htmlencode(id_asignacion)&""", "
		    Response.Write "   ""id_personal"": """&server.htmlencode(id_personal)&""", "
		    Response.Write "   ""nombrePersona"": """&server.htmlencode(nombrePersona)&""", "
		    Response.Write "   ""nombreFormulario"": """&server.htmlencode(nombreFormulario)&""", "
			Response.Write "   ""idestado"": """&server.htmlencode(idestado)&""", "
		    Response.Write "   ""estado"": """&server.htmlencode(estado)&""", "
		    Response.Write "   ""suc_nombre"": """&server.htmlencode(suc_nombre)&""", "
		    Response.Write "   ""usuario_evaluacion"": """&server.htmlencode(usuario_evaluacion)&""", "
		    Response.Write "   ""fecha_agendada"": """&server.htmlencode(fecha_agendada)&""", "
		    Response.Write "   ""tipoCap"": """&server.htmlencode(tipoCap)&""", "
		    Response.Write "   ""dias_diff"": """&server.htmlencode(dias_diff)&""", "
		    Response.Write "   ""fecha_termino"": """&server.htmlencode(fecha_termino)&""", "
		    Response.Write "   ""ult_modificacion"": """&server.htmlencode(ult_modificacion)&""", "
		    Response.Write "   ""fecha_ingreso"": """&server.htmlencode(fecha_ingreso)&""", "
			Response.Write "   ""nota"": """&server.htmlencode(nota)&""", "
			Response.Write "   ""resultado_nota"": """&server.htmlencode(resultado_nota)&""", "
			Response.Write "   ""estado_sla"": """&server.htmlencode(estado_sla)&""", "
			Response.Write "   ""dias_cap"": """&server.htmlencode(dias_cap)&""" "
		    Response.Write "}"		 
		end if
			Response.Write "] "
			Response.Write "}"

end if
%>