<!--#include file="../funciones.asp"-->
<%
perfil = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
idSucursal = trim(request("idSucursal"))
tipoVista = trim(request("tipoVista"))


  sql = ""
  sql = sql & " select suc_nombre, suc_direccion, suc_tipo, "
  sql = sql & " suc_jeps, suc_jeps_enexo, "
  sql = sql & " suc_jeps_celular, suc_zonal, suc_zonal_ext, "
  sql = sql & " cod_sap, cod_bantotal "
  sql = sql & " from SUC_sucursal "
  sql = sql & " where id_sucursal = '"&idSucursal&"'"
  'Response.Write(sql)
  set rs= db.execute(sql)
  if not rs.eof then
    nombreSucursal = server.HTMLEncode(trim(rs("suc_nombre")))
    direccionSucursal = server.HTMLEncode(trim(rs("suc_direccion")))
    nombreJeps = server.HTMLEncode(trim(rs("suc_jeps")))  
    anexoSucursal = trim(rs("suc_jeps_enexo"))
    celujarJeps = trim(rs("suc_jeps_celular"))
    nombreEncargadoZonal = server.HTMLEncode(trim(rs("suc_zonal")))
    nombreEncargadoZonal_Ext = server.HTMLEncode(trim(rs("suc_zonal_ext")))
    suc_tipo = server.HTMLEncode(trim(rs("suc_tipo")))
    codSAP = trim(rs("cod_sap"))
    codBTT = trim(rs("cod_bantotal"))
  end if  
%>
<style type="text/css">           
  
  .table-hover4 th {
       background-color: #D9E8FF;
       color:#0d0d0d;
    }
</style>
<div class="row-fluid">
     <div class="alert alert-info pagination pagination-centered">
        <h4>
            Detalle Sucursal
        </h4>
    </div>
 </div> 
<div>
    <table id="tablaCtrolCajeroTablaSucursalAsistencia" class="table table-bordered table-hover4" data-idSucursal="<%=idSucursal%>" data-tipoVista="<%=tipoVista%>" data-idUsuario="<%=idUsuario%>" data-perfil="<%=perfil%>">
        <tr>
            <th >Sucursal:</th>
            <td id="nombreSucursal"><%=nombreSucursal%> (<%=suc_tipo%>)</td>
            <th>Dirección</th>
            <td id="direccionSucursal"><%=direccionSucursal%></td>
            <th>Jeps</th>
            <td id="nombreJeps"><span class="label label-info"><%=nombreJeps%></span></td>
          </tr>
          <tr>
            <th>Anexo</th>
            <td id="anexoSucursal"><%=anexoSucursal%></td>
            <th>Celular</th>
            <td id="celujarJeps"><%=celujarJeps%></td>
            <th>Cod BTT</th>
            <td id="codBttAsistencia" data-codBtt="<%=codBTT%>"><%=codBTT%></td>
          </tr>
          <tr>
            <th>Cod SAP</th>
            <td id="codsap" ><%=codSAP%></td>
            <td></td>
            <td id="auditoria"></td>
            <td></td>
            <td id="aperturaSucursal"></td>
          </tr>
      </table>  
</div>  
<%
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing

DB.Close
set DB=nothing

if tipoVista = 1 then
%>
<div class="row-fluid text-center" id="butons_add">
  <a class="btn btn-info addTitularAsistencia" id="butons_add_Titular_Asistencia">
    <i class="icon-plus-sign icon-large"></i>
    &nbsp;&nbsp;Titular
  </a>
  &nbsp;
  <a class="btn btn-info addReemplazoAsistencia" id="butons_add_Reemplazo_Asistencia">
    <i class="icon-plus-sign icon-large"></i>
    &nbsp;&nbsp;Reemplazo
  </a>
</div>              
<div class="oculto row-fluid" id="div3"></div>
<% end if%>
<br>

<script type="text/javascript">
  var estBtn1 = 1;
  var estBtn2 = 1;
  var tipoVista = $('#tablaCtrolCajeroTablaSucursalAsistencia').attr('data-tipoVista');
    
  $(function (){

        var codBtt = $('#codBttAsistencia').attr('data-codBtt');
        var idUsuario = $('#codBttAsistencia').attr('data-idUsuario');
        var perfil = $('#codBttAsistencia').attr('data-perfil');
        var idSucursal = $('#tablaCtrolCajeroTablaSucursalAsistencia').attr('data-idSucursal');
        //se debe modificar consulta antes de pasar a periodo
        pagina = 'ctrolCajeroTablaSucursalAsitencia.asp';
        div = 'ctrolCajeroTablaSucursalAsist';
        if (tipoVista == 1){
        datos='idUsuario='+idUsuario+'&perfilMain='+perfil+'&idSucursal='+idSucursal+'&tipoVista='+tipoVista+'&codBtt='+codBtt;
        }else{
          datos='idUsuario='+idUsuario+'&perfilMain='+perfil+'&idSucursal='+idSucursal+'&tipoVista='+tipoVista+'&fecha='+fecha+'&codBtt='+codBtt;
        }        
        //console.log(datos);
        enviaDatos(pagina,div,datos);
  });


$('#butons_add_Titular_Asistencia').click(function(){  
    if (estBtn1 == 1){   
        if (estBtn2 == 2){
          estBtn2 = 1;
          $('#butons_add_Reemplazo_Asistencia').removeClass("btn-success");
          $('#butons_add_Reemplazo_Asistencia').addClass("btn-info");
        }   
        estBtn1 = 2;
        $(this).removeClass("btn-info");
        $(this).addClass("btn-success");
        var codBtt = $('#codBttAsistencia').attr('data-codBtt');
        var idUsuario = $('#codBttAsistencia').attr('data-idUsuario');
        var perfil = $('#codBttAsistencia').attr('data-perfil');
        var idSucursal = $('#tablaCtrolCajeroTablaSucursalAsistencia').attr('data-idSucursal');
        //console.log(codBtt);
        var div = 'div3';
        var pagina = 'personal_ingreso.asp?tipoPersonal=1&idSucursal='+idSucursal+'&codBtt='+codBtt+'&tipoVista=1';    
        enviaDatos(pagina,div,'');
        $('#div3').removeClass('oculto').fadeIn('slow');

        


    }else{
      estBtn1 = 1;      
      $(this).removeClass("btn-success");
      $(this).addClass("btn-info");
      $('#div3').html('');   
      $('#div3').addClass('oculto');
    }
    
});

$('#butons_add_Reemplazo_Asistencia').click(function(){    
  if (estBtn2 == 1){ 
    if (estBtn1 == 2){
      estBtn1 = 1; 
      $('#butons_add_Titular_Asistencia').removeClass("btn-success");
      $('#butons_add_Titular_Asistencia').addClass("btn-info");
    }     
    estBtn2 = 2;
    $(this).removeClass("btn-info");
    $(this).addClass("btn-success"); 
    
    var codBtt = $('#codBttAsistencia').attr('data-codBtt');
    var idSucursal = $('#tablaCtrolCajeroTablaSucursalAsistencia').attr('data-idSucursal');
    
    var div = 'div3';
    var pagina = 'personal_ingreso.asp?tipoPersonal=2&idSucursal='+idSucursal+'&codBtt='+codBtt+'&tipoVista=1';    
    enviaDatos(pagina,div,'');
    $('#div3').removeClass('oculto').fadeIn('slow');
  }else{
    estBtn2 = 1;      
    $(this).removeClass("btn-success");
    $(this).addClass("btn-info");
    $('#div3').html('');   
    $('#div3').addClass('oculto');
  }
});


</script>


