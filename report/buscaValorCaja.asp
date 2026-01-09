<!--#include file="../funciones2.asp"-->
<%idCarpeta = trim(request("idCarpeta"))
 sql = ""
 sql = sql & " SELECT id_codigo_barra "
 sql = sql & " FROM SUC_vcc_carpeta_credito "
 sql = sql & " WHERE id_carpeta = '"&idCarpeta&"' "
 set rs = db.execute(sql)
 if not rs.eof then
 	codigoBarra = trim(rs(0))
 end if%>
<%=codigoBarra%>

