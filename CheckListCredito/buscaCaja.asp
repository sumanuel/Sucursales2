<!--#include file="../funciones2.asp"-->
<%idCarpeta=trim(request("idCarpeta"))
sql = ""
sql = sql & " select id_codigo_barra "
sql = sql & " from SUC_vcc_carpeta_credito "
sql = sql & " where id_carpeta = '"&idCarpeta&"' "
set rs = db.execute(sql)
if not rs.eof then
	codigoBarra = trim(rs(0))
end if%>
<span class="ayuda">
	<%=codigoBarra%>
</span>
<script type="text/javascript">
	/*$(function(){
		$('.ayuda').tooltip({
			placement : 'top',
			title: "Doble click para modificar"
		});
	});*/
</script>