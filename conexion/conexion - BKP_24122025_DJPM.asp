<!--#include file="encripta.asp"-->
<%Response.addHeader "pragma", "no-cache"
Response.CacheControl = "Private"
Response.Expires = -1
dim DB,db2
Set DB = Server.CreateObject("ADODB.Connection")
DB.ConnectionTimeout = 170

''LOCAL
'usuario = "000A1C0E1C1506605D404242414851515F574C5742495A465541430FB0A46D6B193AD8FE7E"
'valorPass = "000A1C0E1C1506605D404242414851515F574C5742495A465547470FAAB7776B1E3E"

'lh-contoper-bd
usuario = "000A1C0E1C1506605D454242414851515F574C5444495B4355414000BFCD41621F23D5E667BE"
valorPass = "000A1C0E1C1506605D454242414851515F574C5444495B4455474606A3CF71630436"

key = "soportecanales" 

usuario = QuickDecrypt(usuario,key)
pass = QuickDecrypt(valorPass,key)



'response.write(pass)
'response.end

DB.Open "Provider=SQLNCLI10; Data Source=10.81.233.14; Initial Catalog=SCSS; User Id=usr_paneles; Password=PAn3le5_16S;"
'DB.Open "Provider=SQLNCLI11; Data Source=DESKTOP-2H8RS1B; Initial Catalog=SCSS; User Id="&usuario&"; Password="&pass&";"

%>