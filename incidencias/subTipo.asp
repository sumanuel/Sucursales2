<!--#include file="../funciones.asp"-->
<%tipo = trim(request("tipo"))
sql = ""
sql = sql & " select id_gest_inc_subtipo, "
sql = sql & " gest_inc_subtipo "
sql = sql & " from SUC_gest_inc_subtipo "
sql = sql & " where id_gest_inc_tipo = '"&tipo&"' "
sql = sql & " order by gest_inc_subtipo" 
set rsCombo = db.execute(sql)%>

<div class="control-group">
    <label class="control-label" for="valorSubTipo">Sub tipo de Gestion</label>
    <div class="controls">
    	<%if not rsCombo.eof then%>
      	<select id="valorSubTipo" name="valorSubTipo" title="Debe selecionar sub tipo de incidencia">
      		<option value="">[Sub tipo de incidencia]</option>
      		<%do while not rsCombo.eof
      			valorTipo = trim(rsCombo("id_gest_inc_subtipo"))
				nombreSubTipoGestion = server.htmlencode(trim(rsCombo("gest_inc_subtipo")))%>
				<option value="<%=valorTipo%>">
					<%=nombreSubTipoGestion%>
				</option>
      			<%rsCombo.movenext
			loop%>	
		</select>
		<%else
			response.write("error en la busqueda de tipos de incidencia")
		end if%>
    </div>
  </div>