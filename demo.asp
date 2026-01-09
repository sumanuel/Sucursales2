<%
Domain = "losheroes.losheroes.cl"
strQuery = "SELECT sAMAccountName FROM 'LDAP://" & Domain & "' WHERE objectClass='*'"
        set oConn = server.CreateObject("ADODB.Connection")
        oConn.Provider = "ADsDSOOBJECT"
        oConn.properties("User ID") = "rmorales"
        oConn.properties("Password")="adivina123456+"
        oConn.properties("Encrypt Password") = true
        oConn.open "DS Query", Username,Password
        set cmd = server.CreateObject("ADODB.Command")
        set cmd.ActiveConnection = oConn
        cmd.CommandText = strQuery
        set oRS = cmd.Execute
        if oRS.bof or oRS.eof then
            AuthenticateUser = false
        else
            AuthenticateUser = oRS(0)&"xx"
        end if
        set oRS = nothing
        set oConn = nothing

        response.write(AuthenticateUser)
%>

