<!--#include file="../funciones2.asp"-->
<%
idUsuario =request("idUsuarioMain") 
idSucursal=request("idSucursalMain")  
idPerfil= request("perfilMain") 

%>
<div class="row-fluid" id="frmAddCaso">
  <div id="divAddCaso">
      <span class="span12">
        <input type="hidden" name="v_idSucursal" id="v_idSucursal" value="<%=idSucursal%>"/>
        <input type="hidden" name="idUsuario" id="idUsuario" value="<%=idUsuario%>"/>
        <span class="label label-info"><i class="icon-book"></i><span style="font-size: 10px"><strong> AGREGAR CASO</strong></span></span>
        <form class="form-horizontal">
            <input type="hidden" id="v_rutPersonal"></input>
            <div class="control-group">
              <label class="control-label" for="casoTitulo">Desc. Breve</label>
              <div class="controls">
                <input type="text" id="casoTitulo" placeholder="titulo">
              </div>
            </div>

            <div class="control-group">
            <%
               sql = ""
               sql = sql & "SELECT "
               sql = sql & "id_caso_categoria, "
               sql = sql & "caso_cod_categoria, "
               sql = sql & "caso_categoria "
               sql = sql & "FROM SUC_casos_config_categoria "
               sql = sql & "WHERE caso_categoria_activo = 1"

               set rsCat = db.execute(sql)
            %>    

              <label class="control-label" for="casoCategoria">Categoria</label>
              <div class="controls">
                <select id="casoCategoria" class="casoCategoria">
                  <option value="0">--- Seleccione Categoria ---</option>
                  <%
                     if not rsCat.eof then
                     do while not rsCat.eof
                  %>
                    <option value="<%=rsCat("id_caso_categoria")%>"><%=rsCat("caso_categoria")%></option>
                  <%
                    rsCat.MoveNext
                    loop 
                    end if 
                    rsCat.Close
                    set rsCat.ActiveConnection = nothing
                    set rsCat=nothing
                  %>     
                </select>
              </div>
            </div>

            <div class="control-group">            
              <label class="control-label" for="casoMotivo">Motivos</label>
              <div class="controls">
                <select class="casoMotivo" id="casoMotivo">
                    <option value="0">--- Seleccione Motivo ---</option>                 
                </select>
              </div>
            </div>

            <div class="control-group oculto" id="cajerosRelacionadosHead">
              <label class="control-label" for="casoMotivo">&nbsp;</label>
              <div class="controls">
                <label class="label label-info">CAJERO RELACIONADO</label>
                <div id="cajerosRelacionados"></div>
                <div id="cajerosSeleccionado">
                    <table class="table table-bordered table-condensed" id="tbl_cajerosSeleccionado">
                    <thead>
                      <tr>
                        <th>RUT</th>
                        <th>NOMBRE</th>
                        <th>CARGO</th>
                        <th>TIPO</th>
                        <th>EMPRESA</th>
                      </tr>
                    </thead>
                        <tbody>                        
                        </tbody>
                    </table>
                </div>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label" for="casoObs">Observación</label>
              <div class="controls">
                <textarea id="casoObs" style="margin: 0px; width: 754px; height: 88px;"></textarea>
              </div>
            </div>

            <div class="control-group">
              <div class="controls">          
                <a class="btn btn-primary addCasoSave"><i class="icon-save"></i> <span style="font-size: 10px"><strong>GUARDAR</strong></span></a>
              </div>
            </div>

        </form>
      </span>
  </div>
  <div id="divAddCasoSucces"></div>
  <div id="divCasoDetalle"></div>
</div>
<script type="text/javascript">
  var cleanAddCasoForm = function() {

    $('#cajerosRelacionados').html('');    
    $("#tbl_cajerosSeleccionado").find("tr:gt(0)").remove();
    $('#cajerosRelacionadosHead').slideUp();
    $('#cajerosSeleccionado').slideUp();

    $("#casoCategoria option:first").attr('selected','selected');
    $("#casoMotivo option:first").attr('selected','selected');
    $('#v_rutPersonal').val('');

    $('#casoTitulo').val('');
    $('#casoObs').val('');
 }
 

 $('.addCasoSave').click(function(){
    var idUsuario = $("#idUsuario").val();
    var idSucursal =  $('#v_idSucursal').val();  
    var casoTitulo = $('#casoTitulo').val();
    var idCat = $('#casoCategoria').val();
    var idMot = $('#casoMotivo').val();
    var casoObs = $('#casoObs').val();
    var rutPersonal = $('#v_rutPersonal').val();

    var pagina = 'sucursales/atencionCliente_sql.asp';
    var datos = 'tipo=3&idCat='+idCat+'&idMot='+idMot+'&casoTitulo='+casoTitulo+'&casoObs='+casoObs+'&idSucursal='+idSucursal+'&rutPersonal='+rutPersonal+'&idUsuario='+idUsuario;
    
    $('#divAddCaso').slideUp();
    $('#divAddCasoSucces').html('<div class="alert alert-success"><i class="icon-save icon-large"></i> <b>GUARDANDO CASO</b><img src="img/loader.gif"/></div>');
    $('#divAddCasoSucces').slideDown();

    //alert('datos: ' + datos);
    $.ajax({
        url: pagina,
        data: datos,
        type: "GET",
        dataType: "html",
        cache:false,
        //async:true,
        timeout:120000,
        success: function(source){                                
        },
        error: function(source){
          alert('error');
        }
    });

    setTimeout(function(){
      $('#divAddCasoSucces').html('<div class="alert alert-success"><i class="icon-ok icon-large"></i> <strong>INGRESO OK</strong></div>');
      setTimeout(function(){
          var pagina,div,datos;
          $('li#btnVerCasosReclamo').addClass('active');
          $('li#btnAgregarCasoReclamo').removeClass('active');

          var pagina, div, datos,canal;   
          var idSucursal = $('#v_idSucursal').val();  
          
          pagina = 'sucursales/reclamoTablaDetalle.asp';
          div = 'divAreaTrabajoReclamo';
          datos= 'idSucursal='+ idSucursal;
          enviaDatos(pagina,div,datos); 
      }, 1000);
    }, 3000);
 });
$('.casoMotivo').change(function(){ 
    var idSucursal =  $('#v_idSucursal').val();   
    var data_flagreqcajero = $('option:selected', this).attr('data-flagreqcajero');
    var categoriaSelect = $('select#casoCategoria option:selected').val();
    
    if(data_flagreqcajero == '1' && categoriaSelect == '1'){
        var pagina = 'sucursales/atencionCliente_sql.asp';
        var datos = 'tipo=5&idSucursal='+idSucursal;

        $.ajax({
            url: pagina,
            data: datos,
            type: "GET",
            dataType: "html",
            cache:false,
            //async:true,
            timeout:120000,
            success: function(source){
              $('#cajerosRelacionados').html(source);              
              $('#cajerosRelacionados').slideDown();
              $('#cajerosRelacionadosHead').slideDown();

              $("#tbl_cajerosSeleccionado").find("tr:gt(0)").remove();      
              $('#cajerosSeleccionado').slideUp();
              $('#v_rutPersonal').val('');
            },
            error: function(source){
              alert('error');
            }
        });
    }
    else
    {
      $('#cajerosRelacionadosHead').slideUp();
      $("#tbl_cajerosSeleccionado").find("tr:gt(0)").remove();
      $('#cajerosSeleccionado').slideUp();      
      $('#v_rutPersonal').val('');
    }
 });

$('.casoCategoria').change(function(){
    //alert($(this).val());


    var idCat = $(this).val();
    $('.casoMotivo')
        .find('option')
        .remove()
        .end()
        .append('<option data-flagreqcajero="0" value="0">--- Seleccione Motivo ---</option>')
        .val('0');

    var pagina = 'sucursales/atencionCliente_sql.asp';
    var datos = 'tipo=2&idCat='+idCat;
    $.ajax({
        url: pagina,
        data: datos,
        type: "GET",
        dataType: "json",
        cache:false,
        //async:true,
        timeout:120000,
        success: function(source){          
          $.each(source.datos,function(index,item){
             $('.casoMotivo').append('<option data-flagReqcajero="'+item.caso_flag_reqcajero+'" value="'+item.id_caso_motivo+'">'+item.caso_motivo+'</option>');
          });

          $('#cajerosRelacionadosHead').slideUp();
          $("#tbl_cajerosSeleccionado").find("tr:gt(0)").remove();
          $('#cajerosSeleccionado').slideUp();      
          $('#v_rutPersonal').val('');

        },
        error: function(source){
          alert('error');
        }
    });



 });

</script>