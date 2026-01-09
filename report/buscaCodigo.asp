<!--#include file="../funciones2.asp"-->
<%codigo = trim(request("codigo"))

if codigo <> "0" and codigo <> "" then
	sql = ""
	sql = sql & "select count(0) from SUC_vcc_caja where id_codigo_barra = '"&codigo&"'"
	set rs = db.execute(sql)
	if not rs.eof then
		existe = trim(rs(0))
		if (existe > 0) then %>
			<span class="badge badge-important">El código ya existe en el sistema </span>
			<script type="text/javascript">
				$('#checkOk').html('<i class="icon-remove"></i>').slideDown('slow').removeClass('text-success').addClass('text-error');
				$('#controlador').removeClass('success').addClass('error');
				$('#btnRegistraCaja').hide();
			</script>
		<%else%>
			<span class="badge badge-info">Código Válido</span>
			<script type="text/javascript">
				$('#checkOk').html('<i class="icon-ok"></i>').slideDown('slow').removeClass('text-error').addClass('text-success');
				$('#controlador').removeClass('error').addClass('success');
				$('#btnRegistraCaja').slideDown('fast');
			</script>
	 	<%end if
	end if%>
<%else%>
	<span class="badge badge-important">Ingrese un codigo valido </span>
	<script type="text/javascript">
		$('#checkOk').html('<i class="icon-remove"></i>').slideDown('slow').removeClass('text-success').addClass('text-error');
		$('#controlador').removeClass('success').addClass('error');
		$('#btnRegistraCaja').hide();
	</script>
<%end if%>