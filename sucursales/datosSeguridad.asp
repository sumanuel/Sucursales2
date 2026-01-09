<!--#include file="../funciones.asp"-->
<% perfil = trim(request("perfil"))
idUsuario = trim(request("idUsuario"))
sql = ""


sql = ""
sql = sql & " exec SUC_prc_index_asistencia_ex_h "
sql = sql & "'"&perfil&"', "
sql = sql & " '"&idUsuario&"' "

set rs = db.execute(sql)


'if idPerfil = "55" then
	'codSucursal = ""
	'sqlSucs = ""
	'sqlSucs = sqlSucs & " select cod_bantotal "
	'sqlSucs = sqlSucs & " from SUC_sucursal "
	'sqlSucs = sqlSucs & " where id_sucursal in "
	'sqlSucs = sqlSucs & " (select id_sucursal "
	'sqlSucs = sqlSucs & " from SUC_zonales_comercial_sucursal "
	'sqlSucs = sqlSucs & " where id_zonal = " & idUsuario & ") "

	'set rsSucs = db.execute(sqlSucs)
	'if not rsSucs.eof then
	'dataSucs = rsSucs.GetRows()
	'end if
	'for y=0 to ubound(dataSucs,2)
	'codSucursal = codSucursal & dataSucs(0,y) & ","
	'next
	'codSucursal = left(codSucursal, (len(codSucursal)-1))
	'Response.Write("idSucursal: "&idSucursal & "<br>")
	'rsSucs.close: set rsSucs = nothing 

	'sql = sql & " select  "
	'sql = sql & " sum(z.titulares_dot) as totalguardiastitulares "
	'sql = sql & " ,sum(z.reemplazos_dot) as totalguardiasreemplazos "
	'sql = sql & " ,sum(z.titulares_p)+SUM(z.reemp_p) as totalguardiaspresentes "
	'sql = sql & " ,sum(z.ausencia) as totalguardiasausentes  "
	'sql = sql & " ,sum(sinRegistro) as totalguardiassinregistro "
	'sql = sql & " from ( "
	'sql = sql & " select *, case when y.total >= y.titulares_dot then 0 else y.titulares_a + y.reemp_a  end "
	'sql = sql & " ausencia from ( "
	'sql = sql & " select *, ((titulares_p)+(reemp_p)) as total from ( "
	'sql = sql & " select a.cod_bantotal,  "
	'sql = sql & " count(*) titulares_dot "
	'sql = sql & " ,isnull((select count(*) "
	'sql = sql & " from SUC_sucursal_guardias_asistencia b "
	'sql = sql & " where a.cod_bantotal = b.cod_bantotal "
	'sql = sql & " and b.asistencia = 'si' "
	'sql = sql & " and b.tipo_suc = 'titular'),0) as titulares_p "
	'sql = sql & ",isnull((select count(*) "
	'sql = sql & " from SUC_sucursal_guardias_asistencia b "
	'sql = sql & " where a.cod_bantotal = b.cod_bantotal "
	'sql = sql & " and (b.asistencia = 'no' "
	'sql = sql & " or b.asistencia is null) "
	'sql = sql & " and b.tipo_suc = 'titular'),0) as titulares_a "
	'sql = sql & " ,isnull((select COUNT(gr.guardia_rut_titular) "
	'sql = sql & " from SUC_sucursal_guardias_r gr  "
	'sql = sql & " where gr.guardia_rut_titular = a.guardia_rut  "
	'sql = sql & " and gr.cod_bantotal = a.cod_bantotal  "
	'sql = sql & " and CONVERT(date,gr.desde) <= CONVERT(date,GETDATE())),0) as reemplazos_dot "
	'sql = sql & " ,isnull((select count(*) "
	'sql = sql & " from SUC_sucursal_guardias_asistencia b  "
	'sql = sql & " inner join SUC_sucursal_guardias_r gr on "
	'sql = sql & " gr.guardia_rut = b.guardia_rut "
	'sql = sql & " and gr.cod_bantotal = b.cod_bantotal "
	'sql = sql & " where a.cod_bantotal = b.cod_bantotal "
	'sql = sql & " and b.asistencia = 'si' "
	'sql = sql & " and b.tipo_suc = 'reemplazo'  "
	'sql = sql & " and CONVERT(date,desde) <= CONVERT(date,GETDATE())),0) as reemp_p, "
	'sql = sql & " isnull((select count(*) "
	'sql = sql & " from SUC_sucursal_guardias_asistencia b  "
	'sql = sql & " inner join SUC_sucursal_guardias_r gr "
	'sql = sql & " on gr.guardia_rut = b.guardia_rut "
	'sql = sql & " and gr.cod_bantotal = b.cod_bantotal "
	'sql = sql & " where a.cod_bantotal = b.cod_bantotal "
	'sql = sql & " and (b.asistencia = 'no' "
	'sql = sql & " or b.asistencia is null) "
	'sql = sql & " and b.tipo_suc = 'reemplazo' "
	'sql = sql & " and CONVERT(date,desde) <= CONVERT(date,GETDATE()) "
	'sql = sql & " ),0) as reemp_a "
	'sql = sql & " ,(select COUNT(*) "
	'sql = sql & " from SUC_sucursal_guardias_asistencia b  "
	'sql = sql & " where b.asistencia is null "
	'sql = sql & " and b.cod_bantotal = a.cod_bantotal) as sinRegistro "
	'sql = sql & " from SUC_sucursal_guardias_t a "
	'sql = sql & " group by a.cod_bantotal,a.guardia_rut "
	'sql = sql & " ) as z  "
	'sql = sql & " ) as y  "
	'sql = sql & " where y.cod_bantotal in ("&codSucursal&")  "
	'sql = sql & " ) as z "
'end if

'if idPerfil = "66" then
	'codSucursal = ""
	'sqlSucs = ""
	'sqlSucs = sqlSucs & " select cod_bantotal "
	'sqlSucs = sqlSucs & " from SUC_sucursal "
	'sqlSucs = sqlSucs & " where id_sucursal in "
	'sqlSucs = sqlSucs & " (select id_sucursal "
	'sqlSucs = sqlSucs & " from SUC_zonales_comercial_mas_sucursal "
	'sqlSucs = sqlSucs & " where id_zonal = " & idUsuario & ") "

	'set rsSucs = db.execute(sqlSucs)
	'if not rsSucs.eof then
	'dataSucs = rsSucs.GetRows()
	'end if
	'for y=0 to ubound(dataSucs,2)
	'codSucursal = codSucursal & dataSucs(0,y) & ","
	'next
	'codSucursal = left(codSucursal, (len(codSucursal)-1))
	'Response.Write("idSucursal: "&idSucursal & "<br>")
	'rsSucs.close: set rsSucs = nothing 

	'sql = sql & " select  "
	'sql = sql & " sum(z.titulares_dot) as totalguardiastitulares "
	'sql = sql & " ,sum(z.reemplazos_dot) as totalguardiasreemplazos "
	'sql = sql & " ,sum(z.titulares_p)+SUM(z.reemp_p) as totalguardiaspresentes "
	'sql = sql & " ,sum(z.ausencia) as totalguardiasausentes  "
	'sql = sql & " ,sum(sinRegistro) as totalguardiassinregistro "
	'sql = sql & " from ( "
	'sql = sql & " select *, "
	'sql = sql & " case when y.total >= y.titulares_dot then 0 else y.titulares_a + y.reemp_a  end "
	'sql = sql & " ausencia from ( "
	'sql = sql & " select *, ((titulares_p)+(reemp_p)) as total from ( "
	'sql = sql & " select a.cod_bantotal,  "
	'sql = sql & " count(*) titulares_dot "
	'sql = sql & " ,isnull((select count(*) "
	'sql = sql & " from SUC_sucursal_guardias_asistencia b "
	'sql = sql & " where a.cod_bantotal = b.cod_bantotal "
	'sql = sql & " and b.asistencia = 'si' and b.tipo_suc = 'titular'),0) as titulares_p "
	'sql = sql & ",isnull((select count(*) from SUC_sucursal_guardias_asistencia b where a.cod_bantotal = b.cod_bantotal and (b.asistencia = 'no' or b.asistencia is null) and b.tipo_suc = 'titular'),0) as titulares_a "
	'sql = sql & ",isnull((select COUNT(gr.guardia_rut_titular) "
	'sql = sql & "from SUC_sucursal_guardias_r gr  "
	'sql = sql & "where gr.guardia_rut_titular = a.guardia_rut  "
	'sql = sql & "and gr.cod_bantotal = a.cod_bantotal  "
	'sql = sql & "and CONVERT(date,gr.desde) <= CONVERT(date,GETDATE())),0)as reemplazos_dot "
	'sql = sql & ",isnull((select count(*) from SUC_sucursal_guardias_asistencia b  "
	'sql = sql & "inner join SUC_sucursal_guardias_r gr on gr.guardia_rut = b.guardia_rut and gr.cod_bantotal = b.cod_bantotal "
	'sql = sql & "where a.cod_bantotal = b.cod_bantotal and b.asistencia = 'si' and b.tipo_suc = 'reemplazo'  "
	'sql = sql & "and CONVERT(date,desde) <= CONVERT(date,GETDATE())),0) as reemp_p, "
	'sql = sql & "isnull((select count(*) from SUC_sucursal_guardias_asistencia b  "
	'sql = sql & "inner join SUC_sucursal_guardias_r gr on gr.guardia_rut = b.guardia_rut and gr.cod_bantotal = b.cod_bantotal "
	'sql = sql & "where a.cod_bantotal = b.cod_bantotal and (b.asistencia = 'no' or b.asistencia is null) and b.tipo_suc = 'reemplazo' "
	'sql = sql & "and CONVERT(date,desde) <= CONVERT(date,GETDATE()) "
	'sql = sql & "),0) as reemp_a "
	'sql = sql & " ,(select COUNT(*) from SUC_sucursal_guardias_asistencia b  "
	'sql = sql & "where b.asistencia is null "
	'sql = sql & "and b.cod_bantotal = a.cod_bantotal) as sinRegistro "
	'sql = sql & "from SUC_sucursal_guardias_t a "
	'sql = sql & "group by a.cod_bantotal,a.guardia_rut "
	'sql = sql & " ) as z  "
	'sql = sql & " ) as y  "
	'sql = sql & " where y.cod_bantotal in ("&codSucursal&")  "
	'sql = sql & " ) as z "
	'end if

'if idPerfil <> "2" and idPerfil <> "55" and idPerfil <> "66" then
	'sql = sql & "select "
	'sql = sql & "(select count(0) from SUC_sucursal_guardias_r where hasta >= cast(getdate() as date)) as totalguardiasreemplazos "
	'sql = sql & ",(select count(0) from SUC_sucursal_guardias_t) as totalguardiastitulares "
	'sql = sql & ",(select count(0) from SUC_sucursal_guardias_asistencia where asistencia = 'si') as totalguardiaspresentes "
	'sql = sql & ",(select count(0) from SUC_sucursal_guardias_asistencia where asistencia = 'no') as totalguardiasausentes "
	'sql = sql & ",(select count(0) from SUC_sucursal_guardias_asistencia where asistencia is null) as totalguardiassinregistro "
'end if

'response.Write(sql)
'response.end()

set rs = db.execute(sql)
totalTitu = 0
totalRempl = 0
totalSR = 0
if not rs.eof then 
	totalTitu = rs("totalguardiastitulares")
	totalPres = rs("totalguardiaspresentes")
	totalRempl = rs("totalguardiasreemplazos")
	totalAus = rs("totalguardiasausentes")
	totalSR = rs("totalguardiassinregistro")
end if
Response.ContentType = "application/json"
Response.Write "{"
Response.Write "  ""dataGuardias"": ["
response.write "{"
Response.Write "   ""totalTitu"": """ & totalTitu & """, "
Response.Write "   ""totalPres"": """ & totalPres & """, "
Response.Write "   ""totalRempl"": """ & totalRempl & """, "
Response.Write "   ""totalAus"": """ & totalAus & """, "
Response.Write "   ""totalSR"": """ & totalSR & """ "
response.write "}]}"
%>