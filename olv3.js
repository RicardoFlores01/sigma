/* MOSTRAR VENTANA DE BUSQUEDA */ 
  const urlActual = window.location.href;

  const busquedaNormal = "search";
  const busquedaNormal_filent = "filent";

  const buscarCortev = "Corte";
  const punto = "longitud";

  if (urlActual.indexOf(busquedaNormal) !== -1 || urlActual.indexOf(busquedaNormal_filent) !== -1) {
    const div = document.getElementById("busquedadiv");
    div.style.display = "block";
  }

  if(buscarCortev !== undefined && urlActual.indexOf(buscarCortev) !== -1){
    const buscarCorte = document.getElementById("busquedaCorte");
    buscarCorte.style.display = 'block';
  }

  // Contenido de botones 
  function mostrarContenido(buttonValue) {
    if (buttonValue === "search") {
      document.getElementById("busquedadiv").style.display = "block";
      document.getElementById("busquedaCorte").style.display = "none";
      console.log("buscar");
    } else if (buttonValue === "buscarCorte") {
      document.getElementById("busquedadiv").style.display = "none";
      document.getElementById("busquedaCorte").style.display = "block";
      console.log("corte");
    }
  }

/* MAPA */ 
  var coord_x;
  var coord_y;
  //var extent = [-13459673.0276619,1232095.46159631,-9281930.46183394,4109451.87806631];

  var view = new ol.View({
    projection: 'EPSG:3857',
    center: ol.proj.fromLonLat([-102.552784,23.634501]),
    //center: ol.proj.transform([-102.552784,23.634501], 'EPSG:4326', 'EPSG:3857'),
    zoom: 5,
    minZoom: 5,
    maxZoom: 21,
  });


  var map = new ol.Map({
    target: 'map',
    controls: 
    [
      new ol.control.Zoom(),
      new ol.control.Rotate(),
      new ol.control.Attribution(),
      new ol.control.ZoomSlider(),
      new ol.control.MousePosition({
        coordinateFormat: ol.coordinate.createStringXY(5),
        projection: 'EPSG:4326',
        className: 'coordinates',
        target: document.getElementById('coordinates'),
      }),
    ],
    view: view
  });


  var scaleLineMetric = new ol.control.ScaleLine({
    units: ['metric'],
    //className: 'scale-line-1',
    target: document.getElementById("scaleline-metric"),
    //projection: 'EPSG:3857'
  });

  var scaleLineImperial = new ol.control.ScaleLine({
    units: ['imperial'], //className: 'scale-line-2',
    target: document.getElementById("scaleline-imperial"), //projection: 'EPSG:3857'
  });

  map.addControl(scaleLineMetric); map.addControl(scaleLineImperial);

  map.once('postrender', function() {
    //var scaleLineMetricElement = scaleLineMetric.getElement();
    var scaleLineMetricElement = scaleLineMetric.element;
    scaleLineMetricElement.style.bottom = '30px';
    scaleLineMetricElement.style.left = '10px';
  });

/* CODIGO DE CUANDO SE INICIA LA PLATAFORMA, ZOOM CON SHIFT Y MOUSE, CAMBIAR PUNTERO CUANDO SE MUEVE EL MAPA  */
  // es la de hacer zoom pulsando la tecla shift con el click izquierdo 
    var mapContainer = map.getTargetElement();
    var isShiftKeyDown = false;

    // Event listener para detectar cuando se presiona la tecla Shift
    window.addEventListener('keydown', function(event) {
      if (event.shiftKey) {
        isShiftKeyDown = true;
      }
    });

    // Event listener para detectar cuando se suelta la tecla Shift
    window.addEventListener('keyup', function(event) {
      if (!event.shiftKey) {
        isShiftKeyDown = false;
        mapContainer.style.cursor = 'default'; // Restablece el cursor predeterminado
      }
    });

    // Event listener para el clic en el mapa
    map.on('click', function(event) {
      if (isShiftKeyDown) {
        map.getView().setZoom(map.getView().getZoom()+1);  
        mapContainer.style.cursor = 'url("data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 0 64 64\' width=\'32\' height=\'32\'%3E%3Cpath stroke=\'%23000\' stroke-width=\'4\' d=\'M32 0 v64 M0 32 h64\'/%3E%3C/svg%3E"), auto';
      } else {
        mapContainer.style.cursor = 'default';
      }
    });
  // codigo de cuando se mueva el mapa cambiar el puntero 
    map.on('pointermove', function(event) {
    if (map.getView().getInteracting()) {
      // Si el usuario está interactuando con el mapa (por ejemplo, arrastrando), establece el cursor de movimiento
      mapContainer.style.cursor = 'move';
    } else {
      // De lo contrario, establece el cursor predeterminado
      mapContainer.style.cursor = 'default';
    }
    });

/* CAPAS BASE */ 
  var bingimg = new ol.layer.Tile({
    source: new ol.source.BingMaps({
      key: 'AmX1FVgGILJ-v3nO2tttFP5-CrYrAIip7w0Uzd9T_UfQqZz6ZoDrmgyv2rnhxO9z',
      imagerySet: 'Aerial'
    }),
    visible: false,
    title: '12-BING'
  });
  // añadir capas base link https://www.faneci.com/url-para-anadir-mapas-base-en-qgis/
  var googleSatelliteLayer = new ol.layer.Tile({
    title: 'Google Satellite',
    visible: false,
    source: new ol.source.XYZ({
        url: 'http://www.google.cn/maps/vt?lyrs=s@189&gl=cn&x={x}&y={y}&z={z}'
    })
  });

/* MOSTRAR CAPAS BASE */ 
  var bing = document.getElementById("bing");
  bing.addEventListener("change", comprobarCapasBase, false);

  var mdm = document.getElementById("mdm");
  mdm.addEventListener("change", comprobarCapasBase, false);

  var google = document.getElementById("google");
  google.addEventListener("change", comprobarCapasBase, false);

  function comprobarCapasBase(e){

    if($('#bing').is(':checked')){
      bingimg.setVisible(true);
    } else {
      bingimg.setVisible(false);
    }

    if($('#google').is(':checked')){
      googleSatelliteLayer.setVisible(true);
      console.log("google");
    } else {
      googleSatelliteLayer.setVisible(false);
    }

    if($('#mdm').is(':checked')){
      bingimg.setVisible(false);
      googleSatelliteLayer.setVisible(false);
    }
  }

/* AGREGAR CAPAS BASE */ 
  map.addLayer(bingimg);
  map.addLayer(googleSatelliteLayer);

/* OPACIDAD */ 
  function menos(){
    var layer = map.getLayers().item(0); // obtener la primera capa en el mapa
    var currentOpacity = layer.getOpacity(); // obtener la opacidad actual
    var newOpacity = currentOpacity - 0.1; // reducir la opacidad en 20%
    layer.setOpacity(newOpacity); // establecer la nueva opacidad

    var currentOpacityGoogle = googleSatelliteLayer.getOpacity();
    googleSatelliteLayer.setOpacity(currentOpacityGoogle - 0.1);
  }

  function mas(){
    var layer = map.getLayers().item(0); // obtener la primera capa en el mapa
    var currentOpacity = layer.getOpacity(); // obtener la opacidad actual
    var newOpacity = currentOpacity + 0.1; // aumentar la opacidad en 20%
    layer.setOpacity(newOpacity); // establecer la nueva opacidad

    var currentOpacityGoogle = googleSatelliteLayer.getOpacity();
    googleSatelliteLayer.setOpacity(currentOpacityGoogle + 0.1);
  }

/* LAYERS */

  var mxestados =  new ol.layer.Tile({
    title: 'Estados',
    name: 'Estados',
    visible: true,
    source: new ol.source.TileWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:entidad_2022', TRANSPARENT: true, STYLES: 'estados',}, 
      serverType: 'geoserver',
    })
  });


  var estadoset = new ol.layer.Image({
    title: 'EstadoSet',
    name: 'estadoset',
    visible: true,
    source: new ol.source.ImageWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:entidad_2022', STYLES: 'estadoset', TRANSPARENT: true},
      serverType: 'geoserver',
    })
  });

  var municipios =  new ol.layer.Tile({
    title: 'Municipios',
    name: 'Municipios',
    visible: false,
    minZoom: 8,
    maxScale: 0,
    minScale: 3000000,
    source: new ol.source.TileWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:municipio_2022', STYLES: 'mun_hist', TRANSPARENT: true,}, /// duda
      serverType: 'geoserver',
    })
  });

  var municipioset =  new ol.layer.Image({
    title: 'Nombre Municipios',
    name: 'municipioset',
    visible: false,
    minZoom: 9,
    maxScale: 0,
    minScale: 1000000,
    source: new ol.source.ImageWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:municipio_2022', STYLES: 'municipioset', TRANSPARENT: true}, /// duda
      serverType: 'geoserver'
    })
  });

  var agebrural =  new ol.layer.Tile({
    title: 'Ageb Rural',
    name: 'agebrural',
    visible: false,
    maxScale: 0,
    minZoom: 10,
    minScale: 1000000,
    source: new ol.source.TileWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:ageb_2022', TRANSPARENT: true, STYLES: 'agebs'}, /// duda
      serverType: 'geoserver',
    })
  });
  var agebruralset =  new ol.layer.Image({
    title: 'Agebrural set',
    name: 'agebruralset',
    visible: false,
    maxScale: 0,
    minZoom: 10,
    minScale: 600000,
    source: new ol.source.ImageWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:ageb_2022', TRANSPARENT: true, STYLES: 'agebset_hist'}, /// duda
      serverType: 'geoserver',
    })
  });

  var locurbana =  new ol.layer.Tile({
    title: 'Loc Urbana',
    name: 'locurbana',
    visible: false,
    maxScale: 0,
    minZoom: 9,
    minScale: 500000,
    source: new ol.source.TileWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:l_2022', TRANSPARENT: true, STYLES: 'urbanas', CQL_FILTER: 'ambito=\'Urbana\' or ambito=\'U\''}, /// duda
      serverType: 'geoserver',
    })
  });

  var locurbanatxt =  new ol.layer.Image({
    title: 'Loc Urbana',
    name: 'locurbanatxt',
    visible: false,
    maxScale: 0,
    minZoom: 9,
    minScale: 100000,
    source: new ol.source.ImageWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:l_2022', TRANSPARENT: true, STYLES: 'urbanaset_hist', CQL_FILTER: 'ambito=\'Urbana\' or ambito=\'U\''}, /// duda
      serverType: 'geoserver',
    })
  });


  var ageburbana =  new ol.layer.Tile({
    title: 'Ageb Urbana',
    name: 'ageburbana',
    visible: false,
    maxScale: 0,
    minZoom: 12,
    minScale: 600000,
    source: new ol.source.TileWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:agebu_2022', TRANSPARENT: true, STYLES: 'agebs',}, /// duda
      serverType: 'geoserver',
    })
  });

  var ageburbanatxt =  new ol.layer.Image({
    title: 'Ageb Urbana txt',
    name: 'ageburbanatxt',
    visible: false,
    maxScale: 0,
    minZoom: 13,
    minScale: 100000,
    source: new ol.source.ImageWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:agebu_2022', TRANSPARENT: true, STYLES: 'agebset_hist',}, /// duda
      serverType: 'geoserver',
    })
  });

  var locrural =  new ol.layer.Tile({
    title: 'Loc Rural',
    name: 'locrural',
    visible: false,
    maxScale: 0,
    minZoom: 10,
    minScale: 300000,
    source: new ol.source.TileWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:l_2022', TRANSPARENT: true, STYLES: 'porur', CQL_FILTER: 'ambito=\'Rural\'  or ambito=\'R\''}, /// duda
      serverType: 'geoserver',
    })
  });

   var locruraltxt =  new ol.layer.Image({
    title: 'Loc Rural txt',
    name: 'locruraltxt',
    visible: false,
    maxScale: 0,
    minZoom: 11,
    minScale: 100000,
    source: new ol.source.ImageWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:l_2022', TRANSPARENT: true, STYLES: 'poruret_hist', CQL_FILTER: 'ambito=\'Rural\'  or ambito=\'R\''}, /// duda
      serverType: 'geoserver',
    })
  });

  var locrur_ext =  new ol.layer.Tile({
    title: 'Loc Rural Ext',
    name: 'locruralext',
    visible: false,
    maxScale: 0,
    minZoom: 10,
    minScale: 300000,
    source: new ol.source.TileWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:pe_2022', TRANSPARENT: true, STYLES: 'pol_rur_ext',}, /// duda
      serverType: 'geoserver',
    })
  });

  var mza =  new ol.layer.Tile({
    title: 'Manzana',
    name: 'mza',
    visible: false,
    maxScale: 0,
    minZoom: 12,
    minScale: 600000,
    source: new ol.source.TileWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:manzana_2022', TRANSPARENT: true, STYLES: 'mza',}, /// duda
      serverType: 'geoserver',
    })
  });

  var mzatxt =  new ol.layer.Image({
    title: 'Mza txt',
    name: 'mzatxt',
    visible: false,
    maxScale: 0,
    minZoom: 13,
    minScale: 200000,
    source: new ol.source.ImageWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:manzana_2022', TRANSPARENT: true, STYLES: 'mzaet_hist',}, /// duda
      serverType: 'geoserver',
    })
  });

  var caserio =  new ol.layer.Image({
    title: 'Caserio',
    name:'caserio',
    visible: false,
    maxScale: 0,
    minZoom: 12,
    minScale: 600000,
    source: new ol.source.ImageWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:caserio_2022', TRANSPARENT: true, STYLES: 'caserio_hist',}, /// duda
      serverType: 'geoserver',
    })
  });

  var locvig =  new ol.layer.Tile({
    title: 'Locs Vig',
    name: 'locsvig',
    visible: false,
    maxScale: 0,
    minZoom: 12,
    minScale: 200000,
    source: new ol.source.TileWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:lpr_2022', TRANSPARENT: true, STYLES: 'locsrur1_hist',}, /// duda
      serverType: 'geoserver',
    })
  });

  var txtlocvig =  new ol.layer.Image({
    title: 'Loc Vig txt',
    name: 'locsvigtxt',
    visible: false,
    maxScale: 0,
    minZoom: 12,
    minScale: 100000,
    source: new ol.source.ImageWMS({
      url: 'http://w-webintratslic.inegi.gob.mx:8080/geoserver/HISTORICO/wms',
      params: {'LAYERS': 'HISTORICO:lpr_2022', TRANSPARENT: true, STYLES: 'locsruret1_hist',}, /// duda
      serverType: 'geoserver',
    })
  });

/* CODIGO MOSTRAR LAYERS */ 

  var stateV = document.getElementById("state");
  stateV.addEventListener("change", comprobarRespuesta, false);

  var txtEstadosV = document.getElementById("txtEstados");
  txtEstadosV.addEventListener("change", comprobarRespuesta, false);

  var municipioV = document.getElementById("muni");
  municipioV.addEventListener("change", comprobarRespuesta, false);

  var txtmunicipioV = document.getElementById("txtMunicipios");
  txtmunicipioV.addEventListener("change", comprobarRespuesta, false);

  var agebruralV = document.getElementById("agebrural");
  agebruralV.addEventListener("change", comprobarRespuesta, false);

  var txtagebrural = document.getElementById("txtAgebRural");
  txtagebrural.addEventListener("change", comprobarRespuesta, false);

  var locurbanaV = document.getElementById("locurbana");
  locurbanaV.addEventListener("change", comprobarRespuesta, false);

  var txtlocurbana = document.getElementById("txtLocUrbana");
  txtlocurbana.addEventListener("change", comprobarRespuesta, false);

  var ageburbanaV = document.getElementById("chbxageburbana");
  ageburbanaV.addEventListener("change", comprobarRespuesta, false);

  var txtagebu = document.getElementById("txtageburbana");
  txtagebu.addEventListener("change", comprobarRespuesta, false);

  var locruralV = document.getElementById("chbxlocrural");
  locruralV.addEventListener("change", comprobarRespuesta, false);

  var locruraltxtv = document.getElementById("chbxtxtlocrural");
  locruraltxtv.addEventListener("change", comprobarRespuesta, false);

  var locrur_extv = document.getElementById("chbxlocrur_ext");
  locrur_extv.addEventListener("change", comprobarRespuesta, false);

  var mzav = document.getElementById("chbxmanzana");
  mzav.addEventListener("change", comprobarRespuesta, false);

  var txtmza = document.getElementById("chbxtxtmanzana");
  txtmza.addEventListener("change", comprobarRespuesta, false);

  var caseriov = document.getElementById("chbxcaserio");
  caseriov.addEventListener("change", comprobarRespuesta, false);

  var locvigv = document.getElementById("chbxlocvig");
  locvigv.addEventListener("change", comprobarRespuesta, false);

  var txtlocvigv = document.getElementById("chbxtxtlocvig");
  txtlocvigv.addEventListener("change", comprobarRespuesta, false);

  function comprobarRespuesta(e) {
    
    if($('#state').is(':checked')){
      document.getElementById("btnEstados").style.background = "#FFEBEE";
      mxestados.setVisible(true);
    } else {
      mxestados.setVisible(false);
      document.getElementById("btnEstados").style.background = "#F5F5F5";
    }

    if($('#txtEstados').is(':checked')){
      estadoset.setVisible(true);
    } else {
      estadoset.setVisible(false);
    }

    if($('#muni').is(':checked')){
      document.getElementById("btnMunicipios").style.background = "#EFEBE9";
      municipios.setVisible(true);
    } else {
      municipios.setVisible(false);
      document.getElementById("btnMunicipios").style.background = "#F5F5F5";
    }

    if($('#txtMunicipios').is(':checked')){
      municipioset.setVisible(true);
    } else {
      municipioset.setVisible(false);
    }

    if($('#agebrural').is(':checked')){
      document.getElementById("btnAgebRural").style.background = "#E3F2FD";
      agebrural.setVisible(true);
    } else {
      agebrural.setVisible(false);
      document.getElementById("btnAgebRural").style.background = "#F5F5F5";
    }

    if($('#txtAgebRural').is(':checked')){
      agebruralset.setVisible(true);
    } else {
      agebruralset.setVisible(false);
    }

     if($('#locurbana').is(':checked')){
      document.getElementById("btnLocUrbana").style.background = "#F0F4C3";
      locurbana.setVisible(true);
    } else {
      locurbana.setVisible(false);
      document.getElementById("btnLocUrbana").style.background = "#F5F5F5";
    }

    if($('#txtLocUrbana').is(':checked')){
      locurbanatxt.setVisible(true);
    } else {
      locurbanatxt.setVisible(false);
    }

    if($('#chbxageburbana').is(':checked')){
      document.getElementById("btnAgebUrbana").style.background = "#BBDEFB";
      ageburbana.setVisible(true);
    } else {
      ageburbana.setVisible(false);
      document.getElementById("btnAgebUrbana").style.background = "#F5F5F5";
    }

    if($('#txtageburbana').is(':checked')){
      ageburbanatxt.setVisible(true);
    } else {
      ageburbanatxt.setVisible(false);
    }

    if($('#chbxlocrural').is(':checked')){
      document.getElementById("btnLocRural").style.background = "#D7CCC8";
      locrural.setVisible(true);
    } else {
      locrural.setVisible(false);
      document.getElementById("btnLocRural").style.background = "#F5F5F5";
    }

    if($('#chbxtxtlocrural').is(':checked')){
      locruraltxt.setVisible(true);
    } else {
      locruraltxt.setVisible(false);
    }

    if ($('#chbxlocrur_ext').is(':checked')) {
      document.getElementById("btnLocRur_Ext").style.background = "#E0E0E0";
      locrur_ext.setVisible(true);
    } else {
      locrur_ext.setVisible(false);
      document.getElementById("btnLocRur_Ext").style.background = "#F5F5F5"; 
    }

    if($('#chbxmanzana').is(':checked')){
      document.getElementById("btnMza").style.background = "#BCAAA4";
      mza.setVisible(true);
    } else {
      mza.setVisible(false);
      document.getElementById("btnMza").style.background = "#F5F5F5";
    }

    if($('#chbxtxtmanzana').is(':checked')){
      mzatxt.setVisible(true);
    } else {
      mzatxt.setVisible(false);
    }

    if($('#chbxcaserio').is(':checked')){
      document.getElementById("btnCaserio").style.background = "#B0BEC5";
      caserio.setVisible(true);
    } else {
      caserio.setVisible(false);
      document.getElementById("btnCaserio").style.background = "#F5F5F5";
    }    


    if($('#chbxlocvig').is(':checked')){
      document.getElementById("btnLocVig").style.background = "#90A4AE";
      locvig.setVisible(true);
    } else {
      locvig.setVisible(false);
      document.getElementById("btnLocVig").style.background = "#F5F5F5";
    }

    if($('#chbxtxtlocvig').is(':checked')){
      txtlocvig.setVisible(true);
    } else {
      txtlocvig.setVisible(false);
    }
    
  }

/* ADD LAYERS */ 

  map.addLayer(agebrural);
  map.addLayer(agebruralset);

  map.addLayer(locurbana);
  map.addLayer(locurbanatxt);

  map.addLayer(mza);
  map.addLayer(mzatxt);

  map.addLayer(locrur_ext);

  map.addLayer(locrural);
  map.addLayer(locruraltxt);

  map.addLayer(ageburbana);
  map.addLayer(ageburbanatxt);

  map.addLayer(caserio);

  map.addLayer(locvig);
  map.addLayer(txtlocvig);

  map.addLayer(municipios);
  map.addLayer(municipioset);

  map.addLayer(mxestados);
  map.addLayer(estadoset);

/* INPUT RANGE */ 
  const rangeInputs = document.querySelectorAll('input[type="range"]')
  const numberInput = document.querySelector('input[type="number"]')

  function handleInputChange(e) {
    let target = e.target
    if (e.target.type !== 'range') {
      target = document.getElementById('range')
    } 
    const min = target.min
    const max = target.max
    const val = target.value
  
    target.style.backgroundSize = (val - min) * 100 / (max - min) + '% 100%'
  }

  rangeInputs.forEach(input => {
    input.addEventListener('input', handleInputChange)
  });

  numberInput.addEventListener('input', handleInputChange);

  const progress = document.querySelector('.progress');
  
  progress.addEventListener('input', function() {
    const value = this.value;
    this.style.background = `linear-gradient(to right, #cfe2ff 0%, #cfe2ff ${value}%, #fff ${value}%, white 100%)`
  });

    function showVal(e){
      var year = '';
        switch(e) {
            case '0':  document.fi.rangeSal.value = '1990'; year='1990'; break;
            case '10': document.fi.rangeSal.value = '1995'; year = '1995'; break;
            case '20': document.fi.rangeSal.value = '2000'; year = '2000'; break;
            case '30': document.fi.rangeSal.value = '2005'; year = '2005'; break;
            case '40': document.fi.rangeSal.value = '2010'; year = '2010'; break;
            case '50': document.fi.rangeSal.value = '2015'; year = '2015'; break;
            case '60': document.fi.rangeSal.value = '2018'; year = '2018'; break;
            case '70': document.fi.rangeSal.value = '2019'; year = '2019'; break;
            case '80': document.fi.rangeSal.value = '2020'; year = '2020'; break;
            case '90': document.fi.rangeSal.value = '2021'; year = '2021';break;
            case '100': document.fi.rangeSal.value = '2022'; year = '2022'; break;        
        }
        //console.log(year);
        
        // ESTADOS 
        var mxestados = map.getLayers().getArray().find(layer => layer.get('name') === 'Estados');var fuenteEstados = mxestados.getSource();
        var NPEstados = {'LAYERS': 'HISTORICO:entidad_'+year, 'STYLES': 'estados'}; fuenteEstados.updateParams(NPEstados); fuenteEstados.refresh();

        var estadoset = map.getLayers().getArray().find(layer => layer.get('name') === 'estadoset');var fuenteestadoset = estadoset.getSource();
        var NPEstadoset = {'LAYERS': 'HISTORICO:entidad_'+year, 'STYLES': 'estadoset'}; fuenteestadoset.updateParams(NPEstadoset); fuenteestadoset.refresh();

        // MUNICIPIOS
        var municipios = map.getLayers().getArray().find(layer => layer.get('name') === 'Municipios');var fuenteMunicipios = municipios.getSource();
        var NPMunicipios = {'LAYERS': 'HISTORICO:municipio_'+year}; fuenteMunicipios.updateParams(NPMunicipios); fuenteMunicipios.refresh();

        var municipioset = map.getLayers().getArray().find(layer => layer.get('name') === 'municipioset');var fuenteMunicipioset = municipioset.getSource();
        var NPMunicipioset = {'LAYERS': 'HISTORICO:municipio_'+year}; fuenteMunicipioset.updateParams(NPMunicipioset); fuenteMunicipioset.refresh();

        // AGEB RURAL 
        var agebrural = map.getLayers().getArray().find(layer => layer.get('name') === 'agebrural');var fuenteagebrural = agebrural.getSource();
        var NPagebrural = {'LAYERS': 'HISTORICO:ageb_'+year}; fuenteagebrural.updateParams(NPagebrural); fuenteagebrural.refresh();

        var agebruralset = map.getLayers().getArray().find(layer => layer.get('name') === 'agebruralset');var fuenteagebruralset = agebruralset.getSource();
        var NPagebruralset = {'LAYERS': 'HISTORICO:ageb_'+year}; fuenteagebruralset.updateParams(NPagebruralset); fuenteagebruralset.refresh();

        // Loc Urbana
        var locurbana = map.getLayers().getArray().find(layer => layer.get('name') === 'locurbana');var fuenteLocUrbana = locurbana.getSource();
        var NPLocUrbana = {'LAYERS': 'HISTORICO:l_'+year}; fuenteLocUrbana.updateParams(NPLocUrbana); fuenteLocUrbana.refresh();

        var locurbanatxt = map.getLayers().getArray().find(layer => layer.get('name') === 'locurbanatxt');var fuenteLocUrbanatxt = locurbanatxt.getSource();
        var NPLocUrbanatxt = {'LAYERS': 'HISTORICO:l_'+year}; fuenteLocUrbanatxt.updateParams(NPLocUrbanatxt); fuenteLocUrbanatxt.refresh();

        // AGEB Urbana
        var ageburbana = map.getLayers().getArray().find(layer => layer.get('name') === 'ageburbana');var fuenteageburbana = ageburbana.getSource();
        var NPageburbana = {'LAYERS': 'HISTORICO:agebu_'+year}; fuenteageburbana.updateParams(NPageburbana); fuenteageburbana.refresh();

        var ageburbanatxt = map.getLayers().getArray().find(layer => layer.get('name') === 'ageburbanatxt');var fuenteageburbanatxt = ageburbanatxt.getSource();
        var NPageburbanatxt = {'LAYERS': 'HISTORICO:agebu_'+year}; fuenteageburbanatxt.updateParams(NPageburbanatxt); fuenteageburbanatxt.refresh();

        // Loc Rural
        var locrural = map.getLayers().getArray().find(layer => layer.get('name') === 'locrural');var fuentelocrural = locrural.getSource();
        var NPlocrural = {'LAYERS': 'HISTORICO:l_'+year}; fuentelocrural.updateParams(NPlocrural); fuentelocrural.refresh();

        var locruraltxt = map.getLayers().getArray().find(layer => layer.get('name') === 'locruraltxt');var fuentelocruraltxt = locruraltxt.getSource();
        var NPlocruraltxt = {'LAYERS': 'HISTORICO:l_'+year}; fuentelocruraltxt.updateParams(NPlocruraltxt); fuentelocruraltxt.refresh();

        // Loc Rural Ext
        var locrurext = map.getLayers().getArray().find(layer => layer.get('name') === 'locruralext');var fuentelocruralext = locrurext.getSource();
        var NPlocruralext = {'LAYERS': 'HISTORICO:pe_'+year}; fuentelocruralext.updateParams(NPlocruralext); fuentelocruralext.refresh();

        // Manzana
        var mza = map.getLayers().getArray().find(layer => layer.get('name') === 'mza');var fuentemza = mza.getSource();
        var NPmza = {'LAYERS': 'HISTORICO:manzana_'+year}; fuentemza.updateParams(NPmza); fuentemza.refresh();

        var mzatxt = map.getLayers().getArray().find(layer => layer.get('name') === 'mzatxt');var fuentemzatxt = mzatxt.getSource();
        var NPmzatxt = {'LAYERS': 'HISTORICO:manzana_'+year}; fuentemzatxt.updateParams(NPmzatxt); fuentemzatxt.refresh();

        // Caserio 
        var caserio = map.getLayers().getArray().find(layer => layer.get('name') === 'caserio');var fuentecaserio = caserio.getSource();
        var NPcaserio = {'LAYERS': 'HISTORICO:caserio_'+year}; fuentecaserio.updateParams(NPcaserio); fuentecaserio.refresh();

        // Locs Vig
        var locsvig = map.getLayers().getArray().find(layer => layer.get('name') === 'locsvig');var fuentelocsvig = locsvig.getSource();
        var NPlocsvig = {'LAYERS': 'HISTORICO:lpr_'+year}; fuentelocsvig.updateParams(NPlocsvig); fuentelocsvig.refresh();

        var locsvigtxt = map.getLayers().getArray().find(layer => layer.get('name') === 'locsvigtxt');var fuentelocsvigtxt = locsvigtxt.getSource();
        var NPlocsvigtxt = {'LAYERS': 'HISTORICO:lpr_'+year}; fuentelocsvigtxt.updateParams(NPlocsvigtxt); fuentelocsvigtxt.refresh();

        //desactivar casillas

        if(year=='1990' || year=='1995' || year=='2005'){
          document.getElementById("agebrural").disabled=true;
          document.getElementById("txtAgebRural").disabled=true;
        } else {
          document.getElementById("agebrural").disabled=false;
          document.getElementById("txtAgebRural").disabled=false;
        }
        if(year=='1990' || year=='1995'){
          document.getElementById("chbxlocrural").disabled=true;
          document.getElementById("chbxtxtlocrural").disabled=true;

          document.getElementById("chbxlocrur_ext").disabled=true;
          document.getElementById("chbxcaserio").disabled=true;
        } else {
          document.getElementById("chbxlocrural").disabled=false;
          document.getElementById("chbxtxtlocrural").disabled=false;
          
          document.getElementById("chbxlocrur_ext").disabled=false;
          document.getElementById("chbxcaserio").disabled=false;
        }
    };

/* FUNCIONES ICONOS ACCESO RAPIDO */ 
  document.getElementById("desplazar").style.background = "#cfe2ff";

  var medirv = document.getElementById("chbxmedir");
  medirv.addEventListener("change", comprobarIconos, false);

  var despv = document.getElementById("chbxdesplazar");
  despv.addEventListener("change", comprobarIconos, false);

  var altitudv = document.getElementById("chbxaltitud");
  altitudv.addEventListener("change", comprobarIconos, false);

  // altitud 
    var pointLayeralt = new ol.layer.Vector({
      source: new ol.source.Vector(),
      title: "PointSV"
    });

    var draw = new ol.interaction.Draw({
      type: "Point",
      source: pointLayeralt.getSource(),
      title: "Altitud (MDE)",
      className: "olControlAltitud",
      stopClick: false
    })
    document.getElementById('msjs').style.display = 'none';

  function comprobarIconos(e)
  {
    document.getElementById('msjs').style.display = 'none';
    // funcion altitud
      if($('#chbxaltitud').is(':checked')){
        document.getElementById("boxmedir").style.display = 'none';
        document.getElementById("altitudbtn").style.background = "#cfe2ff"; // azul 
        document.getElementById("medir").style.background = "#F5F5F5"; // gris
        document.getElementById("desplazar").style.background = "#F5F5F5"; // gris

        map.addInteraction(draw);
        map.on('click', function(event) {
          const ll = map.getCoordinateFromPixel(event.pixel);
          const transformedLL = ol.proj.transform(ll, 'EPSG:3857', 'EPSG:4326');
          const lon = transformedLL[0];
          const lat = transformedLL[1];
          //console.log("Lon " + lon + " Lat " + lat);
     
          fetch('obtalt.jsp?x=' + lon + '&y=' + lat)
            .then(function(response) {
              if (response.ok) {
                return response.text();
              } else {
                throw new Error('No se pudo obtener la altura');
              }
            })
            .then(function(val) {
              var alt = parseInt(val);
              if (isNaN(alt) || alt == 32767 || alt < -100 || val === '') {
                alt = 0;
              }
              alertmsg("Altitud: " + alt);
            })
            .catch(function(error) {
              alertmsg(error.message);
            });
        });
        document.getElementById('msjs').style.display = 'none';

        if($('#chbxmedir').is(':checked')){
          map.removeInteraction(draw);
          document.getElementById('msjs').style.display = 'none';
        }
      }

    // Funcion medir 
      if($('#chbxmedir').is(':checked'))
      { 
        document.getElementById('msjs').style.display = 'none';
        document.getElementById("boxmedir").style.display = 'block';
        document.getElementById("altitudbtn").style.background = "#F5F5F5"; // gris 
        document.getElementById("medir").style.background = "#cfe2ff"; // azul 
        document.getElementById("desplazar").style.background = "#F5F5F5"; // gris

        const raster = new ol.layer.Tile({/*source: new ol.source.OSM()*/});
          const source = new ol.source.Vector();
            const vector = new ol.layer.Vector({
              source: source,
              style: new ol.style.Style({
                fill: new ol.style.Fill({
                  color: 'rgba(255, 255, 255, 0.2)'
                }),
                stroke: new ol.style.Stroke({
                  color: '#ffcc33',
                  width: 2
                }),
                image: new ol.style.Circle({
                  radius: 7,
                  fill: new ol.style.Fill({
                  color: '#ffcc33'
                })
              })
          })
        });

        map.addLayer(raster);
        map.addLayer(vector);

        let sketch;
        let helpTooltipElement;
        let helpTooltip;
        let measureTooltipElement;
        let measureTooltip;
        const continuePolygonMsg = 'Click to continue drawing the polygon';
        const continueLineMsg = 'Click to continue drawing the line';

        const pointerMoveHandler = function(evt) {
          document.getElementById('msjs').style.display = 'none';
          if (evt.dragging) {

            return;
          }
          let helpMsg = 'Click to start drawing';
          if (sketch) {
            const geom = sketch.getGeometry();
            document.getElementById('msjs').style.display = 'none';
            if (geom instanceof ol.geom.Polygon) {
              document.getElementById('msjs').style.display = 'none';
              helpMsg = continuePolygonMsg;
            } else if (geom instanceof ol.geom.LineString) {
              document.getElementById('msjs').style.display = 'none';
              helpMsg = continueLineMsg;
            }

          }
          helpTooltipElement.innerHTML = helpMsg;
          helpTooltip.setPosition(evt.coordinate);
          helpTooltipElement.classList.remove('hidden');
        };

        map.on('pointermove', pointerMoveHandler);

        map.getViewport().addEventListener('mouseout', function() {
          document.getElementById('msjs').style.display = 'none';
          helpTooltipElement.classList.add('hidden');
        });

        const typeSelect = document.getElementById('type');

        let draw;

        const formatLength = function(line) {
          document.getElementById('msjs').style.display = 'none';
          const length = ol.sphere.getLength(line);
          let output;
          if (length > 100) {
            output = Math.round((length / 1000) * 100) / 100 + ' ' + 'km';
          } else {
            output = Math.round(length * 100) / 100 + ' ' + 'm';
          }
          return output;
        };

        const formatArea = function(polygon) {
          document.getElementById('msjs').style.display = 'none';
          const area = ol.sphere.getArea(polygon);
          let output;
          if (area > 10000) {
            output = Math.round((area / 1000000) * 100) / 100 + ' ' + 'km<sup>2</sup>';
          } else {
            output = Math.round(area * 100) / 100 + ' ' + 'm<sup>2</sup>';
          }
          return output;
        };

        function addInteraction() {
          document.getElementById('msjs').style.display = 'none';
          var type = typeSelect.value == 'area' ? 'Polygon' : 'LineString';
          draw = new ol.interaction.Draw({
            source: source,
            type: type,
            style: new ol.style.Style({
              fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.2)',
              }),
              stroke: new ol.style.Stroke({
                color: 'rgba(0, 0, 0, 0.5)',
                lineDash: [10, 10],
                width: 2,
              }),
              image: new ol.style.Circle({
                radius: 5,
                stroke: new ol.style.Stroke({
                  color: 'rgba(0, 0, 0, 0.7)',
                }),
                fill: new ol.style.Fill({
                  color: 'rgba(255, 255, 255, 0.2)',
                }),
              }),
            }),
          });

          map.addInteraction(draw);

          createMeasureTooltip();
          createHelpTooltip();

          var listener;
          draw.on('drawstart', function (evt) {
            document.getElementById('msjs').style.display = 'none';
            sketch = evt.feature;
            var tooltipCoord = evt.coordinate;

            listener = sketch.getGeometry().on('change', function (evt) {
              document.getElementById('msjs').style.display = 'none';
              var geom = evt.target;
              var output;
              if (geom instanceof ol.geom.Polygon) {
                document.getElementById('msjs').style.display = 'none';
                output = formatArea(geom);
                tooltipCoord = geom.getInteriorPoint().getCoordinates();
              } else if (geom instanceof ol.geom.LineString) {
                document.getElementById('msjs').style.display = 'none';
                output = formatLength(geom);
                tooltipCoord = geom.getLastCoordinate();
              }
              measureTooltipElement.innerHTML = output;
              measureTooltip.setPosition(tooltipCoord);
            });
          });

          draw.on('drawend', function () {
            document.getElementById('msjs').style.display = 'none';
            measureTooltipElement.className = 'ol-tooltip ol-tooltip-static';
            measureTooltip.setOffset([0, -7]);
            sketch = null;
            measureTooltipElement = null;
            createMeasureTooltip();
            ol.Observable.unByKey(listener);
          });
        }

        function createHelpTooltip() {
          document.getElementById('msjs').style.display = 'none';
          if (helpTooltipElement) {
            helpTooltipElement.parentNode.removeChild(helpTooltipElement);
          }
          helpTooltipElement = document.createElement('div');
          helpTooltipElement.className = 'ol-tooltip hidden';
          helpTooltip = new ol.Overlay({
            element: helpTooltipElement,
            offset: [15, 0],
            positioning: 'center-left',
          });
          map.addOverlay(helpTooltip);
       
        }

        function createMeasureTooltip() {
          document.getElementById('msjs').style.display = 'none';
          if (measureTooltipElement) {
            measureTooltipElement.parentNode.removeChild(measureTooltipElement);
          }
          measureTooltipElement = document.createElement('div');
          measureTooltipElement.className = 'ol-tooltip ol-tooltip-measure';
          measureTooltip = new ol.Overlay({
            element: measureTooltipElement,
            offset: [0, -15],
            positioning: 'bottom-center',
            stopEvent: false,
            insertFirst: false,
          });
          map.addOverlay(measureTooltip);
        }

        typeSelect.onchange = function () {
          map.removeInteraction(draw);
          document.getElementById('msjs').style.display = 'none';
          addInteraction();
        };
        document.getElementById('msjs').style.display = 'none';
        addInteraction();
        
      }

    // funcion desplazar 
      if($('#chbxdesplazar').is(':checked')){
        document.getElementById('msjs').style.display = 'none';
        map.removeInteraction(draw);
        document.getElementById("boxmedir").style.display = 'none';
        document.getElementById("altitudbtn").style.background = "#F5F5F5"; // gris 
        document.getElementById("medir").style.background = "#F5F5F5"; // gris
        document.getElementById("desplazar").style.background = "#cfe2ff"; // azul

        var mapContainer = map.getTargetElement();
        var isShiftKeyDown = false;
        window.addEventListener('keydown', function(event) {
          if (event.shiftKey) {
            isShiftKeyDown = true;
          }
        });
        window.addEventListener('keyup', function(event) {
          if (!event.shiftKey) {
            document.getElementById('msjs').style.display = 'none';
            isShiftKeyDown = false;
            mapContainer.style.cursor = 'default';
          }
        });
        map.on('click', function(event) {
          document.getElementById('msjs').style.display = 'none';
          if (isShiftKeyDown) {
            document.getElementById('msjs').style.display = 'none';
            map.getView().setZoom(map.getView().getZoom()+1);  
            mapContainer.style.cursor = 'url("data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 0 64 64\' width=\'32\' height=\'32\'%3E%3Cpath stroke=\'%23000\' stroke-width=\'4\' d=\'M32 0 v64 M0 32 h64\'/%3E%3C/svg%3E"), auto';
          } else {
            document.getElementById('msjs').style.display = 'none';
            mapContainer.style.cursor = 'default';
          }
        });
      }
  }

  // Info 

/* FUNCION DE RETROCESO Y SIGUIENTE */ 
  //https://openlayers.org/en/latest/examples/permalink.html#map=5.91/-4129023.32/-316922.83/0
  if (window.location.hash !== '') {
    // try to restore center, zoom-level and rotation from the URL
    const hash = window.location.hash.replace('#map=', '');
    const parts = hash.split('/');
    if (parts.length === 4) {
      zoom = parseFloat(parts[0]);
      center = [parseFloat(parts[1]), parseFloat(parts[2])];
      rotation = parseFloat(parts[3]);
    }
  }

  let shouldUpdate = true;
  view = map.getView();
  const updatePermalink = function () {
    if (!shouldUpdate) {
      // do not update the URL when the view was changed in the 'popstate' handler
      shouldUpdate = true;
      return;
    }

    const center = view.getCenter();
    const hash =
      '#map=' +
      view.getZoom().toFixed(2) +
      '/' +
      center[0].toFixed(2) +
      '/' +
      center[1].toFixed(2) +
      '/' +
      view.getRotation();
    const state = {
      zoom: view.getZoom(),
      center: view.getCenter(),
      rotation: view.getRotation(),
    };
  
    window.history.pushState(state, 'map', hash);
  };

  map.on('moveend', updatePermalink);

  // restore the view state when navigating through the history, see
  // https://developer.mozilla.org/en-US/docs/Web/API/WindowEventHandlers/onpopstate
  window.addEventListener('popstate', function (event) {
    if (event.state === null) {
      return;
    }
    map.getView().setCenter(event.state.center);
    map.getView().setZoom(event.state.zoom);
    map.getView().setRotation(event.state.rotation);
    shouldUpdate = false;
  });

/* DEMAS FUNCIONES */
  // ajax
    function nuevoAjax()
    {
      /* Crea el objeto AJAX. Esta funcion es generica para cualquier utilidad de este tipo, por
      lo que se puede copiar tal como esta aqui */
      var xmlhttp=false;
      try {
          // Creacion del objeto AJAX para navegadores no IE
          xmlhttp=new ActiveXObject("Msxml2.XMLHTTP");
      }catch(e){
          try {
              // Creacion del objet AJAX para IE
              xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
          }catch(E){
              if (!xmlhttp && typeof XMLHttpRequest!=undefined) xmlhttp=new XMLHttpRequest();
          }
      }return xmlhttp;
    }

  // alert msj
    function alertmsg(msg){
      document.getElementById('msjs').style.display = 'block';
      document.getElementById('textomsg').innerHTML = msg;
    }

/* BUSQUEDAS */ 
  // Estrella como marcador en el punto 
    var starStyle = new ol.style.Style({
      image: new ol.style.RegularShape({
        fill: new ol.style.Fill({
          color: '#2196F3'
        }),
        points: 5,
        radius: 10,
        radius2: 4,
        stroke: new ol.style.Stroke({
          color: 'white',
          width: 0.5
        })
      })
    });

  // Funciones de busqueda 
    // 
    function mun(capa,sal1,sal2,sal3,sal4){
      // ICONO COMO MARCADOR
        var c1 = (parseFloat(sal1)+parseFloat(sal3))/2;
        var c2 = (parseFloat(sal2)+parseFloat(sal4))/2;

        var markerFeature = new ol.Feature({
          geometry: new ol.geom.Point(([c1,c2]))
        });
        markerFeature.setStyle(starStyle);

        var markerLayer = new ol.layer.Vector({
          source: new ol.source.Vector({
            features: [markerFeature]
          })
        });

        map.addLayer(markerLayer);

      // ZOOM AL MAPA 
        // Definir las cuatro coordenadas de la extensión
        var extent = [sal1, sal2, sal3, sal4];

        // Obtener el centro de la extensión
        var center = ol.extent.getCenter(extent);

        // Calcular el nivel de zoom basado en la resolución del mapa en ese nivel
        var zoom = 0;
        var resolution = map.getView().getResolutionForZoom(zoom); 
        if(capa==11){
          console.log("capa 11");  
          zoom = 19;
          resolution = map.getView().getResolutionForZoom(zoom); 
        } else if(capa==3){
          console.log("capa 3");
          zoom = 11;
          resolution = map.getView().getResolutionForZoom(zoom);
        } else if(capa==4){
          zoom = 13;
          resolution = map.getView().getResolutionForZoom(zoom);
        } else if(capa==7){
          zoom = 12;
          resolution = map.getView().getResolutionForZoom(zoom);
        }
        

        // Establecer la vista del mapa en el centro y el nivel de zoom calculados
        map.getView().setCenter(center);
        map.getView().setZoom(zoom);
    }

/* COORDENADAS */ 
  var pull = map.getView().getProjection().getCode();
  console.log(pull);
  
  // CCL 
  var projLambert = new ol.proj.Projection({
    code: 'ESRI:102005',
    extent: [-1483000, 149000, -736000, 2833000],
    units: 'm'
  });

  proj4.defs('EPSG:3857', '+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs');
  proj4.defs('ESRI:102005', '+proj=lcc +lat_1=17.5 +lat_2=29.5 +lat_0=12 +lon_0=-102 +x_0=2500000 +y_0=0 +datum=NAD83 +units=m +no_defs');
  proj4.defs("EPSG:32800", "+proj=tmerc +lat_0=0 +lon_0=-72 +k=0.9996 +x_0=500000 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs");
  proj4.defs("EPSG:9802", "+proj=lcc +lat_1=30 +lat_2=60 +lat_0=0 +lon_0=10 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs");

  // Sexagesimal
  function decimalToSexagesimal(coordinate) {
    var degrees = Math.floor(Math.abs(coordinate));
    var minutes = Math.floor((Math.abs(coordinate) - degrees) * 60);
    var seconds = ((Math.abs(coordinate) - degrees - minutes / 60) * 3600).toFixed(2);
    var direction = coordinate >= 0 ? 'N' : 'W';
    return degrees + '° ' + minutes + '\' ' + seconds + '" ' + direction;
  }

  var cor = document.getElementById('coords');

  map.on('pointermove', function(event) {
    /// Sexagesimal 
    var ll = ol.proj.toLonLat(event.coordinate);
    var lon = decimalToSexagesimal(ll[0]);
    var lat = decimalToSexagesimal(ll[1]);

    /// CCL 
    var coordenadas = event.coordinate;
    var coordenadas102005 = proj4('EPSG:3857', 'ESRI:102005', coordenadas);
    var lonccl = coordenadas102005[0].toFixed(6);
    var latccl = coordenadas102005[1].toFixed(6);

    // Mostrar en el div
    cor.innerHTML = lon + ', ' + lat + '  ' + ' --  CCL(' + lonccl + ', ' + latccl +')';
  });

/* AGREGAR PUNTO */   
  // Validar solo numeros en campos de texto de punto 
  function datonum(event){
    if(event.charCode >= 48 && event.charCode <= 57){
      return true;
    }
    alertmsg("Solo numeros");
    return false;      
    }
  // Obtener la cadena de consulta de la URL
  var queryString = window.location.search;
  // Eliminar el símbolo de interrogación de la cadena de consulta
  var queryParams = queryString.substring(1);
  // Convertir la cadena de parámetros en un objeto
  var paramsObj = {};
  queryParams.split("&").forEach(function(param) {
    var paramKeyValue = param.split("=");
    paramsObj[paramKeyValue[0]] = decodeURIComponent(paramKeyValue[1]);
  });

  // Obtener los valores de los parámetros
  var lon = paramsObj.longitud; 
  var lat = paramsObj.latitud; 

  var zoomp = 0;
  var resolutionp = map.getView().getResolutionForZoom(zoomp); 

  if(lon != undefined && lat != undefined)
  {
    if (lon.length==0 || lat.length==0){
      setTimeout(function() {
        window.location.href = 'http://localhost:8070/mapas/index.jsp#map=5.00/-11416123.69/2708933.29/0';
      }, 3000);
      alertmsg ("Proporcione coordenadas");
    }
    var element = document.getElementById('output');
    if((Math.abs(lat)>13 && Math.abs(lat)<34) || (Math.abs(lon)>84 && Math.abs(lon)<120)){
      element.innerHTML = 'DEC';
      lat_dec = parseFloat(lat);
      lon_dec = parseFloat(lon);
      if(lon_dec>0){
        lon_dec = lon_dec*-1;
      }
    } else if((Math.abs(lat)>140000 && Math.abs(lat)<330000 && Math.abs(lon)>860000 && Math.abs(lon)<1190000)){
      element.innerHTML = 'GEO';
      lon = lon.replace("-","");
      var lat_dec = parseFloat(lat.substr(0,2),10)+parseInt(lat.substr(2,2),10)/60+parseFloat(lat.substr(4, lat.length),10)/3600;
      var lon_dec = (parseInt(lon.substr(0,3),10)+parseInt(lon.substr(3,2),10)/60+parseFloat(lon.substr(5, lon.length),10)/3600)*(-1);
      //console.log(lon_dec + " " + lat_dec);
    } else {
      element.innerHTML = 'CCL';
      lat_dec = parseFloat(lat);
      lon_dec = parseFloat(lon);
      coordenadasCCL = [lon_dec, lat_dec];
      var coordenadasTransformadas = proj4('ESRI:102005', "EPSG:4326", coordenadasCCL);
      lon_dec = coordenadasTransformadas[0];
      lat_dec = coordenadasTransformadas[1];
    }
    if(parseInt(Math.abs(lat_dec),10)>parseInt(33,10) || parseInt(Math.abs(lat_dec),10)<parseInt(13,10))
    {
      alertmsg("Latitud fuera de rango"); 
    } else {
      if (parseInt(Math.abs(lon_dec),10)>parseInt(120,10) || parseInt(Math.abs(lon_dec),10)<parseInt(84,10)){
        alertmsg ("Longitud fuera de rango");
      }
    }

    // Estrella como marcador en el punto 
      var starStyle = new ol.style.Style({
        image: new ol.style.RegularShape({
          fill: new ol.style.Fill({
            color: '#2196F3'
          }),
          points: 5,
          radius: 10,
          radius2: 4,
          stroke: new ol.style.Stroke({
            color: 'white',
            width: 0.5
          })
        })
      });

      var geometry1 = new ol.geom.Point(ol.proj.fromLonLat([lon_dec, lat_dec]));

      var markerFeature = new ol.Feature({
        //ol.proj.fromLonLat([lon, lat])
        geometry: geometry1
      });
      markerFeature.setStyle(starStyle);

      var markerLayer = new ol.layer.Vector({
        name: 'punto',
        source: new ol.source.Vector({
          features: [markerFeature]
        })
      });

      map.addLayer(markerLayer);
      
      var viewP = new ol.View({
        center: ol.proj.fromLonLat([lon_dec, lat_dec]),
        zoom: 12
      });
      map.setView(viewP);
  }

/* ELIMINAR PUNTO */ 
  function deletePunto(){
    var lastLayerName = map.getLayers().item(map.getLayers().getLength() - 1).get('name');
    console.log(lastLayerName);
    setTimeout(function() {
      window.location.href = 'http://localhost:8070/mapas/index.jsp#map=5.00/-11416123.69/2708933.29/0';
    }, 1);
    document.getElementById('msjs').style.display = 'none';
  }


/*
var cclProjection = new ol.proj.Projection({
    code: 'EPSG:2154',
    extent: [-13459673.0276619,1232095.46159631,-9281930.46183394,4109451.87806631],
    units: 'm'
  });
  ol.proj.addProjection(cclProjection);
  console.log(cclProjection);
*/


/*CODIGO QUE NO SIRVE 
  
  // Register a click event on the map
  map.on('click', function(evt) {
    // Get the clicked coordinate
    var coordinate = evt.coordinate;

    // Get the WMS source for the mxestados layer
    var source = mxestados.getSource();

    // Construct a WMS GetFeatureInfo request URL for the clicked coordinate
    var viewResolution = map.getView().getResolution();
    var url = source.getFeatureInfoUrl(
      coordinate,
      viewResolution,
      'EPSG:3857',
      {'INFO_FORMAT': 'application/json'}
    );

    // Send an AJAX request to the WMS server to retrieve the feature information
    $.ajax({
      url: url,
      dataType: 'json',
      success: function(response) {
        // Process the JSON response to get information about the clicked feature
        var features = response.features;
        if (features.length > 0) {
          var feature = features[0];
          // Get information about the feature, such as its name and attributes
          var name = feature.properties.nom_ent;
          var attributes = feature.properties;
          // Do something with the information, such as show it in a popup
          showPopup(name, attributes, coordinate);
          console.log(name);
        }
      }
    });
  });
*/