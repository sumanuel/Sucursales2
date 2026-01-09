<!--#include file="../funciones.asp"-->
<div class="row-fluid">
  <div class="span12">
    <ul class="nav nav-tabs nav-stacked span6 seleccionaSucursal">
    <%tipo = trim(request("tipo"))
    perfil = trim(request("perfil"))
    idUsuario = trim(request("idUsuario"))
    sql = ""
    sql = sql & " select count(id_sucursal) as totalSucursales"
    sql = sql & " from suc_sucursal "
    sql = sql & " where id_sucursal in "
    sql = sql & " (select id_sucursal "
    sql = sql & " from SUC_usuario_sucursal "
    sql = sql & " where id_usuario = '"&idUsuario&"')"
    set rs = db.execute(sql)
    if not rs.eof then
      totalSucursales= clng(trim(rs("totalSucursales")))
    end if
    totalSucursales = round(totalSucursales / 2) 
    sql = ""
    sql = sql & " select id_sucursal,"
    sql = sql & " suc_nombre "
    sql = sql & " from suc_sucursal "
    sql = sql & " where id_sucursal in "
    sql = sql & " (select id_sucursal "
    sql = sql & " from SUC_usuario_sucursal "
    sql = sql & " where id_usuario = '"&idUsuario&"')"
    set rs = db.execute(sql)
    i= 0
    do while not rs.eof
      i= i+1
      nombreSucursal = server.htmlencode(trim(rs("suc_nombre")))
      idSucursal = trim(rs("id_sucursal"))%>
      <li id="sucursalZonal<%=idSucursal%>" class="seleccionaSucursalZonal" data-idSucursal="<%=idSucursal%>">
        <a href="#"  >
          <%=nombreSucursal%>
          
        </a>
        </li>
      <%rs.movenext
      if i = totalSucursales then%>
        </ul>
        <ul class="nav nav-tabs nav-stacked span6">
      <%end if
    loop
    rs.Close
    set rs.ActiveConnection = nothing
    set rs=nothing
    DB.Close
    set DB=nothing%>
    </ul>
  </div>
</div>
<script type="text/javascript">
$('.seleccionaSucursalZonal').click(function(){
  var pagina,div,datos
  var idSucursal = $(this).attr('data-idSucursal');
  pagina = 'sucursales/sucursalZonal.asp';
  div = 'areaZonal';
  datos = 'sucursal='+idSucursal
  enviaDatos(pagina,div,datos);
});
</script>