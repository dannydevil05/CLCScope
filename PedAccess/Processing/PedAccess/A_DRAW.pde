boolean showPaths = true;
boolean showGrid = false;
boolean showSource = false;
boolean showEdges = false;
boolean showSwarm = true;
boolean showInfo = false;
boolean showDemoMap = false;
boolean showWalkAccess = true;

// Makes darker colors more visible when projecting
int masterAlpha;
float schemeScaler;
int background = 0;
int textColor = 255;
int grayColor = int(abs(background - (255.0/2)*schemeScaler));

color road = #D6D6D6;
color ped_ground = #FFFA95;
color ped_xing = #FF9A3B;
color ped_linkway = #3BFFF4;
color ped_bridge = #FF453B;
color ped_2nd = #4BCB2F;

void pedColorbyInt(PGraphics p, int type) {
  switch (type) {
    case 0:
      pedColorbyString(p, "road");
      break;
    case 1:
      pedColorbyString(p, "ped_ground");
      break;
    case 2:
      pedColorbyString(p, "ped_xing");
      break;
    case 3:
      pedColorbyString(p, "ped_linkway");
      break;
    case 4:
      pedColorbyString(p, "ped_bridge");
      break;
    case 5:
      pedColorbyString(p, "ped_2nd");
      break;
  }
}

void pedColorbyString(PGraphics p, String type) {
  int pedAlpha = 255;
  color stroke = color(255);
  color fill = color(255);
  
  if (type.equals("road")) {
    stroke = road;
    fill = road;
  }
  if (type.equals("ped_ground")) {
    stroke = ped_ground;
    fill = ped_ground;
  }
  if (type.equals("ped_xing")) {
    stroke = ped_xing;
    fill = ped_xing;
  }
  if (type.equals("ped_linkway")) {
    stroke = ped_linkway;
    fill = ped_linkway;
  }
  if (type.equals("ped_bridge")) {
    stroke = ped_bridge;
    fill = ped_bridge;
  }
  if (type.equals("ped_2nd")) {
    stroke = ped_2nd;
    fill = ped_2nd;
  }
  
  p.stroke(stroke, pedAlpha);
  p.fill(fill, pedAlpha);
}

// temp variable that holds coordinate location for a point to render
PVector coord;

// temp variable that holds coordinate locations for a line to render
PVector[] line = new PVector[2];

void drawTableCanvas(PGraphics p) {
  
  //Updates Agent Data to Display
  if (showSwarm) {
    swarmHorde.update();
  }

  // holds time from last frame
  time_0 = millis();
  
  // Begin Draw Functions
  p.beginDraw();
 
  
      p.noStroke();
      
      // Instead of solid background draws a translucent overlay every frame.
      // Provides the effect of giving animated elements "tails"
      //p.fill(background, 75);
      
      //p.fill(background);
      //p.rect(0,0,p.width,p.height);
      
      p.clear();
      
      // Displays demoMap
      if(showDemoMap) {
        p.image(demoMap, 0, 0, width, height);
      }
      

  
      // Displays ObstacleCourses
      if (showObstacles) {
        
        if (finderMode == 1) { 
          // Obstacles for gridded Pathfinder Network
          grid.display(p, textColor, 100);
        } else if (finderMode == 2) { 
          // Obstacles for custom Pathfinder Network
          boundaries.display(p, textColor, 100);
        }
          else if (finderMode == 3) {
          grid.display(p, textColor, 100);
        }
      }
      
      // Draws pathfinding nodes onto Canvas
      if (showGrid) {
        p.image(pFinderGrid, 0, 0);
      }
      
      // Draws shortest paths for OD nodes
      if (showPaths) {
        p.image(pFinderPaths, 0, 0);
      }
      
      // Show Markers for Sources and Sinks of Angents
      if (showSource) {
        p.image(sources_Viz, 0, 0);
      }
      
      // Show OD Network for Agents
      if (showEdges) {
        p.image(edges_Viz, 0, 0);
      }
    
      // Renders Agent 'dots' and corresponding obstacles and heatmaps
      if (showSwarm && changeClock == 0) {
          swarmHorde.display(p);
      }
      
        swarmHorde.displaySummary(p);
      
      if (showInfo) {
        swarmHorde.displaySwarmList(p);
      }
      
      drawCredit(p);
      
  p.endDraw();
}


void drawCredit(PGraphics p) {
  p.fill(textColor);
  p.textAlign(LEFT);
  p.textSize(12);
  p.text("Pathfinder v1.1", 20, p.height - 40);
  p.text("Ira Winder, MIT Media Lab", 20, p.height - 20);
}


void loading(PGraphics p, String item) {

  p.beginDraw();
  
  int w, h;
  boolean showName;
  
  // Draw Background Rectangle
  p.fill(abs(textColor-25), 200);
  p.stroke(textColor);
  p.strokeWeight(2);
  
  int x, y;
  
  x = p.width/2;
  y = p.height/2;
  
  if (!initialized) {
    p.background(0);
    w = 400;
    h = 50;
    showName = true;
    p.rect(x - w/2 , y - h/2 + 12/2 , w, h , 12, 12, 12, 12);
  } else {
    w = 400;
    h = 25;
    showName = false;
    p.rect(x - w/2 , y - h + 3*12/4 , w, h , 12, 12, 12, 12);
  }
  p.noStroke();
  
  // Text
  p.textAlign(CENTER);
  p.fill(abs(textColor-225), 255);
  p.textSize(12);
  p.text("Loading " + item + "...", x, y);
  if (showName) {
    p.text("Ira Winder, MIT Media Lab", x, y + 20);
  }
  
  p.endDraw();
}

void setScheme() {
  // Adjusts Colors and Transparency 
  masterAlpha = 0;
  schemeScaler = 0.0;
  grayColor = int(abs(background - (255.0/2)*schemeScaler));
}

// Reinitialize any PGraphics that use masterAlpha and schemaScaler
void refreshGraphicScheme(PGraphics p) {
  pFinderGrid_Viz(p);
}

void adjustAlpha(int a) {
   masterAlpha += a;
      if (a > 0) {
     schemeScaler += 0.05;
   } else {
     schemeScaler -= 0.05;
   }
   
   if (masterAlpha < 0) {
     masterAlpha = 0;
   }
   if (masterAlpha > 255) {
     masterAlpha = 255;
   }
   if (schemeScaler < 0) {
     schemeScaler = 0;
   }
   if (schemeScaler > 1) {
     schemeScaler = 1;
   }
}
