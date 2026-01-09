<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<!--JQUERY Thickbox (Ventanas emergentes, imagenes)-->
<link rel="stylesheet" href="CSS/thickbox.css" type="text/css" media="screen" />
<script type="text/javascript" src="JS/jquery-latest.js" mce_src="JS/jquery-latest.js"></script>
<script type="text/javascript" src="JS/thickbox.js" mce_src="JS/thickbox.js"></script>

<!--AJAX Carga DIV Dinamico-->
<script type="text/javascript" src="divDinamicos/div_dinamicos.js" mce_src="divDinamicos/div_dinamicos.js"></script>

<!--Llamada a archivo CSS externo-->
<link rel="stylesheet" type="text/css" href="CSS/estilo.css" />

<!--Llamada a archivo Javascript-->
<script language="javascript" type="text/javascript" src="JS/script.js" ></script>

<!--Llamada a archivos JQUERY-->
<link rel="stylesheet" type="text/css" href="CSS/estilo.css" />
<link type="text/css" href="css/redmond/jquery-ui-1.8.21.custom.css" rel="stylesheet" />
<script type="text/javascript" src="js/jquery-ui-1.8.21.custom.min.js"></script>

<!--Llamada a archivos JQUERY Tablas -->
<script type="text/javascript" src="tablesorter/jquery.tablesorter.js" ></script> 
<link rel="stylesheet" type="text/css" href="tablesorter/themes/blue/style.css" />

<script type="text/javascript">
	$(document).ready(function(){
		$("#tableDotacion").tablesorter();
	});
</script>

<% bt_sucursal=request.QueryString("sucursal")  
'response.Write(bt_sucursal)
'response.End()

%><!--#include file="conex.asp"--><%

set rsSucursal = server.createObject("ADODB.Recordset")
sucursal ="select a.bt_sucursal,a.nombre_sucursal,a.tipo_sucursal,a.direccion_sucursal,b.nombre_jeps+' '+b.apep_jeps+' '+b.apem_jeps as nombre from sucursales.dbo.sucursales a join sucursales.dbo.jeps b on a.bt_sucursal=b.bt_sucursal where a.bt_sucursal="&bt_sucursal&""
conex.execute(sucursal)
rsSucursal.open sucursal, conex

set rsDotacion = server.createObject("ADODB.Recordset")
dotacion ="select a.id_dotacion,a.bt,CASE WHEN a.bt<>'' THEN (select nombre_sucursal from sucursales.dbo.sucursales where bt_sucursal=a.bt) ELSE '---' END as bt_nombre,a.rut,a.dv,CASE WHEN a.nombres<>'' THEN a.nombres+' '+a.apep+' '+a.apem ELSE '---' END as nombre,b.cargo,CASE WHEN a.anexo<>'' THEN a.anexo ELSE '---' END as anexo,CASE WHEN a.zonal<>'' THEN (select zonal from DOTA_zonales where id_zonal=a.zonal) ELSE '---' END as zonal,CASE WHEN a.zona<>'' THEN (select zona from DOTA_zonas where id_zona=a.zona) ELSE '---' END as zona,c.tipo,CASE WHEN a.sucursal<>'' THEN (select nombre_sucursal from sucursales.dbo.sucursales where bt_sucursal=a.sucursal) ELSE '---' END as sucursal,CASE WHEN a.detalle<>'' THEN a.detalle ELSE '---' END as detalle from DOTA_dotacion a join DOTA_cargos b on a.cargo=b.id_cargo join DOTA_tipos c on a.tipo=c.id_tipo where a.bt="&bt_sucursal&" and a.est_reg=1"
conex.execute(dotacion)
rsDotacion.open dotacion, conex

set rsTipos = server.createObject("ADODB.Recordset")
tipos ="select * from dbo.DOTA_tipos where est_reg=1"
conex.execute(tipos)
rsTipos.open tipos, conex

%>

</head>
<body topmargin="0">
	<div style="width:100%">
        <table width="100%">
            <tr>
                <td><img src="img/logosolo.gif" width="50" height="47"></td>
                <td align="right" style=" font-family:Verdana; font-weight:bold; font-size:21px; color:#F47922"><span style="color:#0075BE">Atenci&oacute;n Clientes </span>- Dotaci&oacute;n Sucursal</td>
            </tr>
        </table>
    </div>
    <div id="Menu">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr height="20px">
                <td width="220px" align="center"><a href="http://lh-contoper-p1/sucursales/admin_jeps_admin_sucursal.asp?sucursal=<%response.Write(bt_sucursal)%>" class="menu" >Volver a Administraci&oacute;n Sucursal</a></td>
                <td align="right"><span class="TextoNegro"><b><SCRIPT>document.write(fechaLarga());</SCRIPT></b></span></td>
            </tr>
        </table>
    </div>
    <div id="Central">
        <div id="Main">
            <br/>
            <form id="dota" name="dota" method="post" action="tipo_dotacion_control.asp" onsubmit="return validarIngreso()">
            <table width="80%">
                <tr height="20px">
                	<td align="left" class="Titulo3" bgcolor="#F3F3F3" colspan="2">Datos Sucursal</td>
            	</tr>
                <tr>
                	<td class="TextoNegroTablas" width="50%">
                    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
                    		<tr align="left">
                    			<td class="TextoAzul" style="font-size:11px" width="120px"><strong>Sucursal:</strong></td>
                                <td><% response.Write(rsSucursal("nombre_sucursal")&" ["&rsSucursal("bt_sucursal")&"]") %></td>
                           	</tr>
                            <tr align="left">
                    			<td class="TextoAzul" style="font-size:11px" width="120px"><strong>Tipo Sucursal:</strong></td>
                                <td><% response.Write(rsSucursal("tipo_sucursal")) %></td>
                           	</tr>
                        </table>
                    </td>
                    <td class="TextoNegroTablas" width="50%">
                    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
                    		<tr align="left">
                    			<td class="TextoAzul" style="font-size:11px" width="120px"><strong>Direcci&oacute;n:</strong></td>
                                <td><% response.Write(rsSucursal("direccion_sucursal")) %></td>
                           	</tr>
                            <tr align="left">
                    			<td class="TextoAzul" style="font-size:11px" width="120px"><strong>JEPS:</strong></td>
                                <td><% response.Write(rsSucursal("nombre")) %></td>
                           	</tr>
                    	</table>
                    </td>
            	</tr>
                <tr height="20px">
                	<td colspan="2">&nbsp;</td>
            	</tr>
            </table>
            <table width="80%">
                <tr height="20px">
                	<td align="left" class="Titulo3" bgcolor="#F3F3F3">Ingreso de Dotaci&oacute;n</td>
            	</tr>
                <tr>
                	<td class="TextoNegroTablas">
                    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
                    		<tr align="left">
                    			<td width="120px">Seleccione un tipo: </td>
                                <td><select name="slcTipo" style="width:200px" onchange="cargaTipo('tipo_dotacion.asp','slcTipo','tipoDotacion')">
                                        <option value="0">Seleccione...</option>
                                        <% do while not rsTipos.EOF %>
                                        <option value="<% response.Write(rsTipos("id_tipo")) %>"><% response.Write(rsTipos("tipo")) %></option>	
                                        <% rsTipos.MoveNext
                                        loop %>
                                	</select>
                                </td>
                           	</tr>
                    	</table>
                    </td>
            	</tr>
                <tr>
                    <td class="TextoNegroTablas">
                    	<div id=tipoDotacion>
                    		<table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>Favor seleccionar un Tipo</td>
                                </tr>	
                            </table>
                    	</div>
                    </td>
                </tr>
            </table>    
            <br/>
            <table width="80%">
                <tr height="20px">
                	<td align="left" class="Titulo3" bgcolor="#F3F3F3">Dotaci&oacute;n de la Sucursal</td>
            	</tr>
                <tr>
                	<td>
                    	<table id="#tableDotacion" class="tablesorter">
                            <thead> 
                                <tr align="center">
                                    <th width="30px"><b>ID</b></th>
                                    <th width="80px" align="left"><b>Tipo</b></th>
                                    <th align="left"><b>Nombre</b></th>
                                    <th width="112px"><b>Cargo</b></th>
                                    <th width="40px"><b>Anexo</b></th>
                                    <th width="65px"><b>Zona</b></th>
                                    <th><b>Zonal</b></th>
                                    <th width="100px"><b>Suc. Asig.</b></th>
                                    <th width="50px"><b>Detalle</b></th>
                                    <th width="50px"><b>Eliminar</b></th>
                                </tr>
                            </thead> 
                            <tbody> 
                                <% while not rsDotacion.Eof %>
                                    <tr align="center">
                                        <td><%=rsDotacion("id_dotacion")%></td>
                                        <td><%=rsDotacion("tipo")%></td>
                                        <td><%=rsDotacion("nombre")%></td>
                                        <td><%=rsDotacion("cargo")%></td>
                                        <td><%=rsDotacion("anexo")%></td>
                                        <td><%=rsDotacion("zona")%></td>
                                        <td><%=rsDotacion("zonal")%></td>
                                        <td><%=rsDotacion("sucursal")%></td>
                                        <td><a href="ver_dotacion.asp?dotacion=<%response.Write(rsDotacion("id_dotacion"))%>&keepThis=true&TB_iframe=true&height=360&width=450" title="Detalles" class="thickbox">[Detalles]</a></td>
                                        <td><a href="eliminar_dotacion.asp?dotacion=<%response.Write(rsDotacion("id_dotacion"))%>&keepThis=true&TB_iframe=true&height=200&width=450" title="Eliminar" class="thickbox">[Eliminar]</a></td>
                                    </tr>
                                    <% rsDotacion.MoveNext 
                                wend %>
                            </tbody>
                        </table>
                    </td>
            	</tr>
            </table>
            <br/>
            <input name="btSucursal" type="hidden" value="<% response.Write(bt_sucursal)%>"  />
            </form>
            <br/>
            <br/>
        </div>
    </div>
</body>
</html>