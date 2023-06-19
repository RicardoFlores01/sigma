<%@ page import="java.util.*" session="true" %>
<%@ page import="java.io.*"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<script>
window.resizeTo(500,400);
</script>
<head>
<%
String nom = request.getParameter("nom");
try {
		String sexec="";
		String sFichero="";
		//con pass
		//sexec ="D:\\Sitio\\7z  a D:\\Sitio\\apps\\catalogos\\temp\\"+nom+" D:\\Sitio\\apps\\catalogos\\temp\\"+nom+".* -pmcc -tzip";
		//sin pass
		sexec ="D:\\Sitio\\7z  a D:\\Sitio\\apps\\catalogos\\temp\\"+nom+" D:\\Sitio\\apps\\catalogos\\temp\\"+nom+".* -tzip";
		//out.println(f1);
		//out.println(sexec);
		Runtime runtime = Runtime.getRuntime();
		Process exec = runtime.exec(sexec);
		int i = exec.waitFor();
		sFichero = "D:\\Sitio\\apps\\catalogos\\temp\\"+nom+".zip";
		File fichero = new File(sFichero);
		File file=new File(sFichero);
		out.println ("<meta http-equiv='refresh' content='0; url=http://"+request.getServerName()+":8888/catalogos/temp/"+nom+".zip'><script>setTimeout(function(){ window.close() }, 5000);</script>");
}
    catch(Exception ex){
      out.println("<script>");
      out.println("  alert(\"Se genero la expresion: "+ex.getMessage()+" !\");window.close();");
      out.println("</script>");
    }

%>
</head>
</html>