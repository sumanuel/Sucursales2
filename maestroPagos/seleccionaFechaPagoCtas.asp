<!--#include file="../funciones.asp"-->
<%sql = ""
sql = sql & " SELECT distinct(Mes) as mes "
sql = sql & " FROM SCSS.dbo.vw_Total_Pago_Cuentas_Dia "
sql = sql & " order by mes desc "
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getrows()
	tieneDatos = 1
end if
if tieneDatos = 1 then%>
	<div class="row-fluid">
		<div class="span12">
			<select id="selectFechaPagCtas">
				<%for i = 0 to ubound(datos,2)
					mes = trim(datos(0,i))
					anio = left(mes,4)
					mesTotal = cint(right(mes,2))
					nombreMes = primeraMayuscula(monthname(mesTotal))
					opcion = anio&" - "&nombreMes%>
					<option value="<%=mes%>">
						<%=opcion%>
					</option>
				<%next%>
			</select>	
		</div>
	</div>
	<script type="text/javascript">
	$(function(){
		var valorSelect = $('#selectFechaPagCtas').val();
		fechaSeleccionadaPagoCtas(valorSelect);
	});
	$('#selectFechaPagCtas').change(function() {
		var valorSelect = $('#selectFechaPagCtas').val();
		fechaSeleccionadaPagoCtas(valorSelect);
	});
	function fechaSeleccionadaPagoCtas(valor)
	{
		$('#graficoPagoCtas').hide();
		var pagina, div, datos;
		pagina = 'maestroPagos/tablaPagoCtas.asp';
		div = 'datosPagoCta';
		datos='valorFecha='+valor;
		enviaDatos(pagina,div,datos);
	}
	</script>
<%end if%>