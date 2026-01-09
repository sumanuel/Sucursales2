<%@ Language=VBScript %>

<%
Response.Write "UNMAPPED_REMOTE_USER: " & Request.ServerVariables("UNMAPPED_REMOTE_USER") & "<br>"
Response.Write "REMOTE_USER: " & Request.ServerVariables("REMOTE_USER") & "<br>"
Response.Write "AUTH_USER: " & Request.ServerVariables("AUTH_USER") & "<br>"
Response.Write "REMOTE_ADDR: " & Request.ServerVariables("REMOTE_ADDR") & "<br>"
Response.Write "<br>"

strRemoteUser = Request.ServerVariables("REMOTE_USER")

'Show all server variables
'For Each Item In Request.ServerVariables
'	Response.Write Item & " = " & Request.ServerVariables(Item) & "<br>"
'Next
%>
<!--<html>
<head>
<title>Phone and Email List</title>
<style type="text/css">
	body{padding: 10px;background-color: #FFF;
	    font: 100.01% "Verdana,Trebuchet MS",Arial,sans-serif}
	h1,h2,p{margin: 0 0px}
	h1{font-size: 125%;color: #000}
	h2{font-size: 200%;color: #C0C0C0}
	p{padding-bottom:1em}
	h2{padding-top: 0.3em}
	div#nifty{ margin: 0 23%;background: #C0C0C0}
	a:hover{color: #FF0000}
	b.rtop, b.rbottom{display:block;background: #FFF}
	b.rtop b, b.rbottom b{display:block;height: 1px;
	    overflow: hidden; background: #C0C0C0}
	b.r1{margin: 0 5px}
	b.r2{margin: 0 3px}
	b.r3{margin: 0 2px}
	b.rtop b.r4, b.rbottom b.r4{margin: 0 1px;height: 2px}
	
	td.topLine, td{border-top: 1px solid black;font-size: 10px}
</style>
</head>
<body bgcolor="#FFFFFF">-->
<%
Dim objConn,objRS,objCom,objADsPath,objDomain,myCounter,colorCounter,rowColor,runLDAPsync,forceRefresh,objConn2,objRS2,viewCompany,totalRecords

'Set variables
runLDAPsync = 0
myCounter = 0
colorCounter = 2
forceRefresh = Request.QueryString("forceRefresh")

'Connection information
Set ObjConn2 = Server.CreateObject("ADODB.Connection")

'Modify this line with IP Address of SQL Server, Database, UserID and password with rights to the database being used
'Use the following line for SQL 2000 connections
'ObjConn2.Open "Driver={SQL Server};Server=10.0.0.1;Database=databaseName;Uid=userName;Pwd=password;Network=DBMSSOCN;" 'DSN-less
'Use the following line for SQL 2005 connections
'ObjConn2.Open "Provider=SQLNCLI;Server=10.0.0.1;Database=databaseName;UID=userName;PWD=password;"

'Open connection
'Set objRS2 = Server.CreateObject("ADODB.Recordset")
'strSQL2 = "SELECT username,dateHire FROM UserProfilesTBL where username = 'SA';"
'objRS2.Open strSQL2, ObjConn2, adOpenKeyset, adLockPessimistic, adCmdText
'objRS2.MoveFirst

'Determine if LDAP query has been run today
'If NOT objRS2.EOF and objRS2.Fields("dateHire") <> date Then
'  runLDAPsync = 1
'  If objRS2.Fields("username") = "SA" Then
'	  objRS2.Fields("dateHire") = date
'	  objRS2.Update
'  End If
'End If

'objRS2.Close
'Set objRS2 = Nothing

'====================================Begin Sync LDAP with SQL Table====================================

'If runLDAPsync = 1 OR forceRefresh = "yes" Then
  'Account and connection string information for LDAP
  'Next line may need to be changed from GC to LDAP depending on environment
  Set objDomain = GetObject ("GC://RootDSE")
  objADsPath = objDomain.Get("defaultNamingContext")
  Set objDomain = Nothing
  Set objConn = Server.CreateObject("ADODB.Connection")
  objConn.provider ="ADsDSOObject"
  objConn.Properties("User ID") = "losheroes\fjpavez"
  objConn.Properties("Password") = "cokillo7"
  objConn.Properties("Encrypt Password") = True
  objConn.open "Active Directory Provider"
  Set objCom = CreateObject("ADODB.Command")
  Set objCom.ActiveConnection = objConn
  'Next line may need to be changed from GC to LDAP depending on environment
  objCom.CommandText ="select name,telephonenumber,mobile,mail,company,title,department,sAMAccountName,sn,userAccountControl,msexchhidefromaddresslists FROM 'GC://"+objADsPath+"' where sAMAccountname='"& strRemoteUser &"' ORDER by sAMAccountname"
  Response.Write("select name,telephonenumber,mobile,mail,company,title,department,sAMAccountName,sn,userAccountControl,msexchhidefromaddresslists FROM 'GC://"+objADsPath+"' where sAMAccountname='"& strRemoteUser &"' ORDER by sAMAccountname")
  Response.Write("<br/>")
'  
  'Executre queury on LDAP for all accounts
  Set objRS = objCom.Execute

  'Loop through records and update or add
  Do While Not objRS.EOF Or objRS.BOF
  	'Set objRS2 = Server.CreateObject("ADODB.Recordset")
'	strSQL2 = "SELECT * FROM UserProfilesTBL where username = '" & objRS("sAMAccountName") & "';"
'	objRS2.Open strSQL2, ObjConn2, adOpenKeyset, adLockPessimistic, adCmdText
	'Update existing record
'	If NOT objRS2.EOF Then
		'objRS2.Fields("Email") = objRS("mail")
'		objRS2.Fields("DeskPhone") = objRS("telephonenumber")
'		objRS2.Fields("CellPhone") = objRS("mobile")
'		objRS2.Fields("Company") = objRS("company")
'		objRS2.Fields("Department") = objRS("department")
'		objRS2.Fields("Title") = objRS("title")
'		objRS2.Fields("Status") = objRS("userAccountControl")
'		objRS2.Fields("username") = objRS("sAMAccountName")
'		objRS2.Fields("DateModified") = FormatDateTime(Date,2)
'		objRS2.Update
		
		'objRS("mail")
'		objRS("telephonenumber")
'		objRS("mobile")
'		objRS("company")
'		objRS("department")
'		objRS("title")
'		objRS("userAccountControl")
'		objRS("sAMAccountName")		
		
	'Add record and update if it wasn't found
'	Elseif objRS2.EOF AND objRS("sAMAccountName") <> "" Then
		'objRS2.AddNew
'		objRS2.Fields("FullName") = objRS("name")		
'		objRS2.Fields("Email") = objRS("mail")
'		objRS2.Fields("username") = objRS("sAMAccountName")
'		objRS2.Fields("DeskPhone") = objRS("telephonenumber")
'		objRS2.Fields("CellPhone") = objRS("mobile")
'		objRS2.Fields("Company") = objRS("company")
'		objRS2.Fields("Department") = objRS("department")
'		objRS2.Fields("Title") = objRS("title")
'		objRS2.Fields("Status") = objRS("userAccountControl")
'		objRS2.Fields("ScanExempt") = 0
'		objRS2.Fields("DateModified") = FormatDateTime(Date,2)
'		objRS2.Update
		
		'objRS2.AddNew
		
		strVariables = ""
		strVariables = strVariables & objRS("name")	& " / "
		strVariables = strVariables & objRS("mail") & " / "
		strVariables = strVariables & objRS("sAMAccountName") & " / "
		strVariables = strVariables & objRS("telephonenumber") & " / "
		strVariables = strVariables & objRS("mobile") & " / "
		strVariables = strVariables & objRS("company") & " / "
		strVariables = strVariables & objRS("department") & " / "
		strVariables = strVariables & objRS("title") & " / "
		strVariables = strVariables & objRS("userAccountControl") & "<br/>"	 
		Response.Write(strVariables)
		
'	End If
	objRS.MoveNext
	'objRS2.Close
'	Set strSQL2 = Nothing
  Loop
  
  'Close objects and remove from memory
  objRS.Close
  objConn.Close
  Set objRS = Nothing
  Set objConn = Nothing
  Set objCom = Nothing
  Set objADsPath = Nothing
  Set objDomain = Nothing
  'Set objRS2 = Nothing
'End If

'=====================================End Sync LDAP with SQL Table=====================================
%>
<!--<center><h2>Phone & Email List</h2>-->

<!-- Begins top portion rounding of corners on a table -->
<!--<div id="nifty">
<b class="rtop">
<b class="r1"></b><b class="r2"></b><b class="r3"></b><b class="r4"></b>
</b>-->
<!-- Ends top portion rounding of corners on a table -->
<%
'Response.Write "<table border='0px' cellspacing='0px' cellpadding='0px'>"
'Response.Write "<tr>"
'Response.Write "<th>Company</th>"
'Response.Write "<th>Name</th>"
'Response.Write "<th>Phone</th>"
'Response.Write "<th>Mobile</th>"
'Response.Write "<th>Title</th>"
'Response.Write "<th>Building - Room</th>"
'Response.Write "</tr>"
'
''=====================================Begin Writing from SQL Table=====================================
'
'Set objRS2 = Server.CreateObject("ADODB.Recordset")
'
'strSQL2 = "SELECT * FROM UserProfilesTBL Where NOT ScanExempt = '1' order by FullName;"
'
'objRS2.Open strSQL2, ObjConn2, adOpenKeyset, adLockPessimistic, adCmdText
'objRS2.MoveFirst
'totalRecords = objRS2.RecordCount
'  
'Do While NOT objRS2.EOF
'	If objRS2.Fields("FullName") <> "" AND (objRS2.Fields("Status") = "512" OR objRS2.Fields("Status") = "66048") Then
'	If NOT objRS2.Fields("username") = "" Then	myCounter = myCounter + 1
'	If colorCounter = 2 Then
'		rowColor = "#CCCCCC"
'		colorCounter = 0
'	Else
'		rowColor = "#FFFFFF"
'	End If
'	colorCounter = colorCounter  + 1
'	Response.Write "<tr bgcolor='" & rowColor & "'>"
'	Response.Write "<td>&nbsp;" & objRS2.Fields("Company") & "&nbsp;</td>"
'	If NOT objRS2.Fields("Email") = "" Then
'		Response.Write "<td>&nbsp;<a href='mailto:" & objRS2.Fields("Email") & "'>" & objRS2.Fields("FullName") & "</a>&nbsp;</td>"
'	Else
'		Response.Write "<td>&nbsp;" & objRS2.Fields("FullName") & "&nbsp;</td>"
'	End If
'	Response.Write "<td>&nbsp;" & objRS2.Fields("DeskPhone") & "&nbsp;</td>"
'	Response.Write "<td>&nbsp;" & objRS2.Fields("CellPhone") & "&nbsp;</td>"
'	Response.Write "<td>&nbsp;" & objRS2.Fields("Title") & "&nbsp;</td>"
'	Response.Write "<td>&nbsp;" & objRS2.Fields("Building") & " - " & objRS2.Fields("RoomNumber") & "&nbsp;</td>"
'	Response.Write "</tr>"
'	End If
'	objRS2.MoveNext
'Loop
'
'objRS2.Close
'objConn2.Close
'Set colorCounter = Nothing
'Set rowColor = Nothing
'Set totalRecords = Nothing
'Set objRS2 = Nothing
'Set objConn2 = Nothing

'======================================End Writing from ETS Table======================================

'Response.Write "</table>"
%>
<!-- Begins bottom portion rounding of corners on a table -->
<!--<b class="rbottom">
<b class="r4"></b> <b class="r3"></b> <b class="r2"></b> <b class="r1"></b>
</b>
</div>-->
<!-- Ends bottom portion rounding of corners on a table -->
<%
'Response.Write "<br />" & myCounter & " Records<br /></center>"
'Response.Write "<center><form name='refresh'><a href='ldap.asp?forceRefresh=yes'>&nbsp;</a></form></center>"
'
'Set myCounter = Nothing
'Response.Flush()
%>
<!--</body>
</html>-->