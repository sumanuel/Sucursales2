<!--#include file="../funciones.asp"-->
<%idUsuario = trim(request("idUsuario"))
idPerfil = trim(request("idPerfil"))
horaActual = Time()
minutosHoraActual=hour(horaActual)*60
minutosHoraActual = minutosHoraActual + minute(horaActual)
if minutosHoraActual >= 480 then
  '=================================================================================
  '--> TITULARES Y REEMPLZOS
  '=================================================================================
  sql = ""
  if idPerfil = "2" then
    codSucursal = ""
    sqlSucs = ""		
    sqlSucs = sqlSucs & " select cod_bantotal "
    sqlSucs = sqlSucs & " from SUC_sucursal "
    sqlSucs = sqlSucs & " where id_sucursal in "
    sqlSucs = sqlSucs & " (select id_sucursal "
    sqlSucs = sqlSucs & " from SUC_usuario_sucursal "
    sqlSucs = sqlSucs & " where id_usuario = " & idUsuario & ") "			
    set rsSucs = db.execute(sqlSucs)		
    if not rsSucs.eof then
      dataSucs = rsSucs.GetRows()
    end if
    for y=0 to ubound(dataSucs,2)
      codSucursal = codSucursal & dataSucs(0,y) & ","
    next
    codSucursal = left(codSucursal, (len(codSucursal)-1))
    'Response.Write("idSucursal: "&idSucursal & "<br>")		
    rsSucs.close: set rsSucs = nothing 

    sql = sql & " select "
    sql = sql & " (select COUNT(*) "
    sql = sql & " from SUC_sucursal_guardias_asistencia "
    sql = sql & " where cod_bantotal in "
    sql = sql & " ("&codSucursal&")) as totalguardias, "
    sql = sql & " (select COUNT(*) "
    sql = sql & " from SUC_sucursal_guardias_asistencia "
    sql = sql & " where tipo_suc = 'titular' "
    sql = sql & " and cod_bantotal in ("&codSucursal&")) as totalguardiastitulares, "
    sql = sql & " (select COUNT(*) "
    sql = sql & " from SUC_sucursal_guardias_asistencia "
    sql = sql & " where tipo_suc = 'reemplazo' "
    sql = sql & " and cod_bantotal in ("&codSucursal&")) as totalguardiasreemplazos, "
    sql = sql & " (select COUNT(*) "
    sql = sql & " from SUC_sucursal_guardias_asistencia "
    sql = sql & " where (asistencia = 'si' "
    sql = sql & " and asistencia is not null) "
    sql = sql & " and cod_bantotal in ("&codSucursal&")) as totalguardiaspresentes, "
    sql = sql & " (select COUNT(*) "
    sql = sql & " from SUC_sucursal_guardias_asistencia "
    sql = sql & " where (asistencia = 'no' "
    sql = sql & " or asistencia is null) "
    sql = sql & " and cod_bantotal in ("&codSucursal&")) as totalguardiasausentes "
  else
    sql = sql & " select "
    sql = sql & " (select COUNT(*) "
    sql = sql & " from SUC_sucursal_guardias_asistencia) as totalguardias, "
    sql = sql & " (select COUNT(*) "
    sql = sql & " from SUC_sucursal_guardias_asistencia "
    sql = sql & " where tipo_suc = 'titular') as totalguardiastitulares, "
    sql = sql & " (select COUNT(*) "
    sql = sql & " from SUC_sucursal_guardias_asistencia "
    sql = sql & " where tipo_suc = 'reemplazo') as totalguardiasreemplazos, "
    sql = sql & " (select COUNT(*) "
    sql = sql & " from SUC_sucursal_guardias_asistencia "
    sql = sql & " where (asistencia = 'si' "
    sql = sql & " and asistencia is not null)) as totalguardiaspresentes, "
    sql = sql & " (select COUNT(*) "
    sql = sql & " from SUC_sucursal_guardias_asistencia "
    sql = sql & " where (asistencia = 'no' "
    sql = sql & " or asistencia is null)) as totalguardiasausentes "
  end if
  set rs = db.execute(sql)
  totalTitu = 0
  totalRempl = 0
  if not rs.eof then 
    totalGuardias = rs("totalguardias")
    totalTitu = rs("totalguardiastitulares")
    totalPres = rs("totalguardiaspresentes")
    totalRempl = rs("totalguardiasreemplazos")
    totalAus = rs("totalguardiasausentes")
  end if
'arreglo = rs.GetRows()  
'largo = 0
'largo = UBound(arreglo, 2) + 1 
'for i=0 to (uBound(arreglo)-1)
'    largo = i+1
'Next 

'if largo = 1 then
'    campo = arreglo(0,0)	
'    if campo = "titular" then
'        totalTitu= clng(trim(arreglo(1,0)))
'        totalRempl = 0
'   else
'        totalRempl= clng(trim(arreglo(1,0)))
'        totalTitu = 0
'    end if
'else
'    totalTitu = clng(trim(arreglo(1,1)))
'    totalRempl = clng(trim(arreglo(1,0)))
'end if

'totalGuardias = totalTitu + totalRempl
'end if 
'=================================================================================

'=================================================================================
'--> PRESENTES Y AUSENTES
'=================================================================================
' sql = ""
'if idPerfil = "2" then
'     sql = sql & " select case "
'     sql = sql & " when isnull(asistencia,'no') = 'no' then 'ausente' "
'     sql = sql & " when isnull(asistencia,'si') = 'no' then 'presente'  "
'     sql = sql & " end as asistencia, COUNT(*) nro "
'     sql = sql & " from SUC_sucursal_guardias_asistencia "
'     sql = sql & " where cod_bantotal in ( "
'     sql = sql & " select cod_bantotal from SUC_sucursal "
'     sql = sql & " where id_sucursal in ( "
'     sql = sql & " select id_sucursal from SUC_usuario_sucursal "
'     sql = sql & " where id_usuario = "& idUsuario &")) "
' else
'     sql = sql & " select "
'     sql = sql & " case when isnull(asistencia,'no') = 'no' then 'ausente' "
'     sql = sql & " when isnull(asistencia,'si') = 'no' then 'presente' "
'     sql = sql & " end as asistencia, "
'     sql = sql & " COUNT(*) nro "
'     sql = sql & " from SUC_sucursal_guardias_asistencia "
'     sql = sql & " where cod_bantotal in ( "
'     sql = sql & " select cod_bantotal "
'     sql = sql & " from SUC_sucursal) "
' end if
' sql = sql & " group by asistencia "
'Response.Write(sql)
'Response.End

' set rs2 = db.execute(sql)
' totalPres = 0
' totalAus = 0

' if not rs2.eof then 
' arreglo2 = rs2.GetRows()  
' largo2 = 0
' largo2 = UBound(arreglo2, 2) + 1 

' if largo2 = 1 then
'     campo = arreglo2(0,0)	
'     if campo = "presente" then
'         totalPres= clng(trim(arreglo2(1,0)))
'         totalAus = 0
'     else
'         totalAus= clng(trim(arreglo2(1,0)))
'         totalPres = 0
'     end if
' else
'    totalPres = clng(trim(arreglo2(1,1)))
'     totalAus = clng(trim(arreglo2(1,0)))
' end if
' end if%>
  <div class="row-fluid">
    <div class="span12">
      <table class="table table-bordered table-hover table-condensed">
        <tr>
          <td colspan="3">
            <span class="centrado">
              <strong>
                Guardias
              </strong>
              <span id="porcentajeIndicadorRegistrados" class="badge">
                <%=totalGuardias%>
              </span>
          </td>
        </tr>
        <tr>
          <td>
            <span id="textoIndicadorZonalTitulares">
              Titulares 
            </span>
            <span id="porcentajeIndicadorZonalTitulares" class="badge pull-right">
              <%=totalTitu%>
            </span>
          </td>
          <td>
            <span id="textoIndicadorZonalPresentes">
              Presentes 
            </span>
            <span id="porcentajeIndicadorPresentes" class="badge badge-info pull-right">
              <%=totalPres%>
            </span>
          </td>
        </tr>
        <tr>
          <td>
            <span id="textoIndicadorZonalReemplazo">
              Reemplazos 
            </span>
            <span id="porcentajeIndicadorZonalReemplazo" class="badge pull-right">
              <%=totalRempl%>
            </span>
          </td>
          <td>
            <span id="textoIndicadorZonalAusentes">
              Ausentes 
            </span>
            <span id="porcentajeIndicadorPresentes" class="badge badge-warning pull-right">
              <%=totalAus%>
            </span>
          </td>
        </tr>
      </table>
    </div>
  </div>
  <%rs.close: set rs = nothing 
'rs2.close: set rs2 = nothing 
  db.close: set db = nothing
else%>
<div class="row-fluid">
  <div class="alert alert-error span4 offset3">
    La información de guardias de seguridad estará disponible desde las 8:00
  </div>
</div>
<%end if%>