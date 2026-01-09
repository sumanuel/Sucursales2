<!--#include file="../funciones2.asp"-->
<% idSucursalEnvio = trim(request("idSucursalEnvio"))
idUsuarioMainEnvio = trim(request("idUsuarioMainEnvio"))
periodoEnvio = trim(request("periodoEnvio"))
idPerfilMainEnvio = trim(request("idPerfilMainEnvio"))%>
{
	"data": [
<%
sql = ""
sql = sql & " EXEC SCSS_prc_lista_total_Envio_Notario '"&periodoEnvio&"','"&idSucursalEnvio&"','"&idPerfilMainEnvio&"' "
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
		idCodigoNotario = trim(datos(0,i))
	   	codigoNotario = trim(datos(1,i))
	    fechaEnvio = trim(datos(2,i))    
	    idUsuario = server.htmlencode(trim(datos(3,i)))
	    estadoEnvio = server.htmlencode(trim(datos(4,i)))
	    nomSucursal = server.htmlencode(trim(datos(5,i)))
		total_carpeta = trim(datos(6,i))
		total_item = trim(datos(7,i))
	    total_checkOK = trim(datos(8,i))
	    if total_checkOK <> 0 then
	    	porcentajeMarca = formatpercent(total_checkOK/total_item,1)
	    	if right(porcentajeMarca,3) = ",0%" then
				enteroPorcentaje = cint(replace(porcentajeMarca,"%",""))
				porcentajeMarca = enteroPorcentaje&"%"
			end if
		else
			porcentajeMarca = "0%"
		end if
		idEstadoNotario = trim(datos(9,i))
		idEstadoEnvioNotario = trim(datos(10,i))
	    %>
    {
   		"codigoNotario": "<%=codigoNotario%>",
	    "fechaEnvio": "<%=fechaEnvio%>",
	    "idUsuario": "<%=idUsuario%>",
	    "estadoEnvio": "<%=estadoEnvio%>",
	    "nomSucursal": "<%=nomSucursal%>",
	    "total_carpeta": "<%=total_carpeta%>",
	    "porcentajeMarca": "<%=porcentajeMarca%>",     
	    "DT_RowId": "<%=codigoNotario%>" ,
	    "DT_RowAttr":{"data-idCodigoNotario":"<%=idCodigoNotario%>","data-idEstadoNotario":"<%=idEstadoNotario%>","data-idEstadoEnvioNotario":"<%=idEstadoEnvioNotario%>"}
    }
	<%if i <> ubound(datos,2) then
    	Response.Write ","
    end if
  next
else
  codigoNotario = "---"
  fechaEnvio = "---"
  idUsuario = "---"
  estadoEnvio = "---"
  nomSucursal = "---"
  total_carpeta = "---"
  porcentajeMarca = "---"
  %>  
{
	"codigoNotario": "<%=codigoNotario%>",
	"fechaEnvio": "<%=fechaEnvio%>",
	"idUsuario": "<%=idUsuario%>",
	"estadoEnvio": "<%=estadoEnvio%>",
	"nomSucursal": "<%=nomSucursal%>",
	"total_carpeta": "<%=total_carpeta%>",
	"porcentajeMarca": "<%=porcentajeMarca%>",     
	"DT_RowId": "<%=codigoNotario%>" 
  }

<%end if%>
]}