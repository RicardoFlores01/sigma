<%@ page import="java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.File" %>


<!DOCTYPE html>
<html lang="ES">
<head>
    <title>SIGMA</title>
    <meta charesultSetet="UTF-8">

    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width"/>
    <!-- ESTILOS --> 
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" type="text/css" href="resources/ol/ol.css">
    <!-- Bootstrap --> 
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">

</head>

<body>

  <%
    int n1=0;
    String ban1="",cat="",c0="",c1="",c2="",c3="",c4="",st1="",capa1="",clave="",mandaageb="",cons="", id="",regid="", nivel="", nombre="",regionalid="", txt1="",txt2="",edicion="",edicionmz="",edicionpre="",edicionagpr="",restric="",userdg="",passdg="",correodg="";
        
    String host="";
    String hostbd="";
    String remotehostbd="";
    String localhost="";
    String vpn="";

    String servimg="";
    int permisoimgex1=0;
    int capasextra=0;
    int capasalto=490;


    // Verificar si el usuario ha iniciado sesión
    String pass = (String) session.getAttribute("password");

    if (pass == null) {
      // Si no ha iniciado sesión, redirigir al formulario de inicio de sesión
      response.sendRedirect("index.jsp");
    } else {
      // El usuario ha iniciado sesión, mostrar mensaje de bienvenida
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

        if (resultSet.next()) {
          do{
              n1=1;
              id=resultSet.getObject(1).toString();
              regid=resultSet.getObject(2).toString();
              nivel=resultSet.getObject(3).toString();
              nombre=resultSet.getObject(4).toString();
              edicion=resultSet.getObject(5).toString();
              cons=resultSet.getObject(6).toString();
              edicionmz=resultSet.getObject(7).toString();
              edicionpre=resultSet.getObject(8).toString();
              edicionagpr=resultSet.getObject(9).toString();

              if (nivel.equals("1")){
                txt1+=" (EDICION DE LA ENTIDAD "+id+") ";
                //txt1=" (ENTIDAD "+id+") ";
              }else if (nivel.equals("2")){
                txt1+=" (CONSULTA REGIONAL "+id+") ";
                //txt1=" (ENTIDAD "+id+") ";
              }else if (nivel.equals("3") || nivel.equals("5")  ){
                txt1+=" - ADMIN ";
              }else{
                txt1=" (CONSULTA)";
              }

              // ENTRA AL HTML DEL MAPA
%>
    <div id="map"></div>
    <div id="coordinates"></div>
    <div id="menu_btn">
        <button data-bs-toggle="offcanvas" data-bs-target="#offcanvasWithBothOptions" aria-controls="offcanvasWithBothOptions" class="btn_menu" id="btn_menu" 
        style="margin-left:15px; margin-top: 5px;">
            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-list" viewBox="0 0 16 16">
                <path fill-rule="evenodd" d="M2.5 12a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0  1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5z"/>
            </svg>
        </button>
    </div>

    <div id="nombre"></div>

    <div id="header">
        <label style="margin-top: 15px; font-size: 12px;">
            <b><% out.println(nombre + " " + txt1); %></b>
        </label>  
        <button id="btnReload" onclick="reload();"><label id="labelReload">F5</label></button>
        <div id="coords" class="coordenadas"></div>
    </div>

    <div class="dropdown" id="dropdown">
        <a class="" href="#" role="" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false" style="color:black;">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-three-dots-vertical" viewBox="0 0 16 16" style="margin-top: 15px;">
            <path d="M9.5 13a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"/>
        </svg>
        </a>
        <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
            <li><a class="dropdown-item" href="#" onclick="ocultar_header();">Ocultar elementos</a></li>
            <li><a class="dropdown-item" href="#" onclick="mostrar_header()">Mostrar elementos</a></li>
        </ul>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h1 class="modal-title fs-5" id="exampleModalLabel">Ventana emergente</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            Al recargar la página se perderán todas las capas y elementos seleccionados lo cual ya no serán mostrados. <br> <b>¿Está de acuerdo en recargar la página?</b>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="width:100px; margin-left: 15px;">No</button>
            <button type="button" class="btn btn-primary" style="width:100px;" onclick="yesreload();">Si</button>
          </div>
        </div>
      </div>
    </div>

    <div id="msjs">
        <label id="mensajes">Mensaje</label>
        <button type="button" class="btn-close closebtn" onclick="getElementById('msjs').style.display = 'none';"></button>
        <div style="border:1px solid #EEEEEE; width:95%; margin: 0 auto; margin-top:2px;"></div>
        <div id="" style="margin-top:5px; margin-left: 10px; font-size: 16px;"><div id="textomsg"></div></div>
    </div>

    <br><br>
  
    <div class="icon_access" id="icon_access">
        <center>
          <button class="sidebar_btns"id="btnInfo"><input type="checkbox"id="chbxinfo" hidden><label for="chbxinfo"><img src="resources/images/info_off.png"width="20"height="20"></label></button>
          <button class="sidebar_btns" id="altitudbtn" onclick=""><input type="checkbox"id="chbxaltitud" hidden><label for="chbxaltitud"><img src="resources/images/altitud_off.png" /></label></button>
          
          <button class="sidebar_btns" id="medir" onclick=""><input type="checkbox"id="chbxmedir" hidden><label for="chbxmedir"><img src="resources/images/measuring-stick-off.png" /></label> </button>
          <!--<button class="sidebar_btns"><img src="resources/images/drag-rectangle-off.png" /> </button>-->
          <button class="sidebar_btns" id="desplazar"><input type="checkbox" id="chbxdesplazar" hidden><label for="chbxdesplazar"><img src="resources/images/desplazar.PNG"/></label></button>
          <button class="sidebar_btns" id="previa" onclick="window.history.back()"><img src="resources/images/view_previous_on.png" /></button>
          <button class="sidebar_btns" onclick="window.history.forward()"><img src="resources/images/view_next_on.png" /> </button>
        </center>
    </div>

    <div class="medir_box" id="boxmedir">
        <form>
            <select class="form-select" aria-label="Default select example" id="type">
                <option selected>Selecciona un tipo de medición</option>
                <option value="length">Linea</option>
                <option value="area">Área</option>  
            </select>
        </form>
    </div>

    <div class="offcanvas offcanvas-start" data-bs-scroll="true" tabindex="-1" id="offcanvasWithBothOptions" aria-labelledby="offcanvasWithBothOptionsLabel">
        <div class="offcanvas-header">
            <h5 class="offcanvas-title" id="offcanvasWithBothOptionsLabel">SIGMA</h5>
            <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
        </div>
        
        <div class="offcanvas-body">
            <div class="sidebar" id="sidebar" data-bs-scroll="true" tabindex="-1" id="offcanvasWithBothOptions" aria-labelledby="offcanvasWithBothOptionsLabel">
                <div class="card_sidebar">
                    <div class="accordion" id="accordionExample">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingOne">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                    Capas base
                                </button>
                            </h2>
                    
                            <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
                                <div class="accordion-body">
                                    <label class="title_menu">
                                        <b>CAPAS BASE</b>
                                        <input class="form-check-input" type="radio" name="cb" id="mdm" style="margin-left: 10px; font-size:15px; margin-top: 9px;">

                                        <button onclick="mas()" class="btnMas">
                                             <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-plus" viewBox="0 0 16 16">
                                                <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
                                            </svg>
                                        </button>

                                        <button onclick="menos()" class="btnMenos">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-dash" viewBox="0 0 16 16">
                                                <path d="M4 8a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7A.5.5 0 0 1 4 8z"/>
                                            </svg>
                                        </button>
                                    </label>
                                    <br><br>


                                    <!--<div class="form-check" style="margin-top: -15px;">
                                        <input class="form-check-input" type="radio" name="cb" id="spot6">
                                        <label class="form-check-label" for=""><img src="resources/images/map.png"> Spot-6</label>
                                    </div>-->

                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="cb" id="dg_dggmaradio">
                                        <label class="form-check-label" for=""><img src="resources/images/map.png"> DG-DGGMA</label>
                                    </div><hr>

                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="cb" id="flexRadioDefault2">
                                        <label class="form-check-label" for="flexRadioDefault2"><img src="resources/images/otmap.png"> Digital Global</label>
                                    </div><br>
                                
                                    <label class="F" style="width:10%;">F<:</label>
                                    <input type="date" class="form-control formDate" aria-label=".form-control-sm example" style="width:90%;"><br>

                                    <label class="N" style="width:10%;">N:</label>
                                    <select class="form-control formSelect" style="width: 90%;">
                                        <option selected>N/A%</option>
                                        <option>50%</option>
                                        <option>45%</option>
                                        <option>40%</option>
                                        <option>35%</option>
                                        <option>30%</option>
                                        <option>25%</option>
                                        <option>20%</option>
                                        <option>15%</option>
                                        <option>10%</option>
                                        <option>9%</option>
                                        <option>8%</option>
                                        <option>7%</option>
                                        <option>6%</option>
                                        <option>5%</option>
                                        <option>4%</option>
                                        <option>3%</option>
                                        <option>2%</option>
                                        <option>1%</option>
                                        <option>0%</option>
                                    </select> <hr>

                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="cb" id="google">
                                        <label class="form-check-label" for="google"><img src="resources/images/otmap.png">  Google Maps</label>
                                    </div><br>

                                    <div class="form-check" style="margin-top: -15px;">
                                        <input class="form-check-input" type="radio" name="cb" id="bing">
                                        <label class="form-check-label" for=""><img src="resources/images/map.png"> Bing Map</label>
                                    </div><br>

                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingTwo">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">Capas</button>
                            </h2>

                            <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
                                <div class="accordion-body">
                                    <label class="title_menu"><b>CAPAS</b></label><br><br>
                                    <div class="row">
                                        <div class="col">
                                            <center>
                                                <div class="btnCapas" id="btnEstados" style="background-color: #FFEBEE;">
                                                    <input class="form-check-input" type="checkbox" value="" id="state" name="state" checked style="display:none;">
                                                    <label for="state"><img src="resources/images/ent.PNG" style="margin-top:18px;" width="27" height="27" id="estadosBtn"></label>
                                                </div>

                                                <input class="form-check-input" type="checkbox" name="txtEstados" style="margin-top:4px;" id="txtEstados" value="" checked>
                                                <label>Estados</label>
                                            </center>
                                        </div>
                                    
                                        <div class="col">
                                             <center>
                                                <div class="btnCapas" id="btnMunicipios">
                                                    <input type="checkbox" name="muni" value="" id="muni" style="display:none;">
                                                    <label for="muni"><img src="resources/images/municipio.PNG" style="margin-top:18px;" width="27" height="27"></label> 
                                                </div>

                                                <input class="form-check-input" type="checkbox" name="txtMunicipios" style="margin-top:4px;" id="txtMunicipios" value="">
                                                <label>Municipios</label>
                                            </center>
                                        </div>
                                    </div>
                                    <br>
                                    <div class="row">
                                        <div class="col">
                                            <center>
                                                <div class="btnCapas" id="btnAgebRural">
                                                    <input type="checkbox" id="agebrural" name="agebrural" style="display: none;">
                                                    <label for="agebrural"><img src="resources/images/ag.png" style="margin-top:20px;" width="20" height="20"></label>
                                                </div>

                                                <input class="form-check-input" type="checkbox" name="txtAgebRural" id="txtAgebRural" value="" style="margin-top:4px;">
                                                <label>Ageb Rural</label>
                                            </center>
                                        </div>
                            
                                        <div class="col">
                                             <center>
                                                <div class="btnCapas" id="btnLocUrbana">
                                                    <input type="checkbox" name="locurbana" id="locurbana" style="display: none;">
                                                    <label for="locurbana"><img src="resources/images/lou.png" style="margin-top:20px;" width="20" height="20"></label> 
                                                </div>

                                                <input class="form-check-input" type="checkbox" name="txtLocUrbana" id="txtLocUrbana" style="margin-top:4px;">
                                                <label>Loc. Urbana</label>
                                            </center>
                                        </div>
                                    </div>
                                    <br>
                                    <div class="row">
                                        <div class="col">
                                            <center>
                                                <div class="btnCapas" id="btnAgebUrbana">
                                                    <input type="checkbox" name="chbxageburbana" id="chbxageburbana" style="display: none;">
                                                    <label for="chbxageburbana"><img src="resources/images/ag.png" style="margin-top:20px;" width="20" height="20"></label>
                                                </div>
                                                </label>

                                                <input class="form-check-input" type="checkbox" name="txtageburbana" id="txtageburbana" style="margin-top:4px;">
                                                <label>Ageb Urbana</label>
                                            </center>
                                        </div>
                                    
                                        <div class="col">
                                             <center>
                                                <div class="btnCapas" id="btnLocRural">
                                                    <input type="checkbox" name="chbxlocrural" id="chbxlocrural" style="display: none;">
                                                    <label for="chbxlocrural"><img src="resources/images/lor.png" style="margin-top:20px;" width="20" height="20"></label> 
                                                </div>

                                                <input class="form-check-input" type="checkbox" name="chbxtxtlocrural" id="chbxtxtlocrural" style="margin-top:4px;">
                                                <label>Loc. Rural</label>
                                            </center>
                                        </div>
                                    </div><br>

                                    <div class="row">
                                        <div class="col">
                                            <center>
                                                <div class="btnCapas" id="btnLocRur_Ext">
                                                    <input type="checkbox" name="chbxlocrur_ext" id="chbxlocrur_ext" style="display: none;">
                                                    <label for="chbxlocrur_ext"><img src="resources/images/lorext.png" style="margin-top:20px;" width="20" height="20"></label> 
                                                </div>
                                                <label>Loc. Externo</label>
                                            </center>
                                        </div>
                                    
                                        <div class="col">
                                             <center>
                                                <div class="btnCapas" id="btnMza">
                                                    <input type="checkbox" name="chbxmanzana" id="chbxmanzana" style="display: none;">
                                                    <label for="chbxmanzana"><img src="resources/images/mzn.png" style="margin-top:20px;" width="20" height="20"></label> 
                                                </div>

                                                <input class="form-check-input" type="checkbox" name="chbxtxtmanzana" id="chbxtxtmanzana" style="margin-top:4px;">
                                                <label>Manzs base</label>
                                            </center>
                                        </div>
                                    </div> <br>
                            
                                    <div class="row">
                                        <div class="col">
                                            <center>
                                                <div class="btnCapas" id="btnCaserio">
                                                    <input type="checkbox" name="chbxcaserio" id="chbxcaserio" style="display: none;">
                                                    <label for="chbxcaserio"><img src="resources/images/caserio.png" style="margin-top:20px;" width="20" height="20"></label> 
                                                </div>
                                                <label>Caserio</label>
                                            </center>
                                        </div>
                                    
                                        <div class="col">
                                             <center>
                                                <div class="btnCapas" id="btnLocVig">
                                                    <input type="checkbox" name="chbxlocvig" id="chbxlocvig" style="display: none;">
                                                    <label for="chbxlocvig"><img src="resources/images/lrv.png" style="margin-top:20px;" width="20" height="20"></label> 
                                                </div>

                                                <input class="form-check-input" type="checkbox" name="chbxtxtlocvig" id="chbxtxtlocvig" style="margin-top:4px;">
                                                <label>Locs. Vigentes</label>
                                            </center>
                                        </div>
                                    </div>
                                    <br><br><br>
                                </div>
                            </div>

                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingThree">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">Buscar
                                    </button>
                                </h2>
                                <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#accordionExample">
                                    <div class="accordion-body">
                                        <label class="title_menu"><b>Buscar </b></label>
                                        <br><br>
                                        <form name="busqueda" action="mapa.jsp" method="GET">
                                            <select class="form-select" name="capa" aria-label="Default select example">
                                              <option value="3">Municipios</option>
                                              <option value="4">AGEBS</option>
                                              <option value="7" selected>Localidades</option>
                                              <option value="11">Manzanas</option>
                                            </select>
                                            <br>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="tipo" value="0" id="flexRadioDefault1" checked>
                                                <label class="form-check-label" for="flexRadioDefault1">
                                                    Clave
                                                </label>
                                            </div>
                                            <div class="form-check">
                                              <input class="form-check-input" type="radio" name="tipo" value="1" id="flexRadioDefault2">
                                              <label class="form-check-label" for="flexRadioDefault2">
                                                Nombre
                                              </label>
                                            </div><br>
                                            <div class="mb-3">
                                              <label for="exampleFormControlInput1" class="form-label">Texto a buscar</label>
                                              <input type="text" class="form-control" id="exampleFormControlInput1" name="buscar">
                                            </div><br>
                                            <input type="text" name="corte" value="2022" hidden>

                                            <button type="submit" class="btn btn-outline-primary" id="search" name="search" onclick="mostrarContenido(this.name)">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
                                                    <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                                                </svg>  
                                                Buscar
                                            </button>
                                            <button type="submit" class="btn btn-outline-primary" style="margin-left:15px;" name="buscarCorte" id="buscarCorte" onclick="mostrarContenido(this.name)">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-scissors" viewBox="0 0 16 16">
                                                    <path d="M3.5 3.5c-.614-.884-.074-1.962.858-2.5L8 7.226 11.642 1c.932.538 1.472 1.616.858 2.5L8.81 8.61l1.556 2.661a2.5 2.5 0 1 1-.794.637L8 9.73l-1.572 2.177a2.5 2.5 0 1 1-.794-.637L7.19 8.61 3.5 3.5zm2.5 10a1.5 1.5 0 1 0-3 0 1.5 1.5 0 0 0 3 0zm7 0a1.5 1.5 0 1 0-3 0 1.5 1.5 0 0 0 3 0z"/>
                                                </svg> 
                                                Buscar por corte
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingFour">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">Punto
                                    </button>
                                </h2>
                                <div id="collapseFour" class="accordion-collapse collapse" aria-labelledby="headingFour" data-bs-parent="#accordionExample">
                                    <div class="accordion-body">
                                        <label class="title_menu"><b>Punto </b></label>
                                        <br><br>
                                        <form name="busqueda">
                                            <div class="mb-3">
                                              <label for="exampleFormControlInput1" class="form-label">LONGITUD (X)</label>
                                              <input type="text" class="form-control" name="longitud" id="longitud" maxlength="20" value="" onkeypress="return datonum(event)">
                                            </div>

                                            <div class="mb-3">
                                              <label for="exampleFormControlInput1" class="form-label">LATITUD (Y)</label>
                                              <input type="text" class="form-control" id="latitud" name="latitud" maxlength="20" value="" onkeypress="return datonum(event)">
                                            </div>

                                            <button type="submit" class="btn btn-outline-primary" onclick="addPunto()">
                                                Agregar coordenada
                                            </button>
                                            <button type="submit" class="btn btn-outline-primary" style="margin-left:15px;" onclick="deletePunto();">
                                                Borrar puntos
                                            </button>
                                        </form>
<br><br>
                                            <a href="?download"><button type="submit" class="btn btn-outline-primary" name="downloadInfo" id="downloadInfo" onclick="download();">
                                                Descargar informacion
                                            </button></a>
                                       
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div> 
            </div>
        </div>
    </div>

    <div id="escala"></div>
    <div id="output">COR</div>

    <div id="scaleline-metric" class="scaleline-external"></div>
    <div id="scaleline-imperial" class="scaleline-external"></div>

    <div class="icon_access_bottom" id="icon_access_bottom">
        <center>
            <div style="margin-top: 10px;">
                <form oninput="changeVar(rangeField.value,rangeField.min, rangeField.max)" name="fi" id="fi">
                        <label class="sliderBar">CORTES HISTÓRICO
                            <input id="rangeField" type="range" min="0" max="100" value="100" step="10" list="mydata" class="progress" style="margin-top:10px;" 
                            oninput="showVal(this.value)">
                            <!-- <output id="output" value="0">0</output> -->
                            <datalist id="mydata" style="display:flex; justify-content: space-between;">
                                <option value="0" label="90"></option>
                                <option value="10"  label="95"></option>
                                <option value="20" label="00"></option>
                                <option value="30"  label="05"></option>
                                <option value="40" label="10"></option>
                                <option value="50"  label="15"></option>
                                <option value="60" label="18"></option>
                                <option value="70"  label="19"></option>
                                <option value="80" label="20"></option>
                                <option value="90"  label="21"></option>
                                <option value="100" label="22"></option>
                            </datalist>
                            <label style="font-size:13px;"></label>
                            <input type="number" style="font-size:10px; display:none;" id="rangenumber" value="2022" name="rangeSal" id="rangeSal"><br><br>
                        </label>
                </form>
            </div>
        </center>
    </div>
    <script>
function changeVar(value) {
  //console.log(value);
}

function download(){
     document.getElementById('download_div').style.display = 'block';

}

window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());
gtag('config', 'UA-147950442-1');

</script>

<!--    download_div   -->
<div id="download_div">
<%
    if(request.getParameter("descargar") != null)
    {
        int corte1 = 2022;
        String hostbd1 = "actcargeo10";
        String remotehostbd1 = "10.153.3.25";
        int capa2 = Integer.parseInt(request.getParameter("capa"));
        int forma1 = Integer.parseInt(request.getParameter("forma"));
        String filtro1 = request.getParameter("filtro").replace("-","");

        //out.println(corte1 + " " + hostbd1 + " " + remotehostbd1 + " " + capa2 + " " + forma1 + " " + filtro1);

        Random rnd = new Random();
        String nom="Exp_"+corte1+"_"+rnd.nextInt(10000);
        String f1="",f2="";
        String base="actcargeo10";
        if (forma1==1)
        {
            c0 = request.getParameter("c0");
            c1 = request.getParameter("c1");
            c2 = request.getParameter("c2");
            c3 = request.getParameter("c3");
            switch (capa2)
            {
                case 1:
                    f1="select cve_ent,nom_ent,st_transform(geom,6362) as geom from historico.entidad_"+corte1+" where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913) order by cve_ent";
                    break;
                case 2:
                    f1="select cve_ent,cve_mun,nom_mun,st_transform(geom,6362) as geom from historico.municipio_"+corte1+"  where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913) order by cve_ent||cve_mun";
                    break;
                case 3:
                    f1="select cve_ent,cve_mun,replace(cve_ageb,'-','') as cve_ageb,st_transform(geom,6362) as geom from historico.ageb_"+corte1+"  where  geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_ageb";
                    break;
                case 4:
                    f1="select cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,st_transform(geom,6362) as geom from historico.agebu_"+corte1+"   where  geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_ageb";
                    break;
                case 5:
                    f1="select cve_ent,cve_mun,cve_loc,nom_loc,ambito,st_transform(geom,6362) as geom from historico.l_"+corte1+" where substring(ambito,1,1)='U' and geom  && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_loc";
                    break;
                case 6:
                    f1="select cve_ent,cve_mun,cve_loc,nom_loc,ambito,st_transform(geom,6362) as geom from historico.l_"+corte1+" where substring(ambito,1,1)='R' and geom  && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_loc";
                    break;
                case 61:
                    f1="select cvegeo,st_transform(geom,6362) as geom from historico.pe_"+corte1+" where geom  && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cvegeo";
                    break;
                case 7:
                    f1="select cve_ent,cve_mun,replace(cve_ageb,'-','') as cve_ageb,cve_loc,nom_loc,ambito,st_transform(geom,6362) as geom from historico.lpr_"+corte1+"  where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_loc";
                    break;
                case 9:
                    f1="select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_transform(geom,6362) as geom from historico.manzana_"+corte1+" where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza ";
                    break;
                case 13:
                    f1="select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_transform(geom,6362) as geom from historico.caserio_"+corte1+" where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913)  order by cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza ";
                    break;
                case 14:
                    f1="select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_transform(geom,6362) as geom from historico.manzana_"+corte1+" where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913) union select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_collect(st_triangle_32800(st_transform(geom,6362),5.3)) as geom from historico.caserio_"+corte1+" where geom && ST_MakeEnvelope("+c0+","+c1+","+c2+","+c3+", 900913) group by cve_ent,cve_mun,cve_loc,cve_ageb,cve_mza order by cve_ent,cve_mun,cve_loc,cve_ageb,cve_mza";
                    break;
            }
        } else

            {  //forma=2
                switch (capa2)
                {
                    case 1:
                        f1="select cve_ent,nom_ent,st_transform(geom,6362) as geom  from historico.entidad_"+corte1+" where cve_ent ilike '"+filtro1+"%' order by cve_ent";
                        break;
                    case 2:
                        f1="select cve_ent,cve_mun,nom_mun,st_transform(geom,6362) as geom  from historico.municipio_"+corte1+"  where  cve_ent||cve_mun  ilike '"+filtro1+"%' order by  cve_ent||cve_mun";
                        break;
                    case 3:
                        f1="select cve_ent,cve_mun,replace(cve_ageb,'-','') as cve_ageb,st_transform(geom,6362) as geom  from historico.ageb_"+corte1+"  where   cve_ent||cve_mun||cve_ageb  ilike '"+filtro1+"%'  order by cve_ent||cve_mun||cve_ageb";

                        break;
                    case 4:
                        f1="select cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,st_transform(geom,6362) as geom  from historico.agebu_"+corte1+"  where   cve_ent||cve_mun||cve_loc||cve_ageb  ilike '"+filtro1+"%'  order by cve_ent||cve_mun||cve_loc||cve_ageb";
                        break;
                    case 5:
                        f1="select cve_ent,cve_mun,cve_loc,nom_loc,ambito,st_transform(geom,6362) as geom  from historico.l_"+corte1+" where substring(ambito,1,1)='U'  and cve_ent||cve_mun||cve_loc ilike '"+filtro1+"%'  order by cve_ent||cve_mun||cve_loc";
                        break;
                    case 6:
                        f1="select cve_ent,cve_mun,cve_loc,nom_loc,ambito,st_transform(geom,6362) as geom  from historico.l_"+corte1+" where substring(ambito,1,1)='R'  and cve_ent||cve_mun||cve_loc ilike '"+filtro1+"%'  order by cve_ent||cve_mun||cve_loc";
                        break;
                    case 61:
                        f1="select cvegeo,st_transform(geom,6362) as geom  from historico.pe_"+corte1+" where cvegeo ilike '"+filtro1+"%'  order by cvegeo";
                        break;
                    case 7:
                        f1="select cve_ent,cve_mun,replace(cve_ageb,'-','') as cve_ageb,cve_loc,nom_loc,ambito,st_transform(geom,6362) as geom  from historico.lpr_"+corte1+" where cve_ent||cve_mun||cve_loc ilike '"+filtro1+"%'  order by cve_ent||cve_mun||cve_loc";
                        break;
                    case 9:
                        f1="select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_transform(geom,6362) as geom  from historico.manzana_"+corte1+" where cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza ilike '"+filtro1+"%' order by cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza ";
                        break;
                    case 13:
                        f1="select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_transform(geom,6362) as geom  from historico.caserio_"+corte1+" where cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza ilike '"+filtro1+"%' order by cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza ";
                        break;
                    case 14:

                        f1="select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_transform(geom,6362) as geom  from historico.manzana_"+corte1+" where cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza ilike '"+filtro1+"%' union select cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza as cvegeo,cve_ent,cve_mun,cve_loc,replace(cve_ageb,'-','') as cve_ageb,cve_mza,ambito,st_collect(st_triangle_900913(st_transform(geom,6362),5.3)) as geom from historico.caserio_"+corte1+" where cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza ilike '"+filtro1+"%' group by cve_ent,cve_mun,cve_loc,cve_ageb,cve_mza order by cve_ent,cve_mun,cve_loc,cve_ageb,cve_mza";
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
        if (file.exists())
        {
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
        out.println ("<center><br><br><A class='liga2' HREF='"+request.getRequestURL()+"?corte="+corte1+"'>Descargar otro SHP...</a></center>");


    } else {
%>
    <form action="mapa.jsp" method="post" name="enviar">
        <table class="table table-bordered" style="width:90%; margin-top: 10px; margin-left: 10px;">
            <tr class="n" bgcolor="#F5F5F5" align="center">
                <th colspan="2">Descargar información en SHP - CORTE: 2022</th>
                <button type="button" class="btn-close" style="font-size:13px; float:right; margin-right: 20px; margin-top:5px;" onclick="getElementById('download_div').style.display = 'none'; getElementById('btnMostrarDownload').style.display = 'block';"></button>
            </tr>
            <tr class="n" align="center">
                <td class="n" align="center">
                    <label style="margin-top:8px;">Capa:</label>
                </td>
                <td align="left">
                    <select class="form-select" aria-label="Default select example" name="capa">
                        <option selected value="1">Entidad</option>
                        <option value="2">Municipio</option>
                        <option value="3">Ageb Rural</option>
                        <option value="5">Localidad urbana</option>
                        <option value="4">Ageb Urbana</option>
                        <option value="6">Loc Rural Amanzanada</option>
                        <option value="61">Poligono Externo</option>
                        <option value="7">Loc Rural (puntos)</option>
                        <option value="9">Manzanas</option>
                        <option value="13">Caserio</option>
                    </select>
                </td>
            </tr>
            <tr class="c" align="center">
                <td class="n" align="center">
                    <label style="margin-top:8px;">Forma:</label>
                </td>
                <td align="left" class="c">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" 
                                name="forma" value="1" checked>
                        <label class="form-check-label">Por extensión de mapa</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" 
                            name="forma" value="2">
                        <label class="form-check-label">
                            Por filtro de clave
                        </label>
                    </div>
                </td>
            </tr>
            <tr class="c" align="center">
                <td class="n" align="center">
                    <label style="margin-top:8px;">Filtro:</label>
                </td>
                <td align="left" class="c">
                    <input class="boton form-control" type="text" name="filtro">
                </td>
            </tr>
            <input type="hidden" name="c0">
            <input type="hidden" name="c1">
            <input type="hidden" name="c2">
            <input type="hidden" name="c3">
            <input type="hidden" name="ban">
            <input type="hidden" name="as">
            <input type="hidden" name="vial">
            <tr> <td colspan="2"></td> </tr>
            <tr>
                <td nowrap colspan="2" align="center">
                    <input type="submit" class="btn btn-outline-secondary" name="descargar" value="Descargar SHP">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <label class="f" style="font-size:14px; color:red;">* Se limita la descarga a 500,000 rasgos</label>
                </td>
            </tr>
        </table>
    </form>
<%
    }
%>
</div>

<div id="busquedadiv">
     <label style="margin-left: 10px; margin-top:5px; font-size: 13px;">RESULTADOS - CORTE   <b><% String ct = request.getParameter("corte"); out.println(ct); %></b></label>
        <button type="button" class="btn-close" style="font-size:13px; float:right; margin-right: 10px; margin-top:5px;" onclick="getElementById('busquedadiv').style.display = 'none'; getElementById('btnMostrar').style.display = 'block';"></button>

        <div style="width:95%; margin: 0 auto; margin-top:2px;">
            <%
                try
                {
                    String c = request.getParameter("capa");
                    String t = request.getParameter("tipo");
                    String buscar = request.getParameter("buscar");
                    String consulta = "";
                    String salida = "";
                    String limit = " limit 100";
                    String st = "";
                    int ban=0, n=0;

                    String co = request.getParameter("corte");

                    int capa = Integer.parseInt(c);
                    int tipo = Integer.parseInt(t);
                    int corte = Integer.parseInt(co);

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
                    switch(capa)
                    {
                        case 3: // municipios
                            if (tipo==0)
                            {
                                consulta="SELECT cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,3857))::text else 'x' end as salida FROM historico.municipio_"+corte+" t1 where "+where1+" cve_ent||cve_mun like '" + buscar + "%'  order by cve_ent||cve_mun"+limit;
                            }
                            else
                            {
                                consulta="select cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,3857))::text else 'x' end as salida FROM historico.municipio_"+corte+" t1 where "+where1+" lower(nom_mun) || upper(nom_mun) || nom_mun LIKE '%" + buscar + "%' order by cve_ent||cve_mun"+limit;

                            }
                            break;

                        case 4://agebs
                            if (tipo==0)
                            {
                                consulta="SELECT clave,cve_ageb,case when geom is not null THEN box2d(ST_Transform(geom,3857))::text else 'x' end as salida,ambito FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_"+corte+" "+where2+"  union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_"+corte+" "+where2+") t1 where replace(clave,'-','') like '" + buscar + "%' order by ambito,clave"+limit;
                            }
                            else
                            {
                                consulta="SELECT clave,cve_ageb,case when geom is not null THEN box2d(ST_Transform(geom,3857))::text else 'x' end as salida,ambito FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_"+corte+" "+where2+"  union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_"+corte+" "+where2+") t1 where upper(a_sinacentos(replace(cve_ageb,'-',''))) ilike '%" + buscar + "%'  order by ambito,clave"+limit;
                            }
                            break;

                        case 7:     //rurales   --lo modifique para que buscque tanto urbanas como rurales y poligonos rurales
                            if (tipo==0){
                                    consulta = " (SELECT cve_ent||cve_mun||cve_loc as clave,nom_loc,"
                                    + "case "
                                    + " when geom is not null THEN box2d(ST_Transform(geom,3857))::text "
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
                                    + " when geom is not null THEN box2d(ST_Transform(geom,3857))::text "
                                    + " else 'x' "
                                    + "end "
                                    + "as salida,ambito,cve_ageb , 'PUNTO' as geo "
                                    + "FROM historico.lpr_"+corte+" t1 where "+where1+" upper(a_sinacentos(nom_loc)) ilike '%" + buscar + "%' "
                                     + "union "
                                    + "SELECT cve_ent||cve_mun||cve_loc as clave,nom_loc,case when geom is not null THEN box2d(ST_Transform(geom,3857))::text else 'x' end as salida,ambito,'0000' as cve_ageb, 'POLIGONO' as geo "
                                    + "FROM historico.l_"+corte+" t1 where ambito='U' and "+where1+" upper(a_sinacentos(nom_loc)) ilike '%" + buscar + "%' ) order by clave "+limit;
                            }
                        break;

                        case 11:   //manzanas
                            consulta="select * from ( SELECT cve_ent||' '||cve_mun||' '||cve_loc||' '||cve_ageb as cvegeo,cve_mza,box2d(ST_Transform(st_union(geom),3857))::text as salida,ambito as ambito from historico.caserio_"+corte+" where "+where1+"  cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza like '" + buscar + "%' group by cve_ent,cve_mun,cve_loc,cve_ageb,cve_mza,ambito union  SELECT cve_ent||' '||cve_mun||' '||cve_loc||' '||cve_ageb as cvegeo,cve_mza,case when geom is not null THEN box2d(ST_Transform(geom,3857))::text else 'x' end as salida,ambito from historico.manzana_"+corte+" where  "+where1+"  cve_ent||cve_mun||cve_loc||replace(cve_ageb,'-','')||cve_mza like '" + buscar + "%' ) tt   order by cvegeo,cve_mza "+limit;
                        break;
                    }

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

%>  
                        <br>
                        <div style="margin-left:25px;">
                            <form action="" method="GET">
                                <label style="width: 30%;">Filtrar por estado</label><br>
                                <select class="form-select" name="filent" onchange="this.form.submit()" aria-label="Default select example" style="width: 50%; float: right;  margin-top: -30px; margin-right: 90px;">
                                    <option value="00" selected>TODAS</option>
                                    <option value="01">01</option>
                                    <option value="02">02</option>
                                    <option value="03">03</option>
                                    <option value="04">04</option>
                                    <option value="05">05</option>
                                    <option value="06">06</option>
                                    <option value="07">07</option>
                                    <option value="08">08</option>
                                    <option value="09">09</option>
                                    <option value="10">10</option>
                                    <option value="11">11</option>
                                    <option value="12">12</option>
                                    <option value="13">13</option>
                                    <option value="14">14</option>
                                    <option value="15">15</option>
                                    <option value="16">16</option>
                                    <option value="17">17</option>
                                    <option value="18">18</option>
                                    <option value="19">19</option>
                                    <option value="20">20</option>
                                    <option value="21">21</option>
                                    <option value="22">22</option>
                                    <option value="23">23</option>
                                    <option value="24">24</option>
                                    <option value="25">25</option>
                                    <option value="26">26</option>
                                    <option value="27">27</option>
                                    <option value="28">28</option>
                                    <option value="29">29</option>
                                    <option value="30">30</option>
                                    <option value="31">31</option>
                                    <option value="32">32</option>
                                </select>
                                <% out.println ("<input type='hidden' name='buscar' value='"+buscar+"'><input type='hidden' name='capa' value='"+capa+"'><input type='hidden' name='tipo' value='"+tipo+"'><input type='hidden' name='corte' value='"+corte+"'>"); %>
                            </form>
                            <br>
                        </div>
<%
                        switch(capa)
                        {
                            case 3: // municipio
%>  
                                <table class="table table-bordered" style="width:90%;">
                                    <thead>
                                        <tr>
                                            <th scope="col">Clave</th>
                                            <th scope="col">Nombre</th>
                                            <th scope="col">Referencia</th>
                                        </tr>
                                    </thead>
<%
                                break;
                            case 4:// agebs
%>
                                <table class="table table-bordered" style="width:90%;">
                                    <thead>
                                        <tr>
                                            <th scope="col">Clave</th>
                                            <th scope="col">Nombre</th>
                                            <th scope="col">Geom</th>
                                            <th scope="col">Referencia</th>
                                        </tr>
                                    </thead>
<%
                                break;

                            case 7://  rurales
%>
                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th scope="col">Clave</th>
                                            <th scope="col">Nombre</th>
                                            <th scope="col">Ambito</th>
                                            <th scope="col">Ageb</th>
                                            <th scope="col">Geometria</th>
                                            <th scope="col">Referencia</th>
                                        </tr>
                                    </thead>
<%
                                break;

                            case 11://manzanas
%>
                                <table class="table table-bordered" style="width:90%;">
                                    <thead>
                                        <tr>
                                            <th scope="col">Clave</th>
                                            <th scope="col">Mza</th>
                                            <th scope="col">Ambito</th>
                                            <th scope="col">Referencia</th>
                                        </tr>
                                    </thead>
<%
                                break;
                        }

                        while(rs.next())
                        {
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

                            if(capa==3){ // municipios
%>
                                <center>
                                        <tr>
                                            <td style="width:40%;"><% out.println(s1); %></td>
                                            <td style="width: 40%;"><% out.println(s2); %></td>
                                            
                                    
                                </center>
<%
                            }
                            //out.println( "<tr class=c><td align=center>&nbsp;&nbsp;"+s1+"&nbsp;&nbsp;<td>&nbsp;&nbsp;"+s2+"&nbsp;&nbsp;");
                            String s6="";

                            if (capa==7){// rurales
                                String s4=rs.getObject(4).toString();
                                String s5=rs.getObject(5).toString();
                                String s7=rs.getObject(6).toString();

                                %>                              
                                
                                        <tr>
                                            <td style="width:40%;"><% out.println(s1); %></td>
                                            <td style="width: 40%;"><% out.println(s2); %></td>
                                            <td style="width: 40%;"><% out.println(s4); %></td>
                                            <td style="width: 40%;"><% out.println(s5); %></td>
                                            <td style="width: 40%;"><% out.println(s7); %></td>
                                            <!--<td><button type="button" class="btn btn-outline-secondary" id="localidad">Ver</button></td>-->
                                    
                        
                                
<%
                                //out.println( "<td align=center>&nbsp;&nbsp;"+s4+"&nbsp;&nbsp;<td align=center rowspan>"+s5+"&nbsp;&nbsp;<td rowspan>&nbsp;"+s7+"&nbsp;&nbsp;");
                            }

                            if (capa==4 || capa==11) // agebs y manzanas
                            {
                                String s4=rs.getObject(4).toString();
                                //out.println( "<td align=center>&nbsp;&nbsp;"+s4+"&nbsp;&nbsp;");
%>                              
                                <center>
                                        <tr>
                                            <td style="width:40%;"><% out.println(s1); %></td>
                                            <td style="width: 40%;"><% out.println(s2); %></td>
                                            <td style="width: 40%;"><% out.println(s4); %></td>
                                                                
                                </center>
<%
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
                                //out.println("Capa "+capa+" Coor1 "+salsal[0]+", Coor2 "+salsal[1]+", Coor3 "+salsal[2]+", Coor4 "+salsal[3]+" otros "+s1+"\n");
                               
                                out.println("<td align=center><input type=button onclick='buscazoomlocal(\""+st+"\","+capa+","+salsal[0]+","+salsal[1]+","+salsal[2]+","+salsal[3]+",\""+s1+"\",\""+s6+"\");' value=' Ver ' class='boton'>");

                               }else if (capa==3){
                                out.println("<td><input type=button onclick='buscazoomlocal(\""+st+"\","+capa+","+salsal[0]+","+salsal[1]+","+salsal[2]+","+salsal[3]+",\""+s1+"\",\"0\");' value=' Ver ' class='boton'>");

                               } else if(capa==4 || capa==11){
                                out.println("<td align=center><input type=button onclick='buscazoomlocal(\""+st+"\","+capa+","+salsal[0]+","+salsal[1]+","+salsal[2]+","+salsal[3]+",\""+s1+"\",\""+s6+"\");' value=' Ver ' class='boton'>");
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
%>
                        </table>
                        <label style="margin-left:25px;">Total de registros <b><% out.println(n); %></b></label>
<%
                        //out.println( "</table><br><font class=n>Total de Registros: " + n +"</font>");
                        if (n>=100 && capa!=10){
                            out.println( "<br><font class=r>* La consulta tiene un limite de 100 registros. </font>");
                        }
                        out.println( "<br><br>");

                    }
                    catch (Exception ex){
                        out.println("<script>");
                        out.println("  alert(\'Se genero la expresion de SQL: "+ex.getMessage()+" !\');");
                        out.println("</script>");
                    }
                } catch(NumberFormatException ex){
                    ex.printStackTrace();
                }

                
        
            %>
        </div>
</div>

<div id="busquedaCorte">
    <label style="margin-left: 25px; margin-top:5px; font-size: 13px;">
        RESULTADOS 
        <b>
<% 
    try 
    {
                String capac = request.getParameter("capa"); 
                int capav = Integer.parseInt(capac);
                if(capav==3){
                    out.println("MUNICIPIOS");
                } else if(capav==4){
                    out.println("AGEBS");
                } else if(capav==7){
                    out.println("LOCALIDADES");
                } else if(capav==11){
                    out.println("MANZANAS");
                }
%>
        </b>
    </label>
    <button type="button" class="btn-close" style="font-size:13px; float:right; margin-right: 10px; margin-top:5px;" onclick="getElementById('busquedaCorte').style.display = 'none'; getElementById('btnMostrarCorte').style.display = 'block';"></button>
        <%
            String c = request.getParameter("capa");
            String t = request.getParameter("tipo");
            String buscar = request.getParameter("buscar");
            String consulta = "";
            String salida = "";
            String limit = " limit 100";
            String st = "";
            int ban=0, n=0;

            String co = request.getParameter("corte");

            int capa = Integer.parseInt(c);
            int tipo = Integer.parseInt(t);
            int corte = Integer.parseInt(co);

            buscar = buscar.replace("-","");
            buscar = buscar.replace(";","");

            switch(capa){
                case 3://municipios
                consulta = "(SELECT '1990' as corte,cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.municipio_1990 t1 where  cve_ent||cve_mun = substring('" + buscar + "',0,6) order by corte limit 1) "
                    + " UNION "
                    + "(SELECT '1995' as corte,cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.municipio_1995 t1 where  cve_ent||cve_mun =  substring('" + buscar + "',0,6) order by corte limit 1)"
                    + " UNION "
                    + "(SELECT '2000' as corte,cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.municipio_2000 t1 where  cve_ent||cve_mun =  substring('" + buscar + "',0,6) order by corte limit 1)"
                    + " UNION "
                    + "(SELECT '2005' as corte,cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.municipio_2005 t1 where  cve_ent||cve_mun =  substring('" + buscar + "',0,6) order by corte limit 1)"
                    + " UNION "
                    + "(SELECT '2010' as corte,cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.municipio_2010 t1 where  cve_ent||cve_mun =  substring('" + buscar + "',0,6) order by corte limit 1)"
                    + " UNION "
                    + "(SELECT '2015' as corte,cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.municipio_2015 t1 where  cve_ent||cve_mun =  substring('" + buscar + "',0,6) order by corte limit 1)"
                    + " UNION "
                    + "(SELECT '2018' as corte,cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.municipio_2018 t1 where  cve_ent||cve_mun =  substring('" + buscar + "',0,6) order by corte limit 1)"
                    + " UNION "
                    + "(SELECT '2019' as corte,cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.municipio_2019 t1 where  cve_ent||cve_mun =  substring('" + buscar + "',0,6) order by corte limit 1)"
                    + " UNION "
                    + "(SELECT '2020' as corte,cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.municipio_2020 t1 where  cve_ent||cve_mun =  substring('" + buscar + "',0,6) order by corte limit 1)"
                    + " UNION "
                    + "(SELECT '2021' as corte,cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.municipio_2021 t1 where  cve_ent||cve_mun =  substring('" + buscar + "',0,6) order by corte limit 1)"
                    + " UNION "
                    + "(SELECT '2022' as corte,cve_ent||cve_mun as clave,nom_mun,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.municipio_2022 t1 where  cve_ent||cve_mun =  substring('" + buscar + "',0,6) order by corte limit 1)"
                    + "ORDER BY corte asc";
        //out.println(consulta);
                break;
 
                case 4://agebs
                    consulta = "(SELECT '1990' as corte,clave,cve_ageb,ambito ,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida"
                        + " FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_1990  "
                        + " union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_1990 ) t1 where "
                        + " replace(clave,'-','') like substring('" + buscar + "',1,9) order by ambito,clave limit 1)"
                        + " union"
                        + " (SELECT '1995' as corte,clave,cve_ageb,ambito ,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida"
                        + " FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_1995  "
                        + " union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_1995 ) t1 where "
                        + " replace(clave,'-','') like substring('" + buscar + "',1,9) order by ambito,clave limit 1)"
                        + " union"
                        + " (SELECT '2000' as corte,clave,cve_ageb,ambito ,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida"
                        + " FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_2000  "
                        + " union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_2000 ) t1 where "
                        + " replace(clave,'-','') like substring('" + buscar + "',1,9) order by ambito,clave limit 1)"
                        + " union"
                        + " (SELECT '2005' as corte,clave,cve_ageb,ambito ,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida"
                        + " FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_2005  "
                        + " union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_2005 ) t1 where "
                        + " replace(clave,'-','') like substring('" + buscar + "',1,9) order by ambito,clave limit 1)"
                        + " union"
                        + " (SELECT '2010' as corte,clave,cve_ageb,ambito ,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida"
                        + " FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_2010  "
                        + " union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_2010 ) t1 where "
                        + " replace(clave,'-','') like substring('" + buscar + "',1,9) order by ambito,clave limit 1)"
                        + " union"
                        + " (SELECT '2015' as corte,clave,cve_ageb,ambito ,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida"
                        + " FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_2015  "
                        + " union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_2015 ) t1 where "
                        + " replace(clave,'-','') like substring('" + buscar + "',1,9) order by ambito,clave limit 1)"
                        + " union"
                        + " (SELECT '2018' as corte,clave,cve_ageb,ambito ,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida"
                        + " FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_2018  "
                        + " union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_2018 ) t1 where "
                        + " replace(clave,'-','') like substring('" + buscar + "',1,9) order by ambito,clave limit 1)"
                        + " union"
                        + " (SELECT '2019' as corte,clave,cve_ageb,ambito ,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida"
                        + " FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_2019  "
                        + " union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_2019 ) t1 where "
                        + " replace(clave,'-','') like substring('" + buscar + "',1,9) order by ambito,clave limit 1)"
                        + " union"
                        + " (SELECT '2020' as corte,clave,cve_ageb,ambito ,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida"
                        + " FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_2020  "
                        + " union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_2020 ) t1 where "
                        + " replace(clave,'-','') like substring('" + buscar + "',1,9) order by ambito,clave limit 1)"
                        + " union"
                        + " (SELECT '2021' as corte,clave,cve_ageb,ambito ,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida"
                        + " FROM (select  cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'R' as ambito,geom from historico.ageb_2021  "
                        + " union select cve_ent||cve_mun||cve_ageb as clave,cve_ageb,'U' ,geom from historico.agebu_2021 ) t1 where "
                        + " replace(clave,'-','') like substring('" + buscar + "',1,9) order by ambito,clave limit 1) "
                        + " union"
                        + " (SELECT '2022' as corte,clave,substring(cve_ageb,1,3)||'-'||substring(cve_ageb,4,1),ambito ,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida"
                        + " FROM (select  cve_ent||cve_mun||substring(cve_ageb,1,3)||'-'||substring(cve_ageb,4,1) as clave,cve_ageb,'R' as ambito,geom from historico.ageb_2022  "
                        + " union select cve_ent||cve_mun||substring(cve_ageb,1,3)||'-'||substring(cve_ageb,4,1) as clave,cve_ageb,'U' ,geom from historico.agebu_2022 ) t1 where "
                        + " replace(clave,'-','') like substring('" + buscar + "',1,9) order by ambito,clave limit 1)"
                        + " ORDER BY corte asc";
                break;
 
                case 7://localidades
                    consulta = "(SELECT '1990' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,cve_ageb,'PUNTO' as geo,   case    when geom is not null THEN box2d(ST_Transform(geom,900913))::text "
                        + " else 'x'   end    as salida  FROM historico.lpr_1990 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) union "
                        + " SELECT '1990' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,'0000' as cve_ageb , 'POLIGONO' as geo, case when geom is not null THEN box2d(ST_Transform(geom,900913))::text "
                        + " else 'x' end as salida   FROM historico.l_1990 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) ) "
                        + " union "
                        + " (SELECT '1995' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,cve_ageb,'PUNTO' as geo,   case    when geom is not null THEN box2d(ST_Transform(geom,900913))::text "
                        + " else 'x'   end    as salida  FROM historico.lpr_1995 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) union "
                        + " SELECT '1995' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,'0000' as cve_ageb , 'POLIGONO' as geo, case when geom is not null THEN box2d(ST_Transform(geom,900913))::text "
                        + " else 'x' end as salida   FROM historico.l_1995 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) )"
                        + " union "
                        + " (SELECT '2000' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,cve_ageb,'PUNTO' as geo,   case    when geom is not null THEN box2d(ST_Transform(geom,900913))::text " 
                        + " else 'x'   end    as salida  FROM historico.lpr_2000 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) union  "
                        + " SELECT '2000' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,'0000' as cve_ageb , 'POLIGONO' as geo, case when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x' end as salida   FROM historico.l_2000 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) )  "
                        + " union "
                        + " (SELECT '2005' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,cve_ageb,'PUNTO' as geo,   case    when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x'   end    as salida  FROM historico.lpr_2005 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) union  "
                        + " SELECT '2005' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,'0000' as cve_ageb , 'POLIGONO' as geo, case when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x' end as salida   FROM historico.l_2005 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) )  "
                        + " union "
                        + " (SELECT '2015' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,cve_ageb,'PUNTO' as geo,   case    when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x'   end    as salida  FROM historico.lpr_2015 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) union  "
                        + " SELECT '2015' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,'0000' as cve_ageb , 'POLIGONO' as geo, case when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x' end as salida   FROM historico.l_2015 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) )  "
                        + " union "
                        + " (SELECT '2018' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,cve_ageb,'PUNTO' as geo,   case    when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x'   end    as salida  FROM historico.lpr_2018 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) union  "
                        + " SELECT '2018' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,'0000' as cve_ageb , 'POLIGONO' as geo, case when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x' end as salida   FROM historico.l_2018 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) )  "
                        + " union "
                        + " (SELECT '2019' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,cve_ageb,'PUNTO' as geo,   case    when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x'   end    as salida  FROM historico.lpr_2019 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) union  "
                        + " SELECT '2019' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,'0000' as cve_ageb , 'POLIGONO' as geo, case when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x' end as salida   FROM historico.l_2019 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) )    "
                        + " union "
                        + " (SELECT '2020' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,cve_ageb,'PUNTO' as geo,   case    when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x'   end    as salida  FROM historico.lpr_2020 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) union  "
                        + " SELECT '2020' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,'0000' as cve_ageb , 'POLIGONO' as geo, case when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x' end as salida   FROM historico.l_2020 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) )    "
                        + " union "
                        + " (SELECT '2021' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,cve_ageb,'PUNTO' as geo,   case    when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x'   end    as salida  FROM historico.lpr_2021 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) union  "
                        + " SELECT '2021' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,'0000' as cve_ageb , 'POLIGONO' as geo, case when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x' end as salida   FROM historico.l_2021 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) )    "
                        + " union "
                        + " (SELECT '2022' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,ambito,substring(cve_ageb,1,3)||'-'||substring(cve_ageb,4,1),'PUNTO' as geo,   case    when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x'   end    as salida  FROM historico.lpr_2022 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) union  "
                        + " SELECT '2022' as corte,cve_ent||cve_mun||cve_loc as clave,nom_loc,substring(ambito,1,1),'0000' as cve_ageb , 'POLIGONO' as geo, case when geom is not null THEN box2d(ST_Transform(geom,900913))::text  "
                        + " else 'x' end as salida   FROM historico.l_2022 t1 where  cve_ent||cve_mun||cve_loc like substring('" + buscar + "',1,9) )    "
                        + " ORDER BY corte asc,geo";
                break;
 
                case 11://manzanas  
                    int longitudNombre = buscar.length();
                    if(longitudNombre==16) 
                    {
                        if(buscar.substring(13,16).equals("800"))
                        {          
                            consulta =    " (SELECT '2000' as corte,cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.caserio_2000 t1 where  cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza =  '" + buscar + "' order by corte limit 1) "
                                + "  UNION  "
                                + " (SELECT '2005' as corte,cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.caserio_2005 t1 where  cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza =  '" + buscar + "' order by corte limit 1) "
                                + " UNION  "
                                + " (SELECT '2010' as corte,cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.caserio_2010 t1 where  cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza =  '" + buscar + "' order by corte limit 1) "
                                + " UNION  "
                                + " (SELECT '2015' as corte,cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.caserio_2015 t1 where  cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza =  '" + buscar + "' order by corte limit 1) "
                                + "  UNION  "
                                + " (SELECT '2018' as corte,cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.caserio_2018 t1 where  cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza =  '" + buscar + "' order by corte limit 1) "
                                + "  UNION  "
                                + " (SELECT '2019' as corte,cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.caserio_2019 t1 where  cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza =  '" + buscar + "' order by corte limit 1) "
                                + "  UNION  "
                                + " (SELECT '2020' as corte,cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.caserio_2020 t1 where  cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza =  '" + buscar + "' order by corte limit 1) "
                                + "  UNION  "
                                + " (SELECT '2021' as corte,cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.caserio_2021 t1 where  cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza =  '" + buscar + "' order by corte limit 1) "
                                + "  UNION " 
                                + " (SELECT '2022' as corte,cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.caserio_2022 t1 where  cve_ent||cve_mun||cve_loc||cve_ageb||cve_mza =  '" + buscar + "' order by corte limit 1) "
                                + " ORDER BY corte asc";            
                        } else{
                            consulta = "(SELECT '1990' as corte,cve_ent||cve_mun||cve_loc as clave,'000' as cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_1990 t1 where  cvegeo =  substring('" + buscar + "',0,10) order by corte limit 1)"
                                + "  UNION "
                                + " (SELECT '1995' as corte,cve_ent||cve_mun||cve_loc as clave,'000' as cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_1995 t1 where  cvegeo =  substring('" + buscar + "',0,10) order by corte limit 1)"
                                + " UNION "
                                + " (SELECT '2000' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2000 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                                + "  UNION "
                                + " (SELECT '2005' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2005 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                                + "  UNION "
                                + " (SELECT '2010' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2010 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                                + " UNION "
                                + " (SELECT '2015' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2015 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                                + "  UNION "
                                + " (SELECT '2018' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2018 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                                + "  UNION "
                                + " (SELECT '2019' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2019 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                                + "  UNION "
                                + " (SELECT '2020' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2020 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                                + "  UNION "
                                + " (SELECT '2021' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2021 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                                + "  UNION "
                                + " (SELECT '2022' as corte,cvegeo as clave,cve_mza,substring(ambito,1,1) as ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2022 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                                + " ORDER BY corte asc";
                        }
                    }else{
                        consulta = "(SELECT '1990' as corte,cve_ent||cve_mun||cve_loc as clave,'000' as cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_1990 t1 where  cvegeo =  substring('" + buscar + "',0,10) order by corte limit 1)"
                        + "  UNION "
                        + " (SELECT '1995' as corte,cve_ent||cve_mun||cve_loc as clave,'000' as cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_1995 t1 where  cvegeo =  substring('" + buscar + "',0,10) order by corte limit 1)"
                        + " UNION "
                        + " (SELECT '2000' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2000 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                        + "  UNION "
                        + " (SELECT '2005' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2005 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                        + "  UNION "
                        + " (SELECT '2010' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2010 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                        + " UNION "
                        + " (SELECT '2015' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2015 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                        + "  UNION "
                        + " (SELECT '2018' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2018 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                        + "  UNION "
                        + " (SELECT '2019' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2019 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                        + "  UNION "
                        + " (SELECT '2020' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2020 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                        + "  UNION "
                        + " (SELECT '2021' as corte,cvegeo as clave,cve_mza,ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2021 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                        + "  UNION "
                        + " (SELECT '2022' as corte,cvegeo as clave,cve_mza,substring(ambito,1,1) as ambito,case when geom is not null THEN box2d(ST_Transform(geom,900913))::text else 'x' end as salida FROM historico.manzana_2022 t1 where  cvegeo =  '" + buscar + "' order by corte limit 1)"
                        + " ORDER BY corte asc";            
                    }
                break;
            }

        if (tipo==0) {
            Statement str = null;
            ResultSet rs = null;
            try {
                Connection conexion = null;
                Class.forName("org.postgresql.Driver");
                conexion = DriverManager.getConnection(
                                                     "jdbc:postgresql://10.153.3.25:5434/actcargeo10",
                                                     "arcgis",
                                                     "arcgis"
                                                    );

                str = conexion.createStatement(rs.TYPE_SCROLL_SENSITIVE, rs.CONCUR_UPDATABLE);
                rs = str.executeQuery( consulta );

            } catch (SQLException ex){
                out.println("<script>");
                out.println("  alert(\'Se genero la expresion de SQL: "+ex.getMessage()+" !\');");
                out.println("</script>");
            }
            
            switch(capa)
            {
                case 3:      //municipios
%>  
                    <table class="table table-bordered" style="width:90%; margin:0 auto;">
                        <thead>
                            <tr>
                                <th scope="col">Corte</th>
                                <th scope="col">Clave</th>
                                <th scope="col">Nombre</th>
                                <th scope="col">Referencia</th>
                            </tr>
<%  
                            while(rs.next())
                            {
                                String s1=rs.getObject(1).toString();
                                String s2=rs.getObject(2).toString();
                                String s3=rs.getObject(3).toString();
                                String s4=rs.getObject(4).toString();

                                out.println( "<tr class=c><td align=center>&nbsp;&nbsp;"+s1+"&nbsp;&nbsp;<td align=center>&nbsp;&nbsp;"+s2+"&nbsp;&nbsp;<td align=center>&nbsp;&nbsp;"+s3+"&nbsp;&nbsp;");
                                double[] salsal = {0,0,0,0};
                                salida = s4.replace("BOX(","");
                                salida = salida.replace(" ",",");
                                salida = salida.replace(")","");
                                String[] salvec = salida.split(",");
        
                                salsal[0]=Float.parseFloat(salvec[0]);
                                salsal[1]=Float.parseFloat(salvec[1]);
                                salsal[2]=Float.parseFloat(salvec[2]);
                                salsal[3]=Float.parseFloat(salvec[3]);
              
                                if (salsal[0]==salsal[2])
                                {
                                    salsal[0]=salsal[0]-2000;   //CCL , mercator
                                    salsal[1]=salsal[1]-2000;
                                salsal[2]=salsal[2]+2000;
                                salsal[3]=salsal[3]+2000;
                            
                                }     
        
                                out.println("<td align=center><input type=button onclick='buscazoomlocal(\""+st+"\",7,"+salsal[0]+","+salsal[1]+","+salsal[2]+","+salsal[3]+",\""+s2+"\",\""+00+"\");' value=' Ver ' class='boton'>");
                            }
                break;

            case 4:
                out.println( "<table border=1><tr class=n bgcolor=#BBBBBB><th>&nbsp;&nbsp;Corte&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;Clave&nbsp;&nbsp;&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ageb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ambito&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Referencia&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    
        while(rs.next()){
            String s1=rs.getObject(1).toString();
            String s2=rs.getObject(2).toString();               
            String s3=rs.getObject(3).toString();       
            String s4=rs.getObject(4).toString();
            String s5=rs.getObject(5).toString();
            

            
            out.println( "<tr class=c><td align=center>&nbsp;&nbsp;"+s1+"&nbsp;&nbsp;<td align=center>&nbsp;&nbsp;"+s2+"&nbsp;&nbsp;<td align=center>&nbsp;&nbsp;"+s3+"&nbsp;&nbsp;"+"&nbsp;&nbsp;<td align=center>&nbsp;&nbsp;"+s4+"&nbsp;&nbsp;");
        
            double[] salsal = {0,0,0,0};
       salida = s5.replace("BOX(","");
        salida = salida.replace(" ",",");
        salida = salida.replace(")","");
        String[] salvec = salida.split(",");
        
        salsal[0]=Float.parseFloat(salvec[0]);
              salsal[1]=Float.parseFloat(salvec[1]);
              salsal[2]=Float.parseFloat(salvec[2]);
              salsal[3]=Float.parseFloat(salvec[3]);
              
        if (salsal[0]==salsal[2]){
                salsal[0]=salsal[0]-2000;   //CCL , mercator
                salsal[1]=salsal[1]-2000;
                salsal[2]=salsal[2]+2000;
                salsal[3]=salsal[3]+2000;
                
            }     
        
        out.println("<td align=center><input type=button onclick='buscazoomlocal(\""+st+"\",7,"+salsal[0]+","+salsal[1]+","+salsal[2]+","+salsal[3]+",\""+s2+"\",\""+00+"\");' value=' Ver ' class='boton'>");
        
        }
            break;

        case 7:
            out.println( "<table border=1><tr class=n bgcolor=#BBBBBB><th>&nbsp;&nbsp;Corte&nbsp;&nbsp;<th>&nbsp;&nbsp;Clave&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Nombre&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<th>&nbsp;&nbsp;Ambito&nbsp;&nbsp;<th>&nbsp;&nbsp;Ageb&nbsp;&nbsp;<th>&nbsp;&nbsp;Geometria&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Referencia&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    
        while(rs.next()){
            String s1=rs.getObject(1).toString();
            String s2=rs.getObject(2).toString();               
            String s3=rs.getObject(3).toString();       
            String s4=rs.getObject(4).toString();
            String s5=rs.getObject(5).toString();
            String s6=rs.getObject(6).toString();
            String s7=rs.getObject(7).toString();
            

            
            out.println( "<tr class=c><td align=center>&nbsp;&nbsp;"+s1+"&nbsp;&nbsp;<td align=center>&nbsp;&nbsp;"+s2+"&nbsp;&nbsp;<td align=center>&nbsp;&nbsp;"+s3+"&nbsp;&nbsp;"+"&nbsp;&nbsp;<td align=center>&nbsp;&nbsp;"+s4+"&nbsp;&nbsp;<td align=center>&nbsp;&nbsp;"+s5+"&nbsp;&nbsp;<td align=center>&nbsp;&nbsp;"+s6+"&nbsp;&nbsp;");
        
            double[] salsal = {0,0,0,0};
       salida = s7.replace("BOX(","");
        salida = salida.replace(" ",",");
        salida = salida.replace(")","");
        String[] salvec = salida.split(",");
        
        salsal[0]=Float.parseFloat(salvec[0]);
              salsal[1]=Float.parseFloat(salvec[1]);
              salsal[2]=Float.parseFloat(salvec[2]);
              salsal[3]=Float.parseFloat(salvec[3]);
              
        if (salsal[0]==salsal[2]){
                salsal[0]=salsal[0]-2000;   //CCL , mercator
                salsal[1]=salsal[1]-2000;
                salsal[2]=salsal[2]+2000;
                salsal[3]=salsal[3]+2000;
                
            }     
        
        out.println("<td align=center><input type=button onclick='buscazoomlocal(\""+st+"\",7,"+salsal[0]+","+salsal[1]+","+salsal[2]+","+salsal[3]+",\""+s2+"\",\""+00+"\");' value=' Ver ' class='boton'>");
        
    
        }
        break;

    case 11:
         out.println( "<table border=1><tr class=n bgcolor=#BBBBBB><th>&nbsp;&nbsp;Corte&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;Clave&nbsp;&nbsp;&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Manzana&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ambito&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Referencia&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    
        while(rs.next()){
            String s1=rs.getObject(1).toString();
            String s2=rs.getObject(2).toString();               
            String s3=rs.getObject(3).toString();       
            String s4=rs.getObject(4).toString();
            String s5=rs.getObject(5).toString();
            

            
            out.println( "<tr class=c><td align=center>&nbsp;&nbsp;"+s1+"&nbsp;&nbsp;<td align=center>&nbsp;&nbsp;"+s2+"&nbsp;&nbsp;<td align=center>&nbsp;&nbsp;"+s3+"&nbsp;&nbsp;"+"&nbsp;&nbsp;<td align=center>&nbsp;&nbsp;"+s4+"&nbsp;&nbsp;");
        
            double[] salsal = {0,0,0,0};
            salida = s5.replace("BOX(","");
            salida = salida.replace(" ",",");
            salida = salida.replace(")","");
            String[] salvec = salida.split(",");
        
            salsal[0]=Float.parseFloat(salvec[0]);
            salsal[1]=Float.parseFloat(salvec[1]);
            salsal[2]=Float.parseFloat(salvec[2]);
            salsal[3]=Float.parseFloat(salvec[3]);
              
            if (salsal[0]==salsal[2]){
              salsal[0]=salsal[0]-2000;   //CCL , mercator
              salsal[1]=salsal[1]-2000;
              salsal[2]=salsal[2]+2000;
              salsal[3]=salsal[3]+2000;  
            }     
        
          out.println("<td align=center><input type=button onclick='buscazoomlocal(\""+st+"\",7,"+salsal[0]+","+salsal[1]+","+salsal[2]+","+salsal[3]+",\""+s2+"\",\""+00+"\");' value=' Ver ' class='boton'>");
        }
    break;
    }
  } else {
    out.println( "<BR><form ><center class='t'>POR EL MOMENTO SOLO ESTA HABILITADA LA BUSQUEDA POR CLAVE<br><br>");
  }
}  catch(NumberFormatException ex){
    ex.printStackTrace();
}
%>
    </thead>
  </table><br>
</div>

<button style="margin: 0 auto; border-radius: 10px; width: 150px; height:50px; position:absolute; left:1640px; right:0px; bottom:50px; z-index:0; background-color:white;  overflow:auto; display:none; border:1px solid #E0E0E0;" id="btnMostrar" onclick="getElementById('busquedadiv').style.display = 'block'; getElementById('btnMostrar').style.display = 'none'; ">Mostrar</button>

<button style="margin: 0 auto; border-radius: 10px; width: 150px; height:50px; position:absolute; left:1640px; right:0px; bottom:50px; z-index:0; background-color:white;  overflow:auto; display:none; border:1px solid #E0E0E0;" id="btnMostrarDownload" onclick="getElementById('download_div').style.display = 'block'; getElementById('btnMostrarDownload').style.display = 'none'; ">Mostrar Descarga</button>

<button style="margin: 0 auto; border-radius: 10px; width: 150px; height:50px; position:absolute; left:1640px; right:0px; bottom:50px; z-index:0; background-color:white;  overflow:auto; display:none; border:1px solid #E0E0E0;" id="btnMostrarCorte" onclick="getElementById('busquedaCorte').style.display = 'block'; getElementById('btnMostrarCorte').style.display = 'none'; ">Mostrar Corte</button>

<%
            } while(resultSet.next());
        }
      } catch (Exception e) {
        e.printStackTrace();
        out.println("error en la bd");
        return; // Importante: detener la ejecución del código
      } finally {
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

  <script type="text/javascript">
    function buscazoomlocal(st,capa,sal1,sal2,sal3,sal4,clave,ageb){
      //alert(capa);
      mun(capa,sal1,sal2,sal3,sal4);
    }


</script>

  </script>  

  <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.4.4/proj4.js"></script>
  <script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.5.0/build/ol.js"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
  <script type="text/javascript" src="resources/ol/ol.js"></script>
  <script src="main.js"></script>
  <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>

</body>
</html>