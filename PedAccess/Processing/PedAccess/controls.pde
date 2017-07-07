// click-based menu buttons are deactivated for "PedAccess" Singapore demo to increase framerate ... To re-activate:
// 1. Set boolean implementMenu to true

String layerSelected = "pixelizer";
// Options:
// "agents"
// "pixelizer"

// Define the ORDER of the buttons by changing this array
// May only be a subset of buttonNames[]
// May include "VOID" if you which to leave a gap between menu buttons
String[] menuOrder =
{
  "Next City (n)",
  "Randomize Pieces (z)",
  "VOID",
  "Zoom 3 (3)",
  "Zoom 2 (2)",
  "Zoom 1 (1)",
  "Recenter Grid (R)",
  "VOID",
  "Show Input Data (I)",
  "Piece Forms (F)",
  "Piece Data (A)",
  "VOID",
  "Show Output Data (O)",
  "Delivery Cost (C)",
  "Total Cost (T)",
  "Facility Allocation (L)",
  "Vehicle Allocation (v)",
  "VOID",
  "2015 Store Locations (s)",
  "2015 Delivery Data (D)",
  "Delivery Counts (d)",
  "Tote Counts (t)",
  "Store Source (o)",
  "Avg Doorstep Time (a)",
  "VOID",
  "Show Population Data (P)",
  "Population Counts (u)",
  "Household Counts (e)",
  "VOID",
  "Show Basemap (m)",
  "Invert Colors (i)",
  "Show Framerate (f)",
  "Enable Projection (`)",
  "Print Screenshot (p)"
};

// Define how many button of which type in this array
// DO NOT CHANGE THE ORDER OF THESE NAMES!
String[] buttonNames =
{
  "Next City (n)",           // 0
  "Print Screenshot (p)",    // 1
  "Delivery Counts (d)",     // 2
  "Tote Counts (t)",         // 3
  "Store Source (o)",        // 4
  "Avg Doorstep Time (a)",   // 5
  "2015 Store Locations (s)",// 6
  "Align Left (l)",          // 7
  "Align Right (r)",         // 8
  "Align Center (c)",        // 9
  "Invert Colors (i)",       // 10
  "Zoom 3 (3)",       // 11
  "Zoom 2 (2)",       // 12
  "Zoom 1 (1)",      // 13
  "Show Basemap (m)",        // 14
  "Show Framerate (f)",      // 15
  "2015 Delivery Data (D)",  // 16
  "Show Population Data (P)",// 17
  "Population Counts (u)",   // 18
  "Household Counts (e)",    // 19
  "Recenter Grid (R)",       // 20
  "Enable Projection (`)",   // 21
  "Randomize Pieces (z)",    // 22
  "Show Input Data (I)",     // 23
  "Piece Forms (F)",         // 24
  "Piece Data (A)",          // 25
  "Show Output Data (O)",    // 26
  "Delivery Cost (C)",       // 27
  "Total Cost (T)",          // 28
  "Facility Allocation (L)", // 29
  "Vehicle Allocation (v)"   // 30

};

int getButtonIndex(String name) {
  for(int i=0; i<menuOrder.length; i++) {
    if (menuOrder[i].equals(name)) {
      return i;
    }
  }
  return 2;
}

// These Strings are for the hideMenu, formatted as arrays for Menu Class Constructor
String[] hide = {"Hide Main Menu (h)"};
String[] show = {"Show Main Menu (h)"};

// creates all the menu objects
void loadMenu(int screenWidth, int screenHeight) {
  if (implementMenu) {
    
    // Initializes Menu Items (screenWidth, screenHeight, button width[pix], button height[pix],
    // number of buttons to offset downward, String[] names of buttons)
    hideMenu = new Menu(screenWidth, screenHeight, 170, 20, 0, hide, align);
    mainMenu = new Menu(screenWidth, screenHeight, 170, 20, 2, menuOrder, align);
    // Selects one of the mutually exclusive heatmps
    depressHeatmapButtons();
    // Selects one of the mutually exclusive population maps
    depressPopulationButtons();
    // Selects one of the mutually exclusive pixel scales
    depressZoomButtons(gridSize);
    // Selects one of the mutually exclusive Input Data Types
    depressInputButtons();
    // Selects one of the mutually exclusive Output Data Types
    depressOutputButtons();
    // Checks whether these true/false button should be pressed
    pressButton(showStores, getButtonIndex(buttonNames[6]));
    pressButton(showBasemap, getButtonIndex(buttonNames[14]));
    pressButton(showFrameRate, getButtonIndex(buttonNames[15]));
    pressButton(showDeliveryData, getButtonIndex(buttonNames[16]));
    pressButton(showPopulationData, getButtonIndex(buttonNames[17]));
    pressButton(displayProjection2D, getButtonIndex(buttonNames[21]));
  
    if (!showPopulationData) {
      for (int i=18; i<=19; i++) {
        mainMenu.buttons[getButtonIndex(buttonNames[i])].show = false;
      }
    } else {
      for (int i=18; i<=19; i++) {
        mainMenu.buttons[getButtonIndex(buttonNames[i])].show = true;
      }
    }
  
    if (!showDeliveryData) {
      for (int i=2; i<=5; i++) {
        mainMenu.buttons[getButtonIndex(buttonNames[i])].show = false;
      }
    } else {
      for (int i=2; i<=5; i++) {
        mainMenu.buttons[getButtonIndex(buttonNames[i])].show = true;
      }
    }
  
    if (!showInputData) {
      for (int i=24; i<=25; i++) {
        mainMenu.buttons[getButtonIndex(buttonNames[i])].show = false;
      }
    } else {
      for (int i=24; i<=25; i++) {
        mainMenu.buttons[getButtonIndex(buttonNames[i])].show = true;
      }
    }
  
    if (!showOutputData) {
      for (int i=27; i<=30; i++) {
        mainMenu.buttons[getButtonIndex(buttonNames[i])].show = false;
      }
    } else {
      for (int i=27; i<=30; i++) {
        mainMenu.buttons[getButtonIndex(buttonNames[i])].show = true;
      }
    }
  
    mainMenu.buttons[getButtonIndex(buttonNames[0])].isPressed = true;
    mainMenu.buttons[getButtonIndex(buttonNames[1])].isPressed = true;
    mainMenu.buttons[getButtonIndex(buttonNames[10])].isPressed = true;
    mainMenu.buttons[getButtonIndex(buttonNames[20])].isPressed = true;
    mainMenu.buttons[getButtonIndex(buttonNames[22])].isPressed = true;
    
  }
}

// The result of each button click is defined here
void mouseClicked() {

  if (!buttonHovering) {
    selectionU = mouseToU();
    selectionV = mouseToV();
//    println(facilities[selectionU][selectionV]);
//    facilities[selectionU][selectionV] = 1;
//    println("facility set at " + selectionU, selectionV + " to " + facilities[selectionU][selectionV]);
  }

  if (implementMenu) {

    //Hide/Show Menu
    if(hideMenu.buttons[0].over()){
      toggleMainMenu();
    }
  
    // Main Menu Functions:
  
    //function0
    if(mainMenu.buttons[getButtonIndex(buttonNames[0])].over()){
      nextModeIndex();
    }
  
    //function1
    if(mainMenu.buttons[getButtonIndex(buttonNames[1])].over()){
      printScreen();
    }
  
    //function2
    if(mainMenu.buttons[getButtonIndex(buttonNames[2])].over()){
      setDeliveries(getButtonIndex(buttonNames[2]));
    }
  
    //function3
    if(mainMenu.buttons[getButtonIndex(buttonNames[3])].over()){
      setTotes(getButtonIndex(buttonNames[3]));
    }
  
    //function4
    if(mainMenu.buttons[getButtonIndex(buttonNames[4])].over()){
      setSource(getButtonIndex(buttonNames[4]));
    }
  
    //function5
    if(mainMenu.buttons[getButtonIndex(buttonNames[5])].over()){
      setDoorstep(getButtonIndex(buttonNames[5]));
    }
  
    //function6
    if(mainMenu.buttons[getButtonIndex(buttonNames[6])].over()){
      setStores(getButtonIndex(buttonNames[6]));
    }
  
  //    //function7
  //    if(mainMenu.buttons[getButtonIndex(buttonNames[7])].over()){
  //      alignLeft();
  //    }
  //
  //    //function8
  //    if(mainMenu.buttons[getButtonIndex(buttonNames[8])].over()){
  //      alignRight();
  //    }
  //
  //    //function9
  //    if(mainMenu.buttons[getButtonIndex(buttonNames[9])].over()){
  //      alignCenter();
  //    }
  
    //function10
    if(mainMenu.buttons[getButtonIndex(buttonNames[10])].over()){
      invertColors();
    }
  
    //function11
    if(mainMenu.buttons[getButtonIndex(buttonNames[11])].over()){
      setGridSize(MAX_GRID_SIZE);
    }
  
    //function12
    if(mainMenu.buttons[getButtonIndex(buttonNames[12])].over()){
      setGridSize(MAX_GRID_SIZE/2);
    }
  
    //function13
    if(mainMenu.buttons[getButtonIndex(buttonNames[13])].over()){
      setGridSize(MAX_GRID_SIZE/4);
    }
  
    //function14
    if(mainMenu.buttons[getButtonIndex(buttonNames[14])].over()){
      toggleBaseMap(getButtonIndex(buttonNames[14]));
    }
  
    //function15
    if(mainMenu.buttons[getButtonIndex(buttonNames[15])].over()){
      toggleFramerate(getButtonIndex(buttonNames[15]));
    }
  
    //function16
    if(mainMenu.buttons[getButtonIndex(buttonNames[16])].over()){
      toggleDeliveryData(getButtonIndex(buttonNames[16]));
    }
  
    //function17
    if(mainMenu.buttons[getButtonIndex(buttonNames[17])].over()){
      togglePopulationData(getButtonIndex(buttonNames[17]));
    }
  
    //function18
    if(mainMenu.buttons[getButtonIndex(buttonNames[18])].over()){
      setPop(getButtonIndex(buttonNames[18]));
    }
  
    //function19
    if(mainMenu.buttons[getButtonIndex(buttonNames[19])].over()){
      setHousing(getButtonIndex(buttonNames[19]));
    }
  
    //function20
    if(mainMenu.buttons[getButtonIndex(buttonNames[20])].over()){
      resetGridParameters();
    }
  
    //function21
    if(mainMenu.buttons[getButtonIndex(buttonNames[21])].over()){
      toggleProjection(21);
    }
  
    //function22
    if(mainMenu.buttons[getButtonIndex(buttonNames[22])].over()){
      toggleRandomPieces();
    }
  
    //function23
    if(mainMenu.buttons[getButtonIndex(buttonNames[23])].over()){
      toggleInputData(getButtonIndex(buttonNames[23]));
    }
  
    //function24
    if(mainMenu.buttons[getButtonIndex(buttonNames[24])].over()){
      setPieceForm();
    }
  
    //function25
    if(mainMenu.buttons[getButtonIndex(buttonNames[25])].over()){
      setPieceData();
    }
  
    //function26
    if(mainMenu.buttons[getButtonIndex(buttonNames[26])].over()){
      toggleOutputData(getButtonIndex(buttonNames[26]));
    }
  
    //function27
    if(mainMenu.buttons[getButtonIndex(buttonNames[27])].over()){
      setDeliveryCost();
    }
  
    //function28
    if(mainMenu.buttons[getButtonIndex(buttonNames[28])].over()){
      setTotalCost();
    }
  
    //function29
    if(mainMenu.buttons[getButtonIndex(buttonNames[29])].over()){
      setAllocation();
    }
  
    //function30
    if(mainMenu.buttons[getButtonIndex(buttonNames[30])].over()){
      setVehicle();
    }
  
    reRender();
  
  }
}

void keyPressed() {
  
  boolean switched = false;
  boolean projectorMoved = false;
  
  switch (key) {
    case 'x':
      if (layerSelected.equals("agents")) layerSelected = "pixelizer";
      else if (layerSelected.equals("pixelizer")) layerSelected = "agents";
      break;
  }
  
  if (layerSelected.equals("agents")) {
    switch (key) {
      case '0': //ReBoots App
        setLoader("Agent Demo| Version " + version);
        // runs key_0() next frame
        break;
      case 'o': //show obstacle outlines
        showObstacles = toggle(showObstacles);
        break;
      case 'k': //show sources and sinks for agents
        showSource = toggle(showSource);
        break;
      case 'r': //reset agents and simulation
        setLoader("New Agents");
        // runs key_r() next frame
        break;
      case 'f': //print framerate to console
        showFrameRate = toggle(showFrameRate);
        break;
      case 'S': //toggles display of swarms of agents
        showSwarm = toggle(showSwarm);
        break;
      case 'e': //shows network edges of motion
        showEdges = toggle(showEdges);
        break;
      case 'i': //shows info about swarms like weight and agent numbers
        showInfo = toggle(showInfo);
        break;
      case 'p': //makes a grid of obstacles
        setLoader("Gridded Obstacles");
        // runs key_p() next frame
        break;
      case 'F': //toggles frameStep
        frameStep = toggle(frameStep);
        println("FrameStep = " + frameStep);
        break;
      case '+': //speed it up
        updateSpeed(1);
        break;
      case '-': //slow it down
        updateSpeed(-1);
        break;
      case 'l': //loads course
        if (editObstacles) {
          boundaries.loadCourse("data/course.tsv");
        }
        break;
      case 's'://save course
        if (editObstacles) {
          boundaries.saveCourse("data/course.tsv");
        }
        break;
      case 'E': // shows or hides obsticale editor 
        setLoader("Obstacles Editor");
        // runs key_E() next frame
        break;
      case '': //hit the delete key 
        if (editObstacles) {
          boundaries.removeVertex();
        }
        break;
      case 'A': //lets you add obstcles
        if (editObstacles) {
          boundaries.addObstacle();
        }
        break;
      case 'R': //lets you remove obstacles 
        if (editObstacles) {
          boundaries.removeObstacle();
        }
        break;
      case ' ': //switch between the two obstacles to edit them 
        if (editObstacles) {
          boundaries.nextIndex();
        }
        break;
      case 'N': //hops to next vertice 
        if (editObstacles) {
          boundaries.nextVert();
        }
        break;
      case 'V': //starts printing frames to file
        printFrames = toggle(printFrames);
        break;
      case 'b': //toggle background between black and white
        background = toggleBW(background);
        textColor = toggleBW(textColor);
        grayColor = int(abs(background - (255.0/2)*schemeScaler));
        pFinderGrid_Viz(tableCanvas);
        break;
      case 'P': //toggle display of shortest paths
        showPaths = toggle(showPaths);
        break;
      case 'G': //toggle display for pathing grip
        showGrid = toggle(showGrid);
        break;
      case 'X': 
        setLoader("New Origin-Destination Pair");
        // runs key_X() next frame
        break;
      case 'n': // randomize/reset current network for pathfinding
        setLoader("New Pathfinder Network");
        // runs key_n() next frame
        break;
      case '>': // Toggle network for pathfinding
        setLoader("Pathfinder Mode " + nextMode(finderMode, 3));
        // runs key_RightCarrot() next frame
        break;
      case '<': // Enable/Disable Pathfinding
        setLoader("Pathfinder: " + toggle(enablePathfinding));
        // runs key_LeftCarrot() next frame
        break;
      case '{': // Decrease Alpha
        adjustAlpha(-10);
        pFinderGrid_Viz(tableCanvas);
        grayColor = int(abs(background - (255.0/2)*schemeScaler));
        println("schemeScaler: " + schemeScaler);
        println("masterAlpha: " + masterAlpha);
        break;
      case '}': // Increase Alpha
        adjustAlpha(+10);
        pFinderGrid_Viz(tableCanvas);
        grayColor = int(abs(background - (255.0/2)*schemeScaler));
        println("schemeScaler: " + schemeScaler);
        println("masterAlpha: " + masterAlpha);
        break;
      case 'T': // Turns demo background image on or off
        showDemoMap = toggle(showDemoMap);
        break;
    }
    
    //------arrow keys and how to code keys that aren't characters exactly----- 
    if (key == CODED) { 
      if (keyCode == LEFT) {
        if (editObstacles) {
          boundaries.nudgeVertex(-1, 0);
        }
      }  
      if (keyCode == RIGHT) {
        if (editObstacles) {
          boundaries.nudgeVertex(+1, 0);
        }
      }  
      if (keyCode == DOWN) {
        if (editObstacles) {
          boundaries.nudgeVertex(0, +1);
        }
      }  
      if (keyCode == UP) {
        if (editObstacles) {
          boundaries.nudgeVertex(0, -1);
        }
      }
    }
  } else if(layerSelected.equals("pixelizer")) {
  
    switch(key) {
      case 'h': // "Hide Main Menu (h)"     // 0
        toggleMainMenu();
        switched = true;
        break;
  
      case 'n': // "Next City (n)"          // 0
        nextModeIndex();
        switched = true;
        break;
      case 'p': // "Print Screenshot (p)"   // 1
        printScreen();
        switched = true;
        break;
  
      case 'l': // "Align Left (l)",        // 7
        alignLeft();
        switched = true;
        break;
//      case 'r': // "Align Right (r)"        // 8
//        alignRight();
//        switched = true;
//        break;
  //    case 'c': // "Align Center (c)"       // 9
  //      alignCenter();
  //      break;
      case 'i': // "Invert Colors (i)"      // 10
        invertColors();
        switched = true;
        break;
  
      case '3': // "2km per pixel",         // 11
        setGridSize(MAX_GRID_SIZE);
        switched = true;
        break;
      case '2': // "1km per pixel",         // 12
        setGridSize(MAX_GRID_SIZE/2);
        switched = true;
        break;
      case '1': // "500m per pixel",        // 13
        setGridSize(MAX_GRID_SIZE/4);
        switched = true;
        break;
  
      case 'R': //  "Recenter Grid (R)",      // 20
        resetGridParameters();
        switched = true;
        break;
      case 'z': //  "Randomize Pieces (z)"    // 22
        toggleRandomPieces();
        switched = true;
        break;
      case 'F': //  "Piece Forms (F)",        // 24
        setPieceForm();
        switched = true;
        break;
      case 'A': //  "Piece Data (A)"          // 25
        setPieceData();
        switched = true;
        break;
      case 'C': //  "Delivery Cost (C)",          // 27
        setDeliveryCost();
        switched = true;
        break;
      case 'T': //  "Total Cost (T)"              // 28
        setTotalCost();
        switched = true;
        break;
      case 'L': //  "Facility Allocation (L)",    // 29
        setAllocation();
        switched = true;
        break;
      case 'v': //  "Vehicle Allocation (v)"      // 30
        setVehicle();
        switched = true;
        break;
  
      // No Buttons
      case ' ': // Send data to CTL
        enableCTL = !enableCTL;
        waitingForCTL = false;
        switched = true;
        break;
      case '-':
        projH--;
        saveProjectorLocation();
        projectorMoved = true;
        break;
      case '+':
        projH++;
        saveProjectorLocation();
        projectorMoved = true;
        break;
      case 'k': //show sources and sinks for agents
        showSource = toggle(showSource);
        break;
      case 'r': //reset agents and simulation
        setLoader("New Agents");
        // runs key_r() next frame
        break;
      case 'f': //print framerate to console
        showFrameRate = toggle(showFrameRate);
        break;
      case 'S': //toggles display of swarms of agents
        showSwarm = toggle(showSwarm);
        break;
      case 'e': //shows network edges of motion
        showEdges = toggle(showEdges);
        break;
      case 'b': //toggle background between black and white
        background = toggleBW(background);
        textColor = toggleBW(textColor);
        grayColor = int(abs(background - (255.0/2)*schemeScaler));
        pFinderGrid_Viz(tableCanvas);
        break;
      case 'P': //toggle display of shortest paths
        showPaths = toggle(showPaths);
        break;
      case 'G': //toggle display for pathing grip
        showGrid = toggle(showGrid);
        break;
      case '>': // Toggle network for pathfinding
        setLoader("Pathfinder Mode " + nextMode(finderMode, 3));
        // runs key_RightCarrot() next frame
        break;
      case '<': // Enable/Disable Pathfinding
        setLoader("Pathfinder: " + toggle(enablePathfinding));
        // runs key_LeftCarrot() next frame
        break;
      case '{': // Decrease Alpha
        adjustAlpha(-10);
        pFinderGrid_Viz(tableCanvas);
        grayColor = int(abs(background - (255.0/2)*schemeScaler));
        println("schemeScaler: " + schemeScaler);
        println("masterAlpha: " + masterAlpha);
        break;
      case '}': // Increase Alpha
        adjustAlpha(+10);
        pFinderGrid_Viz(tableCanvas);
        grayColor = int(abs(background - (255.0/2)*schemeScaler));
        println("schemeScaler: " + schemeScaler);
        println("masterAlpha: " + masterAlpha);
        break;
    }
    
    if(implementMenu) {
      switch (key){
        case 'O': //  "Show Output Data (O)"    // 26
          toggleOutputData(getButtonIndex(buttonNames[26]));
          switched = true;
          break;
        case 'I': //  "Show Input Data (I)",    // 23
          toggleInputData(getButtonIndex(buttonNames[23]));
          switched = true;
          break;
        case '`': //  "Enable Projection (`)"   // 21
          toggleProjection(getButtonIndex(buttonNames[21]));
          switched = true;
          break;
        case 'm': // "Show Map (m)",          // 14
          toggleBaseMap(getButtonIndex(buttonNames[14]));
          switched = true;
          break;
        case 'f': // "Show Framerate" (f)",   // 15
          toggleFramerate(getButtonIndex(buttonNames[15]));
          switched = true;
          break;
        case 'D': // "Show Delivery Data (D)",  // 16
          toggleDeliveryData(getButtonIndex(buttonNames[16]));
          break;
//        case 'P': // "Show Population Data (P)",  // 17
//          togglePopulationData(getButtonIndex(buttonNames[17]));
//          switched = true;
//          break;
        case 'u': // "Population Counts (u)",   // 18
          setPop(getButtonIndex(buttonNames[18]));
          switched = true;
          break;
        case 'e': // "Household Counts (e)",    // 19
          setHousing(getButtonIndex(buttonNames[19]));
          switched = true;
          break;
        case 'd': // "Delivery Counts (d)",   // 2
          setDeliveries(getButtonIndex(buttonNames[2]));
          switched = true;
          break;
        case 't': // "Tote Counts (t)",       // 3
          setTotes(getButtonIndex(buttonNames[3]));
          switched = true;
          break;
        case 'o': // "Store Source (o)",      // 4
          setSource(getButtonIndex(buttonNames[4]));
          switched = true;
          break;
        case 'a': // "Avg Doorstep Time (a)"  // 5
          setDoorstep(getButtonIndex(buttonNames[5]));
          switched = true;
          break;
    
        case 's': // "Store Locations (s)"    // 6
          setStores(getButtonIndex(buttonNames[6]));
          switched = true;
          break;
          
        case ' ': // Change Age Demographic
          ageDemographic = nextMode(ageDemographic, 2);
          calcWalkAccess(ageDemographic);
          initAgents(tableCanvas);
          break;
          
        case 'w': // toggle heatmap
          showWalkAccess = toggle(showWalkAccess);
          break;
          
        case 'k': // toggle heatmap
          enableDock = toggle(enableDock);
          break;
      }
    }
    
    if (switched) {
      reRender();
      switched = false;
    }
  
    //------arrow keys and how to code keys that aren't characters exactly-----
    if (key == CODED) { 
      if (keyCode == LEFT) {
        projU--;
        saveProjectorLocation();
        projectorMoved = true;
      }  
      if (keyCode == RIGHT) {
        projU++;
        saveProjectorLocation();
        projectorMoved = true;
      }  
      if (keyCode == DOWN) {
        projV++;
        saveProjectorLocation();
        projectorMoved = true;
      }  
      if (keyCode == UP) {
        projV--;
        saveProjectorLocation();
        projectorMoved = true;
      }
      println("Projector Location: " + projU, projV, projH);
    }
    
    if (projectorMoved) {
      renderDynamicTableLayers(input);
      projectorMoved = false;
    }
    
    // reRender();
  }
}

// variables for Scroll Bar
int y_0, x_0;
int scroll_y = 0;
int scroll_x = 0;
int scroll_y_0 = 0;
int scroll_x_0 = 0;
int selectionU = gridU/2;
int selectionV = gridV/2;
boolean panChange = false;

void resetMousePan() {
  scroll_y = 0;
  scroll_x = 0;
  scroll_y_0 = 0;
  scroll_x_0 = 0;
  selectionU = gridU/2;
  selectionV = gridV/2;
}

void mousePressed() {
  
  x_0 = mouseX;
  y_0 = mouseY;
  
  if (showBasemap) {
    mapWasOn = true;
  } else {
    mapWasOn = false;
  }
  
  if (showGrid) {
    gridWasOn = true;
  } else {
    gridWasOn = false;
  }
  
  if (showPaths) {
    pathsWasOn = true;
  } else {
    pathsWasOn = false;
  }
  
  if (showSource) {
    sourceWasOn = true;
  } else {
    sourceWasOn = false;
  }
  
  if (showSwarm) {
    swarmWasOn = true;
  } else {
    swarmWasOn = false;
  }
}

boolean dragging = false;
boolean mapWasOn, gridWasOn, pathsWasOn, swarmWasOn, sourceWasOn;
void mouseDragged() {
  showBasemap = false;
  showGrid = false;
  showSwarm = false;
  showPaths = false;
  showSource = false;
  dragging = true;
  scroll_x = scroll_x_0 + mouseX - x_0;
  scroll_y = scroll_y_0 + mouseY - y_0;

  int tempU = - int(scroll_x*((float)displayU/width)) + (gridU-displayU)/2;
  int tempV = - int(scroll_y*((float)displayV/height)) + (gridV-displayV)/2;

  if (gridPanU != tempU && tempU+1 <= gridU - displayU && tempU-1 >= 0 ) {
    gridPanU = tempU;
    panChange = true;
  }

  if (gridPanV != tempV && tempV+1 <= gridV - displayV && tempV-1 >= 0 ) {
    gridPanV = tempV;
    panChange = true;
  }

  // On ReRenders if pan direction is changed
  if (panChange) {
    reRender();
    panChange = false;
  }

}

void mouseReleased() {
  
  if (dragging) {
    if (mapWasOn) {
      showBasemap = true;
    }
    if (gridWasOn) {
      showGrid = true;
    }
    if (swarmWasOn) {
      showSwarm = true;
    }
    if (sourceWasOn) {
      showSource = true;
    }
    if (pathsWasOn) {
      showPaths = true;
    }
    dragging  = false;
    
    loadBasemap();
  }
  scroll_x_0 = scroll_x;
  scroll_y_0 = scroll_y;
  changeDetected = true;
  changeClock = changeClockTime;
  refreshFinder(tableCanvas);
  initAgents(tableCanvas);
  reRender();
}

// Show or Hide Main Menu Items
void toggleMainMenu() {
  showMainMenu = toggle(showMainMenu);
  if (showMainMenu) {
    hideMenu.buttons[0].label = hide[0];
  } else {
    hideMenu.buttons[0].label = show[0];
  }
  println("showMainMenu = " + showMainMenu);
}

// Loads Next Data Set
void nextModeIndex() {
  modeIndex = next(modeIndex, 2);
  reloadData(gridU, gridV, modeIndex);
  reRenderMiniMap(miniMap);
  fauxPieces(randomType, tablePieceInput, IDMax);
  println("Mode Index = " + modeIndex + ": " + fileName);
}

// Prints Screen to File
void printScreen() {
  String location = "export/" + fileName + "_" + int(gridSize*1000) + ".png";
  save(location);
  println("File saved to " + location);
}

void setDeliveries(int button) {
  valueMode = "deliveries";
  depressHeatmapButtons();
  reloadData(gridU, gridV, modeIndex);
  reRenderMiniMap(miniMap);
  println("valueMode: " + valueMode);
}

void setTotes(int button) {
  valueMode = "totes";
  depressHeatmapButtons();
  reloadData(gridU, gridV, modeIndex);
  reRenderMiniMap(miniMap);
  println("valueMode: " + valueMode);
}

void setSource(int button) {
  valueMode = "source";
  depressHeatmapButtons();
  reloadData(gridU, gridV, modeIndex);
  reRenderMiniMap(miniMap);
  println("valueMode: " + valueMode);
}

void setDoorstep(int button) {
  valueMode = "doorstep";
  depressHeatmapButtons();
  reloadData(gridU, gridV, modeIndex);
  reRenderMiniMap(miniMap);
  println("valueMode: " + valueMode);
}

void setStores(int button) {
  showStores = toggle(showStores);
  pressButton(showStores, button);
  reRenderMiniMap(miniMap);
  println("showStores: " + showStores);
}

void setPop(int button) {
  popMode = "POP10";
  depressPopulationButtons();
  reloadData(gridU, gridV, modeIndex);
  reRenderMiniMap(miniMap);
  println("popMode: " + popMode);
}

void setHousing(int button) {
  popMode = "HOUSING10";
  depressPopulationButtons();
  reloadData(gridU, gridV, modeIndex);
  reRenderMiniMap(miniMap);
  println("popMode: " + popMode);
}

void setPieceForm() {
  showForm = true;
  showFacilities = false;
  showMarket = false;
  renderDynamicTableLayers(input);
  if (implementMenu) depressInputButtons();
  reRenderMiniMap(miniMap);
}

void setPieceData() {
  showForm = false;
  showFacilities = true;
  showMarket = true;
  renderDynamicTableLayers(input);
  if (implementMenu) depressInputButtons();
  reRenderMiniMap(miniMap);
}

void setDeliveryCost() {
  showAllocation = false;
  showVehicle = false;
  showDeliveryCost = true;
  showTotalCost = false;
  renderOutputTableLayers(input);
  if (implementMenu) depressOutputButtons();
  reRenderMiniMap(miniMap);
}

void setTotalCost() {
  showAllocation = false;
  showVehicle = false;
  showDeliveryCost = false;
  showTotalCost = true;
  renderOutputTableLayers(input);
  if (implementMenu) depressOutputButtons();
  reRenderMiniMap(miniMap);
}

void setAllocation() {
  showAllocation = true;
  showVehicle = false;
  showDeliveryCost = false;
  showTotalCost = false;
  renderOutputTableLayers(input);
  if (implementMenu) depressOutputButtons();
  reRenderMiniMap(miniMap);
}

void setVehicle() {
  showAllocation = false;
  showVehicle = true;
  showDeliveryCost = false;
  showTotalCost = false;
  renderOutputTableLayers(input);
  if (implementMenu) depressOutputButtons();
  reRenderMiniMap(miniMap);
}

void setGridSize(float size) {
  gridSize = size;
  resetGridParameters();
  
  refreshFinder(tableCanvas);
  initAgents(tableCanvas);
  
  if (implementMenu) depressZoomButtons(size);
  reloadData(gridU, gridV, modeIndex);
  reRenderMiniMap(miniMap);
  fauxPieces(randomType, tablePieceInput, IDMax);
  println("gridSize: " + gridSize + "km");
}

void toggleBaseMap(int button) {
  showBasemap = toggle(showBasemap);
  reRenderMiniMap(miniMap);
  pressButton(showBasemap, button);
  println("showBasemap = " + showBasemap);
}

void toggleFramerate(int button) {
  showFrameRate = toggle(showFrameRate);
  pressButton(showFrameRate, button);
  println("showFrameRate = " + showFrameRate);
}

void toggleProjection(int button) {
  toggle2DProjection();
  pressButton(displayProjection2D, button);
  println("displayProjection2D = " + displayProjection2D);
}

void toggleRandomPieces() {
  randomType = next(randomType, 2);
  fauxPieces(randomType, tablePieceInput, IDMax);
  renderDynamicTableLayers(input);
  reRenderMiniMap(miniMap);
  changeDetected = true;
  changeClock = changeClockTime;
  println("randomType = " + randomType);
}

void toggleDeliveryData(int button) {
  showDeliveryData = toggle(showDeliveryData);
  reRenderMiniMap(miniMap);
  pressButton(showDeliveryData, button);
  println("showDeliveryData = " + showDeliveryData);

  if (!showDeliveryData) {
    for (int i=2; i<=5; i++) {
      mainMenu.buttons[getButtonIndex(buttonNames[i])].show = false;
    }
  } else {
    for (int i=2; i<=5; i++) {
      mainMenu.buttons[getButtonIndex(buttonNames[i])].show = true;
    }
  }
}

void togglePopulationData(int button) {
  showPopulationData = toggle(showPopulationData);
  reRenderMiniMap(miniMap);
  pressButton(showPopulationData, button);
  println("showPopulationData = " + showPopulationData);

  if (!showPopulationData) {
    for (int i=18; i<=19; i++) {
      mainMenu.buttons[getButtonIndex(buttonNames[i])].show = false;
    }
  } else {
    for (int i=18; i<=19; i++) {
      mainMenu.buttons[getButtonIndex(buttonNames[i])].show = true;
    }
  }
}

void toggleInputData(int button) {
  showInputData = toggle(showInputData);
  reRenderMiniMap(miniMap);
  renderDynamicTableLayers(input);
  pressButton(showInputData, button);
  println("showInputData = " + showInputData);

  if (!showInputData) {
    for (int i=24; i<=25; i++) {
      mainMenu.buttons[getButtonIndex(buttonNames[i])].show = false;
    }
  } else {
    for (int i=24; i<=25; i++) {
      mainMenu.buttons[getButtonIndex(buttonNames[i])].show = true;
    }
  }
}

void toggleOutputData(int button) {
  showOutputData = toggle(showOutputData);
  reRenderMiniMap(miniMap);
  renderOutputTableLayers(input);
  pressButton(showOutputData, button);
  println("showOutputData = " + showOutputData);

  if (!showOutputData) {
    for (int i=27; i<=30; i++) {
      mainMenu.buttons[getButtonIndex(buttonNames[i])].show = false;
    }
  } else {
    for (int i=27; i<=30; i++) {
      mainMenu.buttons[getButtonIndex(buttonNames[i])].show = true;
    }
  }
}

void pressButton(boolean bool, int button) {
  if (bool) {
    mainMenu.buttons[button].isPressed = false;
  } else {
    mainMenu.buttons[button].isPressed = true;
  }
}

// Presses all buttons in a set of mutually exclusive buttons except for the index specified
// min-max specifies a range of button indices; valueMode specifies the currently selected button
void depressHeatmapButtons() {

  int min = getButtonIndex(buttonNames[2]);
  int max = getButtonIndex(buttonNames[5]);

  int button = min;
  if (valueMode.equals("deliveries")) {
    button += 0;
  } else if (valueMode.equals("totes")) {
    button += 1;
  } else if (valueMode.equals("source")) {
    button += 2;
  } else if (valueMode.equals("doorstep")) {
    button += 3;
  }

  // Turns all buttons off
  for(int i=min; i<=max; i++) { //heatmap buttons min-max are mutually exclusive
    mainMenu.buttons[i].isPressed = true;
  }
  // highlighted the heatmap button that is activated only
  mainMenu.buttons[button].isPressed = false;
}

// Presses all buttons in a set of mutually exclusive buttons except for the index specified
// min-max specifies a range of button indices; valueMode specifies the currently selected button
void depressPopulationButtons() {

  int min = getButtonIndex(buttonNames[18]);
  int max = getButtonIndex(buttonNames[19]);

  int button = min;
  if (popMode.equals("POP10")) {
    button += 0;
  } else if (popMode.equals("HOUSING10")) {
    button += 1;
  }

  // Turns all buttons off
  for(int i=min; i<=max; i++) { //heatmap buttons min-max are mutually exclusive
    mainMenu.buttons[i].isPressed = true;
  }
  // highlighted the heatmap button that is activated only
  mainMenu.buttons[button].isPressed = false;
}

// Presses all buttons in a set of mutually exclusive buttons except for the index specified
// min-max specifies a range of button indices; valueMode specifies the currently selected button
void depressInputButtons() {

  int min = getButtonIndex(buttonNames[24]);
  int max = getButtonIndex(buttonNames[25]);

  int button = min;
  if (showForm) {
    button += 0;
  } else {
    button += 1;
  }

  // Turns all buttons off
  for(int i=min; i<=max; i++) { //heatmap buttons min-max are mutually exclusive
    mainMenu.buttons[i].isPressed = true;
  }
  // highlighted the heatmap button that is activated only
  mainMenu.buttons[button].isPressed = false;
}

// Presses all buttons in a set of mutually exclusive buttons except for the index specified
// min-max specifies a range of button indices; valueMode specifies the currently selected button
void depressOutputButtons() {

  int min = getButtonIndex(buttonNames[27]);
  int max = getButtonIndex(buttonNames[30]);

  int button = min;
  if (showDeliveryCost) {
    button += 0;
  } else if (showTotalCost) {
    button += 1;
  } else if (showAllocation) {
    button += 2;
  } else {
    button += 3;
  }

  // Turns all buttons off
  for(int i=min; i<=max; i++) { //heatmap buttons min-max are mutually exclusive
    mainMenu.buttons[i].isPressed = true;
  }
  // highlighted the heatmap button that is activated only
  mainMenu.buttons[button].isPressed = false;
}

// Presses all buttons withinin a set of mutually exclusive buttons except for the index specified
// min-max specifies a range of button indices; size specifies the currently selected button
void depressZoomButtons(float size) {

  int min = getButtonIndex(buttonNames[11]);
  int max = getButtonIndex(buttonNames[13]);

  int button = min;
  if (size == MAX_GRID_SIZE) {
    button += 0;
  } else if (size == MAX_GRID_SIZE/2) {
    button += 1;
  } else if (size == MAX_GRID_SIZE/4) {
    button += 2;
  }

  // Turns all buttons off
  for(int i=min; i<=max; i++) { //heatmap buttons min-max are mutually exclusive
    mainMenu.buttons[i].isPressed = true;
  }
  // highlighted the heatmap button that is activated only
  mainMenu.buttons[button].isPressed = false;
}

// Aligns Menue to Left
void alignLeft() {
  align = "LEFT";
  loadMenu(screen.width, screen.height);
  println(align);
}

// Aligns Menue to Right
void alignRight() {
  align = "RIGHT";
  loadMenu(screen.width, screen.height);
  println(align);
}

// Aligns Menue to Center
void alignCenter() {
  align = "CENTER";
  loadMenu(screen.width, screen.height);
  println(align);
}

// Inverts background and text colors
void invertColors() {
  if (background == 0) {
    background = 255;
    textColor = 0;
    mapColor = "color";
    loadBasemap();
  } else {
    background = 0;
    textColor = 255;
    mapColor = "bw";
    loadBasemap();
  }
  initializeBaseMap();
  loadBasemap();
  reRenderMiniMap(miniMap);
  println ("background: " + background + ", textColor: " + textColor);
}

// iterates an index parameter
int next(int index, int max) {
  if (index == max) {
    index = 0;
  } else {
    index ++;
  }
  return index;
}

// flips a boolean
boolean toggle(boolean bool) {
  if (bool) {
    return false;
  } else {
    return true;
  }
}

boolean buttonHovering = false;

class Button{
  // variables describing upper left corner of button, width, and height in pixels
  int x,y,w,h;
  // String of the Button Text
  String label;
  // Various Shades of button states (0-255)
  int active  = 180; // lightest
  int hover   = 160;
  int pressed = 120; // darkest

  boolean isPressed = false;
  boolean isVoid = false;
  boolean show = true;

  //Button Constructor
  Button(int x, int y, int w, int h, String label){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  //Button Objects are draw to a PGraphics object rather than directly to canvas
  void draw(PGraphics graphic){
    if (!isVoid) {
      graphic.smooth();
      graphic.noStroke();
      if( over() ) {  // Darkens button if hovering mouse over it
        graphic.fill(textColor, hover);
        buttonHovering = true;
      } else if (isPressed){
        graphic.fill(walmart_dark_blue, pressed);
      } else {
        graphic.fill(walmart_dark_blue, active);
      }
      graphic.rect(x, y, w, h, 5);
      graphic.fill(walmart_yellow);
      graphic.text(label, x + (w/2-textWidth(label)/2), y + 0.6*h); //text(str, x1, y1, x2, y2) text(label, x + 5, y + 15)
    }
  }

  // returns true if mouse hovers in button region
  boolean over(){
    if(mouseX >= x  && mouseY >= y && mouseX <= x + w && mouseY <= y + 2 + h){
      return true;
    } else {
      return false;
    }
  }
}

class Menu{
  // Button Array Associated with this Menu
  Button[] buttons;
  // Graphics Object to Draw this Menu
  PGraphics canvas;
  // Button Name Array Associated with Menu
  String[] names;
  // Menu Alignment
  String align;
  // variables describing screenWidth, screenHeight, Button Width, Button Height, Verticle Displacement (#buttons down)
  int w, h, x, y, vOffset;

  //Constructor
  Menu(int w, int h, int x, int y, int vOffset, String[] names, String align){
    this.names = names;
    this.w = w;
    this.h = h;
    this.vOffset = vOffset;
    this.align = align;
    this.x = x;
    this.y = y;

    canvas = createGraphics(w, h);
    // #Buttons defined by Name String Array Length
    buttons = new Button[this.names.length];

    // Initializes the button objects
    for (int i=0; i<buttons.length; i++) {
      if ( this.align.equals("right") || this.align.equals("RIGHT") ) {
        // Right Align
        buttons[i] = new Button(this.w - this.x - STANDARD_MARGIN, STANDARD_MARGIN + this.vOffset*(this.y+5) + i*(this.y+5), this.x, this.y, this.names[i]);
      } else if ( this.align.equals("left") || this.align.equals("LEFT") ) {
        // Left Align
        buttons[i] = new Button(STANDARD_MARGIN, STANDARD_MARGIN + this.vOffset*(this.y+5) + i*(this.y+5), this.x, this.y, names[i]);
      } else if ( this.align.equals("center") || this.align.equals("CENTER") ) {
        // Center Align
        buttons[i] = new Button( (this.w-this.x)/2, STANDARD_MARGIN + this.vOffset*(this.y+5) + i*(this.y+5), this.x, this.y, this.names[i]);
      }

      // Alows a menu button spacer to be added by setting its string value to "VOID"
      if (this.names[i].equals("void") || this.names[i].equals("VOID") ) {
        buttons[i].isVoid = true;
      }
    }
  }

  // Draws the Menu to its own PGraphics canvas
  void draw(PGraphics graphic) {
    canvas.beginDraw();
    canvas.clear();
    for (int i=0; i<buttons.length; i++) {
      if (buttons[i].show) {
        buttons[i].draw(canvas);
      }
    }
    canvas.endDraw();

    graphic.image(canvas, 0, 0);
  }
}

// Key Functions Carried over from AgentDemoClean's "KEY" tab

boolean keyLoaded = true;
char initKey;

// Running this method will display a loading screen when 
// running a method placed in "initKey()".
// Useful for laggy commands
void setLoader(String txt) {
  drawDelay = 2;
  keyLoaded = false;
  loadText = txt;
  initKey = key;
  println(initKey);
  loading(tableCanvas, loadText);
}

void setLoader(String txt, char k) {
  drawDelay = 2;
  keyLoaded = false;
  loadText = txt;
  initKey = k;
  println(initKey);
  loading(tableCanvas, loadText);
}

int toggleBW(int col) {
  if (col == 255) {
    return 0;
  } else if (col == 0) {
    return 255;
  } else {
    return 0;
  }
}

int nextMode(int mode, int maxMode) {
  if (mode < maxMode) {
    return mode + 1;
  } else {
    return 0;
  }
}

//// variables for Scroll Bar
//int y_0;
int scroll = 0;
//int scroll_0 = 0;
//
//void mousePressed() {
//  y_0 = mouseY;
//}
//
//void mouseDragged() {
//  scroll = scroll_0 + mouseY - y_0;
//}
//
//void mouseReleased() {
//  scroll_0 = scroll;
//}
//
//void mouseClicked() {
//  if (editObstacles) {
//    boundaries.addVertex(new PVector(mouseX, mouseY));
//  }
//
//}

// Runs on a delay
void keyInit() {
  switch(initKey) {
    case '0':
      key_0();
      break;
    case '>':
      key_RightCarrot();
      break;
    case '<':
      key_LeftCarrot();
      break;
    case 'n':
      key_n();
      break;
    case 'E':
      key_E();
      break;
    case 'p':
      key_p();
      break;
    case 'r':
      key_r();
      break;
    case 'X':
      key_X();
      break;
  }
}
  
void key_0() {
  // Restarts the whole sh'bang
  initCanvas();
  initContent(tableCanvas);
  tableCanvas.beginDraw();
  tableCanvas.background(background);
  tableCanvas.endDraw();
}


void key_RightCarrot() {
  // Toggle network for pathfinding
  finderMode = nextMode(finderMode, 4);
  println("finderMode = " + finderMode);
  refreshFinder(tableCanvas);
}

void key_LeftCarrot() {
  // Enable/Disable Pathfinding
  enablePathfinding = toggle(enablePathfinding);
  refreshFinder(tableCanvas);
}

void key_n() {
  // randomize/reset current network for pathfinding
  resetFinder(tableCanvas, 10, finderMode);
  refreshFinder(tableCanvas);
}

void key_E() {
  // shows or hides obstale editor 
  editObstacles = toggle(editObstacles);
  println("editObstacles = " + editObstacles);
  if (!editObstacles) { //if deactivapting editor, reinitializes custom network
    // Resets the network for custom mode
    resetFinder(tableCanvas, 10, 2); // '2' for custom mode
    refreshFinder(tableCanvas);
  } else { // If activating editor, sets finder mode to custom
    finderMode = 2;
    refreshFinder(tableCanvas);
    showObstacles = true;
  }
}

void key_p() {
  //makes a grid of obstacles
  testObstacles = toggle(testObstacles);
  testObstacles(tableCanvas, testObstacles);
  // Resets the network for gridded mode
  resetFinder(tableCanvas, 10, finderMode); // '1' for gridded mode
  refreshFinder(tableCanvas);
}

void key_r() {
  //reset agents and simulation
  initAgents(tableCanvas);
}

void key_X() {
  // randomize locations of origin and destination paths
  initOD(tableCanvas);
  initPath(pFinder, A, B);
  pFinderGrid_Viz(tableCanvas);
}

