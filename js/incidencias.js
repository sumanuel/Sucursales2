$(function(){}).on("click", ".botonCambiaEstadoIncidencia", function () {
    var idGestion = $(this).attr("data-idGestion");
    $(this).removeClass("botonCambiaEstadoIncidencia");
    $("." + idGestion).html('<select class="selectCambiaEstadoSucursal input-small ' + idGestion + '" data-idGestion=' + idGestion + ' id="selectCambiaEstadoSucursal"><option value="">[Seleccione opcion]</option><option value="1">Inactivo</option><option value="2">Eliminado por error</option><option value="3">Cerrado</option></select><div id="validaOpcion" class="' + idGestion + '"></div>');
    return false;
}).on("change", ".selectCambiaEstadoSucursal", function () {
    var valorSeleccionado = $(this).val();
    var idGestion = $(this).attr("data-idGestion");
    if (valorSeleccionado == "") {
        $("#validaOpcion." + idGestion).text("Debe seleccionar una opcion").addClass("alert alert-error");
    } else {
        $("#validaOpcion." + idGestion).removeClass("alert alert-error").html('<span class="btn btn-mini btn-success" id="botonGuardaEstadoGestion'+idGestion+'" data-idGestion="' + idGestion + '" data-valorSeleccionado="' + valorSeleccionado + '" onClick="guardaEstadoGestion('+idGestion+');"><strong><i class="icon-save"></i> Guardar</strong></span><span class="btn btn-mini btn-danger" id="botonCancelaEstadoGestion" data-idGestion=' + idGestion + '><i class="icon-remove"></i> Cerrar</span>');
    }
    return false;
}).on("click", "#botonCancelaEstadoGestion", function () {
    var idGestion = $(this).attr("data-idGestion");
    $("#divCambiaEstadoGestion." + idGestion).html('<span class="btn btn-mini btn-success botonCambiaEstadoIncidencia" data-idGestion="' + idGestion + '"><i class="icon-wrench"></i></span>');
    return false;
});
function guardaEstadoGestion(idGestion)
{
    var boton = $('#botonGuardaEstadoGestion'+idGestion);
    //var idGestion = $('#botonGuardaEstadoGestion'+idGestion).attr("data-idGestion");
    var valorSeleccionado = $(boton).attr("data-valorSeleccionado");
    var textoSeleccionado = $("select." + idGestion + " option:selected").text();
    $("#estado" + idGestion).text(textoSeleccionado);
    $("#divCambiaEstadoGestion." + idGestion).html("");
    pagina = "incidencias/cambiaEstadoIncidencias.asp";
    div = "divCambiaEstadoGestion" + idGestion;
    datos = "idGestion=" + idGestion + "&valor=" + valorSeleccionado;
    //alert('este si')
    enviaDatos(pagina, div, datos);
    $('tr#'+idGestion).fadeOut('slow');
    return false;

}

   