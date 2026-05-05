<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json; charset=utf-8"
Response.CodePage = 65001
Response.CharSet = "utf-8"

' Parámetros de paginación
Dim id, orden
id = Request("id")
orden = Request("orden")

' Consulta con paginación
Dim sql, rs

sql = "EXEC SP_SUC_CAP_ORDEN " & id & ", '"& orden &"'" 

Set rs = DB.execute(sql)

Dim json, first
json = "{"
json = json & """status"": """ & rs("RESULTADO") & """"
json = json & "}"

rs.Close
Set rs = Nothing
DB.Close
Set DB = Nothing

Response.Write json

%>
