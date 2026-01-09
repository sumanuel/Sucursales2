<!--#include file="../../funciones.asp"-->
<%
Response.ContentType = "application/json"
sql = ""
sql = sql & " declare @diaAnterior as date "
sql = sql & " set @diaAnterior = (select utilidades.dbo.fn_diaHabilAnterior(GETDATE())) "
sql = sql & " select b.suc_zonal as zonal, "
sql = sql & " a.cod_sucursal as cod_bantotal, "
sql = sql & " a.nombre_sucursal, "
sql = sql & " a.colCred, "
sql = sql & " a.colCred_monto, "
sql = sql & " cast(a.fecha as date) as fecha  "
sql = sql & " from SUC_transacciones_diarias a " 
sql = sql & " inner join SUC_sucursal b "
sql = sql & " on a.cod_sucursal = b.cod_bantotal  "
sql = sql & " where YEAR(a.fecha) = year(@diaAnterior)  "
sql = sql & " and MONTH(a.fecha) = MONTH(@diaAnterior)  "
sql = sql & " and b.suc_foco = 1  "
sql = sql & " and a.colCred <> 0  "
sql = sql & " order by a.cod_sucursal, a.fecha  "

set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getrows()%>
	{
		"data": [
		<%for i = 0 to ubound(datos,2)
			zonal = trim(datos(0,i))
			cod_bantotal = trim(datos(1,i))
			nombre_sucursal = trim(datos(2,i))
			colCred = trim(datos(3,i))
			colCredF = formatnumber(colCred,0)
			colCred_monto = trim(datos(4,i))
			colCred_montoF = formatnumber(colCred_monto,0)
			fecha = trim(datos(5,i))%>
			{
				"zonal": "<%=zonal%>",
				"cod_bantotal": "<%=cod_bantotal%>",
				"nombre_sucursal": "<%=nombre_sucursal%>",
				"colCred": "<%=colCred%>",
				"colCredF": "<%=colCredF%>",
				"colCred_monto": "<%=colCred_monto%>",
				"colCred_montoF" : "<%=colCred_montoF%>",
				"fecha" : "<%=fecha%>"
			}
			<%if i <> ubound(datos,2) then%>
				,
			<%end if%>
		<%next%>
		]
	}
<%else%>
{
	"data": [
		{
			"zonal": "---",
			"cod_bantotal": "---",
			"nombre_sucursal": "---",
			"colCred": "---",
			"colCredF": "---",
			"colCred_monto": "---",
			"colCred_montoF" : "---",
			"fecha" : "---"
		}
	]
}
<%end if%>