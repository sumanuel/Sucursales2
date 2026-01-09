<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones2.asp"-->
<%
idUsuario = Trim(request("idUsuario"))
perfil = Trim(request("idPerfil"))


	sql = ""
	sql = sql & " exec SUC_prc_index_asistencia_ex_b "
	sql = sql & "'"&perfil&"', "
	sql = sql & " '"&idUsuario&"' "
	

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
	 Response.Write " ""cajerosausentesadicionales"": """&rs("cajerosausentesadicionales")&""", "
	 Response.Write " ""cajerosausentestitulares"": """&rs("cajerosausentestitulares")&""", "

	 'Response.Write " ""asesortitular"": """&rs("asesortitular")&""", "
	 'Response.Write " ""asesoreemplazo"": """&rs("asesoreemplazo")&""", "
	 'Response.Write " ""asesoresregistrados"": """&rs("asesoresregistrados")&""", "
	 'Response.Write " ""asesorespresentes"": """&rs("asesorespresentes")&""", "
	 'Response.Write " ""asesoresausentes"": """&rs("asesoresausentes")&""", "
	 'Response.Write " ""paramedicotitular"": """&rs("paramedicotitular")&""", "
	 'Response.Write " ""paramedicoreemplazo"": """&rs("paramedicoreemplazo")&""", "
	 'Response.Write " ""paramedicosregistrados"": """&rs("paramedicosregistrados")&""", "
	 'Response.Write " ""paramedicospresentes"": """&rs("paramedicospresentes")&""", "
	 'Response.Write " ""paramedicosausentes"": """&rs("paramedicosausentes")&""", "

	 Response.Write " ""guardiastitulares"": """&rs("guardiastitulares")&""", "
	 Response.Write " ""guardiasreemp"": """&rs("guardiasreemp")&""", "
	 Response.Write " ""guardiasregistrados"": """&rs("guardiasregistrados")&""", "
	 Response.Write " ""guardiaspresentes"": """&rs("guardiaspresentes")&""", "
	 Response.Write " ""guardiasausentes"": """&rs("guardiasausentes")&""" "
	
	 Response.Write "} }"		
	end if

%>