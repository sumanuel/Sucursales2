<%idSucursal = trim(request("idSucursal"))%>
<div class="row-fluid">
	<div class="span12 well">
    <span class="span12 alert alert-success">
      <strong>
        <h4>
          <span id="loadIcon" style="display:none;">
            <i class="icon-spinner icon-spin icon-large"></i>
          </span> 
          <span class="icon-stack icon-large">
            <i class="icon-check-empty icon-stack-base"></i>
            <i class="icon-legal"></i>
          </span> 
          Auditoría
        </h4>
      </strong>
    </span>
		<span class="ingresaModal">
      <a class="btn btn-primary titulares_paso1"  href="#myModal" data-toggle="modal">
        <i class="icon-upload-alt icon-large"></i>&nbsp;&nbsp;Paso 1: subir archivo</a>
      </span>
	</div>
</div>
<div class="row-fluid">
  <div class="span12 well" id="listadoArchivosAuditoria"></div>
</div>
<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Subir archivo</h3>
  </div>
  <div class="modal-body">
     <iframe id="ifrmUpload" src="auditoria/upload.asp?idSucursal=<%=idSucursal%>" width="780" height="340" frameborder="0"></iframe>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Cerrar</button>
  </div>
  
</div>
<script type="text/javascript">
var pagina, div,datos
$(function(){
  pagina = 'auditoria/listaArchivosAuditoria.asp';
  div='listadoArchivosAuditoria';
  datos='idSucursal=<%=idSucursal%>';
  try{
    enviaDatos(pagina,div,datos);
  }
  catch(err){}
});
$('.ingresaModal').click(function(){
    var perfil = $('#perfil').val();
    $('#ifrmUpload').attr('src','auditoria/upload.asp?idSucursal=<%=idSucursal%>');
  });
$('.modal-footer, .close').click(function(){
    pagina = 'auditoria/listaArchivosAuditoria.asp';
    div='listadoArchivosAuditoria';
    datos='idSucursal=<%=idSucursal%>';
    try{
      enviaDatos(pagina,div,datos);
    }
    catch(err){}
    pagina = 'sucursales/miSucursal.asp';
    div = 'miSucursal';
    datos='idSucursal=<%=idSucursal%>';
    try{
      enviaDatos(pagina,div,datos);
    }
    catch(err){}
});
</script>