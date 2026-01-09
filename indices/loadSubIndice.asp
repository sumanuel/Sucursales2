<!--#include file="../funciones.asp"-->
<%idIndice = trim(request("idIndice"))
sql = ""
sql = sql & " select idIndice,nombreIndice, "
sql = sql & " tituloIndice "
sql = sql & " from suc_indices "
sql = sql & " where padre = '"&idIndice&"' "
sql = sql & " and estado = 1 "
sql = sql & " order by orden desc"
set rs = db.execute(sql)


'########## mando datos a array
datos = rs.GetRows()
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datos"": ["
count = 0  

For i = 0 to ubound(datos, 2)
	Dim correlativo, idIndice, nombreIndice, tituloIndice      
	idIndice = trim(datos(0,i))
	nombreIndice = trim(datos(1,i))
	tituloIndice = trim(datos(2,i))
  	count = count + 1
  	If count > 1 Then
    	Response.Write ", "
  	End If
	Response.Write "{ "      
	Response.Write "   ""idIndice"": """ & idIndice & """, "
	Response.Write "   ""nombreIndice"": """ & nombreIndice & """, "
	Response.Write "   ""tituloIndice"": """ & tituloIndice & """ "
	Response.Write "}"
  
next
Response.Write "         ]"
Response.Write "}"%>