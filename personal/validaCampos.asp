<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones2.asp"-->
<%
	Dim fnxValida
	
	fnxValida = request("fnxValida")

	if fnxValida = "1" then 'valida fecha de carga programada

		Dim fecha_programada,  tipoProceso, tipoEjecucion, tipoCarga

		fecha_programada = request("fecha_programada")
		tipoProceso = request("tipoProceso")
		tipoEjecucion = request("tipoEjecucion")
		tipoCarga = request("tipoCarga")

		fecha_programada = year(fecha_programada) & "-" & month(fecha_programada) & "-" & day(fecha_programada)
		
		'=====================================================================
		' JSON
		'=====================================================================
		Response.ContentType = "application/json"
		 
		Response.Write "{"
		Response.Write "  ""datos"": " 
		Response.Write "{ "
		
		sql = ""	
		sql = sql & " SELECT ID_SUC_ARCHIVO, convert(varchar(12), HORA_PROCESO, 8) as HORA_PROCESO, "
		sql = sql & " TIPO_EJECUCION_FECHA, convert(varchar(12), FECHA_PROCESO, 105) as FECHA_PROCESO "
		sql = sql & " FROM SUC_sucursal_asistencia_personal_control_cp  "
		sql = sql & " WHERE TIPO_EJECUCION_FECHA = (CONVERT(VARCHAR(10),'"&fecha_programada&"',121)) and "
		sql = sql & " tipo_proceso = "&tipoProceso&" and tipo_ejecucion = "&tipoEjecucion&" and  tipo_carga = "&tipoCarga&"	"		
		set rs2 = db.execute(sql)
			
		Dim ID_SUC_ARCHIVO, HORA_PROCESO, TIPO_EJECUCION_FECHA, FECHA_PROCESO
		
		do while not rs2.eof
			ID_SUC_ARCHIVO = trim(rs2("ID_SUC_ARCHIVO"))
			HORA_PROCESO = trim(rs2("HORA_PROCESO"))
			TIPO_EJECUCION_FECHA = trim(rs2("TIPO_EJECUCION_FECHA"))
			FECHA_PROCESO = trim(rs2("FECHA_PROCESO"))
			
			errLog = errLog & "  {""m"": ""Existe archivo para el periodo: "&TIPO_EJECUCION_FECHA&" || Fecha de Carga: "&FECHA_PROCESO&" || ID de Carga: "&ID_SUC_ARCHIVO&"""}, "	
			
		 rs2.MoveNext
		Loop
		
		if errLog = "" then 			
			errLog = ""
		else
			errLog = Left (errLog, (len(errLog)-2))
			Response.Write "   ""result"": ""error"", "
			Response.Write "   ""msg"": [ "
			Response.Write(errLog)
			Response.Write "    ]"	
		end if

		Response.Write "} }"
	end if 

	if fnxValida = "2" then 'valida rut ingresado en bbdd
		Dim rutIngreso

		rutIngreso = request("rutIngreso")

		'=====================================================================
		' JSON
		'=====================================================================
		Response.ContentType = "application/json"
		 
		Response.Write "{"
		Response.Write "  ""datos"": " 
		Response.Write "{ "

		sql = ""
		sql = sql & " select "
		sql = sql & " a.bt_sucursal, "
		sql = sql & " b.suc_nombre, "
		sql = sql & " a.rut_personal, "
		sql = sql & " a.nombre_personal, "
		sql = sql & " a.tipo_personal, "
		sql = sql & " a.tipo, "
		sql = sql & " a.empresa "
		sql = sql & " from SUC_sucursal_asistencia_personal a "
		sql = sql & " inner join SUC_sucursal b on "
		sql = sql & " a.bt_sucursal = b.cod_bantotal "
		sql = sql & " where a.rut_personal like '%"&rutIngreso&"%' "

		set rs2 = db.execute(sql)
		if not rs2.eof then
			Response.Write "   ""result"": ""error"", "
			Response.Write "   ""msg"": [ "
			errLog = ""

			do while not rs2.eof
				bt_sucursal = server.htmlencode(trim(rs2("bt_sucursal")))
				suc_nombre = trim(rs2("suc_nombre"))
				rut_personal = server.htmlencode(trim(rs2("rut_personal")))
				nombre_personal = server.htmlencode(trim(rs2("nombre_personal")))
				tipo_personal = server.htmlencode(trim(rs2("tipo_personal")))
				tipo = server.htmlencode(trim(rs2("tipo")))
				empresa = server.htmlencode(trim(rs2("empresa")))
				
				errLog = errLog & "  {""bt_sucursal"": """&bt_sucursal&""", "
				errLog = errLog & "  ""suc_nombre"": """&suc_nombre&""", "
				errLog = errLog & "  ""rut_personal"": """&rut_personal&""", "
				errLog = errLog & "  ""nombre_personal"": """&nombre_personal&""", "
				errLog = errLog & "  ""tipo_personal"": """&tipo_personal&""", "
				errLog = errLog & "  ""tipo"": """&tipo&""", "
				errLog = errLog & "  ""empresa"": """&empresa&"""}, "				

			rs2.MoveNext
			Loop

			errLog = Left (errLog, (len(errLog)-2))
			Response.Write(errLog)
			Response.Write "    ]"
		else			
			Response.Write "   ""result"": ""Ok"", "
			Response.Write "   ""msg"": [ "
			Response.Write "  {""m"": ""rut disponible""} "
			Response.Write "    ]"	
		end if

		Response.Write "} }"

	end if 
%>
