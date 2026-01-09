<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
sql = ""
sql = sql & "select idIndice, nombreIndice from SUC_indices where padre = 0 and estado = 1 order by orden"
set rs = db.execute(sql)
i = 1
if not rs.eof then
   do while not rs.eof
      if i="1" or i="4" then
         'response.write("<div class='row-fluid'>")
      end if
      nombreIndice = server.htmlencode(trim(rs("nombreIndice")))
      idIndice = trim(rs("idIndice"))
      %>
      <div id="nombreIndice" class="badge badge-inverse mano seleccionaIndice" data-idIndice="<%=idIndice%>" data-idSucursal='<%=idSucursal%>'><%=nombreIndice%></div>
      <%rs.MoveNext
      i = i+1
      if i="1" or i="4" then
        '' response.write("</div>")
      end if
   loop
end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
DB.Close
set DB=nothing%>
<div id="quitarIndices" class="badge badge-inverse mano"><i class="icon-remove"></i>   Quitar Indices</div>
<div class="row-fluid oculto" id="datosIndice">
   <div id="muestraGrafico" class="well oculto"></div>
   <div class="span7 well">
   		<table id="valorsubIndice" border="0" width="100%"></table>
   </div>
</div>

<script type="text/javascript" src="js/bootstrap-tooltip.js"></script>
<script type="text/javascript" src="js/indices.js"></script>