<!--#include file="../funciones2.asp"-->
<%idSucursalEnvio = trim(request("idSucursalEnvio"))
idCodigoNotario = trim(request("idCodigoNotario"))
periodoEnvio = trim(request("periodoEnvio"))
idPerfilMainEnvio = trim(request("idPerfilMainEnvio"))%>
{
	"data": [
<%
sql = ""
sql = sql & " EXEC SCSS_prc_notario_detalle_total_credito_notario '"&periodoEnvio&"','"&idSucursalEnvio&"','"&idCodigoNotario&"','"&idPerfilMainEnvio&"' "
'response.write(sql)
'response.end
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
  datos = rs.getrows()
  tieneDatos = 1
end if
if tieneDatos = 1 then
	for i = 0 to ubound(datos,2)
		idCarpeta = trim(datos(0,i))
	   	numCredito = trim(datos(1,i))
	   	codNotario = trim(datos(2,i))  
	    fechaCredito = trim(datos(3,i))
	    fechaColocacion = trim(datos(4,i))     
	    rutCliente = trim(datos(5,i)) 
	    estadoCredNotario = server.htmlencode(trim(datos(6,i)))
	    usuarioCred = 	server.htmlencode(trim(datos(7,i))) 
	    nomSucursal = server.htmlencode(trim(datos(8,i)))
		idCodigoNotario = trim(datos(9,i))
		idEstadoNotarioCred = trim(datos(10,i))
	    %>
    {
   		"idCarpeta": "<%=idCarpeta%>",
	    "numCredito": "<%=numCredito%>",
	    "codNotario": "<%=codNotario%>",   
	    "fechaCredito": "<%=fechaCredito%>",
	    "fechaColocacion": "<%=fechaColocacion%>",
	    "rutCliente": "<%=rutCliente%>",
	    "estadoCredNotario": "<%=estadoCredNotario%>",
	    "usuarioCred": "<%=usuarioCred%>",
	    "nomSucursal": "<%=nomSucursal%>", 
	     
	    "DT_RowId": "<%=idCarpeta%>" ,
	    "DT_RowAttr":{"data-idCodigoNotario":"<%=idCodigoNotario%>","data-idEstadoNotarioCred":"<%=idEstadoNotarioCred%>"}
    }
	<%if i <> ubound(datos,2) then
    	Response.Write ","
    end if
  next
else
    idCarpeta = "---"
    numCredito = "---"
    codNotario = "---"
    fechaCredito = "---"
    fechaColocacion = "---"
    rutCliente = "---"
    estadoCredNotario = "---"
    usuarioCred = "---"
    nomSucursal = "---"

  %>  
{
	"idCarpeta": "<%=idCarpeta%>",
	"numCredito": "<%=numCredito%>",
	"codNotario": "<%=codNotario%>",  
	"fechaCredito": "<%=fechaCredito%>",
	"fechaColocacion": "<%=fechaColocacion%>",
	"rutCliente": "<%=rutCliente%>",
	"estadoCredNotario": "<%=estadoCredNotario%>",
	"usuarioCred": "<%=usuarioCred%>",
	"nomSucursal": "<%=nomSucursal%>",      
	"DT_RowId": "<%=idCarpeta%>" 
  }

<%end if%>
]}
