<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
tipoDescarga = trim(request("tipoDescarga"))



if tipoDescarga = 1 then

		'response.write(tipoDescarga)
%>
<div class="input-append">
	<select id="fechaExcelAsistencia1" disabled name="fechaExcel6">
		<option value="<%=date()%>"><%=date()%></option>		
	</select>
	<span class="tool">
		<a class="btn btn-danger excelAsistencia1" href="#atrasos" data-fecha="" data-tipoDescarga="<%=tipoDescarga%>" data-descarga="0"  name="atrasos">
		    <i class="icon-cloud-download icon-large"></i>
		    &nbsp;&nbsp;Descargar Atrasos 
		</a>
	</span>
	
</div>
<%
else 
	if tipoDescarga = 2 then

		'response.write(tipoDescarga)

		periodoSelectorFechasExcel = trim(request("periodo"))
%>
	<div class="input-append">
		<%sql = ""
		sql = sql & " set dateformat dmy "
		sql = sql & " select fecha_respaldo "
		sql = sql & " from SUC_sucursal_asistencia_personal_respaldo "
		sql = sql & " where convert(nvarchar(6),fecha_respaldo,112) = " & periodoSelectorFechasExcel
		sql = sql & " group by fecha_respaldo "
		sql = sql & " order by fecha_respaldo desc "
		set rsAtraso = db.execute(sql)
		if not rsAtraso.eof then
		    datosFechaAtraso = rsAtraso.getrows()
		end if%>
		<select id="fechaExcelAsistencia1" name="fechaExcel6">
		    	<option value="0">[Seleccione Fecha]</option>
		    	<%for w = 0 to ubound(datosFechaAtraso,2)
		            fechaRespaldo = trim(datosFechaAtraso(0,w))%>
		            <option value="<%=fechaRespaldo%>"><%=fechaRespaldo%></option>
		        <%next%>
		</select>
		<span class="tool" >
		    <a class="btn btn-danger excelAsistencia1" disabled href="#atrasos" data-fecha="" data-tipoDescarga="<%=tipoDescarga%>" data-descarga="0" name="atrasos">
		        <i class="icon-cloud-download icon-large"></i>
		        &nbsp;&nbsp;Descargar Atrasos
		    </a>		    
		</span>
	</div>
	<%
	end if
end if
%>
<script type="text/javascript">
$(function () {
	$('.tool').tooltip();

}).on('click','.excelAsistencia1',function(){
	var tipoDescargaBtn = $(this).attr('data-tipoDescarga');
    var descargaDatos = $(this).attr('data-descarga');
	var valorSeleccionado = $('#fechaExcelAsistencia1 option:selected').val();

	//console.log("tipoDescargaBtn = " + tipoDescargaBtn + " | descargaDatos = " + descargaDatos + " | valorSeleccionado = "+ valorSeleccionado)

	if (valorSeleccionado == '0'){

	}
	else{		
	    if (tipoDescargaBtn == 1){
	    	
		    if (valorSeleccionado !=='')
		    {
		        $('.excelAsistencia1').attr('data-fecha', valorSeleccionado);
		    }
		    var valorFecha = $(this).attr('data-fecha');
	        var today = new Date();
	        var dd = today.getDate();
	        var mm = today.getMonth()+1; //January is 0!

		    var yyyy = today.getFullYear();
		    if(dd<10){
		        dd='0'+dd
		    } 
		    if(mm<10){
		        mm='0'+mm
		    } 
		    var hoy = dd+'-'+mm+'-'+yyyy;
		    var url

		    url = 'adminPersonalInforme2.asp?tipoInforme=8&valorFecha=' //se deja sin fecha para obtener el dia actual.

		    $(this).attr({
		        'download': 'admin_personal_excel_atrasos_'+valorFecha+'.xls',
		        'href': url,
		        'target': '_blank'
		    });


	    }else{
	    	if (descargaDatos ==='1')
		    {
		        var valorFecha = $(this).attr('data-fecha');
		        var today = new Date();
		        var dd = today.getDate();
		        var mm = today.getMonth()+1; //January is 0!

		        var yyyy = today.getFullYear();
		        if(dd<10){
		            dd='0'+dd
		        } 
		        if(mm<10){
		            mm='0'+mm
		        } 
		        var hoy = dd+'-'+mm+'-'+yyyy;
		        var url

		        url = 'adminPersonalInforme2.asp?tipoInforme=8&valorFecha='+valorFecha
		       
		        $(this).attr({
		           'download': 'admin_personal_excel_atrasos_'+valorFecha+'.xls',
		           'href': url,
		           'target': '_blank'
		        });
		    }
		    else
		    {
		        $(this).html('<i class="icon-calendar icon-large"></i> Seleccione fecha');
		    }  
	    }
	}

    

	     
}).on('change','#fechaExcelAsistencia1',function(){
    var valorSeleccionado = $('#fechaExcelAsistencia1 option:selected').val();
    if (valorSeleccionado !=='0')
    {    	
        $('.excelAsistencia1').html('<i class="icon-cloud-download icon-large"></i>&nbsp;&nbsp;Descargar Atrasos').attr('data-descarga', '1');
        $('.excelAsistencia1').attr('data-fecha', valorSeleccionado);        
        $('.excelAsistencia1').removeAttr("disabled");
    }
    else
    {
         $('.excelAsistencia1').attr('data-descarga', '0');
         $('.excelAsistencia1').attr("disabled", true);
    }
})

</script>