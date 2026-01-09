<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
<!--#include file="../conexion/conexion.asp"-->
<%
truncatePersonalTemp="truncate table dbo.SUC_sucursal_personal_temp"
DB.Execute(truncatePersonalTemp)

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
	
	'Response.ContentType = "application/xml"
	
	Dim objFSO,oInStream,sRows,arrRows
	Dim sFileName
	Dim xml 
	
	sFileName = "..\upload\titulares.csv"  
	
	''*** Create Object ***'   
	Set objFSO = CreateObject("Scripting.FileSystemObject")   
	
	'*** Open Files ***'
	Set oInStream = objFSO.OpenTextFile(Server.MapPath(sFileName),1,False)
	
	contadorLineas=0   
	Dim errLog
	errLog = ""
	xml = ""
	xml = xml & "<root>"
	Do Until oInStream.AtEndOfStream   
		contadorLineas=contadorLineas+1
		sRows = oInStream.readLine   
		arrRows = Split(sRows,";")   
		'Xml
		xml = xml & "<p>"
		
		bt_sucursal=specialCharacterEncoding(arrRows(0))
		xml = xml & "<bt_sucursal>" & bt_sucursal & "</bt_sucursal>"
		
		id_cargo=specialCharacterEncoding(arrRows(1))
		xml = xml & "<id_cargo>" & id_cargo & "</id_cargo>"
		
		sucursal=specialCharacterEncoding(arrRows(2))
		xml = xml & "<sucursal>" & sucursal & "</sucursal>"
		
		cargo=specialCharacterEncoding(arrRows(3))
		xml = xml & "<cargo>" & cargo & "</cargo>"
		
		rut_titular=specialCharacterEncoding(Trim(arrRows(4)))
		xml = xml & "<rut_titular>" & rut_titular & "</rut_titular>"
		
		pos_separador=InStr(rut_titular,"-")			
		rut=Mid(rut_titular,1,pos_separador-1)
		cod_verificador=LCase(Mid(rut_titular,pos_separador+1))
					
		nombre=specialCharacterEncoding(arrRows(5))						
		xml = xml & "<nombre>" & nombre & "</nombre>"
		
		apep=specialCharacterEncoding(arrRows(6))	
		xml = xml & "<apep>" & apep & "</apep>"
				
		apem=specialCharacterEncoding(arrRows(7))
		xml = xml & "<apem>" & apem & "</apem>"
		
		fecha_ingreso=specialCharacterEncoding(arrRows(8))
		xml = xml & "<fecha_ingreso>" & fecha_ingreso & "</fecha_ingreso>"
		
		empresa=specialCharacterEncoding(arrRows(9))			
		xml = xml & "<empresa>" & empresa & "</empresa>"
		
		xml = xml & "</p>"
		
		titulares="insert into dbo.SUC_sucursal_personal_temp (bt_sucursal,id_cargo,nombre_sucursal,nombre_cargo,rut_personal,nombre_personal,apep_personal,apem_personal,fecha_ingreso,tipo,empresa) values ("&bt_sucursal&","&id_cargo&",'"&sucursal&"','"&cargo&"','"&rut_titular&"','"&nombre&"','"&apep&"','"&apem&"',convert(date,'"&fecha_ingreso&"',105),'titular','"&empresa&"')"   
		DB.execute(titulares)			
	Loop  
	xml = xml & "</root>"
	
	oInStream.Close()   
	Set oInStream = Nothing  
	
	truncatePersonal="truncate table dbo.SUC_sucursal_personal"
	DB.Execute(truncatePersonal)
	titulares = ""
	titulares = titulares & "insert into dbo.SUC_sucursal_personal (rut_personal,nombre_personal,apep_personal,apem_personal,id_cargo, nombre_cargo,fecha_ingreso,tipo,bt_sucursal,empresa) "
	titulares = titulares & "select rut_personal, nombre_personal, apep_personal, apem_personal, id_cargo, nombre_cargo, fecha_ingreso,tipo,bt_sucursal,empresa from dbo.SUC_sucursal_personal_temp "   
	DB.execute(titulares)
	
	'Response.Write(xml)
	DB.execute("exec SUC_prc_sucursal_personal_carga 'titular'")
	'Response.Write("exec SUC_prc_sucursal_personal_carga '" & xml & "'")	
	
	updateNames = ""
	updateNames = updateNames & "update SUC_sucursal_asistencia_personal set "	 
	updateNames = updateNames & "nombre_personal = (rtrim(ltrim(b.nombre_personal)) + ' ' + rtrim(ltrim(b.apep_personal)) + ' ' + rtrim(ltrim(b.apem_personal))) "
	updateNames = updateNames & "from SUC_sucursal_asistencia_personal a "
	updateNames = updateNames & "inner join SUC_sucursal_personal b on a.rut_personal = b.rut_personal "
	updateNames = updateNames & "where a.tipo = 'titular' "
	
	DB.execute(updateNames)
	
	DB.Close()
	Set DB = Nothing
%>