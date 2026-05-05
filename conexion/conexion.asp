<!--#include file="encripta.asp"-->
<%Response.addHeader "pragma", "no-cache"
Response.CacheControl = "Private"
Response.Expires = -1
dim DB,db2
Set DB = Server.CreateObject("ADODB.Connection")
DB.ConnectionTimeout = 170

'usuario = "5A5E435A1617795E434754414057430306110F565A455251424F243E0ECER$DB2527D013FCE02B1FA"
'valorPass = "5A5E435A1617795E4347544140574303061O4DA10F565A445254464F243E2BFFAE3E610564F45FE2DA"
'key = "losheroes"
usuario = "000A1C0E1C1506605D454242414851515F574C5444495B4355414000BFCD41621F23D5E667BE"
valorPass = "000A1C0E1C1506605D454242414851515F574C5444495B4455474606A3CF71630436"
key = "soportecanales"

usuario = QuickDecrypt(usuario,key)
pass = QuickDecrypt(valorPass,key)

DB.Open "Provider=SQLNCLI10; Data Source=10.81.233.14; Initial Catalog=SCSS; User Id=usr_paneles; Password=PAn3le5_16S;"
'DB.Open "Provider=SQLNCLI10; Data Source=CLH-COPDES-BD; Initial Catalog=SCSS_PRD; User Id="&usuario&"; Password="&pass&";"

'%>
