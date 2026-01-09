<!--#include file="../funciones2.asp"-->
<%idCarpeta = trim(request("idCarpeta"))
codigoBarras = trim(request("codigoBarras"))
idUsuarioMain = trim(request("idUsuarioMain1"))
'response.write(idCarpeta)
'response.end
sql = ""
sql = sql & "  SELECT Q, visados, PorcentajeCHK, id_carpeta, id_codigo_barra "
sql = sql & "  ,CASE WHEN PorcentajeCHK < 100.00 THEN 0 ELSE 1 END AS chkCompleto "
sql = sql & "  from( "
sql = sql & "  select COUNT(CRV.id_checklist) as Q "
sql = sql & " ,SUM(case when CRV.check_OK = 0 then 1 else 0 end) as visados "  
sql = sql & "  ,convert(varchar,convert(decimal(10,2) "    
sql = sql & "  ,(convert(float,(SUM(case when CRV.check_OK = 0 then 1 else 0 end)*100))/ " 
sql = sql & " 	convert(float,COUNT(CRV.id_checklist))))) as PorcentajeCHK "  
sql = sql & "  ,CAR.id_carpeta,CAR.id_codigo_barra "  
sql = sql & " FROM SUC_vcc_carpeta_credito CAR "
sql = sql & "  INNER JOIN SUC_vcc_checklist CRV ON CRV.id_carpeta = CAR.id_carpeta " 
sql = sql & "  WHERE CAR.id_carpeta = '"&idCarpeta&"' "
sql = sql & "  GROUP BY CAR.id_carpeta,CAR.id_codigo_barra "  
sql = sql & "  )a "  

'response.write(sql)
'response.end
set rs = db.execute(sql)
if not rs.eof then
	prctjCheck = trim(rs(2))
	codigoBarras = trim(rs(4))
	chkCompleto = trim(rs(5))
end if
'response.write(replace(replace(prctjCheck,".",","),",00","")&"%")
prctjChkCtn = replace(replace(prctjCheck,".",","),",00","")&"%"

if (chkCompleto = 1) then%>
	<span class="label label-success"><%=prctjChkCtn%></span>
<%else%>
	<span class="label label-important"><%=prctjChkCtn%></span>
<%end if

if chkCompleto = 1 then
	sql = ""
	sql = sql & " EXEC SCSS_sp_modifica_carpeta_credito "
	sql = sql & " '"&idCarpeta&"' ,"
	'sql = sql & " '"&fechaRecepcion&"', "
	sql = sql & " '"&codigoBarras&"', "
	sql = sql & " '"&idUsuarioMain&"', "
	sql = sql & " '103' "
	db.execute(sql)%>
	<span id="idCarpeta" data-idCarpeta="<%=idCarpeta%>"></span>
<%end if%>
