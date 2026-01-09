<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones2.asp"-->
<%
'Response.Buffer = TRUE
'Response.ContentType = "application/vnd.ms-excel"

tipoInforme = trim(request("tipoInforme"))
'response.write(tipoInforme)
'response.end
'1= Personal titular asistente
'2 = Suplente asistente
'3 = titular ausente
'4 = suplente ausente
'5 = todos no informados
'6 = Todos los titulares
'7 = todos los suplentes%>

<% if  tipoInforme = "1" or tipoInforme = "2" or tipoInforme = "3" or tipoInforme = "4" or tipoInforme = "5" then %>

<TABLE WIDTH=100% BORDER=1 CELLSPACING=1 CELLPADDING=1>
<TR>
	<TD><strong>BT_Sucursal</strong></TD>
   	<TD><strong>Nombre Sucursal</strong></TD>
    <TD><strong>R.U.N</strong></TD>
    <TD><strong>Nombre</strong></TD>
    <%if tipoInforme = "1" or tipoInforme = "2" or tipoInforme = "3" or tipoInforme = "4" or tipoInforme = "5" then%>
      <TD><strong>Asistencia</strong></TD>
      <TD><strong>Entrada</strong></TD>
      <TD><strong>Salida</strong></TD>
    <%end if%>
    <TD><strong>Cargo</strong></TD>
    <TD><strong>Tipo</strong></TD>
    <TD><strong>Empresa</strong></TD>
    <TD><strong>Fecha Registro</strong></TD>
    <TD><strong>Hora Registro</strong></TD>
    <%if tipoInforme = "1" or tipoInforme = "2" or tipoInforme = "3" or tipoInforme = "4" or tipoInforme = "5" then%>
      <TD><strong>Hora Registro Llegada</strong></TD>
      <TD><strong>Hora Registro Salida</strong></TD>
    <%end if%>
</TR>
<%if tipoInforme = "1" or tipoInforme = "3" or tipoInforme = "5" then
  sql = ""
  sql = sql & " select a.bt_sucursal, "
  sql = sql & " b.suc_nombre, "
  sql = sql & " a.rut_personal, "
  sql = sql & " a.nombre_personal, "
  sql = sql & " a.asistencia, "
  sql = sql & " a.hora_llegada, "
  sql = sql & " a.min_llegada, "
  sql = sql & " a.hora_salida, "
  sql = sql & " a.min_salida, "
  sql = sql & " a.tipo_personal, "
  sql = sql & " a.tipo, "
  sql = sql & " a.empresa, "
  sql = sql & " convert(datetime, a.fecha_reg) as fecha_reg, "
  sql = sql & " convert(datetime, a.hora_reg) as hora_reg, "
  sql = sql & " convert(datetime, a.hora_reg_llegada) as hora_reg_llegada, "
  sql = sql & " convert(datetime, a.hora_reg_salida) as hora_reg_salida "
  sql = sql & " from SUC_sucursal_asistencia_personal a, "
  sql = sql & " SUC_sucursal b "
  'sql = sql & " SUC_sucursal_personal c "
  sql = sql & " where "
  sql = sql & " (a.tipo = 'titular' or a.tipo = 'reemplazo') "
  if tipoInforme = "1" then
    sql = sql & " and a.asistencia = 'si' "
  end if
  if tipoInforme = "3" then
    sql = sql & " and a.asistencia = 'no' "
  end if
  if tipoInforme = "5" then
    sql = sql & " and a.asistencia IS NULL "
  end if
  sql = sql & " and a.id_sucursal = b.id_sucursal "
  'sql = sql & " and a.rut_personal = c.rut_personal "
  
  'Response.Write(sql)
  'Response.End()
  
  set rs = db.execute(sql)
  if not rs.eof then
    datos = rs.GetRows()
    for i=0 to ubound(datos,2)
      bt_sucursal = trim(datos(0,i))
      nombre_sucursal = server.htmlencode(trim(datos(1,i)))
      rut_personal = trim(datos(2,i))
      nombre = server.htmlencode(trim(datos(3,i)))
      asistencia = trim(datos(4,i))
      hora_llegada = trim(datos(5,i))
	    min_llegada = trim(datos(6,i))
      hora_salida = trim(datos(7,i))
	    min_salida = trim(datos(8,i))
      nombre_cargo = server.htmlencode(trim(datos(9,i)))
      tipo = server.htmlencode(trim(datos(10,i)))
      empresa = server.htmlencode(trim(datos(11,i)))
      fecha_reg = trim(datos(12,i))
      hora_reg = sacaHora(trim(datos(13,i)))
      hora_reg_llegada = sacaHora(trim(datos(14,i)))
      hora_reg_salida = sacaHora(trim(datos(15,i)))%>
    <TR>
        <TD><%=bt_sucursal%></TD>
        <TD><%=nombre_sucursal%></TD>
        <TD><%=rut_personal%></TD>
        <TD><%=nombre%></TD>
        <%if tipoInforme <> "6" then%>
          <TD><%=asistencia%></TD>
          <TD><%=hora_llegada%>:<%=min_llegada%></TD>
          <TD><%=hora_salida%>:<%=min_salida%></TD>
        <%end if%>
        <TD><%=nombre_cargo%></TD>
        <TD><%=tipo%></TD>
        <TD><%=empresa%></TD>
        <TD><%=fecha_reg%></TD>
        <TD><%=hora_reg%></TD>
        <%if tipoInforme <> "6" then%>
          <TD><%=hora_reg_llegada%></TD>
          <TD><%=hora_reg_salida%></TD>
        <%end if%>
    </TR>
  <%next
  end if
end if
if tipoInforme = "2" or tipoInforme = "4" or tipoInforme = "5" then
  sql = ""
  sql = sql & " select a.bt_sucursal, "
  sql = sql & " b.suc_nombre, "
  sql = sql & " a.rut_personal, "
  sql = sql & " a.nombre_personal, "
  sql = sql & " a.asistencia, "
  sql = sql & " a.hora_llegada, "
  sql = sql & " a.min_llegada, "
  sql = sql & " a.hora_salida, "
  sql = sql & " a.min_salida, "
  sql = sql & " a.tipo_personal, "
  sql = sql & " a.tipo, "
  sql = sql & " a.empresa, "
  sql = sql & " convert(datetime, a.fecha_reg) as fecha_reg, "
  sql = sql & " convert(datetime, a.hora_reg) as hora_reg, "
  sql = sql & " convert(datetime, a.hora_reg_llegada) as hora_reg_llegada, "
  sql = sql & " convert(datetime, a.hora_reg_salida) as hora_reg_salida "
  sql = sql & " from SUC_sucursal_asistencia_personal a, "
  sql = sql & " SUC_sucursal b "
  'sql = sql & " SUC_sucursal_personal c "
  sql = sql & " where "
  sql = sql & " a.tipo <> 'titular' "
  if tipoInforme = "2" then
    sql = sql & " and a.asistencia = 'si' "
  end if
  if tipoInforme = "4" then
    sql = sql & " and a.asistencia = 'no' "
  end if
  if tipoInforme = "5" then
    sql = sql & " and a.asistencia IS NULL "
  end if
  sql = sql & " and a.id_sucursal = b.id_sucursal "
  'sql = sql & " and a.rut_personal = c.rut_personal "
  
  'Response.Write(sql)
  'Response.End()
  
  set rs = db.execute(sql)
  if not rs.eof then
    datos = rs.GetRows()
    for i=0 to ubound(datos,2)
      bt_sucursal = trim(datos(0,i))
      nombre_sucursal = server.htmlencode(trim(datos(1,i)))
      rut_personal = trim(datos(2,i))
      nombre = server.htmlencode(trim(datos(3,i)))
      asistencia = trim(datos(4,i))
      hora_llegada = trim(datos(5,i))
	    min_llegada = trim(datos(6,i))
      hora_salida = trim(datos(7,i))
	    min_salida = trim(datos(8,i))
      nombre_cargo = server.htmlencode(trim(datos(9,i)))
      tipo = server.htmlencode(trim(datos(10,i)))
      empresa = server.htmlencode(trim(datos(11,i)))
      fecha_reg = trim(datos(12,i))
      hora_reg = sacaHora(trim(datos(13,i)))
      hora_reg_llegada = sacaHora(trim(datos(14,i)))
      hora_reg_salida = sacaHora(trim(datos(15,i)))%>
    <TR>
        <TD><%=bt_sucursal%></TD>
        <TD><%=nombre_sucursal%></TD>
        <TD><%=rut_personal%></TD>
        <TD><%=nombre%></TD>
        <%if tipoInforme <> "7" then%>
          <TD><%=asistencia%></TD>
          <TD><%=hora_llegada%>:<%=min_llegada%></TD>
          <TD><%=hora_salida%>:<%=min_salida%></TD>
        <%end if%>
        <TD><%=nombre_cargo%></TD>
        <TD><%=tipo%></TD>
        <TD><%=empresa%></TD>
        <TD><%=fecha_reg%></TD>
        <TD><%=hora_reg%></TD>
        <%if tipoInforme <> "7" then%>
          <TD><%=hora_reg_llegada%></TD>
          <TD><%=hora_reg_salida%></TD>
        <%end if%>
    </TR>
    <%next
  end if
end if
' Clean up
'set rs = Nothing
'rs.Close%>
</TABLE>

<% end if %>

<% if  tipoInforme = "6" then 'listado de titulares' 
    sql = ""    
    sql = sql & "select "
    sql = sql & "a.bt_sucursal, a.id_cargo, b.suc_nombre, a.nombre_cargo, "
    sql = sql & "a.rut_personal, a.nombre_personal, a.apep_personal, "
    sql = sql & "a.apem_personal, a.fecha_ingreso, a.empresa "
    sql = sql & "from SUC_sucursal_personal a "
    sql = sql & "inner join SUC_sucursal b on a.bt_sucursal = b.cod_bantotal "

    set rs = db.execute(sql)
    if not rs.eof then %>

    <table border=1>
      <thead>
        <th>COD BT</th>
        <th>ID CARGO</th>
        <th>SUCURSAL</th>
        <th>CARGO</th>
        <th>RUT TITULAR</th>
        <th>NOMBRE TITULAR</th>
        <th>APELLIDO PATERNO</th>
        <th>APELLIDO MATERNO</th>
        <th>FECHA INGRESO</th>
        <th>EMPRESA</th>
      </thead>
      <tbody>
          <%  do while not rs.eof 
              bt_sucursal = server.htmlencode(trim(rs("bt_sucursal")))
              id_cargo = server.htmlencode(trim(rs("id_cargo")))
              suc_nombre = server.htmlencode(trim(rs("suc_nombre")))
              nombre_cargo = server.htmlencode(trim(rs("nombre_cargo")))
              rut_personal = server.htmlencode(trim(rs("rut_personal")))
              nombre_personal = server.htmlencode(trim(rs("nombre_personal")))
              apep_personal = server.htmlencode(trim(rs("apep_personal")))
              apem_personal = server.htmlencode(trim(rs("apem_personal")))
              fecha_ingreso = server.htmlencode(trim(rs("fecha_ingreso")))
              empresa = server.htmlencode(trim(rs("empresa")))
          %>
              <tr>
                <td><%=bt_sucursal%></td>
                <td><%=id_cargo%></td>
                <td><%=suc_nombre%></td>
                <td><%=nombre_cargo%></td>
                <td><%=rut_personal%></td>
                <td><%=nombre_personal%></td>
                <td><%=apep_personal%></td>
                <td><%=apem_personal%></td>
                <td><%=fecha_ingreso%></td>
                <td><%=empresa%></td>
              </tr>  
          <% rs.MoveNext
             loop %>
      </tbody>
    </table>

    <% end if
  end if
%>
  
<% if  tipoInforme = "7" then 'listado de reemplazos' 
    sql = ""    
    sql = sql & "select "
    sql = sql & "bt_sucursal, id_cargo, nombre_sucursal, nombre_cargo, rut_titular, "
    sql = sql & "rut_reemp, nombre_reemp, desde, hasta, "
    sql = sql & "convert(varchar(12), cast(hora_ingreso as time), 8) as hora_ingreso, "
    sql = sql & "convert(varchar(12), cast(hora_salida as time), 8) as hora_salida, empresa, motivo "
    sql = sql & "from SUC_sucursal_reemplazos_plan "
    sql = sql & "where cast(hasta as date) >= cast(getdate() as DATE) "

    set rs = db.execute(sql)
    if not rs.eof then %>
    <table border=1>
      <thead>
          <th>COD BT</th>
          <th>ID CARGO</th>
          <th>NOMBRE SUCURSAL</th>
          <th>NOMBRE CARGO</th>
          <th>RUT TITULAR</th>
          <th>RUT REEMPLAZO</th>
          <th>NOMBRE REEMPLAZO</th>
          <th>DESDE</th>
          <th>HASTA</th>
          <th>HORA INGRESO</th>
          <th>HORA SALIDA</th>
          <th>EMPRESA</th>
          <th>MOTIVO</th>
      </thead>
      <tbody>

    <%  do while not rs.eof  
          bt_sucursal = server.htmlencode(trim(rs("bt_sucursal")))
          id_cargo = server.htmlencode(trim(rs("id_cargo")))
          nombre_sucursal = server.htmlencode(trim(rs("nombre_sucursal")))
          nombre_cargo = server.htmlencode(trim(rs("nombre_cargo")))
          rut_titular = server.htmlencode(trim(rs("rut_titular")))
          rut_reemp = server.htmlencode(trim(rs("rut_reemp")))
          nombre_reemp = server.htmlencode(trim(rs("nombre_reemp")))
          desde = server.htmlencode(trim(rs("desde")))
          hasta = server.htmlencode(trim(rs("hasta")))
          hora_ingreso = server.htmlencode(trim(rs("hora_ingreso")))
          hora_salida = server.htmlencode(trim(rs("hora_salida")))
          empresa = server.htmlencode(trim(rs("empresa")))
          motivo = server.htmlencode(trim(rs("motivo")))
    %>
          <tr>
              <td><%=bt_sucursal%></td>
              <td><%=id_cargo%></td>
              <td><%=nombre_sucursal%></td>
              <td><%=nombre_cargo%></td>
              <td><%=rut_titular%></td>
              <td><%=rut_reemp%></td>
              <td><%=nombre_reemp%></td>
              <td><%=desde%></td>
              <td><%=hasta%></td>
              <td><%=hora_ingreso%></td>
              <td><%=hora_salida%></td>
              <td><%=empresa%></td>
              <td><%=motivo%></td>
          </tr> 
    <% rs.MoveNext
       loop %>
      </tbody>
    </table>   
<%  end if 
  end if %>







