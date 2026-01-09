<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones.asp"-->
<%
idUsuario = Trim(request("idUsuario"))
perfil = Trim(request("idPerfil"))

codSucursal = ""
sqlSuc = ""

	if (perfil = 2) then
		sqlSucs = ""
		sqlSucs = sqlSucs & "select id_sucursal "
		sqlSucs = sqlSucs & "from SUC_zonales_sucursal "
		sqlSucs = sqlSucs & "where id_zonal =  " & idUsuario
		
		set rsSucs = db.execute(sqlSucs)		
		if not rsSucs.eof then
		  dataSucs = rsSucs.GetRows()
		end if
		for y=0 to ubound(dataSucs,2)
		  codSucursal = codSucursal & dataSucs(0,y) & ","
		next
		codSucursal = left(codSucursal, (len(codSucursal)-1))		
		rsSucs.close: set rsSucs = nothing 
		
		sqlSuc = ""
		sqlSuc = sqlSuc & "and id_sucursal in ("&codSucursal&")"
	end if
	
	if (perfil = 55) then
		sqlSucs = ""
		sqlSucs = sqlSucs & "select id_sucursal "
		sqlSucs = sqlSucs & "from SUC_zonales_comercial_sucursal "
		sqlSucs = sqlSucs & "where id_zonal =  " & idUsuario
		
		set rsSucs = db.execute(sqlSucs)		
		if not rsSucs.eof then
		  dataSucs = rsSucs.GetRows()
		end if
		for y=0 to ubound(dataSucs,2)
		  codSucursal = codSucursal & dataSucs(0,y) & ","
		next
		codSucursal = left(codSucursal, (len(codSucursal)-1))		
		rsSucs.close: set rsSucs = nothing 
		
		sqlSuc = ""
		sqlSuc = sqlSuc & "and id_sucursal in ("&codSucursal&")"
	end if
	
	if (perfil = 66) then
		sqlSucs = ""
		sqlSucs = sqlSucs & "select id_sucursal "
		sqlSucs = sqlSucs & "from SUC_zonales_comercial_mas_sucursal "
		sqlSucs = sqlSucs & "where id_zonal =  " & idUsuario
		
		set rsSucs = db.execute(sqlSucs)		
		if not rsSucs.eof then
		  dataSucs = rsSucs.GetRows()
		end if
		for y=0 to ubound(dataSucs,2)
		  codSucursal = codSucursal & dataSucs(0,y) & ","
		next
		codSucursal = left(codSucursal, (len(codSucursal)-1))		
		rsSucs.close: set rsSucs = nothing 
		
		sqlSuc = ""
		sqlSuc = sqlSuc & "and id_sucursal in ("&codSucursal&")"
	end if
	

	sql = ""
	sql = sql & "select "	 
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal "
	sql = sql & "where tipo_personal='Cajero' and tipo = 'titular' "&sqlSuc&") as cajerotitular "
	sql = sql & ", "
	sql = sql & "(select count(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal "
	sql = sql & "where tipo_personal='Cajero' and tipo = 'reemplazo' "&sqlSuc&") as cajeroreemplazo "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal "
	sql = sql & "where tipo_personal='CAJERO ADICIONAL' and tipo = 'reemplazo' "&sqlSuc&") as cajeroadicional "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal "
	sql = sql & "where tipo_personal in ('Cajero','CAJERO ADICIONAL') and asistencia is not null "&sqlSuc&") as cajerosregistrados "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal "
	sql = sql & "where tipo_personal in ('Cajero','CAJERO ADICIONAL') and asistencia is not null and asistencia='si' "&sqlSuc&") as cajerospresentes "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal "
	sql = sql & "where tipo_personal in ('Cajero','CAJERO ADICIONAL') and asistencia is not null and asistencia='no' "&sqlSuc&") as cajerosausentes "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal (nolock) "
	sql = sql & "where tipo_personal='Asesor de Clientes' and tipo = 'titular' "&sqlSuc&") as asesortitular "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal (nolock) "
	sql = sql & "where tipo_personal='Asesor de Clientes' and tipo = 'reemplazo' "&sqlSuc&") as asesoreemplazo "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal (nolock)  "
	sql = sql & "where tipo_personal='Asesor de Clientes' and asistencia is not null "&sqlSuc&") as asesoresregistrados "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal (nolock) "
	sql = sql & "where tipo_personal='Asesor de Clientes' and asistencia is not null and asistencia='si' "&sqlSuc&") as asesorespresentes "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal (nolock) "
	sql = sql & "where tipo_personal='Asesor de Clientes' and asistencia is not null and asistencia='no' "&sqlSuc&") as asesoresausentes "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal (nolock) "
	sql = sql & "where tipo_personal='Paramedico' and tipo = 'titular' "&sqlSuc&") as paramedicotitular "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal (nolock) "
	sql = sql & "where tipo_personal='Paramedico' and tipo = 'reemplazo' "&sqlSuc&") as paramedicoreemplazo "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal (nolock) "
	sql = sql & "where tipo_personal='Paramedico' and asistencia is not null "&sqlSuc&") as paramedicosregistrados "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal (nolock) " 
	sql = sql & "where tipo_personal='Paramedico' and asistencia is not null and asistencia='si' "&sqlSuc&") as paramedicospresentes "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_asistencia_personal (nolock) "
	sql = sql & "where tipo_personal='Paramedico' and asistencia is not null and asistencia='no' "&sqlSuc&") as paramedicosausentes "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_guardias_asistencia (nolock) "
	sql = sql & "where tipo_suc = 'titular' "&sqlSuc&") as guardiastitulares "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_guardias_asistencia (nolock) "
	sql = sql & "where tipo_suc = 'reemplazo' "&sqlSuc&") as guardiasreemp "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_guardias_asistencia (nolock) "
	sql = sql & "where asistencia is not null "&sqlSuc&") as guardiasregistrados "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_guardias_asistencia (nolock) "
	sql = sql & "where asistencia = 'si' "&sqlSuc&") as guardiaspresentes "
	sql = sql & ", "
	sql = sql & "(select COUNT(*) "
	sql = sql & "from SUC_sucursal_guardias_asistencia (nolock) "
	sql = sql & "where (asistencia = 'no' or asistencia is null) "&sqlSuc&") as guardiasausentes "
    
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
	
	 Response.Write " ""cajerotitular"": """&rs("cajerotitular")&""", "
	 Response.Write " ""cajeroreemplazo"": """&rs("cajeroreemplazo")&""", "
	 Response.Write " ""cajeroadicional"": """&rs("cajeroadicional")&""", "
	 Response.Write " ""cajerosregistrados"": """&rs("cajerosregistrados")&""", "
	 Response.Write " ""cajerospresentes"": """&rs("cajerospresentes")&""", "
	 Response.Write " ""cajerosausentes"": """&rs("cajerosausentes")&""", "
	 Response.Write " ""asesortitular"": """&rs("asesortitular")&""", "
	 Response.Write " ""asesoreemplazo"": """&rs("asesoreemplazo")&""", "
	 Response.Write " ""asesoresregistrados"": """&rs("asesoresregistrados")&""", "
	 Response.Write " ""asesorespresentes"": """&rs("asesorespresentes")&""", "
	 Response.Write " ""asesoresausentes"": """&rs("asesoresausentes")&""", "
	 Response.Write " ""paramedicotitular"": """&rs("paramedicotitular")&""", "
	 Response.Write " ""paramedicoreemplazo"": """&rs("paramedicoreemplazo")&""", "
	 Response.Write " ""paramedicosregistrados"": """&rs("paramedicosregistrados")&""", "
	 Response.Write " ""paramedicospresentes"": """&rs("paramedicospresentes")&""", "
	 Response.Write " ""paramedicosausentes"": """&rs("paramedicosausentes")&""", "
	 Response.Write " ""guardiastitulares"": """&rs("guardiastitulares")&""", "
	 Response.Write " ""guardiasreemp"": """&rs("guardiasreemp")&""", "
	 Response.Write " ""guardiasregistrados"": """&rs("guardiasregistrados")&""", "
	 Response.Write " ""guardiaspresentes"": """&rs("guardiaspresentes")&""", "
	 Response.Write " ""guardiasausentes"": """&rs("guardiasausentes")&""" "
	
	 Response.Write "} }"		
	end if

%>