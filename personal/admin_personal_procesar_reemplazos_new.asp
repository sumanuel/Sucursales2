<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
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

Function extCharacter(strExtCharacter)	
	strExtCharacter = replace(strExtCharacter, "&#48;", "0")
	strExtCharacter = replace(strExtCharacter, "&#49;", "1")
	strExtCharacter = replace(strExtCharacter, "&#50;", "2")
	strExtCharacter = replace(strExtCharacter, "&#51;", "3")
	strExtCharacter = replace(strExtCharacter, "&#52;", "4")
	strExtCharacter = replace(strExtCharacter, "&#53;", "5")
	strExtCharacter = replace(strExtCharacter, "&#54;", "6")
	strExtCharacter = replace(strExtCharacter, "&#55;", "7")
	strExtCharacter = replace(strExtCharacter, "&#56;", "8")
	strExtCharacter = replace(strExtCharacter, "&#57;", "9")

	strExtCharacter = replace(strExtCharacter, "&#65;", "A")
	strExtCharacter = replace(strExtCharacter, "&#66;", "B")
	strExtCharacter = replace(strExtCharacter, "&#67;", "C")
	strExtCharacter = replace(strExtCharacter, "&#68;", "D")
	strExtCharacter = replace(strExtCharacter, "&#69;", "E")
	strExtCharacter = replace(strExtCharacter, "&#70;", "F")
	strExtCharacter = replace(strExtCharacter, "&#71;", "G")
	strExtCharacter = replace(strExtCharacter, "&#72;", "H")
	strExtCharacter = replace(strExtCharacter, "&#73;", "I")
	strExtCharacter = replace(strExtCharacter, "&#74;", "J")
	strExtCharacter = replace(strExtCharacter, "&#75;", "K")
	strExtCharacter = replace(strExtCharacter, "&#76;", "L")
	strExtCharacter = replace(strExtCharacter, "&#77;", "M")
	strExtCharacter = replace(strExtCharacter, "&#78;", "N")
	strExtCharacter = replace(strExtCharacter, "&#79;", "O")
	strExtCharacter = replace(strExtCharacter, "&#80;", "P")
	strExtCharacter = replace(strExtCharacter, "&#81;", "Q")
	strExtCharacter = replace(strExtCharacter, "&#82;", "R")
	strExtCharacter = replace(strExtCharacter, "&#83;", "S")
	strExtCharacter = replace(strExtCharacter, "&#84;", "T")
	strExtCharacter = replace(strExtCharacter, "&#85;", "U")
	strExtCharacter = replace(strExtCharacter, "&#86;", "V")
	strExtCharacter = replace(strExtCharacter, "&#87;", "W")
	strExtCharacter = replace(strExtCharacter, "&#88;", "X")
	strExtCharacter = replace(strExtCharacter, "&#89;", "Y")
	strExtCharacter = replace(strExtCharacter, "&#90;", "Z")

	strExtCharacter = replace(strExtCharacter, "&#97;", "a")
	strExtCharacter = replace(strExtCharacter, "&#98;", "b")
	strExtCharacter = replace(strExtCharacter, "&#99;", "c")
	strExtCharacter = replace(strExtCharacter, "&#100;", "d")
	strExtCharacter = replace(strExtCharacter, "&#101;", "e")
	strExtCharacter = replace(strExtCharacter, "&#102;", "f")
	strExtCharacter = replace(strExtCharacter, "&#103;", "g")
	strExtCharacter = replace(strExtCharacter, "&#104;", "h")
	strExtCharacter = replace(strExtCharacter, "&#105;", "i")
	strExtCharacter = replace(strExtCharacter, "&#106;", "j")
	strExtCharacter = replace(strExtCharacter, "&#107;", "k")
	strExtCharacter = replace(strExtCharacter, "&#108;", "l")
	strExtCharacter = replace(strExtCharacter, "&#109;", "m")
	strExtCharacter = replace(strExtCharacter, "&#110;", "n")
	strExtCharacter = replace(strExtCharacter, "&#111;", "o")
	strExtCharacter = replace(strExtCharacter, "&#112;", "p")
	strExtCharacter = replace(strExtCharacter, "&#113;", "q")
	strExtCharacter = replace(strExtCharacter, "&#114;", "r")
	strExtCharacter = replace(strExtCharacter, "&#115;", "s")
	strExtCharacter = replace(strExtCharacter, "&#116;", "t")
	strExtCharacter = replace(strExtCharacter, "&#117;", "u")
	strExtCharacter = replace(strExtCharacter, "&#118;", "v")
	strExtCharacter = replace(strExtCharacter, "&#119;", "w")
	strExtCharacter = replace(strExtCharacter, "&#120;", "x")
	strExtCharacter = replace(strExtCharacter, "&#121;", "y")
	strExtCharacter = replace(strExtCharacter, "&#122;", "z")

	extCharacter = strExtCharacter
End Function

function replaceCharacter(replaceData)
	replaceData = replace(replaceData, """", "'")

	replaceCharacter = replaceData
end function

function replaceSpecialCharacter(replaceData)
	set expReg = New RegExp
	expReg.Pattern = "([^0-9]|[^a-zA-Z]|-)"
	replaceData = expReg.Replace(replaceData, "")
	replaceSpecialCharacter = replaceData
end function

function esValidoNum(cadena)
  set expReg = New RegExp
  expReg.Pattern = "^[0-9]+$"
  esValidoNum = expReg.Test(cadena) and len(cadena)
  set expReg = nothing
end function
 
function esValidoAlfaNum(cadena)
  set expReg = New RegExp
  expReg.Pattern = "^[a-zA-Z0-9-]+$"
  esValidoAlfaNum = expReg.Test(cadena) and len(cadena)
  set expReg = nothing
end function

function esValidoAlfa(cadena)
  set expReg = New RegExp
  expReg.Pattern = "^[a-zA-Z_ÁÉÍÓÚáéíóúÑñ\s]*$"
  esValidoAlfa = expReg.Test(cadena) and len(cadena)
  set expReg = nothing
end function

function esValidoRut(cadena)
  set expReg = New RegExp
  expReg.Pattern = "^(\d{1}|\d{8})-([a-zA-Z]{1}$|\d{1}$)"
  esValidoRut = expReg.Test(cadena) and len(cadena)
  set expReg = nothing
end function

function esValidoFecha(cadena)
  set expReg = New RegExp
  expReg.Pattern = "^([0][1-9]|[12][0-9]|3[01])(\/|-)([0][1-9]|[1][0-2])\2(\d{4})$"
  esValidoFecha = expReg.Test(cadena) and len(cadena)
  set expReg = nothing
end function

function esValidoHora(cadena)
  set expReg = New RegExp
  expReg.Pattern = "^[0-2][0-3]:[0-5][0-9]:[0-5][0-9]$"
  esValidoHora = expReg.Test(cadena) and len(cadena)
  set expReg = nothing
end function

function TrimEx(byval str)	
	str = server.htmlencode(str)	
	str = extCharacter(str)
	str = trim(str)
	
	TrimEx = str
end function

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
			'response.write("UBound:" & UBound(arrRows))
			'esponse.end()
			
			if cint(UBound(arrRows)) = -1 or cint(UBound(arrRows)) < 12 or cint(UBound(arrRows)) > 12 then
				errLog =  errLog & " {""m"": ""Error en formato (nro de columnas) de la linea "&contadorLineas&"""}, "				
			else
				'Validación de campos
				if esValidoNum(trim(arrRows(0))) = 0 then
					errLog =  errLog & " {""m"": ""Error en formato (Cod BTT sucursal), linea "&contadorLineas&", "&replaceCharacter(arrRows(0))&"""}, "
				else 
					bt_sucursal=cleanseData(arrRows(0),"integer",3)			
					if datoError then
						errLog =  errLog & " {""m"": ""Error en formato (Cod BTT sucursal), linea "&contadorLineas&", "&replaceCharacter(arrRows(0))&"""}, "
					end if
				end if 
								
				if esValidoNum(trim(arrRows(1))) = 0 then
					errLog =  errLog & " {""m"": ""Error en formato (ID Cargo), linea "&contadorLineas&", "&replaceCharacter(arrRows(1))&"""}, "
				else 
					id_cargo=cleanseData(arrRows(1),"integer",1)
					if datoError then
						errLog =  errLog & " {""m"": ""Error en formato (ID Cargo), linea "&contadorLineas&", "&replaceCharacter(arrRows(1))&"""}, "
					end if
					if ((Cint(id_cargo)<> 1) and (Cint(id_cargo) <> 2) and (Cint(id_cargo) <> 3) and (Cint(id_cargo) <> 6)) then
						errLog =  errLog & " {""m"": ""Error en formato (ID Cargo), linea "&contadorLineas&", "&replaceCharacter(arrRows(1))&"""}, "
					end if
				end if 

				if esValidoAlfa(trim(arrRows(2))) = 0 then
					errLog =  errLog & " {""m"": ""Error en formato (Sucursal), linea "&contadorLineas&", "&replaceCharacter(arrRows(2))&"""}, "
				else
					sucursal=cleanseData(arrRows(2),"text",100)
					if datoError then
						errLog =  errLog & " {""m"": ""Error en formato (Sucursal), linea "&contadorLineas&", "&replaceCharacter(arrRows(2))&"""}, "
					end if
				end if
				
				if esValidoAlfa(trim(arrRows(3))) = 0 then
					errLog =  errLog & " {""m"": ""Error en formato (Cargo), linea "&contadorLineas&", "&replaceCharacter(arrRows(3))&"""}, "	
				else
					cargo=cleanseData(arrRows(3),"text",100)
					if datoError then
						errLog =  errLog & " {""m"": ""Error en formato (Cargo), linea "&contadorLineas&", "&replaceCharacter(arrRows(3))&"""}, "
					end if
				end if				
				
				if esValidoRut(trim(arrRows(4))) = 0 then
					errLog =  errLog & " {""m"": ""Error en formato (obs: eliminar espacios-caracteres) (Rut Titular), linea "&contadorLineas&", "&replaceCharacter(arrRows(4))&"""}, "	
				else
					flag_rutTitular = 0
					rut_titular=cleanseData(Trim(arrRows(4)),"text",10)
					if datoError then
						flag_rutTitular = 1
						errLog =  errLog & " {""m"": ""Error en formato (obs: eliminar espacios-caracteres) (Rut Titular), linea "&contadorLineas&", "&replaceCharacter(arrRows(4))&"""}, "						
					end if
					
					if flag_rutTitular = 0 then
						pos_separador=InStr(rut_titular,"-")
						rut=Mid(rut_titular,1,pos_separador-1)
						cod_verificador=LCase(Mid(rut_titular,pos_separador+1))						
						if StrComp(codigo_veri(rut),cod_verificador)<>0 then
							errLog =  errLog & " {""m"": ""Error en formato (Rut Titular), linea "&contadorLineas&", "&replaceCharacter(arrRows(4))&"""}, "							
						end if
					end if 		
				end if
				
				if esValidoRut(trim(arrRows(5))) = 0 then
					errLog =  errLog & " {""m"": ""Error en formato (obs: eliminar espacios-caracteres) (Rut Reemplazo), linea "&contadorLineas&", "&replaceCharacter(arrRows(5))&"""}, "				
				else
					flag_rutReemp = 0
					rut_reemplazo=cleanseData(Trim(arrRows(5)),"text",10)
					if datoError then
						flag_rutReemp = 1						
						
						errLog =  errLog & " {""m"": ""Error en formato (obs: eliminar espacios-caracteres) (Rut Reemplazo), linea "&contadorLineas&", "&replaceCharacter(arrRows(5))&"""}, "						
					end if
					
					if flag_rutReemp = 0 then
						pos_separador=InStr(rut_reemplazo,"-")
						rut=Mid(rut_reemplazo,1,pos_separador-1)
						cod_verificador=LCase(Mid(rut_reemplazo,pos_separador+1))
						if StrComp(codigo_veri(rut),cod_verificador)<>0 then
							errLog =  errLog & " {""m"": ""Error en formato (Rut Reemplazo DV), linea "&contadorLineas&", "&replaceCharacter(arrRows(5))&"""}, "							
						end if
					end if
				end if
				
				if esValidoAlfa(trim(arrRows(6))) = 0 then
					errLog =  errLog & " {""m"": ""Error en formato (Nombre Reemplazo), linea "&contadorLineas&", "&TrimEx(arrRows(6))&"""}, "	
				else
					nombre_reemplazo=cleanseData(arrRows(6),"text",100)
					if datoError then
						errLog =  errLog & " {""m"": ""Error en formato (Nombre Reemplazo), linea "&contadorLineas&", "&TrimEx(arrRows(6))&"""}, "
					end if
				end if
				
				fechaHoy = Date()

				if esValidoFecha(trim(trim(arrRows(7)))) = 0 then
					errLog =  errLog & " {""m"": ""Error en formato (Fecha Inicio), linea "&contadorLineas&", "&replaceCharacter(arrRows(7))&"""}, "
				else
					flag_fechaInicio = 0
					fecha_inicio=cleanseData(arrRows(7),"date",8)
					if datoError then
						flag_fechaInicio = 1
						errLog =  errLog & " {""m"": ""Error en formato (Fecha Inicio), linea "&contadorLineas&", "&replaceCharacter(arrRows(7))&"""}, "						
					end if			
					
					if flag_fechaInicio = 0 then 
						if datediff("d", CDATE(fechaHoy), CDATE(fecha_inicio)) > 0 then				
							errLog =  errLog & " {""m"": ""Error en formato (Fecha Inicio mayor a Fecha Actual), linea "&contadorLineas&", "&replaceCharacter(arrRows(7))&"""}, "							
						end if 
					end if
				end if 				
				
				if esValidoFecha(trim(trim(arrRows(8)))) = 0 then
					errLog =  errLog & " {""m"": ""Error en formato (Fecha Termino), linea "&contadorLineas&", "&replaceCharacter(arrRows(8))&"""}, "
				else
					flag_fechaTermino = 0
					fecha_termino=cleanseData(arrRows(8),"date",8)
					if datoError then
						flag_fechaTermino = 1
						errLog =  errLog & " {""m"": ""Error en formato (Fecha Termino), linea "&contadorLineas&", "&replaceCharacter(arrRows(8))&"""}, "						
					end if
					
					if flag_fechaTermino = 0 then				
						if datediff("d", CDATE(fechaHoy), CDATE(fecha_termino)) < 0 then				
							errLog =  errLog & " {""m"": ""Error en (Fecha Termino / Fecha Caduca), linea "&contadorLineas&", "&replaceCharacter(arrRows(8))&"""}, "							
						end if 
					end if
				end if
								
				if esValidoHora(trim(trim(arrRows(9)))) = 0 then 
					errLog =  errLog & " {""m"": ""Error en formato (Hora Entrada), linea "&contadorLineas&", "&replaceCharacter(arrRows(9))&"""}, "
				else
					hora_entrada=cleanseData(arrRows(9),"time",8)
					if datoError then
						errLog =  errLog & " {""m"": ""Error en formato (Hora Entrada), linea "&contadorLineas&", "&replaceCharacter(arrRows(9))&"""}, "						
					end if
				end if				
				
				if esValidoHora(trim(trim(arrRows(10)))) = 0 then 
					errLog =  errLog & " {""m"": ""Error en formato (Hora Salida), linea "&contadorLineas&", "&replaceCharacter(arrRows(10))&"""}, "
				else
					hora_salida=cleanseData(arrRows(10),"time",8)
					if datoError then
						errLog =  errLog & " {""m"": ""Error en formato (Hora Salida), linea "&contadorLineas&", "&replaceCharacter(arrRows(10))&"""}, "						
					end if
				end if	

				if esValidoAlfa(trim(arrRows(11))) = 0 then
					errLog =  errLog & " {""m"": ""Error en formato (Empresa), linea "&contadorLineas&", "&replaceCharacter(arrRows(11))&"""}, "	
				else
					empresa=cleanseData(arrRows(11),"text",100)
					if datoError then
						errLog =  errLog & " {""m"": ""Error en formato (Empresa), linea "&contadorLineas&", "&replaceCharacter(arrRows(11))&"""}, "
					end if
				end if

				if esValidoAlfa(trim(arrRows(12))) = 0 then
					errLog =  errLog & " {""m"": ""Error en formato (Motivo), linea "&contadorLineas&", "&replaceCharacter(arrRows(12))&"""}, "	
				else
					motivo=cleanseData(arrRows(12),"text",1000)
					if datoError then
						errLog =  errLog & " {""m"": ""Error en formato (Motivo), linea "&contadorLineas&", "&replaceCharacter(arrRows(12))&"""}, "
					end if
				end if

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