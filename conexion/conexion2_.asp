<%Response.addHeader "pragma", "no-cache"
Response.CacheControl = "Private"
Response.Expires = -1
Set DB = Server.CreateObject("ADODB.Connection")
DB.ConnectionTimeout = 170
'DB.CommandTimeout=160
DB.Open "Provider=SQLNCLI10; Data Source=lh-controlop-bd; Initial Catalog=scss; User Id=usr_soporte; Password=soporte;"
'DB.Open "Provider=SQLNCLI10; Data Source=lh-contoper-bd; Initial Catalog=scss; User Id=usr_soporte; Password=soporte;"
%>
