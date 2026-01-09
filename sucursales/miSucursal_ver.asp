<!--#include file="../funciones.asp"-->
<%
perfil = trim(request("perfilMain"))
idSucursal = trim(request("idSucursal"))


  sql = ""
  sql = sql & " select suc_nombre, suc_direccion, suc_tipo, "
  sql = sql & " suc_jeps, suc_jeps_enexo, "
  sql = sql & " suc_jeps_celular, suc_zonal, suc_zonal_ext, "
  sql = sql & " cod_sap, cod_bantotal "
  sql = sql & " from SUC_sucursal "
  sql = sql & " where id_sucursal = '"&idSucursal&"'"
  'Response.Write(sql)
  set rs= db.execute(sql)
  if not rs.eof then
    nombreSucursal = server.HTMLEncode(trim(rs("suc_nombre")))
    direccionSucursal = server.HTMLEncode(trim(rs("suc_direccion")))
    nombreJeps = server.HTMLEncode(trim(rs("suc_jeps")))  
    anexoSucursal = trim(rs("suc_jeps_enexo"))
    celujarJeps = trim(rs("suc_jeps_celular"))
    nombreEncargadoZonal = server.HTMLEncode(trim(rs("suc_zonal")))
    nombreEncargadoZonal_Ext = server.HTMLEncode(trim(rs("suc_zonal_ext")))
	  suc_tipo = server.HTMLEncode(trim(rs("suc_tipo")))
    codSAP = trim(rs("cod_sap"))
    codBTT = trim(rs("cod_bantotal"))
  end if  
%>
    <table class="table table-bordered table-hover">
        <tr>
            <td>Sucursal:</td>
            <td id="nombreSucursal"><%=nombreSucursal%> (<%=suc_tipo%>)</td>
            <td>Dirección</td>
            <td id="direccionSucursal"><%=direccionSucursal%></td>
            <td>Jeps</td>
            <td id="nombreJeps"><span class="label label-info"><%=nombreJeps%></span></td>
          </tr>
          <tr>
            <td>Anexo</td>
            <td id="anexoSucursal"><%=anexoSucursal%></td>
            <td>Celular</td>
            <td id="celujarJeps"><%=celujarJeps%></td>
            <td>Cod BTT</td>
            <td id="codbtt"><%=codBTT%></td>
          </tr>
          <tr>
            <td>Cod SAP</td>
            <td id="codsap"><%=codSAP%></td>
            <td></td>
            <td id="auditoria"></td>
            <td></td>
            <td id="aperturaSucursal"></td>
          </tr>
      </table>    
<%
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing

DB.Close
set DB=nothing
%>