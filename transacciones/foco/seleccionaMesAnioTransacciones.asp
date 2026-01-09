<!--#include file="../../funciones.asp"-->
<%sql = ""
sql = sql & " select "
sql = sql & " month(cast(a.fecha as date)) as mes, "
sql = sql & " YEAR(cast(a.fecha as date)) as anio "
sql = sql & " from SUC_transacciones_diarias a "
sql = sql & " where a.colCred <> 0 "
sql = sql & " group by month(cast(a.fecha as date)), "
sql = sql & " YEAR(cast(a.fecha as date))"
sql = sql & " order by YEAR(cast(a.fecha as date)) desc, " 
sql = sql & " month(cast(a.fecha as date)) desc  "
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getrows()
	tieneDatos = 1
end if
if tieneDatos = 1 then%>
	<div class="row-fluid">
		<div class="span6 offset3 well">
			<div class="row-fluid">
				<div class="span3">Seleccione mes : </div>
				<div class="span9">
					<select id="seleccionaMesAnioTransacc">
						<option value="">[Seleccione mes]</option>
						<%for i = 0 to ubound(datos,2)
							mes = trim(datos(0,i))
							nombreMes = primeraMayuscula(monthname(mes))
							if len(mes) = 1 then mes = "0"&mes
							anio = trim(datos(1,i))
							valor = anio&mes%>
							<option value="<%=valor%>">
								<%=anio&" - "&nombreMes%>
							</option>
						<%next%>
					</select>
					<span id="errorOption" class="label label-important">
						Debe seleccionar una opcion
					</span>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		$(function(){
			$('#errorOption').hide();
		});
		$('#seleccionaMesAnioTransacc').change(function() {
			var valor = $(this).val();
			if (valor ==='')
			{
				$('#errorOption').fadeIn('slow');
			}
			else
			{
				$('#errorOption').fadeOut('slow');
				window.open('transacciones/foco/downloadDatos.asp?valor='+valor);
			}
		});
	</script>
<%end if%>