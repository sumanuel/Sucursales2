<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones2.asp"-->
<%
'Change HTML header to specify Excel's MIME content type
Response.Buffer = TRUE
Response.ContentType = "application/vnd.ms-excel"

%>
<HTML>
<BODY>
<%
'Set conex = Server.CreateObject ("ADODB.Connection")
'conex.Open "driver={SQL Server};server=lh-contoper-bd; database=sucursales; uid=usr_soporte; pwd=soporte"

'set rsPersonal = server.createObject("ADODB.Recordset")
'personal="select A.bt_sucursal,C.nombre_sucursal,A.rut_personal,B.nombre_personal+' '+B.apep_personal+' '+B.apem_personal as nombre,A.asistencia,A.hora_llegada,A.hora_salida,D.nombre_cargo,A.tipo,B.empresa,A.fecha_reg,A.hora_reg,A.hora_reg_llegada,A.hora_reg_salida from asistencia_personal A, personal B, sucursales C, cargos D where A.rut_personal=B.rut_personal and A.bt_sucursal=C.bt_sucursal and B.id_cargo=D.id_cargo and A.fecha_reg=cast(GETDATE() as DATE)"
'conex.execute(personal)
'rsPersonal.open personal, conex

'set rsReemplazos = server.createObject("ADODB.Recordset")
'reemplazos="select A.bt_sucursal,C.nombre_sucursal,A.rut_personal,B.nombre_reemp as nombre,A.asistencia,A.hora_llegada,A.hora_salida,D.nombre_cargo,A.tipo,B.empresa,A.fecha_reg,A.hora_reg,A.hora_reg_llegada,A.hora_reg_salida from asistencia_personal A, reemplazos B, sucursales C, cargos D where A.rut_personal=B.rut_reemp and A.bt_sucursal=C.bt_sucursal and B.id_cargo=D.id_cargo and A.fecha_reg=cast(GETDATE() as DATE)" 
'conex.execute(reemplazos)
'rsReemplazos.open reemplazos, conex
%>

<!-- Our table which will be translated into an Excel spreadsheet -->
<TABLE WIDTH=100% BORDER=1 CELLSPACING=1 CELLPADDING=1>
<TR>
	<TD><strong>BT_Sucursal</strong></TD>
   	<TD><strong>Nombre Sucursal</strong></TD>
    <TD><strong>R.U.N</strong></TD>
    <TD><strong>Nombre</strong></TD>
    <TD><strong>Asistencia</strong></TD>
    <TD><strong>Entrada</strong></TD>
    <TD><strong>Salida</strong></TD>
    <TD><strong>Cargo</strong></TD>
    <TD><strong>Tipo</strong></TD>
    <TD><strong>Empresa</strong></TD>
    <TD><strong>Fecha Registro</strong></TD>
    <TD><strong>Hora Registro</strong></TD>
    <TD><strong>Hora Registro Llegada</strong></TD>
    <TD><strong>Hora Registro Salida</strong></TD>
</TR>
<%sql = ""
sql = sql & " select a.bt_sucursal, "
sql = sql & " b.suc_nombre, "
sql = sql & " a.rut_personal, "
sql = sql & " a.nombre_personal, "
sql = sql & " a.tipo_personal, "
sql = sql & " a.tipo, "
sql = sql & " a.asistencia, "
sql = sql & " a.hora_llegada, "
sql = sql & " a.hora_salida, "
sql = sql & " convert(datetime, a.hora_reg_llegada) as hora_reg_llegada, "
sql = sql & " convert(datetime, a.hora_reg_salida) as hora_reg_salida, "
sql = sql & " c.empresa, "
sql = sql & " convert(datetime, a.fecha_reg) as fecha_reg, "
sql = sql & " convert(datetime, a.hora_reg) as hora_reg "
sql = sql & " from SUC_sucursal_asistencia_personal a, "
sql = sql & " SUC_sucursal b, "
sql = sql & " SUC_sucursal_personal c "
sql = sql & " where "
sql = sql & " a.tipo = 'titular' "
sql = sql & " and a.asistencia = 'si' "
sql = sql & " and a.id_sucursal = b.id_sucursal "
sql = sql & " and a.rut_personal = c.rut_personal "
set rs = db.execute(sql)
if not rs.eof then
  datos = rs.GetRows()
end if
for i=0 to ubound(datos,2)
  bt_sucursal = trim(datos(0,i))
  nombre_sucursal = server.htmlencode(trim(datos(1,i)))
  rut_personal = trim(datos(2,i))
  nombre = server.htmlencode(trim(datos(3,i)))
  nombre_cargo = server.htmlencode(trim(datos(4,i)))
  tipo = server.htmlencode(trim(datos(5,i)))
  asistencia = trim(datos(6,i))
  hora_llegada = sacaHora(trim(datos(7,i)))
  hora_salida = sacaHora(trim(datos(8,i)))
  hora_reg_llegada = sacaHora(trim(datos(9,i)))
  hora_reg_salida = sacaHora(trim(datos(10,i)))
  empresa = server.htmlencode(trim(datos(11,i)))
  fecha_reg = trim(datos(12,i))
  hora_reg = sacaHora(trim(datos(13,i)))%>
<TR>
    <TD><%=bt_sucursal%></TD>
    <TD><%=nombre_sucursal%></TD>
    <TD><%=rut_personal%></TD>
    <TD><%=nombre%></TD>
    <TD><%=nombre_cargo%></TD>
    <TD><%=tipo%></TD>
    <TD><%=asistencia%></TD>
    <TD><%=hora_llegada%></TD>
    <TD><%=hora_salida%></TD>
    <TD><%=hora_reg_llegada%></TD>
    <TD><%=hora_reg_salida%></TD>
    <TD><%=empresa%></TD>
    <TD><%=fecha_reg%></TD>
    <TD><%=hora_reg%></TD>
</TR>
<%next
sql = ""
sql = sql & " select a.bt_sucursal, "
sql = sql & " b.suc_nombre, "
sql = sql & " a.rut_personal, "
sql = sql & " a.nombre_personal, "
sql = sql & " a.tipo_personal, "
sql = sql & " a.tipo, "
sql = sql & " a.asistencia, "
sql = sql & " a.hora_llegada, "
sql = sql & " a.hora_salida, "
sql = sql & " convert(datetime, a.hora_reg_llegada) as hora_reg_llegada, "
sql = sql & " convert(datetime, a.hora_reg_salida) as hora_reg_salida, "
sql = sql & " c.empresa, "
sql = sql & " convert(datetime, a.fecha_reg) as fecha_reg, "
sql = sql & " convert(datetime, a.hora_reg) as hora_reg "
sql = sql & " from SUC_sucursal_asistencia_personal a, "
sql = sql & " SUC_sucursal b, "
sql = sql & " SUC_sucursal_personal c "
sql = sql & " where "
sql = sql & " a.tipo <> 'titular' "
sql = sql & " and a.asistencia = 'si' "
sql = sql & " and a.id_sucursal = b.id_sucursal "
sql = sql & " and a.rut_personal = c.rut_personal "
set rs = db.execute(sql)
if not rs.eof then
  datos = rs.GetRows()
end if
for i=0 to ubound(datos,2)
  bt_sucursal = trim(datos(0,i))
  nombre_sucursal = server.htmlencode(trim(datos(1,i)))
  rut_personal = trim(datos(2,i))
  nombre = server.htmlencode(trim(datos(3,i)))
  nombre_cargo = server.htmlencode(trim(datos(4,i)))
  tipo = server.htmlencode(trim(datos(5,i)))
  asistencia = trim(datos(6,i))
  hora_llegada = sacaHora(trim(datos(7,i)))
  hora_salida = sacaHora(trim(datos(8,i)))
  hora_reg_llegada = sacaHora(trim(datos(9,i)))
  hora_reg_salida = sacaHora(trim(datos(10,i)))
  empresa = server.htmlencode(trim(datos(11,i)))
  fecha_reg = trim(datos(12,i))
  hora_reg = sacaHora(trim(datos(13,i)))%>
<TR>
    <TD><%=bt_sucursal%></TD>
    <TD><%=nombre_sucursal%></TD>
    <TD><%=rut_personal%></TD>
    <TD><%=nombre%></TD>
    <TD><%=nombre_cargo%></TD>
    <TD><%=tipo%></TD>
    <TD><%=asistencia%></TD>
    <TD><%=hora_llegada%></TD>
    <TD><%=hora_salida%></TD>
    <TD><%=hora_reg_llegada%></TD>
    <TD><%=hora_reg_salida%></TD>
    <TD><%=empresa%></TD>
    <TD><%=fecha_reg%></TD>
    <TD><%=hora_reg%></TD>
</TR>
<%next
' Clean up
rsReemplazos.Close
set rs = Nothing
rs.Close%>
</TABLE>
</BODY>
</HTML>
