<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
'Change HTML header to specify Excel's MIME content type
Response.Buffer = TRUE
Response.ContentType = "application/vnd.ms-excel"
%>
<HTML>
<BODY>
<%
Set conex = Server.CreateObject ("ADODB.Connection")
conex.Open "driver={SQL Server};server=lh-contoper-bd; database=sucursales; uid=usr_soporte; pwd=soporte"

set rsReemplazos = server.createObject("ADODB.Recordset")
reemplazos="select A.bt_sucursal,C.nombre_sucursal,B.rut_titular,E.nombre_personal+' '+E.apep_personal+' '+E.apem_personal as nombre_personal,A.rut_personal as rut_reemp,B.nombre_reemp,B.desde,B.hasta,B.hora_ingreso,B.hora_salida,A.asistencia,D.nombre_cargo,A.tipo,B.empresa,A.fecha_reg,A.hora_reg from asistencia_personal A, reemplazos B, sucursales C, cargos D, personal E where B.rut_reemp=A.rut_personal and B.bt_sucursal=C.bt_sucursal and B.id_cargo=D.id_cargo and B.rut_titular=E.rut_personal and A.asistencia='no' and A.fecha_reg=cast(GETDATE() as DATE)"
conex.execute(reemplazos)
rsReemplazos.open reemplazos, conex
%>

<!-- Our table which will be translated into an Excel spreadsheet -->
<TABLE WIDTH=100% BORDER=1 CELLSPACING=1 CELLPADDING=1>
<TR>
	<TD><strong>BT_Sucursal</strong></TD>
   	<TD><strong>Nombre Sucursal</strong></TD>
    <TD><strong>R.U.N Titular</strong></TD>
    <TD><strong>Nombre Titular</strong></TD>
    <TD><strong>R.U.N Reemplazo</strong></TD>
    <TD><strong>Nombre Reemplazo</strong></TD>
    <TD><strong>Desde</strong></TD>
    <TD><strong>Hasta</strong></TD>
    <TD><strong>Entrada</strong></TD>
    <TD><strong>Salida</strong></TD>
    <TD><strong>Asistencia</strong></TD>
    <TD><strong>Atraso</strong></TD>
    <TD><strong>Cargo</strong></TD>
    <TD><strong>Tipo</strong></TD>
    <TD><strong>Empresa</strong></TD>
    <TD><strong>Fecha Registro</strong></TD>
    <TD><strong>Hora Registro</strong></TD>
</TR>
<!-- server-side loop adding Table entries -->
<% do while not rsReemplazos.EOF %>
<TR>
   	<TD><%=rsReemplazos("bt_sucursal")%></TD>
   	<TD><%=rsReemplazos("nombre_sucursal")%></TD>
    <TD><%=rsReemplazos("rut_titular")%></TD>
    <TD><%=rsReemplazos("nombre_personal")%></TD>
    <TD><%=rsReemplazos("rut_reemp")%></TD>
    <TD><%=rsReemplazos("nombre_reemp")%></TD>
    <TD><%=rsReemplazos("desde")%></TD>
    <TD><%=rsReemplazos("hasta")%></TD>
    <TD><%=rsReemplazos("hora_ingreso")%></TD>
    <TD><%=rsReemplazos("hora_salida")%></TD>
    <TD><%=rsReemplazos("asistencia")%></TD>
    <TD><% if datediff("n",Cdate(Mid(rsReemplazos("hora_ingreso"),1,8)),Cdate("00:00:00 AM"))=0 then
			response.Write(datediff("n",Cdate("8:45:00"),time()))	
		else
			response.Write(datediff("n",Cdate(Mid(rsReemplazos("hora_ingreso"),1,8)),time()))
		end if
	%></TD>
    <TD><%=rsReemplazos("nombre_cargo")%></TD>
    <TD><%=rsReemplazos("tipo")%></TD>
    <TD><%=rsReemplazos("empresa")%></TD>
    <TD><%=rsReemplazos("fecha_reg")%></TD>
    <TD><%=rsReemplazos("hora_reg")%></TD>
</TR>
<% rsReemplazos.MoveNext
	loop   
   ' Clean up
   rsReemplazos.Close
   set rsReemplazos = Nothing
   conex.Close
   set conex = Nothing
%>
</TABLE>
</BODY>
</HTML>
