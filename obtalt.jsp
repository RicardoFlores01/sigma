<%@ page language="java" %>
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>

<%
/*String x = "-109.83061"; // coordenada x
String y = "24.05947"; // coordenada y*/

String  x = request.getParameter("x");
String  y = request.getParameter("y");

String cmd = "C:/OSGeo4W64/bin/gdallocationinfo -valonly -wgs84 D:/Nacional30_R15m.tif " + x + " " + y;

try {
    Runtime r = Runtime.getRuntime();
    Process p = r.exec(cmd);
    InputStream is = p.getInputStream();
    InputStreamReader isr = new InputStreamReader(is);
    BufferedReader br = new BufferedReader(isr);
    String line = br.readLine();
    if (line == null || line.isEmpty()) {
        out.println("0");
    } else {
        out.println(line);
    }
} catch (Exception ex) {
    out.println("x");
}
%>
