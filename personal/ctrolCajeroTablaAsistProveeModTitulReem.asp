 <!--#include file="../funciones.asp"-->
 <%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
idSucursal = trim(request("idSucursal"))
tipoVista = trim(request("tipoVista"))

%>
 <div class="row-fluid">
     <div class="alert alert-info pagination pagination-centered">
        <h4>
            Detalle Sucursal
        </h4>
    </div>
 </div> 

<%if tipoVista = 1 then%>

<div class="row-fluid">
    <div class="row-fluid" id="butons_add">
        <div class="">
            <a class="btn btn-info addTitularAsistencia">
                <i class="icon-plus-sign icon-large"></i>
                &nbsp;&nbsp;Titular
            </a>
            &nbsp;
            <a class="btn btn-info addReemplazoAsistencia">
                <i class="icon-plus-sign icon-large"></i>
                &nbsp;&nbsp;Reemplazo
            </a>
        </div>
    </div>      
    <br>              
    <div class="row-fluid">
        <div class="oculto " id="div3"></div>
    </div>
</div>
<% else %>


<% end if %>
<!--<div class="row-fluid">                    
    <div class="span10 oculto" id="div4"></div>
</div>-->

<script type="text/javascript">

$(function () {
    $('.tool').tooltip();
}).on('click','.addTitularAsistencia',function(){
    var codBtt = $('#codbtt').val();
    var idSucursal = $('#sucursales').val();
    
    var div = 'div3';
    var pagina = 'personal_ingreso.asp?tipoPersonal=1&idSucursal='+idSucursal+'&codBtt='+codBtt+'&tipoVista=0';    
    enviaDatos(pagina,div,'');
    $('#div3').removeClass('oculto').fadeIn('slow');

}).on('click','.addReemplazoAsistencia',function(){    
    var codBtt = $('option:selected','#sucursales').attr('data-codbt');   
    var idSucursal = $('#sucursales').val();
    
    var div = 'div3';
    var pagina = 'personal_ingreso.asp?tipoPersonal=2&idSucursal='+idSucursal+'&codBtt='+codBtt+'&tipoVista=0';    
    enviaDatos(pagina,div,'');
    $('#div3').removeClass('oculto').fadeIn('slow');

})

</script>











