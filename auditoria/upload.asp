<!DOCTYPE HTML>
<script type="text/javascript" src="../js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="../js/jquery.session.js"></script>
<script src="../js/main.js" type="text/javascript"></script>
<link href="../css/bootstrap.css" rel="stylesheet" type="text/css">
<link href="../css/bootstrap-responsive.css" rel="stylesheet" type="text/css">
<link href="../css/estilo.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="../css/font-awesome.min.css" type="text/css">


<script src="../js/bootstrap.min.js" type="text/javascript"></script>
<script src="../js/jquery.validate.js" type="text/javascript"></script>
<script src="../js/additional-methods.js" type="text/javascript"></script>
<link href="../css/bootstrap-datetimepicker.min.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="../js/bootstrap-datetimepicker.es-cl.js"></script>
<%idSucursal=trim(request("idSucursal"))
accion=trim(request("accion"))
if idSucursal = "" or accion = "1" then%>
    <script type="text/javascript">
        $('#myModal').modal('hide');
    </script>
<%end if%>
<div class="row-fluid">
    <div class="span12">
        <form class="form-horizontal" name="frmSend" method="POST" enctype="multipart/form-data" accept-charset="utf-8" action="subeArchivo.asp?idSucursal=<%=idSucursal%>" id="frmSend">
            <input type="hidden" name="idSucursal" id="idSucursal" value="<%=idSucursal%>">
            <div class="control-group">
                <label class="control-label" for="inputArchivo">Seleccione archivo :</label>
                <div class="controls">
                    <input type="file" id="inputArchivo" name="inputArchivo" placeholder="Archivo" class="required" title="Debe seleccionar archivo">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="fechaAudutoria">Fecha de auditoría</label>
                <div class="controls">
                    <div id="tomaFechaAuditoria" class="input-append">
                        <input data-format="dd-MM-yyyy" type="text" name="fechaAudutoria" id="fechaAudutoria" class="required" placeholder="Fecha de auditoría" title="Debe seleccionar fecha de la auditoría">
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
                <label class="control-label" for="evaluacion">Evaluacion</label>
                <div class="controls">
                    <select name="evaluacion" id="evaluacion" class="required" title="Debe seleccionar evaluación">
                        <option value="">[Seleccione evaluación]</option>
                        <option value="1">Satisfactorio</option>
                        <option value="2">Insatisfactorio</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="puntaje">Puntaje</label>
                <div class="controls">
                    <input type="text" id="puntaje" placeholder="Puntaje" class="required" title="Debe ingresar el puntaje" name="puntaje">
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
    $('#tomaFechaAuditoria').datetimepicker({
        pickTime: false
    });
    $("#observacion").limiter(400, elem);
    
    $('#frmSend').validate({});
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
</script>