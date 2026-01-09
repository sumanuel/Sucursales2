$(function(){
  $('#muestraGrafico').addClass('oculto').css('display','none');
})

$('#quitarIndices').click(function(){
  $('#tareasZonal').slideUp('fast');
  return false;
});

$('.seleccionaIndice').click(function(){
  var idIndice = $(this).attr('data-idIndice');
  var idSucursal = $(this).attr('data-idSucursal');
  var pagina = 'indices/loadDataZonal.asp?idIndice='+idIndice+'&idSucursal='+idSucursal;
  var donde = 'valorsubIndice';
  
  $('#muestraGrafico').css('display','none').addClass('oculto');
  try{
         loadData(pagina,donde,idSucursal);
  }catch(err){}
});

function loadData(pagina,donde,idSucursal) {
   $.ajax({
      url: pagina,
      data: "",
      type: "POST",
      dataType: "json",
      success: function(source){
         data = source;
         dispatchInfo(donde,idSucursal);
         $('#datosIndice').removeClass('oculto');
      },
      error: function(dato){
         alert("ERROR");
      }
   });                     
}
function dispatchInfo(donde,idSucursal){
   renderData(data['datos'],donde,idSucursal);
}
function renderData(objectTable,donde,idSucursal){
   var html = '';
   var objIndex = '';
   $('#'+donde).html('');
   $.each(objectTable, function(index, value) {
      var idIndice = value.idIndice;
      var nombreIndice = value.nombreIndice;
      var tituloIndice = value.tituloIndice;
      var tipo = value.tipo
      var valor = value.valor
      var fecha = value.fecha
      if (tipo =="0")
      {
        html = '';
        html = html + '<tr>';
        html = html + '<td>';
        html = html + '<span class="pull-left label tool" title="'+tituloIndice+'"  data-placement="top" data-original-title="'+tituloIndice+'">';
        html = html + '<strong>'+nombreIndice+'</strong></span>';
        html = html + '</span>';
        html = html + '</td>';
        html = html + '<td>&nbsp;</td>';
        html = html + '<td>&nbsp;</td>';
        html = html + '<tr>';
        $('#'+donde).append(html);
        $('.tool').tooltip();
      }
      else
      {
        html = '';
        html = html + '<tr>';
        html = html + '<td>';
        html = html + '<span class="pull-left mano tool abreGrafico" title="'+tituloIndice+'" onclick="insertaGrafico('+idIndice+','+idSucursal+')" data-placement="top" data-original-title="'+tituloIndice+'" data-idIndice="'+idIndice+'" data-idSucursal="'+idSucursal+'"><strong>'+nombreIndice+'</strong></span>';
        html = html + '</td>';
        html = html + '<td>';
        html = html + '<span class="pull-right">'+numberFormat(valor)+'</span>';
        html = html + '</td>';
        html = html + '<td>';
        html = html + '<span class="pull-left">&nbsp;&nbsp;<small>['+fecha+']</small></span>';
        html = html + '</td>';
        html = html + '<tr>';
        $('#'+donde).append(html);
        $('.tool').tooltip();
      }  
   });      
}

function numberFormat(numero){ 
   var resultado = "";
   var nuevoNumero
   if(numero[0]=="-")
   {
      var nuevoNumero=numero.replace(/\./g,'').substring(1);
   }else{
      nuevoNumero=numero.replace(/\./g,'');
   }
   if(numero.indexOf(",")>=0)
      nuevoNumero=nuevoNumero.substring(0,nuevoNumero.indexOf(","));
   for (var j, i = nuevoNumero.length - 1, j = 0; i >= 0; i--, j++) 
      resultado = nuevoNumero.charAt(i) + ((j > 0) && (j % 3 == 0)? ".": "") + resultado; 
   if(numero.indexOf(",")>=0)
      resultado+=numero.substring(numero.indexOf(","));

   if(numero[0]=="-")
   {
      return "-"+resultado;
   }else{
      return resultado;
   }
}
function insertaGrafico(idIndice,idSucursal)
{
  var pagina = 'grafico/graficos.asp';
  var div = 'muestraGrafico'
  var datos = 'idIndice='+idIndice+'&idSucursal='+idSucursal;
  setTimeout(function(){
    try{
      enviaDatos(pagina,div,datos);
      return false;
    }
    catch(err){}
  },500);
  $('#muestraGrafico').addClass('oculto').css('display','none');
  return false;
}