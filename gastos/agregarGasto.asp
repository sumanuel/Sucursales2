<!DOCTYPE HTML>
<script type="text/javascript" src="../js/jquery-1.10.2.min.js"></script>
<link href="../css/bootstrap.css" rel="stylesheet" type="text/css">
<link href="../css/bootstrap-responsive.css" rel="stylesheet" type="text/css">
<!--<link href="../css/estilo.css" rel="stylesheet" type="text/css"> -->
<link rel="stylesheet" href="../css/font-awesome.min.css" type="text/css">
<!--[if lt IE 9]>
  <link rel="stylesheet" href="../css/font-awesome-ie7.min.css">
  <![endif]-->
  <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
  <!--[if lt IE 9]>
  <script src="../js/html5shiv.js"></script>
  <![endif]-->

<script type="text/javascript" src="../js/jquery.session.js"></script>
<!--<script src="../js/main.js" type="text/javascript"></script> -->
<script src="../js/bootstrap.min.js" type="text/javascript"></script>
<script src="../js/jquery.validate.js" type="text/javascript"></script>
<link href="../css/bootstrap-datetimepicker.min.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="../js/bootstrap-datetimepicker.es-cl.js"></script>
<%idZonal=trim(request("idZonal"))
tipo = trim(request("tipo"))
accion=trim(request("accion"))
if idZonal = "" or accion = "1" then%>
    <script type="text/javascript">
        $('#myModal').modal('hide');
    </script>
<%end if%>
<div class="row-fluid">
    <div class="span12">
        <form class="form-horizontal" name="frmSend" method="POST" enctype="multipart/form-data" accept-charset="utf-8" action="subeArchivos.asp?idZonal=<%=idZonal%>&tipo=<%=tipo%>" id="frmSend">
            <input type="hidden" name="idZonal" id="idZonal" value="<%=idZonal%>">
            <div class="control-group">
                <label class="control-label" for="titulo">Título</label>
                <div class="controls">
                    <input type="text" id="titulo" placeholder="Título" data-rule-required="true" data-msg-required="El campo no puede estar vacio" name="titulo">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="monto">Monto</label>
                <div class="controls">
                    <input type="text" id="monto" placeholder="Monto" data-rule-required="true" data-msg-required="El campo no puede estar vacio" data-rule-number="true" data-msg-number="Debe ingresar solo números" title="Debe ingresar monto" name="monto">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputArchivo">Seleccione archivo :</label>
                <div class="controls">
                    <input type="file" id="inputArchivo" name="inputArchivo" placeholder="Archivo" title="Debe seleccionar archivo" data-rule-required="true" data-msg-required="El campo no puede estar vacio">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="fecha">Fecha de gasto</label>
                <div class="controls">
                    <div id="tomaFecha" class="input-append">
                        <input data-format="dd/MM/yyyy" type="text" name="fecha" id="fecha"  placeholder="Seleccionar fecha" data-rule-required="true" data-msg-required="El campo no puede estar vacio" data-rule-date="true" data-msg-date="Debe seleccionar fecha">
                        <span class="add-on">
                            <i data-time-icon="icon-time" data-date-icon="icon-calendar"></i>
                        </span>
                    </div>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="observacion">Observación</label>
                <div class="controls">
                    <textarea rows="3" name="observacion" id="observacion"></textarea>
                    <span id="totalCaracteres" class="badge"></span>
                </div>
            </div>
            <div class="control-group">
                <div class="controls">
                    <input type="submit" class="btn" value="Guardar">
                </div>
            </div>
        </form>
    </div>
</div>
<div class="row-fluid">
    <div class="span12">
         <%if accion="1" then%>
            <strong>Cierre la ventana e intentelo nuevamente si el problema persiste reinicie su sessión</strong>
        <%end if%>
    </div>
</div>
<script type="text/javascript">
$(function() {
    $('#tomaFecha').datetimepicker({
        pickTime: false
    });
    $("#observacion").limiter(400, elem);
});
(function($) {
        $.fn.extend( {
            limiter: function(limit, elem) {
                $(this).on("keyup focus", function() {
                    setCount(this, elem);
                });
                function setCount(src, elem) {
                    var chars = src.value.length;
                    if (chars > limit) {
                        src.value = src.value.substr(0, limit);
                        chars = limit;
                        elem.addClass("badge-important");
                    }
                    else
                    {
                        elem.removeClass("badge-important");
                    }
                    elem.html( limit - chars );
                }
                setCount($(this)[0], elem);
            }
        });
    })(jQuery);
    var elem = $("#totalCaracteres");
$('#frmSend').validate({
    /*ignore:':not(:visible)',
    onsubmit: true, 
    submitHandler: function(form) {
        var numero = '&v='+ Math.random() * 999;
        var valores = $("#formActivosEntel").serialize();
        valores += numero;
        $('#botonRegistroUsuario').hide('fast');
        $('#enviaDatos').removeClass('oculto').html('<strong>Guardando</strong> <img src="img/loader.gif"/>');
        $('#enviaDatos').delay(2000).queue(function( nxt ) {
            $.ajax({
                type:'GET', //en desarrollo como GET en produccion POST
                url:'activos/sql.asp', //la pagina que se van los datos
                cache:false,
                //async:true,
                global:false,
                dataType:"html",
                data:valores,
                timeout:10000, //tiempo que espera
                success:function(contenido) //cargo la pagina correctamente
                {
                    $('ul#menuActivos > li').removeClass('active');
                    $('#entel').addClass('active');
                    var pagina='activos/activosEntel.asp';
                    var div='cargaActivos';
                    var datos = '';
                    try{
                        enviaDatos(pagina,div,datos);
                    }catch(err){}
                    pagina='activos/informeActivos.asp';
                    div='informeActivos';
                    datos = 'tipoActivo=1';
                    try{
                        enviaDatos(pagina,div,datos);
                    }catch(err){}
                    $('#divAgregarActivos').addClass('oculto');
                },
                error:function() //si no carga la pagina
                {
                    alert('Algo Salio Mal.');
                }
            });
            nxt();
            return false;
        });
    }*/
});
</script>