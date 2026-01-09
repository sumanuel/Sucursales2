<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
'Option Explicit

'Conexión a la BD
'Set Conex = Server.CreateObject ("ADODB.Connection")
'Conex.Open "driver={SQL Server};server=LH-CONTOPER-BD; database=SCSS; uid=usr_soporte; pwd=soporte"

'truncatePersonalTemp="truncate table dbo.SUC_sucursal_personal_temp"
'Conex.Execute(truncatePersonalTemp)


'The function "cleanseData" takes three parameters, the input itself, the datatype that it is supposed to be, and the maximum character length the input should be allowed to be.
'Valid data types are "email", "integer", "date", "string" and "text". 
'The first three are obvious, the last two are slight differences. 
'The "string" I use to validate text-based querystrings, allowing only letters, numbers, _, - and . whereas "text" is any free-form text form field type content.
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
	
	sFileName = "..\upload\titulares.csv"  
	
	'=====================================================================
	' JSON
	'=====================================================================
	 Response.ContentType = "application/json"
	 
	 Response.Write "{"
	 Response.Write "  ""datos"": " 
	 Response.Write "{ "      
     	 

	''*** Create Object ***'   
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
			arrRows = Split(sRows,";")   
			
			'Validación de campos
			bt_sucursal=cleanseData(arrRows(0),"integer",3)
			if datoError then
				errLog =  errLog & "   	{""m"": ""Error en formato (Cod BTT sucursal), linea "&contadorLineas&", "&arrRows(0)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(0)&"'")
				'Response.End()
			end if
			
			id_cargo=cleanseData(arrRows(1),"integer",1)
			if datoError then
				errLog =  errLog & "   	{""m"": ""Error en formato (ID Cargo), linea "&contadorLineas&", "&arrRows(1)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(1)&"'")
				'Response.End()
			end if
			if ((Cint(id_cargo) < 1) or  (Cint(id_cargo) > 3)) then
				errLog = errLog &  "   	{""m"": ""Valor no valido, linea (ID Cargo), linea "&contadorLineas&", "&arrRows(1)&"""}, "
				'Response.Write("Valor no valido, linea "&contadorLineas&", '"&arrRows(1)&"'")
				'Response.End()
			end if
			
			sucursal=cleanseData(arrRows(2),"text",100)
			if datoError then
				errLog = errLog & "   	{""m"": ""Error en formato, linea (Sucursal), linea "&contadorLineas&", "&arrRows(2)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(2)&"'")
				'Response.End()
			end if
			
			cargo=cleanseData(arrRows(3),"text",100)
			if datoError then
				errLog = errLog & "   	{""m"": ""Error en formato, linea (Cargo), linea "&contadorLineas&", "&arrRows(3)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(3)&"'")
				'Response.End()
			end if
			
			flag_rutTitular = 0
			rut_titular=cleanseData(Trim(arrRows(4)),"text",10)
			if datoError then
				flag_rutTitular = 1
				errLog = errLog & "   	{""m"": ""Error en formato (obs: eliminar espacios-caracteres), linea (Rut Titular), linea "&contadorLineas&", "&arrRows(4)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(4)&"'")
				'Response.End()
			end if
			
			if flag_rutTitular = 0 then 
				pos_separador=InStr(rut_titular,"-")
				rut=Mid(rut_titular,1,pos_separador-1)
				cod_verificador=LCase(Mid(rut_titular,pos_separador+1))
				'response.Write(codigo_veri(rut)&"="&cod_verificador)
				if StrComp(codigo_veri(rut),cod_verificador)<>0 then
					errLog =  errLog & "   	{""m"": ""Error en RUT Titular, linea (Rut Titular DV), linea "&contadorLineas&", "&arrRows(4)&"""}, "
					'Response.Write("Error en RUT Titular, linea "&contadorLineas&", '"&arrRows(4)&"'")
					'Response.End()	
				end if
			end if 
			
			nombre=cleanseData(arrRows(5),"text",100)
			if datoError then
				errLog = errLog & "   	{""m"": ""Error en formato, linea (Nombre), linea "&contadorLineas&", "&arrRows(5)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(5)&"'")
				'Response.End()
			end if
			
			apep=cleanseData(arrRows(6),"text",100)
			if datoError then
				errLog =  errLog & "   	{""m"": ""Error en formato, linea (Apellido Paterno), linea "&contadorLineas&", "&arrRows(6)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(6)&"'")
				'Response.End()
			end if
			
			apem=cleanseData(arrRows(7),"text",100)
			if datoError then
				errLog =  errLog & "   	{""m"": ""Error en formato, linea (Apellido Materno), linea "&contadorLineas&", "&arrRows(7)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(7)&"'")
				'Response.End()
			end if
			
			fecha_ingreso=cleanseData(arrRows(8),"date",8)
			if datoError then
				errLog = errLog & "   	{""m"": ""Error en formato, linea (Fecha Ingreso), linea "&contadorLineas&", "&arrRows(8)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(8)&"'")
				'Response.End()
			end if
			
			empresa=cleanseData(arrRows(9),"text",50)
			if datoError then
				errLog = errLog & "   	{""m"": ""Error en formato, linea (Empresa), linea "&contadorLineas&", "&arrRows(9)&"""}, "
				'Response.Write("Error en formato, linea "&contadorLineas&", '"&arrRows(9)&"'")
				'Response.End()
			end if
			
			'titulares="insert into dbo.SUC_sucursal_personal_temp (bt_sucursal,id_cargo,nombre_sucursal,nombre_cargo,rut_personal,nombre_personal,apep_personal,apem_personal,fecha_ingreso,tipo,empresa) values ("&bt_sucursal&","&id_cargo&",'"&sucursal&"','"&cargo&"','"&rut_titular&"','"&nombre&"','"&apep&"','"&apem&"',convert(date,'"&fecha_ingreso&"',105),'titular','"&empresa&"')"   
			'conex.execute(titulares)			
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
			'truncatePersonal="truncate table dbo.SUC_sucursal_personal"
			'conex.Execute(truncatePersonal)
			'titulares="insert into dbo.SUC_sucursal_personal (rut_personal,nombre_personal,apep_personal,apem_personal,id_cargo,fecha_ingreso,tipo,bt_sucursal,empresa) select rut_personal,nombre_personal,apep_personal,apem_personal,id_cargo,fecha_ingreso,tipo,bt_sucursal,empresa from dbo.SUC_sucursal_personal_temp"   
			'conex.execute(titulares)
			
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