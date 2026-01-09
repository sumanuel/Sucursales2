<!--#include file="../funciones2.asp"-->
<%codigo = trim(request("codigo"))
sql = ""
sql = sql & "select 1 from SUC_vcc_caja where id_codigo_barra = '"&codigo&"'"
set rs = db.execute(sql)
if not rs.eof then%>
	<span class="badge badge-important"> 
		El código ya existe en el sistema 
	</span>
	<script type="text/javascript">
		$('#checkOk').html('<i class="icon-remove"></i>').slideDown('slow').removeClass('text-success').addClass('text-error');
		$('#controlCodigo').removeClass('success').addClass('error');
	</script>
<%else%>
	<span class="btn btn-primary" id="registraCodigo" onclick="registraCodigo();">
		Registrar
	</span>
	<script type="text/javascript">
		$('#checkOk').html('<i class="icon-ok"></i>').slideDown('slow').removeClass('text-error').addClass('text-success');
		$('#controlCodigo').removeClass('error').addClass('success');
	</script>
<%end if%>