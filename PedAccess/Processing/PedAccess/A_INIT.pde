// Graphics object in memory that holds visualization
PGraphics tableCanvas;

PImage demoMap;

int finderResolution;

void initCanvas() {
  
  println("Initializing Canvas Objects ... ");
  
  // Largest Canvas that holds unchopped parent graphic.
  
  tableCanvas = createGraphics(tableWidth, tableHeight, P3D);
  
  // Adjusts Colors and Transparency depending on whether visualization is on screen or projected
  setScheme();
  
  println("Canvas and Projection Mapping complete.");

}

void initContent(PGraphics p) {
  
  finderMode = 4;
  finderResolution = p.width/(18*4);
  initObstacles(p);
  initPathfinder(p, finderResolution);
  //initPathfinder(p, p.width/100);
  initAgents(p);
  //initButtons(p);
  
  demoMap = loadImage("data/demoMap.png");
  
  //hurrySwarms(1000);
  println("Initialization Complete.");
}





// ---------------------Initialize Agent-based Objects---

Horde swarmHorde;

PVector[] origin, destination, nodes;
String[] subtype;
float[] weight;

int textSize = 8;

boolean enablePathfinding = true;


PGraphics sources_Viz, edges_Viz;

void initAgents(PGraphics p) {
  
  println("Initializing Agent Objects ... ");
  
  importPointsOfInterest();
  
  swarmHorde = new Horde(int(50*gridSize*1000));
  sources_Viz = createGraphics(p.width, p.height);
  edges_Viz = createGraphics(p.width, p.height);
  //testNetwork_Random(p, 16);
  amenityNetwork(p, amenity, transit, newPOIs);
  
  swarmPaths(p, enablePathfinding);
  sources_Viz(p);
  edges_Viz(p);
  
  println("Agents initialized.");
}

void swarmPaths(PGraphics p, boolean enable) {
  // Applyies pathfinding network to swarms
  swarmHorde.solvePaths(pFinder, enable);
  pFinderPaths_Viz(p, enable);
}

void sources_Viz(PGraphics p) {
  sources_Viz = createGraphics(p.width, p.height);
  sources_Viz.beginDraw();
  // Draws Sources and Sinks to canvas
  swarmHorde.displaySource(sources_Viz);
  sources_Viz.endDraw(); 
}

void edges_Viz(PGraphics p) {
  edges_Viz = createGraphics(p.width, p.height);
  edges_Viz.beginDraw();
  // Draws edges to canvas
  swarmHorde.displayEdges(edges_Viz);
  edges_Viz.endDraw(); 
}

void hurrySwarms(int frames) {
  //speed = 20;
  showSwarm = false;
  showEdges = false;
  showSource = false;
  showPaths = false;
  for (int i=0; i<frames; i++) {
    swarmHorde.update();
  }
  showSwarm = true;
  //speed = 1.5;
}

void amenityNetwork(PGraphics p, JSONArray amenity, JSONArray transit, JSONArray newPOIs) {
  int numNodes, numEdges, numSwarm;
  
  numNodes = amenity.size() + transit.size() + newPOIs.size();
  numEdges = numNodes*(numNodes-1);
  numSwarm = numEdges;
  
  nodes = new PVector[numNodes];
  subtype = new String[numNodes];
  origin = new PVector[numSwarm];
  destination = new PVector[numSwarm];
  weight = new float[numSwarm];
  swarmHorde.clearHorde();
  
  
  for (int i=0; i<amenity.size(); i++) {
    int u = amenity.getJSONObject(i).getInt("u") - gridPanU;//- gridU/2;
    int v = amenity.getJSONObject(i).getInt("v") - gridPanV;// - gridV/2;
    int x = int( u*(float(p.width )/displayU)  );
    int y = int( v*(float(p.height)/displayV) );
    subtype[i] = amenity.getJSONObject(i).getString("subtype");
    nodes[i] = new PVector(x, y, getAmenityID(subtype[i]));
    
  }
  
  for (int i=0; i<transit.size(); i++) {
    int u = transit.getJSONObject(i).getInt("u") - gridPanU;//- gridU/2;
    int v = transit.getJSONObject(i).getInt("v") - gridPanV;//- gridV/2;
    int x = int( u*(float(p.width )/displayU)  );
    int y = int( v*(float(p.height)/displayV) );
    subtype[amenity.size() + i] = transit.getJSONObject(i).getString("subtype");
    nodes[amenity.size() + i] = new PVector(x, y, getAmenityID(subtype[amenity.size() + i]));
  }
  
  for (int i=0; i<newPOIs.size(); i++) {
    int u = newPOIs.getJSONObject(i).getInt("u") - gridPanU;// - gridU/2;
    int v = newPOIs.getJSONObject(i).getInt("v") - gridPanV;// - gridV/2;
    int x = int( u*(float(p.width )/displayU)  );
    int y = int( v*(float(p.height)/displayV) );
    int z;
    subtype[amenity.size() + transit.size() + i] = newPOIs.getJSONObject(i).getString("subtype");
    nodes[amenity.size() + transit.size() + i] = new PVector(x, y, getAmenityID(subtype[amenity.size() + transit.size() + i]));
  }
  
  for (int i=0; i<numNodes; i++) {
    for (int j=0; j<numNodes-1; j++) {
      
      origin[i*(numNodes-1)+j] = new PVector(nodes[i].x, nodes[i].y, nodes[i].z);
      
      destination[i*(numNodes-1)+j] = new PVector(nodes[(i+j+1)%(numNodes)].x, nodes[(i+j+1)%(numNodes)].y, nodes[(i+j+1)%(numNodes)].z);
      
      weight[i*(numNodes-1)+j] = 1.0;
      
      //println("swarm:" + (i*(numNodes-1)+j) + "; (" + i + ", " + (i+j+1)%(numNodes) + ")");
    }
  }
  
    // rate, life, origin, destination
  colorMode(HSB);
  for (int i=0; i<numSwarm; i++) {
//      if (subtype.equals("school"))     
//        ID = 0;
//      if (subtype.equals("child_care")) 
//        ID = 1;
//      if (subtype.equals("health"))     
//        ID = 2;
//      if (subtype.equals("eldercare"))  
//        ID = 3;
//      if (subtype.equals("retail"))
//        ID = 4;
//      if (subtype.equals("park"))
//        ID = 5;
//      if (subtype.equals("transit"))
//        ID = 6;
//      if (subtype.equals("housing"))
//        ID = 7;
    
    boolean walkingDist = (abs(origin[i].x - destination[i].x) + abs(origin[i].y - destination[i].y) ) < 0.3/(gridSize/(p.width/displayU)) ;
    boolean origin_tableArea = origin[i].x > 0 && origin[i].x < p.width && origin[i].y > 0 && origin[i].y < p.height;
    boolean destination_tableArea = destination[i].x > 0 && destination[i].x < p.width && destination[i].y > 0 && destination[i].y < p.height;
    boolean transitToAmenity = destination[i].z <= 5 && origin[i].z > 5 || destination[i].z > 5 && origin[i].z <= 5;
    
    boolean[] validForAge = new boolean[3];
    validForAge[0] = destination[i].z != 3 && origin[i].z != 3 && destination[i].z != 4 && origin[i].z != 4;
    validForAge[1] = destination[i].z != 0 && origin[i].z != 0 && destination[i].z != 3 && origin[i].z != 3;
    validForAge[2] = destination[i].z != 0 && origin[i].z != 0 && destination[i].z != 1 && origin[i].z != 1;
    
    boolean filtered = (amenityFilter == -1) || origin[i].z == amenityFilter || destination[i].z == amenityFilter;
    
    if (walkingDist && (origin_tableArea || destination_tableArea) && transitToAmenity && validForAge[ageDemographic] && filtered) {
    
      // delay, origin, destination, speed, color
      swarmHorde.addSwarm(weight[i], origin[i], destination[i], 1, color(255.0*i/numSwarm, 255, 255));
      
      // Makes sure that agents 'staying put' eventually die
      swarmHorde.getSwarm(i).temperStandingAgents();
    }
  }
  colorMode(RGB);
  
  swarmHorde.popScaler(1.0);
}

int getAmenityID(String subtype) {
  int ID = -1;
  
  if (subtype.equals("school"))     
    ID = 0;
  if (subtype.equals("child_care")) 
    ID = 1;
  if (subtype.equals("health"))     
    ID = 2;
  if (subtype.equals("eldercare"))  
    ID = 3;
  if (subtype.equals("retail"))
    ID = 4;
  if (subtype.equals("park"))
    ID = 5;
  if (subtype.equals("mrt"))
    ID = 6;
  if (subtype.equals("bus_stop"))
    ID = 6;
  if (subtype.equals("housing"))
    ID = 7;
  
  return ID;
}

void testNetwork_Random(PGraphics p, int _numNodes) {
  
  int numNodes, numEdges, numSwarm;
  
  numNodes = _numNodes;
  numEdges = numNodes*(numNodes-1);
  numSwarm = numEdges;
  
  nodes = new PVector[numNodes];
  origin = new PVector[numSwarm];
  destination = new PVector[numSwarm];
  weight = new float[numSwarm];
  swarmHorde.clearHorde();

  
  for (int i=0; i<numNodes; i++) {
    nodes[i] = new PVector(random(10, p.width-10), random(10, p.height-10));
  }
  
  for (int i=0; i<numNodes; i++) {
    for (int j=0; j<numNodes-1; j++) {
      
      origin[i*(numNodes-1)+j] = new PVector(nodes[i].x, nodes[i].y);
      
      destination[i*(numNodes-1)+j] = new PVector(nodes[(i+j+1)%(numNodes)].x, nodes[(i+j+1)%(numNodes)].y);
      
      weight[i*(numNodes-1)+j] = random(0.1, 2.0);
      
      //println("swarm:" + (i*(numNodes-1)+j) + "; (" + i + ", " + (i+j+1)%(numNodes) + ")");
    }
  }
  
    // rate, life, origin, destination
  colorMode(HSB);
  for (int i=0; i<numSwarm; i++) {
    
    // delay, origin, destination, speed, color
    swarmHorde.addSwarm(weight[i], origin[i], destination[i], 1, color(255.0*i/numSwarm, 255, 255));
    
    // Makes sure that agents 'staying put' eventually die
    swarmHorde.getSwarm(i).temperStandingAgents();
  }
  colorMode(RGB);
  
  swarmHorde.popScaler(1.0);
}

//------------------Initialize Obstacles----

boolean showObstacles = false;
boolean editObstacles = false;
boolean testObstacles = true;

ObstacleCourse boundaries, grid;
PVector[] obPts;

void initObstacles(PGraphics p) {
  
  println("Initializing Obstacle Objects ...");
  
  // Gridded Obstacles for testing
  grid = new ObstacleCourse();
  testObstacles(p, testObstacles);
  
  // Obstacles for agents generates within Andorra le Vella
  boundaries = new ObstacleCourse();
  boundaries.loadCourse("data/course.tsv");
  
  println("Obstacles initialized.");
}

void testObstacles(PGraphics p, boolean place) {
  if (place) {
    setObstacleGrid(p, p.width/50, p.height/50);
  } else {
    setObstacleGrid(p, 0, 0);
  }
}

void setObstacleGrid(PGraphics p, int u, int v) {
  
  grid.clearCourse();
  
  float w = 0.75*float(p.width)/(u+1);
  float h = 0.75*float(p.height)/(v+1);
  
  obPts = new PVector[4];
  for (int i=0; i<obPts.length; i++) {
    obPts[i] = new PVector(0,0);
  }
  
  for (int i=0; i<u; i++) {
    for (int j=0; j<v; j++) {
      
      float x = float(p.width)*i/(u+1)+w/2.0;
      float y = float(p.height)*j/(v+1)+h/2.0;
      obPts[0].x = x;     obPts[0].y = y;
      obPts[1].x = x+w;   obPts[1].y = y;
      obPts[2].x = x+w;   obPts[2].y = y+h;
      obPts[3].x = x;     obPts[3].y = y+h;
      
      grid.addObstacle(new Obstacle(obPts));
    }
  }
}


//------------- Initialize Pathfinding Objects

Pathfinder pFinder;
int finderMode = 2;
// 0 = Random Noise Test
// 1 = Grid Test
// 2 = Custom
// 4 = JSON

// Pathfinder test and debugging Objects
Pathfinder finderRandom, finderGrid, finderCustom, finderJSON;
PVector A, B;
ArrayList<PVector> testPath, testVisited;

// PGraphic for holding pFinder Viz info so we don't have to re-write it every frame
PGraphics pFinderPaths, pFinderGrid;

void initPathfinder(PGraphics p, int res) {
  
  println("Initializing Pathfinder Objects ... ");
  
  // Initializes a Custom Pathfinding network Based off of JSON file
  importPedNetwork();
  initJSONFinder(p, res, pedNetwork, newNodes);
  
  // Initializes a Custom Pathfinding network Based off of user-drawn Obstacle Course
  initCustomFinder(p, res);
  
  // Initializes a Pathfinding network Based off of standard Grid-based Obstacle Course
  initGridFinder(p, res);
  
  // Initializes a Pathfinding network Based off of Random Noise
  initRandomFinder(p, res);
  
  // Initializes an origin-destination coordinate for testing
  initOD(p);
  
  // sets 'pFinder' to one of above network presets
  setFinder(p, finderMode);
  initPath(pFinder, A, B);
  
  // Ensures that a valid path is always initialized upon start, to an extent...
  forcePath(p);
  
  // Initializes a PGraphic of the paths found
  pFinderGrid_Viz(p);
  
  println("Pathfinders initialized.");
}

void initJSONFinder(PGraphics p, int res, JSONArray network, JSONArray newNodes) {
  finderJSON = new Pathfinder(p.width, p.height, res, 0.0, network, newNodes); // 4th float object is a number 0-1 that represents how much of the network you would like to randomly cull, 0 being none
  //finderJSON.applyObstacleCourse(boundaries);
}

void initCustomFinder(PGraphics p, int res) {
  finderCustom = new Pathfinder(p.width, p.height, res, 0.0); // 4th float object is a number 0-1 that represents how much of the network you would like to randomly cull, 0 being none
  finderCustom.applyObstacleCourse(boundaries);
}

void initGridFinder(PGraphics p, int res) {
  finderGrid = new Pathfinder(p.width, p.height, res, 0.0); // 4th float object is a number 0-1 that represents how much of the network you would like to randomly cull, 0 being none
  finderGrid.applyObstacleCourse(grid);  
}

void initRandomFinder(PGraphics p, int res) {
  finderRandom = new Pathfinder(p.width, p.height, res, 0.5);
}

// Refresh Paths and visualization; Use for key commands and dynamic changes
void refreshFinder(PGraphics p) {
  
  // Initializes a Custom Pathfinding network Based off of JSON file
  importPedNetwork();
  initJSONFinder(p, finderResolution, pedNetwork, newNodes);
  
  setFinder(p, finderMode);
  initPath(pFinder, A, B);
  swarmPaths(p, enablePathfinding);
  pFinderGrid_Viz(p);
}

// Completely rebuilds a selected Pathfinder Network
void resetFinder(PGraphics p, int res, int _finderMode) {
  switch(_finderMode) {
    case 0:
      initRandomFinder(p, res);
      break;
    case 1:
      initGridFinder(p, res);
      break;
    case 2:
      initCustomFinder(p, res);
      break;
    case 3: 
      initGridFinder(p, res);
      break;
    case 4: 
      initJSONFinder(p, res, pedNetwork, newNodes);
      break;
  }
  setFinder(p, _finderMode);
}

void setFinder(PGraphics p, int _finderMode) {
  switch(_finderMode) {
    case 0:
      pFinder = finderRandom;
      break;
    case 1:
      pFinder = finderGrid;
      break;
    case 2:
      pFinder = finderCustom;
      break;
    case 3: 
      pFinder = finderGrid;
      break;
    case 4: 
      pFinder = finderJSON;
      break;
  }
}

void pFinderPaths_Viz(PGraphics p, boolean enable) {
  
  // Write Path Results to PGraphics
  pFinderPaths = createGraphics(p.width, p.height);
  pFinderPaths.beginDraw();
  swarmHorde.solvePaths(pFinder, enable);
  swarmHorde.displayPaths(pFinderPaths);
  pFinderPaths.endDraw();
  
}

void pFinderGrid_Viz(PGraphics p) {
  
  // Write Network Results to PGraphics
  pFinderGrid = createGraphics(p.width, p.height);
  pFinderGrid.beginDraw();
  pFinder.display(pFinderGrid);

  pFinderGrid.endDraw();
}

// Ensures that a valid path is always initialized upon start, to an extent...
void forcePath(PGraphics p) {
  int counter = 0;
  while (testPath.size() < 2) {
    println("Generating new origin-destination pair ...");
    initOD(p);
    initPath(pFinder, A, B);
    
    counter++;
    if (counter > 1000) {
      break;
    }
  }
}

void initPath(Pathfinder f, PVector A, PVector B) {
  testPath = f.findPath(A, B, enablePathfinding);
  testVisited = f.getVisited();
}

void initOD(PGraphics p) {
  A = new PVector(random(1.0)*p.width, random(1.0)*p.height);
  B = new PVector(random(1.0)*p.width, random(1.0)*p.height);
}
