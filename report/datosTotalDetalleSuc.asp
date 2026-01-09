<!--#include file="../funciones2.asp"-->
<%idSucursalMain = trim(request("idSucursalMain1"))
idUsuarioMain = trim(request("idUsuarioMain1"))
periodo = trim(request("periodo"))
idProducto = trim(request("idProducto"))
idItem = trim(request("idItem"))
idAccion = trim(request("idAccion"))
selectIdCodigoNotario = trim(request("selectIdCodigoNotario"))
if selectIdCodigoNotario = "" then
	selectIdCodigoNotario = "0" 
end if
%>

{
	"data": [
<%
sql = ""
sql = sql & " EXEC SCSS_prc_datos_check_por_suc2 '"&idProducto&"','"&idItem&"','"&idSucursalMain&"','"&idUsuarioMain&"','"&idAccion&"','"&periodo&"','"&selectIdCodigoNotario&"' "
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
	    fechaColocacion = trim(datos(2,i))
	    nomSucursal = server.htmlencode(trim(datos(3,i)))
	    rutCliente = trim(datos(4,i))
	    numCaja = trim(datos(5,i))
		totalPorcentaje = trim(datos(6,i))
		estadoCaja = trim(datos(7,i))
	    alerta = trim(datos(8,i))
	    idEstadoNotario = trim(datos(9,i))
	    tipoInsDel = trim(datos(10,i)) %>
    {
   		"idCarpeta": "<%=idCarpeta%>",
	    "numCredito": "<%=numCredito%>",
	    "fechaColocacion": "<%=fechaColocacion%>",
	    "nomSucursal": "<%=nomSucursal%>",
	    "rutCliente": "<%=rutCliente%>",
	    "numCaja": "<%=numCaja%>",
	    "totalPorcentaje": "<%=totalPorcentaje%>",
	    "estadoCaja": "<%=estadoCaja%>",
	    "alerta": "<%=alerta%>",        
	    "DT_RowId": "<%=idCarpeta%>" ,
	    "DT_RowAttr":{"data-idEstadoNotario":"<%=idEstadoNotario%>","data-tipoInsDel":"<%=tipoInsDel%>"}
    }
	<%if i <> ubound(datos,2) then
    	Response.Write ","
    end if
  next
else
  idCarpeta = "---"
  numCredito = "---"
  fechaColocacion = "---"
  nomSucursal = "---"
  rutCliente = "---"
  numCaja = "---"
  totalPorcentaje = "---"
  estadoCaja = "---"
  alerta = "---"
  %>  
{
	"idCarpeta": "<%=idCarpeta%>",
	"numCredito": "<%=numCredito%>",
	"fechaColocacion": "<%=fechaColocacion%>",
	"nomSucursal": "<%=nomSucursal%>",
	"rutCliente": "<%=rutCliente%>",
	"numCaja": "<%=numCaja%>",
	"totalPorcentaje": "<%=totalPorcentaje%>",
	"estadoCaja": "<%=estadoCaja%>",
	"alerta": "<%=alerta%>",        
	"DT_RowId": "<%=idCarpeta%>" 
  }

<%end if%>
]}