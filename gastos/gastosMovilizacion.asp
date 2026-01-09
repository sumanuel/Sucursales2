<!--#include file="../funciones.asp"-->
<%idZonal = trim(request("idZonal"))
idZonal = trim(request("idZonal"))
anioPpto = trim(request("anioPpto"))
mesPpto = trim(request("mesPpto"))
zonalMontoTotal = 0
zonalMonto1 = 0

sql = ""
sql = sql & " select isnull(sum(zonal_ppto_monto),0) "
sql = sql & " from SUC_zonales_ppto "
sql = sql & " where id_zonal = '"&idZonal&"' "
sql = sql & " and zonal_ppto_activo = 1 "
if mesPpto = "" then
	sql = sql & " and zonal_ppto_mes = month(GETDATE()) "
else
	if len(mesPpto) = 1 then mesPpto = "0"&mesPpto
	sql = sql & " and zonal_ppto_mes = '"&mesPpto&"' "
end if
if anioPpto = "" then
	sql = sql & " and zonal_ppto_ano = year(GETDATE()) "
else
	sql = sql & " and zonal_ppto_ano = '"&anioPpto&"' "
end if
sql = sql & "and id_zonal_ppto_tipo = 1 "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	for i = 0 to ubound(datos,2)
		zonalMonto1 = zonalMonto1 + clng(trim(datos(0,i)))
	next
end if
sql = ""
sql = sql & " select isnull(SUM(zonal_ppto_gasto),0) as totalGastoPresupuesto "
sql = sql & " from SUC_zonales_ppto_gastos "
sql = sql & " where id_zonal = '"&idZonal&"' "
if mesPpto = "" then
	sql = sql & " and zonal_ppto_gasto_mes = month(GETDATE()) "
else
	if len(mesPpto) = 1 then mesPpto = "0"&mesPpto
	sql = sql & " and zonal_ppto_gasto_mes = '"&mesPpto&"' "
end if
if anioPpto = "" then
	sql = sql & " and zonal_ppto_gasto_ano = year(GETDATE()) "
else
	sql = sql & " and zonal_ppto_gasto_ano = '"&anioPpto&"' "
end if
sql = sql & " and id_zonal_ppto_tipo = 1 "
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.GetRows()
	for i = 0 to ubound(datos,2)
		sumaTipo1 = sumaTipo1 + clng(trim(datos(0,i)))
	next
end if
diferencia = zonalMonto1 - sumaTipo1%>
<input type="hidden" name="idZonal" id="idZonal" value="<%=idZonal%>">
<div class="row-fluid">
	<div class="span12 well">
    <span class="span12 alert alert-success">
      <strong><h4><span id="loadIcon" style="display:none;"><i class="icon-spinner icon-spin icon-large"></i></span> <span class="icon-stack icon-large"><i class="icon-check-empty icon-stack-base"></i><i class="icon-legal"></i></span> Gastos</h4></strong>
</span>
		<span class="ingresaModal">
      <a class="btn btn-primary titulares_paso1"  href="#myModal" data-toggle="modal">
        <i class="icon-upload-alt icon-large"></i>Agregar Gasto</a>
      </span>
	</div>
</div>
<div class="row-fluid">
  <div class="span12" id="listadoGastos"></div>
</div>
<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Subir archivo</h3>
  </div>
  <div class="modal-body">
     <iframe id="ifrmUpload" src="gastos/agregarGasto.asp?idZonal=<%=idZonal%>" width="100%" height="100%" frameborder="0"></iframe>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Cerrar</button>
  </div>
</div>
<script type="text/javascript">
var pagina, div,datos
$(function(){
	var idZonal =$('#idZonal').val();
	pagina = 'gastos/listaGastos.asp';
	div='listadoGastos';
	datos='idZonal='+idZonal;
	try{
	       enviaDatos(pagina,div,datos);
	}catch(err){}
});
$('.ingresaModal').click(function(){
		var idZonal =$('#idZonal').val();
		$('#ifrmUpload').attr('src','gastos/agregarGasto.asp?idZonal='+idZonal);
	});
$('.modal-footer, .close').click(function(){
		var idZonal =$('#idZonal').val();
		pagina = 'gastos/listaGastos.asp';
		div='listadoGastos';
		datos='idZonal='+idZonal;
		try{
		       enviaDatos(pagina,div,datos);
		}catch(err){}
	});
</script>