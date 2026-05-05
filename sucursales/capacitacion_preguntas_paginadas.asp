<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<%
Response.ContentType = "application/json; charset=utf-8"
Response.CodePage = 65001
Response.CharSet = "utf-8"

' Parámetros de paginación
Dim page, pageSize, offset, totalRegistros, preguntas_activas
page = Request("page")
If page = "" Or Not IsNumeric(page) Then page = 1
page = CInt(page)

pageSize = Request("page_size")
If pageSize = "" Or Not IsNumeric(pageSize) Then pageSize = 15
pageSize = CInt(pageSize)

offset = (page - 1) * pageSize

if Request("preguntas_activas")="true" Then
    preguntas_activas=1
    else
        preguntas_activas=0
end if

' Consulta con paginación
Dim sql, rs, MIN_ORD, MAX_ORD

sql = "EXEC SP_SUC_CAP_PREGUNTAS " & offset & " , " & pageSize & " , " & preguntas_activas 

'response.write sql
'response.end
Set rs = DB.execute(sql)
totalRegistros = rs("TOTALREGISTROS")
MIN_ORD = rs("MIN_ORD")
MAX_ORD = rs("MAX_ORD")

Set rs = rs.NextRecordset

' Construir JSON
Dim json, first
json = "{"
json = json & """page"":" & page & ","
json = json & """MIN_ORD"":" & MIN_ORD & ","
json = json & """MAX_ORD"":" & MAX_ORD & ","
json = json & """pageSize"":" & pageSize & ","
json = json & """totalRegistros"":" & totalRegistros & ","
json = json & """totalPaginas"":" & Ceiling(totalRegistros / pageSize) & ","
json = json & """preguntas"":["

first = True
Do While Not rs.EOF
    If Not first Then json = json & ","
    first = False

    json = json & "{"
    json = json & """PRE_ID_PRE"":" & rs("PRE_ID_PRE") & ","
    json = json & """PRE_TIT"":""" & EscapeJSON(nvl(rs("PRE_TIT"), "")) & ""","
    json = json & """PRE_PRE"":""" & EscapeJSON(nvl(rs("PRE_PRE"), "")) & ""","
    json = json & """PRE_EST"":" & rs("PRE_EST") & ","
    json = json & """PRE_USR"":""" & EscapeJSON(nvl(rs("PRE_USR"), "")) & ""","
    json = json & """PRE_ORD"":" & nvl(rs("PRE_ORD"), 0) & ","
    json = json & """PRE_FCH"":""" & nvl(rs("PRE_FCH"), "") & """"
    json = json & "}"

    rs.MoveNext
Loop

json = json & "]"
json = json & "}"

rs.Close
Set rs = Nothing
DB.Close
Set DB = Nothing

Response.Write json

' Función auxiliar para valores nulos
Function nvl(valor, defecto)
    If IsNull(valor) Or valor = "" Then
        nvl = defecto
    Else
        nvl = valor
    End If
End Function

' Función para escapar JSON
Function EscapeJSON(str)
    If IsNull(str) Then
        EscapeJSON = ""
        Exit Function
    End If
    Dim result
    result = Replace(str, "\", "\\")
    result = Replace(result, """", "\""")
    result = Replace(result, vbCrLf, "\n")
    result = Replace(result, vbCr, "\n")
    result = Replace(result, vbLf, "\n")
    result = Replace(result, vbTab, "\t")
    EscapeJSON = result
End Function

' Función techo para calcular páginas
Function Ceiling(num)
    Ceiling = Int(num)
    If num > Int(num) Then
        Ceiling = Ceiling + 1
    End If
End Function
%>
