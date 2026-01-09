<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
'Option Explicit

truncateTitularesTemp="truncate table dbo.SUC_sucursal_guardias_ttemp"
DB.Execute(truncateTitularesTemp)

'The function "cleanseData" takes three parameters, the input itself, the datatype that it is supposed to be, and the maximum character length the input should be allowed to be.
'Valid data types are "email", "integer", "date", "string" and "text". 
'The first three are obvious, the last two are slight differences. 
'The "string" I use to validate text-based querystrings, allowing only letters, numbers, _, - and . whereas "text" is any free-form text form field type content.
Dim datoError
datoError = false

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
	
	sFileName = "..\upload\guardias_titulares.csv"  
			
	'*** Create Object ***'   
	Set objFSO = CreateObject("Scripting.FileSystemObject")   
	'*** Check Exist Files ***'   
	If Not objFSO.FileExists(Server.MapPath(sFileName)) Then		
		Response.Write("Archivo no Encontrado")
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
			
			'=====================================================
			' arrRows(0) -> COD_BT			-> integer
			' arrRows(1) -> SUCURSAL		-> text
			' arrRows(2) -> TIPO			-> text
			' arrRows(3) -> EMPRESA			-> text
			' arrRows(4) -> NOMBRE_GUARDIA 	-> text
			' arrRows(5) -> RUT_GUARDIA		-> rut
			' arrRows(6) -> ENTRADA			-> time
			' arrRows(7) -> SALIDA			-> time
			'=====================================================

			'Validación de campos
			bt_sucursal=specialCharacterEncoding(Trim(arrRows(0)))
			sucursal=specialCharacterEncoding(Trim(arrRows(1)))
			tipo_suc=specialCharacterEncoding(Trim(arrRows(2)))
			empresa=specialCharacterEncoding(Trim(arrRows(3)))
			nombre_titular=specialCharacterEncoding(Trim(arrRows(4)))		
			rut_titular=specialCharacterEncoding(Trim(arrRows(5)))
						
			'if len(Trim(rut_titular)) > 3 then
'				pos_separador=InStr(rut_titular,"-")
'				rut=Mid(rut_titular,1,pos_separador-1)
'				cod_verificador=LCase(Mid(rut_titular,pos_separador+1))
'				if StrComp(codigo_veri(rut),cod_verificador)<>0 then
'					errLog =  errLog & " {""m"": ""Error en formato (Rut Titular), linea "&contadorLineas&", "&arrRows(5)&"""}, "
'					'Response.Write("Error en RUT Reemplazo, linea "&contadorLineas&", '"&arrRows(5)&"'")
'					'Response.End()	
'				end if
'			end if 
			
			hora_entrada=specialCharacterEncoding(arrRows(6))						
			hora_salida=specialCharacterEncoding(arrRows(7))
						
			titular="insert into dbo.SUC_sucursal_guardias_ttemp values ("&bt_sucursal&",'"&sucursal&"','"&tipo_suc&"','"&empresa&"','"&nombre_titular&"','"&rut_titular&"',cast('"&hora_entrada&"' as time),cast('"&hora_salida&"' as time),GETDATE())"   
			'response.Write(titular & "<br/>")
			DB.execute(titular)
		Loop  
		
        oInStream.Close()   
        Set oInStream = Nothing  
    	
		truncateReemplazos="truncate table dbo.SUC_sucursal_guardias_t"
		DB.Execute(truncateReemplazos)
		titular="insert into dbo.SUC_sucursal_guardias_t(cod_bantotal, sucursal, tipo, empresa, guardia_nombre, guardia_rut, guardia_p_entrada, guardia_p_salida) "
		titular= titular & " select cod_bantotal, sucursal, tipo, empresa, guardia_nombre, guardia_rut, guardia_p_entrada, guardia_p_salida from SUC_sucursal_guardias_ttemp "   
		DB.execute(titular)
		
		'PROCESAR ASISTENCIA DE GUARDIAS TITULARES
		DB.execute("exec SUC_prc_sucursal_asist_guardias_prc_titulares")
		
	End IF   

'else 'Si no esxiste una sesión
'	Session("id_usuario") = ""
'	Session("nombre") = ""
'	Session("tipo") = ""
'	response.Redirect("login.asp")
'end if
%>