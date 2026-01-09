<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones.asp"-->
<!--#include file="validar_dias_habiles.asp"-->
<%

Dim datoError
datoError = false

Function codigo_veri(rut)
	codigo_veri=""
	tur=strreverse(rut)
	mult = 2
	for i = 1 to len(tur)
		if mult > 7 then mult = 2 end if
		suma = mult * mid(tur,i,1) + suma
		mult = mult +1
	next
	valor = 11 - (suma mod 11)
	if valor = 11 then
		codigo_veri = "0"
	elseif valor = 10 then
		codigo_veri = "k"
	else
		codigo_veri = valor
	end if
end function


Function cleanseData(dataInput,dataType,dataLength)   
	Dim regex, validInput, expressionmatch, RegExpObj, RegExpChk 
	regex = ""   
	validInput = "1"   
	If dataType = "string" And Len(dataInput) > 0 Then       
		regex = "^[\w-\.]{1,"& dataLength &"}$"   
	ElseIf dataType = "email" And Len(dataInput) > 0 Then       
		regex = "^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$"   
	ElseIf dataType = "integer" And Len(dataInput) > 0 Then       
		regex = "^\d{1,"& dataLength &"}$"   
	ElseIf dataType = "time" And Len(dataInput) > 0 Then		
		regex = "^([0-1][0-9]|[2][0-3])[\:]([0-5][0-9])[\:]([0-5][0-9])$"	
	ElseIf dataType = "date" And Len(dataInput) > 0 Then		
		If Not IsDate(dataInput) Then 			
			validInput = "0"			
		End If 		
		If Not Len(dataInput) = 10 Then			
			validInput = "0"			
		End If
	ElseIf dataType = "text" And Len(dataInput) > 0 Then       
		If Len(dataInput) > dataLength Then 
			validInput = "0"
		End If   
	End If   
		
	If Len(regex) > 0 And Len(dataInput) > 0 Then       
		'Response.Write(regex & "<br/>")
	
		Set RegExpObj = New RegExp       
		RegExpObj.Pattern = regex       
		RegExpObj.IgnoreCase = True       
		RegExpObj.Global = True       
		RegExpChk = RegExpObj.Test(dataInput)       
		If Not RegExpChk Then           
			validInput = "0"
		End If       
		Set RegExpObj = nothing   
	End If
	   
	If validInput = "1" And Len(dataInput) > 0 Then       
		cleanseData = specialCharacterEncoding(dataInput)   
		datoError = false
	ElseIf Len(dataInput) = 0 Then       
		cleanseData = ""   
		datoError = true
	Else       
		datoError = true
		'Response.Write "processing halted"       
		'Response.End   
	End If
End Function

Function specialCharacterEncoding(encodeData)    
	encodeData = replace(encodeData,"&", "&#38;")    
	encodeData = replace(encodeData,"'", "&#39;")    
	encodeData = replace(encodeData,"""", "&quot;")    
	encodeData = replace(encodeData,">", "&gt;")    
	encodeData = replace(encodeData,"<", "&lt;")    
	encodeData = replace(encodeData,")", "&#41;")    
	encodeData = replace(encodeData,"(", "&#40;")    
	encodeData = replace(encodeData,"]", "&#93;")    
	encodeData = replace(encodeData,"[", "&#91;")    
	encodeData = replace(encodeData,"}", "&#125;")    
	encodeData = replace(encodeData,"{", "&#123;")    
	encodeData = replace(encodeData,"--", "&#45;&#45;")    
	encodeData = replace(encodeData,"=", "&#61;")
	encodeData = replace(encodeData,"=", "&#61;")
	encodeData = replace(encodeData,"Á", "&#65;")
	encodeData = replace(encodeData,"É", "&#69;")
	encodeData = replace(encodeData,"Í", "&#73;")
	encodeData = replace(encodeData,"Ó", "&#79;")
	encodeData = replace(encodeData,"Ú", "&#85;")
	encodeData = replace(encodeData,"á", "&#97;")
	encodeData = replace(encodeData,"é", "&#101;")
	encodeData = replace(encodeData,"í", "&#105;")
	encodeData = replace(encodeData,"ó", "&#111;")
	encodeData = replace(encodeData,"ú", "&#117;")
	encodeData = replace(encodeData,"Ñ", "&#78;")
	encodeData = replace(encodeData,"ñ", "&#110;")
	specialCharacterEncoding = encodeData
End Function

'if Session("id_usuario")<>"" and Session("tipo")="admin" then
	
	Dim objFSO,oInStream,sRows,arrRows
	Dim sFileName
	
	sFileName = "..\upload\reemplazos.csv"  
	
	'=====================================================================
	' JSON
	'=====================================================================
	 Response.ContentType = "application/json"
	 
	 Response.Write "{"
	 Response.Write "  ""datos"": " 
	 Response.Write "{ "
	
	'*** Create Object ***'   
	Set objFSO = CreateObject("Scripting.FileSystemObject")   
	'*** Check Exist Files ***'   
	If Not objFSO.FileExists(Server.MapPath(sFileName)) Then		
		Response.Write "   ""result"": ""error"", "     
		Response.Write "   ""msg"": [ "
		Response.Write "   	{""m"": ""Archivo no encontrado.""} "
		Response.Write "    ]"	
	Else
		'*** Open Files ***'
		Set oInStream = objFSO.OpenTextFile(Server.MapPath(sFileName),1,False)
		
		contadorLineas=0   
		Dim errLog
		errLog = ""
		Do Until oInStream.AtEndOfStream   
			contadorLineas=contadorLineas+1
			sRows = oInStream.readLine   
			'response.Write(sRows)
			'response.End()
			arrRows = Split(sRows,";")   
			
			'Validación de campos
			bt_sucursal=cleanseData(arrRows(0),"integer",3)
			if datoError then
				errLog =  errLog & " {""m"": ""Error en formato (Cod BTT sucursal), linea "&contadorLineas&", "&arrRows(0)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(0)&"'")
				'Response.End()
			end if
			
			id_cargo=cleanseData(arrRows(1),"integer",1)
			if datoError then
				errLog =  errLog & " {""m"": ""Error en formato (ID Cargo), linea "&contadorLineas&", "&arrRows(1)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(1)&"'")
				'Response.End()
			end if
			if ((Cint(id_cargo)<> 1) and (Cint(id_cargo) <> 2) and (Cint(id_cargo) <> 3) and (Cint(id_cargo) <> 6)) then
				errLog =  errLog & " {""m"": ""Error en formato (ID Cargo), linea "&contadorLineas&", "&arrRows(1)&"""}, "
				'Response.Write("Valor no valido, linea "&contadorLineas&", '"&arrRows(1)&"'")
				'Response.End()
			end if
			
			sucursal=cleanseData(arrRows(2),"text",100)
			if datoError then
				errLog =  errLog & " {""m"": ""Error en formato (Sucursal), linea "&contadorLineas&", "&arrRows(2)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(2)&"'")
				'Response.End()
			end if
			
			cargo=cleanseData(arrRows(3),"text",100)
			if datoError then
				errLog =  errLog & " {""m"": ""Error en formato (Cargo), linea "&contadorLineas&", "&arrRows(3)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(3)&"'")
				'Response.End()
			end if
			
			flag_rutTitular = 0
			rut_titular=cleanseData(Trim(arrRows(4)),"text",10)
			if datoError then
				flag_rutTitular = 1
				errLog =  errLog & " {""m"": ""Error en formato (obs: eliminar espacios-caracteres)(Rut Titular), linea "&contadorLineas&", "&arrRows(4)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(4)&"'")
				'Response.End()
			end if
						
			if flag_rutTitular = 0 then
				pos_separador=InStr(rut_titular,"-")
				rut=Mid(rut_titular,1,pos_separador-1)
				cod_verificador=LCase(Mid(rut_titular,pos_separador+1))
				'response.Write(codigo_veri(rut)&" = "&cod_verificador)
				'response.End()
				if StrComp(codigo_veri(rut),cod_verificador)<>0 then
					errLog =  errLog & " {""m"": ""Error en formato (Rut Titular DV), linea "&contadorLineas&", "&arrRows(4)&"""}, "
					'Response.Write("Error en RUT Titular, linea "&contadorLineas&", '"&arrRows(4)&"'")
					'Response.End()	
				end if
			end if
			
			flag_rutReemp = 0
			rut_reemplazo=cleanseData(Trim(arrRows(5)),"text",10)
			if datoError then
				flag_rutReemp = 1
				'response.Write("flag_rutReemp:" & flag_rutReemp)
				'Response.End()
				
				errLog =  errLog & " {""m"": ""Error en formato (obs: eliminar espacios-caracteres)(Rut Reemplazo), linea "&contadorLineas&", "&arrRows(5)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(5)&"'")
				'Response.End()
			end if
			
			if flag_rutReemp = 0 then
				pos_separador=InStr(rut_reemplazo,"-")
				rut=Mid(rut_reemplazo,1,pos_separador-1)
				cod_verificador=LCase(Mid(rut_reemplazo,pos_separador+1))
				if StrComp(codigo_veri(rut),cod_verificador)<>0 then
					errLog =  errLog & " {""m"": ""Error en formato (Rut Reemplazo DV), linea "&contadorLineas&", "&arrRows(5)&"""}, "
					'Response.Write("Error en RUT Reemplazo, linea "&contadorLineas&", '"&arrRows(5)&"'")
					'Response.End()	
				end if
			end if
			
			nombre_reemplazo=cleanseData(arrRows(6),"text",100)
			if datoError then
				errLog =  errLog & " {""m"": ""Error en formato (Nombre Reemplazo), linea "&contadorLineas&", "&arrRows(6)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(6)&"'")
				'Response.End()
			end if
			
			fecha_inicio=cleanseData(arrRows(7),"date",8)
			if datoError then
				errLog =  errLog & " {""m"": ""Error en formato (Fecha Inicio), linea "&contadorLineas&", "&arrRows(7)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(7)&"'")
				'Response.End()
			else
				' Validar que la fecha de inicio cumpla con el plazo de carga
				Dim validacionPlazo, fechaInicioConvertida
				
				' Convertir la fecha usando la función especial para CSV (formato MM/DD/YYYY)
				On Error Resume Next
				fechaInicioConvertida = convertirFechaCSV(arrRows(7))
				
				If Err.Number <> 0 Or IsNull(fechaInicioConvertida) Then
					errLog = errLog & " {""m"": ""Linea "&contadorLineas&": Error al convertir fecha de inicio '"&arrRows(7)&"'. Formato esperado: MM/DD/YYYY""}, "
					Err.Clear
				Else
					Set validacionPlazo = validarPlazoCarga(fechaInicioConvertida)
					
					If Not validacionPlazo("valido") Then
						errLog = errLog & " {""m"": ""Linea "&contadorLineas&": "&Replace(validacionPlazo("mensaje"), """", "'")&"""}, "
					End If
				End If
				On Error GoTo 0
			end if
			
			fecha_termino=cleanseData(arrRows(8),"date",8)
			if datoError then
				errLog =  errLog & " {""m"": ""Error en formato (Fecha Termino), linea "&contadorLineas&", "&arrRows(8)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(8)&"'")
				'Response.End()
			else
				' Validar que la fecha de término no sea menor a la fecha de inicio
				Dim fechaTerminoConvertida
				
				On Error Resume Next
				fechaTerminoConvertida = convertirFechaCSV(arrRows(8))
				
				If Err.Number <> 0 Or IsNull(fechaTerminoConvertida) Then
					errLog = errLog & " {""m"": ""Linea "&contadorLineas&": Error al convertir fecha de término '"&arrRows(8)&"'. Formato esperado: MM/DD/YYYY""}, "
					Err.Clear
				ElseIf Not IsNull(fechaInicioConvertida) And IsDate(fechaInicioConvertida) Then
					' Comparar que fecha hasta >= fecha desde
					If CDate(fechaTerminoConvertida) < CDate(fechaInicioConvertida) Then
						errLog = errLog & " {""m"": ""Linea "&contadorLineas&": La fecha de termino ("&arrRows(8)&") no puede ser menor a la fecha de inicio ("&arrRows(7)&")""}, "
					End If
				End If
				On Error GoTo 0
			end if
			
			hora_entrada=cleanseData(arrRows(9),"time",8)
			if datoError then
				errLog =  errLog & " {""m"": ""Error en formato (Hora Entrada), linea "&contadorLineas&", "&arrRows(9)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(9)&"'")
				'Response.End()
			end if
			
			hora_salida=cleanseData(arrRows(10),"time",8)
			if datoError then
				errLog =  errLog & " {""m"": ""Error en formato (Hora Salida), linea "&contadorLineas&", "&arrRows(10)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(10)&"'")
				'Response.End()
			end if
			
			empresa=cleanseData(arrRows(11),"text",100)
			if datoError then
				errLog =  errLog & " {""m"": ""Error en formato (Empresa), linea "&contadorLineas&", "&arrRows(11)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(11)&"'")
				'Response.End()
			end if
			
			motivo=cleanseData(arrRows(12),"text",1000)
			if datoError then
				errLog =  errLog & " {""m"": ""Error en formato (Motivo), linea "&contadorLineas&", "&arrRows(12)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(12)&"'")
				'Response.End()
			end if
			
			'reemplazo="insert into dbo.reemplazos_temp values ("&bt_sucursal&","&id_cargo&",'"&sucursal&"','"&cargo&"','"&rut_titular&"','"&rut_reemplazo&"','"&nombre_reemplazo&"',convert(date,'"&fecha_inicio&"',105),convert(date,'"&fecha_termino&"',105),cast('"&hora_entrada&"' as time),cast('"&hora_salida&"' as time),'"&empresa&"','"&motivo&"',GETDATE(),GETDATE())"   
			'conex.execute(reemplazo)
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
		
        oInStream.Close()   
        Set oInStream = Nothing  
    	
		if errLog = "" then
			'truncateReemplazos="truncate table dbo.reemplazos"
			'conex.Execute(truncateReemplazos)
			'reemplazo="insert into dbo.reemplazos (bt_sucursal,id_cargo,nombre_sucursal,nombre_cargo,rut_titular,rut_reemp,nombre_reemp,desde,hasta,hora_ingreso,hora_salida,empresa,motivo,fecha_reg,hora_reg) select * from reemplazos_temp"   
			'conex.execute(reemplazo)
			
			Response.Write "   ""result"": ""exito"", "     
			Response.Write "   ""msg"": [ "
			Response.Write "   	{""m"": ""Proceso terminado sin errores.""} "
			Response.Write "    ]"	
		end if
		
	End IF   
	
Response.Write "} }"

'else 'Si no esxiste una sesión
'	Session("id_usuario") = ""
'	Session("nombre") = ""
'	Session("tipo") = ""
'	response.Redirect("login.asp")
'end if
%>