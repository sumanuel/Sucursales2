<!--#include file="encripta.asp"-->
<%texto = trim(request("texto"))
llave = trim(request("llave"))

textoEncriptado = QuickEncrypt(texto,llave)
response.write(textoEncriptado)
%>