<!--#include file="../funciones.asp"-->
<%mes = "201505"
anio = left(mes,4)
mesTotal = cint(right(mes,2))
nombreMes = primeraMayuscula(monthname(mesTotal))
opcion = anio&" - "&nombreMes%>
<div class="row-fluid">
	<div class="span12">
		<select id="seleccionaFechaRedMovil">
			<option value="<%=mes%>">
				<%=opcion%>
			</option>
		</select>
	</div>
</div>
<script type="text/javascript">
$(function(){
	var pagina, div, datos, mes;
	mes = $('#seleccionaFechaRedMovil').val()
	pagina = 'maestroPAgos/redMovilT1.asp';
	div = 'redMovilT1';
	datos='mes='+mes;
	enviaDatos(pagina,div,datos);
	pagina = 'maestroPAgos/rezagoRedMovil.asp';
	div = 'rezagoRM';
	enviaDatos(pagina,div,datos);
	pagina = 'maestroPAgos/redMovilenRedFija.asp';
	div = 'redMovilRedFija';
	enviaDatos(pagina,div,datos);	
});
</script>