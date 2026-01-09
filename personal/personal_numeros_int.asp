<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones2.asp"-->
<%
idUsuario = Trim(request("idUsuario"))
perfil = Trim(request("idPerfil"))

codSucursal = ""
sqlSuc = ""

	if (perfil = 2) then
		sqlSucs = ""
		sqlSucs = sqlSucs & "and id_sucursal in ( select id_sucursal "
		sqlSucs = sqlSucs & "from SUC_zonales_sucursal "
		sqlSucs = sqlSucs & "where id_zonal =  " & idUsuario &" )"
		
		'set rsSucs = db.execute(sqlSucs)		
		'if not rsSucs.eof then
		''  dataSucs = rsSucs.GetRows()
		'end if
		'for y=0 to ubound(dataSucs,2)
		''  codSucursal = codSucursal & dataSucs(0,y) & ","
		'next
		'codSucursal = left(codSucursal, (len(codSucursal)-1))		
		'rsSucs.close: set rsSucs = nothing 
		''
		'sqlSuc = ""
		'sqlSuc = sqlSuc & "and id_sucursal in ("&codSucursal&")"
	end if
	
	sql = ""
	sql = sql & "select "	 
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_dotacion "
	sql = sql & "where cargo = 1 "&sqlSucs&") as jeps, "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_dotacion "
	sql = sql & "where cargo = 2 "&sqlSucs&") as jepsm, "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_dotacion "
	sql = sql & "where cargo = 3 "&sqlSucs&") as ao, "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_dotacion "
	sql = sql & "where cargo = 4 "&sqlSucs&") as val, "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_dotacion "
	sql = sql & "where cargo = 5 "&sqlSucs&") as tes "
    
	'Response.Write(sql)
	'Response.End
	set rs = db.execute(sql)
	if not rs.eof then
	
	'=====================================================================
	' JSON
	'=====================================================================
	 Response.ContentType = "application/json"
	 
	 Response.Write "{"
	 Response.Write "  ""datos"": " 
	 Response.Write "{ "
	
	 Response.Write " ""jeps"": """&rs("jeps")&""", "
	 Response.Write " ""jepsm"": """&rs("jepsm")&""", "
	 Response.Write " ""ao"": """&rs("ao")&""", "
	 Response.Write " ""val"": """&rs("val")&""", "	
	 Response.Write " ""tes"": """&rs("tes")&""" "
	
	 Response.Write "} }"		
	end if

%>