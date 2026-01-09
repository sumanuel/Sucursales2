<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))

sql= ""
sql = sql & "exec SUC_prc_sucursal_apertura_ing '"&idSucursal&"', 2 "
'response.write(sql)
set rs = db.execute(sql)
'rs.Close
'set rs.ActiveConnection = nothing
'set rs=nothing
'DB.Close
'set DB=nothing%>
<script type="text/javascript">
$('#cierreSucursal').removeClass('oculto');
</script>