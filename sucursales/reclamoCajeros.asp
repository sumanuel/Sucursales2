<!--#include file="../funciones.asp"-->
<%
idUsuario =request("idUsuarioMain")	
idSucursal=request("idSucursalMain")	
idPerfil= request("perfilMain")	

%>


<div class="row-fluid span12 well">
	<div class="row-fluid">
	  	<span class="span12 alert alert-success">
		    <span class="span12">
		    	<strong><h4><span id="loadIcon" style="display:none;"><i class="icon-spinner icon-spin icon-large"></i></span> <span class="icon-stack icon-large"><i class="icon-check-empty icon-stack-base"></i><i class="icon-user"></i></span> Reclamo Cajeros</h4></strong>
		    </span> 
		</span>   
	</div>
<ul class="nav nav-tabs">
  <li class="active" id="btnVerCasosReclamo">
    <a class="mano">VER CASOS</a>
  </li >
  <li id="btnAgregarCasoReclamo"><a class="mano">AGREGAR CASO RECLAMO</a></li>
</ul>
	<div class="row-fluid" id="divAreaTrabajoReclamo">
			
	</div>
</div>
<script type="text/javascript">
	$(function(){		
		var pagina, div, datos,canal;		
		var idSucursal = $('#idSucursalMain').val();	
		
		pagina = 'sucursales/reclamoTablaDetalle.asp';
		div = 'divAreaTrabajoReclamo';
		datos= 'idSucursal='+ idSucursal;
		enviaDatos(pagina,div,datos);  	

	});

	$('li#btnVerCasosReclamo').click(function(){
		var pagina,div,datos;
		$(this).addClass('active');
		$('li#btnAgregarCasoReclamo').removeClass('active');

		var pagina, div, datos,canal;		
		var idSucursal = $('#idSucursalMain').val();	
		
		pagina = 'sucursales/reclamoTablaDetalle.asp';
		div = 'divAreaTrabajoReclamo';
		datos= 'idSucursal='+ idSucursal;
		enviaDatos(pagina,div,datos); 

		
	});

	$('li#btnAgregarCasoReclamo').click(function(){
		var pagina,div,datos;
		$(this).addClass('active');
		$('li#btnVerCasosReclamo').removeClass('active');

		var pagina, div, datos,canal;		
		var idSucursal = $('#idSucursalMain').val();	
		
		pagina = 'sucursales/reclamoAddCaso.asp';
		div = 'divAreaTrabajoReclamo';
		datos= 'idSucursal='+ idSucursal;
		enviaDatos(pagina,div,datos); 

		//alert("hola");
	});

</script>