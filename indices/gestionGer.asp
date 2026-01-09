<!--#include file="../funciones.asp"-->
<%tipo = trim(request("tipo"))
if tipo = "4" then
  icono = "icon-group"
  tipoClase = "gAdministrativa"
  campo = "admin"
end if
if tipo = "3" then
  icono = "icon-money"
  tipoClase = "gContable"
  campo = "cont"
end if
if tipo= "2" then
  icono = "icon-archive"
  tipoClase = "gDocumental"
  campo = "doc"
end if
sql = ""
sql = sql & "select count(a.id_gest_"&campo&") "
sql = sql & " from SUC_gest_"&campo&" a inner join SUC_gest_"&campo&"_tipo b "
sql = sql & " on a.id_gest_"&campo&"_tipo = b.id_gest_"&campo&"_tipo "
sql = sql & " where a.fecha_operacion = CAST(getdate() as date) "
set rs = db.execute(sql)
if not rs.eof then
  totalTareas = trim(clng(rs(0)))
end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
if totalTareas <> "0" then tieneDatos = 1
if tieneDatos = 1 then
	sql = ""
	sql = sql & "select count(a.id_gest_"&campo&") "
	sql = sql & " from SUC_gest_"&campo&" a inner join SUC_gest_"&campo&"_tipo b "
	sql = sql & " on a.id_gest_"&campo&"_tipo = b.id_gest_"&campo&"_tipo "
	sql = sql & " where a.fecha_operacion = CAST(getdate() as date) "
	sql = sql & " and gest_"&campo&"_estado = 1 "
	set rs = db.execute(sql)
	if not rs.eof then
		totalTareasTerminadas = trim(clng(rs(0)))
	end if
	rs.Close
	set rs.ActiveConnection = nothing
	set rs=nothing
	DB.Close
	set DB=nothing
	totalTareasNoTerminadas = totalTareas - totalTareasTerminadas
	porcentaje = cint((totalTareasTerminadas * 100) / totalTareas)
	if porcentaje < 100 then
		if porcentaje <= 30 then
			clase = "error"
		else
			clase = "warning"
		end if
	else
		clase = "success"
	end if
 end if%>
<i class="<%=icono%> icon-2x text-<%=clase%>"></i>
<%=porcentaje%>%