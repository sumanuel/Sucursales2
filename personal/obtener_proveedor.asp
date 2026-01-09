<%@ Language=VBScript %>
<%
Response.ContentType = "application/json"
Response.Charset = "utf-8"
%>
<!--#include file="../conexion/conexion.asp"-->
<%
On Error Resume Next
Dim id: id = Request.QueryString("id")
If id = "" Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""ID requerido""}"
    Response.End
End If
Dim sql: sql = "EXEC SP_SUC_obtener_proveedor @id_proveedor=" & id
Dim rs: Set rs = db.Execute(sql)
If Err.Number <> 0 Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & Replace(Err.Description, """", "'") & """}"
    Response.End
End If
If rs.EOF Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""Proveedor no encontrado""}"
    Response.End
End If
Dim v_nombre, v_tipo, v_contrato, v_oc, v_fi, v_ff
Dim v_cadmin, v_cemail, v_coper, v_cemail2, v_titulares, v_adicionales
v_nombre = rs("nombre_empresa")
v_tipo = rs("tipo_servicio")
v_contrato = rs("numero_contrato")
v_oc = rs("numero_oc")
v_cadmin = rs("contacto_administrativo")
v_cemail = rs("correo_administrativo")
v_coper = rs("contacto_operacional")
v_cemail2 = rs("correo_operacional")
v_titulares = rs("cantidad_titulares")
v_adicionales = rs("cantidad_adicionales")
If Not IsNull(rs("fecha_inicio")) Then
    v_fi = Year(rs("fecha_inicio")) & "-"
    If Month(rs("fecha_inicio")) < 10 Then v_fi = v_fi & "0"
    v_fi = v_fi & Month(rs("fecha_inicio")) & "-"
    If Day(rs("fecha_inicio")) < 10 Then v_fi = v_fi & "0"
    v_fi = v_fi & Day(rs("fecha_inicio"))
Else
    v_fi = ""
End If
If Not IsNull(rs("fecha_fin")) Then
    v_ff = Year(rs("fecha_fin")) & "-"
    If Month(rs("fecha_fin")) < 10 Then v_ff = v_ff & "0"
    v_ff = v_ff & Month(rs("fecha_fin")) & "-"
    If Day(rs("fecha_fin")) < 10 Then v_ff = v_ff & "0"
    v_ff = v_ff & Day(rs("fecha_fin"))
Else
    v_ff = ""
End If
Response.Write "{"
Response.Write """id_proveedor"":" & rs("id_proveedor") & ","
Response.Write """nombre_empresa"":""" & v_nombre & ""","
Response.Write """tipo_servicio"":""" & v_tipo & ""","
Response.Write """numero_contrato"":""" & v_contrato & ""","
Response.Write """numero_oc"":""" & v_oc & ""","
Response.Write """fecha_inicio"":""" & v_fi & ""","
Response.Write """fecha_fin"":""" & v_ff & ""","
Response.Write """contacto_administrativo"":""" & v_cadmin & ""","
Response.Write """correo_administrativo"":""" & v_cemail & ""","
Response.Write """contacto_operacional"":""" & v_coper & ""","
Response.Write """correo_operacional"":""" & v_cemail2 & ""","
Response.Write """cantidad_titulares"":""" & v_titulares & ""","
Response.Write """cantidad_adicionales"":""" & v_adicionales
Response.Write """}"
%>
