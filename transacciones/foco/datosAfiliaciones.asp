<!--#include file="../../funciones.asp"-->
<%
Response.ContentType = "application/json"
sql = ""
sql = sql & " declare @diaAnterior as date "
sql = sql & " set @diaAnterior = (select utilidades.dbo.fn_diaHabilAnterior(GETDATE())) "
sql = sql & " select b.suc_zonal, "
sql = sql & " a.cod_sucursal, "
sql = sql & " a.nombre_sucursal, "
sql = sql & " isnull(a.afi_normal,0) as afi_normal, "
sql = sql & " isnull(a.afi_pbs,0) as afi_pbs, "
sql = sql & " isnull(a.afi_ffaa,0) as afi_ffaa, "
sql = sql & " cast(a.fecha as date) as fecha "
sql = sql & " from SUC_transacciones_diarias a "
sql = sql & " inner join SUC_sucursal b "
sql = sql & " on a.cod_sucursal = b.cod_bantotal "
sql = sql & " where year(a.fecha) = year(@diaAnterior) "
sql = sql & " and month(a.fecha) = month(@diaAnterior) "
sql = sql & " and (a.afi_normal <> 0 or a.afi_pbs <> 0) "
sql = sql & " and a.cod_sucursal in "
sql = sql & " (select cod_bantotal "
sql = sql & " from SUC_sucursal "
sql = sql & " where suc_foco = 1) "
sql = sql & " order by a.cod_sucursal, "
sql = sql & " a.fecha "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getrows()%>
	{
		"data": [
		<%for i = 0 to ubound(datos,2)
			zonal = trim(datos(0,i))
			codSucursal = trim(datos(1,i))
			nombre_sucursal = trim(datos(2,i))
			afiNormal = trim(datos(3,i))
			afiNormalF = formatnumber(afiNormal,0)
			afiPbs = trim(datos(4,i))
			afiPbsF = formatnumber(afiPbs,0)
			afiFFAA = trim(datos(5,i))
			afiFFAAF = formatnumber(afiFFAA,0)
			fecha = trim(datos(6,i))%>
			{
				"zonal": "<%=zonal%>",
				"codSucursal": "<%=codSucursal%>",
				"nombre_sucursal": "<%=nombre_sucursal%>",
				"afiNormal": "<%=afiNormal%>",
				"afiNormalF": "<%=afiNormalF%>",
				"afiPbs": "<%=afiPbs%>",
				"afiPbsF" : "<%=afiPbsF%>",
				"afiFFAA" : "<%=afiFFAA%>",
				"afiFFAAF" : "<%=afiFFAAF%>",
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
			"codSucursal": "---",
			"nombre_sucursal": "---",
			"afiNormal": "---",
			"afiNormalF": "---",
			"afiPbs": "---",
			"afiPbsF" : "---",
			"afiFFAA" : "---",
			"afiFFAAF" : "---",
			"fecha" : "---"
		}
	]
}
<%end if%>