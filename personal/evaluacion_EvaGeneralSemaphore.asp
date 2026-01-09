
<!--#include file="../funciones.asp"-->
<%
per = trim(request("periodo"))

sql = "exec SUC_prc_eva_get_semaphore "&per

set rs = db.execute(sql)
if not rs.EOF then
		'response.write(rs)
	do while not rs.eof 
		'response.write(1)
		bueno = trim(rs("BUENO"))
		malo = trim(rs("MALO"))
		normal = trim(rs("NORMAL"))
		rs.MoveNext  			
	loop  		
end if

%>
	<div class="span2"></div>	
	<div class="span1" id="semaphoresmile">
		<button type="button" class="btn btn-success" title="Buenos" id="btnIndicadorReclamosCajerosDP" style="height:50px;width:150px;margin-bottom: 5px;">
			<div style="font-size: 35px"><i class="icon-smile" ></i> <div id="asd" style="display:inline"><%=bueno%></div></div>					
		</button>
	</div>
	<div class="span1"></div>	
	<div class="span1" id="semaphoremeh">
		<button type="button" class="btn btn-warning" title="Normal" style="height:50px;width:150px;margin-bottom: 5px;">
			
			<div style="font-size: 35px"><i class="icon-meh" style="display:inline"></i> <%=normal%></div>
			
		</button>
	</div>
	<div class="span1">		
	</div>	
	<div class="span1" id="semaphorefrown">
		<button type="button" class="btn btn-danger" title="Malos" id="btnIndicadorReclamosCajerosPI" style="height:50px;width:150px;margin-bottom: 5px;">
			<div style="font-size: 35px;"><i class="icon-frown" style="display:inline" ></i> <%=malo%></div>			
		</button>
	</div>

