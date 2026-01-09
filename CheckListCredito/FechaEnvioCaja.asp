<!--#include file="../funciones2.asp"-->
<%

idUsuario = trim(request("IdUsuario"))
codigoBarras = trim(request("codigoBarras"))
valorEstado = trim(request("valorEstado"))
botonera = trim(request("botonera"))
idSucursalCaja = trim(request("idSucursalCaja"))

%>
<div class="row-fluid">
    <div class="span8 offset2" id="ingresa">
        <form class="form-horizontal" name="formDatosCaja" id="formDatosCaja">
            <div class="control-group fecEnvio" id="fecEnvio">
                <label class="control-label" for="txtFecha">Seleccione Fecha</label>
                <div class="controls">
                    <div id="datetimepicker1" class="input-append">
                        <input data-format="dd/MM/yyyy" type="text" id="txtfecha" name="txtfecha" data-rule-required="true" data-msg-required="Ingrese fecha" placeholder="Ingrese fecha" value="<%=replace(date(),"-","/")%>">
                        <span class="add-on">
                            <i class="icon-calendar"></i>
                        </span>
                    </div>
                </div>                
            </div>
            <div class="control-group obsTextera" id="obsTextera">
                <label class="control-label" for="txtObsCaja">Observaciones</label>
                <div class="controls">
                    <textarea rows="6" id="obsCaja" name="obsCaja" class="field span12"></textarea>
                    <span id="totalCaracteres" class="badge"></span>
                </div>                
            </div>                
            <div class="control-group">
                <div class="controls">
                    <span id="guardaDatosCaja">
                        <input type="submit" name="enviar" id="enviar" value="Enviar" class="btn btn-success"/>
                    </span>
                </div>
            </div>
        </form> 
    </div>
</div>

<script type="text/javascript">
$(function(){
    $('#datetimepicker1').datetimepicker({
        pickTime: false,
        language: 'es-cl',
        weekStart: 1
    });

    $.fn.extend( {
        limiter: function(limit, elem) {
            $(this).on("keyup focus", function() {
                setCount(this, elem);
            });
            function setCount(src, elem){
                var chars = src.value.length;
                if (chars > limit){
                    src.value = src.value.substr(0, limit);
                    chars = limit;
                    elem.addClass("badge-important");
                }else{
                    elem.removeClass("badge-important");
                }
                elem.html( limit - chars );
            }
            setCount($(this)[0], elem);
        }
    });
});
var elem = $("#totalCaracteres");
$("#obsCaja").limiter(400, elem);

$("#formDatosCaja").validate({            
    submitHandler: function(form) {
    var numero = '&v='+ Math.random() * 999;
    var codigoBarras = <%=codigoBarras%>;
    var valorEstado = <%=valorEstado%>;
    var idUsuario = <%=idUsuario%>;
    var botonera = <%=botonera%>;
    var fechaEnvio = $('#txtfecha').val();
    var idSucursalCaja = <%=idSucursalCaja%>;
    //alert(fechaEnvio);
    var valores = 'codigoBarras='+codigoBarras+'&valorEstado='+valorEstado+'&idAccion=2&botonera='+botonera+'&idUsuario='+idUsuario+'&fechaEnvio='+fechaEnvio;
    valores += '&'+ $('#formDatosCaja').serialize();
    valores += numero;    
    $('#guardaDatosCaja').html('<i class="icon-refresh icon-spin"></i>Un momento guardando datos');
    $.ajax( 
        {
            type:'GET',
            url:'CheckListCredito/sqlCajas.asp', //la pagina que se van los datos
            cache:false,
            global:false,
            dataType:"html",
            data:valores,
            timeout:10000, //tiempo que espera
            success:function(contenido) //cargo la pagina correctamente
            {
                setTimeout('$("#guardaDatosCaja").html("<i class=icon-check></i>Registrado con exito")',2000);
                $('#fecEnvio').addClass('oculto');
                $('#obsTextera').addClass('oculto');
                
            },
            error:function() //si no carga la pagina
            {
                alert('Algo Salio Mal.');
            }
        });
    }
});

</script>