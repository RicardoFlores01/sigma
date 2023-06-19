<%@ page import="java.util.*" %>
<%@ page import="java.sql.*"%>
<%@     page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>SIGMA - Historico</title>

   <!-- ESTILOS --> 
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" type="text/css" href="resources/ol/ol.css">
    <!-- Bootstrap --> 
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">

</head>
<body style="background-image:url('resources/images/fondo1.jpg'); background-repeat: no-repeat; background-size: cover;">

<script>
  var nored=0;
  function enviarkey(e){
    key = (document.all) ? e.keyCode : e.which;
    if (key==13){
      enviarpass();
      return false;
    }
  }

  function enviarpass(){
    document.inicia.password.value=MD5(document.inicia.password.value.toUpperCase());
    document.inicia.submit()
  }

  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'UA-147950442-1');

</script>

  <div id="login_center">
      <center>
        <img src="resources/images/sigma.png" width="130" height="90" style="margin-top: 20px;">
        <label id="label_title">Sistema de Información Geográfica del Marco Geoestadistico</label><br><br>
      </center>
      <form method="post" action="index.jsp">
        <div class="mb-3" id="input_login">
          <input type="password" name="password" 
           class="form-control" placeholder="Usuario" autocomplete="off">
        </div>
        <br><br>
        <input type="submit" value="Ingresar" class="btn btn-outline-secondary" id="buton_login">

        <input type="hidden" name="ban" value="1">
      </form>
  </div>

  <div id="div_botom_login">
      <center id="center_login">
        <label>Analisis diseño y desarrollo:</label><br>
        <a href="">Neatil Ceballos</a>
      </center>
  </div>

<% 
    if (request.getMethod().equals("POST")) {
        // Obtener los datos enviados desde el formulario
        String pass = request.getParameter("password");
        
        // Conectar a la base de datos
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        
        try 
        { 
            Class.forName("org.postgresql.Driver");
            connection = DriverManager.getConnection("jdbc:postgresql://geogat046068d.inegi.gob.mx:5432/catalogos", "arcgis", "arcgis");
            
            // Verificar si el usuario y la contraseña son válidos
            String sql = "SELECT id,regid,nivel,nombre,edicion,cons,edicionmz,edicionpre,edicionagpr,restric,userdg,passdg,correo as correodg  FROM usuarios WHERE password = ?";

            statement = connection.prepareStatement(sql);
            statement.setString(1, pass);
            resultSet = statement.executeQuery();
        
            if(pass == null || pass.isEmpty())
            {
%>
                <center>
                    <div class="alert alert-danger" role="alert" id="user_incorrect">
                        <label>Ingrese un usuario</label>
                    </div>
                </center>    
<%
                return; // Importante: detener la ejecución del código
            } else if (resultSet.next()) {
                // Inicio de sesión exitoso, redireccionar a una página de éxito
%>
                <center>
                    <div class="alert alert-success" role="alert" id="user_incorrect">
                        <label>Ingreso exitoso</label>
                    </div>
                </center>    
<%
                session.setAttribute("password", pass);
                response.sendRedirect("mapa.jsp");
            } else {
%>
                <center>
                    <div class="alert alert-danger" role="alert" id="user_incorrect">
                        <label>Usuario incorrecto</label>
                    </div>
                </center>
<%
                return; // Importante: detener la ejecución del código
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error en la BD");
            return; // Importante: detener la ejecución del código
        } finally {
            // Cerrar la conexión a la base de datos y liberar los recuresultSetos
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>



    <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.4.4/proj4.js"></script>
    <script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.5.0/build/ol.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script type="text/javascript" src="resources/ol/ol.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
</body>
</html>