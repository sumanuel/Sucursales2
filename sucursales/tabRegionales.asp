<!--#include file="../funciones.asp"-->
<%totalCampos = 4
idRegional = trim(request("idZona"))
if idRegional = "" then idRegional = "1" %>
<div class="row-fluid" id="divMenuTabRegionales">
	<div class="span12">
		<ul class="nav nav-tabs" id="tabRegionales">
			<%sql = ""
			sql = sql & "select id_regional, nombre_regional zona from suc_regionales "
			set rs = db.execute(sql)
			if not rs.eof then
				datosZona = rs.GetRows()
			end if
			For i = 0 to ubound(datosZona, 2)
				idZonaSelecciona = trim(datosZona(0,i))
				nombreZona = server.htmlencode(trim(datosZona(1,i)))%>
				<li data-idRegional="<%=idZonaSelecciona%>" class="seleccionaZona" id="tabRegional<%=idZonaSelecciona%>">
					<a href="#">
						<%=nombreZona%>
					</a>
				</li>
			<%next%>
		</ul>
	</div>
</div>
<div class="row-fluid">
	<div class="span12" id="cuadrosRegionales"></div>
</div>
<script type="text/javascript">
$(function(){
	$('.seleccionaZona').first().addClass('active');
	var idRegional = $('.seleccionaZona').first().attr('data-idRegional');
	var pagina, div, datos;
	pagina = 'sucursales/cuadrosRegionalesGer.asp';
	div = 'cuadrosRegionales';
	datos='idRegional='+idRegional;
	enviaDatos(pagina,div,datos);	
});
$('.seleccionaZona').click(function() {
	$('#tabRegionales > li').each(function() {
		$(this).removeClass('active');
	});
	$(this).addClass('active');
	var idRegional = $(this).attr('data-idRegional');
	pagina = 'sucursales/cuadrosRegionalesGer.asp';
	div = 'cuadrosRegionales';
	datos='idRegional='+idRegional;
	enviaDatos(pagina,div,datos);
});

</script>