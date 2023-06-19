<%@ page import="java.util.*" %>
<%@ page import="java.sql.*"%>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>
SIGMA
</title>
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-147950442-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-147950442-1');
</script>
<%
int capa = Integer.parseInt(request.getParameter("capa")),
    tipo = Integer.parseInt(request.getParameter("tipo")),
corte = Integer.parseInt(request.getParameter("corte")),
    n = 0, ban=0;
String  buscar = request.getParameter("buscar").toUpperCase(),
         consulta = "",
         salida = "",
         limit = " limit 100",
         st = "";
%>
<style type="text/css">
table {
  border-collapse: collapse;
}
.t{font-size: 12pt; font-family: Arial; font-weight: bold; color: #000000;}
.c{font-family: Arial; font-size: 10pt; line-height: 1.3; font-weight: normal;}
.n{font-family: Arial; font-size: 10pt; line-height: 1.3; font-weight: bold;}
.r{font-family: Arial; font-size: 8pt; line-height: 1.3;}
.boton{font-family: Arial; font-size: 10px; line-height: 1; font-weight: normal;}

</style>
<script language="javascrpt" type="text/javascript">
window.resizeTo(800,400);
var buscar='<% out.print(buscar); %>';
var capa='<% out.print(capa); %>';

function envia(){
    document.enviar.submit();
}

var out = "";
var out2 = 0;


</script>
  </head>
<body>
<%


 String select="",filent="",where1="",where2="";

filent = request.getParameter("filent");
if (filent==null){
  filent="00";
}
if (filent.equals("00")){
   where1 = "";
   where2 = "";
}else{
   where1 = " cve_ent='"+filent+"' and ";
   where2 = " where cve_ent='"+filent+"'";
}

buscar = buscar.replace("-","");
buscar = buscar.replace(";","");
switch(capa){
   case 3:		//municipios
	if (tipo==0){
		consulta="SELECT cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,3857))::text else 'x' end as salida FROM historico.municipio_"+corte+" t1 where "+where1+" cve_ent||cve_mun like '" + buscar + "%'  order by cve_ent||cve_mun"+limit;
	}else{
		consulta="select cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,3857))::text else 'x' end as salida FROM historico.municipio_"+corte+" t1 where "+where1+" upper(a_sinacentos(nom_mun)) like '%" + buscar + "%' order by cve_ent||cve_mun"+limit;
	}
	break;
case 4:		//agebs
	if (tipo==0){
		consulta="SELECT clave,cve_ageb,case when geom is not null THEN box2d(ST_Transform(geom,3857))::text else 'x' end as salida,ambito FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_"+corte+" "+where2+"  union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_"+corte+" "+where2+") t1 where replace(clave,'-','') like '" + buscar + "%' order by ambito,clave"+limit;
	}else{
		  consulta="SELECT clave,cve_ageb,case when geom is not null THEN box2d(ST_Transform(geom,3857))::text else 'x' end as salida,ambito FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_"+corte+" "+where2+"  union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_"+corte+" "+where2+") t1 where upper(a_sinacentos(replace(cve_ageb,'-',''))) like '%" + buscar + "%'  order by ambito,clave"+limit;
	}
	break;
case 7:		//rurales   --lo modifique para que buscque tanto urbanas como rurales y poligonos rurales
	if (tipo==0){
            consulta = " (SELECT cve_ent||cve_mun||cve_loc as clave,nom_loc,"
            + "case "
            + "	when geom is not null THEN box2d(ST_Transform(geom,3857))::text "
            + " else 'x' "
            + "end "
            + "as salida,ambito,cve_ageb,'PUNTO' as geo "
            + "FROM historico.lpr_"+corte+" t1 where "+where1+" cve_ent||cve_mun||cve_loc like '" + buscar + "%' "
            + "union "
            + "SELECT cve_ent||cve_mun||cve_loc as clave,nom_loc,case when geom is not null THEN box2d(ST_Transform(geom,3857))::text else 'x' end as salida,ambito,'0000' as cve_ageb , 'POLIGONO' as geo "
            + "FROM historico.l_"+corte+" t1 where "+where1+" cve_ent||cve_mun||cve_loc like '"+buscar+"%' ) order by clave "+limit;
	}else{
            consulta = "( SELECT cve_ent||cve_mun||cve_loc as clave,nom_loc,"
            + "case "
            + "	when geom is not null THEN box2d(ST_Transform(geom,3857))::text "
            + " else 'x' "
            + "end "
            + "as salida,ambito,cve_ageb , 'PUNTO' as geo "
            + "FROM historico.lpr_"+corte+" t1 where "+where1+" upper(a_sinacentos(nom_loc)) like '%" + buscar + "%' "
             + "union "
            + "SELECT cve_ent||cve_mun||cve_loc as clave,nom_loc,case when geom is not null THEN box2d(ST_Transform(geom,3857))::text else 'x' end as salida,ambito,'0000' as cve_ageb, 'POLIGONO' as geo "
            + "FROM historico.l_"+corte+" t1 where ambito='U' and "+where1+" upper(a_sinacentos(nom_loc)) like '%" + buscar + "%' ) order by clave "+limit;
	}
	break;
case 11:   //manzanas
    consulta="select * from ( SELECT cve_ent||' '||cve_mun||' '||cve_loc||' '||cve_ageb as cvegeo,cve_mza,box2d(ST_Transform(st_union(geom),3857))::text as salida,ambito as ambito from historico.caserio_"+corte+" where "+where1+"  cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza like '" + buscar + "%' group by cve_ent,cve_mun,cve_loc,cve_ageb,cve_mza,ambito union  SELECT cve_ent||' '||cve_mun||' '||cve_loc||' '||cve_ageb as cvegeo,cve_mza,case when geom is not null THEN box2d(ST_Transform(geom,3857))::text else 'x' end as salida,ambito from historico.manzana_"+corte+" where  "+where1+"  cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza like '" + buscar + "%' ) tt   order by cvegeo,cve_mza "+limit;
  break;
  }
//out.println( consulta );

try {
      Statement str = null;
      ResultSet rs = null;
      Connection conexion = null;
      Class.forName("org.postgresql.Driver");
      conexion = DriverManager.getConnection(
                                             "jdbc:postgresql://10.153.3.25:5434/actcargeo10",
                                             "arcgis",
                                             "arcgis"
                                            );

      str = conexion.createStatement(rs.TYPE_SCROLL_SENSITIVE, rs.CONCUR_UPDATABLE);
      rs = str.executeQuery( consulta );
      out.println( "<form action=\"buscar.jsp\" method=\"post\" name=\"enviar\"><center class='t'>RESULTADOS");
      out.println( " - CORTE: "+corte+"<br><br>");
     if (capa!=1 && capa!=10){
                select="<select name=filent class='boton' onChange='envia();''>";
                select+="<option value='00' ";if (filent.equals("00")){select+="selected";}select+=">TODAS</option>";
                select+="<option value='01' ";if (filent.equals("01")){select+="selected";}select+=">01</option>";
                select+="<option value='02' ";if (filent.equals("02")){select+="selected";}select+=">02</option>";
                select+="<option value='03' ";if (filent.equals("03")){select+="selected";}select+=">03</option>";
                select+="<option value='04' ";if (filent.equals("04")){select+="selected";}select+=">04</option>";
                select+="<option value='05' ";if (filent.equals("05")){select+="selected";}select+=">05</option>";
                select+="<option value='06' ";if (filent.equals("06")){select+="selected";}select+=">06</option>";
                select+="<option value='07' ";if (filent.equals("07")){select+="selected";}select+=">07</option>";
                select+="<option value='08' ";if (filent.equals("08")){select+="selected";}select+=">08</option>";
                select+="<option value='09' ";if (filent.equals("09")){select+="selected";}select+=">09</option>";
                select+="<option value='10' ";if (filent.equals("10")){select+="selected";}select+=">10</option>";
                select+="<option value='11' ";if (filent.equals("11")){select+="selected";}select+=">11</option>";
                select+="<option value='12' ";if (filent.equals("12")){select+="selected";}select+=">12</option>";
                select+="<option value='13' ";if (filent.equals("13")){select+="selected";}select+=">13</option>";
                select+="<option value='14' ";if (filent.equals("14")){select+="selected";}select+=">14</option>";
                select+="<option value='15' ";if (filent.equals("15")){select+="selected";}select+=">15</option>";
                select+="<option value='16' ";if (filent.equals("16")){select+="selected";}select+=">16</option>";
                select+="<option value='17' ";if (filent.equals("17")){select+="selected";}select+=">17</option>";
                select+="<option value='18' ";if (filent.equals("18")){select+="selected";}select+=">18</option>";
                select+="<option value='19' ";if (filent.equals("19")){select+="selected";}select+=">19</option>";
                select+="<option value='20' ";if (filent.equals("20")){select+="selected";}select+=">20</option>";
                select+="<option value='21' ";if (filent.equals("21")){select+="selected";}select+=">21</option>";
                select+="<option value='22' ";if (filent.equals("22")){select+="selected";}select+=">22</option>";
                select+="<option value='23' ";if (filent.equals("23")){select+="selected";}select+=">23</option>";
                select+="<option value='24' ";if (filent.equals("24")){select+="selected";}select+=">24</option>";
                select+="<option value='25' ";if (filent.equals("25")){select+="selected";}select+=">25</option>";
                select+="<option value='26' ";if (filent.equals("26")){select+="selected";}select+=">26</option>";
                select+="<option value='27' ";if (filent.equals("27")){select+="selected";}select+=">27</option>";
                select+="<option value='28' ";if (filent.equals("28")){select+="selected";}select+=">28</option>";
                select+="<option value='29' ";if (filent.equals("29")){select+="selected";}select+=">29</option>";
                select+="<option value='30' ";if (filent.equals("30")){select+="selected";}select+=">30</option>";
                select+="<option value='31' ";if (filent.equals("31")){select+="selected";}select+=">31</option>";
                select+="<option value='32' ";if (filent.equals("32")){select+="selected";}select+=">32</option></select>";
                out.println ("&nbsp;&nbsp;&nbsp;&nbsp;<font class=n>Filtrar por estado:</font>&nbsp;"+select+"<br><br>");
                out.println ("<input type='hidden' name='buscar' value='"+buscar+"'><input type='hidden' name='capa' value='"+capa+"'><input type='hidden' name='tipo' value='"+tipo+"'><input type='hidden' name='corte' value='"+corte+"'>");
        }


switch(capa){
case 3:      //municipios
    out.println( "<table border=1><tr class=n bgcolor=#BBBBBB><th>&nbsp;&nbsp;Clave&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Nombre&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    break;
case 4:     //agebs
    out.println( "<table border=1><tr class=n bgcolor=#BBBBBB><th>&nbsp;&nbsp;Clave&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Nombre&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<th>&nbsp;&nbsp;Geom&nbsp;&nbsp;");
    break;
case 7:     //rurales   --lo modifique para que buscque tanto urbanas como rurales y poligonos rurales
    out.println( "<table border=1><tr class=n bgcolor=#BBBBBB><th>&nbsp;&nbsp;Clave&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Nombre&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<th>&nbsp;&nbsp;Ambito&nbsp;&nbsp;<th>&nbsp;&nbsp;Ageb&nbsp;&nbsp;<th>&nbsp;&nbsp;Geometria&nbsp;&nbsp;");
    break;
case 11:   //manzanas
    out.println( "<table border=1><tr class=n bgcolor=#BBBBBB><th>&nbsp;&nbsp;Clave&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mza&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<th>&nbsp;&nbsp;Ambito&nbsp;&nbsp;");
    break;
  }


	out.println( "<th>&nbsp;Referencia&nbsp;");
	while(rs.next()){
            String s1=rs.getObject(1).toString();
            String s2=rs.getObject(2).toString();
            String s3=rs.getObject(3).toString();
            if (s3.equals("x")){
                ban=1;
            }else{
              salida = s3.replace("BOX(","");
              salida = salida.replace(" ",",");
              salida = salida.replace(")","");
            }
            String[] salvec = salida.split(",");
            double[] salsal = {0,0,0,0};
            out.println( "<tr class=c><td align=center>&nbsp;&nbsp;"+s1+"&nbsp;&nbsp;<td>&nbsp;&nbsp;"+s2+"&nbsp;&nbsp;");
            String s6="";
            if (capa==7){
                String s4=rs.getObject(4).toString();
                String s5=rs.getObject(5).toString();
                String s7=rs.getObject(6).toString();
                out.println( "<td align=center>&nbsp;&nbsp;"+s4+"&nbsp;&nbsp;<td align=center rowspan>"+s5+"&nbsp;&nbsp;<td rowspan>&nbsp;"+s7+"&nbsp;&nbsp;");
            }
            if (capa==4 || capa==11){
                String s4=rs.getObject(4).toString();
                out.println( "<td align=center>&nbsp;&nbsp;"+s4+"&nbsp;&nbsp;");
            }
            if (ban!=1){
              salsal[0]=Float.parseFloat(salvec[0]);
              salsal[1]=Float.parseFloat(salvec[1]);
              salsal[2]=Float.parseFloat(salvec[2]);
              salsal[3]=Float.parseFloat(salvec[3]);
            }
            if (salsal[0]==salsal[2]){
                salsal[0]=salsal[0]-2000;   //CCL , mercator
				salsal[1]=salsal[1]-2000;
				salsal[2]=salsal[2]+2000;
				salsal[3]=salsal[3]+2000;
                //salsal[0]=salsal[0]-.02000;
				//salsal[1]=salsal[1]-.02000;
				//salsal[2]=salsal[2]+.02000;
				//salsal[3]=salsal[3]+.02000;
            }
            if (ban!=1){
               if (capa==7 || capa==5){
                out.println("<td align=center><input type=button onclick='buscazoomlocal(\""+st+"\","+capa+","+salsal[0]+","+salsal[1]+","+salsal[2]+","+salsal[3]+",\""+s1+"\",\""+s6+"\");' value=' Ver d ' class='boton'>");
               }else if (capa==4 || capa==41){
                out.println("<td align=center><input type=button onclick='buscazoomlocal(\""+st+"\","+capa+","+salsal[0]+","+salsal[1]+","+salsal[2]+","+salsal[3]+",\""+s1+"\",\"0\");' value=' Ver c' class='boton'>");
               }else{
                out.println("<td align=center><input type=button onclick='window.opener.buscazoom(\""+st+"\","+capa+","+salsal[0]+","+salsal[1]+","+salsal[2]+","+salsal[3]+");' value=' Ver m' class='boton'>");
               }
            }else{
              out.println("<td align=center title='Sin coordenadas'>S/C");
            }
            n++;
            ban=0;
            capa = Integer.parseInt(request.getParameter("capa"));
        }
        rs.close();
        str.close();
        conexion.close();
	      out.println( "</table><br><font class=n>Total de Registros: " + n +"</font>");
        if (n>=100 && capa!=10){
        out.println( "<br><font class=r>* La consulta tiene un limite de 100 registros. </font>");
      }
        out.println( "<br><br>");
    }

    catch (SQLException ex){
      out.println("<script>");
      out.println("  alert(\'Se genero la expresion de SQL: "+ex.getMessage()+" !\');");
      out.println("</script>");
    }

    catch(Exception ex){
      out.println("<script>");
      out.println("  alert(\'Se genero la expresion: "+ex.getMessage()+" !\');");
      out.println("</script>");
    }

%>
</form>
</body>
<script language="javascrpt" type="text/javascript">
function buscazoomlocal(st,capa,sal1,sal2,sal3,sal4,clave,ageb){
  window.opener.buscazoom(st,capa,sal1,sal2,sal3,sal4);

}

</script>
</html>