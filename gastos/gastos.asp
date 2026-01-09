<!--#include file="../funciones.asp"-->
<%perfil = trim(request("perfil"))
if perfil = "3" then%>
<div class="tabbable tabs-left">
  <ul class="nav nav-tabs zonales" data-idZonalActual="">
  <%sql = ""
  sql = sql & " select id_zonal, "
  sql = sql & " zonal, id_usuario "
  sql = sql & " from SUC_zonales "
  sql = sql & " where estado_zonal = 1 "
  sql = sql & " order by zonal "
  set rs = db.execute(sql)
  if not rs.eof then
    datos = rs.GetRows()
    for i = 0 to ubound(datos,2)
      idZonal = trim(datos(2,i))
      nombreZonal = server.htmlencode(trim(datos(1,i)))
      if i = 0 then
        clase = "active"
      else
        clase = ""
      end if%>
    <li class="<%=clase%> identificaZonal" data-idZonal="<%=idZonal%>">
      <a href="#<%=idZonal%>" data-toggle="tab">
        <%=nombreZonal%>
      </a>
    </li>
    <%next
  end if%>
  </ul>
  <div class="tab-content">
    <div id="menuGastos"></div>
  </div>
</div>
<script type="text/javascript">
$(function(){
  var zonalActual = $('.zonales').attr('data-idZonalActual');
  if (zonalActual=="")
  {
    var idZonal = $('.identificaZonal:first-child').attr('data-idZonal');
    $('.zonales').attr('data-idZonalActual',idZonal);
    seleccionaZonal();
  }
}).on('click','.identificaZonal',function(){
  var idZonal = $(this).attr('data-idZonal');
  $('.zonales').attr('data-idZonalActual',idZonal);
  seleccionaZonal();
});
function seleccionaZonal()
{
  var idZonal = $('.zonales').attr('data-idZonalActual');
  var pagina = 'gastos/menuGastos.asp';
  var div = 'menuGastos';
  var datos='idZonal='+idZonal;
  enviaDatos(pagina,div,datos);
}
</script>

<%end if%>