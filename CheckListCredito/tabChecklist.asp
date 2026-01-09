<!--#include file="../funciones2.asp"-->
<%
perfilMain = trim(request("perfilMain"))
idSucursalMain = trim(request("idSucursalMain"))
idUsuarioMain = trim(request("idUsuarioMain"))
'response.write(idSucursalMain)
'response.end

%>
<div class="span11">
	<div class="tabbable tabs-left">
	  <ul class="nav nav-tabs" id="tabCheckList">  
	    <li class="" id="colocaciones" data-colocacion="1"><a href="#" data-toggle="tab">COLOCACIONES CR</a></li>
	    <li class="" id="reprogra" data-repro="2"><a href="#" data-toggle="tab">REPROGRAMACIONES CR</a></li>
	    <%if idUsuarioMain  = "1" then%>
		    <li class="" id="cajasSuc" data-repro="3"><a href="#" data-toggle="tab">CAJAS EN PROCESO</a></li>
		    <li class="" id="cajasEnviadas" data-repro="4"><a href="#" data-toggle="tab">CAJAS ENVIADAS</a></li>
		    <li class="" id="cajasEliminadas" data-repro="5"><a href="#" data-toggle="tab">CAJAS ELIMINADAS</a></li>
	    <%end if%>
	  </ul>
	  <div class="tab-content">
	  	<div class="span4 offset6" id="comboFechasColo"></div>
	    <p>
	    	<div class="row-fluid">
				<div class="span12" id="listaChecklistColo"></div>
			</div>
	    </p>
	    <p>
	    	<div class="row-fluid">
				<div class="span12" id="listaChecklistColo2"></div>
			</div>
	    </p>
	    <p>
	    	<div class="row-fluid">
				<div class="span12" id="listaChecklistColo3"></div>
			</div>
	    </p>
	  </div>	 
	  <div class="tab-content">
	  	<div class="span4 offset6" id="comboFechasRepro"></div>
	  		<div class="row-fluid">
				<div class="span12" id="listaChecklistRepro"></div>
			</div>
	    </p>
	    <p>
	    	<div class="row-fluid">
				<div class="span12" id="listaChecklistRepro2"></div>
			</div>
	    </p>
	    <p>
	    	<div class="row-fluid">
				<div class="span12" id="listaChecklistRepro3"></div>
			</div>
	    </p>
	  </div>
	  <div class="tab-content">
	  	<div class="row-fluid">
			<div class="span12" id="listaCajasIng"></div>
			<div class="span11" id="cajaTrabajo"></div>
		</div>	    
	  </div>
	  <div class="tab-content">
	  	<div class="span4 offset6" id="comboCajasEnviadas"></div>
	  		<div class="row-fluid">
				<div class="span12" id="ListaCajasEnviadas"></div>
			</div>
	    </p>	    
	  </div>
	  <div class="tab-content">
	  	<div class="span4 offset6" id="comboCajasEliminadas"></div>
	  		<div class="row-fluid">
				<div class="span12" id="ListaCajasEliminadas"></div>
			</div>
	    </p>	    
	  </div>
	</div>
</div>

<script type="text/javascript">
$(function(){	
	eliminaActive();
	$('#listaCajasIng').html('').hide();
	$('#cajaTrabajo').html('').hide();
	$('#comboFechasColo').html('').hide();	
	$('#listaChecklistColo').html('').hide();
	$('#listaChecklistColo2').html('').hide();
	$('#listaChecklistColo3').html('').hide();
	$('#comboFechasRepro').html('').hide();
	$('#listaChecklistRepro').html('').hide();
	$('#listaChecklistRepro2').html('').hide();
	$('#listaChecklistRepro3').html('').hide();
	$('#comboCajasEnviadas').html('').hide();
	$('#ListaCajasEnviadas').html('').hide();
	$('#comboCajasEliminadas').html('').hide();
	$('#ListaCajasEliminadas').html('').hide();
	$('#colocaciones').first().addClass('active');
	var perfilMain = <%=perfilMain%>;
	var idColocacion = $('#tabCheckList li').first().attr('data-colocacion');
	if (perfilMain == 3){
		var idCombo = 0;
		var pagina = 'CheckListCredito/comboFechasColo.asp';
		var div = 'comboFechasColo';
		var datos='idColocacion='+idColocacion+'&idCombo='+idCombo;
		enviaDatos(pagina,div,datos);
	}
	if (perfilMain == 2){
		var idCombo = 2;
		var pagina = 'CheckListCredito/comboFechasColo.asp';
		var div = 'comboFechasColo';
		var datos='idColocacion='+idColocacion+'&idCombo='+idCombo;
		enviaDatos(pagina,div,datos);
	}
	if (perfilMain == 1){
		var idCombo = 3;
		var pagina = 'CheckListCredito/comboFechasColo.asp';
		var div = 'comboFechasColo';
		var datos='idColocacion='+idColocacion+'&idCombo='+idCombo;
		enviaDatos(pagina,div,datos);
	}
});
$('#colocaciones').click(function() {
	var perfilMain = <%=perfilMain%>;
	eliminaActive();
	$('#listaCajasIng').html('').hide();
	$('#cajaTrabajo').html('').hide();
	$('#comboFechasColo').html('').hide();	
	$('#listaChecklistColo').html('').hide();
	$('#listaChecklistColo2').html('').hide();
	$('#listaChecklistColo3').html('').hide();
	$('#comboFechasRepro').html('').hide();
	$('#listaChecklistRepro').html('').hide();
	$('#listaChecklistRepro2').html('').hide();
	$('#listaChecklistRepro3').html('').hide();
	$('#comboCajasEnviadas').html('').hide();
	$('#ListaCajasEnviadas').html('').hide();
	$('#comboCajasEliminadas').html('').hide();
	$('#ListaCajasEliminadas').html('').hide();
	$(this).addClass('active');
	var tabCheckList = $('#tabCheckList li').first().attr('data-colocacion');
	if (perfilMain == 3){
		var idCombo = 0;
		var pagina = 'CheckListCredito/comboFechasColo.asp';
		var div = 'comboFechasColo';
		var datos='idColocacion='+tabCheckList+'&idCombo='+idCombo;
		enviaDatos(pagina,div,datos);
	}
	if (perfilMain == 2){
		var idCombo = 2;
		var pagina = 'CheckListCredito/comboFechasColo.asp';
		var div = 'comboFechasColo';
		var datos='idColocacion='+tabCheckList+'&idCombo='+idCombo;
		enviaDatos(pagina,div,datos);
	}
	if (perfilMain == 1){
		var idCombo = 3;
		var pagina = 'CheckListCredito/comboFechasColo.asp';
		var div = 'comboFechasColo';
		var datos='idColocacion='+tabCheckList+'&idCombo='+idCombo;
		enviaDatos(pagina,div,datos);
	}
});
$('#reprogra').click(function() {
	var perfilMainRepro = <%=perfilMain%>;
	eliminaActive();
	$('#listaCajasIng').html('').hide();
	$('#cajaTrabajo').html('').hide();
	$('#comboFechasColo').html('').hide();
	$('#listaChecklistColo').html('').hide();
	$('#listaChecklistColo2').html('').hide();
	$('#listaChecklistColo3').html('').hide();
	$('#comboFechasRepro').html('').hide();
	$('#listaChecklistRepro').html('').hide();
	$('#listaChecklistRepro2').html('').hide();
	$('#listaChecklistRepro3').html('').hide();
	$('#comboCajasEnviadas').html('').hide();
	$('#ListaCajasEnviadas').html('').hide();
	$('#comboCajasEliminadas').html('').hide();
	$('#ListaCajasEliminadas').html('').hide();
	$(this).addClass('active');
	var tabCheckList = 2;
	if (perfilMainRepro == 3){
		var idComboRepro = 0;
		var pagina = 'CheckListCredito/comboFechasRepro.asp';
		var div = 'comboFechasRepro';
		var datos='idColocacion='+tabCheckList+'&idComboRepro='+idComboRepro;
		enviaDatos(pagina,div,datos);
	}
	if (perfilMainRepro == 2){
		var idComboRepro = 2;
		var pagina = 'CheckListCredito/comboFechasRepro.asp';
		var div = 'comboFechasRepro';
		var datos='idColocacion='+tabCheckList+'&idComboRepro='+idComboRepro;
		enviaDatos(pagina,div,datos);
	}
	if (perfilMainRepro == 1){
		var idComboRepro = 3;
		var pagina = 'CheckListCredito/comboFechasRepro.asp';
		var div = 'comboFechasRepro';
		var datos='idColocacion='+tabCheckList+'&idComboRepro='+idComboRepro;
		enviaDatos(pagina,div,datos);
	}
});
$('#cajasSuc').click(function(){
	var idSucursalCaja = <%=idSucursalMain%>;
	var idUsuarioMainCaja = <%=idUsuarioMain%>;
	eliminaActive();
	$('#comboCajasEnviadas').html('').hide();
	$('#ListaCajasEnviadas').html('').hide();
	$('#comboCajasEliminadas').html('').hide();
	$('#ListaCajasEliminadas').html('').hide();
	$('#listaCajasIng').html('').hide();
	$('#cajaTrabajo').html('').hide();
	$('#comboFechasColo').html('').hide();
	$('#listaChecklistColo').html('').hide();
	$('#listaChecklistColo2').html('').hide();
	$('#listaChecklistColo3').html('').hide();
	$('#comboFechasRepro').html('').hide();
	$('#listaChecklistRepro').html('').hide();
	$('#listaChecklistRepro2').html('').hide();
	$('#listaChecklistRepro3').html('').hide();
	$('#comboFechasColo').html('').hide();
	$(this).addClass('active');	
	var pagina = 'CheckListCredito/cajas.asp';
	var div = 'listaCajasIng';
	var datos='idSucursalCaja='+idSucursalCaja+'&idUsuarioMainCaja='+idUsuarioMainCaja;
	enviaDatos(pagina,div,datos)
});

$('#cajasEnviadas').click(function(){	
	eliminaActive();
	$('#comboCajasEnviadas').html('').hide();
	$('#ListaCajasEnviadas').html('').hide();
	$('#comboCajasEliminadas').html('').hide();
	$('#ListaCajasEliminadas').html('').hide();
	$('#listaCajasIng').html('').hide();
	$('#cajaTrabajo').html('').hide();
	$('#comboFechasColo').html('').hide();
	$('#listaChecklistColo').html('').hide();
	$('#listaChecklistColo2').html('').hide();
	$('#listaChecklistColo3').html('').hide();
	$('#comboFechasRepro').html('').hide();
	$('#listaChecklistRepro').html('').hide();
	$('#listaChecklistRepro2').html('').hide();
	$('#listaChecklistRepro3').html('').hide();
	$('#comboFechasColo').html('').hide();
	$(this).addClass('active');	
	var pagina = 'CheckListCredito/comboCajasEnviadas.asp';
	var div = 'comboCajasEnviadas';
	var datos='';
	enviaDatos(pagina,div,datos)
});

$('#cajasEliminadas').click(function(){
	eliminaActive();
	$('#comboCajasEnviadas').html('').hide();
	$('#ListaCajasEnviadas').html('').hide();
	$('#comboCajasEliminadas').html('').hide();
	$('#ListaCajasEliminadas').html('').hide();	
	$('#listaCajasIng').html('').hide();
	$('#cajaTrabajo').html('').hide();
	$('#comboFechasColo').html('').hide();
	$('#listaChecklistColo').html('').hide();
	$('#listaChecklistColo2').html('').hide();
	$('#listaChecklistColo3').html('').hide();
	$('#comboFechasRepro').html('').hide();
	$('#listaChecklistRepro').html('').hide();
	$('#listaChecklistRepro2').html('').hide();
	$('#listaChecklistRepro3').html('').hide();
	$('#comboFechasColo').html('').hide();
	$(this).addClass('active');	
	var pagina = 'CheckListCredito/cajas.asp';
	var div = 'comboCajasEliminadas';
	var datos='';
	enviaDatos(pagina,div,datos)
});

function eliminaActive(){
	$('#tabCheckList li').each(function() {
	$(this).removeClass('active');
	});
}

</script>