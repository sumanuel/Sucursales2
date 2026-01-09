<!--#include file="../funciones.asp"-->
<%

perfil = trim(request("perfilMain"))
idUsuario = trim(request("idUsuarioMain"))

sql = ""
sql = sql & " exec SUC_prc_index_asistencia_cajeros_h "
sql = sql & "'"&perfil&"', "
sql = sql & " '"&idUsuario&"' "

'response.write(sql)
'response.end

set rs = db.execute(sql)

  if not rs.eof then
	  totalCajerosTitulares = rs("cajerostitulares")
	  totalCajerosReemplazos = rs("cajerosreemplazos")
	  totalCajerosAdicionales = rs("cajerosadicionales")  
	  totalAusentes2 = rs("cajerosausentes2")
	  totalPresentes = rs("cajerospresentes")
	  totalSinRegistro = rs("cajerossinregistro")
    totalCajeros = rs("totalcajeros")
    totalAusentesAdi = rs("cajerosausentesadi")
    totalAusentesTitu = rs("cajerosausentestitu")
    
    'response.write(totalCajerosTitulares)
    'response.end

  end if
  'totalCajeros = totalCajerosTitulares+totalCajerosAdicionales

Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""dataCajeros"": ["
response.write "{"
Response.Write "   ""totalCajerosTitulares"": """ & totalCajerosTitulares & """, "
Response.Write "   ""totalCajerosReemplazos"": """ & totalCajerosReemplazos & """, "
Response.Write "   ""totalCajerosAdicionales"": """ & totalCajerosAdicionales & """, "
Response.Write "   ""totalAusentes2"": """ & totalAusentes2 & """, "
Response.Write "   ""totalPresentes"": """ & totalPresentes & """, "
Response.Write "   ""totalSinRegistro"": """ & totalSinRegistro & """, "
Response.Write "   ""totalAusentesAdi"": """ & totalAusentesAdi & """, "
Response.Write "   ""totalAusentesTitu"": """ & totalAusentesTitu & """, "
Response.Write "   ""totalCajeros"": """ & totalCajeros & """ "

response.write "}]}"%>