<!--#include file="../funciones.asp"-->
<div class="row-fluid" id="divEstados">
  <div class="span12">
    <ul class="nav nav-tabs nav-stacked span6 listado">
    <%tipo = trim(request("tipo"))
    perfil = trim(request("perfilMain"))
    idUsuario = trim(request("idUsuarioMain"))

    sqlPerfil = ""
    if perfil = "55" then 	
    	sqlPerfil = sqlPerfil & " (select id_sucursal "
    	sqlPerfil = sqlPerfil & " from SUC_zonales_comercial_sucursal "
    	sqlPerfil = sqlPerfil & " where id_zonal = '"&idUsuario&"')"
    elseif perfil = "66" then 	
    	sqlPerfil = sqlPerfil & " (select id_sucursal "
    	sqlPerfil = sqlPerfil & " from SUC_zonales_comercial_mas_sucursal "
    	sqlPerfil = sqlPerfil & " where id_zonal = '"&idUsuario&"')"
    else 
    	sqlPerfil = sqlPerfil & " (select id_sucursal "
    	sqlPerfil = sqlPerfil & " from SUC_usuario_sucursal "
    	sqlPerfil = sqlPerfil & " where id_usuario = '"&idUsuario&"')"
    end if

    sql = ""
    sql = sql & " select count(id_sucursal) as totalSucursales"
    sql = sql & " from suc_sucursal "
    sql = sql & " where suc_estado = 1 and id_sucursal in "
    sql = sql & sqlPerfil
    set rs = db.execute(sql)
    if not rs.eof then
      totalSucursales= clng(trim(rs("totalSucursales")))
    end if
    totalSucursales = round(totalSucursales / 2) 

    sql = ""
    sql = sql & " select id_sucursal"
    sql = sql & " from suc_sucursal "
    sql = sql & " where suc_estado = 1 and id_sucursal in "
    sql = sql & sqlPerfil
    'response.write(sql)
    set rs = db.execute(sql)
    if not rs.eof then
      datos = rs.getrows()
    end if
    for i = 0 to ubound(datos,2)
      idSucursal = trim(datos(0,i))%>
      <li id="sucursalZonal<%=idSucursal%>" data-idSucursal="<%=idSucursal%>" class="seleccionaSucursalZonal">
        <a href="#">
          <span id="nombreSucursalLiZonal<%=idSucursal%>"></span>
           <span id="botonesSucursales<%=idSucursal%>" class="botonesSucursales oculto">
              <span id="plazoBtn<%=idSucursal%>" class="ayuda" data-placement="top"></span>
              <span id="situacionBtn<%=idSucursal%>" class="ayuda" data-placement="top"></span>
              <!--<span id="situacionAFPBtn<%=idSucursal%>" class="ayuda" data-placement="top"></span>
              <span id="situacionIPSBtn<%=idSucursal%>" class="ayuda" data-placement="top"></span>-->
            </span>
          </span>
          <span class="pull-right situacion<%=idSucursal%> ayuda " data-placement="top">
            <!--<span id="situacionNormal<%=idSucursal%>"></span>
            <span id="situacionAFP<%=idSucursal%>"></span>
            <span id="situacionIPS<%=idSucursal%>"></span>-->
          </span>
        </a>
      </li>
      <%if i = totalSucursales-1 then%>
        </ul>
        <ul class="nav nav-tabs nav-stacked span6 listado">
      <%end if
    next%>
    </ul>
  </div>
</div>
<div id="sucursalSeleccionada" class="oculto" data-idSucursal="">
  <span id="textoSucursalSeleccionada"></span>  
  <span class="btn btn-primary btn-mini pull-right" id="botonCierraSucursalSeleccionada"><i class="icon-collapse"></i>  Cerrar</span>
</div>
<script type="text/javascript">
$(function () {
  var perfil = $('#perfilMain').val();
  var idUsuario = $('#idUsuarioMain').val();
  $('.ayuda').tooltip();
  url='sucursales/datosEstadoSucursal.asp?perfil='+perfil+'&idUsuario='+idUsuario;
  $.when($.ajax(url)).then(function(data) {
    $.each( data.dataAperturaSucursales, function( key, valoresSucursales ) {
      var boton, plazo, hora, situacionDerecha;
      var nombreSucursal = valoresSucursales.nombreSucursal;
      var idSucursal = valoresSucursales.idSucursal;
      var sucursalAbierta = valoresSucursales.sucursalAbierta;
      var clasePlazo = valoresSucursales.clasePlazo;
      var textoPlazo = valoresSucursales.textoPlazo;
      var situacionSucursalNormal = valoresSucursales.situacionSucursalNormal;
      var situacionSucursalHoraNormal = valoresSucursales.situacionSucursalHoraNormal;
      var claseSituacionNormal = valoresSucursales.claseSituacionNormal;
      var situacionSucursalAFP = valoresSucursales.situacionSucursalAFP;
      var situacionSucursalHoraAFP = valoresSucursales.situacionSucursalHoraAFP;
      var claseSituacionAFP = valoresSucursales.claseSituacionAFP;
      var situacionSucursalIPS = valoresSucursales.situacionSucursalIPS;
      //console.log("IPS: "+situacionSucursalIPS);
      var situacionSucursalHoraIPS = valoresSucursales.situacionSucursalHoraIPS;
      var claseSituacionIPS = valoresSucursales.claseSituacionIPS;
      var nombreSucursalSinCaract = valoresSucursales.nombreSucursalSinCaract;
      $('#nombreSucursalLiZonal'+idSucursal).html(nombreSucursal);
      if (sucursalAbierta === '0')
      {
        $('.situacion'+idSucursal).html(situacionSucursalNormal).addClass(claseSituacionNormal);
        $('#sucursalZonal'+idSucursal).attr('data-abierta', '0');
      }
      else
      {
        var plazo = '<span class="label '+clasePlazo+' horaIngreso">A: '+textoPlazo+'</span>   ';
        $('#botonesSucursales'+idSucursal).attr('data-idSucursal', idSucursal);
        $('#plazoBtn'+idSucursal).html(plazo);
        $('#sucursalZonal'+idSucursal).attr('data-abierta', '1');

        var total = 0
        var horaNormal = situacionSucursalHoraNormal;
        var horaAFP = situacionSucursalHoraAFP;
        var horaIPS = situacionSucursalHoraIPS;
        var valores = '';
        var segNormal = 0
        var segAFP = 0
        var segIPS = 0
        if (situacionSucursalNormal !== ""){
            total = total + 1; 
            valores = valores+";"+situacionSucursalNormal+","+horaNormal.replace(":","").replace(":","");
            segNormal = 1;
             //$('#situacionNormal'+idSucursal).html(situacionSucursalNormal).addClass(claseSituacionNormal);
        }
        if (situacionSucursalAFP !== ""){
            total = total + 1;
            valores = valores+";"+"AFP"+","+horaAFP.replace(":","").replace(":","");
            //$('#situacionAFP'+idSucursal).html('AFP').addClass(claseSituacionAFP);
            segAFP = 1;
        }
        if (situacionSucursalIPS !== ""){
            total = total + 1;
            valores = valores+";"+"IPS"+","+horaIPS.replace(":","").replace(":","");
            //$('#situacionIPS'+idSucursal).html('IPS').addClass(claseSituacionIPS);
            segIPS = 1;
        }
          valores = valores.substring(1,valores.length);
          
          if (total === 1){
            arregloValores = valores.split(";");
            var val1 = arregloValores[0];
            var arreglo = val1.split(",");
            var valEstado = arreglo[0];
            var valHora = arreglo[1];
            //console.log(valHora);
            if(segNormal === 1){
              $('.situacion'+idSucursal).html('<span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado+'</span>');
              
              $('#situacionBtn'+idSucursal).html('<span id="situacionBtnNormal" class="'+claseSituacionNormal+'">'+valEstado+'</span>').attr('data-original-title', situacionSucursalHoraNormal);

            }else if(segIPS === 1){
              $('.situacion'+idSucursal).html('<span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado+'</span>');
              
              $('#situacionBtn'+idSucursal).html('<span id="situacionBtnIPS" class="'+claseSituacionIPS+'">'+valEstado+'</span>').attr('data-original-title', situacionSucursalHoraIPS);

            }else if(segAFP === 1){
              $('.situacion'+idSucursal).html('<span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado+'</span>');
              
              $('#situacionBtn'+idSucursal).html('<span id="situacionBtnAFP" class="'+claseSituacionAFP+'">'+valEstado+'</span>').attr('data-original-title', situacionSucursalHoraAFP);
            }
  
          }
          if (total === 2){
            //var totalEstado = valEstado2 + valEstado1;
            //console.log(totalEstado);
            var arregloValores = valores.split(";");
            var val1 = arregloValores[0];
            var val2 = arregloValores[1];
            var arreglo1 = val1.split(",");
            var arreglo2 = val2.split(",");
            //Normal o IPS o AFP
            var valEstado1 = arreglo1[0]; 
            var valEstado2 = arreglo2[0];
            var valHora1 = arreglo1[1]; 
            var valHora2 = arreglo2[1];

          //if (parseInt(idSucursal) === 164){
            if (segNormal === 1 && segAFP === 1){
               //console.log("1");
               //console.log(valEstado1+'-'+valHora1);
               //console.log(valEstado2+'-'+valHora2);
              if(parseInt(valHora1) > parseInt(valHora2)){
                 $('.situacion'+idSucursal).html('<span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span> <span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span>');
                  
                  $('#situacionBtn'+idSucursal).html('<span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span> <span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span>').attr('data-original-title', situacionSucursalHoraAFP+' -- '+situacionSucursalHoraNormal);
                //console.log("1.1");
              }else{
                 $('.situacion'+idSucursal).html('<span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span> <span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span> ');
                 
                 $('#situacionBtn'+idSucursal).html('<span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span> <span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span>').attr('data-original-title', situacionSucursalHoraNormal+' -- '+situacionSucursalHoraAFP);
              }
              
            }else if (segAFP === 1 && segIPS === 1){

              if(parseInt(valHora1) > parseInt(valHora2)){     
                 $('.situacion'+idSucursal).html('<span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado2+'</span> <span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado1+'</span>');

                $('#situacionBtn'+idSucursal).html('<span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado2+'</span> <span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado1+'</span>').attr('data-original-title', situacionSucursalHoraIPS+' -- '+situacionSucursalHoraAFP);

              }else{
                  $('.situacion'+idSucursal).html('<span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado1+'</span> <span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado2+'</span>');

                  $('#situacionBtn'+idSucursal).html('<span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado1+'</span> <span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado2+'</span>').attr('data-original-title', situacionSucursalHoraAFP+' -- '+situacionSucursalHoraIPS);
              }
            }else if (segNormal === 1 && segIPS === 1){
              if(parseInt(valHora1) > parseInt(valHora2)){
                  $('.situacion'+idSucursal).html('<span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado2+'</span> <span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span>');

                  $('#situacionBtn'+idSucursal).html('<span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado2+'</span> <span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span>').attr('data-original-title',situacionSucursalHoraIPS+' -- '+situacionSucursalHoraNormal);

              }else{
                  $('.situacion'+idSucursal).html('<span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span> <span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado2+'</span>');

                  $('#situacionBtn'+idSucursal).html('<span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span> <span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado2+'</span>').attr('data-original-title',situacionSucursalHoraNormal+' -- '+situacionSucursalHoraIPS);
              }
            }       
          }

        //if (parseInt(idSucursal) === 59){
          if (total === 3){
            var arregloValores = valores.split(";");
            var val1 = arregloValores[0];
            var val2 = arregloValores[1];
            var val3 = arregloValores[2];
            var arreglo1 = val1.split(",");
            var arreglo2 = val2.split(",");
            var arreglo3 = val3.split(",");
            //normal - IPS - AFP 
            var valEstado1 = arreglo1[0];
            var valEstado2 = arreglo2[0];
            var valEstado3 = arreglo3[0];
            var valHora1 = arreglo1[1];
            var valHora2 = arreglo2[1];
            var valHora3 = arreglo3[1];

            if(parseInt(valHora1) > parseInt(valHora2) && parseInt(valHora1) > parseInt(valHora3)){
              if (parseInt(valHora2) > parseInt(valHora3)){
              //console.log("1.2");
              $('.situacion'+idSucursal).html('<span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado3+'</span> <span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span> <span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span>');
              //console.log(valEstado3+'-'+valEstado2+'-'+valEstado1);
              
              $('#situacionBtn'+idSucursal).html('<span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado3+'</span> <span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span> <span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span>').attr('data-original-title', situacionSucursalHoraIPS+' -- '+situacionSucursalHoraAFP+' -- '+situacionSucursalHoraNormal);

              }else{
              //console.log("1.3");
              $('.situacion'+idSucursal).html('<span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span> <span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado3+'</span> <span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span>');
              //console.log(valEstado2+'-'+valEstado3+'-'+valEstado1);
                
              $('#situacionBtn'+idSucursal).html('<span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span> <span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado3+'</span> <span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span>').attr('data-original-title',situacionSucursalHoraAFP+' -- '+situacionSucursalHoraIPS+' -- '+situacionSucursalHoraNormal);
              }
            }

           if(parseInt(valHora2) > parseInt(valHora1) && parseInt(valHora2) > parseInt(valHora3)){
            if (parseInt(valHora1) > parseInt(valHora3)){
              //console.log("2.2");
              $('.situacion'+idSucursal).html('<span id="situacionIPS"'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado3+'</span> <span id="situacionNormal"'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span> <span id="situacionAFP"'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span>');
              //console.log(valEstado3+'-'+valEstado1+'-'+valEstado2); 

              $('#situacionBtn'+idSucursal).html('<span id="situacionIPS"'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado3+'</span> <span id="situacionNormal"'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span> <span id="situacionAFP"'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span>').attr('data-original-title',situacionSucursalHoraIPS+' -- '+ situacionSucursalHoraNormal+' -- '+situacionSucursalHoraAFP);
             
            }else{
             //console.log("2.3");
              $('.situacion'+idSucursal).html('<span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span> <span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado3+'</span> <span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span>');
             //console.log(valEstado1+'-'+valEstado3+'-'+valEstado2);
              $('#situacionBtn'+idSucursal).html('<span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span> <span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado3+'</span> <span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span>').attr('data-original-title',situacionSucursalHoraNormal+' -- '+situacionSucursalHoraIPS+' -- '+situacionSucursalHoraAFP);      
            }
          }

           if (parseInt(valHora3) > parseInt(valHora2) && parseInt(valHora3) > parseInt(valHora1)){
              if(parseInt(valHora1) > parseInt(valHora2)){
               //console.log("3.2");
              $('.situacion'+idSucursal).html('<span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span> <span id="'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span> <span id="situacionIPS '+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado3+'</span>');
              //console.log(valEstado2+'-'+valEstado1+'-'+valEstado3);
               $('#situacionBtn'+idSucursal).html('<span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span> <span id="'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span> <span id="situacionIPS '+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado3+'</span>').attr('data-original-title',situacionSucursalHoraAFP+' -- '+situacionSucursalHoraNormal+' -- '+situacionSucursalHoraIPS);
              }else{
              //console.log("3.3");
               $('.situacion'+idSucursal).html('<span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span> <span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span> <span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado3+'</span>');
              //console.log(valEstado1+'-'+valEstado2+'-'+valEstado3);
              $('#situacionBtn'+idSucursal).html('<span id="situacionNormal'+idSucursal+'" class="'+claseSituacionNormal+'">'+valEstado1+'</span> <span id="situacionAFP'+idSucursal+'" class="'+claseSituacionAFP+'">'+valEstado2+'</span> <span id="situacionIPS'+idSucursal+'" class="'+claseSituacionIPS+'">'+valEstado3+'</span>').attr('data-original-title',situacionSucursalHoraNormal+' -- '+situacionSucursalHoraAFP+' -- '+situacionSucursalHoraIPS);

            }
          }
        }           
      }
    });
  });
})

$('.seleccionaSucursalZonal').click(function(){
  var pagina,div,datos
  var idSucursal = $(this).attr('data-idSucursal');
  var textoSeleccionado = $('#nombreSucursalLiZonal'+idSucursal).text();
  $('#sucursalSeleccionada').removeClass('oculto').addClass('span12 label label-inverse').attr('data-idSucursal',idSucursal);
  $('#textoSucursalSeleccionada').text(textoSeleccionado);
  $('#divEstados').slideUp('fast');
  $('#estadoSucursalesZonal').removeClass('span5').addClass('span2');
  $('#trabajoZonal').removeClass('span5').addClass('span8');
  $('#botonNuevoMensaje').removeClass('span4').addClass('span6');
  $('#trabajoZonal').html('');
  pagina = 'sucursales/sucursalZonal.asp';
  div = 'trabajoZonal';
  datos = 'sucursal='+idSucursal
  //console.log(datos);
  try{
    enviaDatos(pagina,div,datos);
  }
  catch(err){}
  return false;
});


$('#botonCierraSucursalSeleccionada').click(function(){
  $('#areaZonal').slideUp('fast');
  $('#trabajoZonal').removeClass('span8').addClass('span5').html('');
  $('#estadoSucursalesZonal').removeClass('span2').addClass('span5');
  $('#divEstados').slideDown('slow');
  $('#sucursalSeleccionada').addClass('oculto').removeClass(' span12 label label-inverse');
  return false;
});
$('.seleccionaSucursalZonal').mouseenter(function(){
    var abierta = $(this).attr('data-abierta');
    if (abierta === '1')
    {
      var idSucursal = $(this).attr('data-idSucursal');
       $('#botonesSucursales'+idSucursal).removeClass('oculto');
       $('.situacion'+idSucursal).addClass('oculto');
       return false;
    }
});
$('.seleccionaSucursalZonal').mouseleave(function(){
   var idSucursal = $(this).attr('data-idSucursal');
   $('#botonesSucursales'+idSucursal).addClass('oculto');
   $('.situacion'+idSucursal).removeClass('oculto');
   return false;
});
</script>