<%@ page import="java.util.*" %>
<%@ page import="java.io.*"%>
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
<style type="text/css">
table {
  border-collapse: collapse;
}
.t{font-size: 12pt; font-family: Arial; font-weight: bold; color: #000000;}
.c{font-family: Arial; font-size: 10pt; line-height: 1; font-weight: normal;}
.n{font-family: Arial; font-size: 10pt; line-height: 1.3; font-weight: bold;}
.boton{font-family: Arial; font-size: 10px; line-height: 1; font-weight: normal;}
.f{font-family: Arial; font-size: 9px; line-height: 1; font-weight: normal;}
a.liga2:link {font-family: Arial;color: black; font-size: 9pt; text-decoration: underline}
a.liga2:visited {font-family: Arial;color: black; font-size: 9pt; text-decoration: underline}
a.liga2:hover {font-family: Arial;color: black; font-size: 9pt; text-decoration: underline; background-color: #FFFFFF}

</style>
<script language="javascrpt" type="text/javascript">
window.resizeTo(500,400);
function desc(){
	if (document.enviar.forma[0].checked){
		var co = opener.map.getExtent();
		co = co.toString();
		var coord = co.split(",");
		document.enviar.c0.value=coord[0];
		document.enviar.c1.value=coord[1];
		document.enviar.c2.value=coord[2];
		document.enviar.c3.value=coord[3];
	}else{
		if (document.enviar.filtro.value.length<2){
			alert ("Debe de proporcionar algun filtro!!");
			return false;
		}
	}
	document.enviar.ban.value=1;
	document.enviar.submit();
}

function bajazip(nom){
	ventana = window.open('descargazip.jsp?nom='+nom,'ZIP','toolbar=no,Resizable=1,scrollbars=1');
    ventana.focus();
}
</script>
  </head>
<body>
<form action="descarga.jsp" method="post" name="enviar">
<%

int corte = Integer.parseInt(request.getParameter("corte"));



  	  String hostbd  = "actcargeo10";
      String remotehostbd  = "10.153.3.25";
String ban = request.getParameter("ban");
try {
	if (ban==null){
		out.println ("<center><br><table border=1 cellpadding=2>"+
		"<tr class=n bgcolor=#BBBBBB align=center><th colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Descargar informacion en SHP - CORTE: "+corte+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
		"<tr class=n align=center><td class=n align=right>Capa:&nbsp;&nbsp;<td align=left>&nbsp;&nbsp;<select class=c name=capa>"+
		"<option value=1>Entidad</option>"+
		"<option value=2>Municipio</option>"+
		"<option value=3>Ageb rural</option>"+
	  "<option value=5>Localidad urbana</option>"+
		"<option value=4>Ageb urbana</option>"+
		"<option value=6>Loc rural amanzanada</option>"+
		"<option value=61>Poligono externo</option>"+
		"<option value=7>Loc rural  (puntos)</option>"+
		"<option value=9>Manzanas</option>"+
		"<option value=13>Caserio</option>"+
		"</select>"+
		"<tr class=c align=center><td class=n align=right>Forma:&nbsp;&nbsp;<td align=left class=c>"+
		"&nbsp;&nbsp;<input class='boton' type='radio' name='forma' value='1' checked>Por extension de mapa<br>"+
		"&nbsp;&nbsp;<input class='boton' type='radio' name='forma' value='2'>Por filtro de clave"+
		"<tr class=c align=center><td class=n align=right>Filtro:&nbsp;&nbsp;<td align=left class=c>&nbsp;&nbsp;<input class='boton' type='text' name='filtro'>"+
		"<input type='hidden' name=corte value="+corte+"><input type='hidden' name=c0><input type='hidden' name=c1><input type='hidden' name=c2><input type='hidden' name=c3><input type='hidden' name=ban><input type='hidden' name=as><input type='hidden' name=vial>");
		out.println ("<tr><td colspan=2>&nbsp;<tr><td nowrap colspan=2 align=center><input class='boton' type='Button' name='descargar' onClick='desc();' value=' Descargar SHP '/>");
		out.println ("</table><br><font class=f>* Se limita la descarga a 500,000 rasgos</font>");
	}else{
	  int capa = Integer.parseInt(request.getParameter("capa"));
	  int forma = Integer.parseInt(request.getParameter("forma"));
	  String filtro = request.getParameter("filtro").replace("-","");
	  Random rnd = new Random();
		String nom="Exp_"+corte+"_"+rnd.nextInt(10000);
		String f1="",f2="";
		String base="actcargeo10";
		if (forma==1){
			String c0 = request.getParameter("c0");
			String c1 = request.getParameter("c1");
			String c2 = request.getParameter("c2");
			String c3 = request.getParameter("c3");
			switch (capa){
			case 1:
				f1="select cve_ent,nom_ent,st_transform(geom,6362) as geom from historico.entidad_"+corte+" where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913) order by cve_ent";
				break;
			case 2:
				f1="select cve_ent,cve_mun,nom_mun,st_transform(geom,6362) as geom from historico.municipio_"+corte+"  where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913) order by cve_ent||cve_mun";
				break;
			case 3:
				f1="select cve_ent,cve_mun,replace(cve_ageb,'-','') as cve_ageb,st_transform(geom,6362) as geom from historico.ageb_"+corte+"  where  geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_ageb";
				break;
			case 4:
				f1="select cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,st_transform(geom,6362) as geom from historico.agebu_"+corte+"   where  geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_ageb";
				break;
			case 5:
				f1="select cve_ent,cve_mun,cve_loc,nom_loc,ambito,st_transform(geom,6362) as geom from historico.l_"+corte+" where substring(ambito,1,1)='U' and geom  && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_loc";
				break;
			case 6:
				f1="select cve_ent,cve_mun,cve_loc,nom_loc,ambito,st_transform(geom,6362) as geom from historico.l_"+corte+" where substring(ambito,1,1)='R' and geom  && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_loc";
				break;
			case 61:
				f1="select cvegeo,st_transform(geom,6362) as geom from historico.pe_"+corte+" where geom  && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cvegeo";
				break;
			case 7:
				f1="select cve_ent,cve_mun,replace(cve_ageb,'-','') as cve_ageb,cve_loc,nom_loc,ambito,st_transform(geom,6362) as geom from historico.lpr_"+corte+"  where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_loc";
				break;
			case 9:
				f1="select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_transform(geom,6362) as geom from historico.manzana_"+corte+" where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza ";
				break;
			case 13:
				f1="select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_transform(geom,6362) as geom from historico.caserio_"+corte+" where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza ";
				break;
			case 14:
				f1="select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_transform(geom,6362) as geom from historico.manzana_"+corte+" where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913) union select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_collect(st_triangle_32800(st_transform(geom,6362),5.3)) as geom from historico.caserio_"+corte+" where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913) group by cve_ent,cve_mun,cve_loc,cve_ageb,cve_mza order by cve_ent,cve_mun,cve_loc,cve_ageb,cve_mza";
				break;
			}
		}else{  //forma=2
			switch (capa){
			case 1:
				f1="select cve_ent,nom_ent,st_transform(geom,6362) as geom  from historico.entidad_"+corte+" where cve_ent ilike '"+filtro+"%' order by cve_ent";
				break;
			case 2:
								f1="select cve_ent,cve_mun,nom_mun,st_transform(geom,6362) as geom  from historico.municipio_"+corte+"  where  cve_ent||cve_mun  ilike '"+filtro+"%' order by  cve_ent||cve_mun";
				break;
			case 3:
				f1="select cve_ent,cve_mun,replace(cve_ageb,'-','') as cve_ageb,st_transform(geom,6362) as geom  from historico.ageb_"+corte+"  where   cve_ent||cve_mun||cve_ageb  ilike '"+filtro+"%'  order by cve_ent||cve_mun||cve_ageb";

				break;
			case 4:
				f1="select cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,st_transform(geom,6362) as geom  from historico.agebu_"+corte+"  where   cve_ent||cve_mun||cve_loc||cve_ageb  ilike '"+filtro+"%'  order by cve_ent||cve_mun||cve_loc||cve_ageb";
				break;
			case 5:
				f1="select cve_ent,cve_mun,cve_loc,nom_loc,ambito,st_transform(geom,6362) as geom  from historico.l_"+corte+" where substring(ambito,1,1)='U'  and cve_ent||cve_mun||cve_loc ilike '"+filtro+"%'  order by cve_ent||cve_mun||cve_loc";
				break;
			case 6:
				f1="select cve_ent,cve_mun,cve_loc,nom_loc,ambito,st_transform(geom,6362) as geom  from historico.l_"+corte+" where substring(ambito,1,1)='R'  and cve_ent||cve_mun||cve_loc ilike '"+filtro+"%'  order by cve_ent||cve_mun||cve_loc";
				break;
			case 61:
				f1="select cvegeo,st_transform(geom,6362) as geom  from historico.pe_"+corte+" where cvegeo ilike '"+filtro+"%'  order by cvegeo";
				break;
			case 7:
				f1="select cve_ent,cve_mun,replace(cve_ageb,'-','') as cve_ageb,cve_loc,nom_loc,ambito,st_transform(geom,6362) as geom  from historico.lpr_"+corte+" where cve_ent||cve_mun||cve_loc ilike '"+filtro+"%'  order by cve_ent||cve_mun||cve_loc";
				break;
			case 9:
				f1="select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_transform(geom,6362) as geom  from historico.manzana_"+corte+" where cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza ilike '"+filtro+"%' order by cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza ";
				break;
			case 13:
				f1="select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_transform(geom,6362) as geom  from historico.caserio_"+corte+" where cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza ilike '"+filtro+"%' order by cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza ";
				break;
			case 14:

				f1="select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_transform(geom,6362) as geom  from historico.manzana_"+corte+" where cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza ilike '"+filtro+"%' union select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_collect(st_triangle_900913(st_transform(geom,6362),5.3)) as geom from historico.caserio_"+corte+" where cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza ilike '"+filtro+"%' group by cve_ent,cve_mun,cve_loc,cve_ageb,cve_mza order by cve_ent,cve_mun,cve_loc,cve_ageb,cve_mza";
				break;
			}
		}
		f1= f1+" limit 500000";
		String sexec="";
		String sFichero="";
		String user="-P arcgis -u arcgis";
		remotehostbd=remotehostbd+" -p 5434 ";
		sexec ="D:\\Sitio\\PostgreSQL\\9.2\\bin\\pgsql2shp -f D:\\Sitio\\apps\\catalogos\\temp\\"+nom+".shp -h "+remotehostbd+" "+user+" "+hostbd+" \""+f1+"\"";
		//out.println(f1);
		//out.println(sexec);
		Runtime runtime = Runtime.getRuntime();
		Process exec = runtime.exec(sexec);
		int i = exec.waitFor();
		sFichero = "D:\\Sitio\\apps\\catalogos\\temp\\"+nom+".shp";
		File fichero = new File(sFichero);
		File file=new File(sFichero);
		if (file.exists()){
			out.println ("<center><br><table border=1>");
			out.println ("<tr class=n bgcolor=#BBBBBB><th>TIPO<th>LINK");
			out.println ("<tr align=center><td class=c align=center>PRJ<td align=center class=c><a href='http://"+request.getServerName()+":8888/catalogos/temp/"+nom+".prj'>Descargar<a>");
			out.println ("<tr align=center><td class=c align=center>SHX<td align=center class=c><a href='http://"+request.getServerName()+":8888/catalogos/temp/"+nom+".shx'>Descargar<a>");
			out.println ("<tr align=center><td class=c align=center>DBF<td align=center class=c><a href='http://"+request.getServerName()+":8888/catalogos/temp/"+nom+".dbf'>Descargar<a>");
			out.println ("<tr align=center><td class=c align=center>SHP<td align=center class=c><a href='http://"+request.getServerName()+":8888/catalogos/temp/"+nom+".shp'>Descargar<a>");
			out.println ("<tr align=center><td colspan=2 class=c>&nbsp;");
			out.println ("<tr align=center><td colspan=2 class=c>(Boton derecho, Guardar Como...)");
			//if (capa==53){
				out.println ("<tr align=center><td colspan=2 class=c>&nbsp;");
				//out.println ("<tr align=center><td colspan=2 class=c onclick='bajazip(\""+nom+"\")'><a href=#>Descargar ZIP para MCC</a>");
				out.println ("<tr align=center><td colspan=2 class=c onclick='bajazip(\""+nom+"\")'><a href=#>Descargar ZIP </a>");
			//}
			out.println ("</table>");
		}else{
			out.println ("<center><br><table border=1>");
			out.println ("<tr class=n bgcolor=#BBBBBB><th>TIPO<th>LINK");
			out.println ("<tr align=center><td colspan=2 class=c>&nbsp;");
			out.println ("<tr align=center><td colspan=2 class=c>Falta informacion...");
			out.println ("<tr align=center><td colspan=2 class=c>&nbsp;");
			out.println ("</table>");
		}
	out.println ("<center><br><br><A class='liga2' HREF='"+request.getRequestURL()+"?corte="+corte+"'>Descargar otro SHP...</a></center>");

	}
}
    catch(Exception ex){
      out.println("<script>");
      out.println("  alert(\"Se genero la expresion: "+ex.getMessage()+" !\");");
      out.println("</script>");
    }
    

%>
</form>
</body>
</html>