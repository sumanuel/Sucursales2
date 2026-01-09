<%Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""datos"": ["
ipsMontoDisp = 100
ipsCantidadDisp = 200
ipsMontoPag = 200
ipsCantPag = 300
afpMontoDisp = 700
afpCantidadDisp = 600
afpMontoPag = 100
afpCantPag = 900
varDatos = ""
varDatos =  varDatos & "{"
varDatos = varDatos &  "   ""ipsMontoDisp"": """ & ipsMontoDisp & """, "
varDatos = varDatos &  "   ""ipsCantidadDisp"": """ & ipsCantidadDisp & """, "
varDatos = varDatos &  "   ""ipsMontoPag"": """ & ipsMontoPag & """, "
varDatos = varDatos &  "   ""ipsCantPag"": """ & ipsCantPag & """, "
varDatos = varDatos &  "   ""afpMontoDisp"": """ & afpMontoDisp & """, "
varDatos = varDatos &  "   ""afpCantidadDisp"": """ & afpCantidadDisp & """, "
varDatos = varDatos &  "   ""afpMontoPag"": """ & afpMontoPag & """, "
varDatos = varDatos &  "   ""afpCantPag"": """ & afpCantPag & """ "
varDatos =  varDatos &  "}"
'varDatos = varDatos & ","
varDatos =  varDatos & "]"
varDatos =  varDatos &  "}"
response.write(varDatos)%>