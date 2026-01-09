<!--#include file="../funciones2.asp"-->
<%
idUsuario = trim(request("idUsuarioMain"))
perfil = trim(request("perfilMain"))

if (perfil = "3" or perfil = "2" or perfil="4") then%>
<div class="span9">
<div class="tabbable tabs-left">
  <ul class="nav nav-tabs personal" data-idPersonalActual="1">  
    <li class="active" data-personal="1"><a href="#1" data-toggle="tab">JEPS</a></li>
    <li class="" data-personal="2"><a href="#2" data-toggle="tab">JEPS MULTI</a></li>
    <li class="" data-personal="3"><a href="#3" data-toggle="tab">ASISTENTES OP</a></li>  
    <li class="" data-personal="4"><a href="#4" data-toggle="tab">VALIDADORES</a></li>   
    <li class="" data-personal="5"><a href="#5" data-toggle="tab">TESOREROS</a></li>
    
  </ul>
  <div class="tab-content">
    <div id="menuPersonal"></div>
  </div>
</div>
</div>
<div class="span3 well">
	<input type="hidden" name="idUsuario" id="idUsuario" value="<%=idUsuario%>"/>
    <input type="hidden" name="idPerfil" id="idPerfil" value="<%=perfil%>"/>
	<dl class="dl-horizontal">
      <dt><span class="label label-info">JEPS </span></dt>
      	<dd><span class="label"><i class="icon-user"></i> <span id="jeps"></span></span></dd>
      <dt><span class="label label-info">JEPS MULTI </span></dt>
      	<dd><span class="label"><i class="icon-user"></i> <span id="jepsm"></span></span></dd>
      <dt><span class="label label-info">ASISTENTES OP </span></dt>
      	<dd><span class="label"><i class="icon-user"></i> <span id="ao"></span></span></dd>
      <dt><span class="label label-info">VALIDADORES </span></dt>
        <dd><span class="label"><i class="icon-user"></i> <span id="validadores"></span></span></dd>     
      <dt><span class="label label-info">TESOREROS </span></dt>
      	<dd><span class="label"><i class="icon-user"></i> <span id="tesorero"></span></span></dd>    
   </dl>    
    
</div>
<script type="text/javascript">
$(document).ready(function(){	
	var pagina = 'personal/menuPersonal_int.asp';
	var div = 'menuPersonal';
	var datos='idPersonal='+1;  	  
	enviaDatos(pagina,div,datos);
	
	var idPerfil = $("#idPerfil").val();
	var idUsuario = $("#idUsuario").val();
	
	//Carga numeros totales
	pagina='personal/personal_numeros_int.asp';
	dv='';
	datos='idUsuario='+idUsuario+'&idPerfil='+idPerfil;	
	
	var loadData = $.ajax({
        url: pagina,
        data: datos,
        type: "GET",
        dataType: "json",
        success: function(source){
            data = source;
            dispatchInfo();
        },
        error: function(dato){
            alert("ERROR");
        }
    });

    var dispatchInfo = function(){
        renderData(data);
    }
    
    var renderData = function(objectJson){
      $.each(objectJson, function(index, value) {            
			$("#jeps").html(value.jeps);			
			$("#jepsm").html(value.jepsm);			
			$("#ao").html(value.ao);			
			$("#tesorero").html(value.tes);			
			$("#validadores").html(value.val);			
        });     
    }
	
	$(".personal li").click(function(){            
		var idPersonal = $(this).attr('data-personal');				
		
		var pagina = 'personal/menuPersonal_int.asp';
	  	var div = 'menuPersonal';
	  	var datos='idPersonal='+idPersonal;		
	  	enviaDatos(pagina,div,datos);	
	});	
});
</script>
<%end if%>