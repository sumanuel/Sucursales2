
<!--#include file="../funciones.asp"-->
<%
	periodo = trim(request("periodo"))
	tipoConsulta = trim(request("tipoConsulta"))
if tipoConsulta = "" then tipoConsulta = "1"
subConsulta = trim(request("subConsulta"))%>

<%if tipoConsulta = "1" then
	if subConsulta = "1" then
		prefijo = "_monto"
	else
		prefijo = ""
	end if
	base = "SUC_transacciones_diarias"
	
end if
if tipoConsulta = "2" then
	if subConsulta = "1" then
		prefijo = "_monto"
	else
		prefijo = ""
	end if
	base = "SUC_transacciones_acumuladas"
end if
sql = ""
sql = sql & " select "
sql = sql & " convert(varchar,b.suc_nombre)+' ('+CONVERT(varchar,a.cod_sucursal)+')' nombre_sucursal,"	
sql = sql & " pagos2"&prefijo&", "
sql = sql & " ppaa"&prefijo&", "
sql = sql & " leasing"&prefijo&", "
sql = sql & " nominas"&prefijo&", "
sql = sql & " recCred"&prefijo&", "
sql = sql & " trasCaja"&prefijo&", "
sql = sql & " ingCaja"&prefijo&", "
sql = sql & " creSocial"&prefijo&", "
sql = sql & " reDistr"&prefijo&", "
sql = sql & " pagosAFP"&prefijo&", "
sql = sql & " pagosIPS"&prefijo&", "
sql = sql & " licencias"&prefijo&", "
sql = sql & " colCred"&prefijo&", "
sql = sql & " CONVERT(DATETIME, CONVERT(CHAR(8), fecha)) as fecha, "
sql = sql & " b.suc_zonal zonal, "
sql = sql & " b.suc_zonal_jefe regional, "
sql = sql & " RECCEL, "
sql = sql & " RECCEL"&prefijo&", "
sql = sql & " PAGCUENT, "
sql = sql & " PAGCUENT"&prefijo&" "
'sql = sql & " colCred"&prefijo&""
sql = sql & " from "&base&" a, "
sql = sql & " SUC_sucursal b "
sql = sql & " where "
sql = sql & " CONVERT(DATETIME, CONVERT(CHAR(8), fecha)) = "
sql = sql & " ( select max(CONVERT(DATETIME, CONVERT(CHAR(8), fecha))) "
sql = sql & " from "&base
if periodo <> "" then 
	sql = sql & " where left(fecha, 6) = '"&periodo&"') "
else 
	sql = sql & " ) "
end if 
sql = sql & " and a.cod_sucursal = b.cod_bantotal "
sql = sql & " and b.suc_estado = 1 "
sql = sql & " order by b.suc_zonal_jefe, b.suc_zonal, b.suc_nombre asc"
'response.write(sql)
'response.end
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	resultado = ""
	resultado = resultado & "<table id='datatable' class='table table-bordered table-hover table-condensed'>"
	resultado = resultado & "<thead>"
	resultado = resultado & "<tr>"
	'resultado = resultado & "<th class='ayuda' title='CODIGO BANTOTAL'>BT</th>"
	resultado = resultado & "<th class='ayuda' title='SUCURSAL'>SUC</th>"			
	resultado = resultado & "<th class='ayuda' title='JEFE REGIONAL'>REG</th>"
	resultado = resultado & "<th class='ayuda' title='JEFE ZONAL'>ZONAL</th>"
	resultado = resultado & "<th style='background: #CEFE9C;' class='ayuda' title='PAGOS IPS'>IPS</th>"
	resultado = resultado & "<th style='background: #C0E2FF;' class='ayuda' title='PAGOS AFP'>AFP</th>"
	resultado = resultado & "<th class='ayuda' title='COLOCACION DE CREDITOS'>COL CRED</th>"	
	resultado = resultado & "<th class='ayuda' title='LEASING'>LISNG</th>"
	resultado = resultado & "<th class='ayuda' title='PAGO DE LICENCIAS'>P LM</th>"
	resultado = resultado & "<th class='ayuda' title='PAGOS 2%'>PAG 2%</th>"
	resultado = resultado & "<th class='ayuda' title='PAGOS PPAA'>P PPAA</th>"
	resultado = resultado & "<th class='ayuda' title='RECAUDACION EFT(Nominas)'>R EFT</th>"
	resultado = resultado & "<th class='ayuda' title='PAGOS CUOTA DE CREDITO EFECTIVO'>P EFECT</th>"
	resultado = resultado & "<th class='ayuda' title='RECAUDACION CREDITO EFECTIVO(Prepago Voluntario)'>R EFECT</th>"
	resultado = resultado & "<th class='ayuda' title='RECAUDACION POR DISTRIBUIR'>R XDISTR</th>"
	resultado = resultado & "<th class='ayuda' title='PAGO CUENTA'>P CUENT</th>"
	resultado = resultado & "<th class='ayuda' title='RECARGA CELULAR'>REC CEL</th>"
	resultado = resultado & "<th class='ayuda' title='INGRESO A CAJA'>ING CAJA</th>"	
	resultado = resultado & "<th class='ayuda' title='TRASPASO A CAJA'>T CAJA</th>"
	resultado = resultado & "</tr>"
	resultado = resultado & "</thead>"
	resultado = resultado & "<tbody>"
	for i=0 to ubound(datos,2)
		'codSucursal = trim(datos(0,i))
		nombreSucursal = server.htmlencode(trim(datos(0,i)))
		pagos2 =trim(datos(1,i))
		ppaa =trim(datos(2,i))
		leasing =trim(datos(3,i))
		nominas =trim(datos(4,i))
		recCred =trim(datos(5,i))
		trasCaja =trim(datos(6,i))
		ingCaja =trim(datos(7,i))
		creSocial =trim(datos(8,i))
		reDistr =trim(datos(9,i))
		pagosAFP =trim(datos(10,i))
		pagosIPS =trim(datos(11,i))
		licencias =trim(datos(12,i))
		colCred =trim(datos(13,i))
		fecha = trim(datos(14,i))
		zonal = trim(datos(15,i))
		regional = trim(datos(16,i))
		recCel = trim(datos(17,i))
		recCelMonto = trim(datos(18,i))
		pagCuenta = trim(datos(19,i))
		pagCuentaMonto = trim(datos(20,i))

		resultado = resultado & "<tr>"
		'resultado = resultado & "<td>"&codSucursal&"</td>"
		resultado = resultado & "<td>"&nombreSucursal&"</td>"
		resultado = resultado & "<td>"&regional&"</td>"
		resultado = resultado & "<td>"&zonal&"</td>"
		resultado = resultado & "<td style='background: #CEFE9C;' class='numero'>"&pagosIPS&"</td>"
		resultado = resultado & "<td style='background: #C0E2FF;' class='numero'>"&pagosAFP&"</td>"
		resultado = resultado & "<td class='numero'>"&colCred&"</td>"
							
		resultado = resultado & "<td class='numero'>"&leasing&"</td>"
		resultado = resultado & "<td class='numero'>"&licencias&"</td>"
		resultado = resultado & "<td class='numero'>"&pagos2&"</td>"
		resultado = resultado & "<td class='numero'>"&ppaa&"</td>"	
		resultado = resultado & "<td class='numero'>"&nominas&"</td>"
		resultado = resultado & "<td class='numero'>"&creSocial&"</td>"	
		resultado = resultado & "<td class='numero'>"&recCred&"</td>"					
		resultado = resultado & "<td class='numero'>"&reDistr&"</td>"
		resultado = resultado & "<td class='numero'>"&pagCuenta&"</td>"
		resultado = resultado & "<td class='numero'>"&recCel&"</td>"
		resultado = resultado & "<td class='numero'>"&ingCaja&"</td>"
		resultado = resultado & "<td class='numero'>"&trasCaja&"</td>"					
		resultado = resultado & "</tr>"
	next
	resultado = resultado & "</tbody>"
	resultado = resultado & "</table>"
	response.write(resultado)
	diaFecha =  WeekDayName(WeekDay(fecha))
	dia = day(fecha)
	mesFecha = monthname(month(fecha))
	response.write("<span class='alert-info'>Datos correspondientes a la fecha: <strong>"&fecha&" ("&diaFecha&", "&dia&" de "&mesFecha&")</strong></span>")
else%>
<span class="label label-warning">Sin Registros.</span>
<%end if%>
<script type="text/javascript">
	$(function () {	
	try{
		$('.ayuda').tooltip();	
		$('#datatable').dataTable( {
			"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
			"sPaginationType": "bootstrap",
			"oLanguage": {
				"sLengthMenu": "_MENU_ registros por página",
				"sProcessing":     "Procesando...",
				"sZeroRecords":    "No se encontraron resultados",
				"sEmptyTable":     "Ningún dato disponible en esta tabla",
				"sInfo":           "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
				"sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
				"sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
				"sInfoPostFix":    "",
				"sSearch":         "Buscar:",
				"sUrl":            "",
				"sInfoThousands":  ",",
				"sLoadingRecords": "Cargando...",
				"oPaginate": {
					"sFirst":    "Primero",
					"sLast":     "Último",
					"sNext":     "Siguiente",
					"sPrevious": "Anterior"
				},
				"oAria": {
					"sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
					"sSortDescending": ": Activar para ordenar la columna de manera descendente"
				}
			},
		});
		$('.numero').prettynumber();
		//botonFoco();

		$('#datatable').on( 'draw.dt', function () {
			//alert('pesca')
			$('.numero').prettynumber();
		});
	}
	catch(err){}	
});

</script>