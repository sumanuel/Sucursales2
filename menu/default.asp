<div class="row-fluid">
      <div class="span12">
            <ul class="nav nav-tabs" id="menuTab">    
                  <li  class="active" id="tabMenu1">
                        <a href="#">
                              <i class="icon-fixed-width icon-home"></i>
                              Inicio
                        </a>
                  </li>
                  <!--<li id="tabMenuVisitas"><a href="#"><i class="icon-fixed-width icon-pushpin"></i>Visitas</a></li>
                  <li id="tabMenuCostos"><a href="#"><i class="icon-fixed-width icon-home"></i>Costos</a></li>-->
                  <li id="informes">
                        <a href="#">
                              <i class="icon-fixed-width icon-list-alt"></i>
                              Informes
                        </a>
                  </li>
                  <!--<li id="CheckList">
                        <a href="#">
                              <i class="icon-fixed-width icon-list-alt"></i>
                              CheckList Crédito
                        </a>
                  </li>-->
                  <li id="Reporte">
                        <a href="#">
                              <i class="icon-fixed-width icon-list-alt"></i>
                              Integración
                        </a>
                  </li>    
                  <li id="transacciones">
                        <a href="#">
                              <i class="icon-fixed-width icon-road"></i>
                              Transacciones
                        </a>
                  </li>
                  <!--<li id="gastosZon">
                        <a href="#">
                              <i class="icon-fixed-width icon-compass"></i>
                              Gastos
                        </a>
                  </li>-->        
                  <li id="opPersonal">
                        <a href="#">
                              <i class="icon-fixed-width icon-user"></i>
                              Personal Externo
                        </a>
                  </li>
                  
                 
                  <!--<li id="gastosGer">
                        <a href="#">
                              <i class="icon-fixed-width icon-compass"></i>
                              Gastos
                        </a>
                  </li>-->
                  <li id="opPersonalInt">
                        <a href="#">
                              <i class="icon-fixed-width icon-user"></i>
                              Personal Interno
                        </a>
                  </li>
                  <!--<li id="dash">
                        <a href="#">
                              <i class="icon-fixed-width icon-dashboard"></i>
                              Panel en línea
                        </a>
                  </li>-->
                  <li id="opSucursales">
                        <a href="#">
                              <i class="icon-fixed-width icon-list-alt"></i>
                              Sucursales
                        </a>
                  </li>
                  <li id="opEspecial">
                        <a href="#">
                              <i class="icon-fixed-width icon-cogs"></i>
                              Control Maestro Pagos
                        </a>
                  </li>
                  <!--<li id="activos">
                        <a href="#">
                              <i class="icon-fixed-width icon-building"></i>
                              Activos
                        </a>
                  </li>-->
                  <li id="dashDivision">
                        <a href="#">
                              <i class="icon-fixed-width icon-dashboard"></i>
                              Panel en línea
                        </a>
                  </li>
                  <li id="opPersonalDivision">
                        <a href="#">
                              <i class="icon-fixed-width icon-user"></i>
                              Personal Externo
                        </a>
                  </li>
                  <li id="opPersonalIntDivision">
                        <a href="#">
                              <i class="icon-fixed-width icon-user"></i>
                              Personal Interno
                        </a>
                  </li>
                  <li id="opSucursalesDivision">
                        <a href="#">
                              <i class="icon-fixed-width icon-list-alt"></i>
                              Sucursales
                        </a>
                  </li>
                  <li id="logOut" class="pull-right">
                        <a href="#">
                              <i class="icon-fixed-width icon-signout"></i> 
                              Salir
                        </a>
                  </li>
            </ul>
      </div>
</div>
<script type="text/javascript">
      $(function(){
           var perfil = $('#perfilMain').val();
           if (perfil ==='1')
           {
                  $('#dash,#opPersonalInt,#opPersonal,#opSucursales,#opEspecial,#dashDivision,#opPersonalDivision,#opPersonalIntDivision,#opSucursalesDivision,#transacciones').remove();
           }
           if (perfil ==='2')
           {
                  $('#dash,#dashDivision,#opPersonalDivision,#opPersonalIntDivision,#opSucursalesDivision,#activos').remove();
           }
           if (perfil ==='3')
           {
                  $('#dashDivision,#opPersonalDivision,#opPersonalIntDivision,#opSucursalesDivision,#activos').remove();
           }
           if (perfil ==='4')
            {
                  $('#informes,#transacciones,#opPersonal,#activos,#dash,#opPersonalInt,#opSucursales,#opEspecial,#CheckList,#Reporte').remove();
            }
            if (perfil ==='55')
            {
                  $('#informes,#transacciones,#activos,#dash,#opPersonalInt,#opSucursales,#opEspecial,#dashDivision,#opPersonalDivision,#opPersonalIntDivision,#opSucursalesDivision,#CheckList').remove();
            }
            if (perfil ==='66')
            {
                  $('#informes,#transacciones,#activos,#dash,#opPersonalInt,#opSucursales,#opEspecial,#dashDivision,#opPersonalDivision,#opPersonalIntDivision,#opSucursalesDivision,#CheckList').remove();
            }
      });
      $('#opEspecial').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            sube();
            $(this).addClass('active');
            pagina = 'maestroPagos/listaEspecial.asp';
            if (perfil ==='2')
            {
                  $('#sucursalesZonal').slideUp('fast');
                  $('#divDetalleSucursales').removeClass('oculto').show();
                  div = 'detalleSucursales';      
            }
            if (perfil ==='3')
            {
                  div = 'areaTrabajoGer';
            }
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
                  $('#'+div).slideDown('slow');
                  
            }
            catch(err){}
      });
      $('#divIncidencias').click(function(){
            pagina = 'incidencias/muestraIncidenciasZonal.asp';
            div = 'trabajoZonal';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
            }
            catch(err){}
            if ($('#estadoSucursalesZonal').hasClass('span5'))
            {
                  $('#estadoSucursalesZonal').remove();
                  $('#trabajoZonal')
                  .addClass('span10')
                  .removeClass('span5');  
                  setTimeout(function() {
                        $('.botonVuelveZon')
                        .html('Cerrar <i class="icon-remove"></i>')
                        .removeClass('botonVuelveZon')
                        .addClass('botonCierraZon quitaDivZon');
                  }, 100);
            }
            
      });
      $('#logOut').click(function(){
            location.href="verificaUsuario/salir.asp";      
      });
      $('#gastosZon').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $(this).addClass('active');
            sube();
            $('#gastosIndices')
            .removeClass('oculto')
            .slideDown('slow');
            var pagina = 'gastos/menuGastosZonal.asp';
            var div = 'gastosZonal';
            var datos='';
            try{
                   enviaDatos(pagina,div,datos);
            }catch(err){}     
      });
      $('#informes').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $('#informes').addClass('active');
            sube();
            pagina = 'informes/informes.asp';
            div = 'areaInformes';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
            }
            catch(err){}
      });
      $('#dash').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $('#dash').addClass('active');
            sube();
            pagina = 'dashboard/dash.asp';
            div = 'dashGer';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
                  $('#areaDashGer').slideDown('slow');
                  
            }
            catch(err){}
      });
      $('#dashDivision').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $('#dashDivision').addClass('active');
            pagina = 'dashboard/dash.asp';
            div = 'areaDivisional';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
                  
            }
            catch(err){}
      });      

      $('#transacciones').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $('#transacciones').addClass('active');
            sube();
            pagina = 'transacciones/transacciones.asp';
            div = 'transaccionesGer';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
                  $('#areaTransacciones').slideDown('slow');
                  
            }
            catch(err){}      
      });
      $('#activos').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $(this).addClass('active');
            sube();
            pagina = 'activos/activos.asp';
            div = 'areaInformes';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);       
            }
            catch(err){}
            $('#areaInformes').slideDown('slow');
      });
      $('#gastosGer').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $(this).addClass('active');
            sube();
            pagina = 'gastos/gastos.asp';
            div = 'gastosGerEspacio';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
                  $('#areaGastosGer').slideDown('slow');
                  
            }
            catch(err){}
      });
      $('#opPersonal').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $(this).addClass('active');
            sube();
            pagina = 'personal/personal.asp';
            div = 'personalGer';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
                  $('#personalGer').slideDown('slow');
                  
            }
            catch(err){}
      });
      $('#opPersonalInt').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $(this).addClass('active');
            sube();
            pagina = 'personal/personal_int.asp';
            div = 'personalGer';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
                  $('#personalGer').slideDown('slow');
                  
            }
            catch(err){}      
      });
      $('#CheckList').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $('#CheckList').addClass('active');            
            sube();
            pagina = 'CheckListCredito/CheckListCredito.asp';
            div = 'checkListGer';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
                  $('#checkListGer').slideDown('slow');
                  
            }
            catch(err){}      
      });

      $('#Reporte').click(function() {
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $('#Reporte').addClass('active');
            sube();
            pagina = 'report/reporte.asp';
            div='reporteGer';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
                  $('#reporteGer').slideDown('slow');

            }
            catch(err){}
       });
      $('#opSucursales').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $(this).addClass('active');
            sube();
            pagina = 'sucursales/listaSucursales_detalle.asp';
            div = 'personalGer';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
                  $('#personalGer').slideDown('slow');
                  
            }
            catch(err){}      
      });
      $('#opPersonalDivision').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $(this).addClass('active');
            pagina = 'personal/personal.asp';
            div = 'areaDivisional';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
                  $('#personalGer').slideDown('slow');
                  
            }
            catch(err){}
      });
      $('#opPersonalIntDivision').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $(this).addClass('active');
            pagina = 'personal/personal_int.asp';
            div = 'areaDivisional';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
                  $('#personalGer').slideDown('slow');
                  
            }
            catch(err){}
      });      

      $('#opSucursalesDivision').click(function(){
            $('ul#menuTab li').each(function(){
                  $(this).removeClass('active');
            });
            $(this).addClass('active');
            pagina = 'sucursales/listaSucursales_detalle.asp';
            div = 'areaDivisional';
            datos='';
            try{
                  enviaDatos(pagina,div,datos);
                  $('#personalGer').slideDown('slow');
                  
            }
            catch(err){}
      });
      $('#tabMenu1').click(function(){
            $('#valores').submit();
      });
</script>