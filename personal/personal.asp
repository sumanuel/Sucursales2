<!--#include file="../funciones2.asp"-->
<%
idUsuario = trim(request("idUsuarioMain"))
perfil = trim(request("perfilMain"))

if (perfil = "3" or perfil = "2" or perfil="4" or perfil="55" or perfil="66") then%>
<div class="span9">
  <div class="tabbable tabs-left">
    <ul class="nav nav-tabs personal" data-idPersonalActual="1">        
      <li class="" data-personal="5"><a href="#5" data-toggle="tab">Gestión Req.</a></li>
      <li class="active" data-personal="1"><a href="#1" data-toggle="tab">Cajeros</a></li>
      <!--<li class="" data-personal="2"><a href="#2" data-toggle="tab">Anfitriones</a></li>-->
      <!--<li class="" data-personal="3"><a href="#3" data-toggle="tab">Param&eacute;dicos</a></li>-->
      <li class="" data-personal="4"><a href="#4" data-toggle="tab">Guardias</a></li>    
    </ul>
    <div class="tab-content">
      <div id="menuPersonal"></div>
    </div>
  </div>
</div>
<input type="hidden" name="idUsuario" id="idUsuario" value="<%=idUsuario%>"/>
<input type="hidden" name="idPerfil" id="idPerfil" value="<%=perfil%>"/>
<div class="span3 well" id="numerosPersonal">
  <input type="hidden" name="idUsuario" id="idUsuario" value="<%=idUsuario%>"/>
  <input type="hidden" name="idPerfil" id="idPerfil" value="<%=perfil%>"/>
</div>
<script type="text/javascript">
$(document).ready(function(){	
	var pagina = 'personal/menuPersonal.asp';
	var div = 'menuPersonal';
	var datos='idPersonal=1';  	  
	enviaDatos(pagina,div,datos);

	var idPerfil = $("#idPerfil").val();
	var idUsuario = $("#idUsuario").val();
	pagina="personal/numerosPersonal.asp"
  div = "numerosPersonal"
  datos = datos='idUsuario='+idUsuario+'&idPerfil='+idPerfil;
  detiene(pagina,div,datos,900);

	$(".personal li").click(function(){ 
      var idPerfil = $("#idPerfil").val();           
		  var idUsuario = $("#idUsuario").val();
      var idPersonal = $(this).attr('data-personal');	

      var pagina = '';
      var div = 'menuPersonal';
      var datos='';  		
		  
      if(idPersonal == '5'){
        pagina = 'personal/gestioncasos.asp';        
        datos='idPerfil='+idPerfil+'&idUsuario='+idUsuario;     
      }else{
        pagina = 'personal/menuPersonal.asp';        
        datos='idPersonal='+idPersonal;        
      }		  
      enviaDatos(pagina,div,datos);
	});	
});
</script>
<%end if%>