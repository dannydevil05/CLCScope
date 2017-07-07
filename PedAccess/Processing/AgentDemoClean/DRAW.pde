boolean showPaths = false;
boolean showGrid = false;
boolean showSource = true;
boolean showEdges = false;
boolean showSwarm = true;
boolean showInfo = false;
boolean showDemoMap = false;

// Makes darker colors more visible when projecting
int masterAlpha = 15;
float schemeScaler = 0.5;
int background = 0;
int textColor = 255;
int grayColor = int(abs(background - (255.0/2)*schemeScaler));

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
 
  
      // Instead of solid background draws a translucent overlay every frame.
      // Provides the effect of giving animated elements "tails"
      p.noStroke();
      p.fill(background, 75);
      p.rect(0,0,p.width,p.height);
      
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
      if (showSwarm) {
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
  p.textSize(24);
  p.text("Pathfinder v1.1", 20, p.height - 60);
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
  masterAlpha = 25;
  schemeScaler = 0.4;
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
