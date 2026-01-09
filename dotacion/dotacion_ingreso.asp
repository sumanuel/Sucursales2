<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<% 
q=request("q")

if(q="1") then
	idSucursal=request("idSucursal")
	tipo=request("tipo")
	rut=request("rut")
	dv=request("dv")
	nombres=request("nombres")
	apep=request("apep")
	apem=request("apem")
	cargo=request("cargo")
	anexo=request("anexo")
	zona=request("zona")
	zonal=request("zonal")  
	sucursal=request("sucursal")
	detalle=request("detalle")
	
	
	
	qry ="exec dbo.SUC_prc_sucursal_dotacion_ing '"&idSucursal&"','"&tipo&"','"&rut&"','"&dv&"','"&nombres&"','"&apep&"','"&apem&"','"&cargo&"','"&anexo&"','"&zona&"','"&zonal&"','"&sucursal&"','"&detalle&"'"
	DB.execute(qry)
end if

if(q="2") then

idSucDot = request("idsucdot")
	
qry =""
qry = qry & "select a.id_sucdot, b.tipo, a.rut, a.dv, a.nombres, a.apep, a.apem, c.cargo, a.anexo, d.zona, e.zonal, a.id_sucursal_dest, f.suc_nombre, a.detalle "
qry = qry & "from SUC_sucursal_dotacion a "
qry = qry & "inner join SUC_sucursal_dotacion_tipo b on a.tipo = b.id_tipo "
qry = qry & "inner join SUC_sucursal_dotacion_cargos c on a.cargo = c.id_cargo "
qry = qry & "left outer join SUC_sucursal_dotacion_zonas d on a.zona = d.id_zona "
qry = qry & "left outer join SUC_sucursal_dotacion_zonales e on a.zonal = e.id_zonal "
qry = qry & "left outer join SUC_sucursal f on a.id_sucursal_dest = f.id_sucursal "
qry = qry & "where a.id_sucdot = " & idSucDot
Set rsDot = DB.execute(qry)
	
	'=====================================================================
	' JSON
	'=====================================================================
	 'Response.ContentType = "application/json"
'	 
'	 Response.Write "{"
'	 Response.Write "  ""datos"": " 
'	 Response.Write "{ "
'	 
'	 Response.Write "   ""tipo"": """&rsDot("tipo")&""", "
'	 Response.Write "   ""rut"": """&rsDot("rut")&""", "
'	 Response.Write "   ""dv"": """&rsDot("dv")&""", "
'	 Response.Write "   ""nombres"": """&rsDot("nombres")&""", "
'	 Response.Write "   ""apep"": """&rsDot("apep")&""", "
'	 Response.Write "   ""apem"": """&rsDot("apem")&""", "
'	 Response.Write "   ""cargo"": """&rsDot("cargo")&""", "
'	 Response.Write "   ""anexo"": """&rsDot("anexo")&""", "
'	 Response.Write "   ""zona"": """&rsDot("zona")&""", "
'	 Response.Write "   ""zonal"": """&rsDot("zonal")&""", "
'	 Response.Write "   ""suc_nombre"": """&rsDot("suc_nombre")&""", "
'	 Response.Write "   ""detalle"": """&rsDot("detalle")&""" "
'	 
'	 Response.Write "} }"
	 
%>
<table class="table table-bordered table-hover pagination-centered">
    <tr>
    	<td>Nombre</td>
        <td><%=rsDot("nombres")%>&nbsp;<%=rsDot("apep")%>&nbsp;<%=rsDot("apem")%></td>
    </tr>
    <tr>
    	<td>R.U.N</td>
        <td><%=rsDot("rut")%>-<%=rsDot("dv")%></td>
    </tr>    
    <tr>
    	<td>Tipo</td>
        <td><%=rsDot("tipo")%></td>
    </tr>
    <tr>
    	<td>Cargo</td>
        <td><%=rsDot("cargo")%></td>
    </tr>
    <tr>
    	<td>Anexo</td>
        <td><%=rsDot("anexo")%></td>
    </tr>
    <tr>
    	<td>Zonal</td>
        <td><%=rsDot("zonal")%></td>
    </tr>
    <tr>
    	<td>Zona</td>
        <td><%=rsDot("zona")%></td>
    </tr>
    <tr>
    	<td>Sucursal Asignada</td>
        <td><%=rsDot("suc_nombre")%></td>
    </tr>
    <tr>
    	<td>Comentarios</td>
        <td><%=rsDot("detalle")%></td>
    </tr>
    </table>
<%

rsDot.Close
set rsDot.ActiveConnection = nothing
set rsDot=nothing
	 
end if

if(q="3") then

idSucDot = request("idsucdot")

qry =""
qry = qry & "delete from SUC_sucursal_dotacion where id_sucdot = " & idSucDot
DB.execute(qry)
Response.Write("Eliminar dotacion")

end if 

DB.Close
set DB=nothing	
%>