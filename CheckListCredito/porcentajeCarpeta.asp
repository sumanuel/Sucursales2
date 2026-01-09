<!--#include file="../funciones2.asp"-->
<%idCarpeta = trim(request("idCarpeta"))
codigoBarras = trim(request("codigoBarras"))
idUsuario = trim(request("idUsuario"))
'fechaRecepcion = trim(request("fechaRecepcion"))
sql = ""
sql = sql & " select COUNT(*) "
sql = sql & " from SUC_vcc_checklist b, "
sql = sql & " SUC_vcc_tipo_doc c "
sql = sql & " where "
sql = sql & " id_carpeta = '"&idCarpeta&"' "
sql = sql & " and b.ID_Tipo_Doc = c.ID_Tipo_Doc "
sql = sql & " and c.excluyente = 0 "
'response.write(sql)
'response.end
set rs = db.execute(sql)
if not rs.eof then
	totalCheck = trim(rs(0))
end if
sql = ""
sql = sql & " select COUNT(*) "
sql = sql & " from SUC_vcc_checklist b, "
sql = sql & " SUC_vcc_tipo_doc c "
sql = sql & " where "
sql = sql & " id_carpeta = '"&idCarpeta&"' "
sql = sql & " and b.ID_Tipo_Doc = c.ID_Tipo_Doc "
sql = sql & " and c.excluyente = 0 "
sql = sql & " and check_OK = 0 "
set rs = db.execute(sql)
if not rs.eof then
	totalResponde = trim(rs(0))
end if
totalnoResponde = totalCheck - totalResponde
totalPorcentaje = FormatPercent(totalResponde/totalCheck,1)
totalPorcentaje = replace(totalPorcentaje,"%","")
if right(totalPorcentaje,2) = ",0" then
	totalPorcentaje = cint(totalPorcentaje)
end if
totalPorcentaje = totalPorcentaje&"%"
response.write(totalPorcentaje)
enteroPorcentaje = cint(replace(totalPorcentaje,"%",""))

if enteroPorcentaje = 100 then
	sql = ""
	sql = sql & " execute SCSS_sp_modifica_carpeta_credito "
	sql = sql & " '"&idCarpeta&"' ,"
	'sql = sql & " '"&fechaRecepcion&"', "
	sql = sql & " '"&codigoBarras&"', "
	sql = sql & " '"&idUsuario&"', "
	sql = sql & " '103' "
	db.execute(sql)%>
	<span id="idCarpeta" data-idCarpeta="<%=idCarpeta%>"></span>
<%end if%>
