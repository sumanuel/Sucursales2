<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
'Change HTML header to specify Excel's MIME content type
'Response.Buffer = TRUE
'Response.ContentType = "application/vnd.ms-excel"

%>
<HTML>
<BODY>
<%
Set conex = Server.CreateObject ("ADODB.Connection")
set rs = server.createObject("ADODB.Recordset")
conex.Open "driver={SQL Server};server=lh-contoper-bd; database=sucursales; uid=usr_soporte; pwd=soporte"
qry="select A.rut_personal,A.nombre_personal,A.apep_personal,A.apem_personal, A.fecha_ingreso, A.bt_sucursal, B.nombre_sucursal, C.nombre_cargo from personal A, sucursales B, cargos C where A.bt_sucursal=B.bt_sucursal and A.id_cargo=C.id_cargo order by B.nombre_sucursal"
conex.execute(qry)
rs.open qry, conex
%>

<!-- Our table which will be translated into an Excel spreadsheet -->
<TABLE WIDTH=100% BORDER=1 CELLSPACING=1 CELLPADDING=1>
<TR>
	<TD><strong>R.U.N</strong></TD>
   	<TD><strong>Nombre</strong></TD>
    <TD><strong>Apellido Paterno</strong></TD>
    <TD><strong>Apellido Materno</strong></TD>
    <TD><strong>Fecha Ultima Actualizacion</strong></TD>
    <TD><strong>Codigo Bantotal Sucursal</strong></TD>
    <TD><strong>Nombre de la Sucursal</strong></TD>
    <TD><strong>Cargo</strong></TD>
</TR>
<!-- server-side loop adding Table entries -->
<% do while not rs.EOF %>
<TR>
   	<TD><%=rs("rut_personal")%></TD>
   	<TD><%=rs("nombre_personal")%></TD>
    <TD><%=rs("apep_personal")%></TD>
    <TD><%=rs("apem_personal")%></TD>
    <TD><%=rs("fecha_ingreso")%></TD>
    <TD><%=rs("bt_sucursal")%></TD>
    <TD><%=rs("nombre_sucursal")%></TD>
    <TD><%=rs("nombre_cargo")%></TD>
</TR>
<% rs.MoveNext
   loop
   ' Clean up
   rs.Close
   set rs = Nothing
   conex.Close
   set conex = Nothing
%>
</TABLE>
</BODY>
</HTML>
