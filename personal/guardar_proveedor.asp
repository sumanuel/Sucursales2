<%@ Language=VBScript %>
<%
Response.ContentType = "application/json"
Response.Charset = "utf-8"
%>
<!--#include file="../conexion/conexion.asp"-->
<%
On Error Resume Next
Dim id_proveedor, nombre_empresa, tipo_servicio, numero_contrato, numero_oc
Dim fecha_inicio, fecha_fin, contacto_admin, correo_admin
Dim contacto_oper, correo_oper, cant_titulares, cant_adicionales, usuario
id_proveedor = Request.Form("id_proveedor")
nombre_empresa = Request.Form("nombre_empresa")
tipo_servicio = Request.Form("tipo_servicio")
numero_contrato = Request.Form("numero_contrato")
numero_oc = Request.Form("numero_oc")
fecha_inicio = Request.Form("fecha_inicio")
fecha_fin = Request.Form("fecha_fin")
contacto_admin = Request.Form("contacto_administrativo")
correo_admin = Request.Form("correo_administrativo")
contacto_oper = Request.Form("contacto_operacional")
correo_oper = Request.Form("correo_operacional")
cant_titulares = Request.Form("cantidad_titulares")
cant_adicionales = Request.Form("cantidad_adicionales")
Dim logon_user: logon_user = Request.ServerVariables("LOGON_USER")
If InStr(logon_user, "\") > 0 Then
    usuario = Mid(logon_user, InStr(logon_user, "\") + 1)
Else
    usuario = logon_user
End If
If nombre_empresa = "" Or tipo_servicio = "" Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""Nombre de empresa y tipo de servicio son requeridos""}"
    Response.End
End If
Dim cmd: Set cmd = Server.CreateObject("ADODB.Command")
cmd.ActiveConnection = db
cmd.CommandType = 4
cmd.CommandText = "SP_SUC_insertar_proveedor"
cmd.Parameters.Append cmd.CreateParameter("@id_proveedor", 3, 1, , CInt(id_proveedor))
cmd.Parameters.Append cmd.CreateParameter("@nombre_empresa", 200, 1, 200, nombre_empresa)
cmd.Parameters.Append cmd.CreateParameter("@tipo_servicio", 200, 1, 100, tipo_servicio)
If numero_contrato = "" Then
    cmd.Parameters.Append cmd.CreateParameter("@numero_contrato", 200, 1, 50, Null)
Else
    cmd.Parameters.Append cmd.CreateParameter("@numero_contrato", 200, 1, 50, numero_contrato)
End If
If numero_oc = "" Then
    cmd.Parameters.Append cmd.CreateParameter("@numero_oc", 200, 1, 50, Null)
Else
    cmd.Parameters.Append cmd.CreateParameter("@numero_oc", 200, 1, 50, numero_oc)
End If
If fecha_inicio = "" Then
    cmd.Parameters.Append cmd.CreateParameter("@fecha_inicio", 7, 1, , Null)
Else
    cmd.Parameters.Append cmd.CreateParameter("@fecha_inicio", 7, 1, , CDate(fecha_inicio))
End If
If fecha_fin = "" Then
    cmd.Parameters.Append cmd.CreateParameter("@fecha_fin", 7, 1, , Null)
Else
    cmd.Parameters.Append cmd.CreateParameter("@fecha_fin", 7, 1, , CDate(fecha_fin))
End If
If contacto_admin = "" Then
    cmd.Parameters.Append cmd.CreateParameter("@contacto_administrativo", 200, 1, 100, Null)
Else
    cmd.Parameters.Append cmd.CreateParameter("@contacto_administrativo", 200, 1, 100, contacto_admin)
End If
If correo_admin = "" Then
    cmd.Parameters.Append cmd.CreateParameter("@correo_administrativo", 200, 1, 100, Null)
Else
    cmd.Parameters.Append cmd.CreateParameter("@correo_administrativo", 200, 1, 100, correo_admin)
End If
If contacto_oper = "" Then
    cmd.Parameters.Append cmd.CreateParameter("@contacto_operacional", 200, 1, 100, Null)
Else
    cmd.Parameters.Append cmd.CreateParameter("@contacto_operacional", 200, 1, 100, contacto_oper)
End If
If correo_oper = "" Then
    cmd.Parameters.Append cmd.CreateParameter("@correo_operacional", 200, 1, 100, Null)
Else
    cmd.Parameters.Append cmd.CreateParameter("@correo_operacional", 200, 1, 100, correo_oper)
End If
If cant_titulares = "" Then
    cmd.Parameters.Append cmd.CreateParameter("@cantidad_titulares", 3, 1, , 0)
Else
    cmd.Parameters.Append cmd.CreateParameter("@cantidad_titulares", 3, 1, , CInt(cant_titulares))
End If
If cant_adicionales = "" Then
    cmd.Parameters.Append cmd.CreateParameter("@cantidad_adicionales", 3, 1, , 0)
Else
    cmd.Parameters.Append cmd.CreateParameter("@cantidad_adicionales", 3, 1, , CInt(cant_adicionales))
End If
cmd.Parameters.Append cmd.CreateParameter("@usuario_registro", 200, 1, 50, usuario)
Dim rs: Set rs = cmd.Execute
If Err.Number <> 0 Then
    Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & Replace(Err.Description, """", "'") & """}"
Else
    If Not rs.EOF Then
        Dim resultado_sp: resultado_sp = rs("resultado")
        If resultado_sp = "OK" Then
            Dim id_retornado: id_retornado = rs("id_proveedor")
            If IsNull(id_retornado) Or id_retornado = "" Then
                id_retornado = 0
            End If
            Response.Write "{""resultado"":""OK"",""id"":" & id_retornado & "}"
        Else
            Dim msg_error: msg_error = rs("mensaje")
            Response.Write "{""resultado"":""ERROR"",""mensaje"":""" & Replace(msg_error, """", "'") & """}"
        End If
    Else
        Response.Write "{""resultado"":""OK"",""id"":0}"
    End If
End If
%>