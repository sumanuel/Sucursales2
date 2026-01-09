<!--#include file="../funciones.asp"-->
<%idZonal = trim(request("idZonal"))
anioPpto = trim(request("anioPpto"))
mesPpto = trim(request("mesPpto"))
tipo = trim(request("tipo"))
zonalMontoTotal = 0
zonalMonto1 = 0%>
<div class="row-fluid">
  <div class="span12">
    <span class="ingresaModal">
      <a class="btn btn-primary titulares_paso1"  href="#myModal" data-toggle="modal">
        <i class="icon-upload-alt icon-large"></i>  
        Agregar Gasto
      </a>
    </span>
  </div>
</div>
<div class="row-fluid">
	<div class="span12" id="valoresGastos"></div>
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
     <iframe id="ifrmUpload" src="gastos/agregarGasto.asp?idZonal=<%=idZonal%>&tipo=<%=tipo%>" width="750" height="350" frameborder="0"></iframe>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Cerrar</button>
  </div>
</div>
<script type="text/javascript">
var pagina, div,datos
$(function(){
  pagina = 'gastos/listaGastos.asp';
  div='listadoGastos';
  datos='idZonal=<%=idZonal%>&tipo=<%=tipo%>';
  try{
    enviaDatos(pagina,div,datos);
  }catch(err){}
  pagina = 'gastos/valoresGastos.asp';
  div='valoresGastos';
  datos='idZonal=<%=idZonal%>&tipo=<%=tipo%>&anioPpto=<%=anioPpto%>&mesPpto=<%=mesPpto%>';
  try{
    enviaDatos(pagina,div,datos);
  }catch(err){}
  $('.modal-footer, .close').click(function(){
    pagina = 'gastos/listaGastos.asp';
    div='listadoGastos';
    datos='idZonal=<%=idZonal%>&tipo=<%=tipo%>';
    try{
      enviaDatos(pagina,div,datos);
    }catch(err){}
    pagina = 'gastos/valoresGastos.asp';
    div='valoresGastos';
    datos='idZonal=<%=idZonal%>&tipo=<%=tipo%>&anioPpto=<%=anioPpto%>&mesPpto=<%=mesPpto%>';
    try{
      enviaDatos(pagina,div,datos);
    }catch(err){}

  });
})


$('.ingresaModal').click(function(){
  $('#ifrmUpload').attr('src','gastos/agregarGasto.asp?idZonal=<%=idZonal%>&tipo=<%=tipo%>');
});
</script>