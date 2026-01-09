<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
truncateReemplazosTemp="truncate table dbo.SUC_sucursal_reemplazos_temp"
DB.Execute(truncateReemplazosTemp)

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

	sFileName = "..\upload\reemplazos.csv"

	'*** Create Object ***'
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	'*** Check Exist Files ***'
	If Not objFSO.FileExists(Server.MapPath(sFileName)) Then
		Response.Write("Archivo no Existe")
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
			bt_sucursal=specialCharacterEncoding(arrRows(0))
			id_cargo=specialCharacterEncoding(arrRows(1))
			sucursal=specialCharacterEncoding(arrRows(2))
			cargo=specialCharacterEncoding(arrRows(3))
			rut_titular=specialCharacterEncoding(Trim(arrRows(4)))

			pos_separador=InStr(rut_titular,"-")
			rut=Mid(rut_titular,1,pos_separador-1)
			cod_verificador=LCase(Mid(rut_titular,pos_separador+1))

			rut_reemplazo=specialCharacterEncoding(Trim(arrRows(5)))
			pos_separador=InStr(rut_reemplazo,"-")
			rut=Mid(rut_reemplazo,1,pos_separador-1)
			cod_verificador=LCase(Mid(rut_reemplazo,pos_separador+1))

			nombre_reemplazo=specialCharacterEncoding(arrRows(6))
			fecha_inicio=specialCharacterEncoding(arrRows(7))
			fecha_termino=specialCharacterEncoding(arrRows(8))
			hora_entrada=specialCharacterEncoding(arrRows(9))
			hora_salida=specialCharacterEncoding(arrRows(10))
			empresa=specialCharacterEncoding(arrRows(11))
			motivo=specialCharacterEncoding(arrRows(12))

			reemplazo="insert into dbo.SUC_sucursal_reemplazos_temp values ("&bt_sucursal&","&id_cargo&",'"&sucursal&"','"&cargo&"','"&rut_titular&"','"&rut_reemplazo&"','"&nombre_reemplazo&"',convert(date,'"&fecha_inicio&"',105),convert(date,'"&fecha_termino&"',105),cast('"&hora_entrada&"' as time),cast('"&hora_salida&"' as time),'"&empresa&"','"&motivo&"',GETDATE(),GETDATE())"
			'Response.Write(reemplazo)
			DB.execute(reemplazo)
		Loop

		oInStream.Close()
        Set oInStream = Nothing

		truncateReemplazos="truncate table dbo.SUC_sucursal_reemplazos"
		DB.Execute(truncateReemplazos)
		reemplazo="insert into dbo.SUC_sucursal_reemplazos(bt_sucursal,id_cargo,nombre_sucursal,nombre_cargo,rut_titular,rut_reemp,nombre_reemp,desde,hasta,hora_ingreso,hora_salida,empresa,motivo,fecha_reg,hora_reg) "
		reemplazo=reemplazo+"select * from SUC_sucursal_reemplazos_temp"
		DB.execute(reemplazo)

		DB.execute("exec SUC_prc_sucursal_personal_carga 'reemplazo'")

		'Actualiza el nombre del titular asociado al reemplazo
		sql_update = ""
		sql_update = sql_update + "update SUC_sucursal_reemplazos set "
		sql_update = sql_update + "nombre_titular = (rtrim(ltrim(b.nombre_personal)) + ' ' + rtrim(ltrim(b.apep_personal)) + ' ' + rtrim(ltrim(b.apem_personal))) "
		sql_update = sql_update + "from SUC_sucursal_reemplazos a "
		sql_update = sql_update + "inner join SUC_sucursal_personal b on a.bt_sucursal = b.bt_sucursal "
		sql_update = sql_update + "where a.rut_titular = b.rut_personal "

		DB.execute(sql_update)

	End IF

'else 'Si no esxiste una sesión
'	Session("id_usuario") = ""
'	Session("nombre") = ""
'	Session("tipo") = ""
'	response.Redirect("login.asp")
'end if
%>
