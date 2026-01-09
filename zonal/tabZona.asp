<!--#include file="../funciones.asp"-->
<div class="row-fluid">
	<div id="menuGer" class="span12"> 
		<ul class="nav nav-tabs" id="idZona">
			<%sql = ""
			sql = sql & "select id_zona, zona from suc_zonas "
			set rs = db.execute(sql)
			if not rs.eof then
				datosZona = rs.GetRows()
			end if
			For i = 0 to ubound(datosZona, 2)
				idZona = trim(datosZona(0,i))
				nombreZona = server.htmlencode(trim(datosZona(1,i)))%>
				<li data-idZona="<%=idZona%>" class="seleccionaZona" id="idZona<%=idZona%>">
					<a href="#">
						<%=nombreZona%>
					</a>
				</li>
			<%next%>
		</ul>
	</div>
	
</div>
<input type="hidden" name="zona" id="zona">
<script type="text/javascript">
idZona = $('#zona').val();
if (idZona == "")
{
	$('#idZona1').addClass('active');
}
</script>