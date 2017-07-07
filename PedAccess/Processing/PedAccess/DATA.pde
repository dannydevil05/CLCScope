// Data Extents Parameters

    // Display Matrix Size (cells rendered to screen)
    int inputUMax = 18;
    int inputVMax = 22;
    int IDMax = 15;
    int legoPerPiece = 4;
    int displayV = inputVMax*legoPerPiece; // Height of Lego Table
    int displayU = inputUMax*legoPerPiece; // Width of Lego Table
    int gridPanV, gridPanU; // Integers that describe how much to offset grid pixels when drawing
    int scaler, gridU, gridV;
    
    // Demand Parameters
    int WEEKS_IN_YEAR = 52;
    int DAYS_IN_YEAR = 365;
    float WALMART_MARKET_SHARE = 0.02; // 2.0%
    float HOUSEHOLD_SIZE = 2.54;
    
    float dailyDemand(float pop) {
      if (popMode.equals("POP10")) {
        return pop/HOUSEHOLD_SIZE*WEEKS_IN_YEAR*WALMART_MARKET_SHARE/DAYS_IN_YEAR;
      } else if (popMode.equals("HOUSING10")) {
        return pop*WEEKS_IN_YEAR*WALMART_MARKET_SHARE/DAYS_IN_YEAR;
      } else {
        println("no conversion for daily demand for this input");
        return 0;
      }
    }

    
    void resetGridParameters() {
      scaler = int(MAX_GRID_SIZE/gridSize);
      // Total Matrix Size (includes cells beyond extents of screen)
      gridV = displayV*scaler; // Height of Lego Table
      gridU = displayU*scaler; // Width of Lego Table
      // Integers that describe how much to offset grid pixels when drawing
      gridPanV = (gridV-displayV)/2;
      gridPanU = (gridU-displayU)/2;
      resetMousePan();
    }

// Raster Basemap Data based on Google Maps
    
    // Raster Basemap Objects
    PImage wholeMap, basemap;
    String mapColor = "bw";
    
    // Loads one giant map object
    void initializeBaseMap() {
      wholeMap = loadImage("data/" + mapColor + "/" + fileName + ".png");
    }
    
    // Pedestrian Network Rasters
    PImage[] networkRaster;
    void importNetworkRaster() {
      /* 0 = Vehicle Road Network
       * 1 = Surface Level Pedestrian Pathways
       * 2 = Surface Level Pedestrian Street Crossing
       * 3 = Covered Linkway Redestrian Pathway
       * 4 = Ground-Bridge-Ground Street Crossing
       * 5 = 2nd Level Pedestrian Causeway
       */
      networkRaster = new PImage[6];
//      networkRaster[0] = loadImage("data/ped_network/network_roads.png");
//      networkRaster[1] = loadImage("data/ped_network/network_groundped.png");
//      networkRaster[2] = loadImage("data/ped_network/network_crossingped.png");
//      networkRaster[3] = loadImage("data/ped_network/network_linkway.png");
//      networkRaster[4] = loadImage("data/ped_network/network_bridgeped.png");
//      networkRaster[5] = loadImage("data/ped_network/network_2ndped.png");
      
      // Crop network raster to 1/2 area
    }
    
    // Loads subset of wholemap onto basemap
    void loadBasemap() {
      float w = (float)wholeMap.width/gridU;
      float h = (float)wholeMap.height/gridV;
      basemap = wholeMap.get(int(gridPanU*w), int(gridPanV*h), int(displayU*w), int(displayV*h));
      basemap.resize(table.width, table.height);
      loadMiniBaseMap();
    }
    
// Methods for reloading data when changing zoom level, area of analysis, etc
    
    // Set this to false if you know that you don't need to regenerate data every time Software is run
    boolean pixelizeData = true;

    void reloadData(int gridU, int gridV, int index) {
      // determines which dataset to Load
      switch(index) {
        case 0:
          denverMode();
          break;
        case 1:
          sanjoseMode();
          break;
        case 2:
          singaporeMode();
          break;
        case 3:
          wiaMode();
          break;
      }
      
      // Processes lat-long data and saves to aggregated JSON grid
      if (pixelizeData) {
        pixelizeData(this.gridU, this.gridV);
      }
      
      // Loads extents of static data
      initStaticData();
      
      // Loads extents of Input data
      initInputData(); 
      
      // Loads extents of Output data
      initOutputData(); 
      clearOutputData();
      println("faux data loaded");
      
      // Initializes Basemap file
      initializeBaseMap();
      
      // Initialize PEdestrian Netowrk Rasters
      //importNetworkRaster();
      
      // Loads Basemap from subset of file
      loadBasemap();
    }

// Pre-loaded Static Data (geospatial delivery counts, population, etc)

    // 2D matrix that holds grid values
    float heatmap[][], stores[][], pop[][], hu[][];
    // variables to hol minimum and maximum grid values in matrixƒ
    float heatmapMIN, heatmapMAX;
    float storesMIN, storesMAX;
    float popMIN, popMAX;
    float huMIN, huMAX;
    float popTotal;
    
    //JSON array holding totes
    JSONArray array;
    
    //Table holding Population Counts and Housing Units (created from GridResampler)
    Table popCSV, huCSV;
    
    // Runs once when initializes
    void initStaticData() {
      
      array = loadJSONArray("data/" + fileName + "_" + valueMode + ".json");
      try {
        popCSV = loadTable("data/CSV_POPHU/" + fileName + "_" + popMode + "_" + gridV + "_" + gridU + "_" + int(gridSize*1000) + ".csv");
      }  catch(RuntimeException e) {
        popCSV = new Table();
        println("Loading File at scale " + gridSize + " failed.");
      }
      
      heatmap = new float[gridU][gridV];
      stores = new float[gridU][gridV];
      pop = new float[gridU][gridV];
      for (int u=0; u<gridU; u++) {
        for (int v=0; v<gridV; v++) {
          heatmap[u][v] = 0;
          stores[u][v] = 0;
          pop[u][v] = 0;
        }
      }
      
      popTotal = 0;
      
      // MIN and MAX set to arbitrarily large and small values
      heatmapMIN = Float.POSITIVE_INFINITY;
      heatmapMAX = Float.NEGATIVE_INFINITY;
      
      // MIN and MAX set to arbitrarily large and small values
      storesMIN = Float.POSITIVE_INFINITY;
      storesMAX = Float.NEGATIVE_INFINITY;
      
      // MIN and MAX set to arbitrarily large and small values
      popMIN = Float.POSITIVE_INFINITY;
      popMAX = Float.NEGATIVE_INFINITY;
      
      JSONObject temp = new JSONObject();
      for (int i=0; i<array.size(); i++) {
        try {
          temp = array.getJSONObject(i);
        } catch(RuntimeException e) {
        }
        heatmap[temp.getInt("u")][temp.getInt("v")] = temp.getInt(valueMode);
        stores[temp.getInt("u")][temp.getInt("v")] = temp.getInt("store");
      }
      
      for (int i=0; i<popCSV.getRowCount(); i++) {
        for (int j=0; j<popCSV.getColumnCount(); j++) {
          pop[j][i] = popCSV.getFloat(popCSV.getRowCount()-1-i, j);
          popTotal += pop[j][i];
        }
      }
        
      
      for (int u=0; u<gridU; u++) {
        for (int v=0; v<gridV; v++) {
          
          // each cell in the heatmap randomly assigned a vlue between 0 and 178
          // This is a placeholder that should eventually hold real data (i.e. number of totes)
          //heatmap[u][v] = random(0, 178);
          
          if (heatmap[u][v] != 0) { // 0 is usually void, so including it will skew our color gradient
            heatmapMIN = min(heatmapMIN, heatmap[u][v]);
            heatmapMAX = max(heatmapMAX, heatmap[u][v]);
          }
            
          storesMIN = min(storesMIN, stores[u][v]);
          storesMAX = max(storesMAX, stores[u][v]);
          
          if (pop[u][v] != 0) { // 0 is usually void, so including it will skew our color gradient
            popMIN = min(popMIN, pop[u][v]);
            popMAX = max(popMAX, pop[u][v]);
          }
        }
      }
      
    //  // Prints largest and smallest values to console
    //  println("Maximum Value: " + heatmapMAX);
    //  println("Minimum Value: " + heatmapMIN);
      
    }
    
// Initialize Input Data (store locations, lockers, etc)
    
    // Input Matrices
    int[][] facilities, market, obstacles, form;
    
    // Runs once when initializes
    void initInputData() {
      facilities = new int[gridU][gridV];
      market = new int[gridU][gridV];
      obstacles = new int[gridU][gridV];
      form = new int[gridU][gridV];
      for (int u=0; u<gridU; u++) {
        for (int v=0; v<gridV; v++) {
          facilities[u][v] = 0;
          market[u][v] = 0;
          obstacles[u][v] = 0;
          form[u][v] = 0;
        }
      }
    }
    
// Initialize Output Data (Cost, Allocations, etc)

    // Output Matrices
    float[][] totalCost, deliveryCost;
    int[][] allocation, vehicle;
    boolean[][] cellAllocated;
    
    // minMax Values:
    float totalCostMIN, totalCostMAX;
    float deliveryCostMIN, deliveryCostMAX;
    float allocationMIN, allocationMAX;
    float vehicleMIN, vehicleMAX;
    
    // Runs once when initializes
    void initOutputData() {
      totalCost = new float[gridU][gridV];
      deliveryCost = new float[gridU][gridV];
      allocation = new int[gridU][gridV];
      cellAllocated = new boolean[gridU][gridV];
      vehicle = new int[gridU][gridV];
      for (int u=0; u<gridU; u++) {
        for (int v=0; v<gridV; v++) {
          totalCost[u][v] = 0;
          deliveryCost[u][v] = 0;
          allocation[u][v] = 0;
          cellAllocated[u][v] = false;
          vehicle[u][v] = 0;
        }
      }
    }
    
    void fauxOutputData() {
      fauxFloatData(totalCost, 100);
      fauxFloatData(deliveryCost, 100);
      fauxIntData(allocation, 7);
      fauxIntData(vehicle, 7);
    }
    
    void clearOutputData() {
      clearFloatData(totalCost, 0);
      clearFloatData(deliveryCost, Float.POSITIVE_INFINITY);
      clearIntData(allocation, 0);
      clearIntData(vehicle, 0);
      clearBooleanData(cellAllocated, false);
    }
    
    // Create Faux Data Set for Debugging
    void fauxIntData(int[][] data, int maxInput) {
      for (int i=0; i<data.length; i++) {
        for (int j=0; j<data[0].length; j++) {
          data[i][j] = int(random(-0.99, maxInput));
        }
      }
    }
    
    // Create Faux Data Set for Debugging
    void fauxFloatData(float[][] data, int maxInput) {
      for (int i=0; i<data.length; i++) {
        for (int j=0; j<data[0].length; j++) {
          data[i][j] = random(0, maxInput);
        }
      }
    }
    
    void clearIntData(int[][] data, int clearValue) {
      for (int i=0; i<data.length; i++) {
        for (int j=0; j<data[0].length; j++) {
          data[i][j] = clearValue;
        }
      }
    }
    
    void clearFloatData(float[][] data, float clearValue) {
      for (int i=0; i<data.length; i++) {
        for (int j=0; j<data[0].length; j++) {
          data[i][j] = clearValue;
        }
      }
    }
    
    void clearBooleanData(boolean[][] data, boolean clearValue) {
      for (int i=0; i<data.length; i++) {
        for (int j=0; j<data[0].length; j++) {
          data[i][j] = clearValue;
        }
      }
    }
    
// Initialize Pedestrian Network Data
    
    JSONArray pedNetwork;
    void importPedNetwork() {
      if (gridSize == 0.005) pedNetwork = loadJSONArray("data/nodes5_meters_576_by_704.json");
      else if (gridSize == 0.01) pedNetwork = loadJSONArray("data/nodes15_meters_144_by_176.json");
      else if (gridSize == 0.02) pedNetwork = loadJSONArray("data/nodes20_meters_144_by_176.json");
      println("Number of nodes: " + pedNetwork.size());
    }

// Initialize Ammenity and Bus Stop Data
    
    JSONArray amenity = new JSONArray();
    JSONArray transit = new JSONArray();
    void importPointsOfInterest(){
      amenity = loadJSONArray("data/ammenities_" + int(gridSize*1000) + "m.json");
      transit = loadJSONArray("data/transitStops_" + int(gridSize*1000) + "m.json");
      println("Imported Ammenities: " + amenity.size());
      println("Imported Transit Stops: " + transit.size());
    }
    
// Method that opens a folder
String folderPath;
void folderSelected(File selection) {
  if (selection == null) { // Notifies console and closes program
    println("User did not select a folder");
    exit();
  } else { // intitates the rest of the software
    println("User selected " + selection.getAbsolutePath());
    folderPath = selection.getAbsolutePath() + "/";
    // some other startup function
  }
}
